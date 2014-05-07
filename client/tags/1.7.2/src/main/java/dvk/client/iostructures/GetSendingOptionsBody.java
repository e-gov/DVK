package dvk.client.iostructures;

import dvk.client.iostructures.SOAPBodyOverride;
import java.util.ArrayList;

public class GetSendingOptionsBody implements SOAPBodyOverride {
    public ArrayList<String> keha;

    public GetSendingOptionsBody() {
        keha = new ArrayList<String>();
    }

    public String getBodyContentsAsText() {
        StringBuilder sb = new StringBuilder();
        sb.append("<dhl:getSendingOptions><keha>");
        if (keha != null) {
	        for (int i = 0; i < keha.size(); ++i) {
	            sb.append("<asutus>" + keha.get(i) + "</asutus>");
	        }
        }
        sb.append("</keha></dhl:getSendingOptions>");
        return sb.toString();
    }
}