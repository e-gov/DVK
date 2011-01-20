package dhl.iostructures;

import dvk.core.CommonMethods;
import javax.xml.soap.SOAPBody;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class getOccupationListRequestType {
    public String[] asutused;

    public getOccupationListRequestType() {
        asutused = new String[] {};
    }

    public static getOccupationListRequestType getFromSOAPBody(org.apache.axis.MessageContext context) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList msgNodes = body.getElementsByTagName("getOccupationList");
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element)msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element)bodyNodes.item(0);
                    NodeList orgNodes = bodyNode.getElementsByTagName("asutus");
                    if (orgNodes.getLength() > 0) {
                        getOccupationListRequestType result = new getOccupationListRequestType();
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
            CommonMethods.logError(ex, "dhl.iostructures.getOccupationListRequestType", "getFromSOAPBody");
            return null;
        }
    }
}
