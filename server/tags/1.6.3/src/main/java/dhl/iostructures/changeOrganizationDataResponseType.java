package dhl.iostructures;

import dvk.core.CommonMethods;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class changeOrganizationDataResponseType {
    public changeOrganizationDataResponseType() {}
    
    private Element m_requestElement;

    public Element getRequestElement() {
        return m_requestElement;
    }

    public void setRequestElement(Element value) {
        m_requestElement = value;
    }
    
    public void addToSOAPBody( org.apache.axis.Message msg ) {
        try {
            String XTEE_PREFIX = "xtee";
            String XTEE_URI = "http://x-tee.riik.ee/xsd/xtee.xsd";
            String SOAPENC_PREFIX = "SOAP-ENC";
            String SOAPENC_URI = "http://schemas.xmlsoap.org/soap/encoding/";
            
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();
            
            se.addNamespaceDeclaration( XTEE_PREFIX, XTEE_URI );
            se.addNamespaceDeclaration( SOAPENC_PREFIX, SOAPENC_URI );

            Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName("changeOrganizationDataResponse",XTEE_PREFIX,XTEE_URI));
            SOAPElement elParing = element.addChildElement(se.createName("paring"));
            
            if (m_requestElement != null) {
                NodeList nl = m_requestElement.getChildNodes();
                for (int i = 0; i < nl.getLength(); ++i) {
                    elParing.appendChild(nl.item(i));
                }
            }
            
            SOAPElement elKeha = element.addChildElement("keha");
            elKeha.addTextNode("OK");
        }
        catch (Exception ex) {
            CommonMethods.logError( ex, this.getClass().getName(), "addToSOAPBody" );
        }
    }
}
