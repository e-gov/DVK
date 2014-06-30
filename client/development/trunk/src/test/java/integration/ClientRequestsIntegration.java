package integration;

import dvk.api.container.v1.ContainerVer1;
import dvk.api.container.v2_1.ContainerVer2_1;
import dvk.client.businesslayer.DhlMessage;
import dvk.client.conf.OrgSettings;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.CommonStructures;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.ClientTestUtil;
import ee.ria.dvk.client.testutil.DBTestUtil;
import ee.ria.dvk.client.testutil.FileUtil;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;
import org.apache.log4j.Logger;
import org.junit.Test;

import java.sql.*;
import java.util.List;

//TODO: remove unnecessary comments
// fix the searching part of inserted messages
// remove try and catch blocks where possible
public class ClientRequestsIntegration {
    private static Logger logger = Logger.getLogger(ClientRequestsIntegration.class);
    private static final double CONTAINER_VERSION_1_0 = 1.0;
    private static final double CONTAINER_VERSION_2_1 = 2.1;
    private static final int SEND_RECEIVE_MODE = 3;

    @Test
    public void sendAndReceiveAndGetSendStatusRequestsAndMarkDocumentsReceivedContainer2_1Test() throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        for (String path : configFilePaths) {
            int messageId = insertNewMessage(path, CONTAINER_VERSION_2_1);

            ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);

            String sentXMLData = getSentXML(path, messageId);
            DhlResultRow receivedRow = getReceivedInformation(path);
            String receivedXMLData = receivedRow.getXmlData();

            ContainerVer2_1 containerForSentMessage = createTheContainerVer2_1(sentXMLData);
            ContainerVer2_1 containerForReceivedMessage = createTheContainerVer2_1(receivedXMLData);

            doDataAsserts(sentXMLData, receivedXMLData, containerForSentMessage, containerForReceivedMessage);

