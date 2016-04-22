package integration;

import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.CommonStructures;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.ClientTestUtil;
import ee.ria.dvk.client.testutil.DBTestUtil;
import ee.ria.dvk.client.testutil.DhlSetting;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import junit.framework.Assert;
import org.apache.log4j.Logger;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.Arrays;
import java.util.List;

public class ClientNegativeCasesIntegration {
    private static Logger logger = Logger.getLogger(ClientRequestsIntegration.class);
    private static final int SEND_RECEIVE_MODE = 3;

    @Test
    public void serverIsMissingTest() {
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForNegativeCases();
        for (String path : configFilePaths) {
            // Execute Client with valid configuration, but with the wrong URL to the server
            ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);
            String errorMessageActual = "";
            String errorMessageExpected = "(404)Not Found";
            try {
                errorMessageActual = DBTestUtil.getTheLastErrorsMessage(path);
            } catch (Exception e) {
                Assert.fail();
            }
            Assert.assertEquals(errorMessageExpected, errorMessageActual);
        }
    }

    @Test
    public void sendersOrgCodeInsideTheMessageDoesNotMatchWithTheSendersOrgCodeInsideTheConfigFileTest() throws Exception{
        List<String> configFilePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();
        for (String path : configFilePaths) {
            int messageId = 0;
            // NB! DhlMessage.addToDB method requires document recipient orgCode matching to dhl_settings.institution_code
            DhlSetting oldSettings = DBTestUtil.fetchDhlSettings(path);
            DhlSetting newSettings = new DhlSetting(DhlSetting.CONTAINER_VERSION_2_1);
            try {
                DBTestUtil.updateDhlSettings(path, newSettings);
                messageId = DBTestUtil.insertNewMessageToDB(path, "xmlDataForNewMessage_other_sender.xml");
                Assert.assertTrue(messageId > 0);
                ClientTestUtil.executeTheClient(path, SEND_RECEIVE_MODE);
                String errorMessageActual = "";
                String errorMessageExpected = CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD;
                errorMessageActual = DBTestUtil.getTheLastErrorsMessage(path);
                Assert.assertEquals(errorMessageActual, errorMessageExpected);
                if (messageId > 0) {
                    putStatusCancelledToMessage(messageId, path);
                }
            } catch (Exception ex) {
                Assert.fail(ex.getMessage());
            } finally {
                DBTestUtil.restoreDhlSettings(path, oldSettings);
                DBTestUtil.clearDataBaseAfterTest(path, Arrays.asList(messageId));
            }
        }
    }

    private void putStatusCancelledToMessage(int messageId, String propertiesFile) throws Exception {
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(propertiesFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();

        String sql = "UPDATE DHL_MESSAGE SET sending_status_id = ? WHERE dhl_message_id = ?";
        try {
            PreparedStatement preparedStatement = dbConnection.prepareStatement(sql);
            preparedStatement.setInt(1, Settings.Client_StatusCanceled);
            preparedStatement.setInt(2, messageId);
            preparedStatement.execute();
            preparedStatement.close();
        } finally {
            DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
        }
    }
}
