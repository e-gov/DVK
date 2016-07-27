package dhl.iostructures;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPException;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dhl.exceptions.RequestProcessingException;
import dvk.core.CommonMethods;

public class getSubdivisionListRequestType {
    static Logger logger = Logger.getLogger(getSubdivisionListRequestType.class.getName());
    public String[] asutused;

    public getSubdivisionListRequestType() {
        asutused = new String[]{};
    }

    public static getSubdivisionListRequestType getFromSOAPBody(org.apache.axis.MessageContext context) throws RequestProcessingException {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList msgNodes = body.getElementsByTagName("getSubdivisionList");
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element) msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element) bodyNodes.item(0);
                    NodeList orgNodes = bodyNode.getElementsByTagName("asutus");
                    if (orgNodes.getLength() > 0) {
                        getSubdivisionListRequestType result = new getSubdivisionListRequestType();
                        result.asutused = new String[orgNodes.getLength()];
                        for (int i = 0; i < orgNodes.getLength(); ++i) {
                            result.asutused[i] = CommonMethods.getNodeText(orgNodes.item(i));
                        }
                        return result;
                    } else {
                        throw new RequestProcessingException("Viga päringu keha töötlemisel. Puudub kohustuslik element /getSubdivisionList/keha/asutus.");
                    }
                } else {
                    throw new RequestProcessingException("Viga päringu keha töötlemisel. Puudub kohustuslik element /getSubdivisionList/keha.");
                }
            } else {
                throw new RequestProcessingException("Viga päringu keha töötlemisel. Puudub kohustuslik element /getSubdivisionList.");
            }
        } catch (SOAPException ex) {
            logger.error(ex.getMessage(), ex);
            throw new RequestProcessingException("Viga päringu keha töötlemisel. Sõnumi SOAP keha laadimine ebaõnnestus.");
        }
    }
}
