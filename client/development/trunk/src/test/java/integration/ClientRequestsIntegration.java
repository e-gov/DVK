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
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;
import org.apache.log4j.Logger;
import org.junit.Test;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ClientRequestsIntegration {
    private static Logger logger = Logger.getLogger(ClientRequestsIntegration.class);

    @Test
    public void sendAndReceiveAndGetSendStatusRequestsTest() throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePaths();

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

    private String readSQLToString(String filePath) throws Exception {
        StringBuffer fileData = new StringBuffer();
        BufferedReader reader = new BufferedReader(new FileReader(filePath));
        char[] buf = new char[1024];
        int numRead = 0;

        while((numRead=reader.read(buf)) != -1) {
            String readData = String.valueOf(buf, 0, numRead);
            fileData.append(readData);
        }
        reader.close();

        return fileData.toString();
    }

    private int insertNewMessageToDB(String propertiesFile) throws Exception {
        String sql = "";
        int messageId = 0;
        String sqlFile = ClientRequestsIntegration.class.getResource("../insert_message").getPath();
        String sqlFileMSSQL = ClientRequestsIntegration.class.getResource("../insert_messageForMSSQL").getPath();

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
                sql = readSQLToString(sqlFileMSSQL);
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                sql = readSQLToString(sqlFile);
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
        String xmlFileForMessage = ClientRequestsIntegration.class.getResource("../xmlDataForNewMessage.xml").getPath();
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
                data = parseClobData(dataClob);
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
            System.out.println("Can't get connection to DB");
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
                data = parseClobData(dataClob);
            } else {
                data = resultSet.getString("data");
            }
        }

        DhlResultRow dhlResultRow = new DhlResultRow();
        dhlResultRow.setXmlData(data);

        return dhlResultRow;
    }

    private String parseClobData(Clob clob) throws Exception {
        StringBuffer stringBuffer = new StringBuffer();
        String strng;

        BufferedReader bufferRead = new BufferedReader(clob.getCharacterStream());

        while ((strng=bufferRead.readLine()) != null) {
            stringBuffer.append(strng);
        }

        return stringBuffer.toString();
    }

    private int returnMessageStatus(int messageId, String propertiesFile) throws Exception {
        // Before, connect to database to get status of the message
        try {
            setUpFromConfigFile(propertiesFile);
        } catch (Exception ex) {
            System.out.println("Can't get connection to DB");
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
                               ContainerVer1 containerForReceivedMessage) {
        Assert.assertNotNull(sendedXMLData);
        Assert.assertNotNull(receivedXMLData);
        Assert.assertTrue(sendedXMLData.length() > 0);
        Assert.assertTrue(receivedXMLData.length() > 0);


        Assert.assertNotNull(containerForSendedMessage);
        Assert.assertNotNull(containerForReceivedMessage);

        String sendedDataFinal = containerForSendedMessage.getFile().get(0).getZipBase64Content();
        String receivedDataFinal = containerForReceivedMessage.getSignedDoc().getDataFiles().get(0).getFileBase64Content();

        Assert.assertEquals(sendedDataFinal, receivedDataFinal);
    }

    private void doStatusAsserts(int statusOfSendingMessage, int statusOfReceivedMessage) {
        Assert.assertEquals(Settings.Client_StatusSent, statusOfSendingMessage);
        Assert.assertEquals(Settings.Client_StatusReceived, statusOfReceivedMessage);
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
