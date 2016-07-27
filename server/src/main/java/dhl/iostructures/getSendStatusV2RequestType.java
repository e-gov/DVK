package dhl.iostructures;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPException;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;

public class getSendStatusV2RequestType {
    public String dokumendidHref;
    public boolean staatuseAjalugu;

    public getSendStatusV2RequestType() {
        dokumendidHref = "";
        staatuseAjalugu = false;
    }

    public static getSendStatusV2RequestType getFromSOAPBody(org.apache.axis.MessageContext context) throws SOAPException {
        org.apache.axis.Message msg = context.getRequestMessage();
        SOAPBody body = msg.getSOAPBody();
        NodeList msgNodes = body.getElementsByTagName("getSendStatus");
        if (msgNodes.getLength() > 0) {
            Element msgNode = (Element) msgNodes.item(0);
            NodeList bodyNodes = msgNode.getElementsByTagName("keha");
            if (bodyNodes.getLength() > 0) {
                getSendStatusV2RequestType result = new getSendStatusV2RequestType();
                Element bodyNode = (Element) bodyNodes.item(0);

                NodeList nl = bodyNode.getElementsByTagName("dokumendid");
                if (nl.getLength() > 0) {
                    Element docNode = (Element) nl.item(0);
                    result.dokumendidHref = docNode.getAttribute("href");
                    if (result.dokumendidHref.startsWith("cid:")) {
                        result.dokumendidHref = result.dokumendidHref.replaceFirst("cid:", "");
                    }
                }
                nl = bodyNode.getElementsByTagName("staatuse_ajalugu");
                if (nl.getLength() > 0) {
                    result.staatuseAjalugu = CommonMethods.booleanFromXML(CommonMethods.getNodeText(nl.item(0)));
                }
                return result;
            }
        }
        return null;
    }
}
