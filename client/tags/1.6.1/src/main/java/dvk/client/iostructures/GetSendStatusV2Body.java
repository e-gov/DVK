package dvk.client.iostructures;

public class GetSendStatusV2Body implements SOAPBodyOverride {
    public String dokumendidHref;
    public boolean staatuseAjalugu;

    public GetSendStatusV2Body() {
    	dokumendidHref = "";
    	staatuseAjalugu = false;
    }

    public String getBodyContentsAsText() {
        String result = "<dhl:getSendStatus><keha><dokumendid href=\"cid:" + dokumendidHref + "\"/>";
        if (staatuseAjalugu) { 
        	result += "<staatuse_ajalugu>true</staatuse_ajalugu>";
        }
        result += "</keha></dhl:getSendStatus>";
    	return result;
    }
}