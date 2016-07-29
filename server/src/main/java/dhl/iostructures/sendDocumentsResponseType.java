package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.commons.lang3.StringUtils;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class sendDocumentsResponseType implements SOAPOutputBodyRepresentation {
	
	private static final String DEFAULT_RESPONSE_ELEMENT_NAME = sendDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME + SOAPOutputBodyRepresentation.RESPONSE;
	
    public sendDocumentsRequestTypeBack paring;
    public String kehaHref;

    public sendDocumentsResponseType() {
        paring = new sendDocumentsRequestTypeBack();
        kehaHref = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) {
        try {
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }
            
            String responseElementName = DEFAULT_RESPONSE_ELEMENT_NAME;
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V4_0)) {
            	String serviceVersion = xRoadProtocolHeader.getXRoadService().getServiceVersion();
            	
            	if (StringUtils.isNotBlank(serviceVersion)) {
            		if (serviceVersion.equalsIgnoreCase("v2")) {
            			responseElementName = sendDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME + "V2" + SOAPOutputBodyRepresentation.RESPONSE;
            		} else if (serviceVersion.equalsIgnoreCase("v3")) {
            			responseElementName = sendDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME + "V3" + SOAPOutputBodyRepresentation.RESPONSE;
            		} else if (serviceVersion.equalsIgnoreCase("v4")) {
            			responseElementName = sendDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME + "V4" + SOAPOutputBodyRepresentation.RESPONSE;
            		}
            	}
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName(responseElementName));
            
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
            	SOAPElement elParing = element.addChildElement(se.createName("paring"));
            	SOAPElement elDok = elParing.addChildElement("dokumendid");
            	elDok.addTextNode(paring.dokumendid);
            	SOAPElement elKaust = elParing.addChildElement("kaust");
            	elKaust.addTextNode(paring.kaust);
            }
            
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            elKeha.addAttribute(se.createName("href"), "cid:" + kehaHref);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
    
}
