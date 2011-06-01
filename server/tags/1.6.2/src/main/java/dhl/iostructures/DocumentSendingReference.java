package dhl.iostructures;

public class DocumentSendingReference {
    private int m_dokumentID;
    private String m_isikukood;

    public int getDokumentID() {
        return m_dokumentID;
    }

    public void setDokumentID(int value) {
        m_dokumentID = value;
    }

    public String getIsikukood() {
        return m_isikukood;
    }

    public void setIsikukood(String value) {
        m_isikukood = value;
    }

    public DocumentSendingReference() {
        m_dokumentID = 0;
        m_isikukood = "";
    }
}
