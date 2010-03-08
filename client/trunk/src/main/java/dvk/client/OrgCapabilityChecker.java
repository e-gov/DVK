package dvk.client;

import dvk.client.amphora.Department;
import dvk.client.amphora.Organization;
import dvk.client.businesslayer.DhlCapability;
import dvk.client.businesslayer.Occupation;
import dvk.client.businesslayer.Subdivision;
import dvk.client.conf.OrgSettings;
import dvk.core.Settings;
import dvk.client.db.DBConnection;
import dvk.client.db.UnitCredential;
import dvk.client.iostructures.GetSendingOptionsV3ResponseType;
import dvk.core.CommonMethods;
import dvk.core.HeaderVariables;
import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;

import org.apache.log4j.Logger;

public class OrgCapabilityChecker {

	private static Logger logger = Logger.getLogger(OrgCapabilityChecker.class);
	
	public static void main(String[] args) {
        Date startDate = new Date();
        ClientAPI dvkClient = new ClientAPI();

        // Vaatame, kas kasutaja on käivitamisel ka mingeid argumente ette andnud
        String propertiesFile = "dvk_client.properties";
        for (int i = 0; i < args.length; ++i) {
            if (args[i].startsWith("-prop=") && (args[i].length() > 6)) {
                propertiesFile = args[i].substring(6).replaceAll("\"","");
            }
        }
        
        // Kontrollime seaded üle
        if (!(new File(propertiesFile)).exists()) {
            System.out.println("Application properties file " + propertiesFile + " does not exist!");
            return;
        }

        // Laeme rakenduse seaded
        Settings.loadProperties(propertiesFile);
        ArrayList<OrgSettings> allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);

        // Filtreerime välja need andmebaasid, mille andmeid antud klient
        // peab keskserveriga sünkroniseerima.
        // S.t. filtreerimisel jäetakse välja need andmebaasid, mille andmed
        // on konfifailis ainult selleks, et teaks sinna vajadusel otse andmeid kopeerida.
        ArrayList<OrgSettings> databases = new ArrayList<OrgSettings>();
        for (OrgSettings db : allKnownDatabases) {
        	if (!db.getDbToDbCommunicationOnly()) {
        		databases.add(db);
        	}
        }
        
        // Kontrollime, et seadetes on märgitud vähemalt üks andmebaas, kus
        // andmeid saaks uuendada.
        if ((databases == null) || (databases.size() < 1)) {
            System.out.println("No database configured in configuration file "+ Settings.Client_ConfigFile +"!");
            return;
        }

        // TODO: See ei ole päris õige. Tegelikult tuleks siin asutused grupeerida
        // turvaserverite kaupa ja siis iga grupi kohta eraldi päring teha. Antud juhul
        // toimib loogika valesti, kui sama klient vahendab andmeid üle test-x-tee ja
        // "päris" x-tee.
        // Initsialiseerime kliendi
        try {
            dvkClient.initClient(Settings.Client_ServiceUrl, Settings.Client_ProducerName);
        } catch (Exception ex) {
            ex.printStackTrace();
            return;
        }
        dvkClient.setOrgSettings(databases.get(0).getDvkSettings());

        // Tutvustame ennast kasutajale
        System.out.println("DVK Client started organization data syncronization with DVK central server. Syncronized databases: " + String.valueOf(databases.size()));
        System.out.println("Local X-Road secure server: " + Settings.Client_ServiceUrl);
        System.out.println("DVK version: " + Settings.Client_SpecificationVersion);

        System.out.println("    Preparing request for DVK server...");

        GetSendingOptionsV3ResponseType result = new GetSendingOptionsV3ResponseType();
        
        // Küsime esimese asutuse nimel nimekirja kõigist DHL-võimelistest
        // asutustest.
        UnitCredential[] credList = UnitCredential.getCredentials(databases.get(0));
        if (credList.length > 0) {
            UnitCredential cred = credList[0];
            
            HeaderVariables headerVar = new HeaderVariables(
                cred.getInstitutionCode(),
                cred.getPersonalIdCode(),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(cred.getPersonalIdCode()) ? cred.getPersonalIdCode() : "EE"+cred.getPersonalIdCode()));

            try {
            	result = dvkClient.getSendingOptions(headerVar, null, null, null, false, -1, -1, databases.get(0).getDvkSettings().getGetSendingOptionsRequestVersion());
            } catch (Exception ex) {
                CommonMethods.logError(ex, "dvk.client.OrgCapabilityChecker", "main");
                System.out.println("    Exception occured while exchanging data: " + ex.getMessage());
                System.out.println("Canceling work...");
                return;
            }
            System.out.println("    Got response from DVK server...");

