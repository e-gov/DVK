package integration;

import Utills.IntegrationTestUtills;
import dhl.iostructures.XHeader;
import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolVersion;
import junit.framework.Assert;
import org.apache.axiom.soap.SOAP11Constants;
import org.apache.axis2.Constants;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.transport.http.HTTPConstants;
import org.apache.commons.httpclient.Header;
import org.apache.commons.io.FileUtils;
import org.junit.BeforeClass;
import org.junit.Test;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import java.io.*;
import java.util.ArrayList;
import java.util.UUID;

public class GetSendStatusIntegration {
	
	private static final String UTF8_ENCODING = "UTF-8";
	private static final String encodedAmpersandSymbol = "&amp";
	
    private static Options options;
    private static XHeaderBuilder xHeaderBuilder;
    private static XRoadProtocolVersion xRoadProtocolVersion;

    @BeforeClass
    public static void setUp() throws Exception {
        xHeaderBuilder = new XHeaderBuilder();
        xRoadProtocolVersion = XRoadProtocolVersion.V2_0;
        xHeaderBuilder.setAsutus("87654321").setAndmekogu("dhl")
        //xHeaderBuilder.setAsutus("70006317").setAndmekogu("dhl")
                .setAmetnik("EE37001010001").setId("6cae248568b3db7e97ff784673a4d38c5906bee0")
                .setNimi("dhl.getSendStatus.v1").setToimik("").setIsikukood("EE37001010001");
  
        //String serviceUrl = "http://0.0.0.0:9099/services/dhlHttpSoapPort";
        String serviceUrl = "http://0.0.0.0:8070/dvk/services/dhlHttpSoapPort";
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

    @Test
    public void getSendStatusTest() throws Exception {
        long dhl_id = sendDocument("../testcontainers/v1_0/dvk_konteiner_v1_with_encoded_ampersand.xml.gz");
        String getSendStatusAttachmentFilePath = composeGetSendStatusAttachment(dhl_id);
        doesResponseContainEncodedAmpersandSymbolAssert(doGetSendStatusRequest(
                getSendStatusAttachmentFilePath, xHeaderBuilder.build()));
    }

    private long sendDocument(String path) throws Exception {
        Options optionsForSending;
        XHeaderBuilder xHeaderBuilderForSending;

        xHeaderBuilderForSending = new XHeaderBuilder();
        xHeaderBuilderForSending.setAsutus("87654321").setAndmekogu("dhl")
        //xHeaderBuilderForSending.setAsutus("70006317").setAndmekogu("dhl")
                .setAmetnik("EE12345678901").setId("6cae248568b3db7e97ff784673a4d38c5906bee0")
                .setNimi("dhl.sendDocuments.v3").setToimik("").setIsikukood("");
        
        //String serviceUrl = "http://0.0.0.0:9099/services/dhlHttpSoapPort";
        String serviceUrl = "http://0.0.0.0:8070/dvk/services/dhlHttpSoapPort";
        EndpointReference endpointReference = new EndpointReference(serviceUrl);
        optionsForSending = new Options();
        optionsForSending.setTo(endpointReference);
        optionsForSending.setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        optionsForSending.setTransportInProtocol(Constants.TRANSPORT_HTTP);
        optionsForSending.setSoapVersionURI(SOAP11Constants.SOAP_ENVELOPE_NAMESPACE_URI);
        optionsForSending.setProperty(HTTPConstants.HTTP_PROTOCOL_VERSION, HTTPConstants.HEADER_PROTOCOL_11);
        optionsForSending.setProperty(HTTPConstants.CHUNKED, Boolean.FALSE);
        ArrayList<Header> customHeaders = new ArrayList<Header>();
        customHeaders.add(new Header("Connection", "close"));
        customHeaders.add(new Header("Cache-control", "no-cache"));
        customHeaders.add(new Header("Pragma", "no-cache"));
        optionsForSending.setProperty(HTTPConstants.HTTP_HEADERS, customHeaders);

        return getDhlIdOfMessage(sendMessageWithAttachment(path, xHeaderBuilderForSending.build(), optionsForSending));
    }

    private MessageContext sendMessageWithAttachment(String attachmentName, XHeader xHeader,  Options options) throws Exception {
        SendDocumentsDvkSoapClient sendDocumentsDvkSoapClient = new SendDocumentsDvkSoapClient(options, xRoadProtocolVersion);
        return sendDocumentsDvkSoapClient.sendMessage(attachmentName, xHeader);
    }

    private MessageContext doGetSendStatusRequest(String attachmentName, XHeader xHeader) throws Exception {
        GetSendStatusDvkSoapClient getSendStatusDvkSoapClient = new GetSendStatusDvkSoapClient(options, xRoadProtocolVersion);
        return getSendStatusDvkSoapClient.sendRequest(attachmentName, xHeader);
    }

    private long getDhlIdOfMessage(MessageContext sendDocumentResponse) throws Exception {
        String contentID = IntegrationTestUtills.getContentID(sendDocumentResponse.getEnvelope().getBody().getFirstElement());
        InputStream input = new FileInputStream(IntegrationTestUtills.decodeBase64FileFrom(sendDocumentResponse.
                getAttachment(contentID).getInputStream()));

        DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
        Document document = builder.parse(new InputSource(new StringReader(
                FileUtils.readFileToString(IntegrationTestUtills.gunzip(input)))));
        NodeList nodeList = document.getElementsByTagName("dhl_id");
        return Long.parseLong(nodeList.item(0).getTextContent());
    }

    private String composeGetSendStatusAttachment(long dhl_id) throws Exception {
        String content = "<item>" +
        "<dhl_id>" + dhl_id + "</dhl_id>" +
        "<dokument_guid></dokument_guid>" +
        "</item>";

        File file = CommonMethods.createTempFile("getSendStatusAttachment" + UUID.randomUUID().toString() + ".xml");
        FileUtils.writeStringToFile(file, content, UTF8_ENCODING);

        return CommonMethods.gzipFile(file.getAbsolutePath());
    }

    private void doesResponseContainEncodedAmpersandSymbolAssert(MessageContext getSendStatusResponse) throws Exception {
        String contentID = IntegrationTestUtills.getContentID(getSendStatusResponse.getEnvelope().getBody().getFirstElement());
        InputStream input = new FileInputStream(IntegrationTestUtills.decodeBase64FileFrom(getSendStatusResponse.
                getAttachment(contentID).getInputStream()));
        String response = FileUtils.readFileToString(IntegrationTestUtills.gunzip(input));
        input.close();
        Assert.assertTrue(response.contains(encodedAmpersandSymbol));
    }
}

