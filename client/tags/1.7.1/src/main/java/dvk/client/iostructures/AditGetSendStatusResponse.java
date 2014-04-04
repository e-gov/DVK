package dvk.client.iostructures;

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

        NodeList nodeList = root.getElementsByTagName("item");
        if (nodeList.getLength() > 0) {
            Node item = nodeList.item(0);
            nodeList = ((Element) item).getElementsByTagName("dokument");
            for (int i = 0; i < nodeList.getLength(); ++i) {
                AditDocument document = AditDocument.fromXML((Element) nodeList.item(i));
                if (document != null) {
                   result.aditDocuments.add(document);
                }
            }
        }

        return result;
    }


}
