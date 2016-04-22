package integration;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
import dvk.core.CommonMethods;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;
import org.apache.log4j.Logger;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;


public class ErrorLoggingIntegration {
    ArrayList<OrgSettings> allKnownDatabases;

    static Logger logger = Logger.getLogger(LoggingService.class.getName());

    static String errorMessage = "Error message";
    static String orgCode = "123456";
    static String userCode = "39105200028";

    public Connection setUpFromConfigFile(String path) {
        Connection connection = null;


        if ("".equals(path)) {
            logger.error("Can't find properties file");
        }

        // Load settings from config file and start using this database
        Settings.loadProperties(path);
        allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);
        try {
            connection = DBConnection.getConnection(allKnownDatabases.get(0));
        } catch (Exception ex) {
            logger.error("Can't get a connection to DB");
            logger.error(ex.getMessage());
        }
        DatabaseSessionService.getInstance().setSession(connection, allKnownDatabases.get(0));

        return connection;
    }

    @Test
    public void saveErrorLogToDB() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            Connection connection = setUpFromConfigFile(path);

            int errorLogEntryId = 0;
            String actionName = "dvk.client.src.test.integration.ErrorLoggingIntegration" + " saveErrorLogToDB";

            ErrorLog errorLog = new ErrorLog();
            errorLog.setErrorMessage(errorMessage);
            errorLog.setActionName(actionName);
            errorLog.setOrganizationCode(orgCode);
            errorLog.setUserCode(userCode);

            errorLogEntryId = LoggingService.logError(errorLog);

            Assert.assertNotSame(-1, errorLogEntryId);

            try {
                PreparedStatement preparedStatement = connection.prepareStatement(
                        "SELECT * FROM dhl_error_log WHERE dhl_error_log_id = ? ");
                preparedStatement.setInt(1, errorLogEntryId);
                ResultSet resultSet = preparedStatement.executeQuery();

                while (resultSet.next()) {
                    Assert.assertEquals(errorLogEntryId, resultSet.getInt("dhl_error_log_id"));
                    Assert.assertEquals(orgCode, resultSet.getString("organization_code"));
                    Assert.assertEquals(userCode, resultSet.getString("user_code"));
                    Assert.assertEquals(actionName, resultSet.getString("action_name"));
                    Assert.assertEquals(errorMessage, resultSet.getString("error_message"));
                }

                preparedStatement.close();
                connection.commit();
            } catch (Exception ex) {
                Assert.fail();
            } finally {
                CommonMethods.safeCloseDatabaseConnection(connection);
                DatabaseSessionService.getInstance().clearSession();
            }
        }
    }

    @Test
    public void saveErrorLogToDBWithoutConnectionToDatabase() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            Connection connection = setUpFromConfigFile(path);
            int errorLogEntryId = 0;
            String actionName = "dvk.client.src.test.integration.ErrorLoggingIntegration" +
                    " saveErrorLogToDBWithoutConnectionToDatabase";
            DatabaseSessionService.getInstance().setConnection(null);
            ErrorLog errorLog = new ErrorLog();
            errorLog.setErrorMessage(errorMessage);
            errorLog.setActionName(actionName);
            errorLog.setOrganizationCode(orgCode);
            errorLog.setUserCode(userCode);
            errorLogEntryId = LoggingService.logError(errorLog);
            Assert.assertEquals(-1, errorLogEntryId);
        }


    }

    @Test
    public void saveErrorLogToDBWithoutOrgSettings() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            Connection connection = setUpFromConfigFile(path);
            int errorLogEntryId = 0;
            String actionName = "dvk.client.src.test.integration.ErrorLoggingIntegration" + " saveErrorLogToDBWithoutOrgSettings";
            DatabaseSessionService.getInstance().setOrgSettings(null);
            ErrorLog errorLog = new ErrorLog();
            errorLog.setErrorMessage(errorMessage);
            errorLog.setActionName(actionName);
            errorLog.setOrganizationCode(orgCode);
            errorLog.setUserCode(userCode);
            errorLogEntryId = LoggingService.logError(errorLog);
            Assert.assertEquals(-1, errorLogEntryId);
        }


    }

    @Test
    public void saveErrorLogToDBWithoutAnErrorMessage() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            Connection connection = setUpFromConfigFile(path);

            int errorLogEntryId = 0;
            String actionName = "dvk.client.src.test.integration.ErrorLoggingIntegration" + " saveErrorLogToDBWithoutAnErrorMessage";
            ErrorLog errorLog = new ErrorLog();
            errorLog.setErrorMessage(null);
            errorLog.setActionName(actionName);
            errorLog.setOrganizationCode(orgCode);
            errorLog.setUserCode(userCode);
            errorLogEntryId = LoggingService.logError(errorLog);
            Assert.assertEquals(-1, errorLogEntryId);
        }
    }
}
