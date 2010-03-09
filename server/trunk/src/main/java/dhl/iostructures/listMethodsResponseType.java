package dhl.iostructures;

import dvk.core.CommonMethods;
import java.util.Iterator;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

public class listMethodsResponseType implements SOAPOutputBodyRepresentation
{
    public String[] list;
    
    public listMethodsResponseType( String[] data )
    {
        list = data;
    }
    
    public void addToSOAPBody( org.apache.axis.Message msg )
    {
        try
        {
            String XTEE_PREFIX = "xtee";
            String XTEE_URI = "http://x-tee.riik.ee/xsd/xtee.xsd";
            String SOAPENC_PREFIX = "SOAP-ENC";
            String SOAPENC_URI = "http://schemas.xmlsoap.org/soap/encoding/";
            String XSI_PREFIX = "xsi";
            String XSI_URI = "http://www.w3.org/2001/XMLSchema-instance";
            
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();
            
            se.addNamespaceDeclaration( XTEE_PREFIX, XTEE_URI );
            se.addNamespaceDeclaration( SOAPENC_PREFIX, SOAPENC_URI );

            Iterator items = body.getChildElements();
            if( items.hasNext() )
            {
                body.removeContents();
            }
            
            SOAPBodyElement element = body.addBodyElement(se.createName("listMethodsResponse",XTEE_PREFIX,XTEE_URI));
            SOAPElement elKeha = element.addChildElement("keha");
            elKeha.addAttribute(se.createName("type",XSI_PREFIX,XSI_URI),"SOAP-ENC:Array");
            elKeha.addAttribute(se.createName("arrayType",SOAPENC_PREFIX,SOAPENC_URI),"xsd:string["+String.valueOf(list.length)+"]");
            for( int i = 0; i < list.length; ++i )
            {
                SOAPElement elItem = elKeha.addChildElement("item");
                elItem.addAttribute(se.createName("type",XSI_PREFIX,XSI_URI),"xsd:string");
                elItem.addTextNode( list[i] );
            }
        }
        catch( Exception ex )
        {
            CommonMethods.logError( ex, this.getClass().getName(), "addToSOAPBody" );
        }
    }
}
