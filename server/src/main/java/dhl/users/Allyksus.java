package dhl.users;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import dvk.core.CommonMethods;

public class Allyksus {
    private int m_id;
    private int m_asutusID;
    private int m_vanemID;
    private String m_nimetus;
    private Date m_loodud;
    private Date m_muudetud;
    private String m_muutja;
    private int m_muutmisteArv;
    private int m_aarID;
    private String m_lyhinimetus;
    private String m_adrUri;

    // Abimuutuja, mida andmebaasi pole vaja salvestada
    private String m_asutusKood;
    private String m_ksAllyksuseLyhinimetus;

    public Allyksus() {
        clear();
    }

    public int getID() {
        return m_id;
    }

    public void setID(int value) {
        m_id = value;
    }

    public int getAsutusID() {
        return m_asutusID;
    }

    public void setAsutusID(int value) {
        m_asutusID = value;
    }

    public int getVanemID() {
        return m_vanemID;
    }

    public void setVanemID(int value) {
        m_vanemID = value;
    }

    public String getNimetus() {
        return m_nimetus;
    }

    public void setNimetus(String value) {
        m_nimetus = value;
    }

    public Date getLoodud() {
        return m_loodud;
    }

    public void setLoodud(Date value) {
        m_loodud = value;
    }

    public Date getMuudetud() {
        return m_muudetud;
    }

    public void setMuudetud(Date value) {
        m_muudetud = value;
    }

    public String getMuutja() {
        return m_muutja;
    }

    public void setMuutja(String value) {
        m_muutja = value;
    }

    public int getMuutmisteArv() {
        return m_muutmisteArv;
    }

    public void setMuutmisteArv(int value) {
        m_muutmisteArv = value;
    }

    public int getAarID() {
        return m_aarID;
    }

    public void setAarID(int value) {
        m_aarID = value;
    }

    public String getLyhinimetus() {
        return this.m_lyhinimetus;
    }

    public void setLyhinimetus(String value) {
        this.m_lyhinimetus = value;
    }

    public String getAdrUri() {
        return this.m_adrUri;
    }

    public void setAdrUri(String value) {
        this.m_adrUri = value;
    }


    public String getAsutusKood() {
        return m_asutusKood;
    }

    public void setAsutusKood(String value) {
        m_asutusKood = value;
    }

    public String getKsAllyksuseLyhinimetus() {
        return this.m_ksAllyksuseLyhinimetus;
    }

    public void setKsAllyksuseLyhinimetus(String value) {
        this.m_ksAllyksuseLyhinimetus = value;
    }

