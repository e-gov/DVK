package integration;

import dvk.core.CommonStructures;
import oracle.jdbc.pool.OracleDataSource;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.soap.SOAP11Constants;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axis2.Constants;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.transport.http.HTTPConstants;
import org.apache.commons.httpclient.Header;
import org.apache.commons.io.FileUtils;
import org.apache.log4j.Logger;
import org.junit.Assert;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import javax.xml.namespace.QName;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.UUID;
import java.util.zip.GZIPInputStream;

/**
 * Integration tests for receiveDocuments.v1-v4 webservice methods.
 *
 * @author Hendrik Pärna
 * @since 17.12.13
 */
public class ReceiveDocumentsIntegration {
    private static Logger logger = Logger.getLogger(ReceiveDocumentsIntegration.class);

    private static Options options;

    @BeforeClass
    public static void setUp() throws Exception {
        String serviceUrl = "http://0.0.0.0:9099/services/dhlHttpSoapPort";
        EndpointReference endpointReference = new EndpointReference(serviceUrl);
        options = new Options();
        options.setTo(endpointReference);
        options.setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        options.setTransportInProtocol(Constants.TRANSPORT_HTTP);
        options.setSoapVersionURI(SOAP11Constants.SOAP_ENVELOPE_NAMESPACE_URI);
        options.setProperty(HTTPConstants.HTTP_PROTOCOL_VERSION, HTTPConstants.HEADER_PROTOCOL_11);
        options.setProperty(HTTPConstants.CHUNKED, Boolean.FALSE);
        ArrayList<Header> customHeaders = new ArrayList<Header>();
        customHeaders.add(new Header("Connection", "close"));
        customHeaders.add(new Header("Cache-control", "no-cache"));
        customHeaders.add(new Header("Pragma", "no-cache"));
        options.setProperty(HTTPConstants.HTTP_HEADERS, customHeaders);
    }

    private static XHeaderBuilder getDefaultXHeaderBuilder() {
        XHeaderBuilder xHeaderBuilder = new XHeaderBuilder();
        xHeaderBuilder.setAsutus("87654321").setAndmekogu("dhl")
                .setAmetnik("EE38806190294").setId("6cae248568b3db7e97ff784673a4d38c5906bee0")
                .setNimi("dhl.sendDocuments.v1").setToimik("").setIsikukood("EE38806190294");
        return xHeaderBuilder;
    }

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_v1_receiveDocuments_mustRespondWithTheSameDocument() throws Exception {
        updatePreviouslySentDocumentsStatusToReceived();

        SendDocumentsDvkSoapClient sendDocumentsDvkSoapClient = new SendDocumentsDvkSoapClient(options);

        MessageContext sendDocumentsMessageContext = sendDocumentsDvkSoapClient.sendMessage(
                "../testcontainers/v1_0/dvk_konteiner_v1.xml.gz", getDefaultXHeaderBuilder().build());
        SOAPEnvelope sendDocumentsResponse = sendDocumentsMessageContext.getEnvelope();
        Assert.assertTrue(sendDocumentsResponse.toString().contains("keha href=\"cid"));

        ReceiveDocumentsDvkSoapClient receiveDocumentsDvkSoapClient = new ReceiveDocumentsDvkSoapClient(options);
        MessageContext receiveDocumentsMessageContext = receiveDocumentsDvkSoapClient.sendMessage(
                getDefaultXHeaderBuilder().setNimi("dhl.receiveDocuments.v1").build());
        SOAPEnvelope receiveDocumentsResponse = receiveDocumentsMessageContext.getEnvelope();

        logger.info("response: "+receiveDocumentsResponse.toString());
        Assert.assertTrue(receiveDocumentsResponse.toString().contains("keha href=\"cid"));

        String contentID = getContentID(receiveDocumentsResponse.getBody().getFirstElement());
        InputStream input = new FileInputStream(decodeBase64FileFrom(receiveDocumentsMessageContext.getAttachment(contentID).getInputStream()));
        String xml = FileUtils.readFileToString(gunzip(input));
        logger.debug("xml: "+xml);
        Assert.assertTrue(xml.contains("<ma:dhl_id>"));
        Assert.assertTrue(xml.contains("<mm:koostaja_asutuse_nr>87654321</mm:koostaja_asutuse_nr>"));
    }

