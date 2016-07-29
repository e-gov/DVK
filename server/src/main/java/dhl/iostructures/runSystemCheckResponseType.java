package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class runSystemCheckResponseType implements SOAPOutputBodyRepresentation {
    private Element m_requestElement;

    public runSystemCheckResponseType() {

    }

    public Element getRequestElement() {
        return m_requestElement;
    }

    public void setRequestElement(Element value) {
        m_requestElement = value;
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            se.addNamespaceDeclaration(xRoadProtocolHeader.getProtocolVersion().getNamespacePrefix(), xRoadProtocolHeader.getProtocolVersion().getNamespaceURI());
            se.addNamespaceDeclaration(CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI);
            se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(
            		se.createName("runSystemCheckResponse", xRoadProtocolHeader.getProtocolVersion().getNamespacePrefix(), xRoadProtocolHeader.getProtocolVersion().getNamespaceURI()));

            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
            	SOAPElement elParing = element.addChildElement(se.createName("paring"));
            	if (m_requestElement != null) {
            		NodeList nl = m_requestElement.getChildNodes();
            		for (int i = 0; i < nl.getLength(); ++i) {
            			elParing.appendChild(nl.item(i));
            		}
            	}
            }

            SOAPElement elKeha = element.addChildElement("keha");
            elKeha.addTextNode("OK");
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
