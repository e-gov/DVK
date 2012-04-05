package dvk.client.db;

import static org.junit.Assert.*;

import java.util.ArrayList;

import org.junit.Before;
import org.junit.Test;

public class UnitCredentialTest {

	@Before
	public void setUp() throws Exception {
	}

	@Test
	public void testAcceptsMessagesInFolder_FoldersNull_AcceptAll() {
		UnitCredential cred = new UnitCredential();
		cred.setFolders(null);
		assertTrue(cred.acceptsMessagesInFolder(null));
		assertTrue(cred.acceptsMessagesInFolder(""));
		assertTrue(cred.acceptsMessagesInFolder("/"));
		assertTrue(cred.acceptsMessagesInFolder("kataloog"));
	}

	@Test
	public void testAcceptsMessagesInFolder_FoldersEmpty_AcceptAll() {
		UnitCredential cred = new UnitCredential();
		cred.setFolders(new ArrayList<String>());
		assertTrue(cred.acceptsMessagesInFolder(null));
		assertTrue(cred.acceptsMessagesInFolder(""));
		assertTrue(cred.acceptsMessagesInFolder("/"));
		assertTrue(cred.acceptsMessagesInFolder("kataloog"));
	}
	
	@Test
	public void testAcceptsMessagesInFolder_RootFolder_AcceptRootAndUnspecified() {
		UnitCredential cred = new UnitCredential();
		cred.setFolders(new ArrayList<String>());
		cred.getFolders().add("/");
		
		assertTrue(cred.acceptsMessagesInFolder(null));
		assertTrue(cred.acceptsMessagesInFolder(""));
		assertTrue(cred.acceptsMessagesInFolder("/"));
		assertFalse(cred.acceptsMessagesInFolder("kataloog"));
	}
	
	@Test
	public void testAcceptsMessagesInFolder_SpecificFolder_AcceptMatching() {
		UnitCredential cred = new UnitCredential();
		cred.setFolders(new ArrayList<String>());
		cred.getFolders().add("/kataloog");
		
		assertFalse(cred.acceptsMessagesInFolder(null));
		assertFalse(cred.acceptsMessagesInFolder(""));
		assertFalse(cred.acceptsMessagesInFolder("/"));
		assertFalse(cred.acceptsMessagesInFolder("teine_kataloog"));
		assertTrue(cred.acceptsMessagesInFolder("kataloog"));
		assertTrue(cred.acceptsMessagesInFolder("/kataloog"));
		assertTrue(cred.acceptsMessagesInFolder("KATALOOG"));
		assertTrue(cred.acceptsMessagesInFolder("/KATALOOG"));
	}
	
	@Test
	public void testAcceptsMessagesInFolder_SpecificFolders_AcceptMatching() {
		UnitCredential cred = new UnitCredential();
		cred.setFolders(new ArrayList<String>());
		cred.getFolders().add("/kataloog");
		cred.getFolders().add("/kataloog2");
		
		assertFalse(cred.acceptsMessagesInFolder(null));
		assertFalse(cred.acceptsMessagesInFolder(""));
		assertFalse(cred.acceptsMessagesInFolder("/"));
		assertFalse(cred.acceptsMessagesInFolder("teine_kataloog"));
		assertTrue(cred.acceptsMessagesInFolder("kataloog"));
		assertTrue(cred.acceptsMessagesInFolder("/kataloog"));
		assertTrue(cred.acceptsMessagesInFolder("kataloog2"));
		assertTrue(cred.acceptsMessagesInFolder("/kataloog2"));
		assertTrue(cred.acceptsMessagesInFolder("KATALOOG"));
		assertTrue(cred.acceptsMessagesInFolder("/KATALOOG"));
		assertTrue(cred.acceptsMessagesInFolder("KATALOOG2"));
		assertTrue(cred.acceptsMessagesInFolder("/KATALOOG2"));
	}
}
