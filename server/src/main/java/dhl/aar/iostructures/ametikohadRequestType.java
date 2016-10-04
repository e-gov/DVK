package dhl.aar.iostructures;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

import dvk.core.CommonMethods;

public class ametikohadRequestType {
    public String ametikohadHref;
    
    public ametikohadRequestType() {
        ametikohadHref = "";
    }
    
    public String getBodyContentsAsText() {
        return "<aar:ametikohad><keha><ametikohad href=\"cid:" + ametikohadHref + "\"/></keha></aar:ametikohad>";
    }
    
    public static String createRequestFile() throws IOException {
        FileOutputStream outStream = null;
        OutputStreamWriter outWriter = null;
        BufferedWriter writer = null;
        String resultFile = CommonMethods.createPipelineFile(0);
        try {
            outStream = new FileOutputStream(resultFile, false);
            outWriter = new OutputStreamWriter(outStream, "UTF-8");
            writer = new BufferedWriter(outWriter);
            
            writer.write("<ametikohad>");
            writer.write("</ametikohad>");
        } finally {
            CommonMethods.safeCloseWriter(writer);
            CommonMethods.safeCloseWriter(outWriter);
            CommonMethods.safeCloseStream(outStream);
            outStream = null;
            outWriter = null;
            writer = null;
        }
        return resultFile;
    }
}
