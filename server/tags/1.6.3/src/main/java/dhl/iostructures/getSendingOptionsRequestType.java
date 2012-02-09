package dhl.iostructures;

import dvk.core.CommonMethods;

import javax.xml.soap.SOAPBody;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class getSendingOptionsRequestType {
    public String[] asutused;

    public getSendingOptionsRequestType() {
        asutused = new String[] { };
    }

    public static getSendingOptionsRequestType getFromSOAPBody(org.apache.axis.MessageContext context) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList msgNodes = body.getElementsByTagName("getSendingOptions");
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element)msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element)bodyNodes.item(0);
                    NodeList orgNodes = bodyNode.getElementsByTagName("asutus");
                    if (orgNodes.getLength() > 0) {
                        getSendingOptionsRequestType result = new getSendingOptionsRequestType();
                        result.asutused = new String[orgNodes.getLength()];
                        for (int i = 0; i < orgNodes.getLength(); ++i) {
                            result.asutused[i] = CommonMethods.getNodeText(orgNodes.item(i));
                        }
                        return result;
                    }
                }
            }
            return null;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.getSendingOptionsRequestType", "getFromSOAPBody");
            return null;
        }
    }
}
