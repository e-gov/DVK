package dvk.core;

import java.io.FileInputStream;
import java.io.InputStream;
import java.util.Properties;

import org.apache.log4j.Logger;

public class Settings {
	
	private static final Logger logger = Logger.getLogger(Settings.class.getName());

    private static final int SERVER_DEFAULT_DOCUMENT_DEFAULT_LIFETIME = 30;
    private static final int SERVER_DEFAULT_EXPIRED_DOCUMENT_GRACE_PERIOD = 1;
    private static final int SERVER_DEFAULT_CENTRAL_RIGHTS_DATABASE_SYNC_PERIOD = 120;
    private static final String SERVER_DEFAULT_PRODUCER_NAME = "dhl";
    
    private static final long CLIENT_DEFAULT_FRAGMENT_SIZE_BYTES = 1024 * 1024 * 10;
    private static final String CLIENT_DEFAULT_PRODUCER_NAME = "dhl";
    private static final String CLIENT_DEFAULT_ADIT_PROCUCER_NAME = "adit";
    private static final String CLIENT_DEFAULT_ADIT_INFORMATION_SYSTEM_NAME = "DHS";
    
    // X-Road protocol version 4.0 related default settings
    private static final String XROAD_DEFAULT_INSTANCE = "EE";
	private static final String XROAD_DEFAULT_MEMBER_CLASS = "GOV";
	private static final String XROAD_DEFAULT_MEMBER_CODE = "70006317";
	private static final String XROAD_DEFAULT_SUBSYSTEM_CODE = "dhl";

    public static Properties currentProperties;

    public static int Client_StatusWaiting = 1;
    public static int Client_StatusSending = 2;
    public static int Client_StatusSent = 3;
    public static int Client_StatusCanceled = 4;
    public static int Client_StatusReceived = 5;
    public static int Client_SentMessageStatusFollowupDays = 30;
    public static String Client_ConfigFile = "config.xml";
    public static String Client_ServiceUrl = "";
    public static boolean Client_IntegratedAmphoraFunctions = false;
    public static String Client_ProducerName = CLIENT_DEFAULT_PRODUCER_NAME;
    public static long Client_FragmentSizeBytes = CLIENT_DEFAULT_FRAGMENT_SIZE_BYTES;
    public static boolean Client_UseFragmenting = false;
    public static int Client_SentMessageDefaultLifetime = Client_SentMessageStatusFollowupDays;
    public static String Client_DefaultOrganizationCode;
    public static String Client_DefaultPersonCode;
    public static String Client_SpecificationVersion = "1.6";
    public static String Client_KeyStoreFile = "";
    public static String Client_KeyStorePassword = "";
    public static String Client_KeyStoreType = "";
    public static String Client_TrustStoreFile = "";
    public static String Client_TrustStorePassword = "";
    public static String Client_TrustStoreType = "";
    public static String Client_AditProducerName = CLIENT_DEFAULT_ADIT_PROCUCER_NAME;
    public static String CLIENT_ADIT_INFORMATION_SYSTEM_NAME = CLIENT_DEFAULT_ADIT_INFORMATION_SYSTEM_NAME;

    // Server settings
    public static String Server_DatabaseEnvironmentVariable = "jdbc/dhloracle";
    public static String Server_ProducerName = SERVER_DEFAULT_PRODUCER_NAME;
    public static int Server_DocumentDefaultLifetime = SERVER_DEFAULT_DOCUMENT_DEFAULT_LIFETIME;
    public static int Server_ExpiredDocumentGracePeriod = SERVER_DEFAULT_EXPIRED_DOCUMENT_GRACE_PERIOD;
    public static boolean Server_UseCentralRightsDatabase = false;
    public static String Server_CentralRightsDatabaseURL = "";
    public static String Server_CentralRightsDatabaseOrgCode = "";
    public static String Server_CentralRightsDatabasePersonCode = "";
    public static int Server_CentralRightsDatabaseSyncPeriod = SERVER_DEFAULT_CENTRAL_RIGHTS_DATABASE_SYNC_PERIOD;
    public static boolean Server_RunOnClientDatabase = false;
    public static boolean Server_ValidateContainer = false;
    public static String Server_ValidationSchemaFile = "";
    public static boolean Server_IgnoreInvalidContainers = false;
    public static boolean Server_ValidateXmlFiles = false;
    public static boolean Server_ValidateSignatures = false;
    public static boolean Server_DocumentSenderMustMatchXroadHeader = true;
    public static boolean Server_AutoRegisterUnknownSenders = false;
    public static String serverJdigidocConfigLocation = "jar://jdigidoc.cfg";
    
