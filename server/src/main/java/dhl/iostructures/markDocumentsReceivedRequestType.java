package dhl.iostructures;

import javax.xml.soap.SOAPBody;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadHeader;

public class markDocumentsReceivedRequestType {
	
	public static final String DEFAULT_REQUEST_ELEMENT_NAME = "markDocumentsReceived";
	
    static Logger logger = Logger.getLogger(markDocumentsReceivedRequestType.class.getName());
    
    public String dokumendidHref;
    public String kaust;
    public String edastusID;
    public int allyksusId;
    public int ametikohtId;

    public markDocumentsReceivedRequestType() {
        dokumendidHref = "";
        kaust = "";
        edastusID = "";
        allyksusId = 0;
        ametikohtId = 0;
    }

    public static markDocumentsReceivedRequestType getFromSOAPBody(org.apache.axis.MessageContext context, XRoadHeader xRoadHeader) {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            
            NodeList msgNodes = body.getElementsByTagName(DEFAULT_REQUEST_ELEMENT_NAME);
            
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element) msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element) bodyNodes.item(0);
                    NodeList docRefNodes = bodyNode.getElementsByTagName("dokumendid");
                    if (docRefNodes.getLength() > 0) {
                        Element docRefNode = (Element) docRefNodes.item(0);
                        markDocumentsReceivedRequestType result = new markDocumentsReceivedRequestType();
                        result.dokumendidHref = docRefNode.getAttribute("href");
                        if (result.dokumendidHref.startsWith("cid:")) {
                            result.dokumendidHref = result.dokumendidHref.replaceFirst("cid:", "");
                        }
                        NodeList folderNodes = bodyNode.getElementsByTagName("kaust");
                        if (folderNodes.getLength() > 0) {
                            Element folderNode = (Element) folderNodes.item(0);
                            result.kaust = CommonMethods.getNodeText(folderNode);
                        }
                        NodeList sessionNodes = bodyNode.getElementsByTagName("edastus_id");
                        if (sessionNodes.getLength() > 0) {
                            Element sessionNode = (Element) sessionNodes.item(0);
                            result.edastusID = CommonMethods.getNodeText(sessionNode);
                        }
                        NodeList subdivisionNodes = bodyNode.getElementsByTagName("allyksus");
                        if (subdivisionNodes.getLength() > 0) {
                            String tmp = CommonMethods.getNodeText(subdivisionNodes.item(0));
                            if ((tmp != null) && (tmp.length() > 0)) {
                                try {
                                    result.allyksusId = Integer.parseInt(CommonMethods.getNodeText(subdivisionNodes.item(0)));
                                } catch (Exception ex) {
                                    logger.warn("Unable to parse value \"" + tmp + "\" of parameter \"allyksus\" to integer. Default value \"" + String.valueOf(result.allyksusId) + "\" will be used.");
                                }
                            }
                        }
                        NodeList occupationNodes = bodyNode.getElementsByTagName("ametikoht");
                        if (occupationNodes.getLength() > 0) {
                            String tmp = CommonMethods.getNodeText(occupationNodes.item(0));
                            if ((tmp != null) && (tmp.length() > 0)) {
                                try {
                                    result.ametikohtId = Integer.parseInt(tmp);
                                } catch (Exception ex) {
                                    logger.warn("Unable to parse value \"" + tmp + "\" of parameter \"ametikoht\" to integer. Default value \"" + String.valueOf(result.ametikohtId) + "\" will be used.");
                                }
                            }
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
