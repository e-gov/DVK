/**
 * 
 */
package dhl;

import static org.junit.Assert.*;

import org.junit.Before;
import org.junit.Test;
import org.omg.PortableInterceptor.SUCCESSFUL;

import dhl.Folder;

/**
 * @author Jaak
 *
 */
public class FolderTest {

	/**
	 * @throws java.lang.Exception
	 */
	@Before
	public void setUp() throws Exception {
		
	}

	/**
	 * Test method for {@link dhl.Folder#correctFolderName(java.lang.String)}.
	 */
	@Test
	public void testCorrectFolderName() {
		Folder f = new Folder();
		assertEquals("KAUST", f.correctFolderName("kaust"));
		assertEquals("1234", f.correctFolderName("1õ2ä3ö4ü"));
		assertEquals("1234", f.correctFolderName("1\\2:3;4."));
	}
	
	/**
	 * Checks wheather or not the field accessors (get() and set() methods)
	 * work properly.
	 */
	@Test
	public void allAccessorsWorkProperly() {
		Folder f = new Folder();
		
		f.setId(100);
		f.setFolderNumber("123-ABC");
		f.setNimi("alamkataloog");
		f.setOrganizationID(25);
		f.setParentFolderID(50);
		f.setPositionID(75);
		
		assertEquals(100, f.getId());
		assertEquals("123-ABC", f.getFolderNumber());
		
		// All folder names are converted to UPPER CASE
		assertEquals("ALAMKATALOOG", f.getNimi()); 
		
		assertEquals(25, f.getOrganizationID());
		assertEquals(50, f.getParentFolderID());
		assertEquals(75, f.getPositionID());
	}

}
