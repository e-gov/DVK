package dvk.client.iostructures;

import dvk.core.CommonMethods;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.ArrayList;
import java.util.List;

/**
* @author Hendrik Pärna
* @since 1.04.14
*/
public class AditDocument {
    public Integer dhlId;
    public List<AditReciever> aditRecievers = new ArrayList<AditReciever>();

    public static AditDocument fromXML(Element root) {
        AditDocument result = new AditDocument();

        NodeList nList = root.getChildNodes();

        for (int i = 0; i < nList.getLength(); ++i) {
            Node n = nList.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE) {
                if (n.getLocalName().equalsIgnoreCase("dhl_id")) {
                    result.dhlId = Integer.parseInt(CommonMethods.getNodeText(n).trim());
                } else if (n.getLocalName().equalsIgnoreCase("saaja")) {
                    result.aditRecievers.add(AditReciever.fromXML((Element) n));
                }
            }
        }

        return result;
    }
}
