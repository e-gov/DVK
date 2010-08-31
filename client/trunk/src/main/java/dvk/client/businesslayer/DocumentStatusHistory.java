package dvk.client.businesslayer;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Calendar;
import java.util.Date;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Fault;
import dvk.core.Settings;

public class DocumentStatusHistory {
	private int m_id;
	private int m_serverSideId;
	private int m_recipientId;
	private int m_sendingStatusId;
	private Date m_statusDate;
	private Fault m_fault;
    private int m_recipientStatusId;
    private String m_metaXML;
    
    // Abimuutujad, mida andmebaasi ei salvestata
    private String m_orgCode;
    private String m_personCode;
    private String m_subdivisionShortName;
    private String m_occupationShortName;
    
    public int getId() {
        return this.m_id;
    }

    public void setId(int value) {
        this.m_id = value;
    }

    public int getServerSideId() {
        return this.m_serverSideId;
    }

    public void setServerSideId(int value) {
        this.m_serverSideId = value;
    }
    
    public int getRecipientId() {
        return this.m_recipientId;
    }

    public void setRecipientId(int value) {
        this.m_recipientId = value;
    }

    public int getSendingStatusId() {
        return this.m_sendingStatusId;
    }

    public void setSendingStatusId(int value) {
        this.m_sendingStatusId = value;
    }

    public Date getStatusDate() {
        return this.m_statusDate;
    }

    public void setStatusDate(Date value) {
        this.m_statusDate = value;
    }

    public Fault getFault() {
        return this.m_fault;
    }

    public void setFault(Fault value) {
        this.m_fault = value;
    }

    public int getRecipientStatusId() {
        return this.m_recipientStatusId;
    }

    public void setRecipientStatusId(int value) {
        this.m_recipientStatusId = value;
    }

    public String getMetaXML() {
        return this.m_metaXML;
    }

    public void setMetaXML(String value) {
        this.m_metaXML = value;
    }
    
    
    public String getOrgCode() {
        return this.m_orgCode;
    }

    public void setOrgCode(String value) {
        this.m_orgCode = value;
    }

    public String getPersonCode() {
        return this.m_personCode;
    }

    public void setPersonCode(String value) {
        this.m_personCode = value;
    }

    public String getSubdivisionShortName() {
        return this.m_subdivisionShortName;
    }

    public void setSubdivisionShortName(String value) {
        this.m_subdivisionShortName = value;
    }

    public String getOccupationShortName() {
        return this.m_occupationShortName;
    }

    public void setOccupationShortName(String value) {
        this.m_occupationShortName = value;
    }

    public DocumentStatusHistory() {
    	this.m_id = 0;
    	this.m_serverSideId = 0;
    	this.m_recipientId = 0;
    	this.m_sendingStatusId = 0;
    	this.m_statusDate = null;
    	this.m_fault = null;
    	this.m_recipientStatusId = 0;
    	this.m_metaXML = "";
        
    	this.m_orgCode = "";
    	this.m_personCode = "";
    	this.m_subdivisionShortName = "";
    	this.m_occupationShortName = "";
    }
    
