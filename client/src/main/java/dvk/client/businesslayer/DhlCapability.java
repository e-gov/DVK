package dvk.client.businesslayer;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;

import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.LoggingService;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

public class DhlCapability {
	
    private String m_orgCode;
    private String m_orgName;
    private boolean m_isDhlCapable;
    private boolean m_isDhlDirectCapable;
    private String m_parentOrgCode;
    
	// For X-Road message protocol v4.0 the equivalent of "producer" is
    // "subsystemCode" element inside "service" SOAP header block
    private String m_dhlDirectProducerName;
    private String m_dhlDirectServiceUrl;
    private String xRoadServiceInstance;
    private String xRoadServiceMemberClass;
    private String xRoadServiceMemberCode;
    

    public void setOrgCode(String orgCode) {
        this.m_orgCode = orgCode;
    }

    public String getOrgCode() {
        return m_orgCode;
    }

    public void setOrgName(String orgName) {
        this.m_orgName = orgName;
    }

    public String getOrgName() {
        return m_orgName;
    }

    public void setIsDhlCapable(boolean isDhlCapable) {
        this.m_isDhlCapable = isDhlCapable;
    }
    public boolean getIsDhlCapable() {
        return m_isDhlCapable;
    }

    public boolean IsDhlCapable() {
        return m_isDhlCapable;
    }

    public void setIsDhlDirectCapable(boolean isDhlDirectCapable) {
        this.m_isDhlDirectCapable = isDhlDirectCapable;
    }
    public boolean getIsDhlDirectCapable() {
        return this.m_isDhlDirectCapable;
    }

    public boolean IsDhlDirectCapable() {
        return m_isDhlDirectCapable;
    }

    
    public String getParentOrgCode() {
        return this.m_parentOrgCode;
    }

    public void setParentOrgCode(String value) {
        this.m_parentOrgCode = value;
    }
    
    /**
     * NOTE:<br>
     * "producerName" corresponds to <b>"subsystemCode"</b> element of the <em>service</em> block
     * in the X-Road message protocol version 4.0
     * 
     * @return <em>producerName</em> / <em>subsystemCode</em>
     */
    public String getDhlDirectProducerName() {
    	return m_dhlDirectProducerName;
    }
    
    public void setDhlDirectProducerName(String value) {
    	this.m_dhlDirectProducerName = value;
    }
    
    public String getDhlDirectServiceUrl() {
    	return m_dhlDirectServiceUrl;
    }
    
    public void setDhlDirectServiceUrl(String value) {
    	this.m_dhlDirectServiceUrl = value;
    }
    
    public String getXRoadServiceInstance() {
		return xRoadServiceInstance;
	}

	public void setXRoadServiceInstance(String xRoadServiceInstance) {
		this.xRoadServiceInstance = xRoadServiceInstance;
	}

	public String getXRoadServiceMemberClass() {
		return xRoadServiceMemberClass;
	}

	public void setXRoadServiceMemberClass(String xRoadServiceMemberClass) {
		this.xRoadServiceMemberClass = xRoadServiceMemberClass;
	}

	public String getXRoadServiceMemberCode() {
		return xRoadServiceMemberCode;
	}

	public void setXRoadServiceMemberCode(String xRoadServiceMemberCode) {
		this.xRoadServiceMemberCode = xRoadServiceMemberCode;
	}

	public DhlCapability() {
        clear();
    }

    public DhlCapability(Connection conn, String orgCode, OrgSettings db) {
        loadFromDB(conn, orgCode, db);
    }

    /**
     * Initializes all fields
     */
    public void clear() {
        m_orgCode = "";
        m_orgName = "";
        m_isDhlCapable = false;
        m_isDhlDirectCapable = false;
        m_parentOrgCode = "";
        
        m_dhlDirectProducerName = "";
        m_dhlDirectServiceUrl = "";
        xRoadServiceInstance = "";
        xRoadServiceMemberClass = "";
        xRoadServiceMemberCode = "";
    }

