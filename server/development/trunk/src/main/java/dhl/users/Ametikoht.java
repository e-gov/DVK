package dhl.users;

import dhl.aar.iostructures.AarAmetikoht;
import dvk.core.CommonMethods;
import dvk.core.Settings;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

public class Ametikoht {
    private int m_id;
    private int m_ksAmetikohtID;
    private int m_asutusID;
    private String m_nimetus;
    private Date m_alates;
    private Date m_kuni;
    private Date m_created;
    private Date m_lastModified;
    private String m_username;
    private int m_allyksusID;
    private String m_params;
    private int m_aarID;
    private String m_lyhinimetus;

    // Abimuutuja, mida andmebaasi pole vaja salvestada
    private String m_asutusKood;
    private String m_allyksuseLyhinimetus;

    public Ametikoht() {
        clear();
    }

    public int getID() {
        return m_id;
    }

    public void setID(int value) {
        m_id = value;
    }

    public int getKsAmetikohtID() {
        return m_ksAmetikohtID;
    }

    public void setKsAmetikohtID(int value) {
        m_ksAmetikohtID = value;
    }

    public int getAsutusID() {
        return m_asutusID;
    }

    public void setAsutusID(int value) {
        m_asutusID = value;
    }

    public String getNimetus() {
        return m_nimetus;
    }

