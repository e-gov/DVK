package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class receiveDocumentsV2ResponseType implements SOAPOutputBodyRepresentation {
		
    public receiveDocumentsV2RequestType paring;
    public String dokumendidHref;
    public String edastusID;
    public int fragmentNr;
    public int fragmenteKokku;

    public receiveDocumentsV2ResponseType() {
        paring = new receiveDocumentsV2RequestType();
        dokumendidHref = "";
        edastusID = "";
        fragmentNr = -1;
        fragmenteKokku = 0;
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

            String responseElementName = receiveDocumentsResponseType.DEFAULT_RESPONSE_ELEMENT_NAME;
            // FIXME Currently (29.07.2016) the WSDL has no related element definitions
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V4_0)) {
            	responseElementName = receiveDocumentsRequestType.DEFAULT_REQUEST_ELEMENT_NAME + "V2" + SOAPOutputBodyRepresentation.RESPONSE;
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName(responseElementName)); 

            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
	            // Sõnumi päringu osa
	            SOAPElement elParing = element.addChildElement(se.createName("paring"));
	            SOAPElement elArv = elParing.addChildElement("arv");
	            elArv.addTextNode(String.valueOf(paring.arv));
	            for (int i = 0; i < paring.kaust.size(); ++i) {
	                SOAPElement elKaust = elParing.addChildElement("kaust");
	                elKaust.addTextNode(paring.kaust.get(i));
	            }
	            if ((paring.edastusID != null) && !paring.edastusID.equalsIgnoreCase("")) {
	                SOAPElement elParEdastusID = elParing.addChildElement("edastus_id");
	                elParEdastusID.addTextNode(paring.edastusID);
	            }
	            if (paring.fragmentNr >= 0) {
	                SOAPElement elParFragmentNr = elParing.addChildElement("fragment_nr");
	                elParFragmentNr.addTextNode(String.valueOf(paring.fragmentNr));
	            }
	            if (paring.fragmentSizeBytesOrig > 0) {
	                SOAPElement elParFragmentSize = elParing.addChildElement("fragmendi_suurus_baitides");
	                elParFragmentSize.addTextNode(String.valueOf(paring.fragmentSizeBytesOrig));
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
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
