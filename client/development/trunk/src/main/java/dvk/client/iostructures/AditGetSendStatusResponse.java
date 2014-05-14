package dvk.client.iostructures;

import dvk.core.CommonMethods;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * @author Hendrik Pärna
 * @since 1.04.14
 */
public class AditGetSendStatusResponse {
    public List<AditDocument> aditDocuments = new ArrayList<AditDocument>();

    /**
     * Create AditGetSendStatusResponse from xml.
     * @param root element
     * @return parsed AditGetSendStatusResponse
     */
    public static AditGetSendStatusResponse fromXML(Element root) {
        AditGetSendStatusResponse result = new AditGetSendStatusResponse();

        NodeList nodeList = root.getChildNodes();

        for (int i = 0; i < nodeList.getLength(); ++i) {
            Node n = nodeList.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE) {
                if (n.getLocalName().equalsIgnoreCase("dokument")) {
                    AditDocument document = AditDocument.fromXML((Element) nodeList.item(i));
                    if (document != null) {
                        result.aditDocuments.add(document);
                    }
                }
            }
        }

        return result;
    }


}
