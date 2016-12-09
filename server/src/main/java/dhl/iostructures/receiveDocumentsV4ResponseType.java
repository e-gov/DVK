package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.xroad.XRoadHeader;
import dvk.core.xroad.XRoadMessageProtocolVersion;

public class receiveDocumentsV4ResponseType implements SOAPOutputBodyRepresentation {
	
	static Logger logger = Logger.getLogger(receiveDocumentsV4ResponseType.class.getName());
	
	public Element paring;
    public String dokumendidHref;
    public String edastusID;
    public int fragmentNr;
    public int fragmenteKokku;

    public receiveDocumentsV4ResponseType() {
        paring = null;
        dokumendidHref = "";
        edastusID = "";
        fragmentNr = -1;
        fragmenteKokku = 0;
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
            
            SOAPBodyElement element = body.addBodyElement(se.createName(receiveDocumentsResponseType.DEFAULT_RESPONSE_ELEMENT_NAME));

            if (xRoadHeader.getMessageProtocolVersion().equals(XRoadMessageProtocolVersion.V2_0)) {
	            // Sõnumi päringu osa
	            if (paring != null) {
	            	SOAPElement elParing = element.addChildElement(se.createName("paring"));
	                if (paring != null) {
	                    NodeList nl = paring.getChildNodes();
	                    for (int i = 0; i < nl.getLength(); ++i) {
	                        elParing.appendChild(nl.item(i));
	                    }
	                }
	            }
            }

            // Sõnumi keha osa
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            if ((edastusID != null) && !edastusID.equalsIgnoreCase("")) {
                SOAPElement elEdastusID = elKeha.addChildElement(se.createName("edastus_id"));
                elEdastusID.addTextNode(edastusID);
            }
            if (fragmentNr >= 0) {
                SOAPElement elFragmentNr = elKeha.addChildElement(se.createName("fragment_nr"));
                elFragmentNr.addTextNode(String.valueOf(fragmentNr));
            }
            if (fragmenteKokku > 0) {
                SOAPElement elFragmenteKokku = elKeha.addChildElement(se.createName("fragmente_kokku"));
                elFragmenteKokku.addTextNode(String.valueOf(fragmenteKokku));
            }
            SOAPElement elDokument = elKeha.addChildElement(se.createName("dokumendid"));
            elDokument.addAttribute(se.createName("href"), "cid:" + dokumendidHref);
        } catch (Exception ex) {
        	logger.error(ex.getMessage(), ex);
        }
    }
}
