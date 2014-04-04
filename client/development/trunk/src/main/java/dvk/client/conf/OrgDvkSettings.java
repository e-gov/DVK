package dvk.client.conf;

import dvk.core.CommonMethods;
import dvk.core.Settings;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class OrgDvkSettings {
    private String m_serviceUrl;
    private int m_sendDocumentsRequestVersion;
    private int m_receiveDocumentsRequestVersion;
    private int m_markDocumentsReceivedRequestVersion;
    private int m_getSendStatusRequestVersion;
    private int m_getSendingOptionsRequestVersion;
    private int m_getSubdivisionListRequestVersion;
    private int m_getOccupationListRequestVersion;
    private int m_defaultStatusID;
    private int aditGetSendStatusRequestVersion;

    public void setServiceUrl(String serviceUrl) {
        if (serviceUrl == null) {
            m_serviceUrl = Settings.Client_ServiceUrl;
        } else {
            m_serviceUrl = serviceUrl;
        }
    }

    public String getServiceUrl() {
        return m_serviceUrl;
    }

    public void setSendDocumentsRequestVersion(int sendDocumentsRequestVersion) {
        if (sendDocumentsRequestVersion < 1) {
            m_sendDocumentsRequestVersion = 1;
        } else {
            m_sendDocumentsRequestVersion = sendDocumentsRequestVersion;
        }
    }

    public int getSendDocumentsRequestVersion() {
        return m_sendDocumentsRequestVersion;
    }

    public void setReceiveDocumentsRequestVersion(int receiveDocumentsRequestVersion) {
        if (receiveDocumentsRequestVersion < 1) {
            m_receiveDocumentsRequestVersion = 1;
        } else {
            this.m_receiveDocumentsRequestVersion = receiveDocumentsRequestVersion;
        }
    }

    public int getReceiveDocumentsRequestVersion() {
        return m_receiveDocumentsRequestVersion;
    }

    public void setMarkDocumentsReceivedRequestVersion(int markDocumentsReceivedRequestVersion) {
        if (markDocumentsReceivedRequestVersion < 1) {
            m_markDocumentsReceivedRequestVersion = 1;
        } else {
            m_markDocumentsReceivedRequestVersion = markDocumentsReceivedRequestVersion;
        }
    }

    public int getMarkDocumentsReceivedRequestVersion() {
        return m_markDocumentsReceivedRequestVersion;
    }

    public void setGetSendStatusRequestVersion(int getSendStatusRequestVersion) {
        if (getSendStatusRequestVersion < 1) {
            m_getSendStatusRequestVersion = 1;
        } else {
            m_getSendStatusRequestVersion = getSendStatusRequestVersion;
        }
    }

    public int getGetSendStatusRequestVersion() {
        return m_getSendStatusRequestVersion;
    }

    public void setGetSendingOptionsRequestVersion(int getSendingOptionsRequestVersion) {
        if (getSendingOptionsRequestVersion < 1) {
            m_getSendingOptionsRequestVersion = 1;
        } else {
            m_getSendingOptionsRequestVersion = getSendingOptionsRequestVersion;
        }
    }

    public int getGetSendingOptionsRequestVersion() {
        return m_getSendingOptionsRequestVersion;
    }
    
    public void setGetSubdivisionListRequestVersion(int getSubdivisionListRequestVersion) {
        if (getSubdivisionListRequestVersion < 1) {
            m_getSubdivisionListRequestVersion = 1;
        } else {
            m_getSubdivisionListRequestVersion = getSubdivisionListRequestVersion;
        }
    }

    public int getGetSubdivisionListRequestVersion() {
        return m_getSubdivisionListRequestVersion;
    }
    
    public void setGetOccupationListRequestVersion(int getOccupationListRequestVersion) {
        if (getOccupationListRequestVersion < 1) {
            m_getOccupationListRequestVersion = 1;
        } else {
            m_getOccupationListRequestVersion = getOccupationListRequestVersion;
        }
    }

    public int getGetOccupationListRequestVersion() {
        return m_getOccupationListRequestVersion;
    }

    public void setDefaultStatusID(int defaultStatusID) {
        m_defaultStatusID = defaultStatusID;
    }

    public int getDefaultStatusID() {
        return m_defaultStatusID;
    }

    public int getAditGetSendStatusRequestVersion() {
        return aditGetSendStatusRequestVersion;
    }

    public void setAditGetSendStatusRequestVersion(int aditGetSendStatusRequestVersion) {
        this.aditGetSendStatusRequestVersion = aditGetSendStatusRequestVersion;
    }

    public OrgDvkSettings() {
        m_serviceUrl = Settings.Client_ServiceUrl;
        m_sendDocumentsRequestVersion = 1;
        m_receiveDocumentsRequestVersion = 1;
        m_markDocumentsReceivedRequestVersion = 1;
        m_getSendStatusRequestVersion = 1;
        m_getSendingOptionsRequestVersion = 1;
        m_getSubdivisionListRequestVersion = 1;
        m_getOccupationListRequestVersion = 1;
        m_defaultStatusID = 0;
        aditGetSendStatusRequestVersion = 1;
    }

    /**
     * Loeb DVK ühenduse seaded XML struktuurist.
     * 
     * @param rootNode      DVK ühenduse seadete juurelement
     * @return              DVK ühenduse seadete objekt
     */
    public static OrgDvkSettings getFromXML(Node rootNode) {
        Node n;
        NodeList nl = rootNode.getChildNodes();
        OrgDvkSettings result = new OrgDvkSettings();
        String nodeText;
        for (int i = 0; i < nl.getLength(); ++i) {
            n = nl.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE) {
                nodeText = CommonMethods.getNodeText(n);
                if ((nodeText != null) && (nodeText.trim().length() > 0)) {
                    nodeText = nodeText.trim();
                    if (n.getLocalName().equalsIgnoreCase("service_url")) {
                        result.setServiceUrl(nodeText);
                    } else if (n.getLocalName().equalsIgnoreCase("send_documents_ver")) {
                        result.setSendDocumentsRequestVersion(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("receive_documents_ver")) {
                        result.setReceiveDocumentsRequestVersion(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("mark_documents_received_ver")) {
                        result.setMarkDocumentsReceivedRequestVersion(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("get_send_status_ver")) {
                        result.setGetSendStatusRequestVersion(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("get_sending_options_ver")) {
                        result.setGetSendingOptionsRequestVersion(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("get_subdivision_list_ver")) {
                        result.setGetSubdivisionListRequestVersion(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("get_occupation_list_ver")) {
                        result.setGetOccupationListRequestVersion(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("default_status_id")) {
                        result.setDefaultStatusID(Integer.parseInt(nodeText));
                    } else if (n.getLocalName().equalsIgnoreCase("adit_get_send_status")) {
                        result.setAditGetSendStatusRequestVersion(Integer.parseInt(nodeText));
                    }
                }
            }
        }

        return result;
    }
}
