package dhl.iostructures;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolVersion;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

public class sendDocumentsResponseType implements SOAPOutputBodyRepresentation {
    public sendDocumentsRequestTypeBack paring;
    public String kehaHref;

    public sendDocumentsResponseType() {
        paring = new sendDocumentsRequestTypeBack();
        kehaHref = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolVersion xRoadProtocolVersion) {
        try {
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("sendDocumentsResponse"));
            
            if (xRoadProtocolVersion.equals(XRoadProtocolVersion.V2_0)) {
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
