package integration;

import dvk.api.container.v1.ContainerVer1;
import dvk.api.container.v2_1.ContainerVer2_1;
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

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientRequestsIntegration {
    private static Logger logger = Logger.getLogger(ClientRequestsIntegration.class);
    private static final double CAPSULE_VERSION_1_0 = 1.0;
    private static final double CAPSULE_VERSION_2_1 = 2.1;

    @Test
    public void sendAndReceiveAndGetSendStatusRequestsAndMarkDocumentsReceivedAllVersion2_1Test() throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path : configFilePaths) {
            int messageId = 0;

            // Before test, insert a new message to DB
            try {
                messageId = insertNewMessageToDB(path, CAPSULE_VERSION_2_1);
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
                String[] args = new String[]{"-mode=3", "-prop=" + path};
                Client.main(args);
            } catch (Exception e) {
                logger.error(e.getMessage());
                Assert.fail();
            }

            String sendedXMLData = "";
            String receivedXMLData = "";
            ContainerVer2_1 containerForSendedMessage = null;
            ContainerVer2_1 containerForReceivedMessage = null;
            DhlResultRow dhlResultRow = null;

            try {
                dhlResultRow = getSendedMessageXMLData(messageId, path);
                sendedXMLData = dhlResultRow.getXmlData();
            } catch (Exception ex) {
                logger.error("Can't get a sended document");
                Assert.fail();
            }

            try {
                dhlResultRow = getTheLastReceivedDocumentXMLDataFromDB(path);
                receivedXMLData = dhlResultRow.getXmlData();
            } catch (Exception ex) {
                logger.error("Can't get a received document");
                Assert.fail();
            }

            // Create a containers ver 2.1 for sended message, ver 2.1 for received message
            try {
                containerForSendedMessage = ContainerVer2_1.parse(sendedXMLData);
                containerForReceivedMessage = ContainerVer2_1.parse(receivedXMLData);
            } catch (Exception ex) {
                logger.error("Can't create the containers");
                Assert.fail();
            }

            // Do asserts
            doDataAsserts(sendedXMLData, receivedXMLData, containerForSendedMessage, containerForReceivedMessage);

            // Get status (getSendStatusRequest) of sended message
            int statusOfSendingMessage = returnMessageStatus(messageId, path);
            // Get status (markDocumentReceived) of received message
            int statusOfReceivedMessage = returnMessageStatus(dhlResultRow.getId(), path);

            // Do asserts
            doStatusAsserts(statusOfSendingMessage, statusOfReceivedMessage);
        }
    }

    @Test
    public void sendAndReceiveAndGetSendStatusRequestsAndMarkDocumentsReceivedVersion1_0Test() throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCasesCapsuleVer1();

        for (String path : configFilePaths) {
            int messageId = 0;
            // Before the test, update an information in DHL_SETTING

            try {
                updateAnInformationInDhlSettings(path);
            } catch (Exception ex) {
                logger.error("Can't update an information in DHL_SETTINGS");
                Assert.fail();
            }

            // Before the test, insert a new message to DB
            try {
                messageId = insertNewMessageToDB(path, CAPSULE_VERSION_1_0);
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
                String[] args = new String[]{"-mode=3", "-prop=" + path};
                Client.main(args);
            } catch (Exception e) {
                logger.error(e.getMessage());
                Assert.fail();
            }

            String sendedXMLData = "";
            String receivedXMLData = "";
            ContainerVer2_1 containerForSendedMessage = null;
            ContainerVer1 containerForReceivedMessage = null;
            DhlResultRow dhlResultRow = null;

            try {
                dhlResultRow = getSendedMessageXMLData(messageId, path);
                sendedXMLData = dhlResultRow.getXmlData();
            } catch (Exception ex) {
                logger.error("Can't get a sended document");
                Assert.fail();
            }

            try {
                dhlResultRow = getTheLastReceivedDocumentXMLDataFromDB(path);
                receivedXMLData = dhlResultRow.getXmlData();
            } catch (Exception ex) {
                logger.error("Can't get a received document");
                Assert.fail();
            }

            // Create a containers ver 2.1 for sended message, ver 1.0 for received message
            try {
                containerForSendedMessage = ContainerVer2_1.parse(sendedXMLData);
                containerForReceivedMessage = ContainerVer1.parse(receivedXMLData);
            } catch (Exception ex) {
                logger.error("Can't create the containers");
                Assert.fail();
            }

            // Do asserts
            doDataAsserts(sendedXMLData, receivedXMLData, containerForSendedMessage, containerForReceivedMessage);

            // Get status (getSendStatusRequest) of sended message
            int statusOfSendingMessage = returnMessageStatus(messageId, path);
            // Get status (markDocumentReceived) of received message
            int statusOfReceivedMessage = returnMessageStatus(dhlResultRow.getId(), path);

            // Do asserts
            doStatusAsserts(statusOfSendingMessage, statusOfReceivedMessage);

            // After the test is completed, restore an information in DHL_SETTINGS
            try {
                restoreAnInformationInDhlSettings(path);
            } catch (Exception ex) {
                logger.error("Can't update an information in DHL_SETTINGS");
                Assert.fail();
            }
        }
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

    private int insertNewMessageToDB(String propertiesFile, double capsuleVersion) throws Exception {
        String sql = "";
        int messageId = 0;
        String sqlFile;

        if (capsuleVersion == CAPSULE_VERSION_2_1) {
            sqlFile = ClientRequestsIntegration.class.getResource("../insert_message").getPath();
        } else if (capsuleVersion == CAPSULE_VERSION_1_0) {
            sqlFile = ClientRequestsIntegration.class.getResource("../insert_message_other_asutus").getPath();
        } else {
            throw new Exception("Can't recognize the capsules version");
        }

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
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))) {
                String sqlFileMSSQL = null;
                if (capsuleVersion == CAPSULE_VERSION_2_1) {
                    sqlFileMSSQL = ClientRequestsIntegration.class.getResource("../insert_messageForMSSQL").getPath();
                } else if (capsuleVersion == CAPSULE_VERSION_1_0) {
                    sqlFileMSSQL = ClientRequestsIntegration.class.getResource("../insert_message_other_asutus_ForMSSQL").getPath();
                }
                sql = FileUtil.readSQLToString(sqlFileMSSQL);
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                sql = FileUtil.readSQLToString(sqlFile);
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                    || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                messageId = insertNewMessageToDBForOracle(propertiesFile, dbConnection, orgSettings, capsuleVersion);
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
        } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
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
                                              OrgSettings orgSettings, double capsuleVersion) throws Exception {
        int messageID = 0;

        // Get data from xml file for new message
        String xmlFileForMessage = null;
        if (capsuleVersion == CAPSULE_VERSION_2_1) {
            xmlFileForMessage = ClientRequestsIntegration.class.getResource("../xmlDataForNewMessage.xml").getPath();
        } else if (capsuleVersion == CAPSULE_VERSION_1_0) {
            xmlFileForMessage = ClientRequestsIntegration.class.getResource("../xmlDataForNewMessage_other_asutus.xml").getPath();
        }
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

    private DhlResultRow getTheLastReceivedDocumentXMLDataFromDB(String propertiesFile) throws Exception {
        String data = "";
        int receivedMessageId = 0;

        // Before, connect to database to get the last received message
        try {
            setUpFromConfigFile(propertiesFile);
        } catch (Exception ex) {
            logger.error("Can't get connection to DB", ex);
            throw ex;
        }

        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        Clob dataClob = null;
        PreparedStatement preparedStatement = null;

        // Different syntax for different databases
        if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dhl_message" +
                    " WHERE rownum = 1 ORDER BY dhl_message_id DESC");
        } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dvk.dhl_message ORDER BY " +
                    "dhl_message_id DESC LIMIT 1");
        } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL)
                || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005))
                || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))) {
            preparedStatement = dbConnection.prepareStatement("SELECT TOP 1 * FROM dhl_message " +
                    "ORDER BY dhl_message_id DESC");
        } else {
            throw new Exception("Can't recognize the database");
        }

        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                    || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                dataClob = resultSet.getClob("data");
                data = FileUtil.parseClobData(dataClob);
            } else {
                data = resultSet.getString("data");
            }
            receivedMessageId = resultSet.getInt("dhl_message_id");
        }

        DhlResultRow dhlResultRow = new DhlResultRow(receivedMessageId, data);

        CommonMethods.safeCloseDatabaseConnection(dbConnection);
        DatabaseSessionService.getInstance().clearSession();
        return dhlResultRow;
    }

    private DhlResultRow getSendedMessageXMLData(int messageId, String propertiesFile) throws Exception {
        // Before, connect to database to get the sended message
        try {
            setUpFromConfigFile(propertiesFile);
        } catch (Exception ex) {
            logger.error("Can't get connection to DB");
            throw ex;
        }

        String data = "";
        Clob dataClob = null;

        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        PreparedStatement preparedStatement = null;

        if (!orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dhl_message " +
                    "WHERE dhl_message_id = ?");
        } else {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dvk.dhl_message " +
                    "WHERE dhl_message_id = ?");
        }

        preparedStatement.setInt(1, messageId);
        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {

            if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                    || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                dataClob = resultSet.getClob("data");
                data = FileUtil.parseClobData(dataClob);
            } else {
                data = resultSet.getString("data");
            }
        }

        DhlResultRow dhlResultRow = new DhlResultRow();
        dhlResultRow.setXmlData(data);

        return dhlResultRow;
    }

    private int returnMessageStatus(int messageId, String propertiesFile) throws Exception {
        // Before, connect to database to get status of the message
        try {
            setUpFromConfigFile(propertiesFile);
        } catch (Exception ex) {
            logger.error("Can't get connection to DB");
            throw ex;
        }

        int status = -1;

        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        PreparedStatement preparedStatement = null;

        if (!orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dhl_message " +
                    "WHERE dhl_message_id = ?");
        } else {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dvk.dhl_message " +
                    "WHERE dhl_message_id = ?");
        }

        preparedStatement.setInt(1, messageId);
        ResultSet resultSet = preparedStatement.executeQuery();
        if (resultSet.next()) {
            status = resultSet.getInt("sending_status_id");
        }

        return status;
    }

    private void doDataAsserts(String sendedXMLData, String receivedXMLData, ContainerVer2_1 containerForSendedMessage,
                               ContainerVer2_1 containerForReceivedMessage) {
        Assert.assertNotNull(sendedXMLData);
        Assert.assertNotNull(receivedXMLData);
        Assert.assertTrue(sendedXMLData.length() > 0);
        Assert.assertTrue(receivedXMLData.length() > 0);


        Assert.assertNotNull(containerForSendedMessage);
        Assert.assertNotNull(containerForReceivedMessage);
        Assert.assertNotNull(containerForSendedMessage.getTransport());
        Assert.assertNotNull(containerForReceivedMessage.getTransport());
        Assert.assertNotNull(containerForSendedMessage.getDecMetadata());
        Assert.assertNotNull(containerForReceivedMessage.getDecMetadata());
    }

    private void doDataAsserts(String sendedXMLData, String receivedXMLData, ContainerVer2_1 containerForSendedMessage,
                               ContainerVer1 containerForReceivedMessage) {
        Assert.assertNotNull(sendedXMLData);
        Assert.assertNotNull(receivedXMLData);
        Assert.assertTrue(sendedXMLData.length() > 0);
        Assert.assertTrue(receivedXMLData.length() > 0);


        Assert.assertNotNull(containerForSendedMessage);
        Assert.assertNotNull(containerForReceivedMessage);
        Assert.assertNotNull(containerForSendedMessage.getTransport());
        Assert.assertNotNull(containerForReceivedMessage.getTransport());
        Assert.assertNotNull(containerForSendedMessage.getDecMetadata());
        Assert.assertNotNull(containerForReceivedMessage.getMetainfo());
    }

    private void doStatusAsserts(int statusOfSendingMessage, int statusOfReceivedMessage) {
        Assert.assertEquals(Settings.Client_StatusSent, statusOfSendingMessage);
        Assert.assertEquals(Settings.Client_StatusReceived, statusOfReceivedMessage);
    }

    private void updateAnInformationInDhlSettings(String propertiesFile) throws Exception {
        try {
            setUpFromConfigFile(propertiesFile);
        } catch (Exception ex) {
            logger.error("Can't get connection to DB");
            throw ex;
        }

        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        PreparedStatement preparedStatement = null;

        preparedStatement = dbConnection.prepareStatement("UPDATE dhl_settings SET institution_code = 'icefire-test1'," +
                "institution_name = 'ICEFIRE TEST1' WHERE id = 1");

        try {
            preparedStatement.executeUpdate();
        } catch (Exception ex) {
            throw ex;
        }
    }

    private void restoreAnInformationInDhlSettings(String propertiesFile) throws Exception {
        try {
            setUpFromConfigFile(propertiesFile);
        } catch (Exception ex) {
            logger.error("Can't get connection to DB");
            throw ex;
        }

        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        PreparedStatement preparedStatement = null;

        preparedStatement = dbConnection.prepareStatement("UPDATE dhl_settings SET institution_code = '10885324'," +
                    "institution_name = 'Icefire OÜ' WHERE id = 1");

        try {
            preparedStatement.executeUpdate();
        } catch (Exception ex) {
            throw ex;
        }
    }

    private class DhlResultRow {
        private int id;
        private String xmlData;

        DhlResultRow(int id, String xmlData) {
            this.id = id;
            this.xmlData = xmlData;
        }

        DhlResultRow() {

        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getXmlData() {
            return xmlData;
        }

        public void setXmlData(String xmlData) {
            this.xmlData = xmlData;
        }
    }
}
