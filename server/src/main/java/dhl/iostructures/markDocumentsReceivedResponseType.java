package dhl.iostructures;

import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.commons.lang3.StringUtils;

import dvk.core.CommonMethods;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class markDocumentsReceivedResponseType implements SOAPOutputBodyRepresentation {
	
	public static final String DEFAULT_RESPONSE_ELEMENT_NAME = markDocumentsReceivedRequestType.DEFAULT_REQUEST_ELEMENT_NAME + SOAPOutputBodyRepresentation.RESPONSE;
	
    public markDocumentsReceivedRequestTypeBack paring;
    public String keha;

    public markDocumentsReceivedResponseType() {
        paring = new markDocumentsReceivedRequestTypeBack();
        keha = "OK";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            String responseElementName = DEFAULT_RESPONSE_ELEMENT_NAME;
            // FIXME Currently (29.07.2016) the WSDL has no related element definitions
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V4_0)) {
            	// NOTE For some unknown historical reason version 2 of markDocumentsReceivedResponse is also handled by this method
            	String serviceVersion = xRoadProtocolHeader.getXRoadService().getServiceVersion();
            	
            	if (StringUtils.isNotBlank(serviceVersion)) {
            		if (serviceVersion.equalsIgnoreCase("v2")) {
            			responseElementName = markDocumentsReceivedRequestType.DEFAULT_REQUEST_ELEMENT_NAME + "V2" + SOAPOutputBodyRepresentation.RESPONSE;
            		}
            	}
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName(responseElementName));
            
            if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
	            SOAPElement elParing = element.addChildElement(se.createName("paring"));
	            SOAPElement elDok = elParing.addChildElement("dokumendid");
	            elDok.addTextNode(paring.dokumendid);
	            SOAPElement elKaust = elParing.addChildElement("kaust");
	            elKaust.addTextNode(paring.kaust);
            }
            
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            elKeha.addTextNode(keha);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
}
