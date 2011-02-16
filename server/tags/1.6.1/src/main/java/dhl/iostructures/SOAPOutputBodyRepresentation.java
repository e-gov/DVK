package dhl.iostructures;

import javax.xml.soap.SOAPException;
import org.apache.axis.AxisFault;

public interface SOAPOutputBodyRepresentation
{
    public void addToSOAPBody(org.apache.axis.Message msg) throws AxisFault, SOAPException;
}
