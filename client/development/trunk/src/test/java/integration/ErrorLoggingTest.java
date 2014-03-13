package integration;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Settings;
import junit.framework.Assert;
import org.junit.Before;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;


public class ErrorLoggingTest {
    OrgSettings currentDbConf;
    ArrayList<OrgSettings> allKnownDatabases;
    Connection connection;

    static String errorMessage = "Error message";
    static String orgCode = "123456";
    static String userCode = "39105200028";

    @Before
    public void setUpFromConfigFile() {
        String configFile = ClientRequestsTest.class.getResource("../dvk_client_postgreSQL.properties").getPath();

        if (configFile == "") {
            System.out.println("Can't find properties file");
        }

        // Load settings from config file and start using this database
        Settings.loadProperties(configFile);
        allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);
        try {
            connection = DBConnection.getConnection(allKnownDatabases.get(0));
        } catch (Exception ex) {
            System.out.println("Can't get a connection to DB");
        }
        DatabaseSessionService.getInstance().setSession(connection, allKnownDatabases.get(0));
    }

    @Test
    public void saveErrorLogToDB() {
        int errorLogEntryId = 0;
        String actionName = "dvk.client.src.test.integration.ErrorLoggingTest" + " saveErrorLogToDB";

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
//                Assert.assertEquals(errorLog.getErrorDateTime(), resultSet.getTimestamp("error_datetime"));
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

    @Test
    public void saveErrorLogToDBWithoutConnectionToDatabase() {
        int errorLogEntryId = 0;
        String actionName = "dvk.client.src.test.integration.ErrorLoggingTest" +
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

    @Test
    public void saveErrorLogToDBWithoutOrgSettings() {
        int errorLogEntryId = 0;
        String actionName = "dvk.client.src.test.integration.ErrorLoggingTest" + " saveErrorLogToDBWithoutOrgSettings";

        DatabaseSessionService.getInstance().setOrgSettings(null);

        ErrorLog errorLog = new ErrorLog();
        errorLog.setErrorMessage(errorMessage);
        errorLog.setActionName(actionName);
        errorLog.setOrganizationCode(orgCode);
        errorLog.setUserCode(userCode);

        errorLogEntryId = LoggingService.logError(errorLog);
        Assert.assertEquals(-1, errorLogEntryId);
    }

    @Test
    public void saveErrorLogToDBWithoutAnErrorMessage() {
        int errorLogEntryId = 0;
        String actionName = "dvk.client.src.test.integration.ErrorLoggingTest" + " saveErrorLogToDBWithoutAnErrorMessage";

        ErrorLog errorLog = new ErrorLog();
        errorLog.setErrorMessage(null);
        errorLog.setActionName(actionName);
        errorLog.setOrganizationCode(orgCode);
        errorLog.setUserCode(userCode);

        errorLogEntryId = LoggingService.logError(errorLog);
        Assert.assertEquals(-1, errorLogEntryId);
    }
}
