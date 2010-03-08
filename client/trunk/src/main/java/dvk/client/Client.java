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
    private static ClientExecType ExecType; // mï¿½ï¿½rab tegevused, mida programm peab tegema

    public static void main( String[] args )
    {
        if (args.length > 2) {
            ShowHelp();
            return;
        }
        Date startDate = new Date();
        String runningMode = "";
        
        // Vaatame, kas kasutaja on kï¿½ivitamisel ka mingeid argumente ette andnud
        String propertiesFile = "dhlclient.properties";
        for (int i = 0; i < args.length; ++i) {
            if (args[i].startsWith("-prop=") && (args[i].length() > 6)) {
                propertiesFile = args[i].substring(6).replaceAll("\"","");
            } else if (args[i].startsWith("-mode=") && (args[i].length() > 6)) {
                runningMode = args[i].substring(6).replaceAll("\"","");
            }
        }
        
        InitExecType(runningMode);
        System.out.println("\n\nKï¿½ivitamise reziim: " + ExecType);
        
        // Kontrollime seaded ï¿½le
        if (!(new File(propertiesFile)).exists()) {
            System.out.println("Application properties file " + propertiesFile + " does not exist!");
            return;
        }
        
        // Laeme rakenduse seaded
        Settings.loadProperties(propertiesFile);
        allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);
        
        // Filtreerime vï¿½lja need andmebaasid, mille andmeid antud klient
        // peab keskserveriga sï¿½nkroniseerima.
        // S.t. filtreerimisel jï¿½etakse vï¿½lja need andmebaasid, mille andmed
        // on konfifailis ainult selleks, et teaks sinna vajadusel otse andmeid kopeerida.
        currentClientDatabases = new ArrayList<OrgSettings>();
        for (OrgSettings db : allKnownDatabases) {
        	if (!db.getDbToDbCommunicationOnly()) {
        		currentClientDatabases.add(db);
        	}
        }
        
        // Kui seadistus on puudulik, lï¿½petab programm tï¿½ï¿½
        if (currentClientDatabases.isEmpty()){
            System.out.println("DVK kliendi seadistuses pole ï¿½htegi andmebaasi!");
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
            	// Kontrollime kindlasti, et antud andmebaaiï¿½hendus ei oleks
            	// mï¿½eldud ainult andmebaaide omavahelise andmevahetuse jaoks.
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
                            System.out.println("\nUuendan välja saadetud sõnumite staatusi...");
                            int updatedMessages = UpdateSendStatus(credentials[i], db);
                            System.out.println("Välja saadetud sõnumite ("+ updatedMessages +") staatused uuendatud!");
                        }
                        
                        // Saadame vastuvï¿½etud sï¿½numite staatusemuudatused ja veateated
                        if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                            System.out.println("\nUuendan vastuvõ½etud sõnumite staatusi ja veateateid...");
                            int updatedMessages = UpdateClientStatus(credentials[i], db);
                            System.out.println("Vastuvõetud sõnumite ("+updatedMessages+") staatused ja veateated uuendatud!");
                        }
                    }
                    catch (Exception ex) {
                        CommonMethods.logError( ex, "dvk.client.Client", "main" );
                        System.out.println("Viga DVK andmevahetuses (väljuvad): " + ex.getMessage());
                    }
                }
            }    
        }

        // RECEIVE
        if (ExecType == ClientExecType.Receive || ExecType == ClientExecType.SendReceive) {
        	
        	logger.info("Client executionMode: " + ExecType);
        	
            // Kui klient vahetab andmeid DVK versiooniga, mis on varasem, kui 1.5, siis ei saa
            // serverist kï¿½sida, millistel asutustel on allalaadimata dokumente.
            if (CommonMethods.compareVersions(Settings.Client_SpecificationVersion,"1.5") < 0) {
                for (OrgSettings db : currentClientDatabases) {
                	// Kontrollime kindlasti, et antud andmebaaiï¿½hendus ei oleks
                	// mï¿½eldud ainult andmebaaide omavahelise andmevahetuse jaoks.
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
                            
                            // Kï¿½sime DHL-st meile saadetud dokumendid
                            System.out.println("\nVï¿½tan vastu saabuvaid sï¿½numeid...");
                            //// Kï¿½sime DHL-st meile saadetud dokumendid
                            ReceiveNewMessages(credentials[i], db);                            
                            System.out.println("Saabuvad sï¿½numid vastu vï¿½etud!");
                            
                            // Saadame vastuvï¿½etud sï¿½numite staatusemuudatused ja veateated
                            if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                                System.out.println("\nUuendan vastuvï¿½etud sï¿½numite staatusi ja veateateid...");
                                int updatedMessages = UpdateClientStatus(credentials[i], db);
                                System.out.println("Vastuvï¿½etud sï¿½numite ("+updatedMessages+") staatused ja veateated uuendatud!");
                            }
                            
                            // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
                            System.out.println("\nUuendan vï¿½lja saadetud sï¿½numite staatusi...");                                
                            int updatedMessages = UpdateSendStatus(credentials[i], db);
                            System.out.println("Vï¿½lja saadetud sï¿½numite ("+updatedMessages+") staatused uuendatud!");
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
	                	logger.debug("Asutuste nimekiri kÃ¤es. Alustame tÃ¶Ã¶tlemist.");
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
		                            		logMessage += " ja allüksusel \""+ credentials[i].getDivisionShortName() +"\" on dokumente ootel";
		                            	} else {
		                            		logMessage += ", aga allüksusel \""+ credentials[i].getDivisionShortName() +"\" ei ole dokumente ootel";
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
	                            	
	                            	// Kui on dokumente alla laadimiseks ootel, siis teeme pï¿½ringu vastasel korral mitte
	                            	if (found){
	                                    String secureServer = db.getDvkSettings().getServiceUrl();
	                                    if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
	                                        secureServer = Settings.Client_ServiceUrl;
	                                    }                    
	                                    System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
	                                    System.out.println("Asutuse turvaserver: " + secureServer);
	                                    dvkClient.setServiceURL(secureServer);
	                                    
	                                    // Kï¿½sime DHL-st meile saadetud dokumendid
	                                    System.out.println("\nVï¿½tan vastu saabuvaid sï¿½numeid...");
	                                    System.out.println("\nSï¿½numite alla laadimist ootavate asutuste arv: "+ waitingInstitutions.asutused.size());
	                                    //// Kï¿½sime DHL-st meile saadetud dokumendid
	                                    ReceiveNewMessages(credentials[i], db);                            
	                                    System.out.println("Saabuvad sï¿½numid vastu vï¿½etud!");
	                                    
	                                    // Saadame vastuvï¿½etud sï¿½numite staatusemuudatused ja veateated
	                                    if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
	                                        System.out.println("\nUuendan vastuvï¿½etud sï¿½numite staatusi ja veateateid...");
	                                        int updatedMessages = UpdateClientStatus(credentials[i], db);
	                                        System.out.println("Vastuvï¿½etud sï¿½numite ("+updatedMessages+") staatused ja veateated uuendatud!");
	                                    }
	                                    
	                                    // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
	                                    System.out.println("\nUuendan vï¿½lja saadetud sï¿½numite staatusi...");                                
	                                    int updatedMessages = UpdateSendStatus(credentials[i], db);
	                                    System.out.println("Vï¿½lja saadetud sï¿½numite ("+updatedMessages+") staatused uuendatud!");
	                                }
	                            }
	                            catch (Exception ex) {
	                                CommonMethods.logError( ex, "dvk.client.Client", "main" );
	                                System.out.println("Viga DVK andmevahetuses (saabuvad): " + ex.getMessage());
	                            }                        
	                        }
	                    }
	                } else {
	                	logger.info("Saabuvaid sÃµnumeid ei leitud");
	                }
            	} catch (Exception ex) {
            		logger.info("Dokumentide vastuvõtmisel tekkis viga - " + ex.getMessage());
            		logger.error(ex);
            	}
            }
        }

        // UPDATE STATUS
        if (ExecType == ClientExecType.UpdateStatus || ExecType == ClientExecType.SendReceive) {
            for (OrgSettings db : currentClientDatabases) {
            	// Kontrollime kindlasti, et antud andmebaaiï¿½hendus ei oleks
            	// mï¿½eldud ainult andmebaaide omavahelise andmevahetuse jaoks.
                dvkClient.setOrgSettings(db.getDvkSettings());
                UnitCredential[] credentials = UnitCredential.getCredentials(db);
                for (int i = 0; i < credentials.length; ++i) {
                    try {
                        // Kui on dokumente alla laadimiseks ootel, siis teeme pï¿½ringu vastasel korral mitte
                        String secureServer = db.getDvkSettings().getServiceUrl();
                        if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                            secureServer = Settings.Client_ServiceUrl;
                        }
                        System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
                        System.out.println("Asutuse turvaserver: " + secureServer);
                        dvkClient.setServiceURL(secureServer);
                        
                        // Saadame vastuvï¿½etud sï¿½numite staatusemuudatused ja veateated
                        if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                            System.out.println("\nUuendan vastuvï¿½etud sï¿½numite staatusi ja veateateid...");
                            int updatedMessages = UpdateClientStatus(credentials[i], db);
                            System.out.println("Vastuvï¿½etud sï¿½numite ("+updatedMessages+") staatused ja veateated uuendatud!");
                        }
                        
                        // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
                        System.out.println("\nUuendan sï¿½numite staatusi...");
                        int updatedMessages = UpdateSendStatus(credentials[i], db);
                        System.out.println("Sï¿½numite ("+ updatedMessages +") staatused uuendatud!");
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
        System.out.println("\n\nDVK klient lï¿½petab tï¿½ï¿½.");
        System.out.println("Andmete uuendamiseks kulus "+ String.valueOf( (double)(endDate.getTime()-startDate.getTime())/1000f ) +" sekundit.");
    }
    
    // Kuvab juhised programmi kï¿½ivitamiseks. Valede parameetrite korral kuvatakse alati juhised
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
        System.out.println("Programmi kï¿½ivitamise parameetrid:");
        System.out.println("  -mode=X");
        System.out.println("    Parameetri vï¿½imalikud vï¿½ï¿½rtused:");
        System.out.println("    1 - ootel dokumentide vï¿½lja saatmine");
        System.out.println("    2 - saatmisel olevate dokumentide alla laadimine (sissetulevad)");
        System.out.println("    3 - nii saatmine kui ka vastuvï¿½tmine (1 ja 2)");
        System.out.println("    4 - ainult staatuste uuendamine");
        System.out.println("");
        System.out.println("    Nï¿½iteks: java dvk.client.Client -mode=3");
        System.out.println("");
        System.out.println("");
        System.out.println("  -prop=X");
        System.out.println("    Kliendi seadete faili dvk_client.properties asukoha etteandmine");
        System.out.println("");
        System.out.println("    Nï¿½iteks: java dvk.client.Client -prop=\"C:\\dvk\\dvk_client.properties\"");
        System.out.println("");
        System.out.println("");
        System.out.println("Parameetrite puudumisel teostatakse kï¿½ik toimingud");
    }

    private static int UpdateSendStatus(UnitCredential masterCredential, OrgSettings db) {
        int resultCounter = 0;
        try {
            ArrayList<DhlMessage> messages = DhlMessage.getList( false, Settings.Client_StatusSending, masterCredential.getUnitID(), false, true, db );
            ArrayList<DhlMessage> messages2 = DhlMessage.getList( false, 0, masterCredential.getUnitID(), true, true, db );
            
            messages.addAll(messages2);
            
            messages2 = null;
            System.out.println("    Saatmisel olevaid sÃµnumeid: " + String.valueOf(messages.size()));
            if (!messages.isEmpty()) {
                HeaderVariables header = new HeaderVariables(
                    masterCredential.getInstitutionCode(),
                    masterCredential.getPersonalIdCode(),
                    "",
                    (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode()));
                
                // Jaotame dokumendid gruppidesse, et staatust kï¿½sitaks sellest
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
                            throw new Exception("Viga sï¿½numi aadresaandmete tï¿½ï¿½tlemisel!");
                        }
                    }
                    dvkClient.initClient(realServiceURL, realProducerName);
                    System.out.println("    Suhtlen DVK serveriga...");
                    ArrayList<GetSendStatusResponseItem> result = dvkClient.getSendStatus(header, dhlIDs, true);
                    System.out.println("    Tï¿½ï¿½tlen DVKst saadud vastust...");
                    
                    // Teeme vastussï¿½numi andmetest omad jï¿½reldused
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
        
        // Taastame seadistuse, et klient oleks vaikimisi seadistatud pï¿½ringuid saatma konfiguratsioonifailis
        // mï¿½ï¿½ratud aadressi ja andmekogu nimega.
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
            System.out.println("    Staatuse uuendamist vajavaid sï¿½numeid: " + String.valueOf(messages.size()));
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
            // Tï¿½ï¿½tleme andmebaasis olevad saatmist ootavad sï¿½numid ï¿½le, et XML konteineris
            // olev adressaatide nimekiri oleks kindlasti ka adressaatide tabelisse dubleeritud.
            DhlMessage.prepareUnsentMessages(masterCredential.getUnitID(), db);
            
            ArrayList<DhlMessage> messages = DhlMessage.getList(false, Settings.Client_StatusWaiting, masterCredential.getUnitID(), false, false, db);
            if (messages.size() == 0){
                System.out.println("Saatmist ootavaid sï¿½numeid ei leitud!");
                return resultCounter;
            }
            else{            
                System.out.println("\nSaadan vï¿½ljuvaid sï¿½numeid...");                
                System.out.println("    Saatmist ootavaid sï¿½numeid: " + String.valueOf(messages.size()));
            }            
            
            HeaderVariables header = new HeaderVariables(
                masterCredential.getInstitutionCode(),
                masterCredential.getPersonalIdCode(),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode())); 
            
            resultCounter = messages.size();
            for (int i = 0; i < messages.size(); ++i) {
                DhlMessage msg = messages.get(i);
                
                // Kui dokumendi GUID ei ole mï¿½ï¿½ratud, siis genereerime selle.
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
	                		// Sï¿½num on mï¿½eldud ï¿½hest andmebaasist teise edastamiseks
	                		if (centralServerId > 0) {
	                			currentClone.setDhlID(centralServerId);
	                		} else if (result > 0) {
	                			currentClone.setDhlID(result);
	                		}
	                		dvkClient.sendDocumentFromDbToDb(currentClone, db);
	                	} else {
	                		// Sï¿½num on mï¿½eldud SOAP kujul edastamiseks
	                		String serviceUrl = currentClone.getDeliveryChannel().getServiceUrl();
	                		String producerName = currentClone.getDeliveryChannel().getProducerName();
	                		
	                		logger.info("Sending document " + String.valueOf(msg.getId()) + " (GUID:"+ msg.getDhlGuid() +") to server " + serviceUrl + " (" + producerName + ")");
	                		dvkClient.initClient(serviceUrl, producerName);
	                		
	                        result = dvkClient.sendDocuments(header, currentClone);
	                        if ((centralServerId == 0) && producerName.equalsIgnoreCase(Settings.Client_ProducerName)) {
	                        	centralServerId = result;
	                        }
	                        currentClone.setQueryID(dvkClient.getQueryId()); // paneme pï¿½ringu ID sï¿½numile kï¿½lge
	                        
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
	                	
                        // Ainult esimese serveri puhul uuendame DHL_ID vï¿½ï¿½rtus sï¿½numi pï¿½hitabelis
                        if (k == 0){
                            UpdateDhlID(currentClone, db, result);
                        }
	                }
	                
	                // Mï¿½rgime saatja andmebaasis, et sï¿½num on saatmisel
	                DhlMessage.calculateAndUpdateMessageStatus(msg.getId(), db);
	                //DhlMessage.updateStatus(msg.getId(), Settings.Client_StatusSending, false, db);
	                
                } catch (Exception ex1) {
                    CommonMethods.logError(ex1, "dvk.client.Client", "SendUnsentMessages");
                    System.out.println("    Sï¿½numite saatmisel tekkis viga: " + ex1.getMessage());
                    if (msg != null) {
                        try {
                            //msg.setFilePath(originalFilePath);
                            msg.setFaultActor("local");
                            msg.setFaultString(ex1.getMessage());
                            msg.setQueryID(dvkClient.getQueryId());  // paneme sï¿½numile kï¿½lge pï¿½ringu ID
                            msg.updateInDB(db);
                        } catch (Exception ex2) {
                            CommonMethods.logError(ex2, "dvk.client.Client", "SendUnsentMessages");
                            System.out.println("    Sï¿½numite saatmisel tekkis viga: " + ex2.getMessage());
                        }
                    }
                }
            }
            System.out.println("Vï¿½ljuvad sï¿½numid saadetud!");          
            
        } catch (Exception ex) {
            CommonMethods.logError( ex, "dvk.client.Client", "SendUnsentMessages" );
            System.out.println("    Sï¿½numite saatmisel tekkis viga: " + ex.getMessage());
        }  
        return resultCounter;
    }
    
    // Harutab lahti sendDocuments pï¿½ringu vastuseks saadud XML-i ja uuendab
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
            // Saadetava sõnumi päisesse kantavad parameetrid
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
                message.setQueryID(dvkClient.getQueryId()); // paneme X-tee päringu ID sõnumile külge
                
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
                
            // Märgime edukalt vastuvõetud dokumendid vastuvõetuks.
            if (receivedDocs.size() > 0) {
            	logger.info("Annan dokumendivahetuskeskusele teada, et sain dokumendid kätte...");
                MarkDocumentsReceived(receivedDocs, masterCredential, db.getDvkSettings().getDefaultStatusID(), null, "", resultFiles.deliverySessionID, db);
            }
                
            // Teavitame dokumendivahetuskeskust dokumentidest, mille
            // vastuvõtmine ebaõnnestus.
            if ((failedDocs.size() > 0) && (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1)) {
            	logger.info("Teavitame dokumendivahetuskeskust dokumentidest, mille vastuvõtmine ebaõnnestus.");
                Fault clientFault = new Fault();
                clientFault.setFaultString("Error occured while saving document to database!");
                MarkDocumentsReceived(failedDocs, masterCredential, 0, clientFault, "", resultFiles.deliverySessionID, db);
            }    
        } catch (Exception ex) {
        	logger.error(ex);
            System.out.println("    Dokumentide vastuvõtmisel tekkis viga: " + ex.getMessage());
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
            // Saadetava sõnumi päisesse kantavad parameetrid
            HeaderVariables header = new HeaderVariables(
                masterCredential.getInstitutionCode(),
                masterCredential.getPersonalIdCode(),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode()));
            
            // Käivitame päringu
            dvkClient.markDocumentsReceived(header, documents, statusID, clientFault, metaXML, deliverySessionID, false, db, masterCredential);
        }
        catch (Exception ex) {
            CommonMethods.logError( ex, "dvk.client.Client", "MarkDocumentsReceived" );
            System.out.println("    Dokumentide staatuste uuendamisel tekkis viga: " + ex.getMessage());
            return;
        }
    }

    private static void MarkDocumentsReceived(ArrayList<DhlMessage> documents, UnitCredential masterCredential, String deliverySessionID, OrgSettings db) throws Exception {
        // Saadetava sõnumi päisesse kantavad parameetrid
        HeaderVariables header = new HeaderVariables(
            masterCredential.getInstitutionCode(),
            masterCredential.getPersonalIdCode(),
            "",
            (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE"+masterCredential.getPersonalIdCode()));
        
        // Käivitame päringu
        dvkClient.markDocumentsReceived(header, documents, deliverySessionID, db, masterCredential);
    }
        
    private static ArrayList<String> ReceiveDownloadWaitingInstitutions(ArrayList<OrgSettings> databases){    	
        // kï¿½sime nimekirja asutustest, kus on alla laadimist ootavaid dokumente
        ArrayList<String> waitingInstitutions = new ArrayList<String>();
        try {
            // Saadetava sï¿½numi pï¿½isesse kantavad parameetrid
            HeaderVariables headerVar = new HeaderVariables(
                Settings.Client_DefaultOrganizationCode,
                Settings.Client_DefaultPersonCode,
                "",
                (CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode) ? Settings.Client_DefaultPersonCode : "EE"+Settings.Client_DefaultPersonCode));
            
            // Kï¿½ivitame pï¿½ringu
            logger.debug("KÃ¤ivitame pÃ¤ringu parameetritega:");
            logger.debug("OrganizationCode: " + headerVar.getOrganizationCode());
            logger.debug("PersonalIDCode: " + headerVar.getPersonalIDCode());
            logger.debug("PIDWithCountryCode: " + headerVar.getPIDWithCountryCode());
            logger.debug("CaseName: " + headerVar.getCaseName());         
            
            waitingInstitutions = dvkClient.receiveDownloadWaitingOrgs(headerVar, databases);
        }
        catch (Exception ex) {
        	logger.error("Viga alla laadimata sï¿½numeid omavate asutuste loetelu koostamisel: ", ex);
            CommonMethods.logError( ex, "dvk.client.Client", "ReceiveDownloadWaitingInstitutions" );
        }        
        return waitingInstitutions;
    }
    
    private static GetSendingOptionsV3ResponseType ReceiveDownloadWaitingInstitutionsV2(ArrayList<OrgSettings> databases) throws Exception {    	
    	// Saadetava sõnumi päisesse kantavad parameetrid
        HeaderVariables headerVar = new HeaderVariables(
            Settings.Client_DefaultOrganizationCode,
            Settings.Client_DefaultPersonCode,
            "",
            (CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode) ? Settings.Client_DefaultPersonCode : "EE"+Settings.Client_DefaultPersonCode));
        
        // Kï¿½ivitame pï¿½ringu
        logger.debug("Käivitame päringu parameetritega:");
        logger.debug("OrganizationCode: " + headerVar.getOrganizationCode());
        logger.debug("PersonalIDCode: " + headerVar.getPersonalIDCode());
        logger.debug("PIDWithCountryCode: " + headerVar.getPIDWithCountryCode());
        logger.debug("CaseName: " + headerVar.getCaseName());         
        
        return dvkClient.receiveDownloadWaitingOrgsV2(headerVar, databases);
    }
    
}
