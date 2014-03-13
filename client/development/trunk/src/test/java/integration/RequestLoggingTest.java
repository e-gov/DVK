package integration;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.businesslayer.RequestLog;
import dvk.client.businesslayer.ResponseStatus;
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
import java.util.ArrayList;

public class RequestLoggingTest {
    OrgSettings currentDbConf;
    ArrayList<OrgSettings> allKnownDatabases;
    Connection connection;

    static String requestName = "Request name";
    static String orgCode = "123456";
    static String userCode = "39105200028";
    static String response = ResponseStatus.OK.toString();
//    static int errorLogId = 56;

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
    public void saveRequestLogToDB() {
        int requestLogEntryId = 0;

        RequestLog requestLog = new RequestLog();
        requestLog.setRequestName(requestName);
        requestLog.setOrganizationCode(orgCode);
        requestLog.setUserCode(userCode);
        requestLog.setResponse(response);
//        requestLog.setErrorLogId(2);

        requestLogEntryId = LoggingService.logRequest(requestLog);
        Assert.assertNotSame(-1, requestLogEntryId);

        try {
            PreparedStatement preparedStatement = connection.prepareStatement(
                    "SELECT * FROM dhl_request_log WHERE dhl_request_log_id = ? ");
            preparedStatement.setInt(1, requestLogEntryId);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {
                Assert.assertEquals(requestLogEntryId, resultSet.getInt("dhl_request_log_id"));
//                Assert.assertEquals(requestLog.getRequestDateTime(), resultSet.getTimestamp("request_datetime"));
                Assert.assertEquals(orgCode, resultSet.getString("organization_code"));
                Assert.assertEquals(userCode, resultSet.getString("user_code"));
                Assert.assertEquals(requestName, resultSet.getString("request_name"));
                Assert.assertEquals(response, resultSet.getString("response"));
//                Assert.assertEquals(errorLogId, resultSet.getInt("dhl_error_log_id"));
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
    public void saveRequestLogToDBWithoutConnectionToDatabase() {
        int requestLogEntryId = 0;

        RequestLog requestLog = new RequestLog();
        requestLog.setRequestName(requestName);
        requestLog.setOrganizationCode(orgCode);
        requestLog.setUserCode(userCode);
        requestLog.setResponse(response);
//        requestLog.setErrorLogId(errorLogId);

        DatabaseSessionService.getInstance().setConnection(null);

        requestLogEntryId = LoggingService.logRequest(requestLog);
        Assert.assertEquals(-1, requestLogEntryId);
    }

    @Test
    public void saveRequestLogToDBWithoutOrgSettings() {
        int requestLogEntryId = 0;

        RequestLog requestLog = new RequestLog();
        requestLog.setRequestName(requestName);
        requestLog.setOrganizationCode(orgCode);
        requestLog.setUserCode(userCode);
        requestLog.setResponse(response);
//        requestLog.setErrorLogId(errorLogId);

        DatabaseSessionService.getInstance().setOrgSettings(null);

        requestLogEntryId = LoggingService.logRequest(requestLog);
        Assert.assertEquals(-1, requestLogEntryId);
    }

    @Test
    public void saveRequestLogWithoutARequestName() {
        int requestLogEntryId = 0;

        RequestLog requestLog = new RequestLog();
        requestLog.setRequestName(null);
        requestLog.setOrganizationCode(orgCode);
        requestLog.setUserCode(userCode);
        requestLog.setResponse(response);
//        requestLog.setErrorLogId(errorLogId);

        requestLogEntryId = LoggingService.logRequest(requestLog);
        Assert.assertEquals(-1, requestLogEntryId);
    }

    @Test
    public void saveRequestLogWithoutAnOrganizationCode() {
        int requestLogEntryId = 0;

        RequestLog requestLog = new RequestLog();
        requestLog.setRequestName(requestName);
        requestLog.setOrganizationCode(null);
        requestLog.setUserCode(userCode);
        requestLog.setResponse(response);
//        requestLog.setErrorLogId(errorLogId);

        requestLogEntryId = LoggingService.logRequest(requestLog);
        Assert.assertEquals(-1, requestLogEntryId);
    }
}
