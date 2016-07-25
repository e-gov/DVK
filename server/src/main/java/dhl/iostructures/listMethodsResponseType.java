package dhl.iostructures;

import java.util.Iterator;
import java.util.List;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadIdentifierType;
import dvk.core.xroad.XRoadObjectType;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolHeaderField;
import dvk.core.xroad.XRoadProtocolVersion;
import dvk.core.xroad.XRoadService;

public class listMethodsResponseType implements SOAPOutputBodyRepresentation {
	
	/**
	 * For storing list of methods/services offered by this producer when using X-Road protocol v2.0 (legacy)
	 */
    private String[] methodsList;
    
    /**
	 * For storing list of methods/services offered by this producer when using X-Road protocol v4.0
	 */
    private List<XRoadService> xRoadServices;

    public listMethodsResponseType(String[] methodsList) {
        this.methodsList = methodsList;
    }
    
    public listMethodsResponseType(List<XRoadService> xRoadServices) {
    	this.xRoadServices = xRoadServices;
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolVersion xRoadProtocolVersion) {
        try {
            // Get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope soapEnvelope = msg.getSOAPEnvelope();
            SOAPBody body = soapEnvelope.getBody();

            soapEnvelope.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
            soapEnvelope.addNamespaceDeclaration(xRoadProtocolVersion.getNamespacePrefix(), xRoadProtocolVersion.getNamespaceURI());

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement soapBody = body.addBodyElement(soapEnvelope.createName("listMethodsResponse", xRoadProtocolVersion.getNamespacePrefix(), xRoadProtocolVersion.getNamespaceURI()));
            
            if (xRoadProtocolVersion.equals(XRoadProtocolVersion.V2_0)) {
            	SOAPElement elKeha = soapBody.addChildElement("keha");
            	elKeha.addAttribute(soapEnvelope.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "SOAP-ENC:Array");
            	elKeha.addAttribute(soapEnvelope.createName("arrayType", CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI), "xsd:string[" + String.valueOf(methodsList.length) + "]");
            	
            	for (int i = 0; i < methodsList.length; ++i) {
            		SOAPElement elItem = elKeha.addChildElement("item");
            		elItem.addAttribute(soapEnvelope.createName("type", CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI), "xsd:string");
            		elItem.addTextNode(methodsList[i]);
            	}
            } else if (xRoadProtocolVersion.equals(XRoadProtocolVersion.V4_0)) {
            	soapEnvelope.addNamespaceDeclaration(XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX, XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_URI);
            	
            	for (XRoadService xRoadService : xRoadServices) {
            		SOAPElement serviceElement = soapBody.addChildElement(XRoadProtocolHeaderField.SERVICE.getValue(), xRoadProtocolVersion.getNamespacePrefix());
            		serviceElement.addAttribute(
            				soapEnvelope.createName("objectType", XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX, XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_URI),
            				XRoadObjectType.SERVICE.getName());
            		
            		SOAPElement xRoadInstance = serviceElement.addChildElement(XRoadIdentifierType.XROAD_INSTANCE.getName(), XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX);
            		xRoadInstance.addTextNode(xRoadService.getxRoadInstance());
            		
            		SOAPElement memberClass = serviceElement.addChildElement(XRoadIdentifierType.MEMBER_CLASS.getName(), XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX);
            		memberClass.addTextNode(xRoadService.getMemberClass());
            		
            		SOAPElement memberCode = serviceElement.addChildElement(XRoadIdentifierType.MEMBER_CODE.getName(), XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX);
            		memberCode.addTextNode(xRoadService.getMemberCode());
            		
            		SOAPElement subsystemCode = serviceElement.addChildElement(XRoadIdentifierType.SUBSYSTEM_CODE.getName(), XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX);
            		subsystemCode.addTextNode(xRoadService.getSubsystemCode());
            		
            		SOAPElement serviceCode = serviceElement.addChildElement(XRoadIdentifierType.SERVICE_CODE.getName(), XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX);
            		serviceCode.addTextNode(xRoadService.getServiceCode());
            		
            		SOAPElement serviceVersion = serviceElement.addChildElement(XRoadIdentifierType.SERVICE_VERSION.getName(), XRoadProtocolHeader.NAMESPACE_IDENTIFIERS_PREFIX);
            		serviceVersion.addTextNode(xRoadService.getServiceVersion());
            	}
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }

	public String[] getMethodsList() {
		return methodsList;
	}

	public void setMethodsList(String[] methodsList) {
		this.methodsList = methodsList;
	}

	public List<XRoadService> getxRoadServices() {
		return xRoadServices;
	}

	public void setxRoadServices(List<XRoadService> xRoadServices) {
		this.xRoadServices = xRoadServices;
	}
	
}
