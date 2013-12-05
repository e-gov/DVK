package dhl.iostructures;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Iterator;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;
import dhl.users.Ametikoht;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

public class getOccupationListV2ResponseType implements SOAPOutputBodyRepresentation {
    static Logger logger = Logger.getLogger(getOccupationListV2ResponseType.class.getName());
    public getOccupationListV2RequestType paring;
    public String ametikohadHref;
    public String responseFile;
    public String dataMd5Hash;

    public getOccupationListV2ResponseType() {
        paring = null;
        ametikohadHref = "";
        responseFile = null;
        dataMd5Hash = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("getOccupationListResponse", CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_URI));
            SOAPElement elParing = element.addChildElement(se.createName("paring"));
            SOAPElement elHash = elParing.addChildElement("asutused");
            elHash.addTextNode(this.dataMd5Hash);

            // Sõnumi keha osa
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            SOAPElement elDokument = elKeha.addChildElement(se.createName("ametikohad"));
            elDokument.addAttribute(se.createName("href"), "cid:" + this.ametikohadHref);
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
        }
    }

    public void createResponseFile(ArrayList<Ametikoht> occupationList, String orgCode) throws Exception {
        String xmlFile = CommonMethods.createPipelineFile(0);

        FileOutputStream out = null;
        OutputStreamWriter ow = null;
        BufferedWriter bw = null;
        try {
            out = new FileOutputStream(xmlFile, false);
            ow = new OutputStreamWriter(out, "UTF-8");
            bw = new BufferedWriter(ow);

            if (occupationList != null) {
                bw.write("<ametikohad>");
                for (Ametikoht occupation : occupationList) {
                    bw.write("<ametikoht>");
                    bw.write("<kood>" + String.valueOf(occupation.getID()) + "</kood>");
                    bw.write("<nimetus>" + occupation.getNimetus() + "</nimetus>");
                    bw.write("<asutuse_kood>" + occupation.getAsutusKood() + "</asutuse_kood>");
                    if ((occupation.getLyhinimetus() != null) && (occupation.getLyhinimetus().length() > 0)) {
                        bw.write("<lyhinimetus>" + occupation.getLyhinimetus() + "</lyhinimetus>");
                    }
                    if ((occupation.getAllyksuseLyhinimetus() != null) && (occupation.getAllyksuseLyhinimetus().length() > 0)) {
                        bw.write("<ks_allyksuse_lyhinimetus>" + occupation.getAllyksuseLyhinimetus() + "</ks_allyksuse_lyhinimetus>");
                    }
                    bw.write("</ametikoht>");
                }
                bw.write("</ametikohad>");
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            throw new AxisFault("Error composing response message: " + " (" + ex.getClass().getName() + ": " + ex.getMessage() + ")");
        } finally {
            CommonMethods.safeCloseWriter(bw);
            CommonMethods.safeCloseWriter(ow);
            CommonMethods.safeCloseStream(out);
            bw = null;
            ow = null;
            out = null;
        }

        this.responseFile = CommonMethods.gzipPackXML(xmlFile, orgCode, "getOccupationList");
    }
}