    public void clear() {
        m_id = 0;
        m_asutusID = 0;
        m_vanemID = 0;
        m_nimetus = "";
        m_loodud = null;
        m_muudetud = null;
        m_muutja = "";
        m_muutmisteArv = 0;
        m_aarID = 0;
        m_asutusKood = "";
        m_lyhinimetus = "";
        m_adrUri = "";
        m_ksAllyksuseLyhinimetus = "";
    }


    
    public static Allyksus getByAarID(int aarID, Connection conn) {
        try {
            if (conn != null) {
                Allyksus result = new Allyksus();
                Calendar cal = Calendar.getInstance();                           	
            	CallableStatement cs = conn.prepareCall("SELECT * FROM \"Get_AllyksusByAarID\"(?)");
                cs.setInt(1, aarID);
                ResultSet rs = cs.executeQuery();        	
                while (rs.next()) {                               
	                if (rs.getInt("id") > 0) {
	                    result.setID(rs.getInt("id"));
	                    result.setAsutusID(rs.getInt("asutus_id"));
	                    result.setVanemID(rs.getInt("vanem_id"));
	                    result.setNimetus(rs.getString("nimetus"));
	                    result.setLoodud(rs.getTimestamp("created", cal));
	                    result.setMuudetud(rs.getTimestamp("last_modified", cal));
	                    result.setMuutja(rs.getString("username"));
	                    result.setMuutmisteArv(rs.getInt("muutmiste_arv"));
	                    result.setLyhinimetus(rs.getString("lyhinimetus"));
	                    result.setAdrUri(rs.getString("adr_uri"));
	                    result.setAarID(aarID);
	                } else {
	                    result = null;
	                }
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Allyksus", "getByAarID");
            return null;
        }
    }
    

    public static int getIdByAarID(int aarID, Connection conn) {
        try {
            if (conn != null) {
                int result = 0;
                CallableStatement cs = conn.prepareCall("{? = call \"Get_AllyksusIdByAarID\"(?)}");
                cs.registerOutParameter(1, Types.INTEGER);
                cs.setInt(2, aarID);
                cs.executeUpdate();
                result = cs.getInt(1);
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Allyksus", "getIdByAarID");
            return 0;
        }
    }

    
    public static int getIdByShortName(int orgId, String shortName, Connection conn) {
        try {
            if (conn != null) {
                int result = 0;
                CallableStatement cs = conn.prepareCall("{? = call \"Get_AllyksusIdByShortName\"(?,?)}");
                cs.registerOutParameter(1, Types.INTEGER);
                cs.setInt(2, orgId);
                cs.setString(3, shortName);
                cs.executeUpdate();
                result = cs.getInt(1);
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Allyksus", "getIdByShortName");
            return 0;
        }
    }
    
    
    public static ArrayList<Allyksus> getList(int orgID, String name, Connection conn) {
        try {
            if (conn != null) {            	
            	boolean defaultAutoCommit = conn.getAutoCommit();
            	try{
	            	conn.setAutoCommit(false);	                        
	            	Calendar cal = Calendar.getInstance();
	            	CallableStatement cs = conn.prepareCall("{? = call \"Get_AllyksusList\"(?,?)}");
	                cs.registerOutParameter(1, Types.OTHER);
            	            
	                if (orgID > 0) {
	                    cs.setInt(2, orgID);
	                } else {
	                    cs.setNull(2, Types.INTEGER);
	                }
	                if ((name != null) && (name.length() > 0)) {
	                    cs.setString(3, name);
	                } else {
	                    cs.setNull(3, Types.VARCHAR);
	                }
	                cs.execute();
	                ResultSet rs = (ResultSet) cs.getObject(1);
	                ArrayList<Allyksus> result = new ArrayList<Allyksus>();
	                while (rs.next()) {
	                    Allyksus item = new Allyksus();
	                    item.setID(rs.getInt("id"));
	                    item.setAsutusID(rs.getInt("asutus_id"));
	                    item.setVanemID(rs.getInt("vanem_id"));
	                    item.setNimetus(rs.getString("allyksus"));
	                    item.setLoodud(rs.getTimestamp("created", cal));
	                    item.setMuudetud(rs.getTimestamp("last_modified", cal));
	                    item.setMuutja(rs.getString("username"));
	                    item.setMuutmisteArv(rs.getInt("muutm_arv"));
	                    item.setAarID(rs.getInt("aar_id"));
	                    item.setLyhinimetus(rs.getString("lyhinimetus"));
	                    item.setAdrUri(rs.getString("adr_uri"));
	                    item.setAsutusKood(rs.getString("asutuse_kood"));
	                    item.setKsAllyksuseLyhinimetus(rs.getString("ks_allyksuse_lyhinimetus"));
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
            CommonMethods.logError(ex, "dhl.users.Allyksus", "getList");
            return null;
        }
    }
    

    public int addToDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{? = call \"Add_Allyksus\"(?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter(1, Types.INTEGER);
                
                cs.setInt(2, m_asutusID);
                cs.setInt(3, m_vanemID);
                cs.setString(4, m_nimetus);
                cs.setTimestamp(5, CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp(6, CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString(7, m_muutja);
                cs.setInt(8, m_muutmisteArv);
                cs.setInt(9, m_aarID);
                cs.setString(10, m_lyhinimetus);
                cs.setString(11, m_adrUri);
                cs.executeUpdate();
                m_id = cs.getInt(1);
                cs.close();
                return m_id;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "addToDB");
            return 0;
        }
    }
    

    public int updateInDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call \"Update_Allyksus\"(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, Types.INTEGER);
                cs.setInt(2, m_asutusID);
                cs.setInt(3, m_vanemID);
                cs.setString(4, m_nimetus);
                cs.setTimestamp(5, CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp(6, CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString(7, m_muutja);
                cs.setInt(8, m_muutmisteArv);
                cs.setInt(9, m_aarID);
                cs.setString(10, m_lyhinimetus);
                cs.setString(11, m_adrUri);
                cs.executeUpdate();
                cs.close();
                return m_id;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "updateInDB");
            return 0;
        }
    }
    
    
    public int saveToDB(Connection conn) {
        if (m_id > 0) {
            return updateInDB(conn);
        } else {
            return addToDB(conn);
        }
    }
    
    /*
    public int updateInDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call UPDATE_ALLYKSUS(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt("id", Types.INTEGER);
                cs.setInt("asutus_id", m_asutusID);
                cs.setInt("vanem_id", m_vanemID);
                cs.setString("nimetus", m_nimetus);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
                cs.setInt("muutmiste_arv", m_muutmisteArv);
                cs.setInt("aar_id", m_aarID);
                cs.setString("lyhinimetus", m_lyhinimetus);
                cs.setString("adr_uri", m_adrUri);
                cs.executeUpdate();
                cs.close();
                return m_id;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "updateInDB");
            return 0;
        }
    }
    */
    
    /*
    public int addToDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call ADD_ALLYKSUS(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setInt("asutus_id", m_asutusID);
                cs.setInt("vanem_id", m_vanemID);
                cs.setString("nimetus", m_nimetus);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
                cs.setInt("muutmiste_arv", m_muutmisteArv);
                cs.setInt("aar_id", m_aarID);
                cs.setString("lyhinimetus", m_lyhinimetus);
                cs.setString("adr_uri", m_adrUri);
                cs.executeUpdate();
                m_id = cs.getInt("id");
                cs.close();
                return m_id;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "addToDB");
            return 0;
        }
    }
    */
    /*
    public static ArrayList<Allyksus> getList(int orgID, String name, Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_ALLYKSUSLIST(?,?,?)}");
                if (orgID > 0) {
                    cs.setInt("asutus_id", orgID);
                } else {
                    cs.setNull("asutus_id", Types.INTEGER);
                }
                if ((name != null) && (name.length() > 0)) {
                    cs.setString("nimetus", name);
                } else {
                    cs.setNull("nimetus", Types.VARCHAR);
                }
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet) cs.getObject("RC1");
                ArrayList<Allyksus> result = new ArrayList<Allyksus>();
                while (rs.next()) {
                    Allyksus item = new Allyksus();
                    item.setID(rs.getInt("id"));
                    item.setAsutusID(rs.getInt("asutus_id"));
                    item.setVanemID(rs.getInt("vanem_id"));
                    item.setNimetus(rs.getString("allyksus"));
                    item.setLoodud(rs.getTimestamp("created", cal));
                    item.setMuudetud(rs.getTimestamp("last_modified", cal));
                    item.setMuutja(rs.getString("username"));
                    item.setMuutmisteArv(rs.getInt("muutm_arv"));
                    item.setAarID(rs.getInt("aar_id"));
                    item.setLyhinimetus(rs.getString("lyhinimetus"));
                    item.setAdrUri(rs.getString("adr_uri"));
                    item.setAsutusKood(rs.getString("asutuse_kood"));
                    item.setKsAllyksuseLyhinimetus(rs.getString("ks_allyksuse_lyhinimetus"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Allyksus", "getList");
            return null;
        }
    }
    */
    
    /*
    public static int getIdByShortName(int orgId, String shortName, Connection conn) {
        try {
            if (conn != null) {
                int result = 0;
                CallableStatement cs = conn.prepareCall("{call GET_ALLYKSUSIDBYSHORTNAME(?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setInt("org_id", orgId);
                cs.setString("short_name", shortName);
                cs.executeUpdate();
                result = cs.getInt("id");
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Allyksus", "getIdByShortName");
            return 0;
        }
    }
    */

    /*
    public static Allyksus getByAarID(int aarID, Connection conn) {
        try {
            if (conn != null) {
                Allyksus result = new Allyksus();
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_ALLYKSUSBYAARID(?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.registerOutParameter("asutus_id", Types.INTEGER);
                cs.registerOutParameter("vanem_id", Types.INTEGER);
                cs.registerOutParameter("nimetus", Types.VARCHAR);
                cs.registerOutParameter("created", Types.TIMESTAMP);
                cs.registerOutParameter("last_modified", Types.TIMESTAMP);
                cs.registerOutParameter("username", Types.VARCHAR);
                cs.registerOutParameter("muutmiste_arv", Types.INTEGER);
                cs.registerOutParameter("lyhinimetus", Types.VARCHAR);
                cs.registerOutParameter("adr_uri", Types.VARCHAR);
                cs.setInt("aar_id", aarID);
                cs.executeUpdate();
                if (cs.getInt("id") > 0) {
                    result.setID(cs.getInt("id"));
                    result.setAsutusID(cs.getInt("asutus_id"));
                    result.setVanemID(cs.getInt("vanem_id"));
                    result.setNimetus(cs.getString("nimetus"));
                    result.setLoodud(cs.getTimestamp("created", cal));
                    result.setMuudetud(cs.getTimestamp("last_modified", cal));
                    result.setMuutja(cs.getString("username"));
                    result.setMuutmisteArv(cs.getInt("muutmiste_arv"));
                    result.setLyhinimetus(cs.getString("lyhinimetus"));
                    result.setAdrUri(cs.getString("adr_uri"));
                    result.setAarID(aarID);
                } else {
                    result = null;
                }
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Allyksus", "getByAarID");
            return null;
        }
    }
    */

    /*
    public static int getIdByAarID(int aarID, Connection conn) {
        try {
            if (conn != null) {
                int result = 0;
                CallableStatement cs = conn.prepareCall("{call GET_ALLYKSUSIDBYAARID(?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setInt("aar_id", aarID);
                cs.executeUpdate();
                result = cs.getInt("id");
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Allyksus", "getIdByAarID");
            return 0;
        }
    }
    */
    
}
