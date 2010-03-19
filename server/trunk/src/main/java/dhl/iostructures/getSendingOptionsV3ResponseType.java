package dhl.iostructures;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dhl.iostructures.getSendingOptionsV3RequestType;
import dhl.users.Allyksus;
import dhl.users.Ametikoht;
import dhl.users.Asutus;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Iterator;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPBodyElement;
import javax.xml.soap.SOAPElement;

import org.apache.axis.AxisFault;

public class getSendingOptionsV3ResponseType implements SOAPOutputBodyRepresentation {
    public getSendingOptionsV3RequestType paring;
    public String asutusedHref;
    public String responseFile;
    public String dataMd5Hash;
    
    public getSendingOptionsV3ResponseType() {
        paring = null;
        asutusedHref = "";
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

            SOAPBodyElement element = body.addBodyElement(se.createName("getSendingOptionsResponse", CommonStructures.NS_DHL_PREFIX, CommonStructures.NS_DHL_URI));
            SOAPElement elParing = element.addChildElement(se.createName("paring"));
            SOAPElement elHash = elParing.addChildElement("parameetrid");
            elHash.addTextNode(this.dataMd5Hash);
            
            // Sõnumi keha osa
            SOAPElement elKeha = element.addChildElement(se.createName("keha"));
            SOAPElement elDokument = elKeha.addChildElement(se.createName("asutused"));
            elDokument.addAttribute(se.createName("href"), "cid:" + asutusedHref);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "addToSOAPBody");
        }
    }
    
    public void createResponseFile(
    	ArrayList<Asutus> organizationList,
    	ArrayList<Allyksus> subdivisionList,
    	ArrayList<Ametikoht> occupationList,
    	String orgCode) throws Exception {
    
    	String xmlFile = CommonMethods.createPipelineFile(0);
        
    	FileOutputStream out = null;
        OutputStreamWriter ow = null;
        BufferedWriter bw = null;
        try {
            out = new FileOutputStream(xmlFile, false);
            ow = new OutputStreamWriter(out, "UTF-8");
            bw = new BufferedWriter(ow);

            //bw.write("<?xml version=\"1.0\" encoding=\"utf-8\"?>");
            bw.write("<asutused>");

            if (organizationList != null) {
            	bw.write("<asutused>");
            	for (Asutus org : organizationList) {
            		bw.write("<asutus>");
            		bw.write("<regnr>" + org.getRegistrikood() + "</regnr>");
            		bw.write("<nimi>" + org.getNimetus() + "</nimi>");
            		bw.write("<saatmine>");
                    if (org.getDvkSaatmine()) {
                    	bw.write("<saatmisviis>" + CommonStructures.SENDING_DHL + "</saatmisviis>");
                    }
                    if (org.getDvkOtseSaatmine()) {
                    	bw.write("<saatmisviis>" + CommonStructures.SENDING_DHL_DIRECT + "</saatmisviis>");
                    }
            		bw.write("</saatmine>");
            		if ((org.getKsAsutuseKood() != null) && (org.getKsAsutuseKood().length() > 0)) {
            			bw.write("<ks_asutuse_regnr>" + org.getKsAsutuseKood() + "</ks_asutuse_regnr>");
            		}
                    bw.write("</asutus>");
                }
            	bw.write("</asutused>");
            }
            
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
            
            bw.write("</asutused>");
        }
        catch (Exception ex) {
            CommonMethods.logError( ex, this.getClass().getName(), "createResponseFile" );
            throw new AxisFault( "Error composing response message: " +" ("+ ex.getClass().getName() +": "+ ex.getMessage() +")" );
        }
        finally {
            CommonMethods.safeCloseWriter(bw);
            CommonMethods.safeCloseWriter(ow);
            CommonMethods.safeCloseStream(out);
            bw = null;
            ow = null;
            out = null;
        }
        
        this.responseFile = CommonMethods.gzipPackXML(xmlFile, orgCode, "getSendingOptions");
    }
}
