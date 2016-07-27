package dvk.api.container;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;

/**
 * @author Hendrik Pärna
 * @since 16.04.14
 */
public class TestingFileUtils {
    private static Logger logger = Logger.getLogger(TestingFileUtils.class);

    /**
     * Get String representation of inputStream
     * @param inputStream input
     * @return result String
     * @throws Exception
     */
    public static String getInputStreamContents(InputStream inputStream) throws Exception {
        InputStreamReader is = new InputStreamReader(inputStream, "UTF-8");
        BufferedReader br = new BufferedReader(is);
        String read = null;
        StringBuffer sb = new StringBuffer();

        try {
            while((read = br.readLine()) != null) {
                sb.append(read);
            }
        } catch (IOException e) {
            logger.error("Error reading stream: "+e.getMessage());
        }

        return sb.toString();
    }
}
