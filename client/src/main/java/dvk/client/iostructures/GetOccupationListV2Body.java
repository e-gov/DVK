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

public class GetOccupationListV2Body implements SOAPBodyOverride {
    public String asutusedHref;
    public String attachmentFileName;
    public ArrayList<String> asutused;
    
    public GetOccupationListV2Body() {
    	this.asutusedHref = "";
    	this.attachmentFileName = "";
    	this.asutused = new ArrayList<String>();
    }
	
	public String getBodyContentsAsText() {
		return "<dhl:getOccupationList " + CommonStructures.NS_DHL_DECLARATION + "><keha><asutused href=\"cid:" + asutusedHref + "\"/></keha></dhl:getOccupationList>";
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

            if (asutused != null) {
            	bw.write("<asutused>");
                for (int i = 0; i < asutused.size(); ++i) {
                	bw.write("<asutus>" + asutused.get(i) + "</asutus>");
                }
                bw.write("</asutused>");
            }
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
        
        this.attachmentFileName = CommonMethods.gzipPackXML(xmlFile, "", "getOccupationList");
		return this.attachmentFileName;
	}
}
