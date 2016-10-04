package dhl.iostructures;

public class OrgForwardHelper {
    public int Index;
    public String OrgCode;
    
    public OrgForwardHelper() {
        Index = -1;
        OrgCode = "";
    }
    
    public OrgForwardHelper(int index, String orgCode) {
        this.Index = index;
        this.OrgCode = orgCode;
    }
}
