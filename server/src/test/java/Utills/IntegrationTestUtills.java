package Utills;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.UUID;
import java.util.zip.GZIPInputStream;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;
import org.apache.commons.io.IOUtils;

public class IntegrationTestUtills {
    public static File gunzip(InputStream inputStream) throws Exception {
        File output = new File(UUID.randomUUID().toString());
        try {
            GZIPInputStream gZIPInputStream = new GZIPInputStream(inputStream);
            FileOutputStream fileOutputStream = new FileOutputStream(output);
            IOUtils.copy(gZIPInputStream, fileOutputStream);
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
        OutputStream outputStream = null;
        InputStream base64DecoderStream = javax.mail.internet.MimeUtility.decode(inputStream, "base64");
        File file = new File(UUID.randomUUID().toString());
        try {
            outputStream = new FileOutputStream(file);
            IOUtils.copy(base64DecoderStream, outputStream);
            outputStream.flush();
        } finally {
            try {
                outputStream.close();
                inputStream.close();
            } catch (IOException e) {
                throw new RuntimeException(e);
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
