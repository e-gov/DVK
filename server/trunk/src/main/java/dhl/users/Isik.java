package dhl.users;

import dhl.aar.iostructures.AarIsik;
import dvk.core.CommonMethods;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import java.util.Calendar;
import java.util.Date;

public class Isik {
    private int m_id;
    private String m_isikukood;
    private String m_perenimi;
    private String m_eesnimi;
    private String m_maakond;
    private String m_aadress;
    private String m_postiIndeks;
    private String m_telefon;
    private String m_epost;
    private String m_www;
    private String m_parameetrid;
    private Date m_loodud;
    private Date m_muudetud;
    private String m_muutja;

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setIsikukood(String isikukood) {
        this.m_isikukood = isikukood;
    }

    public String getIsikukood() {
        return m_isikukood;
    }

    public void setPerenimi(String perenimi) {
        this.m_perenimi = perenimi;
    }

    public String getPerenimi() {
        return m_perenimi;
    }

    public void setEesnimi(String eesnimi) {
        this.m_eesnimi = eesnimi;
    }

    public String getEesnimi() {
        return m_eesnimi;
    }

    public void setMaakond(String maakond) {
        this.m_maakond = maakond;
    }

    public String getMaakond() {
        return m_maakond;
    }

    public void setAadress(String aadress) {
        this.m_aadress = aadress;
    }

    public String getAadress() {
        return m_aadress;
    }

    public void setPostiIndeks(String postiIndeks) {
        this.m_postiIndeks = postiIndeks;
    }

    public String getPostiIndeks() {
        return m_postiIndeks;
    }

    public void setTelefon(String telefon) {
        this.m_telefon = telefon;
    }

    public String getTelefon() {
        return m_telefon;
    }

    public void setEpost(String epost) {
        this.m_epost = epost;
    }

    public String getEpost() {
        return m_epost;
    }

    public void setWww(String www) {
        this.m_www = www;
    }

    public String getWww() {
        return m_www;
    }

    public void setParameetrid(String parameetrid) {
        this.m_parameetrid = parameetrid;
    }

    public String getParameetrid() {
        return m_parameetrid;
    }

    public void setLoodud(Date loodud) {
        this.m_loodud = loodud;
    }

    public Date getLoodud() {
        return m_loodud;
    }

    public void setMuudetud(Date muudetud) {
        this.m_muudetud = muudetud;
    }

    public Date getMuudetud() {
        return m_muudetud;
    }

    public void setMuutja(String muutja) {
        this.m_muutja = muutja;
    }

    public String getMuutja() {
        return m_muutja;
    }

    public Isik() {
        clear();
    }

    public void clear() {
        m_id = 0;
        m_isikukood = "";
        m_perenimi = "";
        m_eesnimi = "";
        m_maakond = "";
        m_aadress = "";
        m_postiIndeks = "";
        m_telefon = "";
        m_epost = "";
        m_www = "";
        m_parameetrid = "";
        m_loodud = null;
        m_muudetud = null;
        m_muutja = "";
    }
    
    public static Isik getByCode(String isikukood, Connection conn) {
        try {
            if (conn != null) {
                Isik result = null;
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_ISIKBYCODE(?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setString("isikukood", isikukood);
                cs.registerOutParameter("perenimi", Types.VARCHAR);
                cs.registerOutParameter("eesnimi", Types.VARCHAR);
                cs.registerOutParameter("maakond", Types.VARCHAR);
                cs.registerOutParameter("aadress", Types.VARCHAR);
                cs.registerOutParameter("postiindeks", Types.VARCHAR);
                cs.registerOutParameter("telefon", Types.VARCHAR);
                cs.registerOutParameter("epost", Types.VARCHAR);
                cs.registerOutParameter("www", Types.VARCHAR);
                cs.registerOutParameter("parameetrid", Types.VARCHAR);
                cs.registerOutParameter("loodud", Types.TIMESTAMP);
                cs.registerOutParameter("muudetud", Types.TIMESTAMP);
                cs.registerOutParameter("muutja", Types.VARCHAR);
                cs.executeUpdate();
                if (cs.getInt("id") > 0) {
                    result = new Isik();
                    result.setId(cs.getInt("id"));
                    result.setIsikukood(isikukood);
                    result.setPerenimi(cs.getString("perenimi"));
                    result.setEesnimi(cs.getString("eesnimi"));
                    result.setMaakond(cs.getString("maakond"));
                    result.setAadress(cs.getString("aadress"));
                    result.setPostiIndeks(cs.getString("postiindeks"));
                    result.setTelefon(cs.getString("telefon"));
                    result.setEpost(cs.getString("epost"));
                    result.setWww(cs.getString("www"));
                    result.setParameetrid(cs.getString("parameetrid"));
                    result.setLoodud(cs.getTimestamp("loodud", cal));
                    result.setMuudetud(cs.getTimestamp("muudetud", cal));
                    result.setMuutja(cs.getString("muutja"));
                }
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Isik", "getIDByCode");
            return null;
        }
    }

    public static int getIDByCode(String isikukood, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_ISIKIDBYCODE(?,?)}");
                cs.setString("isikukood", isikukood);
                cs.registerOutParameter("id", Types.INTEGER);
                cs.executeUpdate();
                int result = cs.getInt("id");
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Isik", "getIDByCode");
            return 0;
        }
    }
    
    public int addToDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call ADD_ISIK(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setString("isikukood", m_isikukood);
                cs.setString("perenimi", m_perenimi);
                cs.setString("eesnimi", m_eesnimi);
                cs.setString("maakond", m_maakond);
                cs.setString("aadress", m_aadress);
                cs.setString("postiindeks", m_postiIndeks);
                cs.setString("telefon", m_telefon);
                cs.setString("epost", m_epost);
                cs.setString("www", m_www);
                cs.setString("parameetrid", m_parameetrid);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
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
                CallableStatement cs = conn.prepareCall("{call UPDATE_ISIK(?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt("id", m_id);
                cs.setString("isikukood", m_isikukood);
                cs.setString("perenimi", m_perenimi);
                cs.setString("eesnimi", m_eesnimi);
                cs.setString("maakond", m_maakond);
                cs.setString("aadress", m_aadress);
                cs.setString("postiindeks", m_postiIndeks);
                cs.setString("telefon", m_telefon);
                cs.setString("epost", m_epost);
                cs.setString("www", m_www);
                cs.setString("parameetrid", m_parameetrid);
                cs.setTimestamp("created", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("last_modified", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("username", m_muutja);
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
    
    public static int syncWithAar(Isik person, AarIsik aarPerson, Connection conn) {
        try {
            if (aarPerson == null) {
                return 0;
            }
            
            if (person == null) {
                person = new Isik();
            }
            
            // Kannamae keskregistrist saadud andmed kohaliku
            // andmeobjekti külge
            person.setIsikukood(aarPerson.getIsikukood());
            person.setPerenimi(aarPerson.getPerenimi());
            person.setEesnimi(aarPerson.getEesnimi());
            person.setTelefon(aarPerson.getTelefon());
            person.setEpost(aarPerson.getEPost());
            person.saveToDB(conn);
            
            return person.getId();
        }
        catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Isik", "syncWithAar");
            return 0;
        }
    }
}
