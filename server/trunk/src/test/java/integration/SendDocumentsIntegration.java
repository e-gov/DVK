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
    private static Logger LOG = Logger.getLogger(SendDocumentsIntegration.class);

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
        sendMessageWithAttachment(
                "testcontainers/v1_0/dvk_konteiner_v1.xml.gz", xHeaderBuilder.build());
    }

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_V2_serviceShouldRespondWithCID() throws Exception {
        sendMessageWithAttachment(
                "testcontainers/v1_0/dvk_konteiner_v1.xml.gz", xHeaderBuilder.setNimi("dhl.sendDocuments.v2").build());
    }

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_V3_serviceShouldRespondWithCID() throws Exception {
        sendMessageWithAttachment(
                "testcontainers/v1_0/dvk_konteiner_v1.xml.gz", xHeaderBuilder.setNimi("dhl.sendDocuments.v3").build());
    }

    @Test
    public void whenContainer_V1_isSentTo_sendDocuments_V4_serviceShouldRespondWithCID() throws Exception {
        sendMessageWithAttachment(
                "testcontainers/v1_0/dvk_konteiner_v1.xml.gz", xHeaderBuilder.setNimi("dhl.sendDocuments.v4").build());
    }

    @Test
    public void whenContainer_V2_1_isSentTo_sendDocuments_V4_serviceShouldRespondWithCID() throws Exception {
        List<String> attachmentNames = Arrays.asList(
                "testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide1.xml.gz",
                "testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide2.xml.gz",
                "testcontainers/v2_1/Dvk_kapsel_vers_2_1_n2ide3.xml.gz"
        );

        sendMessageWithAttachment(attachmentNames, xHeaderBuilder.setNimi("dhl.sendDocuments.v4").build());
    }

    private void sendMessageWithAttachment(List<String> attachmentNames, XHeader xHeader) throws Exception {
        for(String attachmentName: attachmentNames) {
            sendMessageWithAttachment(attachmentName, xHeader);
        }
    }

    private void sendMessageWithAttachment(String attachmentName, XHeader xHeader) throws Exception {
        ServiceClient sender = new ServiceClient(null,null);
        sender.setOptions(options);
        OperationClient serviceClient = sender.createClient(ServiceClient.ANON_OUT_IN_OP);

        MessageContext mc = createMessageContext(attachmentName, xHeader);
        serviceClient.addMessageContext(mc);
        serviceClient.execute(true);
        MessageContext response = serviceClient.getMessageContext(WSDLConstants.MESSAGE_LABEL_IN_VALUE);
        SOAPEnvelope resp = response.getEnvelope();
        Assert.assertTrue(resp.toString().contains("keha href=\"cid"));
    }

    private MessageContext createMessageContext(String attachmentName, dhl.iostructures.XHeader header) throws Exception {
        MessageContext messageContext = new MessageContext();

        SOAPFactory fac = OMAbstractFactory.getSOAP11Factory();

        //attachment
        String attachmentFilePath = SendDocumentsIntegration.class.getResource("../"+attachmentName).getPath();
        FileDataSource fileDataSource = new FileDataSource(attachmentFilePath);
        ConfigurableDataHandler dataHandler = new ConfigurableDataHandler(fileDataSource);
        dataHandler.setTransferEncoding("base64");
        dataHandler.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
        messageContext.addAttachment(attachmentName, dataHandler);

        //namespaces
        org.apache.axiom.soap.SOAPEnvelope env = fac.getDefaultEnvelope();
        OMNamespace xsiNs = fac.createOMNamespace("http://www.w3.org/2001/XMLSchema-instance", "xsi");
        OMNamespace xteeNs = fac.createOMNamespace("http://x-tee.riik.ee/xsd/xtee.xsd", "xtee");
        OMNamespace xsdNs = fac.createOMNamespace("http://www.w3.org/2001/XMLSchema", "xsd");
        OMNamespace dhlNs = fac.createOMNamespace("http://0.0.0.0:9099/services/dhlHttpSoapPort", "xsd");
        env.declareNamespace(xsiNs);
        env.declareNamespace(xteeNs);
        env.declareNamespace(xsdNs);
        env.declareNamespace(dhlNs);

        //message body
        OMElement elSendDocuments = fac.createOMElement("sendDocuments", dhlNs);
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement eldokumendid = fac.createOMElement("dokumendid", null);
        OMAttribute attID = fac.createOMAttribute("href", null, "cid:" + attachmentName);
        eldokumendid.addAttribute(attID);
        elKeha.addChild(eldokumendid);
        elKeha.addChild(fac.createOMElement("kaust", null));
        elSendDocuments.addChild(elKeha);
        env.getBody().addChild(elSendDocuments);

        //message header
        env = header.appendToSOAPHeader(env, fac);
        messageContext.setEnvelope(env);

        return messageContext;
    }

}

/**
 * {@link XHeader} builder class for simpler testing purposes.
 */
class XHeaderBuilder {
    private String asutus;
    private String andmekogu;
    private String ametnik;
    private String id;
    private String nimi;
    private String toimik;
    private String isikukood;

    public XHeaderBuilder setAsutus(String asutus) {
        this.asutus = asutus;
        return this;
    }

    public XHeaderBuilder setAndmekogu(String andmekogu) {
        this.andmekogu = andmekogu;
        return this;
    }

    public XHeaderBuilder setAmetnik(String ametnik) {
        this.ametnik = ametnik;
        return this;
    }

    public XHeaderBuilder setId(String id) {
        this.id = id;
        return this;
    }

    public XHeaderBuilder setNimi(String nimi) {
        this.nimi = nimi;
        return this;
    }

    public XHeaderBuilder setToimik(String toimik) {
        this.toimik = toimik;
        return this;
    }

    public void setIsikukood(String isikukood) {
        this.isikukood = isikukood;
    }

    public XHeader build() {
        return new XHeader(
                asutus, andmekogu, ametnik, id, nimi, toimik, isikukood);
    }
}
