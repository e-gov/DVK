package dvk.client;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Ignore;
import org.junit.Test;

import dvk.client.conf.OrgSettings;
import dvk.client.iostructures.AditDocument;
import dvk.client.iostructures.AditGetSendStatusResponse;
import dvk.client.iostructures.AditReciever;
import dvk.core.Settings;
import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;

/**
 * @author Hendrik Pärna
 * @since 4.04.14
 */
/**
 * TODO: This test must be updated properly and added to the integration tests. For now it is ignored.
 */
@Ignore
public class MessageRecipientUpdateTests {


    @Test
    public void testUpdateOpenedDateForMessageRecipient() throws Exception {
        AditGetSendStatusResponse response = new AditGetSendStatusResponse();
        response.aditDocuments = new ArrayList<AditDocument>();

        AditDocument doc = new AditDocument();
        doc.dhlId = 3745;
        doc.aditRecievers = new ArrayList<AditReciever>();
        AditReciever reciever = new AditReciever();
        reciever.opened = true;
        reciever.openedDate = new Date();
        reciever.personIdCode = "EE36212240216";
        reciever.senderName = "Some name";
        doc.aditRecievers.add(reciever);
        response.aditDocuments.add(doc);

        Settings.loadProperties(IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases().get(0));
        List<OrgSettings> allKnownDatabases= OrgSettings.getSettings(Settings.Client_ConfigFile);
        ClientAPI client = new ClientAPI();
        AditGetSendStatusService service = new AditGetSendStatusService("test", client);

        Connection dbConnection = client.getSafeDbConnection(allKnownDatabases.get(0));

        service.updateOpenedDateFor(response, allKnownDatabases.get(0), dbConnection);

    }

}
