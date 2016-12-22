package dvk.client.iostructures;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;

import org.apache.axis.AxisFault;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.dhl.service.LoggingService;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.ShortName;

public class GetSendingOptionsV3Body implements SOAPBodyOverride {
    public String kehaHref;
    public String attachmentFileName;

    public boolean vastuvotmataDokumenteOotel;
    public int vahetatudDokumenteVahemalt;
    public int vahetatudDokumenteKuni;
    public ArrayList<String> asutused;
    public ArrayList<ShortName> allyksused;
    public ArrayList<ShortName> ametikohad;

    public GetSendingOptionsV3Body() {
    	this.kehaHref = "";
    	this.attachmentFileName = "";
    	this.asutused = new ArrayList<String>();
    	this.allyksused = new ArrayList<ShortName>();
    	this.ametikohad = new ArrayList<ShortName>();
    	this.vastuvotmataDokumenteOotel = false;
    	this.vahetatudDokumenteVahemalt = -1;
    	this.vahetatudDokumenteKuni = -1;
    }

	public String getBodyContentsAsText() {
		return "<dhl:getSendingOptions " + CommonStructures.NS_DHL_DECLARATION + "><keha href=\"cid:" + kehaHref + "\"/></dhl:getSendingOptions>";
    }

	public String createAttachmentFile() throws Exception {
		String xmlFile = CommonMethods.createPipelineFile(0);

    	FileOutputStream out = null;
        OutputStreamWriter ow = null;
        BufferedWriter bw = null;
        try {
            out = new FileOutputStream(xmlFile, false);
            ow = new OutputStreamWriter(out, "UTF-8");
            bw = new BufferedWriter(ow);

            // Server tahab praegu igal juhul oma XML päise lisada
            //bw.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>");

            bw.write("<keha>");

            if (vastuvotmataDokumenteOotel) {
                bw.write("<vastuvotmata_dokumente_ootel>true</vastuvotmata_dokumente_ootel>");
            }
            if (vahetatudDokumenteVahemalt >= 0) {
            	bw.write("<vahetatud_dokumente_vahemalt>"+ String.valueOf(vahetatudDokumenteVahemalt) +"</vahetatud_dokumente_vahemalt>");
            }
            if (vahetatudDokumenteKuni >= 0) {
            	bw.write("<vahetatud_dokumente_kuni>"+ String.valueOf(vahetatudDokumenteKuni) +"</vahetatud_dokumente_kuni>");
            }
            if ((asutused != null) && (asutused.size() > 0)) {
            	bw.write("<asutused>");
                for (int i = 0; i < asutused.size(); ++i) {
                	bw.write("<asutus>" + asutused.get(i) + "</asutus>");
                }
                bw.write("</asutused>");
            }
            if ((allyksused != null) && (allyksused.size() > 0)) {
            	bw.write("<allyksused>");
                for (int i = 0; i < allyksused.size(); ++i) {
                	bw.write("<allyksus>");
                	bw.write("<asutuse_kood>" + allyksused.get(i).getOrgCode() + "</asutuse_kood>");
                	bw.write("<lyhinimetus>" + allyksused.get(i).getShortName() + "</lyhinimetus>");
                	bw.write("</allyksus>");
                }
                bw.write("</allyksused>");
            }
            if ((ametikohad != null) && (ametikohad.size() > 0)) {
            	bw.write("<ametikohad>");
                for (int i = 0; i < ametikohad.size(); ++i) {
                	bw.write("<ametikoht>");
                	bw.write("<asutuse_kood>" + ametikohad.get(i).getOrgCode() + "</asutuse_kood>");
                	bw.write("<lyhinimetus>" + ametikohad.get(i).getShortName() + "</lyhinimetus>");
                	bw.write("</ametikoht>");
                }
                bw.write("</ametikohad>");
            }

            bw.write("</keha>");
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " createAttachmentFile");
            LoggingService.logError(errorLog);
            throw new AxisFault( "Error composing response message: " +" ("+ ex.getClass().getName() +": "+ ex.getMessage() +")" );
        } finally {
            CommonMethods.safeCloseWriter(bw);
            CommonMethods.safeCloseWriter(ow);
            CommonMethods.safeCloseStream(out);
            bw = null;
            ow = null;
            out = null;
        }

        this.attachmentFileName = CommonMethods.gzipPackXML(xmlFile, "", "getSendingOptions");
		return this.attachmentFileName;
	}
}