    // X-Road protocol version 4.0 settings
    public static String xRoadInstance = XROAD_DEFAULT_INSTANCE;
	public static String xRoadMemberClass = XROAD_DEFAULT_MEMBER_CLASS;
	public static String xRoadMemberCode = XROAD_DEFAULT_MEMBER_CODE;
	public static String xRoadSubsystemCode = XROAD_DEFAULT_SUBSYSTEM_CODE;

    // General settings (both client and server)
    public static boolean LogErrors = false;
    public static String ErrorLogFile = "error_log.txt";
    public static String PerformanceLogFile = "";

    // Test client settings
    public static String Test_LogFile = "";


    public static int getBinaryBufferSize() {
        int defValue = 100000;
        try {
            if ((currentProperties != null) && (currentProperties.getProperty("binary_buffer_size") != null)) {
                int result = Integer.parseInt(currentProperties.getProperty("binary_buffer_size"));
                return (result > 0) ? result : defValue;
            } else {
                return defValue;
            }
        } catch (Exception ex) {
        	logger.error(ex);
            return defValue;
        }
    }

    public static int getDBBufferSize() {
        int defValue = 100000;
        try {
            if ((currentProperties != null) && (currentProperties.getProperty("database_buffer_size") != null)) {
                int result = Integer.parseInt(currentProperties.getProperty("database_buffer_size"));
                return (result > 0) ? result : defValue;
            } else {
                return defValue;
            }
        } catch (Exception ex) {
        	logger.error(ex);
            return defValue;
        }
    }

    public static int getClientStatusWaitingID() {
        int defValue = 1;
        try {
            if ((currentProperties != null) && (currentProperties.getProperty("client_status_waiting_id") != null)) {
                int result = Integer.parseInt(currentProperties.getProperty("client_status_waiting_id"));
                return (result > 0) ? result : defValue;
            } else {
                return defValue;
            }
        } catch (Exception ex) {
        	logger.error(ex);
            return defValue;
        }
    }

    public static boolean loadProperties(String configFileName) {
        InputStream propertyFile = null;
        currentProperties = new Properties();

        try {
            propertyFile = new FileInputStream(configFileName);
            currentProperties.load(propertyFile);
            extractSettings();
        } catch (Exception ex) {
        	logger.error(ex);
            return false;
        } finally {
            CommonMethods.safeCloseStream(propertyFile);
            propertyFile = null;
        }

        return true;
    }

