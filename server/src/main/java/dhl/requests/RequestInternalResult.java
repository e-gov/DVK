package dhl.requests;

import java.util.List;

import org.w3c.dom.Element;

import dhl.users.Asutus;

public class RequestInternalResult {
    public String dataMd5Hash;
    public String responseFile;
    public String folder;
    public List<String> folders;
    public List<Asutus> orgs;
    public int count;
    public int fragmentNr;
    public long fragmentSizeBytes;
    public int totalFragments;
    public String deliverySessionID;
    public Element requestElement;
    
    public RequestInternalResult() {
        dataMd5Hash = "";
        responseFile = "";
        folder = "";
        folders = null;
        orgs = null;
        count = 0;
        fragmentNr = -1;
        fragmentSizeBytes = 0;
        totalFragments = 0;
        deliverySessionID = "";
        requestElement = null;
    }
}
