package dhl.iostructures;

import java.util.Date;

import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.Fault;

public class markDocumentsReceivedV2Item {
    public int documentID;
    public int recipientStatusID;
    public Fault recipientFault;
    public String metaXML;
    public Date staatuseMuutmiseAeg;
    public String guid;

    public markDocumentsReceivedV2Item() {
        this.documentID = 0;
        this.recipientStatusID = 0;
        this.recipientFault = null;
        this.metaXML = "";
        this.staatuseMuutmiseAeg = null;
    }

    public static markDocumentsReceivedV2Item getFromXML(Element root) {
        markDocumentsReceivedV2Item result = new markDocumentsReceivedV2Item();
        Element e = null;
        try {
            // Dokumendi DVK ID
            NodeList nodes = root.getElementsByTagName("dhl_id");
            if ((nodes != null) && (nodes.getLength() > 0)) {
                e = (Element) nodes.item(0);
                result.documentID = Integer.parseInt(CommonMethods.getNodeText(e));
            }

            // Dokumendi GUID
            nodes = root.getElementsByTagName("dokument_guid");
            if ((nodes != null) && (nodes.getLength() > 0)) {
                e = (Element) nodes.item(0);
                result.guid = CommonMethods.getNodeText(e);
            }

            // Vastuvõtja staatuse ID
            // (vanas versioonis ja kliendis toimis valesti ja jätame ka praegu sisse, et vanad asjad kohe katki ei läheks)
            // TODO: Eemaldada see koodilõik
            nodes = root.getElementsByTagName("staatus_id");
            if ((nodes != null) && (nodes.getLength() > 0)) {
                e = (Element) nodes.item(0);
                result.recipientStatusID = Integer.parseInt(CommonMethods.getNodeText(e));
            }

            // Vastuvõtja staatuse ID
            nodes = root.getElementsByTagName("vastuvotja_staatus_id");
            if ((nodes != null) && (nodes.getLength() > 0)) {
                e = (Element) nodes.item(0);
                result.recipientStatusID = Integer.parseInt(CommonMethods.getNodeText(e));
            }

            // Vastuvõtja edastatud viga
            nodes = root.getElementsByTagName("fault");
            if ((nodes != null) && (nodes.getLength() > 0)) {
                e = (Element) nodes.item(0);
                result.recipientFault = Fault.getFromXML(e);
            }

            // Staatuse muutmise aeg
            NodeList statusDateNodes = root.getElementsByTagName("staatuse_muutmise_aeg");
            if (statusDateNodes.getLength() > 0) {
                String tmp = CommonMethods.getNodeText(statusDateNodes.item(0));
                if ((tmp != null) && (tmp.length() > 0)) {
                    result.staatuseMuutmiseAeg = CommonMethods.getDateFromXML(tmp);
                } else {
                    result.staatuseMuutmiseAeg = new Date();
                }
            }
            if (result.staatuseMuutmiseAeg == null) {
                result.staatuseMuutmiseAeg = new Date();
            }

            // Mistahes muud metaandmed
            nodes = root.getElementsByTagName("metaxml");
            if ((nodes != null) && (nodes.getLength() > 0)) {
                e = (Element) nodes.item(0);
                String meta = new String(CommonMethods.xmlElementToBinary(e), "UTF-8");
                if (meta != null) {
                    if (meta.equalsIgnoreCase("<metaxml/>") || meta.equalsIgnoreCase("<metaxml />")) {
                        meta = "";
                    } else if (meta.startsWith("<metaxml>") && meta.endsWith("</metaxml>")) {
                        meta = meta.substring(9, meta.lastIndexOf("</metaxml>"));
                    }
                    result.metaXML = meta;
                }
            }

            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.markDocumentsReceivedV2Item", "getFromXML");
            return null;
        }
    }
}
