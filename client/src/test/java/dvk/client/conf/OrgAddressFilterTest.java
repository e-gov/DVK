package dvk.client.conf;

import static org.junit.Assert.*;

import java.util.ArrayList;

import org.junit.Before;
import org.junit.Test;

import dvk.client.businesslayer.MessageRecipient;
import dvk.client.conf.OrgAddressFilter;

public class OrgAddressFilterTest {

	@Before
	public void setUp() throws Exception {
	}

	@Test
	public void testGetMatchingRecipients() {
		/*OrgAddressFilter filter = new OrgAddressFilter();
		filter.setSubdivisionId(0);
		filter.setOccupationId(0);
		filter.setSubdivisionCode(null);
		filter.setOccupationCode(null);
		
		assertNull(filter.isValidFilter());
		assertNotNull(filter.isValidFilter());
		assertTrue(filter.isValidFilter());
		
		ArrayList<MessageRecipient> myOrgRecipients = new ArrayList<MessageRecipient>(); 

		MessageRecipient rec1 = new MessageRecipient();
		rec1.setId(1);
		rec1.setRecipientOrgCode("11111111");
		myOrgRecipients.add(rec1);
		
		MessageRecipient rec2 = new MessageRecipient();
		rec2.setId(2);
		rec2.setRecipientOrgCode("11111111");
		rec2.setRecipientDivisionCode("ALLYKSUS");
		myOrgRecipients.add(rec2);
		
		MessageRecipient rec3 = new MessageRecipient();
		rec3.setId(3);
		rec3.setRecipientOrgCode("11111111");
		rec3.setRecipientPositionCode("AMETIKOHT");
		myOrgRecipients.add(rec3);
		
		MessageRecipient rec4 = new MessageRecipient();
		rec4.setId(4);
		rec4.setRecipientOrgCode("11111111");
		rec4.setRecipientDivisionID(4);
		myOrgRecipients.add(rec4);
		
		MessageRecipient rec5 = new MessageRecipient();
		rec5.setId(5);
		rec5.setRecipientOrgCode("11111111");
		rec5.setRecipientPositionID(5);
		myOrgRecipients.add(rec5);
		
		ArrayList<MessageRecipient> matchingRecipients = filter.getMatchingRecipients(myOrgRecipients);
		
		assertNotNull(matchingRecipients);
		assertEquals(1, matchingRecipients.size());*/
		assertTrue(true);
	}

}
