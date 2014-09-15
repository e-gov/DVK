package integration;

import dhl.DocumentFile;
import ee.sk.digidoc.SignedDoc;
import ee.sk.digidoc.factory.DigiDocFactory;
import ee.sk.utils.ConfigManager;
import java.io.File;
import org.apache.log4j.Logger;
import org.junit.Test;

import static junit.framework.Assert.assertNotNull;
import static junit.framework.Assert.fail;

/**
 * @author Hendrik Pärna
 * @since 11.09.14
 */
public class JdigiDocIntegration {
    private static final Logger logger = Logger.getLogger(JdigiDocIntegration.class);

    @Test
    public void testFile() throws Exception {
        ConfigManager.init("C:\\Work\\Dev\\DVK\\server\\development\\trunk\\src\\test\\resources\\jdigidoc.conf");

        DigiDocFactory ddocFactory = ConfigManager.instance().getDigiDocFactory();

        File file = new File("C:\\Users\\hendrik\\AppData\\Local\\Temp\\dhl_1410524438937_item1");

        //String filePath = JdigiDocIntegration.class.getResource("C:\\Users\\hendrik\\AppData\\Local\\Temp\\dhl_1410523437549_item1").getPath();

        SignedDoc container = ddocFactory.readSignedDoc(file.getAbsolutePath());
        assertNotNull(container);
    }
}
