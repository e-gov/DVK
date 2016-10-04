package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class markDocumentsReceivedV3ResponseType implements SOAPOutputBodyRepresentation {
	
	static Logger logger = Logger.getLogger(markDocumentsReceivedV3ResponseType.class.getName());
    
    public Element paring;
    public String keha;

    public markDocumentsReceivedV3ResponseType() {
        paring = null;
        keha = "OK";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            se.addNamespaceDeclaration(xRoadProtocolHeader.getProtocolVersion().getNamespacePrefix(), xRoadProtocolHeader.getProtocolVersion().getNamespaceURI());

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName(markDocumentsReceivedResponseType.DEFAULT_RESPONSE_ELEMENT_NAME));
            
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
            	se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
            	
	            SOAPElement elParing = element.addChildElement(se.createName("paring"));
	            if (paring != null) {
	                NodeList nl = paring.getChildNodes();
	                for (int i = 0; i < nl.getLength(); ++i) {
	                    elParing.appendChild(nl.item(i));
	                }
	            }
            }

            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            elKeha.addTextNode(keha);
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
        }
    }
}
