package integration;

import java.sql.Connection;
import java.util.Date;
import java.util.List;

import org.junit.Assert;

import dvk.client.businesslayer.DhlMessage;
import dvk.client.businesslayer.MessageRecipient;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.Settings;

/**
 * @author Hendrik Pärna
 * @since 26.03.14
 */
public class GetSendStatusIntegration {

    //TODO: finish tests
    //@Test
    public void when_weInsertAMessageSentToAditThatHasNotBeenOpened_ThenItMustBeFound() throws Exception {
        String path = GetSendStatusIntegration.class.getResource(
                "../conf/integrationTests/dvk_client_postgreSQL_hendrik.properties").getPath();

        DhlMessage message = new DhlMessage();
        message.setIsIncoming(false);
        message.setFilePath(GetSendStatusIntegration.class.getResource("../xmlDataForNewMessage.xml").getPath());
        message.setDhlID(0);
        message.setTitle("Testmessage");
        message.setSenderOrgCode("10885324");
        message.setSenderOrgName("Icefire OÜ");
        message.setSenderPersonCode("36212240216");
        message.setSenderName("TestPerson");
        message.setRecipientOrgCode("Adit");
        message.setRecipientOrgName("Adit");
        message.setRecipientPersonCode("36212240216");
        message.setRecipientName("Recipient");
        message.setCaseName("Case name");
        message.setDhlFolderName("/");
        message.setSendingStatusID(1);
        message.setUnitID(0);
        message.setSendingDate(new Date());


        Settings.loadProperties(path);
        List<OrgSettings> allKnownDatabases= OrgSettings.getSettings(Settings.Client_ConfigFile);
        Connection connection = DBConnection.getConnection(allKnownDatabases.get(0));
        DatabaseSessionService.getInstance().setSession(connection, allKnownDatabases.get(0));

        int messageId = message.addToDB(
                DatabaseSessionService.getInstance().getOrgSettings(),
                DatabaseSessionService.getInstance().getConnection());

        MessageRecipient messageRecipient = new MessageRecipient();
        messageRecipient.setDhlId(0);
        messageRecipient.setRecipientOrgCode(message.getRecipientOrgCode());
        messageRecipient.setMessageID(messageId);

        int messageRecipientId = messageRecipient.saveToDB(
                DatabaseSessionService.getInstance().getOrgSettings(),
                DatabaseSessionService.getInstance().getConnection());



        Assert.fail();
    }
}
