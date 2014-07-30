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

        // DecSender blocks
        Assert.assertNotNull(containerForSentMessage.getTransport().getDecSender());
        Assert.assertNotNull(containerForReceivedMessage.getTransport().getDecSender());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecSender().getOrganisationCode(),
                containerForReceivedMessage.getTransport().getDecSender().getOrganisationCode());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecSender().getPersonalIdCode(),
                containerForReceivedMessage.getTransport().getDecSender().getPersonalIdCode());

        // DecRecipient blocks
        Assert.assertNotNull(containerForSentMessage.getTransport().getDecRecipient());
        Assert.assertNotNull(containerForReceivedMessage.getTransport().getDecRecipient());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecRecipient().get(0).getOrganisationCode(),
                containerForReceivedMessage.getTransport().getDecRecipient().get(0).getOrganisationCode());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecRecipient().get(0).getPersonalIdCode(),
                containerForReceivedMessage.getTransport().getDecRecipient().get(0).getPersonalIdCode());

        // Recipient block
        Assert.assertNotNull(containerForSentMessage.getRecipient().get(0).getOrganisation());
        Assert.assertNotNull(containerForReceivedMessage.getRecipient().get(0).getOrganisation());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getOrganisation().getName(),
                            containerForReceivedMessage.getRecipient().get(0).getOrganisation().getName());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getOrganisation().getOrganisationCode(),
                            containerForSentMessage.getRecipient().get(0).getOrganisation().getOrganisationCode());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getOrganisation().getResidency(),
                containerForSentMessage.getRecipient().get(0).getOrganisation().getResidency());

        // RecordMetaData block
        Assert.assertNotNull(containerForSentMessage.getRecordMetadata());
        Assert.assertNotNull(containerForReceivedMessage.getRecordMetadata());
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getRecordGuid(),
                            containerForReceivedMessage.getRecordMetadata().getRecordGuid());
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getRecordType(),
                            containerForReceivedMessage.getRecordMetadata().getRecordType());
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getRecordOriginalIdentifier(),
                            containerForReceivedMessage.getRecordMetadata().getRecordOriginalIdentifier());
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getRecordDateRegistered(),
                            containerForReceivedMessage.getRecordMetadata().getRecordDateRegistered());
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getRecordTitle(),
                            containerForReceivedMessage.getRecordMetadata().getRecordTitle());
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getRecordLanguage(),
                            containerForReceivedMessage.getRecordMetadata().getRecordLanguage());

        // Access block
        Assert.assertNotNull(containerForReceivedMessage.getAccess());
        Assert.assertEquals(containerForSentMessage.getAccess().getAccessConditionsCode(),
                            containerForReceivedMessage.getAccess().getAccessConditionsCode());

        // DecMetaData block
        Assert.assertNotNull(containerForSentMessage.getDecMetadata());
        Assert.assertNotNull(containerForReceivedMessage.getDecMetadata());

        // File block and content's asserts
        Assert.assertNotNull(containerForSentMessage.getFile().get(0));
        Assert.assertNotNull(containerForReceivedMessage.getFile().get(0));
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getFileName(),
                            containerForReceivedMessage.getFile().get(0).getFileName());
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getFileSize(),
                            containerForReceivedMessage.getFile().get(0).getFileSize());
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getZipBase64Content(),
                            containerForReceivedMessage.getFile().get(0).getZipBase64Content());
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getFileGuid(),
                            containerForReceivedMessage.getFile().get(0).getFileGuid());
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getMimeType(),
                            containerForReceivedMessage.getFile().get(0).getMimeType());

        // RecordCreator block
        Assert.assertNotNull(containerForSentMessage.getRecordCreator());
        Assert.assertNotNull(containerForReceivedMessage.getRecordCreator());
        Assert.assertNotNull(containerForSentMessage.getRecordCreator().getPerson());
        Assert.assertNotNull(containerForReceivedMessage.getRecordCreator().getPerson());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getPerson().getName(),
                            containerForReceivedMessage.getRecordCreator().getPerson().getName());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getPerson().getGivenName(),
                            containerForReceivedMessage.getRecordCreator().getPerson().getGivenName());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getPerson().getSurname(),
                            containerForReceivedMessage.getRecordCreator().getPerson().getSurname());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getPerson().getPersonalIdCode(),
                            containerForReceivedMessage.getRecordCreator().getPerson().getPersonalIdCode());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getPerson().getResidency(),
                            containerForReceivedMessage.getRecordCreator().getPerson().getResidency());
        Assert.assertNotNull(containerForSentMessage.getRecordCreator().getContactData());
        Assert.assertNotNull(containerForReceivedMessage.getRecordCreator().getContactData());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getAdit(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getAdit());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPhone(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPhone());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getEmail(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getEmail());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getWebPage(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getWebPage());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getMessagingAddress(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getMessagingAddress());
        Assert.assertNotNull(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress());
        Assert.assertNotNull(containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getCountry(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getCountry());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getCounty(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getCounty());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getLocalGovernment(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getLocalGovernment());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getAdministrativeUnit(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getAdministrativeUnit());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getSmallPlace(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getSmallPlace());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getHouseNumber(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getHouseNumber());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getBuildingPartNumber(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getBuildingPartNumber());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getPostalCode(),
                            containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getPostalCode());

        // RecordSenderToDeck block
        Assert.assertNotNull(containerForSentMessage.getRecordSenderToDec());
        Assert.assertNotNull(containerForReceivedMessage.getRecordSenderToDec());
        Assert.assertNotNull(containerForSentMessage.getRecordSenderToDec().getPerson());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getPerson().getName(),
                            containerForReceivedMessage.getRecordSenderToDec().getPerson().getName());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getPerson().getGivenName(),
                            containerForReceivedMessage.getRecordSenderToDec().getPerson().getGivenName());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getPerson().getSurname(),
                            containerForReceivedMessage.getRecordSenderToDec().getPerson().getSurname());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getPerson().getPersonalIdCode(),
                            containerForReceivedMessage.getRecordSenderToDec().getPerson().getPersonalIdCode());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getPerson().getResidency(),
                            containerForReceivedMessage.getRecordSenderToDec().getPerson().getResidency());
        Assert.assertNotNull(containerForSentMessage.getRecordSenderToDec().getContactData());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getAdit(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getAdit());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPhone(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPhone());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getEmail(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getEmail());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getWebPage(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getWebPage());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getMessagingAddress(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getMessagingAddress());
        Assert.assertNotNull(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getCountry(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getCountry());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getCounty(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getCounty());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getLocalGovernment(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getLocalGovernment());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getAdministrativeUnit(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getAdministrativeUnit());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getSmallPlace(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getSmallPlace());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getStreet(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getStreet());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getHouseNumber(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getHouseNumber());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getBuildingPartNumber(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getBuildingPartNumber());
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getPostalCode(),
                            containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getPostalCode());
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

        Assert.assertEquals(containerForSentMessage.getSignedDoc().getDataFiles().get(0).getFileBase64Content(),
                           containerForReceivedMessage.getSignedDoc().getDataFiles().get(0).getFileBase64Content());
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
