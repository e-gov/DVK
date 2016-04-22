package dhl.aar.iostructures;

import dvk.core.CommonMethods;
import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;

public class isikudRequestType {
    public String isikudHref;
    
    public isikudRequestType() {
        isikudHref = "";
    }
    
    public String getBodyContentsAsText() {
        return "<aar:isikud><keha><isikud href=\"cid:" + isikudHref + "\"/></keha></aar:isikud>";
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
            
            writer.write("<isikud>");
            writer.write("</isikud>");
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
