package dhl.iostructures;

import javax.xml.soap.SOAPException;

import org.apache.axis.AxisFault;

import dvk.core.xroad.XRoadHeader;

public interface SOAPOutputBodyRepresentation {
	
	public static final String RESPONSE = "Response";
	
    public void addToSOAPBody(org.apache.axis.Message msg, XRoadHeader xRoadHeader) throws AxisFault, SOAPException;
    
}
