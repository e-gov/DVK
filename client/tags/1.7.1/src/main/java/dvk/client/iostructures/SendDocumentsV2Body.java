package dvk.client.iostructures;

import dvk.core.CommonMethods;
import java.util.Date;

public class SendDocumentsV2Body {
    public String dokumendid;
    public String kaust;
    public Date sailitustahtaeg;
    public String edastusID;
    public int fragmentNr;
    public int fragmenteKokku;
    
    public SendDocumentsV2Body() {
        dokumendid = "";
        kaust = "";
        sailitustahtaeg = null;
        edastusID = "";
        fragmentNr = -1;
        fragmenteKokku = 0;
    }
    
    public String getBodyContentsAsText() {
        StringBuilder sb = new StringBuilder();
        sb.append("<dhl:sendDocuments><keha>");
        sb.append("<dokumendid href=\"cid:" + dokumendid + "\"/>");
        sb.append("<kaust>" + ((kaust == null) ? "" : kaust) + "</kaust>");
        if (sailitustahtaeg != null) {
            sb.append("<sailitustahtaeg>" + CommonMethods.getDateISO8601(sailitustahtaeg) + "</sailitustahtaeg>");
        }
        if ((edastusID != null) && !edastusID.equalsIgnoreCase("")) {
            sb.append("<edastus_id>" + edastusID + "</edastus_id>");
        }
        if (fragmentNr >= 0) {
            sb.append("<fragment_nr>" + String.valueOf(fragmentNr) + "</fragment_nr>");
        }
        if (fragmenteKokku > 0) {
            sb.append("<fragmente_kokku>" + String.valueOf(fragmenteKokku) + "</fragmente_kokku>");
        }
        sb.append("</keha></dhl:sendDocuments>");
        return sb.toString();
    }
}
