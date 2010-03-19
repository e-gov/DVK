package dhl.users;

import dhl.aar.iostructures.AarAmetikohaTaitmine;
import dvk.core.CommonMethods;
import dvk.core.Settings;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class AmetikohaTaitmine {
    private int m_id;
    private int m_ametikohtID;
    private int m_isikID;
    private Date m_alates;
    private Date m_kuni;
    private String m_roll;
    private Date m_loodud;
    private Date m_muudetud;
    private String m_muutja;
    private boolean m_peatatud;
    private int m_aarID;

    public int getID() {
        return m_id;
    }

    public void setID(int value) {
        m_id = value;
    }

    public int getAmetikohtID() {
        return m_ametikohtID;
    }

    public void setAmetikohtID(int value) {
        m_ametikohtID = value;
    }

    public int getIsikID() {
        return m_isikID;
    }

    public void setIsikID(int value) {
        m_isikID = value;
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

    public String getRoll() {
        return m_roll;
    }

    public void setRoll(String value) {
        m_roll = value;
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

    public int getAarID() {
        return m_aarID;
    }

    public void setAarID(int value) {
        m_aarID = value;
    }

    public AmetikohaTaitmine() {
        clear();
    }
    
    public void clear() {
        m_id = 0;
        m_ametikohtID = 0;
        m_isikID = 0;
        m_alates = null;
        m_kuni = null;
        m_roll = "";
        m_loodud = null;
        m_muudetud = null;
        m_muutja = "";
        m_peatatud = false;
        m_aarID = 0;
    }
    
    public static AmetikohaTaitmine getByAarID(int aarID, Connection conn) {
        try {
            if (conn != null) {
                AmetikohaTaitmine result = new AmetikohaTaitmine();
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_AMETIKOHATAITMINEBYAARID(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.registerOutParameter("ametikoht_id", Types.INTEGER);
                cs.registerOutParameter("isik_id", Types.INTEGER);
                cs.registerOutParameter("alates", Types.TIMESTAMP);
                cs.registerOutParameter("kuni", Types.TIMESTAMP);
                cs.registerOutParameter("roll", Types.VARCHAR);
                cs.registerOutParameter("created", Types.TIMESTAMP);
                cs.registerOutParameter("last_modified", Types.TIMESTAMP);
                cs.registerOutParameter("username", Types.VARCHAR);
                cs.registerOutParameter("peatatud", Types.INTEGER);
                cs.setInt("aar_id", aarID);
                cs.executeUpdate();
                if (cs.getInt("id") > 0) {
                    result.setID(cs.getInt("id"));
                    result.setAmetikohtID(cs.getInt("ametikoht_id"));
                    result.setIsikID(cs.getInt("isik_id"));
                    result.setAlates(cs.getTimestamp("alates", cal));
                    result.setKuni(cs.getTimestamp("kuni", cal));
                    result.setRoll(cs.getString("roll"));
                    result.setLoodud(cs.getTimestamp("created", cal));
                    result.setMuudetud(cs.getTimestamp("last_modified", cal));
                    result.setMuutja(cs.getString("username"));
                    result.setPeatatud(cs.getInt("peatatud") > 0);
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
            CommonMethods.logError(e, "dhl.users.AmetikohaTaitmine", "getByAarID");
            return null;
        }
    }
    
    public static ArrayList<AmetikohaTaitmine> getList(int jobID, String personCode, Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_AMETIKOHATAITMINELIST(?,?,?)}");
                cs.setInt("ametikoht_id", jobID);
                cs.setString("isikukood", personCode);
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet)cs.getObject("RC1");
                ArrayList<AmetikohaTaitmine> result = new ArrayList<AmetikohaTaitmine>();
                while (rs.next()) {
                    AmetikohaTaitmine item = new AmetikohaTaitmine();
                    item.setID(rs.getInt("taitmine_id"));
                    item.setAmetikohtID(rs.getInt("ametikoht_id"));
                    item.setIsikID(rs.getInt("i_id"));
                    item.setAlates(rs.getTimestamp("alates", cal));
                    item.setKuni(rs.getTimestamp("kuni", cal));
                    item.setRoll(rs.getString("roll"));
                    item.setLoodud(rs.getTimestamp("created", cal));
                    item.setMuudetud(rs.getTimestamp("last_modified", cal));
                    item.setMuutja(rs.getString("username"));
                    item.setPeatatud(rs.getInt("peatatud") > 0);
                    item.setAarID(rs.getInt("aar_id"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.AmetikohaTaitmine", "getList");
            return null;
        }
    }
    
    public int addToDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call ADD_AMETIKOHATAITMINE(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setInt("ametikoht_id", m_ametikohtID);
                cs.setInt("isik_id", m_isikID);
                cs.setTimestamp("alates", CommonMethods.sqlDateFromDate(m_alates), cal);
                cs.setTimestamp("kuni", CommonMethods.sqlDateFromDate(m_kuni), cal);
                cs.setString("roll", m_roll);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
                cs.setInt("peatatud", (m_peatatud ? 1 : 0));
                cs.setInt("aar_id", m_aarID);
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
                CallableStatement cs = conn.prepareCall("{call UPDATE_AMETIKOHATAITMINE(?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt("id", m_id);
                cs.setInt("ametikoht_id", m_ametikohtID);
                cs.setInt("isik_id", m_isikID);
                cs.setTimestamp("alates", CommonMethods.sqlDateFromDate(m_alates), cal);
                cs.setTimestamp("kuni", CommonMethods.sqlDateFromDate(m_kuni), cal);
                cs.setString("roll", m_roll);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
                cs.setInt("peatatud", (m_peatatud ? 1 : 0));
                cs.setInt("aar_id", m_aarID);
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
    
    public static void syncListWithAar(ArrayList<AarAmetikohaTaitmine> aarTaitmised, int ametikohtID, Connection conn) {
        if ((aarTaitmised == null) || (ametikohtID <= 0)) {
            return;
        }
        
        for (int i = 0; i < aarTaitmised.size(); ++i) {
            AarAmetikohaTaitmine aarTaitmine = aarTaitmised.get(i);
            AmetikohaTaitmine taitmine = AmetikohaTaitmine.getByAarID(aarTaitmine.getTaitmineID(), conn);
            if (taitmine == null) {
                ArrayList<AmetikohaTaitmine> taitmised = AmetikohaTaitmine.getList(ametikohtID, aarTaitmine.getIsik().getIsikukood(), conn);
                if ((taitmised != null) && !taitmised.isEmpty()) {
                    for (int j = 0; j < taitmised.size(); ++j) {
                        taitmine = taitmised.get(0);
                    }
                }
            }
            syncWithAar(taitmine, aarTaitmine, ametikohtID, conn);
        }
    }
    
    public static int syncWithAar(AmetikohaTaitmine taitmine, AarAmetikohaTaitmine aarTaitmine, int jobID, Connection conn) {
        try {
            if (aarTaitmine == null) {
                return 0;
            }
            
            int isikID = Isik.getIDByCode(aarTaitmine.getIsik().getIsikukood(), conn);
            if (isikID <= 0) {
                isikID = Isik.syncWithAar(null, aarTaitmine.getIsik(), conn);
            }
            
            if (taitmine == null) {
                taitmine = new AmetikohaTaitmine();
            }
            
            // Kannamae keskregistrist saadud andmed kohaliku
            // andmeobjekti kõlge
            taitmine.setAmetikohtID(jobID);
            taitmine.setIsikID(isikID);
            taitmine.setAlates(aarTaitmine.getAlates());
            taitmine.setKuni(aarTaitmine.getKuni());
            taitmine.setRoll(aarTaitmine.getRoll());
            if (taitmine.getID() <= 0) {
                taitmine.setLoodud(new Date());
            } else {
                taitmine.setMuudetud(new Date());
            }
            taitmine.setMuutja(Settings.Server_CentralRightsDatabasePersonCode);
            taitmine.setAarID(aarTaitmine.getTaitmineID());
            taitmine.saveToDB(conn);
            
            return taitmine.getID();
        }
        catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.AmetikohaTaitmine", "SyncWithAar");
            return 0;
        }
    }
}
