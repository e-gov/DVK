package integration;

import dhl.iostructures.XHeader;
import junit.framework.Assert;

import org.apache.axiom.attachments.ConfigurableDataHandler;
import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMAttribute;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.soap.*;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axis2.Constants;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.OperationClient;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.transport.http.HTTPConstants;
import org.apache.axis2.wsdl.WSDLConstants;
import org.apache.commons.httpclient.Header;
import org.apache.log4j.Logger;
import org.junit.BeforeClass;
import org.junit.Ignore;
import org.junit.Test;

import javax.activation.FileDataSource;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


/**
 * Integration tests for send documents webservice calls.
 *
 * @author Hendrik Pärna
 * @since 2.12.13
 */
public class SendDocumentsIntegration {
    private static Options options;
    private static XHeaderBuilder xHeaderBuilder;

    @BeforeClass
    public static void setUp() throws Exception {
        xHeaderBuilder = new XHeaderBuilder();
        xHeaderBuilder.setAsutus("87654321").setAndmekogu("dhl")
                .setAmetnik("EE12345678901").setId("6cae248568b3db7e97ff784673a4d38c5906bee0")
                .setNimi("dhl.sendDocuments.v1").setToimik("").setIsikukood("");

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

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_V1_serviceShouldRespondWithCID() throws Exception {
        List<String> attachmentPaths = Arrays.asList(
                "../testcontainers/v1_0/container_1_0_icefire_test1_ddoc_evorm.xml.gz",
                "../testcontainers/v1_0/test.xml.gz",
                "../testcontainers/v1_0/ddoc_xforms_obfuscated_onlyXml.xml.gz"
        );
        sendMessageWithAttachment(attachmentPaths, xHeaderBuilder.build());
    }

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_V2_serviceShouldRespondWithCID() throws Exception {
        sendMessageWithAttachment(
                "../testcontainers/v1_0/dvk_konteiner_v1.xml.gz", xHeaderBuilder.setNimi("dhl.sendDocuments.v2").build());
    }

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_V3_serviceShouldRespondWithCID() throws Exception {
        sendMessageWithAttachment(
                "../testcontainers/v1_0/dvk_konteiner_v1.xml.gz", xHeaderBuilder.setNimi("dhl.sendDocuments.v3").build());
    }

    @Test
    public void whenContainer_V2_1_isSentTo_sendDocuments_V4_serviceShouldRespondWithCID() throws Exception {
        List<String> attachmentPaths = Arrays.asList(
                "../testcontainers/v2_1/container_2_1_icefire_ddoc.xml.gz",
                "../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide2.xml.gz",
                "../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide3.xml.gz",
                "../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide1_DecMetaDataMissing.xml.gz",
                "../testcontainers/v2_1/viga1.xml.gz",
                "../testcontainers/v2_1/viga2.xml.gz"
                //"../testcontainers/v2_1/icefire_ddoc_obfuscated_both.xml.gz",
                //"../testcontainers/v2_1/books.ddoc.xml.gz"
        );

        sendMessageWithAttachment(attachmentPaths, xHeaderBuilder.setNimi("dhl.sendDocuments.v4").build());
    }

    @Test
    public void whenContainer_V2_1_isSentTo_sendDocument_V4_then_service_shouldMatchRecipient() throws Exception {
        List<String> attachmentNames = Arrays.asList("../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide1Transport.xml.gz");
        sendMessageWithAttachment(attachmentNames, xHeaderBuilder.setNimi("dhl.sendDocuments.v4").build());
    }

    private void sendMessageWithAttachment(List<String> attachmentNames, XHeader xHeader) throws Exception {
        for(String attachmentName: attachmentNames) {
            sendMessageWithAttachment(attachmentName, xHeader);
        }
    }

    private void sendMessageWithAttachment(String attachmentName, XHeader xHeader) throws Exception {
        SendDocumentsDvkSoapClient sendDocumentsDvkSoapClient = new SendDocumentsDvkSoapClient(options);
        MessageContext sendDocumentsMessageContext = sendDocumentsDvkSoapClient.sendMessage(attachmentName, xHeader);
        Assert.assertTrue(sendDocumentsMessageContext.getEnvelope().toString().contains("keha href=\"cid"));
    }
}

