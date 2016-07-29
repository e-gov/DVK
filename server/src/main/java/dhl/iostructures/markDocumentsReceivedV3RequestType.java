package dhl.iostructures;

import java.util.ArrayList;

import javax.xml.soap.SOAPBody;

import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class markDocumentsReceivedV3RequestType {
    static Logger logger = Logger.getLogger(markDocumentsReceivedV3RequestType.class.getName());
    public ArrayList<markDocumentsReceivedV2Item> dokumendid;
    public String kaust;
    public String edastusID;
    public String allyksuseLyhinimetus;
    public String ametikohaLyhinimetus;

    public markDocumentsReceivedV3RequestType() {
        this.dokumendid = new ArrayList<markDocumentsReceivedV2Item>();
        this.kaust = "";
        this.edastusID = "";
        this.allyksuseLyhinimetus = "";
        this.ametikohaLyhinimetus = "";
    }

    public static markDocumentsReceivedV3RequestType getFromSOAPBody(org.apache.axis.MessageContext context, XRoadProtocolHeader xRoadProtocolHeader) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            
            String requestElementName = markDocumentsReceivedRequestType.DEFAULT_REQUEST_ELEMENT_NAME;
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V4_0)) {
            	requestElementName += "V3";
            }
            
            NodeList msgNodes = body.getElementsByTagName(requestElementName);
            
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element) msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element) bodyNodes.item(0);
                    NodeList docRefNodes = bodyNode.getElementsByTagName("dokumendid");
                    if (docRefNodes.getLength() > 0) {
                        markDocumentsReceivedV3RequestType result = new markDocumentsReceivedV3RequestType();
                        Element docRefNode = (Element) docRefNodes.item(0);

                        NodeList foundNodes = docRefNode.getElementsByTagName("item");

                        // Kontrollime, et sisendis sisalduks vähemalt 1 dokumendi andmed
                        if (foundNodes == null) {
                            throw new AxisFault("Dokumentide nimekiri on tühi või vigase XML struktuuriga!");
                        }
                        if (foundNodes.getLength() < 1) {
                            throw new AxisFault("Dokumentide nimekiri on tühi või vigase XML struktuuriga!");
                        }
                        for (int i = 0; i < foundNodes.getLength(); ++i) {
                            markDocumentsReceivedV2Item item = markDocumentsReceivedV2Item.getFromXML((Element) foundNodes.item(i));
                            result.dokumendid.add(item);
                        }

                        NodeList folderNodes = bodyNode.getElementsByTagName("kaust");
                        if (folderNodes.getLength() > 0) {
                            result.kaust = CommonMethods.getNodeText(folderNodes.item(0));
                        }
                        NodeList sessionNodes = bodyNode.getElementsByTagName("edastus_id");
                        if (sessionNodes.getLength() > 0) {
                            result.edastusID = CommonMethods.getNodeText(sessionNodes.item(0));
                        }
                        NodeList subdivisionNodes = bodyNode.getElementsByTagName("allyksuse_lyhinimetus");
                        if (subdivisionNodes.getLength() > 0) {
                            result.allyksuseLyhinimetus = CommonMethods.getNodeText(subdivisionNodes.item(0));
                        }
                        NodeList occupationNodes = bodyNode.getElementsByTagName("ametikoha_lyhinimetus");
                        if (occupationNodes.getLength() > 0) {
                            result.ametikohaLyhinimetus = CommonMethods.getNodeText(occupationNodes.item(0));
                        }
                        return result;
                    }
                }
            }
            return null;
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            return null;
        }
    }
}
