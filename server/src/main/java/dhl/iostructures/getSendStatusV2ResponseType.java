package dhl.iostructures;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Iterator;

import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPException;

import org.apache.axis.AxisFault;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dhl.DocumentStatusHistory;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class getSendStatusV2ResponseType implements SOAPOutputBodyRepresentation {
    public Element paring;
    public String dataMd5Hash;
    public String kehaHref;

    public getSendStatusV2ResponseType() {
        paring = null;
        dataMd5Hash = "";
        kehaHref = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) throws AxisFault, SOAPException {
        // get SOAP envelope from SOAP message
        org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
        SOAPBody body = se.getBody();

        se.addNamespaceDeclaration(xRoadProtocolHeader.getProtocolVersion().getNamespacePrefix(), xRoadProtocolHeader.getProtocolVersion().getNamespaceURI());

        @SuppressWarnings("rawtypes")
		Iterator items = body.getChildElements();
        if (items.hasNext()) {
            body.removeContents();
        }

        SOAPBodyElement element = body.addBodyElement(se.createName(getSendStatusResponseType.DEFAULT_RESPONSE_ELEMENT_NAME));
        
        if (xRoadProtocolHeader.getProtocolVersion().equals(XRoadProtocolVersion.V2_0)) {
        	se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);
        	
	        SOAPElement elParing = element.addChildElement(se.createName("paring"));
	        if (paring != null) {
	            NodeList nl = paring.getChildNodes();
	            for (int i = 0; i < nl.getLength(); ++i) {
	                Node addedNode = elParing.appendChild(nl.item(i));
	                if ((addedNode != null) && (addedNode.getLocalName().equalsIgnoreCase("dokumendid")) && (addedNode.getNodeType() == Node.ELEMENT_NODE)) {
	                    ((Element) addedNode).removeAttribute("href");
	                    ((SOAPElement) addedNode).addTextNode(dataMd5Hash);
	                }
	            }
	        }
        }

        SOAPElement elKeha = element.addChildElement(se.createName("keha"));
        elKeha.addAttribute(se.createName("href"), "cid:" + kehaHref);
    }

    public static void appendObjectXML(int dhlId, String guid, ArrayList<edastus> edastusList, ArrayList<DocumentStatusHistory> historyList, String olek, OutputStreamWriter xmlWriter, Connection conn) throws IOException {
        // Item element start
        xmlWriter.write("<item>");

        // Dokumendi ID
        xmlWriter.write("<dhl_id>" + String.valueOf(dhlId) + "</dhl_id>");

        // Dokumendi GUID
        if (guid != null) {
            xmlWriter.write("<dokument_guid>" + guid + "</dokument_guid>");
        }

        // Edastus
        for (edastus ed : edastusList) {
            ed.appendObjectXML(xmlWriter, conn);
        }

        // Ajalugu
        if ((historyList != null) && (historyList.size() > 0)) {
            xmlWriter.write("<staatuse_ajalugu>");
            for (DocumentStatusHistory history : historyList) {
                history.appendObjectXML(xmlWriter, conn);
            }
            xmlWriter.write("</staatuse_ajalugu>");
        }

        // Olek
        xmlWriter.write("<olek>" + olek + "</olek>");

        // Item element end
        xmlWriter.write("</item>");
    }
}
