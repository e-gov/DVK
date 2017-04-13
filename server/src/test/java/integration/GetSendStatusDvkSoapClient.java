package integration;

import java.util.HashMap;
import java.util.Map;

import javax.activation.FileDataSource;

import org.apache.axiom.attachments.ConfigurableDataHandler;
import org.apache.axiom.om.OMAttribute;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axis2.client.Options;
import org.apache.axis2.context.MessageContext;
import org.apache.log4j.Logger;

import dvk.core.xroad.XRoadHeader;
import dvk.core.xroad.XRoadMessageProtocolVersion;

public class GetSendStatusDvkSoapClient extends AbstractDvkServiceSoapClient {
    private static Logger logger = Logger.getLogger(GetSendStatusDvkSoapClient.class);

    public GetSendStatusDvkSoapClient(Options options, XRoadMessageProtocolVersion xRoadProtocol) {
        super(options, xRoadProtocol);
    }

    public MessageContext sendRequest(String attachmentName, XRoadHeader xHeader) throws Exception {
        super.attachmentName = attachmentName;
        super.xHeader = xHeader;
        return sendMessage(xHeader);
    }

    @Override
    protected OMElement createMessageBody() {
        //message body
        System.out.println("Create a message body for GetSendStatus request");
        OMElement elGetSendStatus = fac.createOMElement("getSendStatus", namespaces.get("dhlNs"));
        OMElement elKeha = fac.createOMElement("keha", null);
        OMAttribute attID = fac.createOMAttribute("href", null, "cid:" + attachmentName);
        elKeha.addAttribute(attID);
        elGetSendStatus.addChild(elKeha);
        return elGetSendStatus;
    }

    @Override
    protected void addAttachmentTo(MessageContext messageContext) {
        //attachment
        logger.info("addAttachmentTo: "+attachmentName);
        FileDataSource fileDataSource = new FileDataSource(attachmentName);
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


