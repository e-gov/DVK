package dvk.client.iostructures;

public class GetSendStatusBody implements SOAPBodyOverride {
    public String keha;

    public GetSendStatusBody() {
        keha = "";
    }

    public String getBodyContentsAsText() {
        return "<dhl:getSendStatus><keha href=\"cid:" + keha + "\"/></dhl:getSendStatus>";
    }
}
