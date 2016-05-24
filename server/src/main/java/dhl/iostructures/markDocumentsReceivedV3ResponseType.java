package dhl.iostructures;

import java.util.Iterator;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolVersion;

public class markDocumentsReceivedV3ResponseType implements SOAPOutputBodyRepresentation {
    static Logger logger = Logger.getLogger(markDocumentsReceivedV3ResponseType.class.getName());
    public Element paring;
    public String keha;

    public markDocumentsReceivedV3ResponseType() {
        paring = null;
        keha = "OK";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolVersion xRoadProtocolVersion) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            se.addNamespaceDeclaration(xRoadProtocolVersion.getNamespacePrefix(), xRoadProtocolVersion.getNamespaceURI());
            se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("markDocumentsReceivedResponse"));
            SOAPElement elParing = element.addChildElement(se.createName("paring"));
            if (paring != null) {
                NodeList nl = paring.getChildNodes();
                for (int i = 0; i < nl.getLength(); ++i) {
                    elParing.appendChild(nl.item(i));
                }
            }

            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            elKeha.addTextNode(keha);
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
        }
    }
}
