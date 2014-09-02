package integration;

import dvk.api.container.v1.ContainerVer1;
import dvk.api.container.v1.DataFile;
import dvk.api.container.v1.Saaja;
import dvk.api.container.v1.Saatja;
import dvk.api.container.v2_1.ContainerVer2_1;
import dvk.api.container.v2_1.DecRecipient;
import dvk.api.container.v2_1.DecSender;
import dvk.api.container.v2_1.File;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.ClientTestUtil;
import ee.ria.dvk.client.testutil.DBTestUtil;
import ee.ria.dvk.client.testutil.DhlMessageData;
import ee.ria.dvk.client.testutil.DhlSetting;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junitparams.JUnitParamsRunner;
import junitparams.Parameters;
import org.apache.commons.codec.binary.Base64InputStream;
import org.apache.commons.codec.binary.Base64OutputStream;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPInputStream;

@RunWith(JUnitParamsRunner.class)
public class ClientRequestsIntegration {
    private static Logger logger = Logger.getLogger(ClientRequestsIntegration.class);
    private static final int SEND_RECEIVE_MODE = 3;
    private static final int SEND_MODE = 1;
    private static final int RECEIVE_MODE = 2;

    @Test
    @Parameters({
            "container_2_1_icefire.xml",
            "container_2_1_icefire_1.xml",
            "container_2_1_icefire_2.xml",
            "container_2_1_icefire_ddoc.xml",
            "2_1_nok1.xml"
    })
    public void sendAndReceiveAndGetSendStatusRequestsAndMarkDocumentsReceivedContainer2_1Test(String xmlContainer) throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();
        for (String path : configFilePaths) {
            doTestForContainerVer2_1(path, xmlContainer);
        }
    }

    @Test
    @Parameters({
            "container_1_0_icefire_test1.xml",
            "container_1_0_icefire_test1_ddoc.xml",
            "container_1_0_icefire_test1_ddoc_evorm.xml",
            "container_1_0_icefire_test1_ddoc_evorm_1.xml",
            "container_1_0_nok1.xml"
    })
    public void sendAndReceiveAndGetSendStatusRequestsAndMarkDocumentsReceivedVersion1_0Test(String xmlContainer) throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCasesContainerVer1();
        for (String path : configFilePaths) {
            doTestForContainerVer1(path, xmlContainer);
        }
    }

    @Test
    @Parameters({
            "container_2_1_icefire_test1.xml"
    })
    public void sendContainer_2_1_AndReceive_1_0_Test(String xmlContainer) throws Exception {
        String configFilePath = IntegrationTestsConfigUtil.getConfigFileAbsolutePathForConversionCase().get(0);
        DhlSetting oldSettings = DBTestUtil.fetchDhlSettings(configFilePath);
        DhlSetting newSettings = new DhlSetting(DhlSetting.CONTAINER_VERSION_1_0);
        int sentMessageId = 0;
        int receivedMessageId = 0;
        try {
            DBTestUtil.updateDhlSettings(configFilePath, newSettings);
            sentMessageId = DBTestUtil.insertNewMessageToDB(configFilePath, xmlContainer);
            ClientTestUtil.executeTheClient(configFilePath, SEND_MODE);
            ClientTestUtil.executeTheClient(configFilePath, RECEIVE_MODE);
            DhlMessageData sentDhlMessageData = DBTestUtil.getMessageById(configFilePath, sentMessageId);
            Assert.assertNotNull("Can't get the sent document", sentDhlMessageData);
            String sentXMLData = sentDhlMessageData.getXmlData();
            DhlMessageData receivedDhlMessageData = DBTestUtil.getMessageByDhlId(configFilePath, sentDhlMessageData.getDhlId(), true);
            Assert.assertNotNull("Can't get the received document", receivedDhlMessageData);
            receivedMessageId = receivedDhlMessageData.getId();
            String receivedXMLData = receivedDhlMessageData.getXmlData();

            Assert.assertTrue(sentXMLData != null && sentXMLData.length() > 0);
            Assert.assertTrue(receivedXMLData != null && receivedXMLData.length() > 0);

            ContainerVer2_1 containerForSentMessage = createTheContainerVer2_1(sentXMLData);
            ContainerVer1 containerForReceivedMessage = createTheContainerVer1(receivedXMLData);

            doDataAsserts(containerForSentMessage, containerForReceivedMessage);
            logger.debug("sendContainer_2_1_AndReceive_1_0_Test passed");

        } finally {
            DBTestUtil.restoreDhlSettings(configFilePath, oldSettings);
            DBTestUtil.clearDataBaseAfterTest(configFilePath, Arrays.asList(sentMessageId, receivedMessageId));
        }
    }

    @Test
    @Parameters({
            "container_2_1_icefire.xml",
            "container_2_1_icefire_ddoc.xml"           
    })
    public void sendAndReceiveContainer2_1_UsingFragmentingTest(String xmlContainer) throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.
                getAllConfigFilesAbsolutePathsForPositiveCasesContainerVer2_1UsingFragmenting();
        for (String path : configFilePaths) {
            doTestForContainerVer2_1(path, xmlContainer);
        }                                        
    }

    @Test
    @Parameters({"container_1_0_icefire_test1.xml",
            "container_1_0_icefire_test1_ddoc.xml"})
    public void sendAndReceiveContainer1_0_UsingFragmentingTest(String xmlContainer) throws Exception {
        List<String> configFilePaths = IntegrationTestsConfigUtil.
                getAllConfigFilesAbsolutePathsForPositiveCasesContainerVer1UsingFragmenting();
        for (String path : configFilePaths) {
            doTestForContainerVer1(path, xmlContainer);
        }
    }

    private int getMessagesStatus(int messageId, String configFile) throws Exception {
        int status = -1;
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();

        PreparedStatement preparedStatement;
        try {
            preparedStatement = dbConnection.prepareStatement("SELECT * FROM dhl_message WHERE dhl_message_id = ?");
            preparedStatement.setInt(1, messageId);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                status = resultSet.getInt("sending_status_id");
            }
        } finally {
            DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
        }
        return status;
    }

    private void doTestForContainerVer2_1(String path, String xmlContainer) throws Exception {
        DhlSetting oldSettings = DBTestUtil.fetchDhlSettings(path);
        DhlSetting newSettings = new DhlSetting(DhlSetting.CONTAINER_VERSION_2_1);
        int sentMessageId = 0;
        int receivedMessageId = 0;
        try {
            DBTestUtil.updateDhlSettings(path, newSettings);
            sentMessageId = DBTestUtil.insertNewMessageToDB(path, xmlContainer);
            ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);
            DhlMessageData sentDhlMessageData = DBTestUtil.getMessageById(path, sentMessageId);
            Assert.assertNotNull("Can't get the sent document", sentDhlMessageData);
            String sentXMLData = sentDhlMessageData.getXmlData();
            DhlMessageData receivedDhlMessageData = DBTestUtil.getMessageByDhlId(path, sentDhlMessageData.getDhlId(), true);
            Assert.assertNotNull("Can't get the received document", receivedDhlMessageData);
            receivedMessageId = receivedDhlMessageData.getId();
            String receivedXMLData = receivedDhlMessageData.getXmlData();
            ContainerVer2_1 containerForSentMessage = createTheContainerVer2_1(sentXMLData);
            ContainerVer2_1 containerForReceivedMessage = createTheContainerVer2_1(receivedXMLData);
            doDataAsserts(sentXMLData, receivedXMLData, containerForSentMessage, containerForReceivedMessage);

            int statusOfSentMessage = getMessagesStatus(sentMessageId, path);
            int statusOfReceivedMessage = getMessagesStatus(receivedDhlMessageData.getId(), path);
            doStatusAsserts(statusOfSentMessage, statusOfReceivedMessage);

        } finally {
            DBTestUtil.restoreDhlSettings(path, oldSettings);
            DBTestUtil.clearDataBaseAfterTest(path, Arrays.asList(sentMessageId, receivedMessageId));
        }
    }

    private void doTestForContainerVer1(String path, String xmlContainer) throws Exception {
        DhlSetting oldSettings = DBTestUtil.fetchDhlSettings(path);
        DhlSetting newSettings = new DhlSetting(DhlSetting.CONTAINER_VERSION_1_0);
        int sentMessageId = 0;
        int receivedMessageId = 0;
        try {
            DBTestUtil.updateDhlSettings(path, newSettings);
            sentMessageId = DBTestUtil.insertNewMessageToDB(path, xmlContainer);
            ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);
            DhlMessageData sentDhlMessageData = DBTestUtil.getMessageById(path, sentMessageId);
            Assert.assertNotNull("Can't get the sent document", sentDhlMessageData);
            String sentXMLData = sentDhlMessageData.getXmlData();
            DhlMessageData receivedDhlMessageData = DBTestUtil.getMessageByDhlId(path, sentDhlMessageData.getDhlId(), true);
            Assert.assertNotNull("Can't get the received document", receivedDhlMessageData);
            receivedMessageId = receivedDhlMessageData.getId();
            String receivedXMLData = receivedDhlMessageData.getXmlData();
            ContainerVer1 containerForSentMessage = createTheContainerVer1(sentXMLData);
            ContainerVer1 containerForReceivedMessage = createTheContainerVer1(receivedXMLData);
            doDataAsserts(sentXMLData, receivedXMLData, containerForSentMessage, containerForReceivedMessage);

            int statusOfSentMessage = getMessagesStatus(sentMessageId, path);
            int statusOfReceivedMessage = getMessagesStatus(receivedDhlMessageData.getId(), path);
            doStatusAsserts(statusOfSentMessage, statusOfReceivedMessage);

        } finally {
            DBTestUtil.restoreDhlSettings(path, oldSettings);
            DBTestUtil.clearDataBaseAfterTest(path, Arrays.asList(sentMessageId, receivedMessageId));
        }
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
        Assert.assertEquals(containerForSentMessage.getTransport().getDecSender().getStructuralUnit(),
                containerForReceivedMessage.getTransport().getDecSender().getStructuralUnit());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecSender().getPersonalIdCode(),
                containerForReceivedMessage.getTransport().getDecSender().getPersonalIdCode());

        // DecRecipient blocks
        Assert.assertNotNull(containerForSentMessage.getTransport().getDecRecipient());
        Assert.assertNotNull(containerForReceivedMessage.getTransport().getDecRecipient());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecRecipient().get(0).getOrganisationCode(),
                containerForReceivedMessage.getTransport().getDecRecipient().get(0).getOrganisationCode());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecRecipient().get(0).getStructuralUnit(),
                containerForReceivedMessage.getTransport().getDecRecipient().get(0).getStructuralUnit());
        Assert.assertEquals(containerForSentMessage.getTransport().getDecRecipient().get(0).getPersonalIdCode(),
                containerForReceivedMessage.getTransport().getDecRecipient().get(0).getPersonalIdCode());

        // Initiator block
        if (containerForSentMessage.getInitiator() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getInitiator());
            Assert.assertEquals(containerForSentMessage.getInitiator().getInitiatorRecordOriginalIdentifier(),
                    containerForReceivedMessage.getInitiator().getInitiatorRecordOriginalIdentifier());
            Assert.assertEquals(containerForSentMessage.getInitiator().getInitiatorRecordDate(),
                    containerForReceivedMessage.getInitiator().getInitiatorRecordDate());
            Assert.assertNotNull(containerForSentMessage.getInitiator().getOrganisation());
            Assert.assertEquals(containerForSentMessage.getInitiator().getOrganisation().getName(),
                    containerForReceivedMessage.getInitiator().getOrganisation().getName());
            Assert.assertEquals(containerForSentMessage.getInitiator().getOrganisation().getOrganisationCode(),
                    containerForReceivedMessage.getInitiator().getOrganisation().getOrganisationCode());
            Assert.assertEquals(containerForSentMessage.getInitiator().getOrganisation().getStructuralUnit(),
                    containerForReceivedMessage.getInitiator().getOrganisation().getStructuralUnit());
            Assert.assertEquals(containerForSentMessage.getInitiator().getOrganisation().getResidency(),
                    containerForReceivedMessage.getInitiator().getOrganisation().getResidency());
            Assert.assertEquals(containerForSentMessage.getInitiator().getOrganisation().getPositionTitle(),
                    containerForReceivedMessage.getInitiator().getOrganisation().getPositionTitle());
            Assert.assertNotNull(containerForSentMessage.getInitiator().getPerson());
            Assert.assertEquals(containerForSentMessage.getInitiator().getPerson().getPersonalIdCode(),
                    containerForReceivedMessage.getInitiator().getPerson().getPersonalIdCode());
            Assert.assertEquals(containerForSentMessage.getInitiator().getPerson().getResidency(),
                    containerForReceivedMessage.getInitiator().getPerson().getResidency());
            Assert.assertEquals(containerForSentMessage.getInitiator().getPerson().getName(),
                    containerForReceivedMessage.getInitiator().getPerson().getName());
            Assert.assertEquals(containerForSentMessage.getInitiator().getPerson().getGivenName(),
                    containerForReceivedMessage.getInitiator().getPerson().getGivenName());
            Assert.assertEquals(containerForSentMessage.getInitiator().getPerson().getGivenName(),
                    containerForReceivedMessage.getInitiator().getPerson().getGivenName());
            Assert.assertEquals(containerForSentMessage.getInitiator().getPerson().getSurname(),
                    containerForReceivedMessage.getInitiator().getPerson().getSurname());
            Assert.assertNotNull(containerForSentMessage.getInitiator().getContactData());
            Assert.assertNotNull(containerForReceivedMessage.getInitiator().getContactData());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getAdit(),
                    containerForReceivedMessage.getInitiator().getContactData().getAdit());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPhone(),
                    containerForReceivedMessage.getInitiator().getContactData().getPhone());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getEmail(),
                    containerForReceivedMessage.getInitiator().getContactData().getEmail());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getWebPage(),
                    containerForReceivedMessage.getInitiator().getContactData().getWebPage());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getMessagingAddress(),
                    containerForReceivedMessage.getInitiator().getContactData().getMessagingAddress());
            Assert.assertNotNull(containerForSentMessage.getInitiator().getContactData().getPostalAddress());
            Assert.assertNotNull(containerForReceivedMessage.getInitiator().getContactData().getPostalAddress());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getCountry(),
                    containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getCountry());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getCounty(),
                    containerForReceivedMessage.getInitiator().getContactData().getPostalAddress().getCounty());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getLocalGovernment(),
                    containerForReceivedMessage.getInitiator().getContactData().getPostalAddress().getLocalGovernment());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getAdministrativeUnit(),
                    containerForReceivedMessage.getInitiator().getContactData().getPostalAddress().getAdministrativeUnit());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getSmallPlace(),
                    containerForReceivedMessage.getInitiator().getContactData().getPostalAddress().getSmallPlace());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getHouseNumber(),
                    containerForReceivedMessage.getInitiator().getContactData().getPostalAddress().getHouseNumber());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getBuildingPartNumber(),
                    containerForReceivedMessage.getInitiator().getContactData().getPostalAddress().getBuildingPartNumber());
            Assert.assertEquals(containerForSentMessage.getInitiator().getContactData().getPostalAddress().getPostalCode(),
                    containerForReceivedMessage.getInitiator().getContactData().getPostalAddress().getPostalCode());
        }

        // RecordCreator block
        Assert.assertNotNull(containerForSentMessage.getRecordCreator());
        Assert.assertNotNull(containerForReceivedMessage.getRecordCreator());
        if (containerForSentMessage.getRecordCreator().getOrganisation() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getRecordCreator().getOrganisation());
            Assert.assertEquals(containerForSentMessage.getRecordCreator().getOrganisation().getPositionTitle(),
                    containerForReceivedMessage.getRecordCreator().getOrganisation().getPositionTitle());
            Assert.assertEquals(containerForSentMessage.getRecordCreator().getOrganisation().getResidency(),
                    containerForReceivedMessage.getRecordCreator().getOrganisation().getResidency());
            Assert.assertEquals(containerForSentMessage.getRecordCreator().getOrganisation().getName(),
                    containerForReceivedMessage.getRecordCreator().getOrganisation().getName());
            Assert.assertEquals(containerForSentMessage.getRecordCreator().getOrganisation().getOrganisationCode(),
                    containerForReceivedMessage.getRecordCreator().getOrganisation().getOrganisationCode());
            Assert.assertEquals(containerForSentMessage.getRecordCreator().getOrganisation().getStructuralUnit(),
                    containerForReceivedMessage.getRecordCreator().getOrganisation().getStructuralUnit());
        }
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
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getLandUnit(),
                containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getLandUnit());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getSmallPlace(),
                containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getSmallPlace());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getHouseNumber(),
                containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getHouseNumber());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getBuildingPartNumber(),
                containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getBuildingPartNumber());
        Assert.assertEquals(containerForSentMessage.getRecordCreator().getContactData().getPostalAddress().getPostalCode(),
                containerForReceivedMessage.getRecordCreator().getContactData().getPostalAddress().getPostalCode());

        // RecordSenderToDec block
        Assert.assertNotNull(containerForSentMessage.getRecordSenderToDec());
        Assert.assertNotNull(containerForReceivedMessage.getRecordSenderToDec());
        if (containerForSentMessage.getRecordSenderToDec().getOrganisation() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getRecordSenderToDec().getOrganisation());
            Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getOrganisation().getName(),
                    containerForReceivedMessage.getRecordSenderToDec().getOrganisation().getName());
            Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getOrganisation().getOrganisationCode(),
                    containerForReceivedMessage.getRecordSenderToDec().getOrganisation().getOrganisationCode());
            Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getOrganisation().getStructuralUnit(),
                    containerForReceivedMessage.getRecordSenderToDec().getOrganisation().getStructuralUnit());
            Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getOrganisation().getPositionTitle(),
                    containerForReceivedMessage.getRecordSenderToDec().getOrganisation().getPositionTitle());
            Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getOrganisation().getResidency(),
                    containerForReceivedMessage.getRecordSenderToDec().getOrganisation().getResidency());
        }
        Assert.assertNotNull(containerForSentMessage.getRecordSenderToDec().getPerson());
        Assert.assertNotNull(containerForReceivedMessage.getRecordSenderToDec().getPerson());
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
        Assert.assertEquals(containerForSentMessage.getRecordSenderToDec().getContactData().getPostalAddress().getLandUnit(),
                containerForReceivedMessage.getRecordSenderToDec().getContactData().getPostalAddress().getLandUnit());
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

        // Recipient block
        Assert.assertNotNull(containerForSentMessage.getRecipient().get(0).getOrganisation());
        Assert.assertNotNull(containerForReceivedMessage.getRecipient().get(0).getOrganisation());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getRecipientRecordGuid(),
                containerForReceivedMessage.getRecipient().get(0).getRecipientRecordGuid());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getRecipientRecordOriginalIdentifier(),
                containerForReceivedMessage.getRecipient().get(0).getRecipientRecordOriginalIdentifier());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getMessageForRecipient(),
                containerForReceivedMessage.getRecipient().get(0).getMessageForRecipient());

        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getOrganisation().getName(),
                containerForReceivedMessage.getRecipient().get(0).getOrganisation().getName());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getOrganisation().getOrganisationCode(),
                containerForSentMessage.getRecipient().get(0).getOrganisation().getOrganisationCode());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getOrganisation().getResidency(),
                containerForSentMessage.getRecipient().get(0).getOrganisation().getResidency());
        Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getOrganisation().getStructuralUnit(),
                containerForReceivedMessage.getRecipient().get(0).getOrganisation().getStructuralUnit());
        if (containerForSentMessage.getRecipient().get(0).getPerson() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getRecipient().get(0).getPerson());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getPerson().getPersonalIdCode(),
                    containerForReceivedMessage.getRecipient().get(0).getPerson().getPersonalIdCode());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getPerson().getResidency(),
                    containerForReceivedMessage.getRecipient().get(0).getPerson().getResidency());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getPerson().getName(),
                    containerForReceivedMessage.getRecipient().get(0).getPerson().getName());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getPerson().getGivenName(),
                    containerForReceivedMessage.getRecipient().get(0).getPerson().getGivenName());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getPerson().getGivenName(),
                    containerForReceivedMessage.getRecipient().get(0).getPerson().getGivenName());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getPerson().getSurname(),
                    containerForReceivedMessage.getRecipient().get(0).getPerson().getSurname());
        }
        if (containerForSentMessage.getRecipient().get(0).getContactData() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getRecipient().get(0).getContactData());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getCountry(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getCountry());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getCounty(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getCounty());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getLocalGovernment(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getLocalGovernment());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getAdministrativeUnit(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getAdministrativeUnit());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getSmallPlace(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getSmallPlace());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getHouseNumber(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getHouseNumber());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getBuildingPartNumber(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getBuildingPartNumber());
            Assert.assertEquals(containerForSentMessage.getRecipient().get(0).getContactData().getPostalAddress().getPostalCode(),
                    containerForReceivedMessage.getRecipient().get(0).getContactData().getPostalAddress().getPostalCode());
        }

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
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getRecordAbstract(),
                containerForReceivedMessage.getRecordMetadata().getRecordAbstract());
        Assert.assertEquals(containerForSentMessage.getRecordMetadata().getReplyDueDate(),
                containerForReceivedMessage.getRecordMetadata().getReplyDueDate());

        // Access block
        if (containerForSentMessage.getAccess() != null) {
            Assert.assertEquals(containerForSentMessage.getAccess().getAccessConditionsCode(),
                    containerForReceivedMessage.getAccess().getAccessConditionsCode());
            if (containerForSentMessage.getAccess().getAccessRestriction() != null && containerForSentMessage.getAccess().getAccessRestriction().size() != 0) {
                Assert.assertNotNull(containerForReceivedMessage.getAccess().getAccessRestriction().get(0));
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getRestrictionIdentifier(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getRestrictionIdentifier());
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getRestrictionBeginDate(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getRestrictionBeginDate());
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getRestrictionEndDate(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getRestrictionEndDate());
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getRestrictionEndEvent(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getRestrictionEndEvent());
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getRestrictionInvalidSince(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getRestrictionInvalidSince());
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getRestrictionInvalidSince(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getRestrictionInvalidSince());
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getInformationOwner(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getInformationOwner());
                Assert.assertEquals(containerForSentMessage.getAccess().getAccessRestriction().get(0).getRestrictionBasis(),
                        containerForReceivedMessage.getAccess().getAccessRestriction().get(0).getRestrictionBasis());
            }
        }

        // DecMetaData block
        Assert.assertNotNull(containerForSentMessage.getDecMetadata());
        Assert.assertNotNull(containerForReceivedMessage.getDecMetadata());

        // SignatureMetadata block
        if (containerForSentMessage.getSignatureMetadata() != null && containerForSentMessage.getSignatureMetadata().size() != 0) {
            Assert.assertNotNull(containerForReceivedMessage.getSignatureMetadata().get(0));
            Assert.assertEquals(containerForSentMessage.getSignatureMetadata().get(0).getSignatureType(),
                    containerForReceivedMessage.getSignatureMetadata().get(0).getSignatureType());
            Assert.assertEquals(containerForSentMessage.getSignatureMetadata().get(0).getSigner(),
                    containerForReceivedMessage.getSignatureMetadata().get(0).getSigner());
            Assert.assertEquals(containerForSentMessage.getSignatureMetadata().get(0).getVerified(),
                    containerForReceivedMessage.getSignatureMetadata().get(0).getVerified());
            Assert.assertEquals(containerForSentMessage.getSignatureMetadata().get(0).getSignatureVerificationDate(),
                    containerForReceivedMessage.getSignatureMetadata().get(0).getSignatureVerificationDate());
        }

        // File block and content's asserts
        Assert.assertNotNull(containerForSentMessage.getFile().get(0));
        Assert.assertNotNull(containerForReceivedMessage.getFile().get(0));
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getFileName(),
                containerForReceivedMessage.getFile().get(0).getFileName());
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getFileSize(),
                containerForReceivedMessage.getFile().get(0).getFileSize());
        Assert.assertTrue(containerForSentMessage.getFile().get(0).getZipBase64Content().length() != 0);
        Assert.assertTrue(containerForReceivedMessage.getFile().get(0).getZipBase64Content().length() != 0);
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getZipBase64Content(),
                containerForReceivedMessage.getFile().get(0).getZipBase64Content());
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getFileGuid(),
                containerForReceivedMessage.getFile().get(0).getFileGuid());
        Assert.assertEquals(containerForSentMessage.getFile().get(0).getMimeType(),
                containerForReceivedMessage.getFile().get(0).getMimeType());

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

    private void doDataAsserts(ContainerVer2_1 containerForSentMessage,
                               ContainerVer1 containerForReceivedMessage) throws Exception {
        Assert.assertNotNull(containerForSentMessage);
        Assert.assertNotNull(containerForReceivedMessage);

        // Transport block
        Assert.assertNotNull(containerForSentMessage.getTransport());
        Assert.assertNotNull(containerForReceivedMessage.getTransport());

        // DecSender blocks
        DecSender decSender = containerForSentMessage.getTransport().getDecSender();
        Assert.assertNotNull(decSender);
        Saatja saatja = containerForReceivedMessage.getTransport().getSaatjad().get(0);
        Assert.assertNotNull(saatja);
        Assert.assertTrue(isTwoStringsIgnoreCaseEqual(decSender.getOrganisationCode(), saatja.getRegNr()));
        Assert.assertTrue(isTwoStringsIgnoreCaseEqual(decSender.getPersonalIdCode(), saatja.getIsikukood()));
        Assert.assertTrue(isTwoStringsIgnoreCaseEqual(decSender.getStructuralUnit(), saatja.getAllyksuseNimetus()));

        // DecRecipient blocks
        List<DecRecipient> decRecipientList = containerForSentMessage.getTransport().getDecRecipient();
        Assert.assertTrue(decRecipientList != null && decRecipientList.size() != 0);
        Assert.assertTrue(containerForReceivedMessage.getTransport().getSaajad() != null
                && containerForReceivedMessage.getTransport().getSaajad().size() != 0);
        Map<String, Saaja> saajad = new HashMap<String, Saaja>();
        for (Saaja saaja : containerForReceivedMessage.getTransport().getSaajad()) {
            saajad.put(saaja.getRegNr() + saaja.getIsikukood(), saaja);
        }
        for (DecRecipient decRecipient : decRecipientList) {
            Assert.assertTrue(saajad.containsKey(decRecipient.getOrganisationCode() + decRecipient.getPersonalIdCode()));
        }
        logger.debug("Transport block data is identical.");

        // RecordCreator block
        if (containerForSentMessage.getRecordCreator() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getMetaxml());
        }
        if (containerForSentMessage.getRecordCreator().getOrganisation() != null
                && containerForSentMessage.getRecordCreator().getOrganisation().getOrganisationCode() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getMetainfo());
            Assert.assertTrue(isTwoStringsIgnoreCaseEqual(containerForSentMessage.getRecordCreator().getOrganisation().getOrganisationCode(),
                    containerForReceivedMessage.getMetainfo().getKoostajaAsutuseNr()));
        }
        if (containerForSentMessage.getRecordCreator().getPerson() != null
                && containerForSentMessage.getRecordCreator().getPerson().getPersonalIdCode() != null) {
            Assert.assertNotNull(containerForReceivedMessage.getMetainfo());
            Assert.assertTrue(isTwoStringsIgnoreCaseEqual(containerForSentMessage.getRecordCreator().getPerson().getPersonalIdCode(),
                    containerForReceivedMessage.getMetainfo().getAutoriIsikukood()));
        }
        logger.debug("RecordCreator block data is identical.");

        // Recipient block

        // File block and content's asserts
        List<File> fileList = containerForSentMessage.getFile();
        Assert.assertTrue(fileList != null && fileList.size() != 0);
        Assert.assertNotNull(containerForReceivedMessage.getSignedDoc());
        Assert.assertTrue(containerForReceivedMessage.getSignedDoc().getDataFiles() != null
                && containerForReceivedMessage.getSignedDoc().getDataFiles().size() != 0);
        Map<String, DataFile> dataFiles = new HashMap<String, DataFile>();
        for (DataFile dataFile : containerForReceivedMessage.getSignedDoc().getDataFiles()) {
            dataFiles.put(dataFile.getFileName() + dataFile.getFileSize(), dataFile);
        }
        for (File file : fileList) {
            Assert.assertTrue(dataFiles.containsKey(file.getFileName() + file.getFileSize()));
            DataFile dataFile = dataFiles.get(file.getFileName() + file.getFileSize());
            Assert.assertNotNull(dataFile);
            Assert.assertTrue(isZipBase64ConvertedContentEqualToFileBase64Content(file.getZipBase64Content(), dataFile.getFileBase64Content()));
        }
        logger.debug("File block data is identical.");

    }

    private void doStatusAsserts(int statusOfSentMessage, int statusOfReceivedMessage) {
        Assert.assertEquals(Settings.Client_StatusSent, statusOfSentMessage);
        Assert.assertEquals(Settings.Client_StatusReceived, statusOfReceivedMessage);
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

    private boolean isZipBase64ConvertedContentEqualToFileBase64Content(String zipBase64Content, String fileBase64Content) throws Exception {
        // Decode and unzip zipBase64Content
        ByteArrayInputStream zipBase64ContentInputStream = new ByteArrayInputStream(
                zipBase64Content.getBytes("UTF-8"));
        Base64InputStream base64InputStream = new Base64InputStream(zipBase64ContentInputStream);
        GZIPInputStream gzipInputStream = new GZIPInputStream(base64InputStream);
        ByteArrayOutputStream unzippedByteOutputStream = new ByteArrayOutputStream();
        IOUtils.copy(gzipInputStream, unzippedByteOutputStream);
        base64InputStream.close();
        gzipInputStream.close();
        byte[] b = unzippedByteOutputStream.toByteArray();
        unzippedByteOutputStream.close();
        ByteArrayInputStream unzippedByteInputStream = new ByteArrayInputStream(b);

        // Encode unzipped content
        ByteArrayOutputStream encodedByteOutputStream = new ByteArrayOutputStream();
        Base64OutputStream base64OutputStream = new Base64OutputStream(encodedByteOutputStream, true, 76, "\n".getBytes());

        IOUtils.copy(unzippedByteInputStream, base64OutputStream);
        base64OutputStream.close();
        String base64encodedString = encodedByteOutputStream.toString();

        // Compare two encoded contents
        if (base64encodedString != null && fileBase64Content != null && base64encodedString.equalsIgnoreCase(fileBase64Content)) {
            return true;
        }
        return false;
    }

    private boolean isTwoStringsIgnoreCaseEqual(String str1, String str2) {
        if ((str1 == null || str1.isEmpty()) && (str2 == null || str2.isEmpty())) {
            return true;
        } else if (str1 != null) {
            return str1.equalsIgnoreCase(str2);
        }
        return false;
    }
}
