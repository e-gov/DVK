package dvk.client.iostructures;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

import dvk.core.CommonStructures;

public class ReceiveDocumentsV4Body implements SOAPBodyOverride {
	
	private static Logger logger = Logger.getLogger(ReceiveDocumentsV4Body.class);
	
    public int arv;
    public String allyksuseLyhinimetus;
    public String ametikohaLyhinimetus;
    public List<String> kaust;
    public String edastusID;
    public int fragmentNr;
    public long fragmendiSuurusBaitides;

    public ReceiveDocumentsV4Body() {
        arv = 0;
        allyksuseLyhinimetus = "";
        ametikohaLyhinimetus = "";
        kaust = new ArrayList<String>();
        edastusID = "";
        fragmentNr = -1;
        fragmendiSuurusBaitides = 0;
    }

    public String getBodyContentsAsText() {
    	logger.debug("getBodyContentsAsText for ReceiveDocuments.V4");
        String tmp = "<dhl:receiveDocuments " + CommonStructures.NS_DHL_DECLARATION + "><keha><arv>" + String.valueOf(arv) + "</arv>";
        if ((allyksuseLyhinimetus != null) && (allyksuseLyhinimetus.length() > 0)) {
            tmp += "<allyksuse_lyhinimetus>"+ allyksuseLyhinimetus +"</allyksuse_lyhinimetus>";
        }
        if ((ametikohaLyhinimetus != null) && (ametikohaLyhinimetus.length() > 0)) {
            tmp += "<ametikoha_lyhinimetus>"+ ametikohaLyhinimetus +"</ametikoha_lyhinimetus>";
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
