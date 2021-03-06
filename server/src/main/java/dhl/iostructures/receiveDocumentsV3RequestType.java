package dhl.iostructures;

import java.util.ArrayList;

import javax.xml.soap.SOAPBody;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.Settings;
import dvk.core.xroad.XRoadHeader;

public class receiveDocumentsV3RequestType {
	
	static Logger logger = Logger.getLogger(receiveDocumentsV3RequestType.class.getName());
    
    public int arv;
    public int allyksus;
    public int ametikoht;
    public ArrayList<String> kaust;
    public String edastusID;
    public int fragmentNr;
    public long fragmentSizeBytes;
    public long fragmentSizeBytesOrig;

    public receiveDocumentsV3RequestType() {
        arv = 10;
        allyksus = 0;
        ametikoht = 0;
        kaust = new ArrayList<String>();
        edastusID = "";
        fragmentNr = -1;
        fragmentSizeBytes = Settings.Client_FragmentSizeBytes;
        fragmentSizeBytesOrig = 0;
    }

    public static receiveDocumentsV3RequestType getFromSOAPBody(org.apache.axis.MessageContext context, XRoadHeader xRoadHeader) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            
            NodeList nodes = body.getElementsByTagName(receiveDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME);
            
            if (nodes.getLength() > 0) {
                Element el = (Element) nodes.item(0);
                nodes = el.getElementsByTagName("keha");
                if (nodes.getLength() > 0) {
                    receiveDocumentsV3RequestType result = new receiveDocumentsV3RequestType();
                    Element bodyNode = (Element) nodes.item(0);

                    // Arv
                    result.arv = CommonMethods.getNumberFromChildNode(bodyNode, "arv", 10);
                    // Kontrollime, et ei saaks esitada päringut, mille väljundisse
                    // ei ole lubatud ühtegi dokumenti.
                    if (result.arv < 1) {
                        result.arv = 1;
                    }

                    // Allüksus
                    result.allyksus = CommonMethods.getNumberFromChildNode(bodyNode, "allyksus", 0);

                    // Ametikoht
                    result.ametikoht = CommonMethods.getNumberFromChildNode(bodyNode, "ametikoht", 0);

                    // Kaust
                    nodes = bodyNode.getElementsByTagName("kaust");
                    if (nodes.getLength() > 0) {
                        for (int i = 0; i < nodes.getLength(); ++i) {
                            Element folderNode = (Element) nodes.item(i);
                            result.kaust.add(CommonMethods.getNodeText(folderNode));
                        }
                    }

                    // Edastus ID
                    nodes = bodyNode.getElementsByTagName("edastus_id");
                    if (nodes.getLength() > 0) {
                        result.edastusID = CommonMethods.getNodeText((Element) nodes.item(0)).trim();
                    }

                    // Fragmendi nr
                    nodes = bodyNode.getElementsByTagName("fragment_nr");
                    if (nodes.getLength() > 0) {
                        try {
                            result.fragmentNr = Integer.parseInt(CommonMethods.getNodeText((Element) nodes.item(0)));
                        } catch (Exception ex) {
                            CommonMethods.logError(ex, "dhl.iostructures.receiveDocumentsV2RequestType", "getFromSOAPBody");
                        }
                    }

                    // Fragmendi suurus
                    nodes = bodyNode.getElementsByTagName("fragmendi_suurus_baitides");
                    if (nodes.getLength() > 0) {
                        try {
                            result.fragmentSizeBytesOrig = Long.parseLong(CommonMethods.getNodeText((Element) nodes.item(0)));
                        } catch (Exception ex) {
                            result.fragmentSizeBytesOrig = 0;
                        }
                    }
                    // Fragmendi suurust alla 100kB ei luba
                    if (result.fragmentSizeBytesOrig < (1024 * 100)) {
                        result.fragmentSizeBytes = 1024 * 100;
                    } else {
                        result.fragmentSizeBytes = result.fragmentSizeBytesOrig;
                    }

                    return result;
                }
            }
            return null;
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            return null;
        }
    }
}