    /**
     * Save data about organization DEC capability to database
     * 
     * @param dbConnection
     * 		Active database connection
     * @param db
     * 		Database settings
     * @return
     * 		{@code true} if saving succeeded
     */
    public boolean saveToDB(Connection dbConnection, OrgSettings db) {
        try {
            if (dbConnection != null) {
                int parNr = 1;
                CallableStatement cs = dbConnection.prepareCall("{call Save_DhlOrganization(?,?,?,?,?,?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Save_DhlOrganization\"(?,?,?,?,?,?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setString(parNr++, m_orgCode);
                cs.setString(parNr++, m_orgName);
                cs.setInt(parNr++, (m_isDhlCapable ? 1 : 0));
                cs.setInt(parNr++, (m_isDhlDirectCapable ? 1 : 0));
                
                if ((xRoadServiceInstance != null) && (xRoadServiceInstance.length() > 0)) {
                    cs.setString(parNr++, xRoadServiceInstance);
                } else {
                    cs.setNull(parNr++, Types.VARCHAR);
                }
                if ((xRoadServiceMemberClass != null) && (xRoadServiceMemberClass.length() > 0)) {
                    cs.setString(parNr++, xRoadServiceMemberClass);
                } else {
                    cs.setNull(parNr++, Types.VARCHAR);
                }
                if ((xRoadServiceMemberCode != null) && (xRoadServiceMemberCode.length() > 0)) {
                    cs.setString(parNr++, xRoadServiceMemberCode);
                } else {
                    cs.setNull(parNr++, Types.VARCHAR);
                }
                
                if ((m_dhlDirectProducerName != null) && (m_dhlDirectProducerName.length() > 0)) {
                    cs.setString(parNr++, m_dhlDirectProducerName);
                } else {
                    cs.setNull(parNr++, Types.VARCHAR);
                }
                if ((m_dhlDirectServiceUrl != null) && (m_dhlDirectServiceUrl.length() > 0)) {
                    cs.setString(parNr++, m_dhlDirectServiceUrl);
                } else {
                    cs.setNull(parNr++, Types.VARCHAR);
                }
                
                cs.setString(parNr++, m_parentOrgCode);
                
                cs.execute();
                cs.close();
                
                dbConnection.commit();
                
                return true;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", this.getClass().getName() + " saveToDB");
                LoggingService.logError(errorLog);
                return false;
            }
        } catch (Exception ex) {
            try {
                dbConnection.rollback();
            } catch(SQLException ex1) {
                ErrorLog errorLog = new ErrorLog(ex1, this.getClass().getName() + " saveToDB");
                LoggingService.logError(errorLog);
            }
            
            ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " saveToDB");
            errorLog.setOrganizationCode(this.getOrgCode());
            LoggingService.logError(errorLog);
            
            return false;
        }
    }
    