            // Kui andmete vahetamisel kasutatava DVK serveri versioon on vähemalt 1.5, siis
            // küsime andmed ka allüksuste ja ametikohtade kohta.
            if (CommonMethods.compareVersions(Settings.Client_SpecificationVersion,"1.5") >= 0) {
                if ((result.allyksused == null) || (result.allyksused.size() < 1)
                	|| (result.ametikohad == null) || (result.ametikohad.size() < 1)) {
            	
	            	ArrayList<String> orgCodes = new ArrayList<String>();
	                for (int i = 0; i < result.asutused.size(); ++i) {
	                    orgCodes.add(result.asutused.get(i).getOrgCode());
	                }
	                
	                if ((result.allyksused == null) || (result.allyksused.size() < 1)) {
		                System.out.println("    Requesting subdivision data...");
		                try {
		                	result.allyksused = dvkClient.getSubdivisionList(headerVar, orgCodes);
		                } catch (Exception ex) {
		                    System.out.println("    Exception occured while getting subdivision data...");
		                    CommonMethods.logError(ex, "dvk.client.OrgCapabilityChecker", "main");
		                    result.allyksused = new ArrayList<Subdivision>();
		                }
	                }
	                
	                if ((result.ametikohad == null) || (result.ametikohad.size() < 1)) {
		                System.out.println("    Requesting occupation data...");
		                try {
		                	result.ametikohad = dvkClient.getOccupationList(headerVar, orgCodes);
		                } catch (Exception ex) {
		                    System.out.println("    Exception occured while getting occupation data...");
		                    CommonMethods.logError(ex, "dvk.client.OrgCapabilityChecker", "main");
		                    result.ametikohad = new ArrayList<Occupation>();
		                }
	                }
                }
            }
        } else {
        	logger.warn("No credentials.");
        }

        System.out.println("    Updating data in databases...");
        Runtime r = Runtime.getRuntime();
        for (int i = 0; i < databases.size(); ++i) {
            OrgSettings db = databases.get(i);
            logger.info("Updating data in database \"" + db.getDatabaseName() + "\".");

            // Leiame asutuse seaded
            UnitCredential[] credentials = UnitCredential.getCredentials(db);

            // Lisame asutuste andmed teadaolevate asutuste andmebaasidesse
            // või kui need seal juba olemas on, siis uuendame vajadusel.
            for (int a = 0; a < credentials.length; ++a) {
                Connection conn = DBConnection.getConnection(db);

                // Asutuste andmete kirjutamine andmebaasi
                for (int b = 0; b < result.asutused.size(); ++b) {
                    DhlCapability org = result.asutused.get(b);
                    DhlCapability originalOrg = new DhlCapability(conn, org.getOrgCode(), db);
                    if ((originalOrg.getOrgCode() != null) && !originalOrg.getOrgCode().equalsIgnoreCase("")) {
                        originalOrg.setOrgName(org.getOrgName());
                        originalOrg.setIsDhlCapable(org.getIsDhlCapable());
                        originalOrg.setIsDhlDirectCapable(org.getIsDhlDirectCapable());
                        originalOrg.setParentOrgCode(org.getParentOrgCode());
                        originalOrg.saveToDB(conn, db);
                    } else {
                    	org.saveToDB(conn, db);
                    }
                    
                    // Kui Amphora integratsioon on lubatud, siis lisame uue asutuse
                    // otse Amphora asutuste registrisse.
                    if (Settings.Client_IntegratedAmphoraFunctions) {
                        if((org != null) && org.IsDhlCapable() && (org.getOrgCode() != null) && (org.getOrgCode().length() > 0)) {
                            Organization.addOrganization(conn, db, credentials[a], org.getOrgCode(), org.getOrgName());
                        }
                    }
                }
                
                // Eemaldame DVK-ühilduvuse märke nendelt asutustelt, mis andmebaasis on küll
                // olemas, aga mille kohta keskserverist mingit infot ei laekunud.
                ArrayList<DhlCapability> orgsInDB = DhlCapability.getList(db);
                for (int b = 0; b < orgsInDB.size(); ++b) {
                    boolean existsInResponse = false;
                    for (int c = 0; c < result.asutused.size(); c++) {
                        if (result.asutused.get(c).getOrgCode().equalsIgnoreCase(orgsInDB.get(b).getOrgCode())) {
                            existsInResponse = true;
                            break;
                        }
                    }
                    if (!existsInResponse) {
                        DhlCapability tmpOrg = orgsInDB.get(b);
                        tmpOrg.setIsDhlCapable(false);
                        tmpOrg.saveToDB(conn, db);
                    }
                }
                
                // Allüksuste andmete kirjutamine andmebaasi
                for (int b = 0; b < result.allyksused.size(); ++b) {
                    Subdivision sub = result.allyksused.get(b);
                    sub.saveToDB(conn, db);
                    
                    // Kui Amphora integratsioon on lubatud, siis lisame uue
                    // allüksuse otse Amphora asutuste registrisse.
                    if (Settings.Client_IntegratedAmphoraFunctions) {
                         if((sub != null) && (sub.getID() > 0) && (sub.getName() != null) && !sub.getName().equalsIgnoreCase("") && (sub.getOrgCode() != null) && !sub.getOrgCode().equalsIgnoreCase("")) {
                             Department.addDepartment(conn, db, credentials[a], sub.getID(), sub.getName(), sub.getOrgCode());
                         }
                    }
                }
                
                // Ametikohtade andmete kirjutamine andmebaasi
                for (int b = 0; b < result.ametikohad.size(); ++b) {
                    Occupation occ = result.ametikohad.get(b);
                    occ.saveToDB(conn, db);
                } 
                
                // Kui Amphora integratsioon on lubatud, siis kontrollime, et
                // Amphora asutuste tabelis olev info oleks sünkroonis DVK-st
                // saadud infoga.
                if (Settings.Client_IntegratedAmphoraFunctions) {
                    Organization.syncOrgDhlCapability(conn);
                }

                try {
                    conn.close();
                } catch (Exception ex) {
                    CommonMethods.logError(ex, "dvk.client.OrgCapabilityChecker", "main");
                }
                r.gc();
            }
        }

        System.out.println("    Processing response data completed successfully!");
        Date endDate = new Date();
        System.out.println("\nWork complete. Client shutting down.");
        System.out.println("Time elapsed: " + String.valueOf((double)(endDate.getTime() - startDate.getTime()) / 1000f) + " seconds.");
    }
}
