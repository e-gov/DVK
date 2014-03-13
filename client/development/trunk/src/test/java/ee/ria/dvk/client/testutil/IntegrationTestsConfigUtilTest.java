package ee.ria.dvk.client.testutil;

import org.junit.Assert;
import org.junit.Test;

import java.util.List;

/**
 * @author Hendrik Pärna
 * @since 13.03.14
 */
public class IntegrationTestsConfigUtilTest {
    @Test
    public void testFindAbsolutePathsForCurrentProfile() {
        List<String> absolutePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePaths();

        Assert.assertNotNull(absolutePaths);
        Assert.assertEquals(1, absolutePaths.size());
    }
}
