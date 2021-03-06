package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadMessageProtocolVersion;

public class changeOrganizationDataResponseType {
	
    public changeOrganizationDataResponseType() {
    }

    private Element m_requestElement;

    public Element getRequestElement() {
        return m_requestElement;
    }

    public void setRequestElement(Element value) {
        m_requestElement = value;
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadMessageProtocolVersion xRoadMessageProtocolVersion) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            se.addNamespaceDeclaration(xRoadMessageProtocolVersion.getNamespacePrefix(), xRoadMessageProtocolVersion.getNamespaceURI());

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("changeOrganizationDataResponse",
            				xRoadMessageProtocolVersion.getNamespacePrefix(),
            				xRoadMessageProtocolVersion.getNamespaceURI()));
            
            if (xRoadMessageProtocolVersion.equals(XRoadMessageProtocolVersion.V2_0)) {
            	se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
            	
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
