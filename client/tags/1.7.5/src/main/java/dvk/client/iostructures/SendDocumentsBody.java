package dvk.client.iostructures;

public class SendDocumentsBody implements SOAPBodyOverride {
    public String dokumendid;
    public String kaust;

    public SendDocumentsBody() {
        dokumendid = "";
        kaust = "";
    }

    public String getBodyContentsAsText() {
        return "<dhl:sendDocuments><keha><dokumendid href=\"cid:" + dokumendid + "\"/><kaust>" + ((kaust == null) ? "" : kaust) + "</kaust></keha></dhl:sendDocuments>";
    }
}
