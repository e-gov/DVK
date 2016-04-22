package dhl.requests;

import dhl.requests.ReceiveDocuments;
import junit.framework.Assert;
import org.junit.Test;

/**
 * @author Hendrik Pärna
 * @since 17.02.14
 */
public class IsContainerConversionNeededTest {

    @Test
    public void whenCorrectParameters() throws Exception {
        Assert.assertTrue(ReceiveDocuments.isContainerConversionNeeded("1.0", "2.1"));
    }

    @Test
    public void when_ContainerVersionNonSpecified_for_Org2_1() throws Exception {
        Assert.assertFalse(ReceiveDocuments.isContainerConversionNeeded("2.1", null));
    }

    @Test
    public void when_ContainerVersionNonSpecified_for_Org1_0() throws Exception {
        Assert.assertFalse(ReceiveDocuments.isContainerConversionNeeded("1.0", null));
    }

    @Test
    public void when_inputDataIsMissing() {
        Assert.assertFalse(ReceiveDocuments.isContainerConversionNeeded(null, null));
    }
}
