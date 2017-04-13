package dhl.iostructures;

import java.util.ArrayList;
import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dhl.users.Asutus;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadHeader;
import dvk.core.xroad.XRoadMessageProtocolVersion;

public class getSendingOptionsV2ResponseType implements SOAPOutputBodyRepresentation {
	
	public getSendingOptionsV2RequestType paring;
    public ArrayList<Asutus> asutused;

    public getSendingOptionsV2ResponseType() {
        asutused = null;
        paring = null;
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadHeader xRoadHeader) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            se.addNamespaceDeclaration(xRoadHeader.getMessageProtocolVersion().getNamespacePrefix(), xRoadHeader.getMessageProtocolVersion().getNamespaceURI());
            se.addNamespaceDeclaration(CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_SCHEMA_URI);

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName(getSendingOptionsResponseType.DEFAULT_RESPONSE_ELEMENT_NAME, CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_SCHEMA_URI));
            
            if (xRoadHeader.getMessageProtocolVersion().equals(XRoadMessageProtocolVersion.V2_0)) {
            	se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
            	
				SOAPElement elParing = element.addChildElement("paring", "");
				if (paring != null) {
					SOAPElement elVvDokOotel = elParing.addChildElement("vastuvotmata_dokumente_ootel", "");
					elVvDokOotel.addTextNode(paring.vastuvotmataDokumenteOotelStr);
					SOAPElement elVahDokVahemalt = elParing.addChildElement("vahetatud_dokumente_vahemalt", "");
					elVahDokVahemalt.addTextNode(paring.vahetatudDokumenteVahemaltStr);
					SOAPElement elVahDokKuni = elParing.addChildElement("vahetatud_dokumente_kuni", "");
					elVahDokKuni.addTextNode(paring.vahetatudDokumenteKuniStr);

					SOAPElement elAsutused = elParing.addChildElement("asutused", "");
					elAsutused.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
					elAsutused.addAttribute(se.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "xsd:string[" + String.valueOf(paring.asutused.length) + "]");
					for (int i = 0; i < paring.asutused.length; ++i) {
						SOAPElement elReqOrg = elAsutused.addChildElement("asutus");
						elReqOrg.addTextNode(paring.asutused[i]);
					}
				} 
			}
            
			SOAPElement elKeha = element.addChildElement("keha", "");
			if (xRoadHeader.getMessageProtocolVersion().equals(XRoadMessageProtocolVersion.V2_0)) {
	            elKeha.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
	            elKeha.addAttribute(se.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "dhl:asutus[" + String.valueOf(asutused.size()) + "]");
			}

            Asutus org;
            for (int i = 0; i < asutused.size(); ++i) {
                org = asutused.get(i);
                SOAPElement elOrg = elKeha.addChildElement("asutus");

                SOAPElement elRegNr = elOrg.addChildElement("regnr");
                elRegNr.addTextNode(org.getRegistrikood());

                SOAPElement elName = elOrg.addChildElement("nimi");
                elName.addTextNode(org.getNimetus());

                SOAPElement elSending = elOrg.addChildElement("saatmine");
                if (org.getDvkSaatmine()) {
                    SOAPElement elSendingDhl = elSending.addChildElement("saatmisviis");
                    elSendingDhl.addTextNode(CommonStructures.SENDING_DHL);
                }
                if (org.getDvkOtseSaatmine()) {
                    SOAPElement elSendingDhl = elSending.addChildElement("saatmisviis");
                    elSendingDhl.addTextNode(CommonStructures.SENDING_DHL_DIRECT);
                }

                if ((org.getKsAsutuseKood() != null) && (org.getKsAsutuseKood().length() > 0)) {
                    SOAPElement elParentOrg = elOrg.addChildElement("ks_asutuse_regnr");
                    elParentOrg.addTextNode(org.getKsAsutuseKood());
                }
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}