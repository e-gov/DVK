package dhl.users;

import dhl.aar.iostructures.AarOigus;
import dvk.core.CommonMethods;
import dvk.core.Settings;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class Kasutusoigus {
    private int m_id;
    private int m_asutusID;
    private int m_muuAsutusID;
    private int m_ametikohtID;
    private String m_roll;
    private Date m_alates;
    private Date m_kuni;
    private Date m_loodud;
    private Date m_muudetud;
    private String m_muutja;
    private boolean m_peatatud;
    private int m_allyksusID;

    public Kasutusoigus() {
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

    public int getMuuAsutusID() {
        return m_muuAsutusID;
    }

    public void setMuuAsutusID(int value) {
        m_muuAsutusID = value;
    }

    public int getAmetikohtID() {
        return m_ametikohtID;
    }

    public void setAmetikohtID(int value) {
        m_ametikohtID = value;
    }

    public String getRoll() {
        return m_roll;
    }

    public void setRoll(String value) {
        m_roll = value;
    }

    public Date getAlates() {
        return m_alates;
    }

    public void setAlates(Date value) {
        m_alates = value;
    }

    public Date getKuni() {
        return m_kuni;
    }

    public void setKuni(Date value) {
        m_kuni = value;
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

    public boolean getPeatatud() {
        return m_peatatud;
    }

    public void setPeatatud(boolean value) {
        m_peatatud = value;
    }

    public int getAllyksusID() {
        return m_allyksusID;
    }

    public void setAllyksusID(int value) {
        m_allyksusID = value;
    }

    public void clear() {
        m_id = 0;
        m_asutusID = 0;
        m_muuAsutusID = 0;
        m_ametikohtID = 0;
        m_roll = "";
        m_alates = null;
        m_kuni = null;
        m_loodud = null;
        m_muudetud = null;
        m_muutja = "";
        m_peatatud = false;
    }

    public static ArrayList<String> getPersonCurrentRoles(int personID, int orgID, Connection conn) {
        try {
            if (conn != null) {
            	boolean defaultAutoCommit = conn.getAutoCommit();
            	try{
	            	conn.setAutoCommit(false);            	
	            	CallableStatement cs = conn.prepareCall("{? = call \"Get_PersonCurrentRoles\"(?,?)}");
	            	cs.registerOutParameter(1, Types.OTHER);
	                cs.setInt(2, personID);
	                cs.setInt(3, orgID);	            
	                cs.execute();
	                ResultSet rs = (ResultSet) cs.getObject(1);
	                ArrayList<String> result = new ArrayList<String>();
	                while (rs.next()) {
	                    result.add(rs.getString("roll"));
	                }
	                rs.close();
	                cs.close();
	                return result;
	            } finally {
	    			conn.setAutoCommit(defaultAutoCommit);
	    		}	               	               
            } else {
                return new ArrayList<String>();
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Kasutusoigus", "getPersonCurrentRoles");
            return new ArrayList<String>();
        }
    }
    
    
    public static Kasutusoigus getFromDB(String roll, int asutusID, int ametikohtID, int allyksusID, Connection conn) {
    	try {
            if (conn != null) {
                Kasutusoigus result = new Kasutusoigus();
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_OIGUSBYAARID()}");
                cs.registerOutParameter("id", Types.INTEGER);
                CommonMethods.setNullableIntParam(cs, "asutus_id", asutusID);
                cs.registerOutParameter("muu_asutus_id", Types.INTEGER);
                CommonMethods.setNullableIntParam(cs, "ametikoht_id", ametikohtID);
                cs.setString("roll", roll);
                cs.registerOutParameter("alates", Types.TIMESTAMP);
                cs.registerOutParameter("kuni", Types.TIMESTAMP);
                cs.registerOutParameter("created", Types.TIMESTAMP);
                cs.registerOutParameter("last_modified", Types.TIMESTAMP);
                cs.registerOutParameter("username", Types.VARCHAR);
                cs.registerOutParameter("peatatud", Types.INTEGER);
                CommonMethods.setNullableIntParam(cs, "allyksus_id", allyksusID);
                cs.executeUpdate();
                if (cs.getInt("id") > 0) {
                    result.setID(cs.getInt("id"));
                    result.setAsutusID(asutusID);
                    result.setMuuAsutusID(cs.getInt("muu_asutus_id"));
                    result.setAmetikohtID(ametikohtID);
                    result.setRoll(roll);
                    result.setAlates(cs.getTimestamp("alates", cal));
                    result.setKuni(cs.getTimestamp("kuni", cal));
                    result.setLoodud(cs.getTimestamp("created", cal));
                    result.setMuudetud(cs.getTimestamp("last_modified", cal));
                    result.setMuutja(cs.getString("username"));
                    result.setPeatatud(cs.getInt("peatatud") > 0);
                    result.setAllyksusID(allyksusID);
                } else {
                    result = null;
                }
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Kasutusoigus", "getByAarID");
            return null;
        }
    }
    
    
    public int addToDB(Connection conn) {    	    	
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call ADD_OIGUS()}");
                cs.registerOutParameter("id", Types.INTEGER);
                CommonMethods.setNullableIntParam(cs, "asutus_id", m_asutusID);
                CommonMethods.setNullableIntParam(cs, "muu_asutus_id", m_muuAsutusID);
                CommonMethods.setNullableIntParam(cs, "ametikoht_id", m_ametikohtID);
                cs.setString("roll", m_roll);
                cs.setTimestamp("alates", CommonMethods.sqlDateFromDate(m_alates), cal);
                cs.setTimestamp("kuni", CommonMethods.sqlDateFromDate(m_kuni), cal);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
                cs.setInt("peatatud", m_peatatud ? 1 : 0);
                CommonMethods.setNullableIntParam(cs, "allyksus_id", m_allyksusID);
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

    public int updateInDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call UPDATE_OIGUS(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt("id", m_id);
                CommonMethods.setNullableIntParam(cs, "asutus_id", m_asutusID);
                CommonMethods.setNullableIntParam(cs, "muu_asutus_id", m_muuAsutusID);
                CommonMethods.setNullableIntParam(cs, "ametikoht_id", m_ametikohtID);
                cs.setString("roll", m_roll);
                cs.setTimestamp("alates", CommonMethods.sqlDateFromDate(m_alates), cal);
                cs.setTimestamp("kuni", CommonMethods.sqlDateFromDate(m_kuni), cal);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
                cs.setInt("peatatud", m_peatatud ? 1 : 0);
                CommonMethods.setNullableIntParam(cs, "allyksus_id", m_allyksusID);
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

    public static int syncWithAar(Kasutusoigus right, AarOigus aarRight, int asutusID, int ametikohtID, int allyksusID, Connection conn) {
        try {
            if (aarRight == null) {
                return 0;
            }
            if (right == null) {
                right = new Kasutusoigus();
            }
            // Kannamae keskregistrist saadud andmed kohaliku
            // andmeobjekti külge
            right.setRoll(aarRight.getOigusNimi());
            right.setAlates(aarRight.getOigusAlates());
            right.setKuni(aarRight.getOigusKuni());
            right.setAsutusID(asutusID);
            right.setAmetikohtID(ametikohtID);
            right.setAllyksusID(allyksusID);
            if (right.getID() <= 0) {
                right.setLoodud(new Date());
            } else {
                right.setMuudetud(new Date());
            }
            right.setMuutja(Settings.Server_CentralRightsDatabasePersonCode);
            right.saveToDB(conn);

            return right.getID();
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Kasutusoigus", "syncWithAar");
            return 0;
        }
    }
    
    /*
    public static ArrayList<String> getPersonCurrentRoles(int personID, int orgID, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_PERSONCURRENTROLES(?,?,?)}");
                cs.setInt("person_id", personID);
                cs.setInt("organization_id", orgID);
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet) cs.getObject("RC1");
                ArrayList<String> result = new ArrayList<String>();
                while (rs.next()) {
                    result.add(rs.getString("roll"));
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return new ArrayList<String>();
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Kasutusoigus", "getPersonCurrentRoles");
            return new ArrayList<String>();
        }
    }
    */
    
}
