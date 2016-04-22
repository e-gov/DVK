package dhl.iostructures;

import dvk.core.CommonMethods;

import java.util.Iterator;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

public class getSendStatusResponseType implements SOAPOutputBodyRepresentation {
    public String paringKehaHash;
    public String kehaHref;

    public getSendStatusResponseType() {
        paringKehaHash = "";
        kehaHref = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("getSendStatusResponse"));
            SOAPElement elParing = element.addChildElement(se.createName("paring"));
            elParing.addTextNode(paringKehaHash);
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            elKeha.addAttribute(se.createName("href"), "cid:" + kehaHref);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
