package Utills;

import org.apache.axiom.om.OMElement;

import javax.xml.namespace.QName;
import java.io.*;
import java.util.Iterator;
import java.util.UUID;
import java.util.zip.GZIPInputStream;

public class IntegrationTestUtills {
    public static File gunzip(InputStream inputStream) throws Exception {
        byte[] buffer = new byte[1024];
        File output = new File("target", UUID.randomUUID().toString());
        output.createNewFile();

        try {
            GZIPInputStream gZIPInputStream = new GZIPInputStream(inputStream);
            FileOutputStream fileOutputStream = new FileOutputStream(output);

            int bytes_read;

            while ((bytes_read = gZIPInputStream.read(buffer)) > 0) {
                fileOutputStream.write(buffer, 0, bytes_read);
            }

            fileOutputStream.flush();
            gZIPInputStream.close();
            fileOutputStream.close();

            System.out.println("The file was decompressed successfully!");

        } catch (IOException ex) {
            ex.printStackTrace();
        }

        return output;
    }

    public static File decodeBase64FileFrom(InputStream inputStream) throws Exception {
        byte[] bytes = new byte[65536];
        File file = new File("target", UUID.randomUUID().toString());

        OutputStream outputStream = null;
        InputStream base64DecoderStream = javax.mail.internet.MimeUtility.decode(inputStream, "base64");

        try {
            outputStream = new FileOutputStream(file);
            int len = 0;
            while ((len = base64DecoderStream.read(bytes, 0, bytes.length)) > 0) {
                outputStream.write(bytes, 0, len);
            }
            outputStream.flush();
        } catch (FileNotFoundException e) {
        } catch (IOException e) {
        } finally {
            try {
                outputStream.close();
                inputStream.close();
            } catch (IOException e) {
            }
        }

        return file;
    }

    public static String getContentID(OMElement omElement) {
        Iterator it = omElement.getChildren();
        QName href = new QName("href");

        String contentID = "";

        while (it.hasNext()) {
            OMElement element = (OMElement) it.next();
            if (element.getLocalName().equals("keha") && element.getAttribute(href) != null) {
                contentID = element.getAttributeValue(href).substring(4);
            } else if (element.getLocalName().equals("keha"))  {
                contentID = element.getFirstChildWithName(new QName("dokumendid")).getAttributeValue(href).substring(4);
            }
        }

        return contentID;
    }

}
