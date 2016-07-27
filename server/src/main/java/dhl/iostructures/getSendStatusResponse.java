package dhl.iostructures;

import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.util.ArrayList;

import dvk.core.CommonMethods;


public class getSendStatusResponse {
    public int dhl_id;
    public ArrayList<edastus> edastus;
    public String olek;

    public getSendStatusResponse() {
        clear();
    }

    public void clear() {
        dhl_id = 0;
        edastus = new ArrayList<edastus>();
        olek = "";
    }

    public void appendObjectXML(OutputStreamWriter xmlWriter, Connection conn) {
        try {
            // Item element start
            xmlWriter.write("<item>");

            // Dokumendi ID
            xmlWriter.write("<dhl_id>" + String.valueOf(dhl_id) + "</dhl_id>");

            // Edastus
            for (edastus ed : edastus) {
                ed.appendObjectXML(xmlWriter, conn);
            }

            // Olek
            xmlWriter.write("<olek>" + olek + "</olek>");

            // Item element end
            xmlWriter.write("</item>");
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "appendObjectXML");
        }
    }
}
