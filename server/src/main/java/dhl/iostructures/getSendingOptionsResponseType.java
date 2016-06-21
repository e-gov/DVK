package dhl.iostructures;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolVersion;
import dhl.users.Asutus;

import java.util.ArrayList;
import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

public class getSendingOptionsResponseType implements SOAPOutputBodyRepresentation {
	
    public getSendingOptionsRequestType paring;
    public ArrayList<Asutus> asutused;

    public getSendingOptionsResponseType() {
        asutused = null;
        paring = null;
    }

    public getSendingOptionsResponseType(ArrayList<Asutus> data) {
        asutused = data;
        paring = null;
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolVersion xRoadProtocolVersion) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            se.addNamespaceDeclaration(xRoadProtocolVersion.getNamespacePrefix(), xRoadProtocolVersion.getNamespaceURI());
            se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
            se.addNamespaceDeclaration(CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_URI);

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("getSendingOptionsResponse", CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_URI));

            if (xRoadProtocolVersion.equals(XRoadProtocolVersion.V2_0)) {
	            SOAPElement elParing = element.addChildElement("paring", "");
	            if (paring != null) {
	                elParing.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
	                elParing.addAttribute(se.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "xsd:string[" + String.valueOf(paring.asutused.length) + "]");
	                for (int i = 0; i < paring.asutused.length; ++i) {
	                    SOAPElement elReqOrg = elParing.addChildElement("asutus");
	                    elReqOrg.addTextNode(paring.asutused[i]);
	                }
	            }
            }
	            
            SOAPElement elKeha = element.addChildElement("keha", "");
            elKeha.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
            elKeha.addAttribute(se.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "dhl:asutus[" + String.valueOf(asutused.size()) + "]");

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
