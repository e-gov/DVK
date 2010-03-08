package dvk.client;

import dvk.client.ClientAPI;
import dvk.client.businesslayer.Classifier;
import dvk.client.businesslayer.DhlCapability;
import dvk.client.businesslayer.DhlMessage;
import dvk.client.businesslayer.Occupation;
import dvk.client.businesslayer.Subdivision;
import dvk.client.conf.OrgSettings;
import dvk.client.db.UnitCredential;
import dvk.client.iostructures.GetSendStatusResponseItem;
import dvk.client.iostructures.GetSendingOptionsV3ResponseType;
import dvk.client.iostructures.ReceiveDocumentsResult;
import dvk.core.CommonMethods;
import dvk.core.Fault;
import dvk.core.HeaderVariables;
import dvk.core.Settings;
import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import dvk.client.businesslayer.MessageRecipient;
import java.util.Hashtable;
import org.apache.log4j.Logger;

public class Client {
	static Logger logger = Logger.getLogger(Client.class.getName());
	private static ArrayList<String> tempFiles = new ArrayList<String>();
    private static ClientAPI dvkClient;
    private static ArrayList<OrgSettings> allKnownDatabases;
    private static ArrayList<OrgSettings> currentClientDatabases;
    private static ClientExecType ExecType; // m��rab tegevused, mida programm peab tegema

    public static void main( String[] args )
    {
        if (args.length > 2) {
            ShowHelp();
            return;
        }
        Date startDate = new Date();
        String runningMode = "";
        
        // Vaatame, kas kasutaja on k�ivitamisel ka mingeid argumente ette andnud
        String propertiesFile = "dhlclient.properties";
        for (int i = 0; i < args.length; ++i) {
            if (args[i].startsWith("-prop=") && (args[i].length() > 6)) {
                propertiesFile = args[i].substring(6).replaceAll("\"","");
            } else if (args[i].startsWith("-mode=") && (args[i].length() > 6)) {
                runningMode = args[i].substring(6).replaceAll("\"","");
            }
        }
        
        InitExecType(runningMode);
        System.out.println("\n\nK�ivitamise reziim: " + ExecType);
        
        // Kontrollime seaded �le
        if (!(new File(propertiesFile)).exists()) {
            System.out.println("Application properties file " + propertiesFile + " does not exist!");
            return;
        }
        
        // Laeme rakenduse seaded
        Settings.loadProperties(propertiesFile);
        allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);
        
        // Filtreerime v�lja need andmebaasid, mille andmeid antud klient
        // peab keskserveriga s�nkroniseerima.
        // S.t. filtreerimisel j�etakse v�lja need andmebaasid, mille andmed
        // on konfifailis ainult selleks, et teaks sinna vajadusel otse andmeid kopeerida.
        currentClientDatabases = new ArrayList<OrgSettings>();
        for (OrgSettings db : allKnownDatabases) {
        	if (!db.getDbToDbCommunicationOnly()) {
        		currentClientDatabases.add(db);
        	}
        }
        
        // Kui seadistus on puudulik, l�petab programm t��
        if (currentClientDatabases.isEmpty()){
            System.out.println("DVK kliendi seadistuses pole �htegi andmebaasi!");
            return;
        }
        else{        
            System.out.println("DVK klient alustab andmete uuendamist " + String.valueOf(currentClientDatabases.size()) + " andmebaasis");
        }
        
        dvkClient = new ClientAPI();
        try {
            dvkClient.initClient(Settings.Client_ServiceUrl, Settings.Client_ProducerName);
            dvkClient.setAllKnownDatabases(allKnownDatabases);
        } catch (Exception ex) {
            ex.printStackTrace();
            return;
        }
        
        // Salvestame staatuse klassifikaatorid konfiguratsioonifailist andmebaasi.
        for (OrgSettings db : currentClientDatabases) {
        	Classifier.duplicateSettingsToDB(db);
        }
        
