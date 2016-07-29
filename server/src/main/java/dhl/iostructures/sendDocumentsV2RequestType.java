package dhl.iostructures;

import java.util.Date;

import javax.xml.soap.SOAPBody;

import org.apache.axis.AxisFault;
import org.apache.commons.lang3.StringUtils;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class sendDocumentsV2RequestType {
	
	public String dokumendid;
    public String kaust;
    public Date sailitustahtaeg;
    public String edastusID;
    public int fragmentNr;
    public int fragmenteKokku;

    public sendDocumentsV2RequestType() {
        dokumendid = "";
        kaust = "";
        sailitustahtaeg = null;
        edastusID = "";
        fragmentNr = 0;
        fragmenteKokku = 0;
    }

    public static sendDocumentsV2RequestType getFromSOAPBody(org.apache.axis.MessageContext context, XRoadProtocolHeader xRoadProtocolHeader) throws AxisFault {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList tmpNodes = null;
            Element el = null;
            
            String requestElementName = sendDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME;
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V4_0)) {
            	// NOTE For some unknown historical reason versions 3 and 4 of sendDocuments request are also handled by this method
            	String serviceVersion = xRoadProtocolHeader.getXRoadService().getServiceVersion();
            	
            	if (StringUtils.isNotBlank(serviceVersion)) {
            		if (serviceVersion.equalsIgnoreCase("v2")) {
            			requestElementName += "V2";
            		} else if (serviceVersion.equalsIgnoreCase("v3")) {
            			requestElementName += "V3";
            		} else if (serviceVersion.equalsIgnoreCase("v4")) {
            			requestElementName += "V4";
            		}
            	}
            }
            
            NodeList msgNodes = body.getElementsByTagName(requestElementName);
            
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element) msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element) bodyNodes.item(0);
                    NodeList docRefNodes = bodyNode.getElementsByTagName("dokumendid");
                    if (docRefNodes.getLength() > 0) {
                        Element docRefNode = (Element) docRefNodes.item(0);
                        sendDocumentsV2RequestType result = new sendDocumentsV2RequestType();
                        result.dokumendid = docRefNode.getAttribute("href");
                        if (result.dokumendid.startsWith("cid:")) {
                            result.dokumendid = result.dokumendid.replaceFirst("cid:", "");
                        }
                        tmpNodes = bodyNode.getElementsByTagName("kaust");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element) tmpNodes.item(0);
                            result.kaust = CommonMethods.getNodeText(el);
                        }
                        tmpNodes = bodyNode.getElementsByTagName("sailitustahtaeg");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element) tmpNodes.item(0);
                            String dateString = CommonMethods.getNodeText(el);
                            if ((dateString != null) && !dateString.equalsIgnoreCase("")) {
                                result.sailitustahtaeg = CommonMethods.getDateFromXML(dateString);
                                if (result.sailitustahtaeg == null) {
                                    throw new AxisFault("Dokumendi sailitustahtaeg on esitatud vigaselt!");
                                }
                            }
                        }
                        tmpNodes = bodyNode.getElementsByTagName("edastus_id");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element) tmpNodes.item(0);
                            result.edastusID = CommonMethods.getNodeText(el);
                        }
                        tmpNodes = bodyNode.getElementsByTagName("fragment_nr");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element) tmpNodes.item(0);
                            result.fragmentNr = Integer.parseInt(CommonMethods.getNodeText(el));
                        }
                        tmpNodes = bodyNode.getElementsByTagName("fragmente_kokku");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element) tmpNodes.item(0);
                            result.fragmenteKokku = Integer.parseInt(CommonMethods.getNodeText(el));
                        }
                        return result;
                    }
                }
            }
            return null;
        } catch (AxisFault fault) {
            throw fault;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.sendDocumentsV2RequestType", "getFromSOAPBody");
            return null;
        }
    }
}
