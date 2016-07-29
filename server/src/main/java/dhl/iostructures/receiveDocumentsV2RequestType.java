package dhl.iostructures;

import java.util.ArrayList;
import java.util.List;

import javax.xml.soap.SOAPBody;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.Settings;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class receiveDocumentsV2RequestType {
	
    public int arv;
    public List<String> kaust;
    public String edastusID;
    public int fragmentNr;
    public long fragmentSizeBytes;
    public long fragmentSizeBytesOrig;

    public receiveDocumentsV2RequestType() {
        arv = 10;
        kaust = new ArrayList<String>();
        edastusID = "";
        fragmentNr = -1;
        fragmentSizeBytes = Settings.Client_FragmentSizeBytes;
        fragmentSizeBytesOrig = 0;
    }

    public static receiveDocumentsV2RequestType getFromSOAPBody(org.apache.axis.MessageContext context, XRoadProtocolHeader xRoadProtocolHeader ) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            
            String requestElementName = receiveDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME;
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V4_0)) {
            	requestElementName += "V2";
            }
            
            NodeList nodes = body.getElementsByTagName(requestElementName);
            
            if (nodes.getLength() > 0) {
                Element el = (Element) nodes.item(0);
                nodes = el.getElementsByTagName("keha");
                if (nodes.getLength() > 0) {
                    receiveDocumentsV2RequestType result = new receiveDocumentsV2RequestType();
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
            CommonMethods.logError(ex, "dhl.iostructures.receiveDocumentsV2RequestType", "getFromSOAPBody");
            return null;
        }
    }
}