    private String getContentID(OMElement omElement) {
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

    @Test
    public void whenContainer_V21_isSentTo_sendDocuments_v4_receiveDocuments_v1_mustRespondWithTheSameDocument_withAutomaticMetadata() throws Exception {
        updatePreviouslySentDocumentsStatusToReceived();

        SendDocumentsDvkSoapClient sendDocumentsDvkSoapClient = new SendDocumentsDvkSoapClient(options);

        MessageContext sendDocumentsMessageContext = sendDocumentsDvkSoapClient.sendMessage(
                "../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide3.xml.gz",
                    getDefaultXHeaderBuilder().setNimi("dhl.sendDocuments.v4").build());
        SOAPEnvelope sendDocumentsResponse = sendDocumentsMessageContext.getEnvelope();
        Assert.assertTrue(sendDocumentsResponse.toString().contains("keha href=\"cid"));

        ReceiveDocumentsDvkSoapClient receiveDocumentsDvkSoapClient = new ReceiveDocumentsDvkSoapClient(options);
        MessageContext receiveDocumentsMessageContext = receiveDocumentsDvkSoapClient.sendMessage(
                getDefaultXHeaderBuilder().setNimi("dhl.receiveDocuments.v1").build());
        SOAPEnvelope receiveDocumentsResponse = receiveDocumentsMessageContext.getEnvelope();

        logger.info("response: "+receiveDocumentsResponse.toString());
        Assert.assertTrue(receiveDocumentsResponse.toString().contains("keha href=\"cid"));

        String contentID = getContentID(receiveDocumentsResponse.getBody().getFirstElement());
        InputStream input = new FileInputStream(decodeBase64FileFrom(receiveDocumentsMessageContext.getAttachment(contentID).getInputStream()));
        String xml = FileUtils.readFileToString(gunzip(input));
        logger.debug("xml: "+xml);
        Assert.assertTrue(!xml.contains("<DecMetadata>"));
        Assert.assertTrue(!xml.contains("<DecFolder>"));
        Assert.assertTrue(!xml.contains("<DecReceiptDate>"));
        Assert.assertTrue(xml.contains("dhl_id"));
    }

    @Test
    public void when_2_1_isSentWithoutDecMetaDataBlock_mustRespondWithProperMetaDataBlock() throws Exception {
        updatePreviouslySentDocumentsStatusToReceived();

        SendDocumentsDvkSoapClient sendDocumentsDvkSoapClient = new SendDocumentsDvkSoapClient(options);

        MessageContext sendDocumentsMessageContext = sendDocumentsDvkSoapClient.sendMessage(
                "../testcontainers/v2_1/uus_kapsel_1.xml.gz", getDefaultXHeaderBuilder().setNimi("dhl.sendDocuments.v4").build());
        SOAPEnvelope sendDocumentsResponse = sendDocumentsMessageContext.getEnvelope();
        Assert.assertTrue(sendDocumentsResponse.toString().contains("keha href=\"cid"));

        ReceiveDocumentsDvkSoapClient receiveDocumentsDvkSoapClient = new ReceiveDocumentsDvkSoapClient(options);
        MessageContext receiveDocumentsMessageContext = receiveDocumentsDvkSoapClient.sendMessage(
                getDefaultXHeaderBuilder().setNimi("dhl.receiveDocuments.v1").build());
        SOAPEnvelope receiveDocumentsResponse = receiveDocumentsMessageContext.getEnvelope();

        logger.info("response: "+receiveDocumentsResponse.toString());
        Assert.assertTrue(receiveDocumentsResponse.toString().contains("keha href=\"cid"));

        String contentID = getContentID(receiveDocumentsResponse.getBody().getFirstElement());
        InputStream input = new FileInputStream(decodeBase64FileFrom(receiveDocumentsMessageContext.getAttachment(contentID).getInputStream()));
        String xml = FileUtils.readFileToString(gunzip(input));
        logger.info("xml: "+xml);
        Assert.assertTrue(!xml.contains("<DecMetadata>"));
        Assert.assertTrue(!xml.contains("<DecFolder>"));
        Assert.assertTrue(!xml.contains("<DecReceiptDate>"));
        Assert.assertTrue(xml.contains("dhl_id"));
    }

    @Test
    public void when_2_1_isSentToOrgWith2_1ContainerSupport() throws Exception {
        updatePreviouslySentDocumentsStatusToReceived();

        SendDocumentsDvkSoapClient sendDocumentsDvkSoapClient = new SendDocumentsDvkSoapClient(options);

        MessageContext sendDocumentsMessageContext = sendDocumentsDvkSoapClient.sendMessage(
                "../testcontainers/v2_1/2_1_container_for_org_2_1_container_support.xml.gz",
                getDefaultXHeaderBuilder().setNimi("dhl.sendDocuments.v4").setAsutus("10434343")
                        .setAmetnik("EE36212240216").setIsikukood("EE36212240216").build());
        SOAPEnvelope sendDocumentsResponse = sendDocumentsMessageContext.getEnvelope();
        Assert.assertTrue(sendDocumentsResponse.toString().contains("keha href=\"cid"));

        ReceiveDocumentsDvkSoapClient receiveDocumentsDvkSoapClient = new ReceiveDocumentsDvkSoapClient(options);
        MessageContext receiveDocumentsMessageContext = receiveDocumentsDvkSoapClient.sendMessage(
                getDefaultXHeaderBuilder().setNimi("dhl.receiveDocuments.v4").setAsutus("10434343")
                        .setAmetnik("EE36212240216").setIsikukood("EE36212240216").build());
        SOAPEnvelope receiveDocumentsResponse = receiveDocumentsMessageContext.getEnvelope();

        logger.info("response: "+receiveDocumentsResponse.toString());
        Assert.assertTrue(receiveDocumentsResponse.toString().contains("dokumendid href=\"cid"));

        String contentID = getContentID(receiveDocumentsResponse.getBody().getFirstElement());
        logger.info("contentID: "+contentID);
        InputStream input = new FileInputStream(decodeBase64FileFrom(receiveDocumentsMessageContext.getAttachment(contentID).getInputStream()));
        String xml = FileUtils.readFileToString(gunzip(input));
        logger.info("xml: "+xml);
        Assert.assertNotNull(xml);
        Assert.assertTrue(xml.length() > 0);
        Assert.assertTrue(xml.contains("<DecMetadata>"));
        Assert.assertTrue(xml.contains("<DecFolder>"));
        Assert.assertTrue(xml.contains("<DecReceiptDate>"));
        Assert.assertTrue(!xml.contains("dhl_id"));
    }

    private File decodeBase64FileFrom(InputStream inputStream) throws Exception {
        byte[] bytes = new byte[65536];
        File file = new File("target", UUID.randomUUID().toString());

        logger.info("decodedbase64File: " + file.getAbsolutePath());
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
            logger.error("file not found: ", e);
        } catch (IOException e) {
            logger.error("Exception", e);
        } finally {
            try {
                outputStream.close();
                inputStream.close();
            } catch (IOException e) {
                logger.error("Closing streams failed: ", e);
            }
        }

        return file;
    }