    public void loadFromDB(Connection dbConnection, String orgCode, OrgSettings db) {
        clear();
        try {
            if (dbConnection != null) {
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlCapability", 1, db, dbConnection);
	                cs.setString(parNr++, orgCode);
	                ResultSet rs = DBConnection.getResultSet(cs, db, 1);
	                if (rs.next()) {
	                    m_orgCode = rs.getString("org_code");
	                    m_orgName = rs.getString("org_name");
	                    m_isDhlCapable = (rs.getInt("dhl_capable") ==  1);
	                    m_isDhlDirectCapable = (rs.getInt("dhl_direct_capable") == 1);
	                    m_parentOrgCode = rs.getString("parent_org_code");
	                    
	                    m_dhlDirectServiceUrl = rs.getString("dhl_direct_service_url");
	                    m_dhlDirectProducerName = rs.getString("dhl_direct_producer_name");
	                    xRoadServiceInstance = rs.getString("xroad_service_instance");
	                    xRoadServiceMemberClass = rs.getString("xroad_service_member_class");
	                    xRoadServiceMemberCode = rs.getString("xroad_service_member_code");
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " loadFromDB");
            errorLog.setOrganizationCode(this.getOrgCode());
            LoggingService.logError(errorLog);
        }
    }

    /**
     * Returns list of all known organizations
     */
    public static ArrayList<DhlCapability> getList(OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
            	ArrayList<DhlCapability> result = new ArrayList<DhlCapability>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlCapabilityList", 0, db, dbConnection);
	                ResultSet rs = DBConnection.getResultSet(cs, db, 0);
	                while (rs.next()) {
	                    DhlCapability item = new DhlCapability();
	                    item.setOrgCode(rs.getString("org_code"));
	                    item.setOrgName(rs.getString("org_name"));
	                    item.setIsDhlCapable(rs.getInt("dhl_capable") == 1);
	                    item.setIsDhlDirectCapable(rs.getInt("dhl_direct_capable") == 1);
	                    item.setParentOrgCode(rs.getString("parent_org_code"));
	                    
	                    item.setDhlDirectServiceUrl(rs.getString("dhl_direct_service_url"));
	                    item.setDhlDirectProducerName(rs.getString("dhl_direct_producer_name"));
	                    item.setXRoadServiceInstance(rs.getString("xroad_service_instance"));
	                    item.setXRoadServiceMemberClass(rs.getString("xroad_service_member_class"));
	                    item.setXRoadServiceMemberCode(rs.getString("xroad_service_member_code"));
	                    
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.businesslayer.DhlCapability" + " getList");
                LoggingService.logError(errorLog);
                return null;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.DhlCapability" + " getList");
            LoggingService.logError(errorLog);
            return null;
        }
    }
    
    /**
     * Returns list of all organizations related to given DEC message
     */
    public static ArrayList<DhlCapability> getListByMessageID(int messageID, OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
            	ArrayList<DhlCapability> result = new ArrayList<DhlCapability>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlCapabilityByMessageID", 1, db, dbConnection);
	                cs.setInt(parNr++, messageID);
	                ResultSet rs = DBConnection.getResultSet(cs, db, 1);
	                
	                // It is necessary to read here only all different combinations of DEC capability
	                while (rs.next()) {
	                    DhlCapability item = new DhlCapability();
	                    item.setIsDhlCapable((rs.getInt("dhl_capable") == 1));
	                    item.setIsDhlDirectCapable((rs.getInt("dhl_direct_capable") == 1));
	                    item.setXRoadServiceInstance(rs.getString("xroad_service_instance"));
	                    item.setXRoadServiceMemberClass(rs.getString("xroad_service_member_class"));
	                    item.setXRoadServiceMemberCode(rs.getString("xroad_service_member_code"));
	                    item.setDhlDirectProducerName(rs.getString("dhl_direct_producer_name"));
	                    item.setDhlDirectServiceUrl(rs.getString("dhl_direct_service_url"));
	                    
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.businesslayer.DhlCapability" + " getListByMessageID");
                LoggingService.logError(errorLog);
                return null;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.DhlCapability" + " getListByMessageID");
            errorLog.setMessageId(messageID);
            LoggingService.logError(errorLog);
            return null;
        }
    }
    
    /**
     * Returns list of all organizations that are using the same DEC server
     */
    public static ArrayList<String> getOrgsByCapability(DhlCapability dcap, OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
            	ArrayList<String> result = new ArrayList<String>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlOrgsByCapability", 7, db, dbConnection);
	                
	                cs.setInt(parNr++, (dcap.getIsDhlCapable() ? 1 : 0));
	                cs.setInt(parNr++, (dcap.getIsDhlDirectCapable() ? 1 : 0));
	                
	                cs.setString(parNr++, dcap.getDhlDirectProducerName());
	                cs.setString(parNr++, dcap.getDhlDirectServiceUrl());
	                cs.setString(parNr++, dcap.getXRoadServiceInstance());
	                cs.setString(parNr++, dcap.getXRoadServiceMemberClass());
	                cs.setString(parNr++, dcap.getXRoadServiceMemberCode());
	                
	                ResultSet rs = DBConnection.getResultSet(cs, db, 7);
	                
	                while (rs.next()) {
	                    result.add(rs.getString("org_code"));
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.businesslayer.DhlCapability" + " getOrgsByCapability");
                LoggingService.logError(errorLog);
                return null;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.DhlCapability" + " getOrgsByCapability");
            LoggingService.logError(errorLog);
            return null;
        }
    }
    
    /**
     * Updates DEC document ID value in every recipient record
     */
    public boolean updateDhlID(DhlMessage msg, OrgSettings db, int dhlID, Connection dbConnection) {
        try {
            // m_dhlID = dhlID;
            // logger.info("Update_DhlMessageRecipientDhlID "+ msg.getDhlID());
            if (dbConnection != null) {
                CallableStatement cs = dbConnection.prepareCall("{call Update_DhlMessageRecipDhlID(?,?,?,?,?,?,?,?,?)}");
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Update_DhlMessageRecipDhlID\"(?,?,?,?,?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, msg.getId());
                cs.setInt(parNr++, (m_isDhlDirectCapable ? 1 : 0));
                cs.setString(parNr++, xRoadServiceInstance);
                cs.setString(parNr++, xRoadServiceMemberClass);
                cs.setString(parNr++, xRoadServiceMemberCode);
                cs.setString(parNr++, m_dhlDirectProducerName);
                cs.setString(parNr++, m_dhlDirectServiceUrl);
                cs.setInt(parNr++, dhlID);
                cs.setString(parNr++, msg.getQueryID());
                
                cs.execute();
                cs.close();
                
                return true;
            } 
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.DhlCapability" + " updateDhlID");
            errorLog.setOrganizationCode(this.getOrgCode());
            errorLog.setMessageId(msg.getId());
            LoggingService.logError(errorLog);
            return false;
        }        
     return false;
    }

    public static DhlCapability fromXML(Element orgRootElement) {
        if (orgRootElement == null) {
            return null;
        }

        try {
        	DhlCapability item = new DhlCapability();
            
            NodeList nl = orgRootElement.getChildNodes();
            Node n = null;
            for (int i = 0; i < nl.getLength(); ++i) {
                n = nl.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    if (n.getLocalName().equalsIgnoreCase("regnr")) {
                        item.setOrgCode(CommonMethods.getNodeText(n).trim());
                    } else if (n.getLocalName().equalsIgnoreCase("nimi")) {
                        item.setOrgName(CommonMethods.getNodeText(n).trim());
                    } else if (n.getLocalName().equalsIgnoreCase("saatmine")) {
                        NodeList nl2 = n.getChildNodes();
                        Node n2 = null;
                        for (int j = 0; j < nl2.getLength(); ++j) {
                            n2 = nl2.item(j);
                            if (n2.getNodeType() == Node.ELEMENT_NODE) {
                                if (n2.getLocalName().equalsIgnoreCase("saatmisviis")) {
                                    String val = CommonMethods.getNodeText(n2).trim();
                                    if (val.equalsIgnoreCase(CommonStructures.SENDING_DHL)) {
                                        item.setIsDhlCapable(true);
                                    } else if (val.equalsIgnoreCase(CommonStructures.SENDING_DHL_DIRECT)) {
                                        item.setIsDhlDirectCapable(true);
                                    }
                                }
                            }
                        }
                    } else if (n.getLocalName().equalsIgnoreCase("ks_asutuse_regnr")) {
                        item.setParentOrgCode(CommonMethods.getNodeText(n).trim());
                    }
                }
            }
            
            if ((item.getOrgCode() == null) || item.getOrgCode().equalsIgnoreCase("")) {
                return null;
            } else {
                return item;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.DhlCapability" + " fromXML");
            LoggingService.logError(errorLog);
            return null;
        }
    }
}