            int statusOfSentMessage = getMessagesStatus(messageId, path);
            int statusOfReceivedMessage = getMessagesStatus(receivedRow.getId(), path);
            doStatusAsserts(statusOfSentMessage, statusOfReceivedMessage);
        }
    }

    @Test
    //This test must be fixed
    public void sendAndReceiveAndGetSendStatusRequestsAndMarkDocumentsReceivedVersion1_0Test() throws Exception {

        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCasesContainerVer1();

        for (String path : configFilePaths) {
            try {
                // Before the test, update an information in DHL_SETTING table (using another organization for this test)
                updateAnInformationInDhlSettings(path);

                int messageId = insertNewMessage(path, CONTAINER_VERSION_1_0);

                ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);

                String sentXMLData = getSentXML(path, messageId);
                DhlResultRow receivedRow = getReceivedInformation(path);
                String receivedXMLData = receivedRow.getXmlData();

                ContainerVer1 containerForSentMessage = createTheContainerVer1(sentXMLData);
                ContainerVer1 containerForReceivedMessage = createTheContainerVer1(receivedXMLData);

                doDataAsserts(sentXMLData, receivedXMLData, containerForSentMessage, containerForReceivedMessage);
                int statusOfSentMessage = getMessagesStatus(messageId, path);
                int statusOfReceivedMessage = getMessagesStatus(receivedRow.getId(), path);
                doStatusAsserts(statusOfSentMessage, statusOfReceivedMessage);
            } finally {
                // After the test was completed, restore an information in DHL_SETTINGS table (back to the default org.)
                try {
                    restoreAnInformationInDhlSettings(path);
                } catch (Exception ex) {
                    logger.error("Can't update an information in DHL_SETTINGS table");
                    Assert.fail();
                }
            }
        }
    }

    private int insertNewMessageToDB(String configFile, double containerVersion) throws Exception {
        String sql = "";
        int messageId = 0;
        String sqlFile = "";

        if (containerVersion == CONTAINER_VERSION_2_1) {
            sqlFile = ClientRequestsIntegration.class.getResource("../insert_message").getPath();
        } else if (containerVersion == CONTAINER_VERSION_1_0) {
            sqlFile = ClientRequestsIntegration.class.getResource("../insert_message_container_v1_0").getPath();
        } else {
            throw new Exception("Can't recognize the containers version");
        }

        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        try {
            if ((orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL))
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005))
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))) {
                String sqlFileMSSQL = "";
                if (containerVersion == CONTAINER_VERSION_2_1) {
                    sqlFileMSSQL = ClientRequestsIntegration.class.getResource("../insert_messageForMSSQL").getPath();
                } else if (containerVersion == CONTAINER_VERSION_1_0) {
                    sqlFileMSSQL = ClientRequestsIntegration.class.getResource("../insert_message_other_asutus_ForMSSQL").getPath();
                }
                sql = FileUtil.readSQLToString(sqlFileMSSQL);
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                sql = FileUtil.readSQLToString(sqlFile);
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                    || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                messageId = insertNewMessageToDBForOracle(dbConnection, orgSettings, containerVersion);
                return messageId;
            } else {
                throw new Exception("Can't recognize the database");
            }
        } catch (Exception ex) {
            logger.error("Can't read SQL file or insert a message to Oracle", ex);
            throw ex;
        }

        messageId = DBTestUtil.executeSQLToInsertTheMessage(sql, dbConnection, orgSettings);
        return messageId;
    }

    private int insertNewMessageToDBForOracle(Connection dbConnection,
                                              OrgSettings orgSettings, double containerVersion) throws Exception {
        int messageId = 0;
        // Get data from xml file for new message
        String xmlFileForMessage = "";
        if (containerVersion == CONTAINER_VERSION_2_1) {
            xmlFileForMessage = ClientRequestsIntegration.class.getResource("../xmlDataForNewMessage.xml").getPath();
        } else if (containerVersion == CONTAINER_VERSION_1_0) {
            xmlFileForMessage = ClientRequestsIntegration.class.getResource("../xmlDataForNewMessage_other_asutus.xml").getPath();
        }
        UnitCredential[] credentials = UnitCredential.getCredentials(orgSettings, dbConnection);

        DhlMessage newMessage = new DhlMessage();
        newMessage.loadFromXML(xmlFileForMessage, credentials[0]);
        newMessage.setFilePath(xmlFileForMessage);
        messageId = newMessage.addToDB(orgSettings, dbConnection);

        DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);

        return messageId;
    }

    private DhlResultRow getTheLastReceivedDocumentXMLDataFromDB(String configFile) throws Exception {
        String data = "";
        int receivedMessageId = 0;
        // Before, connect to database to get the last received message
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);

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

        DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);

        return dhlResultRow;
    }

    private DhlResultRow getSentMessageXMLData(int messageId, String configFile) throws Exception {
        // Before, connect to database to get the sended message
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);

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

    private int getMessagesStatus(int messageId, String configFile) throws Exception {
        int status = -1;
        // Before, connect to database to get status of the message
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
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

    private void doDataAsserts(String sentXMLData, String receivedXMLData, ContainerVer2_1 containerForSentMessage,
                               ContainerVer2_1 containerForReceivedMessage) {
        Assert.assertNotNull(sentXMLData);
        Assert.assertNotNull(receivedXMLData);
        Assert.assertTrue(sentXMLData.length() > 0);
        Assert.assertTrue(receivedXMLData.length() > 0);


        Assert.assertNotNull(containerForSentMessage);
        Assert.assertNotNull(containerForReceivedMessage);
        Assert.assertNotNull(containerForSentMessage.getTransport());
        Assert.assertNotNull(containerForReceivedMessage.getTransport());
        Assert.assertNotNull(containerForSentMessage.getDecMetadata());
        Assert.assertNotNull(containerForReceivedMessage.getDecMetadata());
    }

    private void doDataAsserts(String sentXMLData, String receivedXMLData, ContainerVer1 containerForSentMessage,
                               ContainerVer1 containerForReceivedMessage) {
        Assert.assertNotNull(sentXMLData);
        Assert.assertNotNull(receivedXMLData);
        Assert.assertTrue(sentXMLData.length() > 0);
        Assert.assertTrue(receivedXMLData.length() > 0);


        Assert.assertNotNull(containerForSentMessage);
        Assert.assertNotNull(containerForReceivedMessage);
        Assert.assertNotNull(containerForSentMessage.getTransport());
        Assert.assertNotNull(containerForReceivedMessage.getTransport());
        Assert.assertNotNull(containerForReceivedMessage.getMetainfo());
    }

    private void doStatusAsserts(int statusOfSentMessage, int statusOfReceivedMessage) {
        Assert.assertEquals(Settings.Client_StatusSent, statusOfSentMessage);
        Assert.assertEquals(Settings.Client_StatusReceived, statusOfReceivedMessage);
    }

    private void updateAnInformationInDhlSettings(String configFile) throws Exception {
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();

        PreparedStatement preparedStatement = dbConnection.prepareStatement("UPDATE dhl_settings SET institution_code = 'icefire-test1'," +
                "institution_name = 'ICEFIRE TEST1' WHERE id = 1");
        try {
            preparedStatement.executeUpdate();
        } catch (Exception ex) {
            throw ex;
        }
    }

    private void restoreAnInformationInDhlSettings(String configFile) throws Exception {
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();

        PreparedStatement preparedStatement = dbConnection.prepareStatement("UPDATE dhl_settings SET institution_code = '10885324'," +
                    "institution_name = 'Icefire OÜ' WHERE id = 1");
        try {
            preparedStatement.executeUpdate();
        } catch (Exception ex) {
            throw ex;
        }
    }

    private int insertNewMessage(String configFile, double containerVersion) {
        int messageId = 0;
        try {
            messageId = insertNewMessageToDB(configFile, containerVersion);
        } catch (Exception ex) {
            logger.error("Can't insert a new message", ex);
            Assert.fail();
        }

        if (messageId == -1) {
            logger.error("Can't insert a new message");
            Assert.fail();
        }

        return messageId;
    }

    private String getSentXML(String configFile, int messageId) {
        String sendedXML = "";
        try {
            DhlResultRow resultRow = getSentMessageXMLData(messageId, configFile);
            sendedXML = resultRow.getXmlData();
        } catch (Exception ex) {
            logger.error("Can't get a sent document");
            Assert.fail();
        }

        return sendedXML;
    }

    private DhlResultRow getReceivedInformation(String configFile) {
        DhlResultRow resultRow = null;
        try {
            resultRow = getTheLastReceivedDocumentXMLDataFromDB(configFile);
        } catch (Exception ex) {
            logger.error("Can't get a received document");
            Assert.fail();
        }

        return resultRow;
    }

    private ContainerVer2_1 createTheContainerVer2_1(String xml) {
        ContainerVer2_1 container = null;
        try {
            container = ContainerVer2_1.parse(xml);
        } catch (Exception ex) {
            logger.error("Can't create the container ver 2.1");
            Assert.fail();
        }

        return container;
    }

    private ContainerVer1 createTheContainerVer1(String xml) {
        ContainerVer1 container = null;
        try {
            container = ContainerVer1.parse(xml);
        } catch (Exception ex) {
            logger.error("Can't create the container ver 1.0");
            Assert.fail();
        }

        return container;
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
