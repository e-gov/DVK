package dhl.iostructures;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolVersion;

import java.util.Iterator;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

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

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolVersion xRoadProtocolVersion) {
        try {
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("receiveDocumentsResponse"));

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
