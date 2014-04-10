package dvk.client;

import dvk.client.businesslayer.*;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
import dvk.client.iostructures.GetSendStatusResponseItem;
import dvk.client.iostructures.GetSendingOptionsV3ResponseType;
import dvk.client.iostructures.ReceiveDocumentsResult;
import dvk.core.CommonMethods;
import dvk.core.Fault;
import dvk.core.HeaderVariables;
import dvk.core.Settings;

import java.io.File;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;

import java.util.Hashtable;

import org.apache.log4j.Logger;

public class Client {
    static Logger logger = Logger.getLogger(Client.class);
    private static ArrayList<String> tempFiles = new ArrayList<String>();
    private static ClientAPI dvkClient;
    private static ArrayList<OrgSettings> allKnownDatabases;
    private static ArrayList<OrgSettings> currentClientDatabases;
    private static ClientExecType ExecType; // määrab tegevused, mida programm peab tegema

    public static void main(String[] args) {
        Date startDate = new Date();
        try {
            if (args.length > 3) {
                ShowHelp();
                return;
            }

            String runningMode = "";
            String documentLifetimeString = "";

            // Vaatame, kas kasutaja on käivitamisel ka mingeid argumente ette andnud
            String propertiesFile = "dhlclient.properties";
            for (int i = 0; i < args.length; ++i) {
                if (args[i].startsWith("-prop=") && (args[i].length() > 6)) {
                    propertiesFile = args[i].substring(6).replaceAll("\"", "");
                } else if (args[i].startsWith("-mode=") && (args[i].length() > 6)) {
                    runningMode = args[i].substring(6).replaceAll("\"", "");
                } else if (args[i].startsWith("-docLifetimeDays=") && (args[i].length() > 17)) {
                    documentLifetimeString = args[i].substring(17).replaceAll("\"", "");
                }
            }

            int documentLifetimeInDays = CommonMethods.toIntSafe(documentLifetimeString, -1);
            InitExecType(runningMode);
            System.out.println("\n\nKäivitamise reziim: " + ExecType);

            // Check if application properties file exists
            if (!(new File(propertiesFile)).exists()) {
                System.out.println("Application properties file " + propertiesFile + " does not exist!");
                return;
            }

            // Read configuration parameters from properties file
            Settings.loadProperties(propertiesFile);
            allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);

            // Filtreerime välja need andmebaasid, mille andmeid antud klient
            // peab keskserveriga sünkroniseerima.
            // S.t. filtreerimisel jäetakse välja need andmebaasid, mille andmed
            // on konfifailis ainult selleks, et teaks sinna vajadusel otse andmeid kopeerida.
            currentClientDatabases = new ArrayList<OrgSettings>();
            for (OrgSettings db : allKnownDatabases) {
                if (!db.getDbToDbCommunicationOnly()) {
                    currentClientDatabases.add(db);
                }
            }

            // Quit if no client databases are defined
            if (currentClientDatabases.isEmpty()) {
                System.out.println("DVK kliendi seadistuses pole ühtegi andmebaasi!");
                return;
            } else {
                System.out.println("DVK klient alustab andmete uuendamist " + String.valueOf(currentClientDatabases.size()) + " andmebaasis");
            }

            dvkClient = new ClientAPI();
            try {
                dvkClient.initClient(Settings.Client_ServiceUrl, Settings.Client_ProducerName);
                dvkClient.setAllKnownDatabases(allKnownDatabases);
            } catch (Exception ex) {
                ex.printStackTrace();
                ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                LoggingService.logError(errorLog);
                return;
            }

            // Sync status classifier values from configuration file to database
            for (OrgSettings db : currentClientDatabases) {
                Connection dbConnection = null;
                try {
                    dbConnection = DBConnection.getConnection(db);
                    DatabaseSessionService.getInstance().setSession(dbConnection, db);
                    Classifier.duplicateSettingsToDB(db, dbConnection);
                } finally {
                    CommonMethods.safeCloseDatabaseConnection(dbConnection);
                    DatabaseSessionService.getInstance().clearSession();
                }
            }

            // SEND
            if (ExecType == ClientExecType.Send || ExecType == ClientExecType.SendReceive) {
                for (OrgSettings db : currentClientDatabases) {
                    Connection dbConnection = null;
                    try {
                        dbConnection = DBConnection.getConnection(db);
                        DatabaseSessionService.getInstance().setSession(dbConnection, db);

                        dvkClient.setOrgSettings(db.getDvkSettings());
                        UnitCredential[] credentials = UnitCredential.getCredentials(db, dbConnection);

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
                                int sentMessages = SendUnsentMessages(credentials[i], db, dbConnection);

                                if (sentMessages > 0) {
                                    // Uuendame saatmisel olevate dokumentide staatust
                                    System.out.println("\nUuendan välja saadetud sõnumite staatusi...");
                                    int updatedMessages = UpdateSendStatus(credentials[i], db, dbConnection);
                                    System.out.println("Välja saadetud sõnumite (" + updatedMessages + ") staatused uuendatud!");
                                }

                                // Saadame vastuvõetud sõnumite staatusemuudatused ja veateated
                                if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                                    System.out.println("\nUuendan vastuvõetud sõnumite staatusi ja veateateid...");
                                    int updatedMessages = UpdateClientStatus(credentials[i], db, dbConnection);
                                    System.out.println("Vastuvõetud sõnumite (" + updatedMessages + ") staatused ja veateated uuendatud!");
                                }
                            } catch (Exception ex) {
                                ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                                LoggingService.logError(errorLog);
                                System.out.println("Viga DVK andmevahetuses (väljuvad): " + ex.getMessage());
                            }
                        }
                    } finally {
                        DatabaseSessionService.getInstance().clearSession();
                        CommonMethods.safeCloseDatabaseConnection(dbConnection);
                    }
                }
            }

            // RECEIVE
            if (ExecType == ClientExecType.Receive || ExecType == ClientExecType.SendReceive) {
                logger.info("Client executionMode: " + ExecType);

                // Tuvastame andmebaasiseadetest, milline on suurim lubatud
                // getSendingOptions päringu versioon vaikimisi seadistatud
                // turvaserveri jaoks.
                int getSendingOptionsMaxVersion = 1;
                for (OrgSettings db : currentClientDatabases) {
                    String secureServer = db.getDvkSettings().getServiceUrl();
                    if ((db != null) && (db.getDvkSettings() != null)
                            && ((secureServer == null) || (secureServer.length() < 1) || (Settings.Client_ServiceUrl.equalsIgnoreCase(secureServer)))
                            && (db.getDvkSettings().getGetSendingOptionsRequestVersion() > getSendingOptionsMaxVersion)) {
                        getSendingOptionsMaxVersion = db.getDvkSettings().getGetSendingOptionsRequestVersion();
                    }
                }

                // Kui klient vahetab andmeid DVK versiooniga, mis on varasem, kui 1.6, siis ei saa
                // serverist küsida, millistel asutustel on allalaadimata dokumente.
                // Samuti kui on keelatud getSendingOptions päringu v3 (või uuema) versiooni kasutamine,
                // siis ei saa serverist küsida, millistel asutustel on allalaadimata dokumente.
                if ((getSendingOptionsMaxVersion < 3) || (CommonMethods.compareVersions(Settings.Client_SpecificationVersion, "1.6") < 0)) {
                    for (OrgSettings db : currentClientDatabases) {
                        Connection dbConnection = null;
                        try {
                            dbConnection = DBConnection.getConnection(db);
                            DatabaseSessionService.getInstance().setSession(dbConnection, db);
                            dvkClient.setOrgSettings(db.getDvkSettings());
                            UnitCredential[] credentials = UnitCredential.getCredentials(db, dbConnection);

                            for (int i = 0; i < credentials.length; ++i) {
                                try {
                                    String secureServer = db.getDvkSettings().getServiceUrl();
                                    if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                                        secureServer = Settings.Client_ServiceUrl;
                                    }
                                    System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
                                    System.out.println("Asutuse turvaserver: " + secureServer);
                                    dvkClient.setServiceURL(secureServer);

                                    // Küsime DHL-st meile saadetud dokumendid
                                    System.out.println("\nVõtan vastu saabuvaid sõnumeid...");
                                    //// Küsime DHL-st meile saadetud dokumendid
                                    ReceiveNewMessages(credentials[i], db, dbConnection);
                                    System.out.println("Saabuvad sõnumid vastu võetud!");

                                    // Saadame vastuvõetud sõnumite staatusemuudatused ja veateated
                                    if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                                        System.out.println("\nUuendan vastuvõetud sõnumite staatusi ja veateateid...");
                                        int updatedMessages = UpdateClientStatus(credentials[i], db, dbConnection);
                                        System.out.println("Vastuvõetud sõnumite (" + updatedMessages + ") staatused ja veateated uuendatud!");
                                    }

                                    // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
                                    System.out.println("\nUuendan välja saadetud sõnumite staatusi...");
                                    int updatedMessages = UpdateSendStatus(credentials[i], db, dbConnection);
                                    System.out.println("Välja saadetud sõnumite (" + updatedMessages + ") staatused uuendatud!");
                                } catch (Exception ex) {
                                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                                    LoggingService.logError(errorLog);
                                    System.out.println("Viga DVK andmevahetuses (saabuvad): " + ex.getMessage());
                                }
                            }
                        } finally {
                            CommonMethods.safeCloseDatabaseConnection(dbConnection);
                            DatabaseSessionService.getInstance().clearSession();
                        }
                    }
                } else {

                    logger.debug("Laeme asutuste nimekrija, kellel on alla laadimist ootavaid dokumente.");

                    // Laeme asutuste nimekrija, kellel on alla laadimist ootavaid dokumente
                    try {
                        GetSendingOptionsV3ResponseType waitingInstitutions = ReceiveDownloadWaitingInstitutionsV2(currentClientDatabases);
                        //ArrayList<String> waitingInstitutions = ReceiveDownloadWaitingInstitutions(currentClientDatabases);
                        RequestLog requestLog = new RequestLog("dhl-if.getSendingOptions.v", Settings.Client_DefaultOrganizationCode,
                                Settings.Client_DefaultPersonCode);
                        requestLog.setResponse(ResponseStatus.OK.toString());
                        LoggingService.logMarkDocumentsRequestToDataBases(currentClientDatabases, requestLog);

                        if ((waitingInstitutions != null) && (!waitingInstitutions.asutused.isEmpty())) {
                            logger.debug("Asutuste nimekiri käes. Alustame töötlemist.");
                            for (OrgSettings db : currentClientDatabases) {
                                Connection dbConnection = null;
                                try {
                                    dbConnection = DBConnection.getConnection(db);
                                    DatabaseSessionService.getInstance().setSession(dbConnection, db);

                                    dvkClient.setOrgSettings(db.getDvkSettings());
                                    UnitCredential[] credentials = UnitCredential.getCredentials(db, dbConnection);
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
                                                logMessage = "Asutusel \"" + credentials[i].getInstitutionCode() + "\" on dokumente ootel";
                                            } else {
                                                logMessage = "Asutusel \"" + credentials[i].getInstitutionCode() + "\" ei ole dokumente ootel";
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
                                                    logMessage += " ja allüksusel \"" + credentials[i].getDivisionShortName() + "\" on dokumente ootel";
                                                } else {
                                                    logMessage += ", aga allüksusel \"" + credentials[i].getDivisionShortName() + "\" ei ole dokumente ootel";
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
                                                    logMessage += " ja ametikohal \"" + credentials[i].getOccupationShortName() + "\" on dokumente ootel";
                                                } else {
                                                    logMessage += ", aga ametikohal \"" + credentials[i].getOccupationShortName() + "\" ei ole dokumente ootel";
                                                }
                                            }
                                            logger.debug(logMessage);

                                            // Kui on dokumente alla laadimiseks ootel, siis teeme päringu vastasel korral mitte
                                            if (found) {
                                                String secureServer = db.getDvkSettings().getServiceUrl();
                                                if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                                                    secureServer = Settings.Client_ServiceUrl;
                                                }
                                                System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
                                                System.out.println("Asutuse turvaserver: " + secureServer);
                                                dvkClient.setServiceURL(secureServer);

                                                // Küsime DHL-st meile saadetud dokumendid
                                                System.out.println("\nVõtan vastu saabuvaid sõnumeid...");
                                                System.out.println("\nSõnumite alla laadimist ootavate asutuste arv: " + waitingInstitutions.asutused.size());
                                                //// Küsime DHL-st meile saadetud dokumendid
                                                ReceiveNewMessages(credentials[i], db, dbConnection);
                                                System.out.println("Saabuvad sõnumid vastu võetud!");

                                                // Saadame vastuvõetud sõnumite staatusemuudatused ja veateated
                                                if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                                                    System.out.println("\nUuendan vastuvõetud sõnumite staatusi ja veateateid...");
                                                    int updatedMessages = UpdateClientStatus(credentials[i], db, dbConnection);
                                                    System.out.println("Vastuvõetud sõnumite (" + updatedMessages + ") staatused ja veateated uuendatud!");
                                                }

                                                // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
                                                System.out.println("\nUuendan välja saadetud sõnumite staatusi...");
                                                int updatedMessages = UpdateSendStatus(credentials[i], db, dbConnection);
                                                System.out.println("Välja saadetud sõnumite (" + updatedMessages + ") staatused uuendatud!");
                                            }
                                        } catch (Exception ex) {
                                                ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                                                LoggingService.logError(errorLog);
                                                System.out.println("Viga DVK andmevahetuses (saabuvad): " + ex.getMessage());
                                        }
                                    }
                                } finally {
                                    CommonMethods.safeCloseDatabaseConnection(dbConnection);
                                    DatabaseSessionService.getInstance().clearSession();
                                }
                            }
                        } else {
                            logger.info("Saabuvaid sõnumeid ei leitud");
                        }
                    } catch (Exception ex) {
                        logger.info("Dokumentide vastuvõtmisel tekkis viga - " + ex.getMessage());
                        ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                        LoggingService.logError(errorLog);
                        RequestLog requestLog = new RequestLog("dhl-if.getSendingOptions.v", Settings.Client_DefaultOrganizationCode,
                                Settings.Client_DefaultPersonCode);
                        requestLog.setResponse(ResponseStatus.NOK.toString());
                        LoggingService.logMarkDocumentsRequestToDataBases(currentClientDatabases, requestLog);
                    }
                }
            }

            // UPDATE STATUS
            if (ExecType == ClientExecType.UpdateStatus || ExecType == ClientExecType.SendReceive) {
                for (OrgSettings db : currentClientDatabases) {
                    Connection dbConnection = null;
                    try {
                        dbConnection = DBConnection.getConnection(db);
                        DatabaseSessionService.getInstance().setSession(dbConnection, db);
                        dvkClient.setOrgSettings(db.getDvkSettings());
                        UnitCredential[] credentials = UnitCredential.getCredentials(db, dbConnection);
                        for (int i = 0; i < credentials.length; ++i) {
                            try {
                                // Kui on dokumente alla laadimiseks ootel, siis teeme päringu vastasel korral mitte
                                String secureServer = db.getDvkSettings().getServiceUrl();
                                if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                                    secureServer = Settings.Client_ServiceUrl;
                                }
                                System.out.println("\nAsutus: " + credentials[i].getInstitutionName());
                                System.out.println("Asutuse turvaserver: " + secureServer);
                                dvkClient.setServiceURL(secureServer);

                                // Saadame vastuvõetud sõnumite staatusemuudatused ja veateated
                                if (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1) {
                                    System.out.println("\nUuendan vastuvõetud sõnumite staatusi ja veateateid...");
                                    int updatedMessages = UpdateClientStatus(credentials[i], db, dbConnection);
                                    System.out.println("Vastuvõetud sõnumite (" + updatedMessages + ") staatused ja veateated uuendatud!");
                                }

                                // Uuendame saatmisel olevate dokumentide staatust - vajalik selleks, et saatja dokumendi staatus saaks muudetud
                                System.out.println("\nUuendan sõnumite staatusi...");
                                int updatedMessages = UpdateSendStatus(credentials[i], db, dbConnection);
                                System.out.println("Sõnumite (" + updatedMessages + ") staatused uuendatud!");
                            } catch (Exception ex) {
                                ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                                LoggingService.logError(errorLog);
                                System.out.println("Viga DVK andmevahetuses (staatuse uuendamine): " + ex.getMessage());
                            }
                        }
                    } finally {
                        CommonMethods.safeCloseDatabaseConnection(dbConnection);
                        DatabaseSessionService.getInstance().clearSession();
                    }
                }
            }

            // Delete old documents
            if (ExecType == ClientExecType.DeleteOldDocuments) {
                for (OrgSettings db : currentClientDatabases) {
                    if ((documentLifetimeInDays > 0) || (db.getDeleteOldDocumentsAfterDays() > 0)) {
                        // Determine document lifetime for this database
                        int currentDbDocLifetimeInDays = documentLifetimeInDays;
                        if (currentDbDocLifetimeInDays <= 0) {
                            currentDbDocLifetimeInDays = db.getDeleteOldDocumentsAfterDays();
                        }

                        if (currentDbDocLifetimeInDays > 0) {
                            Connection dbConnection = null;
                            try {
                                dbConnection = DBConnection.getConnection(db);
                                DatabaseSessionService.getInstance().setSession(dbConnection, db);
                                System.out.println("\nKustutan andmebaasist \"" + db.getDatabaseName() + "\" kõik " + currentDbDocLifetimeInDays + " päevast vanemad dokumendid");
                                int deletedDocumentCount = DhlMessage.deleteOldDocuments(currentDbDocLifetimeInDays, db, dbConnection);
                                System.out.println("Kustutatud kokku " + deletedDocumentCount + " dokumenti.");

                                logger.info("Deleted " + deletedDocumentCount + " old documents from database \"" + db.getDatabaseName() + "\". Application was configured to delete all documents older than " + currentDbDocLifetimeInDays + " days.");
                            } finally {
                                CommonMethods.safeCloseDatabaseConnection(dbConnection);
                                DatabaseSessionService.getInstance().clearSession();
                            }
                        } else {
                            System.out.println("Andmebaasist \"" + db.getDatabaseName() + "\" ei kustutata ühtegi dokumenti.");
                        }
                    }
                }
            }

            if (ClientExecType.ADITGetSendStatus.equals(ExecType)) {
                ClientAPI aditDvkApi = new ClientAPI();
                try {
                    aditDvkApi.initClient(Settings.Client_ServiceUrl, Settings.Client_AditProducerName);
                    aditDvkApi.setAllKnownDatabases(allKnownDatabases);
                } catch (Exception ex) {
                    ex.printStackTrace();
                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                    LoggingService.logError(errorLog);
                    return;
                }

                AditGetSendStatusService aditGetSendStatusService = new AditGetSendStatusService(
                        Settings.Client_AditProducerName, aditDvkApi);
                aditGetSendStatusService.updateAditSendStatusFor(currentClientDatabases);
            }
        } catch (Exception ex) {
            System.out.println("DVK kliendi töös tekkis viga! " + ex.getMessage());
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
            LoggingService.logError(errorLog);
        }

        // Kustutame ajutised failid
        System.out.println("\n\nKustutan loodud ajutised failid...");
        if (!tempFiles.isEmpty()) {
            for (int i = 0; i < tempFiles.size(); ++i) {
                try {
                    File f = new File(tempFiles.get(i));
                    if (f.exists()) {
                        f.delete();
                    }
                } catch (Exception ex) {
                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " main");
                    LoggingService.logError(errorLog);
                }
            }
        }
        CommonMethods.deleteOldPipelineFiles(2500, true);
        System.out.println("Ajutised failid kustutatud!");

        Date endDate = new Date();
        System.out.println("\n\nDVK klient lõpetab töö.");
        System.out.println("Andmete uuendamiseks kulus " + String.valueOf((double) (endDate.getTime() - startDate.getTime()) / 1000f) + " sekundit.");
    }

    // Kuvab juhised programmi käivitamiseks. Valede parameetrite korral kuvatakse alati juhised
    private static void InitExecType(String runningMode) {
        int mode = 0;
        // vaikimisi tehakse nii alla laadimine kui ka saatmine
        ExecType = ClientExecType.SendReceive;
        if ((runningMode != null) && (runningMode.length() > 0)) {
            try {
                mode = Integer.parseInt(runningMode);
                switch (mode) {
                    case 1:
                        ExecType = ClientExecType.Send;
                        break;
                    case 2:
                        ExecType = ClientExecType.Receive;
                        break;
                    case 3:
                        ExecType = ClientExecType.SendReceive;
                        break;
                    case 4:
                        ExecType = ClientExecType.UpdateStatus;
                        break;
                    case 5:
                        ExecType = ClientExecType.DeleteOldDocuments;
                        break;
                    case 6:
                        ExecType = ClientExecType.ADITGetSendStatus;
                        break;
                    default:
                        ExecType = ClientExecType.SendReceive;
                        break;
                }
            } catch (Exception ex) {
                ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " InitExecType");
                LoggingService.logError(errorLog);
                ExecType = ClientExecType.SendReceive;
            }
        }
    }

    private static void ShowHelp() {
        System.out.println("Programmi käivitamise parameetrid:");
        System.out.println("  -mode=X");
        System.out.println("    Parameetri võimalikud väärtused:");
        System.out.println("    1 - ootel dokumentide välja saatmine");
        System.out.println("    2 - saatmisel olevate dokumentide alla laadimine (sissetulevad)");
        System.out.println("    3 - nii saatmine kui ka vastuvõtmine (1 ja 2)");
        System.out.println("    4 - ainult staatuste uuendamine");
        System.out.println("    5 - vanade dokumentide kustutamine");
        System.out.println("    6 - uuenda ADIT'isse saadetud dokumentide avamise kuupäevi");
        System.out.println("");
        System.out.println("    Näiteks: java dvk.client.Client -mode=3");
        System.out.println("");
        System.out.println("");
        System.out.println("  -prop=X");
        System.out.println("    Kliendi seadete faili dvk_client.properties asukoha etteandmine");
        System.out.println("");
        System.out.println("    Näiteks: java dvk.client.Client -prop=\"C:\\dvk\\dvk_client.properties\"");
        System.out.println("");
        System.out.println("");
        System.out.println("  -docLifetimeDays=X");
        System.out.println("    Määrab, mitu päeva peab dokument vana olema selleks, et see maha kustutataks");
        System.out.println("");
        System.out.println("    Näiteks: java dvk.client.Client -mode=5 -docLifetimeDays=7");
        System.out.println("");
        System.out.println("    Näitena toodud käsk kustutab DVK kliendi andmebaasist kõik rohkem kui 7 päeva vanad dokumendid");
        System.out.println("");
        System.out.println("");
        System.out.println("Parameetrite puudumisel teostatakse saatmine, vastuvõtmine ja staatuste uuendamine");
    }

    private static int UpdateSendStatus(UnitCredential masterCredential, OrgSettings db, Connection dbConnection) {
        int resultCounter = 0;
        try {
            ArrayList<DhlMessage> messages = DhlMessage.getList(false, Settings.Client_StatusSending, masterCredential.getUnitID(), false, true, db, dbConnection);
            ArrayList<DhlMessage> messages2 = DhlMessage.getList(false, 0, masterCredential.getUnitID(), true, true, db, dbConnection);

            messages.addAll(messages2);

            messages2 = null;
            System.out.println("    Saatmisel olevaid sõnumeid: " + String.valueOf(messages.size()));
            if (!messages.isEmpty()) {
                HeaderVariables header = new HeaderVariables(
                        masterCredential.getInstitutionCode(),
                        masterCredential.getPersonalIdCode(),
                        "",
                        (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE" + masterCredential.getPersonalIdCode()));

                // Jaotame dokumendid gruppidesse, et staatust küsitaks sellest
                // serverist, kuhu dokument saadeti
                ArrayList<String> keys = new ArrayList<String>();
                Hashtable<String, ArrayList<DhlMessage>> addressTable = new Hashtable<String, ArrayList<DhlMessage>>();
                for (int i = 0; i < messages.size(); ++i) {
                    DhlMessage msg = messages.get(i);
                    ArrayList<MessageRecipient> recipients = MessageRecipient.getList(msg.getId(), db, dbConnection);
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
                            throw new Exception("Viga sõnumi aadresaandmete töötlemisel!");
                        }
                    }
                    dvkClient.initClient(realServiceURL, realProducerName);
                    System.out.println("    Suhtlen DVK serveriga...");
                    ArrayList<GetSendStatusResponseItem> result = dvkClient.getSendStatus(header, dhlIDs, true);
                    System.out.println("    Töötlen DVKst saadud vastust...");

                    // Teeme vastussõnumi andmetest omad järeldused
                    UpdateStatusChangesInDB(result, producerName, serviceURL, db, dbConnection);
                }
                resultCounter = messages.size();
            }
            messages = null;
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " UpdateSendStatus");
            LoggingService.logError(errorLog);
            System.out.println("    Staatuste uuendamisel tekkis viga: " + ex.getMessage());
        }

        // Taastame seadistuse, et klient oleks vaikimisi seadistatud päringuid saatma konfiguratsioonifailis
        // määratud aadressi ja andmekogu nimega.
        try {
            dvkClient.initClient(Settings.Client_ServiceUrl, Settings.Client_ProducerName);
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " UpdateSendStatus");
            LoggingService.logError(errorLog);
        }

        return resultCounter;
    }

    private static void UpdateStatusChangesInDB(ArrayList<GetSendStatusResponseItem> statusMessgaes, String producerName, String serviceURL, OrgSettings db, Connection dbConnection) {
        if ((statusMessgaes == null) || (statusMessgaes.size() < 1)) {
            return;
        }

        for (int i = 0; i < statusMessgaes.size(); ++i) {
            GetSendStatusResponseItem item = statusMessgaes.get(i);
            logger.debug("Updating status.");
            logger.debug("DHL_ID: " + item.getDhlID());
            logger.debug("GUID: " + item.getGuid());
            int messageID = DhlMessage.getMessageID(item.getDhlID(), producerName, serviceURL, false, db, dbConnection);
            logger.debug("messageID: " + messageID);
            DhlMessage.updateStatus(messageID, item, db, dbConnection);
        }
    }

    private static int UpdateClientStatus(UnitCredential masterCredential, OrgSettings db, Connection dbConnection) {
        int resultCounter = 0;
        try {
            ArrayList<DhlMessage> messages = DhlMessage.getList(true, Settings.Client_StatusReceived, masterCredential.getUnitID(), true, true, db, dbConnection);
            System.out.println("    Staatuse uuendamist vajavaid sõnumeid: " + String.valueOf(messages.size()));
            if ((messages != null) && !messages.isEmpty()) {
                MarkDocumentsReceived(messages, masterCredential, "", db, dbConnection);
                resultCounter = messages.size();
                DhlMessage tmp = null;
                for (int i = 0; i < messages.size(); ++i) {
                    tmp = messages.get(i);
                    tmp.setStatusUpdateNeeded(false);
                    tmp.updateStatusUpdateNeed(db, dbConnection);
                }
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " UpdateClientStatus");
            LoggingService.logError(errorLog);
            System.out.println("    Staatuste uuendamisel tekkis viga: " + ex.getMessage());
        }
        return resultCounter;
    }

    private static int SendUnsentMessages(UnitCredential masterCredential,
                                          OrgSettings db, Connection dbConnection) {
        int resultCounter = 0;
        try {
            // Töötleme andmebaasis olevad saatmist ootavad sõnumid üle, et
            // XML konteineris olev adressaatide nimekiri oleks kindlasti ka
            // adressaatide tabelisse dubleeritud.
            DhlMessage.prepareUnsentMessages(masterCredential.getUnitID(), db, dbConnection);

            ArrayList<DhlMessage> messages = DhlMessage.getList(false, Settings.Client_StatusWaiting, masterCredential.getUnitID(), false, false, db, dbConnection);
            if (messages.size() == 0) {
                System.out.println("Saatmist ootavaid sõnumeid ei leitud!");
                return resultCounter;
            } else {
                System.out.println("\nSaadan väljuvaid sõnumeid...");
                System.out.println("    Saatmist ootavaid sõnumeid: " + String.valueOf(messages.size()));
            }

            HeaderVariables header = new HeaderVariables(
                    masterCredential.getInstitutionCode(),
                    masterCredential.getPersonalIdCode(),
                    "",
                    (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE" + masterCredential.getPersonalIdCode()));

            resultCounter = messages.size();
            for (int i = 0; i < messages.size(); ++i) {
                DhlMessage msg = messages.get(i);

                // Kui dokumendi GUID ei ole määratud, siis genereerime selle.
                if (msg.getDhlGuid() == null || msg.getDhlGuid().trim().equalsIgnoreCase("")) {
                    msg.setDhlGuid(DhlMessage.generateGUID());
                }

                try {
                    ArrayList<DhlMessage> messageClones = msg.splitMessageByDeliveryChannel(db, allKnownDatabases, masterCredential.getContainerVersion(), dbConnection);
                    logger.info("Document " + String.valueOf(msg.getId()) + " (GUID:" + msg.getDhlGuid() + ") will be sent through " + String.valueOf(messageClones.size()) + " channels.");

                    int messageDecId = 0;
                    String messageQueryId = "";
                    String messageGuid = "";

                    int centralServerId = 0;
                    for (int k = 0; k < messageClones.size(); k++) {
                        DhlMessage currentClone = messageClones.get(k);
                        int result = 0;
                        if (currentClone.getDeliveryChannel().getDatabase() != null) {
                            // Sõnum on mõeldud ühest andmebaasist teise edastamiseks
                            if (centralServerId > 0) {
                                currentClone.setDhlID(centralServerId);
                            } else if (result > 0) {
                                currentClone.setDhlID(result);
                            }
                            dvkClient.sendDocumentFromDbToDb(currentClone, db, dbConnection);
                        } else {
                            // Sõnum on mõeldud SOAP kujul edastamiseks
                            String serviceUrl = currentClone.getDeliveryChannel().getServiceUrl();
                            String producerName = currentClone.getDeliveryChannel().getProducerName();

                            logger.info("Sending document " + String.valueOf(msg.getId()) + " (GUID:" + msg.getDhlGuid() + ") to server " + serviceUrl + " (" + producerName + ")");
                            dvkClient.initClient(serviceUrl, producerName);

                            result = dvkClient.sendDocuments(header, currentClone);
                            currentClone.setDhlID(result);
                            currentClone.setQueryID(dvkClient.getQueryId());

                            if ((centralServerId == 0) && producerName.equalsIgnoreCase(Settings.Client_ProducerName)) {
                                centralServerId = result;
                            }

                            for (int a = 0; a < currentClone.getRecipients().size(); a++) {
                                MessageRecipient rec = currentClone.getRecipients().get(a);
                                rec.setDhlId(result);
                                rec.setSendingStatusID(Settings.Client_StatusSending);
                                rec.setSendingDate(new Date());
                                rec.saveToDB(db, dbConnection);

                                String recipientShortId = rec.getRecipientOrgCode() + "|" + rec.getRecipientPersonCode() + "|" + rec.getRecipientDivisionCode() + "|" + rec.getRecipientPositionCode() + "|" + String.valueOf(rec.getRecipientDivisionID()) + "|" + String.valueOf(rec.getRecipientPositionID());
                                logger.info("Document " + String.valueOf(currentClone.getId()) + " was sent to server " + serviceUrl + " (" + producerName + ")" + " for recipient " + recipientShortId);
                            }
                        }

                        // Ainult esimese serveri puhul uuendame DHL_ID väärtus sõnumi põhitabelis
                        if (k == 0) {
                            messageDecId = currentClone.getDhlID();
                            messageQueryId = currentClone.getQueryID();
                            messageGuid = currentClone.getDhlGuid();
                        }
                    }

                    // Remove data abuout previous sending errors
                    msg.setDhlID(messageDecId);
                    msg.setQueryID(messageQueryId);
                    msg.setDhlGuid(messageGuid);
                    msg.setStatusUpdateNeeded(Settings.Client_SentMessageStatusFollowupDays > 0);
                    msg.setSendingStatusID(Settings.Client_StatusSending);
                    msg.setFaultActor("");
                    msg.setFaultCode("");
                    msg.setFaultDetail("");
                    msg.setFaultString("");
                    msg.updateMetaDataInDB(db, dbConnection);

                    // Märgime saatja andmebaasis, et sõnum on saatmisel
                    DhlMessage.calculateAndUpdateMessageStatus(msg.getId(), db, dbConnection);
                } catch (Exception ex1) {
                    ErrorLog errorLog = new ErrorLog(ex1, "dvk.client.Client" + " SendUnsentMessages");
                    if (msg != null) {
                        errorLog.setOrganizationCode(msg.getSenderOrgCode());
                        errorLog.setUserCode(msg.getSenderPersonCode());
                    }

                    errorLog.setMessageId(msg.getId());
                    LoggingService.logError(errorLog);
                    System.out.println("    Sõnumite saatmisel tekkis viga: " + ex1.getMessage());
                    if (msg != null) {
                        try {
                            //msg.setFilePath(originalFilePath);
                            msg.setFaultActor("local");
                            msg.setFaultString(ex1.getMessage());
                            msg.setQueryID(dvkClient.getQueryId());  // paneme sõnumile külge päringu ID
                            msg.updateMetaDataInDB(db, dbConnection);
                        } catch (Exception ex2) {
                            ErrorLog errorLog1 = new ErrorLog(ex2, "dvk.client.Client" + " SendUnsentMessages");
                            errorLog1.setOrganizationCode(msg.getSenderOrgCode());
                            errorLog1.setUserCode(msg.getSenderPersonCode());
                            errorLog1.setMessageId(msg.getId());
                            LoggingService.logError(errorLog1);
                            System.out.println("    Sõnumite saatmisel tekkis viga: " + ex2.getMessage());
                        }
                    }
                }
            }
            System.out.println("Väljuvad sõnumid saadetud!");

        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " SendUnsentMessages");
            LoggingService.logError(errorLog);
            System.out.println("    Sõnumite saatmisel tekkis viga: " + ex.getMessage());
        }
        return resultCounter;
    }

    private static void ReceiveNewMessages(UnitCredential masterCredential,
                                           OrgSettings db, Connection dbConnection) {
        logger.info("Receiving new messages.");

        try {
            // Saadetava sõnumi päisesse kantavad parameetrid
            HeaderVariables header = new HeaderVariables(
                    masterCredential.getInstitutionCode(),
                    masterCredential.getPersonalIdCode(),
                    "",
                    (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE" + masterCredential.getPersonalIdCode()));
            ReceiveDocumentsResult resultFiles = dvkClient.receiveDocuments(header, 10, masterCredential.getFolders(), masterCredential.getDivisionID(), masterCredential.getDivisionShortName(), masterCredential.getOccupationID(), masterCredential.getOccupationShortName());
            ArrayList<DhlMessage> receivedDocs = new ArrayList<DhlMessage>();
            ArrayList<DhlMessage> failedDocs = new ArrayList<DhlMessage>();

            System.out.println("    Saadud " + String.valueOf(resultFiles.documents.size()) + " dokumenti.");
            for (int i = 0; i < resultFiles.documents.size(); ++i) {
                DhlMessage message = new DhlMessage(resultFiles.documents.get(i), masterCredential);
                message.setIsIncoming(true);
                message.setSendingStatusID(Settings.Client_StatusReceived);
                message.setUnitID(masterCredential.getUnitID());
                message.setReceivedDate(new Date());
                message.setRecipientStatusID(db.getDvkSettings().getDefaultStatusID());
                message.setQueryID(dvkClient.getQueryId()); // paneme X-tee päringu ID sõnumile külge

                try {
                    if (message.addToDB(db, dbConnection) > 0) {
                        DhlMessage.extractAndSaveMessageRecipients(message, db, dbConnection);
                        receivedDocs.add(message);
                    } else {
                        failedDocs.add(message);
                    }
                } catch (Exception ex) {
                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " ReceiveNewMessages");
                    errorLog.setMessageId(message.getId());

                    if (message != null) {
                        errorLog.setOrganizationCode(message.getSenderOrgCode());
                        errorLog.setUserCode(message.getSenderPersonCode());
                    }
                    LoggingService.logError(errorLog);
                    failedDocs.add(message);
                }
            }

            // Märgime edukalt vastuvõetud dokumendid vastuvõetuks.
            if (receivedDocs.size() > 0) {
                logger.info("Annan dokumendivahetuskeskusele teada, et sain dokumendid kätte...");
                MarkDocumentsReceived(receivedDocs, masterCredential, db.getDvkSettings().getDefaultStatusID(), null, "", resultFiles.deliverySessionID, db, dbConnection);
            }

            // Teavitame dokumendivahetuskeskust dokumentidest, mille
            // vastuvõtmine ebaõnnestus.
            if ((failedDocs.size() > 0) && (db.getDvkSettings().getMarkDocumentsReceivedRequestVersion() > 1)) {
                logger.info("Teavitame dokumendivahetuskeskust dokumentidest, mille vastuvõtmine ebaõnnestus.");
                Fault clientFault = new Fault();
                clientFault.setFaultString("Error occured while saving document to database!");
                MarkDocumentsReceived(failedDocs, masterCredential, 0, clientFault, "", resultFiles.deliverySessionID, db, dbConnection);
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " ReceiveNewMessages");
            LoggingService.logError(errorLog);
            System.out.println("Dokumentide vastuvõtmisel tekkis viga: " + ex.getMessage());
        }
    }

    private static void MarkDocumentsReceived(
            ArrayList<DhlMessage> documents,
            UnitCredential masterCredential,
            int statusID,
            Fault clientFault,
            String metaXML,
            String deliverySessionID,
            OrgSettings db,
            Connection dbConnection) {
        try {
            // Saadetava sõnumi päisesse kantavad parameetrid
            HeaderVariables header = new HeaderVariables(
                    masterCredential.getInstitutionCode(),
                    masterCredential.getPersonalIdCode(),
                    "",
                    (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE" + masterCredential.getPersonalIdCode()));

            // Käivitame päringu
            dvkClient.markDocumentsReceived(header, documents, statusID, clientFault, metaXML, deliverySessionID, false, db, dbConnection, masterCredential);
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.Client" + " MarkDocumentsReceived");
            LoggingService.logError(errorLog);
            System.out.println("    Dokumentide staatuste uuendamisel tekkis viga: " + ex.getMessage());
            return;
        }
    }

    private static void MarkDocumentsReceived(ArrayList<DhlMessage> documents, UnitCredential masterCredential, String deliverySessionID, OrgSettings db, Connection dbConnection) throws Exception {
        // Saadetava sõnumi päisesse kantavad parameetrid
        HeaderVariables header = new HeaderVariables(
                masterCredential.getInstitutionCode(),
                masterCredential.getPersonalIdCode(),
                "",
                (CommonMethods.personalIDCodeHasCountryCode(masterCredential.getPersonalIdCode()) ? masterCredential.getPersonalIdCode() : "EE" + masterCredential.getPersonalIdCode()));

        // Käivitame päringu
        dvkClient.markDocumentsReceived(header, documents, deliverySessionID, db, dbConnection, masterCredential);
    }

    protected static GetSendingOptionsV3ResponseType ReceiveDownloadWaitingInstitutionsV2(ArrayList<OrgSettings> databases) throws Exception {
        // Saadetava sõnumi päisesse kantavad parameetrid
        HeaderVariables headerVar = new HeaderVariables(
                Settings.Client_DefaultOrganizationCode,
                Settings.Client_DefaultPersonCode,
                "",
                (CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode) ? Settings.Client_DefaultPersonCode : "EE" + Settings.Client_DefaultPersonCode));

        // Käivitame päringu
        logger.debug("Käivitame päringu parameetritega:");
        logger.debug("OrganizationCode: " + headerVar.getOrganizationCode());
        logger.debug("PersonalIDCode: " + headerVar.getPersonalIDCode());
        logger.debug("PIDWithCountryCode: " + headerVar.getPIDWithCountryCode());
        logger.debug("CaseName: " + headerVar.getCaseName());

        return dvkClient.receiveDownloadWaitingOrgsV2(headerVar, databases);
    }

}
