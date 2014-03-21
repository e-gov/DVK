package ee.ria.dvk.client.testutil;

import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

/**
 * Meant for only parsing the integrationTestConfigs.properties file to get all the
 * integration test database configurations that are configured by profiles.
 * @author Hendrik Pärna
 * @since 13.03.14
 */
public class IntegrationTestsConfigUtil {
    private static Logger logger = Logger.getLogger(IntegrationTestsConfigUtil.class);
    private static final String TEST_CONFIGS_POSITIVE_CASES = "listOfTestConfigs";
    private static final String TEST_CONFIGS_SERVER_MISSING = "serverIsMissingConfigs";

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

    public static List<String> getAllConfigFilesAbsolutePathsForNegativeCases() {
        return getAllConfigFilesAbsolutePaths(TEST_CONFIGS_SERVER_MISSING);
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
}
