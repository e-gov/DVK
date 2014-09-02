package dvk.client;

import dvk.client.amphora.Department;
import dvk.client.amphora.Organization;
import dvk.client.businesslayer.*;
import dvk.client.conf.OrgSettings;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
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
import java.util.List;

import org.apache.log4j.Logger;

public class OrgCapabilityChecker {

	private static Logger logger = Logger.getLogger(OrgCapabilityChecker.class);

	public static void main(String[] args) {
        Date startDate = new Date();

        try {
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
	            logger.error("Application properties file " + propertiesFile + " does not exist!");
	            return;
	        }

	        // Laeme rakenduse seaded
	        Settings.loadProperties(propertiesFile);
	        List<OrgSettings> allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);

	        // Filtreerime välja need andmebaasid, mille andmeid antud klient
	        // peab keskserveriga sünkroniseerima.
	        // S.t. filtreerimisel jäetakse välja need andmebaasid, mille andmed
	        // on konfifailis ainult selleks, et teaks sinna vajadusel otse andmeid kopeerida.
	        List<OrgSettings> databases = new ArrayList<OrgSettings>();
	        for (OrgSettings db : allKnownDatabases) {
	        	if (!db.getDbToDbCommunicationOnly()) {
	        		databases.add(db);
	        	}
	        }

	        // Kontrollime, et seadetes on märgitud vähemalt üks andmebaas, kus
	        // andmeid saaks uuendada.
	        if ((databases == null) || (databases.size() < 1)) {
                logger.error("No database configured in configuration file "+ Settings.Client_ConfigFile +"!");
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
                LoggingService.logError(new ErrorLog(ex, "dvk.client.OrgCapabilityChecker" + " main"));
	            ex.printStackTrace();
	            return;
	        }
	        dvkClient.setOrgSettings(databases.get(0).getDvkSettings());

	        // Tutvustame ennast kasutajale
            logger.info("DVK Client started organization data syncronization with DVK central server. Syncronized databases: " + String.valueOf(databases.size()));
            logger.debug("Local X-Road secure server: " + Settings.Client_ServiceUrl);
            logger.debug("DVK version: " + Settings.Client_SpecificationVersion);

            logger.info("    Preparing request for DVK server...");

	        GetSendingOptionsV3ResponseType result = new GetSendingOptionsV3ResponseType();

	        // Use credentials from first known database to query DEC for all DEC-enabled organizations.
	        UnitCredential[] credList = new UnitCredential[] {};
	        OrgSettings firstKnownDatabase =  databases.get(0);
	        Connection dbConnection = DBConnection.getConnection(firstKnownDatabase);
            DatabaseSessionService.getInstance().setSession(dbConnection, firstKnownDatabase);
	        try {
	        	credList = UnitCredential.getCredentials(databases.get(0), dbConnection);
	        } finally  {
                DatabaseSessionService.getInstance().clearSession();
	        	CommonMethods.safeCloseDatabaseConnection(dbConnection);
	        }

	        if (credList.length > 0) {
	            UnitCredential cred = credList[0];

	            HeaderVariables headerVar = new HeaderVariables(
	                cred.getInstitutionCode(),
	                cred.getPersonalIdCode(),
	                "",
	                (CommonMethods.personalIDCodeHasCountryCode(cred.getPersonalIdCode()) ? cred.getPersonalIdCode() : "EE"+cred.getPersonalIdCode()));

                Connection connection = null;
	            try {
                    connection = DBConnection.getConnection(firstKnownDatabase);
                    DatabaseSessionService.getInstance().setSession(connection, firstKnownDatabase);
                    logger.info("Current database: " + firstKnownDatabase.getDatabaseName());
                    result = dvkClient.getSendingOptions(headerVar, null, null, null, false, -1, -1, databases.get(0).getDvkSettings().getGetSendingOptionsRequestVersion());
                    RequestLog requestLog = new RequestLog(".getSendingOptions.v" +
                            databases.get(0).getDvkSettings().getGetSendingOptionsRequestVersion(), "default_org", "default_user_code");
                    if (result != null) {
                        requestLog.setResponse(ResponseStatus.OK.toString());
                    } else {
                        requestLog.setResponse(ResponseStatus.NOK.toString());
                    }
                    LoggingService.logRequest(requestLog);
	            } catch (Exception ex) {
                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.OrgCapabilityChecker" + " main");
                    LoggingService.logError(errorLog);
                    logger.error("    Exception occured while exchanging data: " + ex.getMessage());
                    logger.info("Canceling work...");
	                return;
	            } finally {
                    CommonMethods.safeCloseDatabaseConnection(connection);
                    DatabaseSessionService.getInstance().clearSession();
                }
                logger.info("    Got response from DVK server...");

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
                            logger.info("    Requesting subdivision data...");
			                try {
                                DatabaseSessionService.getInstance().setSession(dbConnection, firstKnownDatabase);
			                	result.allyksused = dvkClient.getSubdivisionList(headerVar, orgCodes);
			                } catch (Exception ex) {
                                logger.error("    Exception occured while getting subdivision data...");
                                LoggingService.logError(new ErrorLog(ex, "dvk.client.OrgCapabilityChecker" + " main"));
			                    result.allyksused = new ArrayList<Subdivision>();
			                } finally {
                                DatabaseSessionService.getInstance().clearSession();
                            }
		                }

