package dhl.iostructures;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPException;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class getSendStatusRequestType {
    public String kehaHref;

    public getSendStatusRequestType() {
        kehaHref = "";
    }

    public static getSendStatusRequestType getFromSOAPBody(org.apache.axis.MessageContext context) throws SOAPException {
        org.apache.axis.Message msg = context.getRequestMessage();
        SOAPBody body = msg.getSOAPBody();
        NodeList msgNodes = body.getElementsByTagName("getSendStatus");
        if (msgNodes.getLength() > 0) {
            Element msgNode = (Element)msgNodes.item(0);
            NodeList bodyNodes = msgNode.getElementsByTagName("keha");
            if (bodyNodes.getLength() > 0) {
                getSendStatusRequestType result = new getSendStatusRequestType();
                Element bodyNode = (Element)bodyNodes.item(0);
                result.kehaHref = bodyNode.getAttribute("href");
                if (result.kehaHref.startsWith("cid:")) {
                    result.kehaHref = result.kehaHref.replaceFirst("cid:", "");
                }
                return result;
            }
        }
        return null;
    }
}
