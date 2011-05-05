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

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class Occupation {
	static Logger logger = Logger.getLogger(Occupation.class.getName());
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

    public Occupation() {
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
                CallableStatement cs = conn.prepareCall("{call Save_DhlOccupation(?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = conn.prepareCall("{? = call \"Save_DhlOccupation\"(?,?,?,?,?)}");
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
            catch(SQLException ex1) { logger.error(ex1.getMessage(), ex1); }
            logger.error(ex.getMessage(), ex);
            return false;
        }
    }
    
    public static ArrayList<Occupation> getList(OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
                ArrayList<Occupation> result = new ArrayList<Occupation>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlOccupationList", 0, db, dbConnection);
	                ResultSet rs = DBConnection.getResultSet(cs, db, 0);
	                while (rs.next()) {
	                	Occupation item = new Occupation();
	                	item.setID(rs.getInt("occupation_code"));
	                	item.setName(rs.getString("occupation_name"));
	                	item.setOrgCode(rs.getString("org_code"));
	                	item.setParentSubdivisionShortName(rs.getString("parent_subdivision_short_name"));
	                	item.setShortName(rs.getString("occupation_short_name"));
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
            	logger.error("Database connection is NULL!");
                return null;
            }
        } catch (Exception ex) {
        	logger.error(ex);
            return null;
        }
    }
    
    public boolean deleteFromDb(OrgSettings db, Connection dbConnection) throws Exception {
    	boolean result = false;
    	try {
    		if (dbConnection != null) {
                int parNr = 1;
                CallableStatement cs = dbConnection.prepareCall("{call Delete_DhlOccupation(?)}");
                if (CommonStructures.PROVIDER_TYPE_POSTGRE.equalsIgnoreCase(db.getDbProvider())) {
                    cs = dbConnection.prepareCall("{? = call \"Delete_DhlOccupation\"(?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }
                cs.setInt(parNr++, m_id);
                cs.execute();
                cs.close();
                dbConnection.commit();
                result = true;
            } else {
            	logger.error("Database connection is NULL!");
            	result = false;
            }
        } catch (Exception ex) {
            try {
            	dbConnection.rollback();
            } catch(SQLException ex1) {
            	logger.error(ex1);
            }
            logger.error(ex);
            result = false;
        }
        return result;
    }
    
    public static Occupation fromXML(Element itemRootElement) {
        if (itemRootElement == null) {
            return null;
        }

        try {
            Occupation item = new Occupation();
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
            
            if (item.getID() < 1) {
                return null;
            } else {
                return item;
            }
        } catch (Exception ex) {
        	logger.error(ex.getMessage(), ex);
            return null;
        }
    }
    
    public static Occupation FindFromList(ArrayList<Occupation> list, String orgCode, String shortName) {
        try {            
        	for (int i = 0; i < list.size(); ++i) {
            	Occupation item = list.get(i);
                
            	if (((CommonMethods.isNullOrEmpty(orgCode) && CommonMethods.isNullOrEmpty(item.m_orgCode))
            		|| (!CommonMethods.isNullOrEmpty(orgCode) && orgCode.equalsIgnoreCase(item.m_orgCode)))
            		&&
            		((CommonMethods.isNullOrEmpty(shortName) && CommonMethods.isNullOrEmpty(item.m_shortName))
            		|| (!CommonMethods.isNullOrEmpty(shortName) && shortName.equalsIgnoreCase(item.m_shortName)))) {
            		
            		return item;
            	}
            }
        } catch (Exception ex) {
        	logger.error(ex);
            return null;
        }
        return null;
    }
}
