package dvk.client.iostructures;

import dvk.client.iostructures.SOAPBodyOverride;
import java.util.ArrayList;

public class GetSendingOptionsV2Body implements SOAPBodyOverride {
    public ArrayList<String> asutused; // asutuste reg.koodide list
    public boolean vastuvotmata_dokumente_ootel;
    public int vahetatud_dokumente_vahemalt;
    public int vahetatud_dokumente_kuni;

    public GetSendingOptionsV2Body() {
        asutused = new ArrayList<String>();
        vastuvotmata_dokumente_ootel = false;        
        vahetatud_dokumente_vahemalt = -1;
        vahetatud_dokumente_kuni = -1;
    }

    public String getBodyContentsAsText() {
        StringBuilder sb = new StringBuilder();
        sb.append("<dhl:getSendingOptions><keha>");        
        if (vastuvotmata_dokumente_ootel)
            sb.append("<vastuvotmata_dokumente_ootel>true</vastuvotmata_dokumente_ootel>");         
        if (vahetatud_dokumente_vahemalt >= 0)
            sb.append("<vahetatud_dokumente_vahemalt>"+ String.valueOf(vahetatud_dokumente_vahemalt) +"</vahetatud_dokumente_vahemalt>");         
        if (vahetatud_dokumente_kuni >= 0)
            sb.append("<vahetatud_dokumente_kuni>"+ String.valueOf(vahetatud_dokumente_kuni) +"</vahetatud_dokumente_kuni>");         
        if (asutused != null) {
            sb.append("<asutused>");
            for (int i = 0; i < asutused.size(); ++i) {
                sb.append("<asutus>" + asutused.get(i) + "</asutus>");
            }
            sb.append("</asutused>");
        }
        sb.append("</keha></dhl:getSendingOptions>");
        return sb.toString();
    }
}
