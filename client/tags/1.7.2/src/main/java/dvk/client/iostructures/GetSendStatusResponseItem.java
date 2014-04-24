package dvk.client.iostructures;

import dvk.client.businesslayer.DocumentStatusHistory;
import dvk.client.businesslayer.MessageRecipient;
import dvk.client.conf.OrgSettings;
import dvk.core.Settings;
import dvk.core.CommonMethods;
import java.util.ArrayList;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class GetSendStatusResponseItem {
    private int m_dhlID;
    private int m_sendingStatusID;
    private ArrayList<MessageRecipient> m_recipients;
    private ArrayList<DocumentStatusHistory> m_history;
    private String m_guid;
    
    public void setDhlID(int dhlID) {
        this.m_dhlID = dhlID;
    }

    public int getDhlID() {
        return m_dhlID;
    }

    public void setSendingStatusID(int sendingStatusID) {
        this.m_sendingStatusID = sendingStatusID;
    }

    public int getSendingStatusID() {
        return m_sendingStatusID;
    }

    public void setRecipients(ArrayList<MessageRecipient> recipients) {
        this.m_recipients = recipients;
    }

    public ArrayList<MessageRecipient> getRecipients() {
        return m_recipients;
    }
    
    public ArrayList<DocumentStatusHistory> getHistory() {
        return this.m_history;
    }

    public void setHistory(ArrayList<DocumentStatusHistory> value) {
        this.m_history = value;
    }

    public GetSendStatusResponseItem() {
        m_dhlID = 0;
        m_sendingStatusID = Settings.Client_StatusSending;
        m_recipients = new ArrayList<MessageRecipient>();
        m_history = new ArrayList<DocumentStatusHistory>();
    }

    public static GetSendStatusResponseItem fromXML(Element root) {
        if (root == null) {
            return null;
        }

        GetSendStatusResponseItem result = new GetSendStatusResponseItem();

        NodeList nl = root.getChildNodes();
        Node n = null;
        for (int i = 0; i < nl.getLength(); ++i) {
            n = nl.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE) {
                if (n.getLocalName().equalsIgnoreCase("dhl_id")) {
                    result.setDhlID(Integer.parseInt(CommonMethods.getNodeText(n)));
                } else if (n.getLocalName().equalsIgnoreCase("dokument_guid")) {
                    result.setGuid(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("olek")) {
                    String status = CommonMethods.getNodeText(n);
                    if (status.equalsIgnoreCase("saadetud")) {
                        result.setSendingStatusID(Settings.Client_StatusSent);
                    } else if (status.equalsIgnoreCase("katkestatud")) {
                        result.setSendingStatusID(Settings.Client_StatusCanceled);
                    }
                } else if (n.getLocalName().equalsIgnoreCase("edastus")) {
                    MessageRecipient recipientData = MessageRecipient.fromXML((Element)n);
                    if (recipientData != null) {
                    	result.getRecipients().add(recipientData);
                    }
                } else if (n.getLocalName().equalsIgnoreCase("staatuse_ajalugu")) {
                	NodeList historyNodes = n.getChildNodes();
                	for (int j = 0; j < historyNodes.getLength(); j++) {
                		Node historyNode = historyNodes.item(j);
                		if ((historyNode.getNodeType() == Node.ELEMENT_NODE) && historyNode.getLocalName().equalsIgnoreCase("staatus")) {
	                		DocumentStatusHistory historyEvent = DocumentStatusHistory.fromXML((Element)historyNode);
		                    if (historyEvent != null) {
		                    	result.m_history.add(historyEvent);
		                    }
                		}
                	}
                }
            }
        }
        
        for (int i = 0; i < result.getRecipients().size(); ++i) {
            MessageRecipient r = result.getRecipients().get(i);
            r.setDhlId(result.getDhlID());
            result.getRecipients().set(i, r);
        }

        return result;
    }

	public String getGuid() {
		return m_guid;
	}

	public void setGuid(String mGuid) {
		m_guid = mGuid;
	}
}
