package dvk.client.iostructures;

import dvk.core.CommonStructures;

public class GetSendStatusBody implements SOAPBodyOverride {
    public String keha;

    public GetSendStatusBody() {
        keha = "";
    }

    public String getBodyContentsAsText() {
        return "<dhl:getSendStatus " + CommonStructures.NS_DHL_DECLARATION + "><keha href=\"cid:" + keha + "\"/></dhl:getSendStatus>";
    }
}