    private File gunzip(InputStream inputStream) throws Exception {
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

            logger.info("The file was decompressed successfully!");

        } catch (IOException ex) {
            ex.printStackTrace();
        }

        return output;
    }

    @SuppressWarnings(value = "all")
    private void updatePreviouslySentDocumentsStatusToReceived() throws Exception {
        Connection connection = null;
        try {
            connection = getDatabaseConnection();

            PreparedStatement preparedStatement = connection.prepareStatement(
                    "UPDATE vastuvotja SET staatus_id = ? WHERE staatus_id != ? ");
            preparedStatement.setInt(1, CommonStructures.SendStatus_Sent);
            preparedStatement.setInt(2, CommonStructures.SendStatus_Sent);
            preparedStatement.executeUpdate();
            preparedStatement.close();
            connection.commit();
        } catch (SQLException ex) {
            connection.rollback();
            throw ex;
        } finally {
            try {
                connection.close();
            } catch (Exception e) {
                 //unable to close connection
                logger.error("Unable to close connection", e);
            }
        }
    }

    private Connection getDatabaseConnection() throws Exception {
        OracleDataSource oracleDataSource = new OracleDataSource();
        oracleDataSource.setDriverType("thin");
        oracleDataSource.setURL("jdbc:oracle:thin:/@10.32.1.158:1521:XE");
        oracleDataSource.setUser("DVK");
        oracleDataSource.setPassword("dvkd");
        return oracleDataSource.getConnection();
    }
}
