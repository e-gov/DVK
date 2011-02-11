package dvk.client.iostructures;

import java.util.ArrayList;
import java.util.List;

public class ReceiveDocumentsV2Body implements SOAPBodyOverride {
    public int arv;
    public List<String> kaust;
    public String edastusID;
    public int fragmentNr;
    public long fragmendiSuurusBaitides;

    public ReceiveDocumentsV2Body() {
        arv = 0;
        kaust = new ArrayList<String>();
        edastusID = "";
        fragmentNr = -1;
        fragmendiSuurusBaitides = 0;
    }

    public String getBodyContentsAsText() {
        String tmp = "<dhl:receiveDocuments><keha><arv>" + String.valueOf(arv) + "</arv>";
        if (!kaust.isEmpty()) {
            for (int i = 0; i < kaust.size(); ++i) {
                tmp += "<kaust>" + kaust.get(i) + "</kaust>";
            }
        } else {
            tmp += "<kaust/>";
        }
        if ((edastusID != null) && !edastusID.equalsIgnoreCase("")) {
            tmp += "<edastus_id>"+ edastusID +"</edastus_id>";
        }
        if (fragmentNr >= 0) {
            tmp += "<fragment_nr>"+ String.valueOf(fragmentNr) +"</fragment_nr>";
        }
        if (fragmendiSuurusBaitides > 0) {
            tmp += "<fragmendi_suurus_baitides>"+ String.valueOf(fragmendiSuurusBaitides) +"</fragmendi_suurus_baitides>";
        }
        tmp += "</keha></dhl:receiveDocuments>";
        return tmp;
    }
}
