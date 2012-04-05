package dvk.client.iostructures;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class GetSendingOptionsResponseItem {
    private String m_regNr;
    private String m_name;
    private boolean m_dvkSending;
    private boolean m_dvkDirectSending;
    private String m_ksAsutuseRegnr;

    public String getRegNr() {
        return m_regNr;
    }

    public void setRegNr(String value) {
        m_regNr = value;
    }

    public String getName() {
        return m_name;
    }

    public void setName(String value) {
        m_name = value;
    }

    public boolean getDvkSending() {
        return m_dvkSending;
    }

    public void setDvkSending(boolean value) {
        m_dvkSending = value;
    }

    public boolean getDvkDirectSending() {
        return m_dvkDirectSending;
    }

    public void setDvkDirectSending(boolean value) {
        m_dvkDirectSending = value;
    }
    
    public String getKsAsutuseRegnr() {
        return this.m_ksAsutuseRegnr;
    }

    public void setKsAsutuseRegnr(String value) {
        this.m_ksAsutuseRegnr = value;
    }
    
    public GetSendingOptionsResponseItem() {
        clear();
    }
    
    public void clear() {
        m_regNr = "";
        m_name = "";
        m_dvkSending = false;
        m_dvkDirectSending = false;
        m_ksAsutuseRegnr = "";
    }
    
    public static GetSendingOptionsResponseItem fromXML(Element orgRootElement) {
        if (orgRootElement == null) {
            return null;
        }

        try {
            GetSendingOptionsResponseItem item = new GetSendingOptionsResponseItem();
            
            NodeList nl = orgRootElement.getChildNodes();
            Node n = null;
            for (int i = 0; i < nl.getLength(); ++i) {
                n = nl.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    if (n.getLocalName().equalsIgnoreCase("regnr")) {
                        item.setRegNr(CommonMethods.getNodeText(n).trim());
                    } else if (n.getLocalName().equalsIgnoreCase("nimi")) {
                        item.setName(CommonMethods.getNodeText(n).trim());
                    } else if (n.getLocalName().equalsIgnoreCase("saatmine")) {
                        NodeList nl2 = n.getChildNodes();
                        Node n2 = null;
                        for (int j = 0; j < nl2.getLength(); ++j) {
                            n2 = nl2.item(j);
                            if (n2.getNodeType() == Node.ELEMENT_NODE) {
                                if (n2.getLocalName().equalsIgnoreCase("saatmisviis")) {
                                    String val = CommonMethods.getNodeText(n2).trim();
                                    if (val.equalsIgnoreCase(CommonStructures.SENDING_DHL)) {
                                        item.setDvkSending(true);
                                    } else if (val.equalsIgnoreCase(CommonStructures.SENDING_DHL_DIRECT)) {
                                        item.setDvkDirectSending(true);
                                    }
                                }
                            }
                        }
                    } else if (n.getLocalName().equalsIgnoreCase("ks_asutuse_regnr")) {
                        item.setKsAsutuseRegnr(CommonMethods.getNodeText(n).trim());
                    }
                }
            }
            
            if ((item.getRegNr() == null) || item.getRegNr().equalsIgnoreCase("")) {
                return null;
            } else {
                return item;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dvk.client.iostructures.GetSendingOptionsResponseItem", "fromXML");
            return null;
        }
    }
}
