package dvk.client.businesslayer;

import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class DhlCapability {
    private String m_orgCode;
    private String m_orgName;
    private boolean m_isDhlCapable;
    private boolean m_isDhlDirectCapable;
    private String m_dhlDirectProducerName;
    private String m_dhlDirectServiceUrl; // otsesuhtluse korral ilma X-teed kasutamata adapterserveri aadress
    private String m_parentOrgCode;

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

    public void setDhlDirectProducerName(String value) {
        this.m_dhlDirectProducerName = value;
    }

    public String getDhlDirectProducerName() {
        return m_dhlDirectProducerName;
    }

    public void setDhlDirectServiceUrl(String value) {
        this.m_dhlDirectServiceUrl = value;
    }

    public String getDhlDirectServiceUrl() {
        return m_dhlDirectServiceUrl;
    }
    
    public String getParentOrgCode() {
        return this.m_parentOrgCode;
    }

    public void setParentOrgCode(String value) {
        this.m_parentOrgCode = value;
    }
    
    public DhlCapability() {
        clear();
    }

    public DhlCapability(Connection conn, String orgCode, OrgSettings db) {
        loadFromDB(conn, orgCode, db);
    }

    /**
     * T�hjendab v�i initsialiseerib klassi andmev�ljad
     */
    public void clear() {
        m_orgCode = "";
        m_orgName = "";
        m_isDhlCapable = false;
        m_isDhlDirectCapable = false;
        m_dhlDirectProducerName = "";
        m_dhlDirectServiceUrl = "";
        m_parentOrgCode = "";
    }

    /**
     * Salvestab asutuse DVK-v�imekust puudutavad andmed andmebaasi
     * 
     * @param conn      Andmebaasi�hendus
     * @return          Kas salvestamine �nnestus
     */
    public boolean saveToDB(Connection conn, OrgSettings db) {
        try {
            if (conn != null) {
                int parNr = 1;
                CallableStatement cs = conn.prepareCall("{call Save_DhlOrganization(?,?,?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = conn.prepareCall("{? = call \"Save_DhlOrganization\"(?,?,?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setString(parNr++, m_orgCode);
                cs.setString(parNr++, m_orgName);
                cs.setInt(parNr++, (m_isDhlCapable ? 1 : 0));
                cs.setInt(parNr++, (m_isDhlDirectCapable ? 1 : 0));
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
                conn.commit();
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            try { conn.rollback(); }
            catch(SQLException ex1) { CommonMethods.logError(ex, this.getClass().getName(), "saveToDB"); }
            CommonMethods.logError(ex, this.getClass().getName(), "saveToDB");
            return false;
        }
    }
    
    public void loadFromDB(Connection conn, String orgCode, OrgSettings db) {
        clear();
        try {
            if (conn != null) {
                conn.setAutoCommit(false);
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    parNr++;
                }
                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlCapability", 1, db, conn);
                cs.setString(parNr++, orgCode);
                ResultSet rs = DBConnection.getResultSet(cs, db, 1);
                if (rs.next()) {
                    m_orgCode = rs.getString("org_code");
                    m_orgName = rs.getString("org_name");
                    m_isDhlCapable = (rs.getInt("dhl_capable") ==  1);
                    m_isDhlDirectCapable = (rs.getInt("dhl_direct_capable") == 1);
                    m_dhlDirectProducerName = rs.getString("dhl_direct_producer_name");
                    m_dhlDirectServiceUrl = rs.getString("dhl_direct_service_url");
                    m_parentOrgCode = rs.getString("parent_org_code");
                }
                rs.close();
                cs.close();
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlCapability", "loadFromDB");
        }
    }

    // V�ljastab k�ikide erinevate DVK serverite seadete kollektsiooni 
    public static ArrayList<DhlCapability> getList(OrgSettings db) {
        try {
            Connection conn = DBConnection.getConnection(db);
            if (conn != null) {
                conn.setAutoCommit(false);
                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlCapabilityList", 0, db, conn);
                ResultSet rs = DBConnection.getResultSet(cs, db, 0);
                ArrayList<DhlCapability> result = new ArrayList<DhlCapability>();
                while (rs.next()) {
                    DhlCapability item = new DhlCapability();
                    item.setOrgCode(rs.getString("org_code"));
                    item.setOrgName(rs.getString("org_name"));
                    item.setIsDhlCapable(rs.getInt("dhl_capable") == 1);
                    item.setIsDhlDirectCapable(rs.getInt("dhl_direct_capable") == 1);
                    item.setDhlDirectProducerName(rs.getString("dhl_direct_producer_name"));
                    item.setDhlDirectServiceUrl(rs.getString("dhl_direct_service_url")); 
                    item.setParentOrgCode(rs.getString("parent_org_code"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                conn.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlCapability", "getListByMessageID");
            return null;
        }
    }
    
    // V�ljastab etteantud s�numi saajate erinevate DVK serverite seadete kollektsiooni
    public static ArrayList<DhlCapability> getListByMessageID(int messageID, OrgSettings db) {
        try {
            Connection conn = DBConnection.getConnection(db);
            if (conn != null) {
                conn.setAutoCommit(false);
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    parNr++;
                }
                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlCapabilityByMessageID", 1, db, conn);
                cs.setInt(parNr++, messageID);
                ResultSet rs = DBConnection.getResultSet(cs, db, 1);
                ArrayList<DhlCapability> result = new ArrayList<DhlCapability>();
                
                // Siin on oluline, et ei loetaks muid andmeid peale
                // erinevate DVK-v�imekuse kombinatsioonide.
                while (rs.next()) {
                    DhlCapability item = new DhlCapability();
                    item.setIsDhlCapable((rs.getInt("dhl_capable") == 1));
                    item.setIsDhlDirectCapable((rs.getInt("dhl_direct_capable") == 1));
                    item.setDhlDirectProducerName(rs.getString("dhl_direct_producer_name"));
                    item.setDhlDirectServiceUrl(rs.getString("dhl_direct_service_url"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                conn.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlCapability", "getListByMessageID");
            return null;
        }
    }
    
    // V�ljastab organisatsioonide koodide kollektsiooni, kes on sama serveri k�ljes
    public static ArrayList<String> getOrgsByCapability(DhlCapability dcap, OrgSettings db) {
        try {
            Connection conn = DBConnection.getConnection(db);
            if (conn != null) {
                conn.setAutoCommit(false);
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    parNr++;
                }
                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlOrgsByCapability", 4, db, conn);
                
                cs.setInt(parNr++, (dcap.getIsDhlCapable() ? 1 : 0));
                cs.setInt(parNr++, (dcap.getIsDhlDirectCapable() ? 1 : 0));
                cs.setString(parNr++, dcap.getDhlDirectProducerName());
                cs.setString(parNr++, dcap.getDhlDirectServiceUrl());
                
                ResultSet rs = DBConnection.getResultSet(cs, db, 4);
                ArrayList<String> result = new ArrayList<String>();
                while (rs.next()) {
                    result.add(rs.getString("org_code"));
                }
                rs.close();
                cs.close();
                conn.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlCapability", "getOrgsByCapability");
            return null;
        }
    }
    
    // Uuendada iga saaja (asutuste l�ikes) puhul DHL_ID v��rtust
    public boolean updateDhlID(DhlMessage msg, OrgSettings db, int dhlID) {        
        try {
            //m_dhlID = dhlID;
           // logger.info("Update_DhlMessageRecipientDhlID "+ msg.getDhlID());
            Connection conn = DBConnection.getConnection(db);
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Update_DhlMessageRecipDhlID(?,?,?,?,?,?)}");
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = conn.prepareCall("{? = call \"Update_DhlMessageRecipDhlID\"(?,?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, msg.getId());
                cs.setInt(parNr++, (m_isDhlDirectCapable ? 1 : 0));
                cs.setString(parNr++, m_dhlDirectProducerName);
                cs.setString(parNr++, m_dhlDirectServiceUrl);
                cs.setInt(parNr++, dhlID);
                cs.setString(parNr++, msg.getQueryID());
                cs.execute();
                cs.close();
                conn.close();
                return true;
            } 
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "updateDhlID");
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
            CommonMethods.logError(ex, "dvk.client.businesslayer.DhlCapability", "fromXML");
            return null;
        }
    }
}
