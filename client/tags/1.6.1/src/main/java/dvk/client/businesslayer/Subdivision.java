package dvk.client.businesslayer;

import dvk.client.conf.OrgSettings;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Subdivision {
	private static Logger logger = Logger.getLogger(Subdivision.class.getName());
	
	private int m_id;
    private String m_name;
    private String m_orgCode;
    private String m_shortName;
    private String m_parentSubdivisionShortName;

    public int getID() {
        return m_id;
    }

    public void setID(int value) {
        m_id = value;
    }

    public String getName() {
        return m_name;
    }

    public void setName(String value) {
        m_name = value;
    }

    public String getOrgCode() {
        return m_orgCode;
    }

    public void setOrgCode(String value) {
        m_orgCode = value;
    }
    
    public String getShortName() {
        return this.m_shortName;
    }

    public void setShortName(String value) {
        this.m_shortName = value;
    }

    public String getParentSubdivisionShortName() {
        return this.m_parentSubdivisionShortName;
    }

    public void setParentSubdivisionShortName(String value) {
        this.m_parentSubdivisionShortName = value;
    }
    

    public Subdivision() {
        clear();
    }
    
    public void clear() {
        m_id = 0;
        m_name = "";
        m_orgCode = "";
        m_shortName = "";
        m_parentSubdivisionShortName = "";
    }
    
    public boolean saveToDB(Connection conn, OrgSettings db) {
        try {
            if (conn != null) {
                int parNr = 1;
                CallableStatement cs = conn.prepareCall("{call Save_DhlSubdivision(?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = conn.prepareCall("{? = call \"Save_DhlSubdivision\"(?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, m_id);
                cs.setString(parNr++, m_name);
                cs.setString(parNr++, m_orgCode);
                cs.setString(parNr++, m_shortName);
                cs.setString(parNr++, m_parentSubdivisionShortName);
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
    
    public static Subdivision fromXML(Element itemRootElement) {
        if (itemRootElement == null) {
            return null;
        }

        try {
            Subdivision item = new Subdivision();
            NodeList nl = itemRootElement.getChildNodes();
            Node n = null;
            for (int i = 0; i < nl.getLength(); ++i) {
                n = nl.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    if (n.getLocalName().equalsIgnoreCase("kood")) {
                        item.setID(CommonMethods.toIntSafe(CommonMethods.getNodeText(n).trim(), 0));
                    } else if (n.getLocalName().equalsIgnoreCase("nimetus")) {
                        item.setName(CommonMethods.getNodeText(n).trim());
                    } else if (n.getLocalName().equalsIgnoreCase("asutuse_kood")) {
                        item.setOrgCode(CommonMethods.getNodeText(n).trim());
                    } else if (n.getLocalName().equalsIgnoreCase("lyhinimetus")) {
                        item.setShortName(CommonMethods.getNodeText(n).trim());
                    } else if (n.getLocalName().equalsIgnoreCase("ks_allyksuse_lyhinimetus")) {
                        item.setParentSubdivisionShortName(CommonMethods.getNodeText(n).trim());
                    }
                }
            }
            
            logger.debug("Deserialized subdivision data.");
            logger.debug("m_id = " + String.valueOf(item.m_id));
    		logger.debug("m_name = " + item.m_name);
			logger.debug("m_orgCode = " + item.m_orgCode);
			logger.debug("m_shortName = " + item.m_shortName);
			logger.debug("m_parentSubdivisionShortName = " + item.m_parentSubdivisionShortName);
            
            if (item.getID() < 1) {
                return null;
            } else {
                return item;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dvk.client.businesslayer.Subdivision", "fromXML");
            return null;
        }
    }
}
