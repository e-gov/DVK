package dhl.iostructures;

import dvk.core.CommonMethods;

import java.util.Date;
import javax.xml.soap.SOAPBody;

import org.apache.axis.AxisFault;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class sendDocumentsV2RequestType {
    public String dokumendid;
    public String kaust;
    public Date sailitustahtaeg;
    public String edastusID;
    public int fragmentNr;
    public int fragmenteKokku;
    
    public sendDocumentsV2RequestType() {
        dokumendid = "";
        kaust = "";
        sailitustahtaeg = null;
        edastusID = "";
        fragmentNr = 0;
        fragmenteKokku = 0;
    }
    
    public static sendDocumentsV2RequestType getFromSOAPBody( org.apache.axis.MessageContext context ) throws AxisFault {
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody body = msg.getSOAPBody();
            NodeList tmpNodes = null;
            Element el = null;
            NodeList msgNodes = body.getElementsByTagName("sendDocuments");
            if (msgNodes.getLength() > 0) {
                Element msgNode = (Element)msgNodes.item(0);
                NodeList bodyNodes = msgNode.getElementsByTagName("keha");
                if (bodyNodes.getLength() > 0) {
                    Element bodyNode = (Element)bodyNodes.item(0);
                    NodeList docRefNodes = bodyNode.getElementsByTagName("dokumendid");
                    if (docRefNodes.getLength() > 0) {
                        Element docRefNode = (Element)docRefNodes.item(0);
                        sendDocumentsV2RequestType result = new sendDocumentsV2RequestType();
                        result.dokumendid = docRefNode.getAttribute("href");
                        if (result.dokumendid.startsWith("cid:")) {
                            result.dokumendid = result.dokumendid.replaceFirst("cid:","");
                        }
                        tmpNodes = bodyNode.getElementsByTagName("kaust");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element)tmpNodes.item(0);
                            result.kaust = CommonMethods.getNodeText(el);
                        }
                        tmpNodes = bodyNode.getElementsByTagName("sailitustahtaeg");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element)tmpNodes.item(0);
                            String dateString = CommonMethods.getNodeText(el);
                            if ((dateString != null) && !dateString.equalsIgnoreCase("")) {
                                result.sailitustahtaeg = CommonMethods.getDateFromXML(dateString);
                                if (result.sailitustahtaeg == null) {
                                    throw new AxisFault("Dokumendi sailitustahtaeg on esitatud vigaselt!");
                                }
                            }
                        }
                        tmpNodes = bodyNode.getElementsByTagName("edastus_id");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element)tmpNodes.item(0);
                            result.edastusID = CommonMethods.getNodeText(el);
                        }
                        tmpNodes = bodyNode.getElementsByTagName("fragment_nr");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element)tmpNodes.item(0);
                            result.fragmentNr = Integer.parseInt(CommonMethods.getNodeText(el));
                        }
                        tmpNodes = bodyNode.getElementsByTagName("fragmente_kokku");
                        if (tmpNodes.getLength() > 0) {
                            el = (Element)tmpNodes.item(0);
                            result.fragmenteKokku = Integer.parseInt(CommonMethods.getNodeText(el));
                        }
                        return result;
                    }
                }
            }
            return null;
        }
        catch (AxisFault fault) {
            throw fault;
        }
        catch (Exception ex) {
            CommonMethods.logError( ex, "dhl.iostructures.sendDocumentsV2RequestType", "getFromSOAPBody" );
            return null;
        }
    }
}
