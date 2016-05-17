package integration;

import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

import org.apache.axiom.attachments.ConfigurableDataHandler;
import org.apache.axiom.om.OMAttribute;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axis2.client.Options;
import org.apache.axis2.context.MessageContext;
import org.apache.log4j.Logger;

import javax.activation.FileDataSource;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author Hendrik Pärna
 * @since 18.12.13
 */
public class SendDocumentsDvkSoapClient extends AbstractDvkServiceSoapClient {
    private static Logger logger = Logger.getLogger(SendDocumentsDvkSoapClient.class);

    public SendDocumentsDvkSoapClient(Options options, XRoadProtocolVersion xRoadProtocol) {
        super(options, xRoadProtocol);
    }

    public MessageContext sendMessage(String attachmentName, XRoadProtocolHeader xHeader) throws Exception {
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

        /*       
		// Send document in fragments
        // start
        OMElement elEdastusId = fac.createOMElement("edastus_id", null);
        //b.edastusID = headerVar.getOrganizationCode() + String.valueOf(message.getId());
        elEdastusId.setText("87654321776");
        elKeha.addChild(elEdastusId);

        OMElement elFragmendiNr = fac.createOMElement("fragment_nr", null);
        elFragmendiNr.setText("0");
        elKeha.addChild(elFragmendiNr);

        OMElement elFragmendiKokku = fac.createOMElement("fragmente_kokku", null);
        elFragmendiKokku.setText("1");
        elKeha.addChild(elFragmendiKokku);
        // end*/

        elSendDocuments.addChild(elKeha);
        return elSendDocuments;
    }

    @Override
    protected void addAttachmentTo(MessageContext messageContext) {
        //attachment
        logger.info("addAttachmentTo: "+attachmentName);
        String attachmentFilePath = AbstractDvkServiceSoapClient.class.getResource(attachmentName).getPath();
        logger.info("attachmentFilePath: "+attachmentFilePath);
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
