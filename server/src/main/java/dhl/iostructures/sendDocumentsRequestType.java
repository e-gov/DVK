package dhl.iostructures;

import javax.xml.soap.SOAPBody;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;

public class sendDocumentsRequestType {
    public String dokumendid;
    public String kaust;

    public sendDocumentsRequestType() {
        dokumendid = "";
        kaust = "";
    }

    public static sendDocumentsRequestType getFromSOAPBody(org.apache.axis.MessageContext context) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            
            NodeList msgNodes = body.getElementsByTagName("sendDocuments");
            
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element) msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element) bodyNodes.item(0);
                    NodeList docRefNodes = bodyNode.getElementsByTagName("dokumendid");
                    if (docRefNodes.getLength() > 0) {
                        Element docRefNode = (Element) docRefNodes.item(0);
                        sendDocumentsRequestType result = new sendDocumentsRequestType();
                        result.dokumendid = docRefNode.getAttribute("href");
                        if (result.dokumendid.startsWith("cid:")) {
                            result.dokumendid = result.dokumendid.replaceFirst("cid:", "");
                        }
                        NodeList folderNodes = bodyNode.getElementsByTagName("kaust");
                        if (folderNodes.getLength() > 0) {
                            Element folderNode = (Element) folderNodes.item(0);
                            result.kaust = CommonMethods.getNodeText(folderNode);
                        }
                        return result;
                    }
                }
            }
            return null;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.sendDocumentsRequestType", "getFromSOAPBody");
            return null;
        }
    }
}
