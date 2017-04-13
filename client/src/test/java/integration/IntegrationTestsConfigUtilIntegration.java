package integration;

import java.util.List;

import org.junit.Assert;
import org.junit.Test;

import ee.ria.dvk.client.testutil.IntegrationTestsConfigUtil;

/**
 * @author Hendrik Pärna
 * @since 13.03.14
 */
public class IntegrationTestsConfigUtilIntegration {
    @Test
    public void testFindAbsolutePathsForCurrentProfile() {
        List<String> absolutePaths = IntegrationTestsConfigUtil.getAllConfigFilesAbsolutePathsForPositiveCases();

        Assert.assertNotNull(absolutePaths);
    }
}
