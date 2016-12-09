package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadHeader;
import dvk.core.xroad.XRoadMessageProtocolVersion;

public class sendDocumentsResponseType implements SOAPOutputBodyRepresentation {
	
	public static final String DEFAULT_RESPONSE_ELEMENT_NAME = sendDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME + SOAPOutputBodyRepresentation.RESPONSE;
	
    public sendDocumentsRequestTypeBack paring;
    public String kehaHref;

    public sendDocumentsResponseType() {
        paring = new sendDocumentsRequestTypeBack();
        kehaHref = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadHeader xRoadHeader) {
        try {
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName(DEFAULT_RESPONSE_ELEMENT_NAME));
            
            if (xRoadHeader.getMessageProtocolVersion().equals(XRoadMessageProtocolVersion.V2_0)) {
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
