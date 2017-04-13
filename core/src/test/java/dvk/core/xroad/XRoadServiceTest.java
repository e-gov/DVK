package dvk.core.xroad;

import static org.hamcrest.CoreMatchers.equalTo;
import static org.hamcrest.CoreMatchers.not;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertThat;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import dvk.core.util.DVKServiceMethod;

public class XRoadServiceTest {
    
    private static final String DVK_SUBSYSTEM_CODE = "dhl";
    
    private static final String ADIT_SUBSYSTEM_CODE = "adit"; 
    
    private XRoadService defaultDvkXRoadService;

    @Before
    public void setUp() {
        defaultDvkXRoadService = createNewRiaXRoadService(DVK_SUBSYSTEM_CODE);
    }

    @Test
    public void testIsValid() {
        assertFalse(defaultDvkXRoadService.isValid());
        
        defaultDvkXRoadService.setServiceCode(DVKServiceMethod.SEND_DOCUMENTS.getName());
        assertTrue(defaultDvkXRoadService.isValid());
    }

    @Test
    public void testIsValidWithAddress() {
        defaultDvkXRoadService.setServiceCode(DVKServiceMethod.SEND_DOCUMENTS.getName());
        assertFalse(defaultDvkXRoadService.isValidWithAddress());
        
        defaultDvkXRoadService.setServiceURL("http://www.riik.ee/schemas/dhl");
        assertTrue(defaultDvkXRoadService.isValid());
    }
    
    @Test
    public void testIsEmpty() {
        XRoadService xRoadService = new XRoadService();
        assertTrue(xRoadService.isEmpty());
        
        xRoadService = createNewRiaXRoadService(DVK_SUBSYSTEM_CODE);
        assertFalse(xRoadService.isEmpty());
    }

    @Test
    public void testIsEmptyWithAddress() {
        XRoadService xRoadService = new XRoadService();
        assertTrue(xRoadService.isEmptyWithAddress());
    }

    @Test
    public void emptyObjectsHashCodesShouldBeEqual() {
        XRoadService xRoadService1 = new XRoadService();
        XRoadService xRoadService2 = new XRoadService();
        
        assertEquals(xRoadService1.hashCode(), xRoadService2.hashCode());
    }
    
    @Test
    public void equalXRaodServicesHashCodesShouldBeTheSame() {
        XRoadService xRoadService1 = createNewRiaXRoadService(DVK_SUBSYSTEM_CODE);
        XRoadService xRoadService2 = createNewRiaXRoadService(DVK_SUBSYSTEM_CODE);
        
        assertEquals(xRoadService1.hashCode(), xRoadService2.hashCode());
        
        xRoadService1.setServiceCode(DVKServiceMethod.SEND_DOCUMENTS.getName());
        xRoadService1.setServiceVersion("v1");
        xRoadService2.setServiceCode(DVKServiceMethod.SEND_DOCUMENTS.getName());
        xRoadService2.setServiceVersion("v2");
        
        assertFalse(xRoadService1.hashCode() == xRoadService2.hashCode());
        
        xRoadService2.setServiceVersion("v1");
        assertTrue(xRoadService1.hashCode() == xRoadService2.hashCode());
    }
    
    @Test
    public void emptyObjectsShouldBeEqual() {
        XRoadService xRoadService1 = new XRoadService();
        XRoadService xRoadService2 = new XRoadService();
        
        assertEquals(xRoadService1, xRoadService2);
    }
    
    @Test
    public void testEqualXRoadServices() {
        XRoadService anotherDvkXRoadService = createNewRiaXRoadService(DVK_SUBSYSTEM_CODE);
        
        assertEquals(defaultDvkXRoadService, anotherDvkXRoadService);
    }
    
    @Test
    public void testNonEqualXRaodServices() {
        XRoadService aditXRoadService = createNewRiaXRoadService(ADIT_SUBSYSTEM_CODE);
        assertThat(defaultDvkXRoadService, not(equalTo(aditXRoadService)));
    }
    
    @Test
    public void testXRaodServicesWithDifferentServiceVersion() {
        String serviceVersion2 = "v2";
        
        defaultDvkXRoadService.setServiceCode(DVKServiceMethod.SEND_DOCUMENTS.getName());
        defaultDvkXRoadService.setServiceVersion(serviceVersion2);
        
        XRoadService anotherDvkXRoadService = createNewRiaXRoadService(DVK_SUBSYSTEM_CODE);
        anotherDvkXRoadService.setServiceCode(DVKServiceMethod.SEND_DOCUMENTS.getName());
        anotherDvkXRoadService.setServiceVersion("v3");
        
        assertThat(defaultDvkXRoadService, not(equalTo(anotherDvkXRoadService)));
        
        anotherDvkXRoadService.setServiceVersion(serviceVersion2);
        assertEquals(defaultDvkXRoadService, anotherDvkXRoadService);
    }
    
    private XRoadService createNewRiaXRoadService(String subsystemCode) {
        XRoadService newDvkXRoadService = new XRoadService();
        newDvkXRoadService.setXRoadInstance("EE");
        newDvkXRoadService.setMemberClass("GOV");
        newDvkXRoadService.setMemberCode("70006317");
        newDvkXRoadService.setSubsystemCode(subsystemCode);
        
        return newDvkXRoadService;
    }

}
