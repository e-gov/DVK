package integration;

import dhl.iostructures.XHeader;
import dvk.core.xroad.XRoadProtocolVersion;
import junit.framework.Assert;
import junitparams.JUnitParamsRunner;
import junitparams.Parameters;
import org.apache.axiom.soap.SOAP11Constants;
import org.apache.axis2.Constants;
import org.apache.axis2.addressing.EndpointReference;
import org.apache.axis2.client.Options;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.transport.http.HTTPConstants;
import org.apache.commons.httpclient.Header;
import org.junit.BeforeClass;
import org.junit.Test;
import org.junit.runner.RunWith;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;


/**
 * Integration tests for send documents webservice calls.
 *
 * @author Hendrik Pärna
 * @since 2.12.13
 */
@RunWith(JUnitParamsRunner.class)
public class SendDocumentsIntegration {
	
    private static Options options;
    private static XHeaderBuilder xHeaderBuilder;
    private static XRoadProtocolVersion xRoadProtocolVersion;

    @BeforeClass
    public static void setUp() throws Exception {
        xHeaderBuilder = new XHeaderBuilder();        
        xHeaderBuilder.setAsutus("87654321").setAndmekogu("dhl")
        //xHeaderBuilder.setAsutus("70006317").setAndmekogu("dhl")
                .setAmetnik("EE12345678901").setId("6cae248568b3db7e97ff784673a4d38c5906bee0")
                .setNimi("dhl.sendDocuments.v1").setToimik("").setIsikukood("");

        //String serviceUrl = "http://0.0.0.0:9099/services/dhlHttpSoapPort";
        String serviceUrl = "http://0.0.0.0:8070/dvk/services/dhlHttpSoapPort";
        
        EndpointReference endpointReference = new EndpointReference(serviceUrl);
        
        ArrayList<Header> customHeaders = new ArrayList<Header>();
        customHeaders.add(new Header("Connection", "close"));
        customHeaders.add(new Header("Cache-control", "no-cache"));
        customHeaders.add(new Header("Pragma", "no-cache"));
        
        options = new Options();
        options.setTo(endpointReference);
        options.setProperty(Constants.Configuration.ENABLE_SWA, Constants.VALUE_TRUE);
        options.setTransportInProtocol(Constants.TRANSPORT_HTTP);
        options.setSoapVersionURI(SOAP11Constants.SOAP_ENVELOPE_NAMESPACE_URI);
        options.setProperty(HTTPConstants.HTTP_PROTOCOL_VERSION, HTTPConstants.HEADER_PROTOCOL_11);
        options.setProperty(HTTPConstants.CHUNKED, Boolean.FALSE);
        options.setProperty(HTTPConstants.HTTP_HEADERS, customHeaders);
        
        xRoadProtocolVersion = XRoadProtocolVersion.V2_0;
    }

    @Test
    @Parameters({
            "../testcontainers/v1_0/DVK_73_jdigidoc_cache_problem.xml.gz",
            "../testcontainers/v1_0/test.xml.gz",
            "../testcontainers/v1_0/ddoc_xforms_obfuscated_onlyXml.xml.gz",
            "../testcontainers/v1_0/container_1_0_jddoc_bug.xml.gz"
    })
    public void whenContainer_V1_isSentTo_sendDocuments_V1_serviceShouldRespondWithCID(String attachmentPath) throws Exception {
        sendMessageWithAttachment(attachmentPath, xHeaderBuilder.build());
    }

    @Test
    @Parameters({
            "../testcontainers/v1_0/dvk_konteiner_v1.xml.gz"
    })
    public void whenContainer_V1_isSentTo_sendDocuments_V2_serviceShouldRespondWithCID(String attachmentPath) throws Exception {
        sendMessageWithAttachment(
                attachmentPath, xHeaderBuilder.setNimi("dhl.sendDocuments.v2").build());
    }

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_V3_serviceShouldRespondWithCID() throws Exception {
        sendMessageWithAttachment(
                "../testcontainers/v1_0/dvk_konteiner_v1.xml.gz", xHeaderBuilder.setNimi("dhl.sendDocuments.v3").build());
    }

    @Test
    @Parameters({
            "../testcontainers/v2_1/container_2_1_icefire_ddoc.xml.gz",
            "../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide2.xml.gz",
            "../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide3.xml.gz",
            "../testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide1_DecMetaDataMissing.xml.gz",
            "../testcontainers/v2_1/viga1.xml.gz",
            "../testcontainers/v2_1/viga2.xml.gz",
            "../testcontainers/v2_1/DVK_73_jdigidoc_cache_problem.xml.gz"
    })
    public void whenContainer_V2_1_isSentTo_sendDocuments_V4_serviceShouldRespondWithCID(String attachmentPath) throws Exception {
        sendMessageWithAttachment(attachmentPath, xHeaderBuilder.setNimi("dhl.sendDocuments.v4").build());
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
        SendDocumentsDvkSoapClient sendDocumentsDvkSoapClient = new SendDocumentsDvkSoapClient(options, xRoadProtocolVersion);
        MessageContext sendDocumentsMessageContext = sendDocumentsDvkSoapClient.sendMessage(attachmentName, xHeader);
        Assert.assertTrue(sendDocumentsMessageContext.getEnvelope().toString().contains("keha href=\"cid"));
    }
}

