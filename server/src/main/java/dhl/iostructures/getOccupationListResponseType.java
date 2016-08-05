package dhl.iostructures;

import java.util.ArrayList;
import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.log4j.Logger;

import dhl.users.Ametikoht;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class getOccupationListResponseType implements SOAPOutputBodyRepresentation {
    static Logger logger = Logger.getLogger(getOccupationListResponseType.class.getName());
    public getOccupationListRequestType paring;
    public ArrayList<Ametikoht> ametikohad;

    public getOccupationListResponseType() {
        ametikohad = null;
        paring = null;
    }

    public getOccupationListResponseType(ArrayList<Ametikoht> data) {
        ametikohad = data;
        paring = null;
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            se.addNamespaceDeclaration(xRoadProtocolHeader.getProtocolVersion().getNamespacePrefix(), xRoadProtocolHeader.getProtocolVersion().getNamespaceURI());
            se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
            se.addNamespaceDeclaration(CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_URI);

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("getOccupationListResponse", CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_URI));

            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
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
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
	            elKeha.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
	            elKeha.addAttribute(se.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "dhl:ametikoht[" + String.valueOf(ametikohad.size()) + "]");
            }

            Ametikoht occupation;
            for (int i = 0; i < ametikohad.size(); ++i) {
                occupation = ametikohad.get(i);
                SOAPElement elOccupation = elKeha.addChildElement("ametikoht");

                SOAPElement elRegNr = elOccupation.addChildElement("kood");
                elRegNr.addTextNode(String.valueOf(occupation.getID()));

                SOAPElement elName = elOccupation.addChildElement("nimetus");
                elName.addTextNode(occupation.getNimetus());

                SOAPElement elOrg = elOccupation.addChildElement("asutuse_kood");
                elOrg.addTextNode(occupation.getAsutusKood());

                if ((occupation.getLyhinimetus() != null) && (occupation.getLyhinimetus().length() > 0)) {
                    SOAPElement elShortName = elOccupation.addChildElement("lyhinimetus");
                    elShortName.addTextNode(occupation.getLyhinimetus());
                }

                if ((occupation.getAllyksuseLyhinimetus() != null) && (occupation.getAllyksuseLyhinimetus().length() > 0)) {
                    SOAPElement elParent = elOccupation.addChildElement("ks_allyksuse_lyhinimetus");
                    elParent.addTextNode(occupation.getAllyksuseLyhinimetus());
                }
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
        }
    }
}
