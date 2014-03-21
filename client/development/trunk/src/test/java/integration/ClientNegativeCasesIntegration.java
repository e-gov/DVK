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
import ee.ria.dvk.client.testutil.FileUtil;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;
import org.apache.log4j.Logger;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ClientNegativeCasesIntegration {
    private static Logger logger = Logger.getLogger(ClientRequestsIntegration.class);

    @Test
    public void serverIsMissingTest() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForNegativeCases();
        for (String path: configFilePaths) {
            // Execute Client with valid configuration, but with the wrong URL to the server
            try {
                String[] args = new String[]{"-mode=3", "-prop="+path};
                Client.main(args);
            } catch (Exception e) {
                logger.error(e.getMessage());
                Assert.fail();
            }

            String errorMessageActual = "";
            String errorMessageExpected = "(404)Not Found";

            // Get the error message from the last error_log entry
            try {
                errorMessageActual = getTheLastErrorsMessage(path);
            } catch (Exception e) {
                logger.error(e.getMessage());
                Assert.fail();
            }

            Assert.assertEquals(errorMessageExpected, errorMessageActual);
        }
    }

    @Test
    public void sendersOrgCodeInsideTheMessageDoesNotMatchWithTheSendersOrgCodeInsideTheConfigFileTest() {
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

            if (messageId == -1) {
                logger.error("Can't insert a new message");
                Assert.fail();
            }

            // Execute the client for sending and receiving our message

            try {
                String[] args = new String[]{"-mode=3", "-prop="+path};
                Client.main(args);
            } catch (Exception e) {
                logger.error(e.getMessage());
                Assert.fail();
            }

            String errorMessageActual = "";

            try {
                errorMessageActual = getTheLastErrorsMessage(path);
            } catch (Exception e) {
                logger.error(e.getMessage());
                Assert.fail();
            }

            Assert.assertEquals(errorMessageActual, CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD);
        }
    }

    private int insertNewMessageToDB(String propertiesFile) throws Exception {
        String sql = "";
        int messageId = 0;
        String sqlFile = ClientRequestsIntegration.class.getResource("../insert_message_other_sender").getPath();
        String sqlFileMSSQL = ClientRequestsIntegration.class.getResource("../insert_messageForMSSQL_other_sender").getPath();

        // Before, connect to database to insert a new message
        try {
            setUpFromConfigFile(propertiesFile);
        } catch (Exception ex) {
            logger.error("Can't get a connection to DB");
            throw ex;
        }

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

        // Insert a new message
        CallableStatement cs = dbConnection.prepareCall(sql);
        cs.execute();
        cs.close();
        dbConnection.commit();

        PreparedStatement preparedStatement = null;

        // Different syntax of SELECT for different databases
        if ((orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL))
                || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005))
                || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))) {
            preparedStatement = dbConnection.prepareStatement("SELECT TOP 1 * FROM dhl_message " +
                    "ORDER BY dhl_message_id DESC");
        } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)){
            preparedStatement = dbConnection.prepareStatement("SELECT dhl_message_id FROM " +
                    "dvk.dhl_message ORDER BY dhl_message_id DESC LIMIT 1");
        }

        ResultSet resultSet;
        try {
            resultSet = preparedStatement.executeQuery();
        } catch (NullPointerException ex) {
            throw ex;
        }

        if (resultSet.next()) {
            messageId = resultSet.getInt("dhl_message_id");
        }

        CommonMethods.safeCloseDatabaseConnection(dbConnection);
        DatabaseSessionService.getInstance().clearSession();
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

        CommonMethods.safeCloseDatabaseConnection(dbConnection);
        DatabaseSessionService.getInstance().clearSession();

        return messageID;
    }

    private String getTheLastErrorsMessage(String path) throws Exception {
        String errorMessage = "";
        int receivedMessageId = 0;

        // Before, connect to the database
        try {
            setUpFromConfigFile(path);
        } catch (Exception ex) {
            logger.error("Can't get connection to DB", ex);
            throw ex;
        }

        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        PreparedStatement preparedStatement = null;

        // Different syntax for different databases
        if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dhl_error_log" +
                    " WHERE rownum = 1 ORDER BY dhl_error_log_id DESC");
        } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dvk.dhl_error_log ORDER BY " +
                    "dhl_error_log_id DESC LIMIT 1");
        } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL)
                || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005))
                || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))) {
            preparedStatement = dbConnection.prepareStatement("SELECT TOP 1 * FROM dhl_error_log " +
                    "ORDER BY dhl_error_log_id DESC");
        } else {
            throw new Exception("Can't recognize the database");
        }

        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            errorMessage = resultSet.getString("error_message");
        }

        CommonMethods.safeCloseDatabaseConnection(dbConnection);
        DatabaseSessionService.getInstance().clearSession();

        return errorMessage;
    }

    private void setUpFromConfigFile(String configFile) throws Exception {
        if (configFile == null) {
            throw new Exception("configFile is null");
        }

        ArrayList<OrgSettings> allKnownDatabases = null;
        Connection connection = null;

        // Load settings from config file and start using this database
        Settings.loadProperties(configFile);
        allKnownDatabases = OrgSettings.getSettings(Settings.Client_ConfigFile);
        connection = DBConnection.getConnection(allKnownDatabases.get(0));
        DatabaseSessionService.getInstance().setSession(connection, allKnownDatabases.get(0));
    }
}
