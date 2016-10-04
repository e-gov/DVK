package ee.ria.dvk.client.testutil;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.Clob;

/**
 * @author Hendrik Pärna
 * @since 21.03.14
 */
public class FileUtil {

    public static String readSQLToString(String filePath) throws Exception {
        StringBuilder fileData = new StringBuilder();
        BufferedReader reader = new BufferedReader(new InputStreamReader(
                new FileInputStream(filePath), "UTF-8"));
        char[] buf = new char[1024];
        int numRead = 0;

        while((numRead=reader.read(buf)) != -1) {
            String readData = String.valueOf(buf, 0, numRead);
            fileData.append(readData);
        }
        reader.close();

        return fileData.toString();
    }

    public static String parseClobData(Clob clob) throws Exception {
        StringBuffer stringBuffer = new StringBuffer();
        String strng;

        BufferedReader bufferRead = new BufferedReader(clob.getCharacterStream());

        while ((strng=bufferRead.readLine()) != null) {
            stringBuffer.append(strng);
        }

        return stringBuffer.toString();
    }
}
