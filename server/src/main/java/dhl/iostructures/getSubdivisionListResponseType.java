package dhl.iostructures;

import java.util.ArrayList;
import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dhl.users.Allyksus;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadHeader;
import dvk.core.xroad.XRoadMessageProtocolVersion;

public class getSubdivisionListResponseType implements SOAPOutputBodyRepresentation {
	
	public static final String DEFAULT_RESPONSE_ELEMENT_NAME = getSubdivisionListRequestType.DEFAULT_REQUEST_ELEMENT_NAME + SOAPOutputBodyRepresentation.RESPONSE;
	
    public getSubdivisionListRequestType paring;
    public ArrayList<Allyksus> allyksused;

    public getSubdivisionListResponseType() {
        allyksused = null;
        paring = null;
    }

    public getSubdivisionListResponseType(ArrayList<Allyksus> data) {
        allyksused = data;
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

            SOAPBodyElement element = body.addBodyElement(se.createName(DEFAULT_RESPONSE_ELEMENT_NAME, CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_SCHEMA_URI));

            if (xRoadHeader.getMessageProtocolVersion().equals(XRoadMessageProtocolVersion.V2_0)) {
            	se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
            	
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
            if (xRoadHeader.getMessageProtocolVersion().equals(XRoadMessageProtocolVersion.V2_0)) {
	            elKeha.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
	            elKeha.addAttribute(se.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "dhl:allyksus[" + String.valueOf(allyksused.size()) + "]");
            }

            Allyksus sub;
            for (int i = 0; i < allyksused.size(); ++i) {
                sub = allyksused.get(i);
                SOAPElement elSub = elKeha.addChildElement("allyksus");

                SOAPElement elRegNr = elSub.addChildElement("kood");
                elRegNr.addTextNode(String.valueOf(sub.getID()));

                SOAPElement elName = elSub.addChildElement("nimetus");
                elName.addTextNode(sub.getNimetus());

                SOAPElement elOrg = elSub.addChildElement("asutuse_kood");
                elOrg.addTextNode(sub.getAsutusKood());

                if ((sub.getLyhinimetus() != null) && (sub.getLyhinimetus().length() > 0)) {
                    SOAPElement elShortName = elSub.addChildElement("lyhinimetus");
                    elShortName.addTextNode(sub.getLyhinimetus());
                }

                if ((sub.getKsAllyksuseLyhinimetus() != null) && (sub.getKsAllyksuseLyhinimetus().length() > 0)) {
                    SOAPElement elParent = elSub.addChildElement("ks_allyksuse_lyhinimetus");
                    elParent.addTextNode(sub.getKsAllyksuseLyhinimetus());
                }
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
