package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolVersion;

public class listMethodsResponseType implements SOAPOutputBodyRepresentation {
    public String[] list;

    public listMethodsResponseType(String[] data) {
        list = data;
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

            SOAPBodyElement element = body.addBodyElement(se.createName("listMethodsResponse", xRoadProtocolVersion.getNamespacePrefix(), xRoadProtocolVersion.getNamespaceURI()));
            SOAPElement elKeha = element.addChildElement("keha");
            elKeha.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
            elKeha.addAttribute(se.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "xsd:string[" + String.valueOf(list.length) + "]");
            for (int i = 0; i < list.length; ++i) {
                SOAPElement elItem = elKeha.addChildElement("item");
                elItem.addAttribute(se.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "xsd:string");
                elItem.addTextNode(list[i]);
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
