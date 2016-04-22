package ee.ria.dvk.client.testutil;

import dvk.client.Client;
import junit.framework.Assert;
import org.apache.log4j.Logger;

public class ClientTestUtil {
    private static Logger logger = Logger.getLogger(ClientTestUtil.class);

    public static void executeTheClient(String configFile, int mode) {
        try {
            String[] args = new String[]{"-mode=" + mode, "-prop=" + configFile};
            Client.main(args);
        } catch (Exception e) {
            logger.error(e.getMessage());
            Assert.fail();
        }
    }
}