    public void setNimetus(String value) {
        m_nimetus = value;
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

    public Date getCreated() {
        return m_created;
    }

    public void setCreated(Date value) {
        m_created = value;
    }

    public Date getLastModified() {
        return m_lastModified;
    }

    public void setLastModified(Date value) {
        m_lastModified = value;
    }

    public String getUsername() {
        return m_username;
    }

    public void setUsername(String value) {
        m_username = value;
    }

    public int getAllyksusID() {
        return m_allyksusID;
    }

    public void setAllyksusID(int value) {
        m_allyksusID = value;
    }

    public String getParams() {
        return m_params;
    }

    public void setParams(String value) {
        m_params = value;
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

    public String getAsutusKood() {
        return m_asutusKood;
    }

    public void setAsutusKood(String value) {
        m_asutusKood = value;
    }

    public String getAllyksuseLyhinimetus() {
        return this.m_allyksuseLyhinimetus;
    }

    public void setAllyksuseLyhinimetus(String value) {
        this.m_allyksuseLyhinimetus = value;
    }

    public void clear() {
        m_id = 0;
        m_ksAmetikohtID = 0;
        m_asutusID = 0;
        m_nimetus = "";
        m_alates = null;
        m_kuni = null;
        m_created = null;
        m_lastModified = null;
        m_username = "";
        m_allyksusID = 0;
        m_params = "";
        m_aarID = 0;
        m_lyhinimetus = "";
        m_asutusKood = "";
        m_allyksuseLyhinimetus = "";
    }

    public static Ametikoht getByAarID(int aarID, Connection conn) {
        try {
            if (conn != null) {
                Ametikoht result = new Ametikoht();
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_AMETIKOHTBYAARID(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.registerOutParameter("ks_ametikoht_id", Types.INTEGER);
                cs.registerOutParameter("asutus_id", Types.INTEGER);
                cs.registerOutParameter("nimetus", Types.VARCHAR);
                cs.registerOutParameter("alates", Types.TIMESTAMP);
                cs.registerOutParameter("kuni", Types.TIMESTAMP);
                cs.registerOutParameter("created", Types.TIMESTAMP);
                cs.registerOutParameter("last_modified", Types.TIMESTAMP);
                cs.registerOutParameter("username", Types.VARCHAR);
                cs.registerOutParameter("allyksus_id", Types.INTEGER);
                cs.registerOutParameter("params", Types.VARCHAR);
                cs.registerOutParameter("lyhinimetus", Types.VARCHAR);
                cs.setInt("aar_id", aarID);
                cs.executeUpdate();
                if (cs.getInt("id") > 0) {
                    result.setID(cs.getInt("id"));
                    result.setKsAmetikohtID(cs.getInt("ks_ametikoht_id"));
                    result.setAsutusID(cs.getInt("asutus_id"));
                    result.setNimetus(cs.getString("nimetus"));
                    result.setAlates(cs.getTimestamp("alates", cal));
                    result.setKuni(cs.getTimestamp("kuni", cal));
                    result.setCreated(cs.getTimestamp("created", cal));
                    result.setLastModified(cs.getTimestamp("last_modified", cal));
                    result.setUsername(cs.getString("username"));
                    result.setAllyksusID(cs.getInt("allyksus_id"));
                    result.setParams(cs.getString("params"));
                    result.setLyhinimetus(cs.getString("lyhinimetus"));
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
            CommonMethods.logError(e, "dhl.users.Ametikoht", "getByAarID");
            return null;
        }
    }

    public static int getIdByAarID(int aarID, Connection conn) {
        try {
            if (conn != null) {
                int result = 0;
                CallableStatement cs = conn.prepareCall("{call GET_AMETIKOHTIDBYAARID(?,?)}");
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
            CommonMethods.logError(e, "dhl.users.Ametikoht", "getIdByAarID");
            return 0;
        }
    }

    public static int getIdByShortName(int orgId, String shortName, Connection conn) {
        try {
            if (conn != null) {
                int result = 0;
                CallableStatement cs = conn.prepareCall("{call GET_AMETIKOHTIDBYSHORTNAME(?,?,?)}");
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
            CommonMethods.logError(e, "dhl.users.Ametikoht", "getIdByShortName");
            return 0;
        }
    }

    public static ArrayList<Ametikoht> getList(int orgID, String name, Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_AMETIKOHTLIST(?,?,?)}");
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
                ArrayList<Ametikoht> result = new ArrayList<Ametikoht>();
                while (rs.next()) {
                    Ametikoht item = new Ametikoht();
                    item.setID(rs.getInt("ametikoht_id"));
                    item.setKsAmetikohtID(rs.getInt("ks_ametikoht_id"));
                    item.setAsutusID(rs.getInt("asutus_id"));
                    item.setNimetus(rs.getString("ametikoht_nimetus"));
                    item.setAlates(rs.getTimestamp("alates", cal));
                    item.setKuni(rs.getTimestamp("kuni", cal));
                    item.setCreated(rs.getTimestamp("created", cal));
                    item.setLastModified(rs.getTimestamp("last_modified", cal));
                    item.setUsername(rs.getString("username"));
                    item.setAllyksusID(rs.getInt("allyksus_id"));
                    item.setParams(rs.getString("params"));
                    item.setLyhinimetus(rs.getString("lyhinimetus"));
                    item.setAarID(rs.getInt("aar_id"));
                    item.setAsutusKood(rs.getString("asutuse_kood"));
                    item.setAllyksuseLyhinimetus(rs.getString("allyksuse_lyhinimetus"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Ametikoht", "getList");
            return null;
        }
    }

    public static ArrayList<Integer> getPersonCurrentPositions(int personID, int orgID, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_PERSONCURRENTPOSITIONIDS(?,?,?)}");
                cs.setInt("person_id", personID);
                cs.setInt("organization_id", orgID);
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet) cs.getObject("RC1");
                ArrayList<Integer> result = new ArrayList<Integer>();
                while (rs.next()) {
                    result.add(rs.getInt("ametikoht_id"));
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return new ArrayList<Integer>();
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Ametikoht", "getPersonCurrentPositions");
            return new ArrayList<Integer>();
        }
    }

    public static ArrayList<Integer> getPersonCurrentDivisions(int personID, int orgID, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_PERSONCURRENTDIVISIONIDS(?,?,?)}");
                cs.setInt("person_id", personID);
                cs.setInt("organization_id", orgID);
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet) cs.getObject("RC1");
                ArrayList<Integer> result = new ArrayList<Integer>();
                while (rs.next()) {
                    result.add(rs.getInt("allyksus_id"));
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return new ArrayList<Integer>();
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Ametikoht", "getPersonCurrentDivisions");
            return new ArrayList<Integer>();
        }
    }

    public int addToDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call ADD_AMETIKOHT(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setInt("ks_ametikoht_id", m_ksAmetikohtID);
                cs.setInt("asutus_id", m_asutusID);
                cs.setString("nimetus", m_nimetus);
                cs.setTimestamp("alates", CommonMethods.sqlDateFromDate(m_alates), cal);
                cs.setTimestamp("kuni", CommonMethods.sqlDateFromDate(m_kuni), cal);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_created), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_lastModified), cal);
                cs.setString("username", m_username);
                cs.setInt("allyksus_id", m_allyksusID);
                cs.setString("params", m_params);
                cs.setString("lyhinimetus", m_lyhinimetus);
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
                CallableStatement cs = conn.prepareCall("{call UPDATE_AMETIKOHT(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt("id", m_id);
                cs.setInt("ks_ametikoht_id", m_ksAmetikohtID);
                cs.setInt("asutus_id", m_asutusID);
                cs.setString("nimetus", m_nimetus);
                cs.setTimestamp("alates", CommonMethods.sqlDateFromDate(m_alates), cal);
                cs.setTimestamp("kuni", CommonMethods.sqlDateFromDate(m_kuni), cal);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_created), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_lastModified), cal);
                cs.setString("username", m_username);
                cs.setInt("allyksus_id", m_allyksusID);
                cs.setString("params", m_params);
                cs.setString("lyhinimetus", m_lyhinimetus);
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

