package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolVersion;

public class getSendStatusResponseType implements SOAPOutputBodyRepresentation {
    public String paringKehaHash;
    public String kehaHref;

    public getSendStatusResponseType() {
        paringKehaHash = "";
        kehaHref = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolVersion xRoadProtocolVersion) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("getSendStatusResponse"));
            
            if (xRoadProtocolVersion.equals(XRoadProtocolVersion.V2_0)) {
	            SOAPElement elParing = element.addChildElement(se.createName("paring"));
	            elParing.addTextNode(paringKehaHash);
            }
            
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            elKeha.addAttribute(se.createName("href"), "cid:" + kehaHref);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
