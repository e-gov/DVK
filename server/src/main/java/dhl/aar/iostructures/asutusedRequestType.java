package dhl.aar.iostructures;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.util.ArrayList;

import dvk.core.CommonMethods;

public class asutusedRequestType {
    public String asutusedHref;

    public asutusedRequestType() {
        asutusedHref = "";
    }

    public String getBodyContentsAsText() {
        return "<aar:asutused><keha><asutused href=\"cid:" + asutusedHref + "\"/></keha></aar:asutused>";
    }

    public static String createRequestFile(ArrayList<String> orgCodes, ArrayList<Integer> orgIDs, boolean noChildObjects) throws IOException {
        FileOutputStream outStream = null;
        OutputStreamWriter outWriter = null;
        BufferedWriter writer = null;
        String resultFile = CommonMethods.createPipelineFile(0);
        try {
            outStream = new FileOutputStream(resultFile, false);
            outWriter = new OutputStreamWriter(outStream, "UTF-8");
            writer = new BufferedWriter(outWriter);

            writer.write("<asutused>");
            if (orgCodes != null) {
                for (int i = 0; i < orgCodes.size(); ++i) {
                    writer.write("<kood>" + orgCodes.get(i) + "</kood>");
                }
            }
            if (orgIDs != null) {
                for (int i = 0; i < orgIDs.size(); ++i) {
                    writer.write("<id>" + String.valueOf(orgIDs.get(i)) + "</id>");
                }
            }
            if (noChildObjects) {
                writer.write("<alamobjektideta>true</alamobjektideta>");
            }
            writer.write("</asutused>");
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
