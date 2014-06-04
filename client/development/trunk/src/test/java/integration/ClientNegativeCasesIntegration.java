package integration;

import dvk.client.Client;
import dvk.client.businesslayer.DhlMessage;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.ClientTestUtil;
import ee.ria.dvk.client.testutil.DBTestUtil;
import ee.ria.dvk.client.testutil.FileUtil;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;
import org.apache.log4j.Logger;
import org.junit.Ignore;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

@Ignore
public class ClientNegativeCasesIntegration {
    private static Logger logger = Logger.getLogger(ClientRequestsIntegration.class);
    private static final int SEND_RECEIVE_MODE = 3;

    @Test
    public void serverIsMissingTest() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForNegativeCases();
        for (String path: configFilePaths) {
            // Execute Client with valid configuration, but with the wrong URL to the server
            ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);
            // Expect to get (404) Not Found error (because, we're using the wrong server URL
            String errorMessageActual = "";
            String errorMessageExpected = "(404)Not Found";
            // Get the error message from the last error_log entry
            try {
                errorMessageActual = DBTestUtil.getTheLastErrorsMessage(path);
            } catch (Exception e) {
                Assert.fail();
            }
            // Do asserts - Is an actual error is the same with the expected one?
            Assert.assertEquals(errorMessageExpected, errorMessageActual);
        }
    }

    @Test
    public void sendersOrgCodeInsideTheMessageDoesNotMatchWithTheSendersOrgCodeInsideTheConfigFileTest()  {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path: configFilePaths) {
            int messageId = 0;
            // Before test, insert a new message to DB
            try {
                messageId = insertNewMessageToDB(path);
            } catch (Exception ex) {
                logger.error("Can't insert a new message", ex);
                Assert.fail();
            }
            // Execute the client for sending and receiving our message
            ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);
            // Expect to get VIGA_SAATJA_ASUTUSED_ERINEVAD error
            String errorMessageActual = "";
            String errorMessageExpected = CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD;
            try {
                errorMessageActual = DBTestUtil.getTheLastErrorsMessage(path);
            } catch (Exception ex) {
                Assert.fail();
            }
            // Do asserts - Is an actual error is the same with the expected one?
            Assert.assertEquals(errorMessageActual, errorMessageExpected);
        }
    }

    private int insertNewMessageToDB(String propertiesFile) throws Exception {
        String sql = "";
        int messageId = 0;
        String sqlFile = ClientRequestsIntegration.class.getResource("../insert_message_other_sender").getPath();
        String sqlFileMSSQL = ClientRequestsIntegration.class.getResource("../insert_messageForMSSQL_other_sender").getPath();

        // Before, connect to database to insert a new message
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(propertiesFile);

        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        // Different syntax of INSERT command for different databases
        try {
            if ((orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL))
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005))
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))){
                sql = FileUtil.readSQLToString(sqlFileMSSQL);
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                sql = FileUtil.readSQLToString(sqlFile);
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                    || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                messageId = insertNewMessageToDBForOracle(propertiesFile, dbConnection, orgSettings);
                return messageId;
            } else {
                throw new Exception("Can't recognize the database");
            }
        } catch (Exception ex) {
            logger.error("Can't read SQL file or insert a message to Oracle", ex);
            throw ex;
        }

        messageId = DBTestUtil.executeSQLToInsertTheMessage(sql, dbConnection, orgSettings);

        if (messageId == -1) {
            logger.error("Can't insert the message to the DB");
            Assert.fail();
        }

        return messageId;
    }

    private int insertNewMessageToDBForOracle(String propertiesFile, Connection dbConnection,
                                              OrgSettings orgSettings) throws Exception {
        int messageID = 0;

        // Get data from xml file for new message
        String xmlFileForMessage = ClientRequestsIntegration.class.getResource("../xmlDataForNewMessage_other_sender.xml").getPath();
        UnitCredential[] credentials = UnitCredential.getCredentials(orgSettings, dbConnection);

        // Create a new message with information, then, save it to DB
        DhlMessage newMessage = new DhlMessage();
        newMessage.loadFromXML(xmlFileForMessage, credentials[0]);
        newMessage.setFilePath(xmlFileForMessage);
        messageID = newMessage.addToDB(orgSettings, dbConnection);

        DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);

        return messageID;
    }
}
