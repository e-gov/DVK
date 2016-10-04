package dvk.client.iostructures;

import java.util.ArrayList;

public class ReceiveDocumentsResult {
    public ArrayList<String> documents;
    public String deliverySessionID;
    
    public ReceiveDocumentsResult() {
        documents = new ArrayList<String>();
        deliverySessionID = "";
    }
}
