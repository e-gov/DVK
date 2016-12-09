package integration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.junit.Test;

import dvk.client.businesslayer.RequestLog;
import dvk.client.businesslayer.ResponseStatus;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
import dvk.core.CommonMethods;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;

public class RequestLoggingIntegration {
    ArrayList<OrgSettings> allKnownDatabases;

    static String requestName = "Request name";
    static String orgCode = "123456";
    static String userCode = "39105200028";
    static String response = ResponseStatus.OK.toString();

    static Logger logger = Logger.getLogger(RequestLoggingIntegration.class.getName());

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
        }
        DatabaseSessionService.getInstance().setSession(connection, allKnownDatabases.get(0));

        return connection;
    }

    @Test
    public void saveRequestLogToDB() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            Connection connection = setUpFromConfigFile(path);

            int requestLogEntryId = 0;

            RequestLog requestLog = new RequestLog();
            requestLog.setRequestName(requestName);
            requestLog.setOrganizationCode(orgCode);
            requestLog.setUserCode(userCode);
            requestLog.setResponse(response);

            requestLogEntryId = LoggingService.logRequest(requestLog);
            Assert.assertNotSame(-1, requestLogEntryId);

            try {
                PreparedStatement preparedStatement = connection.prepareStatement(
                        "SELECT * FROM dhl_request_log WHERE dhl_request_log_id = ? ");
                preparedStatement.setInt(1, requestLogEntryId);
                ResultSet resultSet = preparedStatement.executeQuery();

                while (resultSet.next()) {
                    Assert.assertEquals(requestLogEntryId, resultSet.getInt("dhl_request_log_id"));
                    Assert.assertEquals(orgCode, resultSet.getString("organization_code"));
                    Assert.assertEquals(userCode, resultSet.getString("user_code"));
                    Assert.assertEquals(requestName, resultSet.getString("request_name"));
                    Assert.assertEquals(response, resultSet.getString("response"));
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
    public void saveRequestLogToDBWithoutConnectionToDatabase() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            setUpFromConfigFile(path);
            int requestLogEntryId = 0;
            RequestLog requestLog = new RequestLog();
            requestLog.setRequestName(requestName);
            requestLog.setOrganizationCode(orgCode);
            requestLog.setUserCode(userCode);
            requestLog.setResponse(response);
            DatabaseSessionService.getInstance().setConnection(null);
            requestLogEntryId = LoggingService.logRequest(requestLog);
            Assert.assertEquals(-1, requestLogEntryId);
        }
    }

    @Test
    public void saveRequestLogToDBWithoutOrgSettings() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            setUpFromConfigFile(path);
            int requestLogEntryId = 0;
            RequestLog requestLog = new RequestLog();
            requestLog.setRequestName(requestName);
            requestLog.setOrganizationCode(orgCode);
            requestLog.setUserCode(userCode);
            requestLog.setResponse(response);
            DatabaseSessionService.getInstance().setOrgSettings(null);
            requestLogEntryId = LoggingService.logRequest(requestLog);
            Assert.assertEquals(-1, requestLogEntryId);
        }
    }

    @Test
    public void saveRequestLogWithoutARequestName() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            setUpFromConfigFile(path);
            int requestLogEntryId = 0;
            RequestLog requestLog = new RequestLog();
            requestLog.setRequestName(null);
            requestLog.setOrganizationCode(orgCode);
            requestLog.setUserCode(userCode);
            requestLog.setResponse(response);
            requestLogEntryId = LoggingService.logRequest(requestLog);
            Assert.assertEquals(-1, requestLogEntryId);
        }
    }

    @Test
    public void saveRequestLogWithoutAnOrganizationCode() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            setUpFromConfigFile(path);
            int requestLogEntryId = 0;
            RequestLog requestLog = new RequestLog();
            requestLog.setRequestName(requestName);
            requestLog.setOrganizationCode(null);
            requestLog.setUserCode(userCode);
            requestLog.setResponse(response);
            requestLogEntryId = LoggingService.logRequest(requestLog);
            Assert.assertEquals(-1, requestLogEntryId);
        }
    }
}