        // SEND
        if (ExecType == ClientExecType.Send || ExecType ==  ClientExecType.SendReceive) {
            for (OrgSettings db : currentClientDatabases) {
            	// Kontrollime kindlasti, et antud andmebaai�hendus ei oleks
            	// m�eldud ainult andmebaaide omavahelise andmevahetuse jaoks.
                dvkClient.setOrgSettings(db.getDvkSettings());
                UnitCredential[] credentials = UnitCredential.getCredentials(db);                                       
                
                for (int i = 0; i < credentials.length; ++i) {
                    try {                                        
                        String secureServer = db.getDvkSettings().getServiceUrl();
                        if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                            secureServer = Settings.Client_ServiceUrl;
                        }                    
                        System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
                        System.out.println("Asutuse turvaserver: " + secureServer);
                        dvkClient.setServiceURL(secureServer);
                        
                        // Saadame DHL poole teele saatmist ootavad dokumendid                        
                        int sentMessages = SendUnsentMessages(credentials[i], db);                        
                        
                        if (sentMessages > 0){
                            // Uuendame saatmisel olevate dokumentide staatust
                            System.out.println("\nUuendan v�lja saadetud s�numite staatusi...");
                            int updatedMessages = UpdateSendStatus(credentials[i], db);
                            System.out.println("V�lja saadetud s�numite ("+ updatedMessages +") staatused uuendatud!");
                        }
                        
                        // Saadame vastuv�etud s�numite staatusemuudatused ja veateated
                        if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                            System.out.println("\nUuendan vastuv��etud s�numite staatusi ja veateateid...");
                            int updatedMessages = UpdateClientStatus(credentials[i], db);
                            System.out.println("Vastuv�etud s�numite ("+updatedMessages+") staatused ja veateated uuendatud!");
                        }
                    }
                    catch (Exception ex) {
                        CommonMethods.logError( ex, "dvk.client.Client", "main" );
                        System.out.println("Viga DVK andmevahetuses (v�ljuvad): " + ex.getMessage());
                    }
                }
            }    
        }

        // RECEIVE
        if (ExecType == ClientExecType.Receive || ExecType == ClientExecType.SendReceive) {
        	
        	logger.info("Client executionMode: " + ExecType);
        	
            // Kui klient vahetab andmeid DVK versiooniga, mis on varasem, kui 1.5, siis ei saa
            // serverist k�sida, millistel asutustel on allalaadimata dokumente.
            if (CommonMethods.compareVersions(Settings.Client_SpecificationVersion,"1.5") < 0) {
                for (OrgSettings db : currentClientDatabases) {
                	// Kontrollime kindlasti, et antud andmebaai�hendus ei oleks
                	// m�eldud ainult andmebaaide omavahelise andmevahetuse jaoks.
                    dvkClient.setOrgSettings(db.getDvkSettings());
                    UnitCredential[] credentials = UnitCredential.getCredentials(db);
                    
                    for (int i = 0; i < credentials.length; ++i) {
                        try { 
                            String secureServer = db.getDvkSettings().getServiceUrl();
                            if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                                secureServer = Settings.Client_ServiceUrl;
                            }                    
                            System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
                            System.out.println("Asutuse turvaserver: " + secureServer);
                            dvkClient.setServiceURL(secureServer);
                            
                            // K�sime DHL-st meile saadetud dokumendid
                            System.out.println("\nV�tan vastu saabuvaid s�numeid...");
                            //// K�sime DHL-st meile saadetud dokumendid
                            ReceiveNewMessages(credentials[i], db);                            
                            System.out.println("Saabuvad s�numid vastu v�etud!");
                            
                            // Saadame vastuv�etud s�numite staatusemuudatused ja veateated
                            if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                                System.out.println("\nUuendan vastuv�etud s�numite staatusi ja veateateid...");
                                int updatedMessages = UpdateClientStatus(credentials[i], db);
                                System.out.println("Vastuv�etud s�numite ("+updatedMessages+") staatused ja veateated uuendatud!");
                            }
                            
                            // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
                            System.out.println("\nUuendan v�lja saadetud s�numite staatusi...");                                
                            int updatedMessages = UpdateSendStatus(credentials[i], db);
                            System.out.println("V�lja saadetud s�numite ("+updatedMessages+") staatused uuendatud!");
                        }
                        catch (Exception ex) {
                            CommonMethods.logError( ex, "dvk.client.Client", "main" );
                            System.out.println("Viga DVK andmevahetuses (saabuvad): " + ex.getMessage());
                        }                        
                    }
                }
            } else {
            	
            	logger.debug("Laeme asutuste nimekrija, kellel on alla laadimist ootavaid dokumente.");
            	
                // Laeme asutuste nimekrija, kellel on alla laadimist ootavaid dokumente
            	try {
	            	GetSendingOptionsV3ResponseType waitingInstitutions = ReceiveDownloadWaitingInstitutionsV2(currentClientDatabases);
	                //ArrayList<String> waitingInstitutions = ReceiveDownloadWaitingInstitutions(currentClientDatabases);                         
	                if ((waitingInstitutions != null) && (!waitingInstitutions.asutused.isEmpty())) {
	                	logger.debug("Asutuste nimekiri käes. Alustame töötlemist.");
	                    for (OrgSettings db : currentClientDatabases) {
	                        dvkClient.setOrgSettings(db.getDvkSettings());
	                        UnitCredential[] credentials = UnitCredential.getCredentials(db);
	                        
	                        for (int i = 0; i < credentials.length; ++i) {
	                            try { 
	                            	boolean found = false;
	                            	String logMessage = "";
	                            	
	                            	// Kas asutusel on allalaadimata dokumente ootel
                                	for (DhlCapability org : waitingInstitutions.asutused) {
                                		if (CommonMethods.stringsEqualIgnoreNull(org.getOrgCode(), credentials[i].getInstitutionCode())) {
                                			found = true;
                                			break;
                                		}
                                	}
	                            	if (found) {
	                            		logMessage = "Asutusel \""+ credentials[i].getInstitutionCode() +"\" on dokumente ootel";
	                            	} else {
	                            		logMessage = "Asutusel \""+ credentials[i].getInstitutionCode() +"\" ei ole dokumente ootel";
	                            	}
	                            	
	                                if (found && (waitingInstitutions.allyksused != null) && (credentials[i].getDivisionShortName() != null) && (credentials[i].getDivisionShortName().length() > 0)) {
	                                	boolean subdivisionFound = false;
	                                	for (Subdivision sub : waitingInstitutions.allyksused) {
	                                		if (CommonMethods.stringsEqualIgnoreNull(sub.getOrgCode(), credentials[i].getInstitutionCode())
	                                			&& CommonMethods.stringsEqualIgnoreNull(sub.getShortName(), credentials[i].getDivisionShortName())) {
	                                			subdivisionFound = true;
	                                			break;
	                                		}
	                                	}
	                                	found = subdivisionFound;
	                                	if (found) {
		                            		logMessage += " ja all�ksusel \""+ credentials[i].getDivisionShortName() +"\" on dokumente ootel";
		                            	} else {
		                            		logMessage += ", aga all�ksusel \""+ credentials[i].getDivisionShortName() +"\" ei ole dokumente ootel";
		                            	}
	                                }
	                                
	                                if (found && (waitingInstitutions.ametikohad != null) && (credentials[i].getOccupationShortName() != null) && (credentials[i].getOccupationShortName().length() > 0)) {
	                                	boolean occupationFound = false;
	                                	for (Occupation oc : waitingInstitutions.ametikohad) {
	                                		if (CommonMethods.stringsEqualIgnoreNull(oc.getOrgCode(), credentials[i].getInstitutionCode())
	                                			&& CommonMethods.stringsEqualIgnoreNull(oc.getShortName(), credentials[i].getOccupationShortName())) {
	                                			occupationFound = true;
	                                			break;
	                                		}
	                                	}
	                                	found = occupationFound;
	                                	if (found) {
		                            		logMessage += " ja ametikohal \""+ credentials[i].getOccupationShortName() +"\" on dokumente ootel";
		                            	} else {
		                            		logMessage += ", aga ametikohal \""+ credentials[i].getOccupationShortName() +"\" ei ole dokumente ootel";
		                            	}
	                                }
	                            	logger.debug(logMessage);
	                            	
	                            	// Kui on dokumente alla laadimiseks ootel, siis teeme p�ringu vastasel korral mitte
	                            	if (found){
	                                    String secureServer = db.getDvkSettings().getServiceUrl();
	                                    if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
	                                        secureServer = Settings.Client_ServiceUrl;
	                                    }                    
	                                    System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
	                                    System.out.println("Asutuse turvaserver: " + secureServer);
	                                    dvkClient.setServiceURL(secureServer);
	                                    
	                                    // K�sime DHL-st meile saadetud dokumendid
	                                    System.out.println("\nV�tan vastu saabuvaid s�numeid...");
	                                    System.out.println("\nS�numite alla laadimist ootavate asutuste arv: "+ waitingInstitutions.asutused.size());
	                                    //// K�sime DHL-st meile saadetud dokumendid
	                                    ReceiveNewMessages(credentials[i], db);                            
	                                    System.out.println("Saabuvad s�numid vastu v�etud!");
	                                    
	                                    // Saadame vastuv�etud s�numite staatusemuudatused ja veateated
	                                    if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
	                                        System.out.println("\nUuendan vastuv�etud s�numite staatusi ja veateateid...");
	                                        int updatedMessages = UpdateClientStatus(credentials[i], db);
	                                        System.out.println("Vastuv�etud s�numite ("+updatedMessages+") staatused ja veateated uuendatud!");
	                                    }
	                                    
	                                    // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
	                                    System.out.println("\nUuendan v�lja saadetud s�numite staatusi...");                                
	                                    int updatedMessages = UpdateSendStatus(credentials[i], db);
	                                    System.out.println("V�lja saadetud s�numite ("+updatedMessages+") staatused uuendatud!");
	                                }
	                            }
	                            catch (Exception ex) {
	                                CommonMethods.logError( ex, "dvk.client.Client", "main" );
	                                System.out.println("Viga DVK andmevahetuses (saabuvad): " + ex.getMessage());
	                            }                        
	                        }
	                    }
	                } else {
	                	logger.info("Saabuvaid sõnumeid ei leitud");
	                }
            	} catch (Exception ex) {
            		logger.info("Dokumentide vastuv�tmisel tekkis viga - " + ex.getMessage());
            		logger.error(ex);
            	}
            }
        }

        // UPDATE STATUS
        if (ExecType == ClientExecType.UpdateStatus || ExecType == ClientExecType.SendReceive) {
            for (OrgSettings db : currentClientDatabases) {
            	// Kontrollime kindlasti, et antud andmebaai�hendus ei oleks
            	// m�eldud ainult andmebaaide omavahelise andmevahetuse jaoks.
                dvkClient.setOrgSettings(db.getDvkSettings());
                UnitCredential[] credentials = UnitCredential.getCredentials(db);
                for (int i = 0; i < credentials.length; ++i) {
                    try {
                        // Kui on dokumente alla laadimiseks ootel, siis teeme p�ringu vastasel korral mitte
                        String secureServer = db.getDvkSettings().getServiceUrl();
                        if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                            secureServer = Settings.Client_ServiceUrl;
                        }
                        System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
                        System.out.println("Asutuse turvaserver: " + secureServer);
                        dvkClient.setServiceURL(secureServer);
                        
                        // Saadame vastuv�etud s�numite staatusemuudatused ja veateated
                        if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                            System.out.println("\nUuendan vastuv�etud s�numite staatusi ja veateateid...");
                            int updatedMessages = UpdateClientStatus(credentials[i], db);
                            System.out.println("Vastuv�etud s�numite ("+updatedMessages+") staatused ja veateated uuendatud!");
                        }
                        
                        // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
                        System.out.println("\nUuendan s�numite staatusi...");
                        int updatedMessages = UpdateSendStatus(credentials[i], db);
                        System.out.println("S�numite ("+ updatedMessages +") staatused uuendatud!");
                    }
                    catch (Exception ex) {
                        CommonMethods.logError( ex, "dvk.client.Client", "main" );
                        System.out.println("Viga DVK andmevahetuses (staatuse uuendamine): " + ex.getMessage());
                    }   
                }
            }
        }
        
        // Kustutame ajutised failid
        if (!tempFiles.isEmpty()) {
            System.out.println("\n\nKustutan loodud ajutised failid...");
            String fileName;
            File f;
            for (int i = 0; i < tempFiles.size(); ++i) {
                try {
                    fileName = tempFiles.get(i);
                    f = new File( fileName );
                    f.delete();
                } catch (Exception ex) {}
            }
            System.out.println("Ajutised failid kustutatud!");
        }
        
        Date endDate = new Date();
        System.out.println("\n\nDVK klient l�petab t��.");
        System.out.println("Andmete uuendamiseks kulus "+ String.valueOf( (double)(endDate.getTime()-startDate.getTime())/1000f ) +" sekundit.");
    }
    
    // Kuvab juhised programmi k�ivitamiseks. Valede parameetrite korral kuvatakse alati juhised
    private static void InitExecType(String runningMode){    
        int mode = 0;
        // vaikimisi tehakse nii alla laadimine kui ka saatmine
        ExecType = ClientExecType.SendReceive;
        if ((runningMode != null) && (runningMode.length() > 0)){
            try{
                mode = Integer.parseInt(runningMode);
                switch (mode) {
                    case 1: ExecType = ClientExecType.Send;
                            break;
                    case 2: ExecType = ClientExecType.Receive;
                            break;
                    case 3: ExecType = ClientExecType.SendReceive;
                            break;
                    case 4: ExecType = ClientExecType.UpdateStatus;
                            break;
                    default: 
                            ExecType = ClientExecType.SendReceive;
                            break;
                }
            }catch (Exception ex){
                ExecType = ClientExecType.SendReceive;
            }
        }        
    }

    private static void ShowHelp() {
        System.out.println("Programmi k�ivitamise parameetrid:");
        System.out.println("  -mode=X");
        System.out.println("    Parameetri v�imalikud v��rtused:");
        System.out.println("    1 - ootel dokumentide v�lja saatmine");
        System.out.println("    2 - saatmisel olevate dokumentide alla laadimine (sissetulevad)");
        System.out.println("    3 - nii saatmine kui ka vastuv�tmine (1 ja 2)");
        System.out.println("    4 - ainult staatuste uuendamine");
        System.out.println("");
        System.out.println("    N�iteks: java dvk.client.Client -mode=3");
        System.out.println("");
        System.out.println("");
        System.out.println("  -prop=X");
        System.out.println("    Kliendi seadete faili dvk_client.properties asukoha etteandmine");
        System.out.println("");
        System.out.println("    N�iteks: java dvk.client.Client -prop=\"C:\\dvk\\dvk_client.properties\"");
        System.out.println("");
        System.out.println("");
        System.out.println("Parameetrite puudumisel teostatakse k�ik toimingud");
    }

    private static int UpdateSendStatus(UnitCredential masterCredential, OrgSettings db) {
        int resultCounter = 0;
        try {
            ArrayList<DhlMessage> messages = DhlMessage.getList( false, Settings.Client_StatusSending, masterCredential.getUnitID(), false, true, db );
            ArrayList<DhlMessage> messages2 = DhlMessage.getList( false, 0, masterCredential.getUnitID(), true, true, db );
            
            messages.addAll(messages2);
            
            messages2 = null;
            System.out.println("    Saatmisel olevaid sõnumeid: " + String.valueOf(messages.size()));
            if (!messages.isEmpty()) {
                HeaderVariables header = new HeaderVariables(
                    masterCredential.getInstitutionCode(),
                    masterCredential.getPersonalIdCode(),
                    "",
                    (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode()));
                
                // Jaotame dokumendid gruppidesse, et staatust k�sitaks sellest
                // serverist, kuhu dokument saadeti
                ArrayList<String> keys = new ArrayList<String>();
                Hashtable<String,ArrayList<DhlMessage>> addressTable = new Hashtable<String,ArrayList<DhlMessage>>();
                for (int i = 0; i < messages.size(); ++i) {
                    DhlMessage msg = messages.get(i);
                    ArrayList<MessageRecipient> recipients = MessageRecipient.getList(msg.getId(), db);
                    for (int j = 0; j < recipients.size(); ++j) {
                        MessageRecipient recipient = recipients.get(j);
                        String currentKey = "";
                        if (recipient.getProducerName() != null) {
                            currentKey += recipient.getProducerName().trim();
                        }
                        currentKey += "|";
                        if (recipient.getServiceURL() != null) {
                            currentKey += recipient.getServiceURL().trim();
                        }
                        ArrayList<DhlMessage> dhlIDs = null;
                        if (!keys.contains(currentKey)) {
                            keys.add(currentKey);
                            dhlIDs = new ArrayList<DhlMessage>();
                        } else {
                            dhlIDs = addressTable.get(currentKey);
                        }
                        dhlIDs.add(msg);
                        addressTable.put(currentKey, dhlIDs);
                    }
                }
                
                for (int i = 0; i < keys.size(); ++i) {
                    String currentKey = keys.get(i);
                    ArrayList<DhlMessage> dhlIDs = addressTable.get(currentKey);
                    String producerName = "";
                    String serviceURL = "";
                    String realProducerName = "";
                    String realServiceURL = "";
                    if (currentKey.equalsIgnoreCase("|")) {
                        producerName = "";
                        serviceURL = "";
                        realProducerName = Settings.Client_ProducerName;
                        realServiceURL = Settings.Client_ServiceUrl;
                    } else {
                        String[] address = currentKey.split("[|]");
                        if (address.length == 2) {
                            producerName = address[0];
                            serviceURL = address[1];
                            realProducerName = producerName;
                            realServiceURL = serviceURL;
                        } else {
                            throw new Exception("Viga s�numi aadresaandmete t��tlemisel!");
                        }
                    }
                    dvkClient.initClient(realServiceURL, realProducerName);
                    System.out.println("    Suhtlen DVK serveriga...");
                    ArrayList<GetSendStatusResponseItem> result = dvkClient.getSendStatus(header, dhlIDs, true);
                    System.out.println("    T��tlen DVKst saadud vastust...");
                    
                    // Teeme vastuss�numi andmetest omad j�reldused
                    UpdateStatusChangesInDB(result, producerName, serviceURL, db);
                }
                resultCounter = messages.size();
            }
            messages = null;
        }
        catch (Exception ex) {
            CommonMethods.logError( ex, "dvk.client.Client", "UpdateSendStatus" );
            System.out.println("    Staatuste uuendamisel tekkis viga: " + ex.getMessage());
        }
        
        // Taastame seadistuse, et klient oleks vaikimisi seadistatud p�ringuid saatma konfiguratsioonifailis
        // m��ratud aadressi ja andmekogu nimega.
        try {
            dvkClient.initClient(Settings.Client_ServiceUrl, Settings.Client_ProducerName);
        } catch (Exception ex) {
            CommonMethods.logError( ex, "dvk.client.Client", "UpdateSendStatus" );
        }
        
        return resultCounter;
    }
    
    private static void UpdateStatusChangesInDB(ArrayList<GetSendStatusResponseItem> statusMessgaes, String producerName, String serviceURL, OrgSettings db) {
        if ((statusMessgaes == null) || (statusMessgaes.size() < 1)) {
            return;
        }
        
        for (int i = 0; i < statusMessgaes.size(); ++i) {
            GetSendStatusResponseItem item = statusMessgaes.get(i);
            logger.debug("Updating status.");
            logger.debug("DHL_ID: " + item.getDhlID());
            logger.debug("GUID: " + item.getGuid());
            int messageID = DhlMessage.getMessageID(item.getDhlID(), producerName, serviceURL, false, db);
            logger.debug("messageID: " + messageID);
            DhlMessage.updateStatus(messageID, item, db);
        }
    }
    
    private static int UpdateClientStatus(UnitCredential masterCredential, OrgSettings db) {
        int resultCounter = 0;
        try {
            ArrayList<DhlMessage> messages = DhlMessage.getList( true, Settings.Client_StatusReceived, masterCredential.getUnitID(), true, true, db );
            System.out.println("    Staatuse uuendamist vajavaid s�numeid: " + String.valueOf(messages.size()));
            if ((messages != null) && !messages.isEmpty()) {
                MarkDocumentsReceived(messages, masterCredential, "", db);
                resultCounter = messages.size();
                DhlMessage tmp = null;
                for (int i = 0; i < messages.size(); ++i) {
                    tmp = messages.get(i);
                    tmp.setStatusUpdateNeeded( false );
                    tmp.updateStatusUpdateNeed( db );
                }
            }
        }
        catch (Exception ex) {
            CommonMethods.logError( ex, "dvk.client.Client", "UpdateClientStatus" );
            System.out.println("    Staatuste uuendamisel tekkis viga: " + ex.getMessage());
        }    
        return resultCounter;
    }

    private static int SendUnsentMessages(UnitCredential masterCredential, OrgSettings db)
    {
        int resultCounter = 0;
        try {
            // T��tleme andmebaasis olevad saatmist ootavad s�numid �le, et XML konteineris
            // olev adressaatide nimekiri oleks kindlasti ka adressaatide tabelisse dubleeritud.
            DhlMessage.prepareUnsentMessages(masterCredential.getUnitID(), db);
            
            ArrayList<DhlMessage> messages = DhlMessage.getList(false, Settings.Client_StatusWaiting, masterCredential.getUnitID(), false, false, db);
            if (messages.size() == 0){
                System.out.println("Saatmist ootavaid s�numeid ei leitud!");
                return resultCounter;
            }
            else{            
                System.out.println("\nSaadan v�ljuvaid s�numeid...");                
                System.out.println("    Saatmist ootavaid s�numeid: " + String.valueOf(messages.size()));
            }            
            
            HeaderVariables header = new HeaderVariables(
                masterCredential.getInstitutionCode(),
                masterCredential.getPersonalIdCode(),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode())); 
            
            resultCounter = messages.size();
            for (int i = 0; i < messages.size(); ++i) {
                DhlMessage msg = messages.get(i);
                
                // Kui dokumendi GUID ei ole m��ratud, siis genereerime selle.
                if(msg.getDhlGuid() == null || msg.getDhlGuid().trim().equalsIgnoreCase("")) {
                	msg.setDhlGuid(DhlMessage.generateGUID());
                }
                
                try {
	                ArrayList<DhlMessage> messageClones = msg.splitMessageByDeliveryChannel(db, allKnownDatabases, masterCredential.getContainerVersion());
	                logger.info("Document " + String.valueOf(msg.getId()) + " (GUID:"+ msg.getDhlGuid() +") will be sent through " + String.valueOf(messageClones.size()) + " channels.");
	                int centralServerId = 0;
	                for (int k = 0; k < messageClones.size(); k++) {
	                	DhlMessage currentClone = messageClones.get(k);
	                	int result = 0;
	                	if (currentClone.getDeliveryChannel().getDatabase() != null) {
	                		// S�num on m�eldud �hest andmebaasist teise edastamiseks
	                		if (centralServerId > 0) {
	                			currentClone.setDhlID(centralServerId);
	                		} else if (result > 0) {
	                			currentClone.setDhlID(result);
	                		}
	                		dvkClient.sendDocumentFromDbToDb(currentClone, db);
	                	} else {
	                		// S�num on m�eldud SOAP kujul edastamiseks
	                		String serviceUrl = currentClone.getDeliveryChannel().getServiceUrl();
	                		String producerName = currentClone.getDeliveryChannel().getProducerName();
	                		
	                		logger.info("Sending document " + String.valueOf(msg.getId()) + " (GUID:"+ msg.getDhlGuid() +") to server " + serviceUrl + " (" + producerName + ")");
	                		dvkClient.initClient(serviceUrl, producerName);
	                		
	                        result = dvkClient.sendDocuments(header, currentClone);
	                        if ((centralServerId == 0) && producerName.equalsIgnoreCase(Settings.Client_ProducerName)) {
	                        	centralServerId = result;
	                        }
	                        currentClone.setQueryID(dvkClient.getQueryId()); // paneme p�ringu ID s�numile k�lge
	                        
	                        for (int a = 0; a < currentClone.getRecipients().size(); a++) {
	                        	MessageRecipient rec = currentClone.getRecipients().get(a);
	                        	rec.setDhlId(result);
	                        	rec.setSendingStatusID(Settings.Client_StatusSending);
	                        	rec.setSendingDate(new Date());
	                        	rec.saveToDB(db);
	                        	
	        		    		String recipientShortId = rec.getRecipientOrgCode() + "|" + rec.getRecipientPersonCode() + "|" + rec.getRecipientDivisionCode() + "|" + rec.getRecipientPositionCode() + "|" + String.valueOf(rec.getRecipientDivisionID()) + "|" + String.valueOf(rec.getRecipientPositionID());
	                  			logger.info("Document "+ String.valueOf(currentClone.getId()) +" was sent to server "+ serviceUrl + " (" + producerName + ")" +" for recipient " + recipientShortId);
	                        }
	                	}
	                	
                        // Ainult esimese serveri puhul uuendame DHL_ID v��rtus s�numi p�hitabelis
                        if (k == 0){
                            UpdateDhlID(currentClone, db, result);
                        }
	                }
	                
	                // M�rgime saatja andmebaasis, et s�num on saatmisel
	                DhlMessage.calculateAndUpdateMessageStatus(msg.getId(), db);
	                //DhlMessage.updateStatus(msg.getId(), Settings.Client_StatusSending, false, db);
	                
                } catch (Exception ex1) {
                    CommonMethods.logError(ex1, "dvk.client.Client", "SendUnsentMessages");
                    System.out.println("    S�numite saatmisel tekkis viga: " + ex1.getMessage());
                    if (msg != null) {
                        try {
                            //msg.setFilePath(originalFilePath);
                            msg.setFaultActor("local");
                            msg.setFaultString(ex1.getMessage());
                            msg.setQueryID(dvkClient.getQueryId());  // paneme s�numile k�lge p�ringu ID
                            msg.updateInDB(db);
                        } catch (Exception ex2) {
                            CommonMethods.logError(ex2, "dvk.client.Client", "SendUnsentMessages");
                            System.out.println("    S�numite saatmisel tekkis viga: " + ex2.getMessage());
                        }
                    }
                }
            }
            System.out.println("V�ljuvad s�numid saadetud!");          
            
        } catch (Exception ex) {
            CommonMethods.logError( ex, "dvk.client.Client", "SendUnsentMessages" );
            System.out.println("    S�numite saatmisel tekkis viga: " + ex.getMessage());
        }  
        return resultCounter;
    }
    
    // Harutab lahti sendDocuments p�ringu vastuseks saadud XML-i ja uuendab
    // vastavalt XML-i sisule andmebaasis olevate dokumentide andmeid.
    private static void UpdateDhlID(DhlMessage message, OrgSettings db, int dhlID) throws Exception {
    	logger.debug("Updating DHL ID.");
        if (dhlID > 0) {
            message.setDhlID( dhlID );
            message.updateDhlID( db );
            boolean statusUpdateNeeded = (Settings.Client_SentMessageStatusFollowupDays > 0);
            DhlMessage.updateStatus(message.getId(), Settings.Client_StatusSending, null, statusUpdateNeeded, db);
        }
    }
    
    private static void ReceiveNewMessages(UnitCredential masterCredential, OrgSettings db) {
    	logger.info("Receiving new messages.");
    	
        try {
            // Saadetava s�numi p�isesse kantavad parameetrid
            HeaderVariables header = new HeaderVariables(
                masterCredential.getInstitutionCode(),
                masterCredential.getPersonalIdCode(),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode()));
            
            ReceiveDocumentsResult resultFiles = dvkClient.receiveDocuments(header, 10, masterCredential.getFolders(), masterCredential.getDivisionID(), masterCredential.getDivisionShortName(), masterCredential.getOccupationID(), masterCredential.getOccupationShortName());
            ArrayList<DhlMessage> receivedDocs = new ArrayList<DhlMessage>();
            ArrayList<DhlMessage> failedDocs = new ArrayList<DhlMessage>();
                        
            System.out.println("    Saadud "+ String.valueOf(resultFiles.documents.size()) +" dokumenti.");
            for (int i = 0; i < resultFiles.documents.size(); ++i) {
                DhlMessage message = new DhlMessage(resultFiles.documents.get(i), masterCredential);
                message.setIsIncoming( true );
                message.setSendingStatusID( Settings.Client_StatusReceived );
                message.setUnitID( masterCredential.getUnitID() );
                message.setReceivedDate( new Date() );
                message.setRecipientStatusID( db.getDvkSettings().getDefaultStatusID() );
                message.setQueryID(dvkClient.getQueryId()); // paneme X-tee p�ringu ID s�numile k�lge
                
                try {
	                if (message.addToDB(db) > 0) {
	                    receivedDocs.add(message);
	                } else {
	                    failedDocs.add(message);
	                }
                } catch (Exception ex) {
                	logger.error(ex);
                	failedDocs.add(message);
                }
            }
                
            // M�rgime edukalt vastuv�etud dokumendid vastuv�etuks.
            if (receivedDocs.size() > 0) {
            	logger.info("Annan dokumendivahetuskeskusele teada, et sain dokumendid k�tte...");
                MarkDocumentsReceived(receivedDocs, masterCredential, db.getDvkSettings().getDefaultStatusID(), null, "", resultFiles.deliverySessionID, db);
            }
                
            // Teavitame dokumendivahetuskeskust dokumentidest, mille
            // vastuv�tmine eba�nnestus.
            if ((failedDocs.size() > 0) && (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1)) {
            	logger.info("Teavitame dokumendivahetuskeskust dokumentidest, mille vastuv�tmine eba�nnestus.");
                Fault clientFault = new Fault();
                clientFault.setFaultString("Error occured while saving document to database!");
                MarkDocumentsReceived(failedDocs, masterCredential, 0, clientFault, "", resultFiles.deliverySessionID, db);
            }    
        } catch (Exception ex) {
        	logger.error(ex);
            System.out.println("    Dokumentide vastuv�tmisel tekkis viga: " + ex.getMessage());
        }    
    }
    
    private static void MarkDocumentsReceived(
        ArrayList<DhlMessage> documents,
        UnitCredential masterCredential,
        int statusID,
        Fault clientFault,
        String metaXML,
        String deliverySessionID,
        OrgSettings db)
    {
        try {
            // Saadetava s�numi p�isesse kantavad parameetrid
            HeaderVariables header = new HeaderVariables(
                masterCredential.getInstitutionCode(),
                masterCredential.getPersonalIdCode(),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode()));
            
            // K�ivitame p�ringu
            dvkClient.markDocumentsReceived(header, documents, statusID, clientFault, metaXML, deliverySessionID, false, db, masterCredential);
        }
        catch (Exception ex) {
            CommonMethods.logError( ex, "dvk.client.Client", "MarkDocumentsReceived" );
            System.out.println("    Dokumentide staatuste uuendamisel tekkis viga: " + ex.getMessage());
            return;
        }
    }

    private static void MarkDocumentsReceived(ArrayList<DhlMessage> documents, UnitCredential masterCredential, String deliverySessionID, OrgSettings db) throws Exception {
        // Saadetava s�numi p�isesse kantavad parameetrid
        HeaderVariables header = new HeaderVariables(
            masterCredential.getInstitutionCode(),
            masterCredential.getPersonalIdCode(),
            "",
            (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode()));
        
        // K�ivitame p�ringu
        dvkClient.markDocumentsReceived(header, documents, deliverySessionID, db, masterCredential);
    }
        
    private static ArrayList<String> ReceiveDownloadWaitingInstitutions(ArrayList<OrgSettings> databases){    	
        // k�sime nimekirja asutustest, kus on alla laadimist ootavaid dokumente
        ArrayList<String> waitingInstitutions = new ArrayList<String>();
        try {
            // Saadetava s�numi p�isesse kantavad parameetrid
            HeaderVariables headerVar = new HeaderVariables(
                Settings.Client_DefaultOrganizationCode,
                Settings.Client_DefaultPersonCode,
                "",
                (CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode) ? Settings.Client_DefaultPersonCode : "EE"+Settings.Client_DefaultPersonCode));
            
            // K�ivitame p�ringu
            logger.debug("Käivitame päringu parameetritega:");
            logger.debug("OrganizationCode: " + headerVar.getOrganizationCode());
            logger.debug("PersonalIDCode: " + headerVar.getPersonalIDCode());
            logger.debug("PIDWithCountryCode: " + headerVar.getPIDWithCountryCode());
            logger.debug("CaseName: " + headerVar.getCaseName());         
            
            waitingInstitutions = dvkClient.receiveDownloadWaitingOrgs(headerVar, databases);
        }
        catch (Exception ex) {
        	logger.error("Viga alla laadimata s�numeid omavate asutuste loetelu koostamisel: ", ex);
            CommonMethods.logError( ex, "dvk.client.Client", "ReceiveDownloadWaitingInstitutions" );
        }        
        return waitingInstitutions;
    }
    
    private static GetSendingOptionsV3ResponseType ReceiveDownloadWaitingInstitutionsV2(ArrayList<OrgSettings> databases) throws Exception {    	
    	// Saadetava s�numi p�isesse kantavad parameetrid
        HeaderVariables headerVar = new HeaderVariables(
            Settings.Client_DefaultOrganizationCode,
            Settings.Client_DefaultPersonCode,
            "",
            (CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode) ? Settings.Client_DefaultPersonCode : "EE"+Settings.Client_DefaultPersonCode));
        
        // K�ivitame p�ringu
        logger.debug("K�ivitame p�ringu parameetritega:");
        logger.debug("OrganizationCode: " + headerVar.getOrganizationCode());
        logger.debug("PersonalIDCode: " + headerVar.getPersonalIDCode());
        logger.debug("PIDWithCountryCode: " + headerVar.getPIDWithCountryCode());
        logger.debug("CaseName: " + headerVar.getCaseName());         
        
        return dvkClient.receiveDownloadWaitingOrgsV2(headerVar, databases);
    }
    
}
