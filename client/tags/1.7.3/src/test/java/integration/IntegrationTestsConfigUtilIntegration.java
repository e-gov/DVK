package integration;

import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;
import org.junit.Assert;
import org.junit.Test;

import java.util.List;

/**
 * @author Hendrik Pärna
 * @since 13.03.14
 */
public class IntegrationTestsConfigUtilIntegration {
    @Test
    public void testFindAbsolutePathsForCurrentProfile() {
        List<String> absolutePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();;

        Assert.assertNotNull(absolutePaths);
    }
}
