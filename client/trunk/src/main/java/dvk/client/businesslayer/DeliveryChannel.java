package dvk.client.businesslayer;

import dvk.client.conf.OrgSettings;

/**
 * DVK sõnumi edastusinfo.
 * Klass on mõeldud selleks, et vahetult enne dokumendi
 * väljasaatmist lisada sõnumi juurde, millisel viisil see
 * tuleks adressaadile edastada.
 * 
 * @author		Jaak Lember
 */
public class DeliveryChannel {
	private String m_producerName;
	private String m_serviceUrl;
	private OrgSettings m_database;
	private int m_unitId;
	private MessageRecipient m_recipient;
	
    public String getProducerName() {
        return this.m_producerName;
    }

    public void setProducerName(String value) {
        this.m_producerName = value;
    }

    public String getServiceUrl() {
        return this.m_serviceUrl;
    }

    public void setServiceUrl(String value) {
        this.m_serviceUrl = value;
    }

    public OrgSettings getDatabase() {
        return this.m_database;
    }

    public void setDatabase(OrgSettings value) {
        this.m_database = value;
    }

    public int getUnitId() {
        return this.m_unitId;
    }

    public void setUnitId(int value) {
        this.m_unitId = value;
    }

    public MessageRecipient getRecipient() {
        return this.m_recipient;
    }

    public void setRecipient(MessageRecipient value) {
        this.m_recipient = value;
    }

    public void clear() {
    	m_producerName = "";
    	m_serviceUrl = "";
    	m_database = null;
    	m_unitId = 0;
    	m_recipient = null;
    }
    
    public DeliveryChannel() {
    	clear();
    }
}