    public static int syncWithAar(Ametikoht job, AarAmetikoht aarJob, int orgID, Connection conn) {
        try {
            if (aarJob == null) {
                return 0;
            }

            // Asutuse tuvastamine
            if (orgID <= 0) {
                orgID = Asutus.getIDByAarID(aarJob.getAsutusID(), conn);
            }
            if (orgID <= 0) {
                return 0;
            }

            // Allüksuse tuvastamine
            int allyksusID = 0;
            if (aarJob.getAllyksusID() > 0) {
                Allyksus tmpAY = Allyksus.getByAarID(aarJob.getAllyksusID(), conn);
                if (tmpAY == null) {
                    ArrayList<Allyksus> tmpAYList = Allyksus.getList(orgID, aarJob.getAllyksusNimetus(), conn);
                    if ((tmpAYList != null) && !tmpAYList.isEmpty()) {
                        tmpAY = tmpAYList.get(0);
                    }
                }
                if (tmpAY == null) {
                    Allyksus newAY = new Allyksus();
                    newAY.setAarID(aarJob.getAllyksusID());
                    newAY.setAsutusID(orgID);
                    newAY.setLoodud(new Date());
                    newAY.setNimetus(aarJob.getAllyksusNimetus());
                    allyksusID = newAY.saveToDB(conn);
                }
            }

            if (job == null) {
                job = new Ametikoht();
            }

            // Kannamae keskregistrist saadud andmed kohaliku
            // andmeobjekti külge
            job.setAsutusID(orgID);
            job.setNimetus(aarJob.getNimetus());
            job.setAlates(aarJob.getAlates());
            job.setKuni(aarJob.getKuni());
            if (job.getID() <= 0) {
                job.setCreated(new Date());
            } else {
                job.setLastModified(new Date());
            }
            job.setUsername(Settings.Server_CentralRightsDatabasePersonCode);
            job.setAllyksusID(allyksusID);
            job.setAarID(aarJob.getAmetikohtID());
            int jobID = job.saveToDB(conn);

            // Ametikoha täitmised
            if ((aarJob.getTaitmised() != null) && (aarJob.getTaitmised().size() > 0)) {
                AmetikohaTaitmine.syncListWithAar(aarJob.getTaitmised(), jobID, conn);
            }

            return job.getID();
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Ametikoht", "SyncWithAar");
            return 0;
        }
    }
}
