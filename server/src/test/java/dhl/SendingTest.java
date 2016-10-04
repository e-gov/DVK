/**
 * 
 */
package dhl;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import java.util.ArrayList;

import org.junit.Before;
import org.junit.Test;

import dhl.users.UserProfile;
import dvk.core.CommonStructures;
import dvk.core.Settings;

/**
 * @author Jaak
 *
 */
public class SendingTest {
	
	// Org 1
	private int org1Id;
	private String org1Code;
	private String org1Name;
	
	// Org 2
	private int org2Id;
	private String org2Code;
	//private String org2Name;
	
	private UserProfile org1UserWithOrgAdminRole;
	private UserProfile org2UserWithOrgAdminRole;
	private Sending sending;
	
	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		org1Id = 1;
		org1Code = "12345678";
		org1Name = "Asutus";
		
		org2Id = 2;
		org2Code = "87654321";
		//org2Name = "Ettevõte";
		//org2Code = "70006317";
		
		org1UserWithOrgAdminRole = new UserProfile();
		org1UserWithOrgAdminRole.setOrganizationID(org1Id);
		org1UserWithOrgAdminRole.setOrganizationCode(org1Code);
		org1UserWithOrgAdminRole.setPersonCode("38005130332");
		org1UserWithOrgAdminRole.setPersonID(1);
		org1UserWithOrgAdminRole.setRoles(new ArrayList<String>());
		org1UserWithOrgAdminRole.getRoles().add(CommonStructures.ROLL_ASUTUSE_ADMIN);
		
		org2UserWithOrgAdminRole = new UserProfile();
		org2UserWithOrgAdminRole.setOrganizationID(org2Id);
		org2UserWithOrgAdminRole.setOrganizationCode(org2Code);
		org2UserWithOrgAdminRole.setPersonCode("37001010001");
		org2UserWithOrgAdminRole.setPersonID(2);
		org2UserWithOrgAdminRole.setRoles(new ArrayList<String>());
		org2UserWithOrgAdminRole.getRoles().add(CommonStructures.ROLL_ASUTUSE_ADMIN);
		
		sending = new Sending();
		Sender sender = new Sender();
        sender.setId(1);
        sender.setSendingID(1);
        sender.setOrganizationID(org1Id);
        sender.setPositionID(0);
        sender.setDivisionID(0);
        sender.setPositionShortName("");
        sender.setDivisionShortName("");
        sender.setName("Jaak Lember");
        sender.setOrganizationName(org1Name);
        sender.setEmail("");
        sender.setDepartmentNumber("");
        sender.setDepartmentName("");
        sender.setPersonalIdCode("38005130332");
        
        Recipient recipient = new Recipient();
        recipient.setId(1);
        recipient.setSendingID(1);
        recipient.setOrganizationID(org1Id);
        recipient.setPositionID(0);
        recipient.setDivisionID(0);
        recipient.setPositionShortName("");
        recipient.setDivisionShortName("");
        recipient.setName("Jaak Lember");
        recipient.setOrganizationName(org1Name);
        recipient.setEmail("");
        recipient.setDepartmentNumber("");
        recipient.setDepartmentName("");
        recipient.setPersonalIdCode("38005130332");
        
        sending.setSender(sender);
        sending.getRecipients().add(recipient);
	}
	
	/**
	 * Test method for {@link dhl.Sending#isStatusAccessibleToUser(dhl.users.UserProfile)}.
	 */
	@Test
	public void testIsStatusAccessibleToUser_SenderOrgUser_ReturnsTrue() {
		Settings.Server_DocumentSenderMustMatchXroadHeader = true;
		assertTrue(sending.isStatusAccessibleToUser(org1UserWithOrgAdminRole));
		
		Settings.Server_DocumentSenderMustMatchXroadHeader = false;
		assertTrue(sending.isStatusAccessibleToUser(org1UserWithOrgAdminRole));
	}
	
	@Test
	public void testIsStatusAccessibleToUser_DifferentOrgUser_ReturnsFalse() {
		Settings.Server_DocumentSenderMustMatchXroadHeader = true;
		assertFalse(sending.isStatusAccessibleToUser(org2UserWithOrgAdminRole));
		
		Settings.Server_DocumentSenderMustMatchXroadHeader = false;
		assertTrue(sending.isStatusAccessibleToUser(org2UserWithOrgAdminRole));
	}

}
