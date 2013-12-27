package integration;

import dhl.iostructures.XHeader;
import org.apache.axiom.attachments.ConfigurableDataHandler;
import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axis2.client.OperationClient;
import org.apache.axis2.client.Options;
import org.apache.axis2.client.ServiceClient;
import org.apache.axis2.context.MessageContext;
import org.apache.axis2.wsdl.WSDLConstants;

import javax.activation.FileDataSource;
import java.util.HashMap;
import java.util.Map;

/**
 * Abstract representation of sending soap messages to DVK server.
 * NB! Used only for testing purposes.
 *
 * @author Hendrik Pärna
 * @since 18.12.13
 */
public abstract class AbstractDvkServiceSoapClient {
    private Options options;
    protected String attachmentName;
    protected dhl.iostructures.XHeader xHeader;
    protected SOAPFactory fac = OMAbstractFactory.getSOAP11Factory();
    protected SOAPEnvelope env = fac.getDefaultEnvelope();
    protected Map<String, OMNamespace> namespaces;

    public AbstractDvkServiceSoapClient(Options options) {
         this.options = options;
    }

    protected MessageContext sendMessage(XHeader xHeader) throws Exception {
        this.xHeader = xHeader;

        ServiceClient sender = new ServiceClient(null,null);
        sender.setOptions(options);
        OperationClient serviceClient = sender.createClient(ServiceClient.ANON_OUT_IN_OP);

        MessageContext mc = createMessageContext();
        serviceClient.addMessageContext(mc);
        serviceClient.execute(true);
        MessageContext responseMessageContext = serviceClient.getMessageContext(WSDLConstants.MESSAGE_LABEL_IN_VALUE);
        return responseMessageContext;
    }

    private void setNamespaces() {
        if (namespaces == null) {
            namespaces = new HashMap<String, OMNamespace>();
        }

        //namespaces
        OMNamespace xsiNs = fac.createOMNamespace("http://www.w3.org/2001/XMLSchema-instance", "xsi");
        OMNamespace xteeNs = fac.createOMNamespace("http://x-tee.riik.ee/xsd/xtee.xsd", "xtee");
        OMNamespace xsdNs = fac.createOMNamespace("http://www.w3.org/2001/XMLSchema", "xsd");
        OMNamespace dhlNs = fac.createOMNamespace("http://0.0.0.0:9099/services/dhlHttpSoapPort", "xsd");

        namespaces.put("xsiNs", xsiNs);
        namespaces.put("xteeNs", xteeNs);
        namespaces.put("xsdNs", xsdNs);
        namespaces.put("dhlNs", dhlNs);

        namespaces.putAll(addNamespaces());
    }

    /**
     * Add custom namespaces if needed.
     * @return Map of OMNamespace's.
     */
    protected abstract Map<String, OMNamespace> addNamespaces();

    private MessageContext createMessageContext() throws Exception {
        MessageContext messageContext = new MessageContext();

        setNamespaces();
        env.declareNamespace(namespaces.get("xsiNs"));
        env.declareNamespace(namespaces.get("xteeNs"));
        env.declareNamespace(namespaces.get("xsdNs"));
        env.declareNamespace(namespaces.get("dhlNs"));

        env.getBody().addChild(createMessageBody());

        //message header
        env = xHeader.appendToSOAPHeader(env, fac);
        messageContext.setEnvelope(env);

        addAttachmentTo(messageContext);

        return messageContext;
    }

    protected void addAttachmentTo(MessageContext messageContext) {

    }

    protected abstract OMElement createMessageBody();
}
