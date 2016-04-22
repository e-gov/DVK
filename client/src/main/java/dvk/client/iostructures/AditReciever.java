package dvk.client.iostructures;

import dvk.core.CommonMethods;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import java.util.Date;

/**
* @author Hendrik Pärna
* @since 1.04.14
*/
public class AditReciever {
    public String personIdCode;
    public String senderName;
    public Boolean opened;
    public Date openedDate;

    /**
     * Parse AditReciever from xml.
     * @param root element
     * @return AditReciever
     */
    public static AditReciever fromXML(Element root) {
        AditReciever result = new AditReciever();

        NodeList nl = root.getChildNodes();
        Node n;
        for (int i = 0; i < nl.getLength(); ++i) {
            n = nl.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE) {
                if (n.getLocalName().equalsIgnoreCase("isikukood")) {
                    result.personIdCode = CommonMethods.getNodeText(n).trim();
                } else if (n.getLocalName().equalsIgnoreCase("saajaNimi")) {
                    result.senderName = CommonMethods.getNodeText(n).trim();
                } else if (n.getLocalName().equalsIgnoreCase("avatud")) {
                    result.opened = CommonMethods.getNodeBoolean(n);
                } else if (n.getLocalName().equalsIgnoreCase("avamiseAeg")) {
                    result.openedDate = CommonMethods.getDateFromXML(CommonMethods.getNodeText(n).trim());
                }
            }
        }

        return result;
    }
}
