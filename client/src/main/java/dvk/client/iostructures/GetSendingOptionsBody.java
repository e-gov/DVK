package dvk.client.iostructures;

import java.util.ArrayList;

import dvk.core.CommonStructures;

public class GetSendingOptionsBody implements SOAPBodyOverride {
    public ArrayList<String> keha;

    public GetSendingOptionsBody() {
        keha = new ArrayList<String>();
    }

    public String getBodyContentsAsText() {
        StringBuilder sb = new StringBuilder();
        sb.append("<dhl:getSendingOptions " + CommonStructures.NS_DHL_DECLARATION + "><keha>");
        if (keha != null) {
	        for (int i = 0; i < keha.size(); ++i) {
	            sb.append("<asutus>" + keha.get(i) + "</asutus>");
	        }
        }
        sb.append("</keha></dhl:getSendingOptions>");
        return sb.toString();
    }
}
