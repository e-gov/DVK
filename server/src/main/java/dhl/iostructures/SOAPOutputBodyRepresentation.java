package dhl.iostructures;

import javax.xml.soap.SOAPException;

import org.apache.axis.AxisFault;

import dvk.core.xroad.XRoadProtocolHeader;

public interface SOAPOutputBodyRepresentation {
	
	public static final String RESPONSE = "Response";
	
    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) throws AxisFault, SOAPException;
    
}
