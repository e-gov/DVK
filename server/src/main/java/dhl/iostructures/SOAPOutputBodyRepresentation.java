package dhl.iostructures;

import javax.xml.soap.SOAPException;
import org.apache.axis.AxisFault;

import dvk.core.xroad.XRoadProtocolVersion;

public interface SOAPOutputBodyRepresentation {
    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolVersion xRoadProtocolVersion) throws AxisFault, SOAPException;
}
