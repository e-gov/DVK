package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class receiveDocumentsResponseType implements SOAPOutputBodyRepresentation {
	
	public static final String DEFAULT_RESPONSE_ELEMENT_NAME = receiveDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME + SOAPOutputBodyRepresentation.RESPONSE;

    public receiveDocumentsRequestType paring;
    public String kehaHref;

    public receiveDocumentsResponseType() {
        paring = new receiveDocumentsRequestType();
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

            SOAPBodyElement element = body.addBodyElement(se.createName(DEFAULT_RESPONSE_ELEMENT_NAME));
            
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
	            SOAPElement elParing = element.addChildElement(se.createName("paring"));
	            SOAPElement elArv = elParing.addChildElement("arv");
	            elArv.addTextNode(String.valueOf(paring.arv));
	            for (int i = 0; i < paring.kaust.size(); ++i) {
	                SOAPElement elKaust = elParing.addChildElement("kaust");
	                elKaust.addTextNode(paring.kaust.get(i));
	            }
            }
            
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            elKeha.addAttribute(se.createName("href"), "cid:" + kehaHref);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
