package dvk.client.iostructures;

import java.util.ArrayList;

public class ReceiveDocumentsBody implements SOAPBodyOverride {
    public int arv;
    public ArrayList<String> kaust;

    public ReceiveDocumentsBody() {
        arv = 0;
        kaust = new ArrayList<String>();
    }

    public String getBodyContentsAsText() {
        StringBuffer tmp = new StringBuffer(100);
        tmp.append("<dhl:receiveDocuments><keha><arv>").append(arv).append("</arv>");
        if ((kaust != null) && !kaust.isEmpty()) {
            for (int i = 0; i < kaust.size(); ++i) {
                tmp.append("<kaust>");
                tmp.append(kaust.get(i));
                tmp.append("</kaust>");
            }
        } else {
            tmp.append("<kaust/>");
        }
        tmp.append("</keha></dhl:receiveDocuments>");
        return tmp.toString();
    }
}
