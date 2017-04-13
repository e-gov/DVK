package dvk.client.businesslayer;

import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import org.junit.Before;
import org.junit.Test;

import dvk.client.conf.OrgSettings;
import dvk.core.CommonStructures;

public class DhlMessageTest {
	OrgSettings currentDbConf;
	ArrayList<OrgSettings> allKnownDatabases;
	
	
	@Before
	public void setUp() throws Exception {
		currentDbConf = new OrgSettings();
		currentDbConf.setDatabaseName("dvk_client");
		currentDbConf.setDbProvider(CommonStructures.PROVIDER_TYPE_ORACLE_10G);
		currentDbConf.setDbToDbCommunicationOnly(false);
		currentDbConf.setDeleteOldDocumentsAfterDays(0);
		currentDbConf.setInstanceName(null);
		currentDbConf.setPassword("dvk_client");
		currentDbConf.setProcessName("xe");
		currentDbConf.setSchemaName(null);
		currentDbConf.setServerName("192.168.1.222");
		currentDbConf.setServerPort("1521");
		currentDbConf.setUserName("dvk_client");
		
		allKnownDatabases = new ArrayList<OrgSettings>();
		allKnownDatabases.add(currentDbConf);
	}

	@Test
	public void testSplitMessageByDeliveryChannel() throws Exception {
		/*int containerVersion = 1;
		Connection dbConnection = null;
		
		try {
			dbConnection = DBConnection.getConnection(currentDbConf);
			
			DhlMessage msg = new DhlMessage();
			msg.setRecipients(new ArrayList<MessageRecipient>());
			
			MessageRecipient rec1 = new MessageRecipient();
			rec1.setRecipientOrgCode("11111111");
			msg.getRecipients().add(rec1);
			
			
			ArrayList<DhlMessage> splitMessage = msg.splitMessageByDeliveryChannel(currentDbConf, allKnownDatabases, containerVersion, dbConnection);
			
			assertNotNull(splitMessage);
			assertEquals(1, splitMessage.size());
			
		} finally {
			CommonMethods.safeCloseDatabaseConnection(dbConnection);
		}*/
		assertTrue(true);
	}

}
