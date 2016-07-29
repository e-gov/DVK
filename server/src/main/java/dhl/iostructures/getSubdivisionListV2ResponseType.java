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

import dhl.users.Allyksus;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;

public class getSubdivisionListV2ResponseType implements SOAPOutputBodyRepresentation {
    public getSubdivisionListV2RequestType paring;
    public String allyksusedHref;
    public String responseFile;
    public String dataMd5Hash;

    public getSubdivisionListV2ResponseType() {
        paring = null;
        allyksusedHref = "";
        responseFile = null;
        dataMd5Hash = "";
    }

    public void addToSOAPBody(org.apache.axis.Message msg, XRoadProtocolHeader xRoadProtocolHeader) {
        try {
            // get SOAP envelope from SOAP message
            org.apache.axis.message.SOAPEnvelope se = msg.getSOAPEnvelope();
            SOAPBody body = se.getBody();

            @SuppressWarnings("rawtypes")
			Iterator items = body.getChildElements();
            if (items.hasNext()) {
                body.removeContents();
            }

            SOAPBodyElement element = body.addBodyElement(se.createName("getSubdivisionListResponse", CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_URI));
            SOAPElement elParing = element.addChildElement(se.createName("paring"));
            SOAPElement elHash = elParing.addChildElement("asutused");
            elHash.addTextNode(this.dataMd5Hash);

            // Sõnumi keha osa
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            SOAPElement elDokument = elKeha.addChildElement(se.createName("allyksused"));
            elDokument.addAttribute(se.createName("href"), "cid:" + this.allyksusedHref);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }

    public void createResponseFile(ArrayList<Allyksus> subdivisionList, String orgCode) throws Exception {
        String xmlFile = CommonMethods.createPipelineFile(0);

        FileOutputStream out = null;
        OutputStreamWriter ow = null;
        BufferedWriter bw = null;
        try {
            out = new FileOutputStream(xmlFile, false);
            ow = new OutputStreamWriter(out, "UTF-8");
            bw = new BufferedWriter(ow);

            if (subdivisionList != null) {
                bw.write("<allyksused>");
                for (Allyksus sub : subdivisionList) {
                    bw.write("<allyksus>");
                    bw.write("<kood>" + String.valueOf(sub.getID()) + "</kood>");
                    bw.write("<nimetus>" + sub.getNimetus() + "</nimetus>");
                    bw.write("<asutuse_kood>" + sub.getAsutusKood() + "</asutuse_kood>");
                    if ((sub.getLyhinimetus() != null) && (sub.getLyhinimetus().length() > 0)) {
                        bw.write("<lyhinimetus>" + sub.getLyhinimetus() + "</lyhinimetus>");
                    }
                    if ((sub.getKsAllyksuseLyhinimetus() != null) && (sub.getKsAllyksuseLyhinimetus().length() > 0)) {
                        bw.write("<ks_allyksuse_lyhinimetus>" + sub.getKsAllyksuseLyhinimetus() + "</ks_allyksuse_lyhinimetus>");
                    }
                    bw.write("</allyksus>");
                }
                bw.write("</allyksused>");
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "createResponseFile");
            throw new AxisFault("Error composing response message: " + " (" + ex.getClass().getName() + ": " + ex.getMessage() + ")");
        } finally {
            CommonMethods.safeCloseWriter(bw);
            CommonMethods.safeCloseWriter(ow);
            CommonMethods.safeCloseStream(out);
            bw = null;
            ow = null;
            out = null;
        }

        this.responseFile = CommonMethods.gzipPackXML(xmlFile, orgCode, "getSubdivisionList");
    }
}
