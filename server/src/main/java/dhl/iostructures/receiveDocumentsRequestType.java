package dhl.iostructures;

import java.util.ArrayList;
import java.util.List;

import javax.xml.soap.SOAPBody;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;

public class receiveDocumentsRequestType {
	
	public static final String DEFAULT_REQUEST_ELEMENT_NAME = "receiveDocuments";
	
    public int arv;
    public List<String> kaust;

    public receiveDocumentsRequestType() {
        arv = 10;
        kaust = new ArrayList<String>();
    }

    public static receiveDocumentsRequestType getFromSOAPBody(org.apache.axis.MessageContext context) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList nodes = body.getElementsByTagName(DEFAULT_REQUEST_ELEMENT_NAME);
            if (nodes.getLength() > 0) {
                Element el = (Element) nodes.item(0);
                nodes = el.getElementsByTagName("keha");
                if (nodes.getLength() > 0) {
                    receiveDocumentsRequestType result = new receiveDocumentsRequestType();
                    Element bodyNode = (Element) nodes.item(0);

                    // Arv
                    nodes = bodyNode.getElementsByTagName("arv");
                    if (nodes.getLength() > 0) {
                        Node countNode = nodes.item(0);
                        String countString = CommonMethods.getNodeText(countNode);
                        result.arv = CommonMethods.toIntSafe(countString, 10);
                        if (result.arv < 1) {
                            result.arv = 1;
                        }
                    }

                    // Kaust
                    nodes = bodyNode.getElementsByTagName("kaust");
                    if (nodes.getLength() > 0) {
                        for (int i = 0; i < nodes.getLength(); ++i) {
                            Element folderNode = (Element) nodes.item(i);
                            result.kaust.add(CommonMethods.getNodeText(folderNode));
                        }
                    }
                    return result;
                }
            }
            return null;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.receiveDocumentsRequestType", "getFromSOAPBody");
            return null;
        }
    }
}
