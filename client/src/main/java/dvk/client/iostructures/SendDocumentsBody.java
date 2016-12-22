package dvk.client.iostructures;

import dvk.core.CommonStructures;

public class SendDocumentsBody implements SOAPBodyOverride {
    public String dokumendid;
    public String kaust;

    public SendDocumentsBody() {
        dokumendid = "";
        kaust = "";
    }

    public String getBodyContentsAsText() {
        return "<dhl:sendDocuments " + CommonStructures.NS_DHL_DECLARATION + "><keha><dokumendid href=\"cid:" + dokumendid + "\"/><kaust>" + ((kaust == null) ? "" : kaust) + "</kaust></keha></dhl:sendDocuments>";
    }
}
