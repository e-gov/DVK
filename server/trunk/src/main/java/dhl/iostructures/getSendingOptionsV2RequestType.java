package dhl.iostructures;

import dvk.core.CommonMethods;
import javax.xml.soap.SOAPBody;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class getSendingOptionsV2RequestType {
    public String[] asutused;
    public String vahetatudDokumenteVahemaltStr;
    public String vahetatudDokumenteKuniStr;
    public String vastuvotmataDokumenteOotelStr;
    public int vahetatudDokumenteVahemalt;
    public int vahetatudDokumenteKuni;
    public boolean vastuvotmataDokumenteOotel;

    public getSendingOptionsV2RequestType() {
        asutused = new String[] { };
        vahetatudDokumenteVahemalt = -1;
        vahetatudDokumenteKuni = -1;
        vastuvotmataDokumenteOotel = false;
    }

    public static getSendingOptionsV2RequestType getFromSOAPBody(org.apache.axis.MessageContext context) {
        org.apache.axis.Message msg = null;
        SOAPBody body = null;
        NodeList nodes = null;
        Element el = null;
        Element el1 = null;
        getSendingOptionsV2RequestType result = new getSendingOptionsV2RequestType();

        try {
            msg = context.getRequestMessage();
            body = msg.getSOAPBody();
            nodes = body.getElementsByTagName("getSendingOptions");
            if (nodes.getLength() > 0) {
                el = (Element)nodes.item(0);
                nodes = el.getElementsByTagName("keha");
                if (nodes.getLength() > 0) {
                    el = (Element)nodes.item(0);

                    // Asutuste nimekiri
                    nodes = el.getElementsByTagName("asutused");
                    if (nodes.getLength() > 0) {
                        el1 = (Element)nodes.item(0);
                        nodes = el1.getElementsByTagName("asutus");
                        if (nodes.getLength() > 0) {
                            result.asutused = new String[nodes.getLength()];
                            for (int i = 0; i < nodes.getLength(); ++i) {
                                result.asutused[i] = CommonMethods.getNodeText(nodes.item(i));
                            }
                        }
                    }

                    // Ainult vastuvõtmist ootavate dokumentidega asutused
                    nodes = el.getElementsByTagName("vastuvotmata_dokumente_ootel");
                    if (nodes.getLength() > 0) {
                        el1 = (Element)nodes.item(0);
                        result.vastuvotmataDokumenteOotelStr = CommonMethods.getNodeText(el1);
                        if ((!result.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("")) && !result.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("0") && !result.vastuvotmataDokumenteOotelStr.equalsIgnoreCase("false")) {
                            result.vastuvotmataDokumenteOotel = true;
                        }
                    }

                    // Ainult asutused, kes on vahetanud vähemalt N dokumenti
                    nodes = el.getElementsByTagName("vahetatud_dokumente_vahemalt");
                    if (nodes.getLength() > 0) {
                        el1 = (Element)nodes.item(0);
                        result.vahetatudDokumenteVahemaltStr = CommonMethods.getNodeText(el1);
                        result.vahetatudDokumenteVahemalt = Integer.parseInt(result.vahetatudDokumenteVahemaltStr);
                    }

                    // Ainult asutused, kes on vahetanud kuni N dokumenti
                    nodes = el.getElementsByTagName("vahetatud_dokumente_kuni");
                    if (nodes.getLength() > 0) {
                        el1 = (Element)nodes.item(0);
                        result.vahetatudDokumenteKuniStr = CommonMethods.getNodeText(el1);
                        result.vahetatudDokumenteKuni = Integer.parseInt(result.vahetatudDokumenteKuniStr);
                    }

                    return result;
                }
            }
            return null;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.getSendingOptionsV2RequestType", "getFromSOAPBody");
            return null;
        }
    }
}
