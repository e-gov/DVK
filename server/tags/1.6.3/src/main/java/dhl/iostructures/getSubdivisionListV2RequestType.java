package dhl.iostructures;

import java.io.File;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPException;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dhl.exceptions.RequestProcessingException;
import dvk.core.CommonMethods;

public class getSubdivisionListV2RequestType {
	static Logger logger = Logger.getLogger(getSubdivisionListV2RequestType.class.getName());
	public String asutusedHref;
    public String[] asutused;

    public getSubdivisionListV2RequestType() {
        asutusedHref = "";
        asutused = new String[] {};
    }

    public static getSubdivisionListV2RequestType getFromSOAPBody(
        org.apache.axis.MessageContext context) throws RequestProcessingException {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList msgNodes = body.getElementsByTagName("getSubdivisionList");
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element) msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element) bodyNodes.item(0);
                    NodeList docRefNodes = bodyNode.getElementsByTagName("asutused");
                    if (docRefNodes.getLength() > 0) {
                        Element docRefNode = (Element) docRefNodes.item(0);
                        getSubdivisionListV2RequestType result = new getSubdivisionListV2RequestType();
                        result.asutusedHref = docRefNode.getAttribute("href");
                        if (result.asutusedHref.startsWith("cid:")) {
                            result.asutusedHref = result.asutusedHref.replaceFirst("cid:", "");
                        }
                        return result;
                    } else {
                    	throw new RequestProcessingException("Viga päringu keha töötlemisel. Puudub kohustuslik element /getSubdivisionList/keha/asutused.");
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

    public void loadParametersFromXML(String xmlFile) {
    	if ((xmlFile != null) && (xmlFile.length() > 0) && (new File(xmlFile)).exists()) {
    		Document xmlDoc = CommonMethods.xmlDocumentFromFile(xmlFile, true);
            NodeList nodes = xmlDoc.getElementsByTagName("asutused");
            if (nodes.getLength() > 0) {
                Element el1 = (Element) nodes.item(0);
                nodes = el1.getElementsByTagName("asutus");
                if (nodes.getLength() > 0) {
                    this.asutused = new String[nodes.getLength()];
                    for (int i = 0; i < nodes.getLength(); ++i) {
                        this.asutused[i] = CommonMethods.getNodeText(nodes.item(i));
                    }
                }
            }
    	}
    }
}
