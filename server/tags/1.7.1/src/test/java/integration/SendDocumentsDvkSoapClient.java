package integration;

import dhl.iostructures.XHeader;
import org.apache.axiom.attachments.ConfigurableDataHandler;
import org.apache.axiom.om.OMAttribute;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axis2.client.Options;
import org.apache.axis2.context.MessageContext;

import javax.activation.FileDataSource;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Hendrik Pärna
 * @since 18.12.13
 */
public class SendDocumentsDvkSoapClient extends AbstractDvkServiceSoapClient {

    public SendDocumentsDvkSoapClient(Options options) {
        super(options);
    }

    public MessageContext sendMessage(String attachmentName, XHeader xHeader) throws Exception {
        super.attachmentName = attachmentName;
        super.xHeader = xHeader;
        return sendMessage(xHeader);
    }

    @Override
    protected OMElement createMessageBody() {
        //message body
        OMElement elSendDocuments = fac.createOMElement("sendDocuments", namespaces.get("dhlNs"));
        OMElement elKeha = fac.createOMElement("keha", null);
        OMElement eldokumendid = fac.createOMElement("dokumendid", null);
        OMAttribute attID = fac.createOMAttribute("href", null, "cid:" + attachmentName);
        eldokumendid.addAttribute(attID);
        elKeha.addChild(eldokumendid);
        elKeha.addChild(fac.createOMElement("kaust", null));
        elSendDocuments.addChild(elKeha);
        return elSendDocuments;
    }

    @Override
    protected void addAttachmentTo(MessageContext messageContext) {
        //attachment
        String attachmentFilePath = AbstractDvkServiceSoapClient.class.getResource(attachmentName).getPath();
        FileDataSource fileDataSource = new FileDataSource(attachmentFilePath);
        ConfigurableDataHandler dataHandler = new ConfigurableDataHandler(fileDataSource);
        dataHandler.setTransferEncoding("base64");
        dataHandler.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
        messageContext.addAttachment(attachmentName, dataHandler);
    }

    @Override
    protected Map<String, OMNamespace> addNamespaces() {
        return new HashMap<String, OMNamespace>();
    }
}