		                if ((result.ametikohad == null) || (result.ametikohad.size() < 1)) {
                            logger.info("    Requesting occupation data...");
			                try {
                                DatabaseSessionService.getInstance().setSession(dbConnection, firstKnownDatabase);
			                	result.ametikohad = dvkClient.getOccupationList(headerVar, orgCodes);
			                } catch (Exception ex) {
                                logger.error("    Exception occured while getting occupation data...");
                                LoggingService.logError(new ErrorLog(ex, "dvk.client.OrgCapabilityChecker" + " main"));
			                    result.ametikohad = new ArrayList<Occupation>();
			                } finally {
                                DatabaseSessionService.getInstance().clearSession();
                            }
		                }
	                }
	            }
	        } else {
	        	logger.warn("No credentials.");
	        }

            logger.info("    Updating data in databases...");
	        Runtime r = Runtime.getRuntime();
	        for (int i = 0; i < databases.size(); ++i) {
	            OrgSettings db = databases.get(i);
	            logger.info("Updating data in database \"" + db.getDatabaseName() + "\".");

	            try {
	            	dbConnection = DBConnection.getConnection(db);
                    DatabaseSessionService.getInstance().setSession(dbConnection, db);
                    logger.info("Current database: " + db.getDatabaseName());
                    if (dbConnection == null) {
                        ErrorLog errorLog = new ErrorLog("Database connection is NULL " + db.getDatabaseName(), "dvk.client.OrgCapabilityChecker" + " main");
                        LoggingService.logError(errorLog);
		            } else {
			            // Sync status classifier values from config file to database
		            	Classifier.duplicateSettingsToDB(db, dbConnection);

		            	// Leiame asutuse seaded
			            UnitCredential[] credentials = UnitCredential.getCredentials(db, dbConnection);

			            // Lisame asutuste andmed teadaolevate asutuste andmebaasidesse
			            // või kui need seal juba olemas on, siis uuendame vajadusel.
			            for (int a = 0; a < credentials.length; ++a) {
			                // Asutuste andmete kirjutamine andmebaasi
			                for (int b = 0; b < result.asutused.size(); ++b) {
			                    DhlCapability org = result.asutused.get(b);
			                    DhlCapability originalOrg = new DhlCapability(dbConnection, org.getOrgCode(), db);
			                    if ((originalOrg.getOrgCode() != null) && !originalOrg.getOrgCode().equalsIgnoreCase("")) {
			                        originalOrg.setOrgName(org.getOrgName());
			                        originalOrg.setIsDhlCapable(org.getIsDhlCapable());
			                        originalOrg.setIsDhlDirectCapable(org.getIsDhlDirectCapable());
			                        originalOrg.setParentOrgCode(org.getParentOrgCode());
			                        originalOrg.saveToDB(dbConnection, db);
			                    } else {
			                    	org.saveToDB(dbConnection, db);
			                    }

			                    // Kui Amphora integratsioon on lubatud, siis lisame uue asutuse
			                    // otse Amphora asutuste registrisse.
			                    if (Settings.Client_IntegratedAmphoraFunctions) {
			                        if((org != null) && org.IsDhlCapable() && (org.getOrgCode() != null) && (org.getOrgCode().length() > 0)) {
			                            Organization.addOrganization(dbConnection, db, credentials[a], org.getOrgCode(), org.getOrgName());
			                        }
			                    }
			                }

			                // Eemaldame DVK-ühilduvuse märke nendelt asutustelt, mis andmebaasis on küll
			                // olemas, aga mille kohta keskserverist mingit infot ei laekunud.
			                ArrayList<DhlCapability> orgsInDB = DhlCapability.getList(db, dbConnection);
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
			                        tmpOrg.saveToDB(dbConnection, db);
			                    }
			                }

			                // Allüksuste andmete kirjutamine andmebaasi
			                if ((result.allyksused != null) && (result.allyksused.size() > 0)) {
			                	List<Subdivision> existingSubdivisions = Subdivision.getList(db, dbConnection);
			                	if (existingSubdivisions != null) {
				                	for (int b = 0; b < existingSubdivisions.size(); b++) {
				                		Subdivision existingItem = existingSubdivisions.get(b);
				                		if (Subdivision.FindFromList(result.allyksused, existingItem.getOrgCode(), existingItem.getShortName()) == null) {
				                			existingItem.deleteFromDb(db, dbConnection);
				                		}
				                	}
			                	}

				                for (int b = 0; b < result.allyksused.size(); ++b) {
				                    Subdivision sub = result.allyksused.get(b);
				                    sub.saveToDB(dbConnection, db);

				                    // Kui Amphora integratsioon on lubatud, siis lisame uue
				                    // allüksuse otse Amphora asutuste registrisse.
				                    // TODO: Remove Amphora integration after year 2011
				                    if (Settings.Client_IntegratedAmphoraFunctions) {
				                         if((sub != null) && (sub.getID() > 0) && !CommonMethods.isNullOrEmpty(sub.getName()) && !CommonMethods.isNullOrEmpty(sub.getOrgCode())) {
				                             Department.addDepartment(dbConnection, db, credentials[a], sub.getID(), sub.getName(), sub.getOrgCode());
				                         }
				                    }
				                }
			                }

			                // Ametikohtade andmete kirjutamine andmebaasi
			                if ((result.ametikohad != null) && (result.ametikohad.size() > 0)) {
			                	List<Occupation> existingOccupations = Occupation.getList(db, dbConnection);
			                	if (existingOccupations != null) {
				                	for (int b = 0; b < existingOccupations.size(); b++) {
				                		Occupation existingItem = existingOccupations.get(b);
				                		if (Occupation.FindFromList(result.ametikohad, existingItem.getOrgCode(), existingItem.getShortName()) == null) {
				                			existingItem.deleteFromDb(db, dbConnection);
				                		}
				                	}
			                	}

				                for (int b = 0; b < result.ametikohad.size(); ++b) {
				                    Occupation occ = result.ametikohad.get(b);
				                    occ.saveToDB(dbConnection, db);
				                }
			                }

			                // Kui Amphora integratsioon on lubatud, siis kontrollime, et
			                // Amphora asutuste tabelis olev info oleks sünkroonis DVK-st
			                // saadud infoga.
			                // TODO: Remove Amphora integration after year 2011
			                if (Settings.Client_IntegratedAmphoraFunctions) {
			                    Organization.syncOrgDhlCapability(dbConnection);
			                }

			                r.gc();
			            }
		            }
                } finally {
                    DatabaseSessionService.getInstance().clearSession();
	            	CommonMethods.safeCloseDatabaseConnection(dbConnection);
	            }
	        }
            logger.info("    Processing response data completed successfully!");
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.OrgCapabilityChecker" + " main");
            LoggingService.logError(errorLog);
            logger.error("    Exception occurred! " + ex.getMessage());
        }

        Date endDate = new Date();
        logger.info("\nWork complete. Client shutting down.");
        logger.debug("Time elapsed: " + String.valueOf((double)(endDate.getTime() - startDate.getTime()) / 1000f) + " seconds.");
    }
}
