package dvk.client.iostructures;

import java.util.ArrayList;

public class ReceiveDocumentsV3Body implements SOAPBodyOverride {
    public int arv;
    public int allyksus;
    public int ametikoht;
    public ArrayList<String> kaust;
    public String edastusID;
    public int fragmentNr;
    public long fragmendiSuurusBaitides;

    public ReceiveDocumentsV3Body() {
        arv = 0;
        allyksus = 0;
        ametikoht = 0;
        kaust = new ArrayList<String>();
        edastusID = "";
        fragmentNr = -1;
        fragmendiSuurusBaitides = 0;
    }

    public String getBodyContentsAsText() {
        String tmp = "<dhl:receiveDocuments><keha><arv>" + String.valueOf(arv) + "</arv>";
        if (allyksus > 0) {
            tmp += "<allyksus>"+ String.valueOf(allyksus) +"</allyksus>";
        }
        if (ametikoht > 0) {
            tmp += "<ametikoht>"+ String.valueOf(ametikoht) +"</ametikoht>";
        }
        if ((kaust != null) && !kaust.isEmpty()) {
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
