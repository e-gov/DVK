package dvk.client.iostructures;

import java.io.BufferedWriter;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Date;

import org.apache.log4j.Logger;

import dvk.client.businesslayer.DhlMessage;
import dvk.core.CommonMethods;

public class MarkDocumentsReceivedBody implements SOAPBodyOverride {

	private static Logger logger = Logger.getLogger(MarkDocumentsReceivedBody.class);

    public String dokumendid;
    public String kaust;
    public String edastusID;
    public int allyksuseId;
    public int ametikohaId;

    public MarkDocumentsReceivedBody() {
        dokumendid = "";
        kaust = "";
        edastusID = "";
        allyksuseId = 0;
        ametikohaId = 0;
    }

    public String getBodyContentsAsText() {
        String result = "<dhl:markDocumentsReceived><keha><dokumendid href=\"cid:" + dokumendid + "\"/><kaust>" + kaust + "</kaust>";
        if ((edastusID != null) && !edastusID.equalsIgnoreCase("")) {
            result += "<edastus_id>"+ edastusID +"</edastus_id>";
        }
        if (allyksuseId > 0) {
        	result += "<allyksus>"+ String.valueOf(allyksuseId) +"</allyksus>";
        }
        if (ametikohaId > 0) {
        	result += "<ametikoht>"+ String.valueOf(ametikohaId) +"</ametikoht>";
        }
        result += "</keha></dhl:markDocumentsReceived>";
        return result;
    }

    public static String createResponseFile(ArrayList<Integer> documents, int statusID, dvk.core.Fault clientFault, String metaXML, int requestVersion, Date statusDate) throws Exception {
    	String attachmentFile = "";
    	FileOutputStream outStream = null;
        OutputStreamWriter outWriter = null;
        BufferedWriter writer = null;

        logger.debug("Creating responseFile for MarkDocumentsReceivedBody.");

        try {
            // Väljundfail
            attachmentFile = CommonMethods.createPipelineFile(0);
            outStream = new FileOutputStream(attachmentFile, false);
            outWriter = new OutputStreamWriter(outStream, "UTF-8");
            writer = new BufferedWriter(outWriter);

            if (requestVersion == 2) {
                for (int i = 0; i < documents.size(); i++) {
                    writer.write("<item>");
                    writer.write("<dhl_id>" + String.valueOf(documents.get(i)) + "</dhl_id>");
                    writer.write("<vastuvotja_staatus_id>" + String.valueOf(statusID) + "</vastuvotja_staatus_id>");
                    if (clientFault != null) {
                        writer.write(clientFault.toXML());
                    }
                    writer.write("<metaxml>" + metaXML + "</metaxml>");
    		        if (statusDate != null) {
    		        	writer.write("<staatuse_muutmise_aeg>" + CommonMethods.getDateISO8601(statusDate) + "</staatuse_muutmise_aeg>");
    		        }
                    writer.write("</item>");
                }
            } else {
                for (int i = 0; i < documents.size(); i++) {
                    writer.write("<dhl_id>" + String.valueOf(documents.get(i)) + "</dhl_id>");
                }
            }
            CommonMethods.safeCloseWriter(writer);
            CommonMethods.safeCloseWriter(outWriter);
            CommonMethods.safeCloseStream(outStream);
        } finally {
            CommonMethods.safeCloseWriter(writer);
            CommonMethods.safeCloseWriter(outWriter);
            CommonMethods.safeCloseStream(outStream);
        }
        return attachmentFile;
    }

    public static String createResponseFile(ArrayList<DhlMessage> documents, int requestVersion, Date statusDate) throws Exception {
    	String attachmentFile = "";
    	FileOutputStream outStream = null;
        OutputStreamWriter outWriter = null;
        BufferedWriter writer = null;

        try {
            // Väljundfail
            attachmentFile = CommonMethods.createPipelineFile(0);
            outStream = new FileOutputStream(attachmentFile, false);
            outWriter = new OutputStreamWriter(outStream, "UTF-8");
            writer = new BufferedWriter(outWriter);

            if (requestVersion == 2) {
                for (int i = 0; i < documents.size(); i++) {
                    DhlMessage tmpMessage = documents.get(i);
                    writer.write("<item>");
                    writer.write("<dhl_id>" + String.valueOf(tmpMessage.getDhlID()) + "</dhl_id>");
                    writer.write("<vastuvotja_staatus_id>" + String.valueOf(tmpMessage.getRecipientStatusID()) + "</vastuvotja_staatus_id>");
                    if (tmpMessage.getFault() != null) {
                        writer.write(tmpMessage.getFault().toXML());
                    }
                    if (tmpMessage.getMetaXML() != null) {
                        writer.write("<metaxml>" + tmpMessage.getMetaXML() + "</metaxml>");
                    }
    		        if (statusDate != null) {
    		        	writer.write("<staatuse_muutmise_aeg>" + CommonMethods.getDateISO8601(statusDate) + "</staatuse_muutmise_aeg>");
    		        }
                    writer.write("</item>");
                }
            } else {
                for (int i = 0; i < documents.size(); i++) {
                	DhlMessage tmpMessage = documents.get(i);
                    writer.write("<dhl_id>" + String.valueOf(tmpMessage.getDhlID()) + "</dhl_id>");
                }
            }
            CommonMethods.safeCloseWriter(writer);
            CommonMethods.safeCloseWriter(outWriter);
            CommonMethods.safeCloseStream(outStream);
        } finally {
            CommonMethods.safeCloseWriter(writer);
            CommonMethods.safeCloseWriter(outWriter);
            CommonMethods.safeCloseStream(outStream);
        }
        return attachmentFile;
    }
}
