package dvk.client.iostructures;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.StringReader;
import java.util.List;

import org.apache.log4j.Logger;

import dvk.client.businesslayer.MessageRecipient;
import dvk.core.CommonMethods;

/**
 * @author Hendrik Pärna
 * @since 1.04.14
 */
public class AditGetSendStatusRequest {
    static Logger logger = Logger.getLogger(AditGetSendStatusRequest.class.getName());

    private String createRequestXml(List<MessageRecipient> messageRecipients) {
        if (messageRecipients == null) {
            throw new IllegalArgumentException("MessageRecipients must be set.");
        }
        StringBuilder sb = new StringBuilder();
        sb.append("<item>");
        for (MessageRecipient messageRecipient: messageRecipients) {
            sb.append("<dhl_id>");
            sb.append(messageRecipient.getDhlID());
            sb.append("</dhl_id>");
        }
        sb.append("</item>");
        return sb.toString();
    }

    /**
     * Create xml for AditGetSendStatus and save it to a temporary file.
     * @param messageRecipients list of {@link MessageRecipient}
     * @param filename name of the temporary file
     * @return File containing xml for request.
     */
    public File createAndSaveTempFile(List<MessageRecipient> messageRecipients, String filename) {
        String xmlRequest = createRequestXml(messageRecipients);
        String pathToFile = CommonMethods.gzipPackXML(saveXmlRequestToFile(filename, xmlRequest).getAbsolutePath());
        return new File(pathToFile);
    }

    private File saveXmlRequestToFile(String filename, String xmlRequest) {
        if (filename == null) {
           throw new IllegalArgumentException("Filename must be specified.");
        }

        if (xmlRequest == null) {
           throw new IllegalStateException("Nothing to write to file");
        }

        File tempFile = CommonMethods.createTempFile(filename);

        BufferedReader bufferedReader = null;
        BufferedWriter bufferedWriter = null;
        try {
            StringReader stringReader = new StringReader(xmlRequest);
            bufferedReader = new BufferedReader(stringReader);
            FileWriter fileWriter = new FileWriter(tempFile);
            bufferedWriter = new BufferedWriter(fileWriter);
            for (String line = bufferedReader.readLine(); line != null; line = bufferedReader.readLine()) {
                bufferedWriter.write(line);
                bufferedWriter.newLine();
            }
        } catch (FileNotFoundException e) {
            throw new RuntimeException("Unable to find temp file", e);
        } catch (IOException e) {
            throw new RuntimeException("Unable to write to temp file", e);
        } finally {
            try {
                if (bufferedReader != null) {
                    bufferedReader.close();
                }
            } catch (IOException e) {
                logger.error("unable to close reader, ", e);
            }
            try {
                if (bufferedWriter != null) {
                    bufferedWriter.close();
                }
            } catch (IOException e) {
                logger.error("unable to close writer, ", e);
            }
        }

        return tempFile;
    }
}