    public int saveToDB(OrgSettings db) throws Exception {
        int result = 0;
    	Connection conn = DBConnection.getConnection(db);
        if (conn != null) {
            try {
            	Calendar cal = Calendar.getInstance();

                int parNr = 1;
                CallableStatement cs = conn.prepareCall("{call Save_DhlStatusHistory(?,?,?,?,?,?,?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = conn.prepareCall("{? = call \"Save_DhlStatusHistory\"(?,?,?,?,?,?,?,?,?,?)}");
                }
                
                // Mingil põhjusel toimib SQL Anywhere JDBC klient
                // korrektselt ainult juhul, kui väljundparameetrid asuvad kõige lõpus.
                // Vastasel juhul liigutatakse kõik väljundparameetrile
                // järgnevad sisendparameetrid ühe koha võrra edasi.
                if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	parNr++;
                }

                cs.setInt(parNr++, m_recipientId);
                cs.setInt(parNr++, m_serverSideId);
                cs.setInt(parNr++, m_sendingStatusId);
                cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(m_statusDate), cal);
                if (m_fault != null) {
	                cs.setString(parNr++, m_fault.getFaultCode());
	                cs.setString(parNr++, m_fault.getFaultActor());
	                cs.setString(parNr++, m_fault.getFaultString());
	                cs.setString(parNr++, m_fault.getFaultDetail());
                } else {
	                cs.setNull(parNr++, Types.VARCHAR);
	                cs.setNull(parNr++, Types.VARCHAR);
	                cs.setNull(parNr++, Types.VARCHAR);
	                cs.setNull(parNr++, Types.VARCHAR);
                }
                cs = CommonMethods.setNullableIntParam(cs, parNr++, m_recipientStatusId);
                cs.setString(parNr++, m_metaXML);
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	cs.registerOutParameter(parNr, Types.INTEGER);
                } else {
                	cs.registerOutParameter(1, Types.INTEGER);
                }
                cs.execute();
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	m_id = cs.getInt(parNr);
                } else {
                	m_id = cs.getInt(1);
                }
                cs.close();
                conn.commit();
            } finally {
            	if (conn != null) {
            		try { conn.close(); }
            		catch (Exception ex) {}
            	}
            }
        } else {
            throw new SQLException("Database connection is NULL!");
        }
        return result;
    }
    
    public static DocumentStatusHistory fromXML(Element itemRootElement) {
        if (itemRootElement == null) {
            return null;
        }

    	DocumentStatusHistory item = new DocumentStatusHistory();
        NodeList nl = itemRootElement.getChildNodes();
        Node n = null;
        for (int i = 0; i < nl.getLength(); i++) {
            n = nl.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE) {
                if (n.getLocalName().equalsIgnoreCase("saaja")) {
                	NodeList recNl = n.getChildNodes();                    
                	for (int j = 0; j < recNl.getLength(); j++) {
                		Node n2 = recNl.item(j);
                		if (n2.getNodeType() == Node.ELEMENT_NODE) {
                			if (n2.getLocalName().equalsIgnoreCase("regnr")) {
                				item.setOrgCode(CommonMethods.getNodeText(n2).trim());
                			} else if (n2.getLocalName().equalsIgnoreCase("isikukood")) {
                				item.setPersonCode(CommonMethods.getNodeText(n2).trim());
                			} else if (n2.getLocalName().equalsIgnoreCase("allyksuse_lyhinimetus")) {
                				item.setSubdivisionShortName(CommonMethods.getNodeText(n2).trim());
                			} else if (n2.getLocalName().equalsIgnoreCase("ametikoha_lyhinimetus")) {
                				item.setOccupationShortName(CommonMethods.getNodeText(n2).trim());
                			} 
                		}
                	}
                } else if (n.getLocalName().equalsIgnoreCase("staatuse_ajalugu_id")) {
                    item.setServerSideId(Integer.parseInt(CommonMethods.getNodeText(n).trim()));
                } else if (n.getLocalName().equalsIgnoreCase("staatuse_muutmise_aeg")) {
                    item.setStatusDate(CommonMethods.getDateFromXML(CommonMethods.getNodeText(n).trim()));
                } else if (n.getLocalName().equalsIgnoreCase("staatus")) {
                	String status = CommonMethods.getNodeText(n).trim();
                    if (status.equalsIgnoreCase("saadetud")) {
                        item.setSendingStatusId(Settings.Client_StatusSent);
                    } else if (status.equalsIgnoreCase("katkestatud")) {
                        item.setSendingStatusId(Settings.Client_StatusCanceled);
                    } else {
                        item.setSendingStatusId(Settings.Client_StatusSending);
                    }
                } else if (n.getLocalName().equalsIgnoreCase("fault")) {
                    Fault f = Fault.getFromXML((Element)n);
                	item.setFault(f);
                } else if (n.getLocalName().equalsIgnoreCase("vastuvotja_staatus_id")) {
                    item.setRecipientStatusId(Integer.parseInt(CommonMethods.getNodeText(n).trim()));
                } else if (n.getLocalName().equalsIgnoreCase("metaxml")) {
                    Element e = (Element)n;
                    String meta = CommonMethods.xmlElementToString(e).trim();
                    if (meta != null) {
                        if (meta.equalsIgnoreCase("<metaxml/>") || meta.equalsIgnoreCase("<metaxml />")) {
                            meta = "";
                        } else if (meta.startsWith("<metaxml>") && meta.endsWith("</metaxml>")) {
                            meta = meta.substring(9, meta.lastIndexOf("</metaxml>"));
                        }
                        item.setMetaXML(meta);
                    }
                }
            }
        }
        
        return item;
    }
}
