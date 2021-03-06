package dhl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;

import dvk.core.CommonMethods;

public class RemoteServer {
    
    private int m_id;
    
    private String xRoadServiceInstance;
    private String xRoadServiceMemberClass;
    private String xRoadServiceMemberCode;
    private String m_producerName;
    private String m_address;

    public int getID() {
        return m_id;
    }

    public void setID(int id) {
        m_id = id;
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

    /**
     * NOTE:<br>
     * "producerName" corresponds to <b>"subsystemCode"</b> element of the <em>service</em> block
     * in the X-Road message protocol version 4.0
     * 
     * @return <em>producerName</em> / <em>subsystemCode</em>
     */
    public String getProducerName() {
        return m_producerName;
    }

    public void setProducerName(String producerName) {
        m_producerName = producerName;
    }

    public String getProducerSOAPAction() {
        if ((m_producerName != null) && !m_producerName.equalsIgnoreCase("")) {
            return "http://producers." + m_producerName + ".xtee.riik.ee/producer/" + m_producerName;
        } else {
            return "";
        }
    }

    public String getAddress() {
        return m_address;
    }

    public void setAddress(String address) {
        m_address = address;
    }

    public RemoteServer() {
        clear();
    }

    public RemoteServer(int id, Connection conn) {
        clear();
        loadByID(id, conn);
    }

    public void clear() {
        m_id = 0;
        m_producerName = "";
        m_address = "";
    }

    
    
    
    public void loadByID(int id, Connection conn) {
        try {
            if (conn != null) {
            	
                Statement cs = conn.createStatement();
                ResultSet rs = cs.executeQuery("SELECT * FROM \"Get_ServerByID\"(" + id + ")");
                while (rs.next()) {
                    m_id = id;
                    m_producerName = rs.getString("andmekogu_nimi");
                    m_address = rs.getString("aadress");
                }
                rs.close();
                cs.close();
            } else {
                clear();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "loadByID");
            clear();
        }
    }
    

    
    public static ArrayList<RemoteServer> getList(Connection conn) {
        try {
            if (conn != null) {
            	boolean defaultAutoCommit = conn.getAutoCommit();
            	try{
	            	conn.setAutoCommit(false);            	
	            	CallableStatement cs = conn.prepareCall("{? = call \"Get_Servers\"()}");
	            	cs.registerOutParameter(1, Types.OTHER);            	                
	                cs.execute();
	                
	                ResultSet rs = (ResultSet) cs.getObject(1);
	                ArrayList<RemoteServer> result = new ArrayList<RemoteServer>();
	                while (rs.next()) {
	                    RemoteServer item = new RemoteServer();
	                    item.setID(rs.getInt("server_id"));
	                    item.setProducerName(rs.getString("andmekogu_nimi"));
	                    item.setAddress(rs.getString("aadress"));
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
	                return result;
	            } finally {
	    			conn.setAutoCommit(defaultAutoCommit);
	    		}	               	               	                
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.RemoteServer", "getList");
            return null;
        }
    }
    
    /*
    public void loadByID(int id, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_SERVERBYID(?,?,?)}");
                cs.setInt("server_id", id);
                cs.registerOutParameter("andmekogu_nimi", Types.VARCHAR);
                cs.registerOutParameter("aadress", Types.VARCHAR);
                cs.executeUpdate();
                m_id = id;
                m_producerName = cs.getString("andmekogu_nimi");
                m_address = cs.getString("aadress");
                cs.close();
            } else {
                clear();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "loadByID");
            clear();
        }
    }

    public static ArrayList<RemoteServer> getList(Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_SERVERS(?)}");
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet) cs.getObject("RC1");
                ArrayList<RemoteServer> result = new ArrayList<RemoteServer>();
                while (rs.next()) {
                    RemoteServer item = new RemoteServer();
                    item.setID(rs.getInt("server_id"));
                    item.setProducerName(rs.getString("andmekogu_nimi"));
                    item.setAddress(rs.getString("aadress"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.RemoteServer", "getList");
            return null;
        }
    }
    */
}
