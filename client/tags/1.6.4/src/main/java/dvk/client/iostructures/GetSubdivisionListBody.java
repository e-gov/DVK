package dvk.client.iostructures;

import java.util.ArrayList;

public class GetSubdivisionListBody implements SOAPBodyOverride {
    public ArrayList<String> keha;

    public GetSubdivisionListBody() {
        keha = new ArrayList<String>();
    }

    public String getBodyContentsAsText() {
        StringBuilder sb = new StringBuilder();
        sb.append("<dhl:getSubdivisionList><keha>");
        if (keha != null) {
            for (int i = 0; i < keha.size(); ++i) {
                sb.append("<asutus>" + keha.get(i) + "</asutus>");
            }
        }
        sb.append("</keha></dhl:getSubdivisionList>");
        return sb.toString();
    }
}
