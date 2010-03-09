package dhl.iostructures;

import dvk.core.CommonMethods;
import javax.xml.soap.SOAPBody;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class getSubdivisionListRequestType {
    public String[] asutused;

    public getSubdivisionListRequestType() {
        asutused = new String[] {};
    }

    public static getSubdivisionListRequestType getFromSOAPBody(org.apache.axis.MessageContext context) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList msgNodes = body.getElementsByTagName("getSubdivisionList");
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element)msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element)bodyNodes.item(0);
                    NodeList orgNodes = bodyNode.getElementsByTagName("asutus");
                    if (orgNodes.getLength() > 0) {
                        getSubdivisionListRequestType result = new getSubdivisionListRequestType();
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
            CommonMethods.logError(ex, "dhl.iostructures.getSubdivisionListRequestType", "getFromSOAPBody");
            return null;
        }
    }
}