    private static void extractSettings() {
        try {
            Client_ConfigFile = currentProperties.getProperty("client_config_file", "client_config.xml");
            Client_ServiceUrl = currentProperties.getProperty("client_service_url");

            if (currentProperties.getProperty("client_status_waiting_id") != null) {
                Client_StatusWaiting = Integer.parseInt(currentProperties.getProperty("client_status_waiting_id"));
            }
            if (currentProperties.getProperty("client_status_sending_id") != null) {
                Client_StatusSending = Integer.parseInt(currentProperties.getProperty("client_status_sending_id"));
            }
            if (currentProperties.getProperty("client_status_sent_id") != null) {
                Client_StatusSent = Integer.parseInt(currentProperties.getProperty("client_status_sent_id"));
            }
            if (currentProperties.getProperty("client_status_canceled_id") != null) {
                Client_StatusCanceled = Integer.parseInt(currentProperties.getProperty("client_status_canceled_id"));
            }
            if (currentProperties.getProperty("client_status_received_id") != null) {
                Client_StatusReceived = Integer.parseInt(currentProperties.getProperty("client_status_received_id"));
            }

            if ((currentProperties.getProperty("client_integrated_amphora_functions") != null)
                    && (currentProperties.getProperty("client_integrated_amphora_functions").equalsIgnoreCase("yes")
                        || currentProperties.getProperty("client_integrated_amphora_functions").equalsIgnoreCase("true")
                        || currentProperties.getProperty("client_integrated_amphora_functions").equalsIgnoreCase("1"))) {
                Client_IntegratedAmphoraFunctions = true;
            }

            if (currentProperties.getProperty("client_producer_name") != null) {
                Client_ProducerName = currentProperties.getProperty("client_producer_name");
            }

            if (currentProperties.getProperty("adit_producer_name") != null) {
                Client_AditProducerName = currentProperties.getProperty("adit_producer_name");
            }

            try {
                Client_SentMessageStatusFollowupDays = Integer.parseInt(
                        currentProperties.getProperty("client_sent_message_status_followup_days"));
            } catch (Exception ex1) {
                Client_SentMessageStatusFollowupDays = 30;
            }

            // Kliendi poolelt saadetav säilitustähtaeg
            try {
                if (currentProperties.getProperty("client_sent_message_lifetime_days") != null) {
                   Client_SentMessageDefaultLifetime = Integer.parseInt(currentProperties.getProperty("client_sent_message_lifetime_days"));
                } else {
                    Client_SentMessageDefaultLifetime = Client_SentMessageStatusFollowupDays;
                }
            } catch (Exception ex1) {
                Client_SentMessageDefaultLifetime = Client_SentMessageStatusFollowupDays;
            }

            // Kliendipoolsed fragmenteerimise seaded
            if ((currentProperties.getProperty("client_use_fragmenting") != null)
                    && (currentProperties.getProperty("client_use_fragmenting").equalsIgnoreCase("yes")
                        || currentProperties.getProperty("client_use_fragmenting").equalsIgnoreCase("true")
                        || currentProperties.getProperty("client_use_fragmenting").equalsIgnoreCase("1"))) {
                Client_UseFragmenting = true;
            }
            if (currentProperties.getProperty("client_fragment_size_bytes") != null) {
                try {
                    Client_FragmentSizeBytes = Long.parseLong(currentProperties.getProperty("client_fragment_size_bytes"));
                } catch (Exception ex1) {
                    Client_FragmentSizeBytes = CLIENT_DEFAULT_FRAGMENT_SIZE_BYTES;
                }
            }

            // Edastamise seaded
            if (currentProperties.getProperty("client_default_org_code") != null) {
                Client_DefaultOrganizationCode = currentProperties.getProperty("client_default_org_code");
            }
            if (currentProperties.getProperty("client_default_person_code") != null) {
                Client_DefaultPersonCode = currentProperties.getProperty("client_default_person_code");
            }

            // Kliendi poolt vaikimisi eeldatav spetsifikatsiooni versioon
            if (currentProperties.getProperty("client_specification_version") != null) {
                Client_SpecificationVersion = currentProperties.getProperty(
                        "client_specification_version").replaceAll(",", ".");
            }

			// SSL keystore andmed
			if (currentProperties.getProperty("client_keystore_file") != null) {
                Client_KeyStoreFile = currentProperties.getProperty("client_keystore_file");
            }
			if (currentProperties.getProperty("client_keystore_password") != null) {
                Client_KeyStorePassword = currentProperties.getProperty("client_keystore_password");
            }
			if (currentProperties.getProperty("client_keystore_type") != null) {
                Client_KeyStoreType = currentProperties.getProperty("client_keystore_type");
            }
			if (currentProperties.getProperty("client_truststore_file") != null) {
                Client_TrustStoreFile = currentProperties.getProperty("client_truststore_file");
            }
			if (currentProperties.getProperty("client_truststore_password") != null) {
                Client_TrustStorePassword = currentProperties.getProperty("client_truststore_password");
            }
			if (currentProperties.getProperty("client_truststore_type") != null) {
                Client_TrustStoreType = currentProperties.getProperty("client_truststore_type");
            }

            if (currentProperties.getProperty("client_adit_information_system_name") != null) {
                CLIENT_ADIT_INFORMATION_SYSTEM_NAME = currentProperties.getProperty("client_adit_information_system_name");
            }

            // Serveri seaded
            if (currentProperties.getProperty("server_producer_name") != null) {
                Server_ProducerName = currentProperties.getProperty("server_producer_name");
            }
            if (currentProperties.getProperty("server_database_environment_variable") != null) {
                Server_DatabaseEnvironmentVariable = currentProperties.getProperty("server_database_environment_variable");
            }

            // Dokumendi vaikimisi säilitustähtaeg serveris
            try {
                if (currentProperties.getProperty("server_document_default_lifetime") != null) {
                    Server_DocumentDefaultLifetime = Integer.parseInt(
                            currentProperties.getProperty("server_document_default_lifetime"));
                    Server_DocumentDefaultLifetime = (Server_DocumentDefaultLifetime > 0)
                            ? Server_DocumentDefaultLifetime : SERVER_DEFAULT_DOCUMENT_DEFAULT_LIFETIME;
                }
            } catch (Exception ex1) {
                Server_DocumentDefaultLifetime = SERVER_DEFAULT_DOCUMENT_DEFAULT_LIFETIME;
            }

            try {
                if (currentProperties.getProperty("server_expired_document_grace_period") != null) {
                    Server_ExpiredDocumentGracePeriod = Integer.parseInt(
                            currentProperties.getProperty("server_expired_document_grace_period"));
                    Server_ExpiredDocumentGracePeriod = (Server_ExpiredDocumentGracePeriod > 0)
                            ? Server_ExpiredDocumentGracePeriod : SERVER_DEFAULT_EXPIRED_DOCUMENT_GRACE_PERIOD;
                }
            } catch (Exception ex1) {
                Server_ExpiredDocumentGracePeriod = SERVER_DEFAULT_EXPIRED_DOCUMENT_GRACE_PERIOD;
            }

            if ((currentProperties.getProperty("server_validate_container") != null)
                    && (currentProperties.getProperty("server_validate_container").equalsIgnoreCase("yes")
                        || currentProperties.getProperty("server_validate_container").equalsIgnoreCase("true")
                        || currentProperties.getProperty("server_validate_container").equalsIgnoreCase("1"))) {
                Server_ValidateContainer = true;
            }
            if (currentProperties.getProperty("server_validation_schema_file") != null) {
                Server_ValidationSchemaFile = currentProperties.getProperty("server_validation_schema_file");
            }
            if ((currentProperties.getProperty("server_ignore_invalid_containers") != null)
                    && (currentProperties.getProperty("server_ignore_invalid_containers").equalsIgnoreCase("yes")
                        || currentProperties.getProperty("server_ignore_invalid_containers").equalsIgnoreCase("true")
                        || currentProperties.getProperty("server_ignore_invalid_containers").equalsIgnoreCase("1"))) {
                Server_IgnoreInvalidContainers = true;
            }

            // Kas saadetavaid XML faile valideeritakse?
            if ((currentProperties.getProperty("server_validate_xml_files") != null)
                    &&
                (currentProperties.getProperty("server_validate_xml_files").equalsIgnoreCase("yes")
                        ||
                currentProperties.getProperty("server_validate_xml_files").equalsIgnoreCase("true")
                        ||
                currentProperties.getProperty("server_validate_xml_files").equalsIgnoreCase("1"))) {
                Server_ValidateXmlFiles = true;
            }

            // Kas digiallkirjastatud dokuimentide allkirjade kehtivust kontrollitakse?
            if ((currentProperties.getProperty("server_validate_signatures") != null)
                    && (currentProperties.getProperty("server_validate_signatures").equalsIgnoreCase("yes")
                        || currentProperties.getProperty("server_validate_signatures").equalsIgnoreCase("true")
                        || currentProperties.getProperty("server_validate_signatures").equalsIgnoreCase("1"))) {
                Server_ValidateSignatures = true;
            }

            // Kas dokumendi saatjaks märgitud asutus peab olema sama, mis x-tee päistes sõnumi saatjaks märgitud asutus?
            if ((currentProperties.getProperty("server_document_sender_must_match_xroad_header") != null)
                    && (currentProperties.getProperty("server_document_sender_must_match_xroad_header").equalsIgnoreCase("no")
                        || currentProperties.getProperty("server_document_sender_must_match_xroad_header").equalsIgnoreCase("false")
                        || currentProperties.getProperty("server_document_sender_must_match_xroad_header").equalsIgnoreCase("0"))) {
                Server_DocumentSenderMustMatchXroadHeader = false;
            }

            // Should the server automatically register senders that are not found in organization database?
            if ((currentProperties.getProperty("server_auto_register_unknown_senders") != null)
                    && (currentProperties.getProperty("server_auto_register_unknown_senders").equalsIgnoreCase("yes")
                    || currentProperties.getProperty("server_auto_register_unknown_senders").equalsIgnoreCase("true")
                    || currentProperties.getProperty("server_auto_register_unknown_senders").equalsIgnoreCase("1"))) {
                Server_AutoRegisterUnknownSenders = true;
            }


            // Õiguste haldamise kesksüsteemi kasutamine
            if ((currentProperties.getProperty("server_use_central_rights_database") != null)
                    && (currentProperties.getProperty("server_use_central_rights_database").equalsIgnoreCase("yes")
                    || currentProperties.getProperty("server_use_central_rights_database").equalsIgnoreCase("true")
                    || currentProperties.getProperty("server_use_central_rights_database").equalsIgnoreCase("1"))) {
                Server_UseCentralRightsDatabase = true;
            }
            if (currentProperties.getProperty("server_rights_database_url") != null) {
                Server_CentralRightsDatabaseURL = currentProperties.getProperty("server_rights_database_url");
            }
            if (currentProperties.getProperty("server_rights_database_org_code") != null) {
                Server_CentralRightsDatabaseOrgCode = currentProperties.getProperty("server_rights_database_org_code");
            }
            if (currentProperties.getProperty("server_rights_database_person_code") != null) {
                Server_CentralRightsDatabasePersonCode = currentProperties.getProperty("server_rights_database_person_code");
            }
            try {
                if (currentProperties.getProperty("server_rights_database_sync_period") != null) {
                    Server_CentralRightsDatabaseSyncPeriod = Integer.parseInt(
                            currentProperties.getProperty("server_rights_database_sync_period"));
                    Server_CentralRightsDatabaseSyncPeriod =
                            (Server_CentralRightsDatabaseSyncPeriod > 0)
                                    ? Server_CentralRightsDatabaseSyncPeriod : SERVER_DEFAULT_CENTRAL_RIGHTS_DATABASE_SYNC_PERIOD;
                }
            } catch (Exception ex1) {
                Server_CentralRightsDatabaseSyncPeriod = SERVER_DEFAULT_CENTRAL_RIGHTS_DATABASE_SYNC_PERIOD;
            }

            // Serveri jooksutamine kliendi andmebaasi peal
            if ((currentProperties.getProperty("server_run_on_client_database") != null)
                    && (currentProperties.getProperty("server_run_on_client_database").equalsIgnoreCase("yes")
                    || currentProperties.getProperty("server_run_on_client_database").equalsIgnoreCase("true")
                    || currentProperties.getProperty("server_run_on_client_database").equalsIgnoreCase("1"))) {
                Server_RunOnClientDatabase = true;
            }

            // X-Road protocol configurations
            if (currentProperties.getProperty("xRoad.instance") != null) {
            	xRoadInstance = currentProperties.getProperty("xRoad.instance");	
            }
            if (currentProperties.getProperty("xRoad.memberClass") != null) {
            	xRoadMemberClass = currentProperties.getProperty("xRoad.memberClass");	
            }
            if (currentProperties.getProperty("xRoad.memberCode") != null) {
            	xRoadMemberCode = currentProperties.getProperty("xRoad.memberCode");	
            }
            if (currentProperties.getProperty("xRoad.subsystemCode") != null) {
            	xRoadSubsystemCode = currentProperties.getProperty("xRoad.subsystemCode");	
            }
            
            // Üldkasutatavad seaded
            if ((currentProperties.getProperty("log_errors") != null)
                    && (currentProperties.getProperty("log_errors").equalsIgnoreCase("yes")
                    || currentProperties.getProperty("log_errors").equalsIgnoreCase("true")
                    || currentProperties.getProperty("log_errors").equalsIgnoreCase("1"))) {
                        LogErrors = true;
            }
            if (currentProperties.getProperty("error_log_file") != null) {
                ErrorLogFile = currentProperties.getProperty("error_log_file");
            }
            if (currentProperties.getProperty("performance_log_file") != null) {
                PerformanceLogFile = currentProperties.getProperty("performance_log_file");
            }

            // Testkliendi seaded
            if (currentProperties.getProperty("test_log_file") != null) {
                Test_LogFile = currentProperties.getProperty("test_log_file");
            }

            logger.debug("server_jdigidoc_config_location conf value: " + currentProperties.getProperty("server_jdigidoc_config_location"));
            if (currentProperties.getProperty("server_jdigidoc_config_location") != null) {
                serverJdigidocConfigLocation = currentProperties.getProperty("server_jdigidoc_config_location");
            }
        } catch (Exception ex) {
        	logger.error(ex);
        }
    }

	public static String getXRoadInstance() {
		return xRoadInstance;
	}

	public static String getXRoadMemberClass() {
		return xRoadMemberClass;
	}

	public static String getxRoadMemberCode() {
		return xRoadMemberCode;
	}

	public static String getXRoadSubsystemCode() {
		return xRoadSubsystemCode;
	}
	
}
