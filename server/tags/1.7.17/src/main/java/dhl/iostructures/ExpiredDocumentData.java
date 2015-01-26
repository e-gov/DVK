package dhl.iostructures;

import java.util.Date;

public class ExpiredDocumentData {
    private int m_documentID;
    private int m_sendStatusID;
    private Date m_conservationDeadline;

    public ExpiredDocumentData() {
        clear();
    }

    public int getDocumentID() {
        return m_documentID;
    }

    public void setDocumentID(int value) {
        m_documentID = value;
    }

    public int getSendStatusID() {
        return m_sendStatusID;
    }

    public void setSendStatusID(int value) {
        m_sendStatusID = value;
    }

    public Date getConservationDeadline() {
        return m_conservationDeadline;
    }

    public void setConservationDeadline(Date value) {
        m_conservationDeadline = value;
    }

    public void clear() {
        m_documentID = 0;
        m_sendStatusID = 0;
        m_conservationDeadline = null;
    }
}
