package ee.ria.dvk.client.testutil;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import org.apache.log4j.Logger;

import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.Settings;

/**
 * Meant for only parsing the integrationTestConfigs.properties file to get all the
 * integration test database configurations that are configured by profiles.
 * @author Hendrik Pärna
 * @since 13.03.14
 */
public class IntegrationTestsConfigUtil {
    private static Logger logger = Logger.getLogger(IntegrationTestsConfigUtil.class);
    private static final String TEST_CONFIGS_POSITIVE_CASES = "listOfTestConfigs";
    private static final String TEST_CONFIG_CONVERSION_CASE = "conversionTestConfig";
    private static final String TEST_CONFIGS_SERVER_MISSING = "serverIsMissingConfigs";
    private static final String TEST_CONFIGS_POSITIVE_CASES_CONTAINER_VERSION_1_0 = "containerVer1Configs";
    private static final String TEST_CONFIGS_POSITIVE_CASES_CONTAINER_VERSION_2_1_FRAGMENTING = "containerVer2_1FragmentingConfigs";
    private static final String TEST_CONFIGS_POSITIVE_CASES_CONTAINER_VERSION_1_0_FRAGMENTING = "containerVer1FragmentingConfigs";

    private IntegrationTestsConfigUtil() {
        //because its a utility class
    }

    private static List<String> getAllConfigFileNames(String configProperty) {
        List<String> configFileNames = new ArrayList<String>();

        Properties properties = findPropertiesFile();

        String listOfTestConfigs = properties.getProperty(configProperty);

        if (listOfTestConfigs != null) {
           if (listOfTestConfigs.contains(",")) {
               for (String confFile: listOfTestConfigs.split(",")) {
                  configFileNames.add(confFile.trim());
               }
           } else {
               configFileNames.add(listOfTestConfigs.trim());
           }
        }

        return configFileNames;
    }

    @SuppressWarnings("ConstantConditions")
    public static List<String> getAllConfigFilesAbsolutePaths(String configProperty) {
        List<String> results = new ArrayList<String>();

        for (String configFileName: getAllConfigFileNames(configProperty)) {
            results.add(IntegrationTestsConfigUtil.class.getClassLoader().getResource(configFileName).getPath());
        }

        return results;
    }

    public static List<String> getAllConfigFilesAbsolutePathsForPositiveCases() {
        return getAllConfigFilesAbsolutePaths(TEST_CONFIGS_POSITIVE_CASES);
    }

    public static List<String> getConfigFileAbsolutePathForConversionCase() {
        return getAllConfigFilesAbsolutePaths(TEST_CONFIG_CONVERSION_CASE);
    }

    public static List<String> getAllConfigFilesAbsolutePathsForNegativeCases() {
        return getAllConfigFilesAbsolutePaths(TEST_CONFIGS_SERVER_MISSING);
    }

    public static List<String> getAllConfigFilesAbsolutePathsForPositiveCasesContainerVer1() {
        return getAllConfigFilesAbsolutePaths(TEST_CONFIGS_POSITIVE_CASES_CONTAINER_VERSION_1_0);
    }

    public static List<String> getAllConfigFilesAbsolutePathsForPositiveCasesContainerVer2_1UsingFragmenting() {
        return getAllConfigFilesAbsolutePaths(TEST_CONFIGS_POSITIVE_CASES_CONTAINER_VERSION_2_1_FRAGMENTING);
    }

    public static List<String> getAllConfigFilesAbsolutePathsForPositiveCasesContainerVer1UsingFragmenting() {
        return getAllConfigFilesAbsolutePaths(TEST_CONFIGS_POSITIVE_CASES_CONTAINER_VERSION_1_0_FRAGMENTING);
    }

    private static Properties findPropertiesFile() {
        Properties properties = new Properties();
        try {
            properties.load(IntegrationTestsConfigUtil.class.
                    getClassLoader().getResourceAsStream("conf/integrationTestConfigs.properties"));
        } catch (IOException e) {
            logger.error("Unable to load properties file for integration tests", e);
            throw new RuntimeException("Unable to load properties file for integration tests", e);
        }
        return  properties;
    }

    public static void setUpFromTheConfigurationFile(String configFile) throws Exception {
        try {
            if (configFile.equalsIgnoreCase("")) {
                throw new Exception("The configuration file is null");
            }
            // Load settings from the configuration file and start to use this database
            Settings.loadProperties(configFile);
            ArrayList<OrgSettings> allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);
            Connection connection = DBConnection.getConnection(allKnownDatabases.get(0));
            DatabaseSessionService.getInstance().setSession(connection, allKnownDatabases.get(0));
        } catch (Exception ex) {
            logger.error("Can't connect to the database");
            throw new RuntimeException(ex);
        }
    }
}
