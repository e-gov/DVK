package dhl.users;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.apache.axis.AxisFault;

import dhl.RemoteServer;
import dhl.aar.AarClient;
import dhl.aar.iostructures.AarAmetikoht;
import dhl.aar.iostructures.AarAsutus;
import dhl.aar.iostructures.AarOigus;
import dvk.client.ClientAPI;
import dvk.client.businesslayer.DhlCapability;
import dvk.client.iostructures.GetSendingOptionsV3ResponseType;
import dvk.core.CommonMethods;
import dvk.core.HeaderVariables;
import dvk.core.Settings;
import dvk.core.xroad.XRoadProtocolHeader;

public class Asutus {
    private int m_id;
    private String m_registrikood;
    private String m_registrikood2;
    private String m_registrikoodVana;
    private int m_ksAsutuseID;
    private String m_ksAsutuseKood;
    private String m_nimetus;
    private String m_nimeLyhend;
    private String m_liik1;
    private String m_liik2;
    private String m_tegevusala;
    private String m_tegevuspiirkond;
    private String m_maakond;
    private String m_asukoht;
    private String m_aadress;
    private String m_postikood;
    private String m_telefon;
    private String m_faks;
    private String m_epost;
    private String m_www;
    private String m_logo;
    private Date m_asutamiseKuupaev;
    private String m_moodustamiseAktiNimi;
    private String m_moodustamiseAktiNumber;
    private Date m_moodustamiseAktiKuupaev;
    private String m_pohimaaruseAktiNimi;
    private String m_pohimaaruseAktiNumber;
    private Date m_pohimaaruseKinnitamiseKuupaev;
    private Date m_pohimaaruseKandeKuupaev;
    private Date m_loodud;
    private Date m_muudetud;
    private String m_muutja;
    private String m_parameetrid;
    private boolean m_dvkSaatmine;
    private boolean m_dvkOtseSaatmine;
    private String m_dhsNimetus;
    private String m_toetatavDVKVersioon;
    private int m_serverID;
    private int m_aarID;
    private String m_kapsel_versioon;

    public Asutus() {
        clear();
    }

    public Asutus(int id, Connection conn) {
        loadByID(id, conn);
    }

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setRegistrikood(String registrikood) {
        this.m_registrikood = registrikood;
    }

    public String getRegistrikood() {
        return m_registrikood;
    }
    
    public void setRegistrikood2(String registrikood2) {
        this.m_registrikood2 = registrikood2;
    }
    
    public String getRegistrikood2() {
    	return m_registrikood2;
    }

    public void setRegistrikoodVana(String registrikoodVana) {
        this.m_registrikoodVana = registrikoodVana;
    }

    public String getRegistrikoodVana() {
        return m_registrikoodVana;
    }

    public void setKsAsutuseID(int ksAsutuseID) {
        this.m_ksAsutuseID = ksAsutuseID;
    }

    public int getKsAsutuseID() {
        return m_ksAsutuseID;
    }

    public void setKsAsutuseKood(String ksAsutuseKood) {
        this.m_ksAsutuseKood = ksAsutuseKood;
    }

    public String getKsAsutuseKood() {
        return m_ksAsutuseKood;
    }

    public void setNimetus(String nimetus) {
        this.m_nimetus = nimetus;
    }

    public String getNimetus() {
        return m_nimetus;
    }

    public void setNimeLyhend(String nimeLyhend) {
        this.m_nimeLyhend = nimeLyhend;
    }

    public String getNimeLyhend() {
        return m_nimeLyhend;
    }

    public void setLiik1(String liik1) {
        this.m_liik1 = liik1;
    }

    public String getLiik1() {
        return m_liik1;
    }

    public void setLiik2(String liik2) {
        this.m_liik2 = liik2;
    }

    public String getLiik2() {
        return m_liik2;
    }

    public void setTegevusala(String tegevusala) {
        this.m_tegevusala = tegevusala;
    }

    public String getTegevusala() {
        return m_tegevusala;
    }

    public void setTegevuspiirkond(String tegevuspiirkond) {
        this.m_tegevuspiirkond = tegevuspiirkond;
    }

    public String getTegevuspiirkond() {
        return m_tegevuspiirkond;
    }

    public void setMaakond(String maakond) {
        this.m_maakond = maakond;
    }

    public String getMaakond() {
        return m_maakond;
    }

    public void setAsukoht(String asukoht) {
        this.m_asukoht = asukoht;
    }

    public String getAsukoht() {
        return m_asukoht;
    }

    public void setAadress(String aadress) {
        this.m_aadress = aadress;
    }

    public String getAadress() {
        return m_aadress;
    }

    public void setPostikood(String postikood) {
        this.m_postikood = postikood;
    }

    public String getPostikood() {
        return m_postikood;
    }

    public void setTelefon(String telefon) {
        this.m_telefon = telefon;
    }

    public String getTelefon() {
        return m_telefon;
    }

    public void setFaks(String faks) {
        this.m_faks = faks;
    }

    public String getFaks() {
        return m_faks;
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

    public void setLogo(String logo) {
        this.m_logo = logo;
    }

    public String getLogo() {
        return m_logo;
    }

    public void setAsutamiseKuupaev(Date asutamiseKuupaev) {
        this.m_asutamiseKuupaev = asutamiseKuupaev;
    }

    public Date getAsutamiseKuupaev() {
        return m_asutamiseKuupaev;
    }

    public void setMoodustamiseAktiNimi(String moodustamiseAktiNimi) {
        this.m_moodustamiseAktiNimi = moodustamiseAktiNimi;
    }

    public String getMoodustamiseAktiNimi() {
        return m_moodustamiseAktiNimi;
    }

    public void setMoodustamiseAktiNumber(String moodustamiseAktiNumber) {
        this.m_moodustamiseAktiNumber = moodustamiseAktiNumber;
    }

    public String getMoodustamiseAktiNumber() {
        return m_moodustamiseAktiNumber;
    }

    public void setMoodustamiseAktiKuupaev(Date moodustamiseAktiKuupaev) {
        this.m_moodustamiseAktiKuupaev = moodustamiseAktiKuupaev;
    }

    public Date getMoodustamiseAktiKuupaev() {
        return m_moodustamiseAktiKuupaev;
    }

    public void setPohimaaruseAktiNimi(String pohimaaruseAktiNimi) {
        this.m_pohimaaruseAktiNimi = pohimaaruseAktiNimi;
    }

    public String getPohimaaruseAktiNimi() {
        return m_pohimaaruseAktiNimi;
    }

    public void setPohimaaruseAktiNumber(String pohimaaruseAktiNumber) {
        this.m_pohimaaruseAktiNumber = pohimaaruseAktiNumber;
    }

    public String getPohimaaruseAktiNumber() {
        return m_pohimaaruseAktiNumber;
    }

    public void setPohimaaruseKinnitamiseKuupaev(Date pohimaaruseKinnitamiseKuupaev) {
        this.m_pohimaaruseKinnitamiseKuupaev = pohimaaruseKinnitamiseKuupaev;
    }

    public Date getPohimaaruseKinnitamiseKuupaev() {
        return m_pohimaaruseKinnitamiseKuupaev;
    }

    public void setPohimaaruseKandeKuupaev(Date pohimaaruseKandeKuupaev) {
        this.m_pohimaaruseKandeKuupaev = pohimaaruseKandeKuupaev;
    }

    public Date getPohimaaruseKandeKuupaev() {
        return m_pohimaaruseKandeKuupaev;
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

    public void setParameetrid(String parameetrid) {
        this.m_parameetrid = parameetrid;
    }

    public String getParameetrid() {
        return m_parameetrid;
    }

    public void setDvkOtseSaatmine(boolean dvkOtseSaatmine) {
        this.m_dvkOtseSaatmine = dvkOtseSaatmine;
    }

    public boolean getDvkOtseSaatmine() {
        return m_dvkOtseSaatmine;
    }

    public void setDvkSaatmine(boolean dvkSaatmine) {
        this.m_dvkSaatmine = dvkSaatmine;
    }

    public boolean getDvkSaatmine() {
        return m_dvkSaatmine;
    }

    public void setDHSNimetus(String dhsNimetus) {
        this.m_dhsNimetus = dhsNimetus;
    }

    public String getDHSNimetus() {
        return m_dhsNimetus;
    }

    public void setToetatavDVKVersioon(String toetatavDVKVersioon) {
        this.m_toetatavDVKVersioon = toetatavDVKVersioon;
    }

    public String getToetatavDVKVersioon() {
        return m_toetatavDVKVersioon;
    }

    public int getServerID() {
        return m_serverID;
    }

    public void setServerID(int serverID) {
        m_serverID = serverID;
    }

    public int getAarID() {
        return m_aarID;
    }

    public void setAarID(int value) {
        m_aarID = value;
    }

    public String getKapselVersioon() {
        return m_kapsel_versioon;
    }

    public void setKapselVersioon(String m_kapsel_versioon) {
        this.m_kapsel_versioon = m_kapsel_versioon;
    }

    public void clear() {
        m_id = 0;
        m_registrikood = "";
        m_registrikood2 = "";
        m_registrikoodVana = "";
        m_ksAsutuseID = 0;
        m_ksAsutuseKood = "";
        m_nimetus = "";
        m_nimeLyhend = "";
        m_liik1 = "";
        m_liik2 = "";
        m_tegevusala = "";
        m_tegevuspiirkond = "";
        m_maakond = "";
        m_asukoht = "";
        m_aadress = "";
        m_postikood = "";
        m_telefon = "";
        m_faks = "";
        m_epost = "";
        m_www = "";
        m_logo = "";
        m_asutamiseKuupaev = null;
        m_moodustamiseAktiNimi = "";
        m_moodustamiseAktiNumber = "";
        m_moodustamiseAktiKuupaev = null;
        m_pohimaaruseAktiNimi = "";
        m_pohimaaruseAktiNumber = "";
        m_pohimaaruseKinnitamiseKuupaev = null;
        m_pohimaaruseKandeKuupaev = null;
        m_loodud = null;
        m_muudetud = null;
        m_muutja = "";
        m_parameetrid = "";
        m_dvkSaatmine = false;
        m_dvkOtseSaatmine = false;
        m_dhsNimetus = "";
        m_toetatavDVKVersioon = "";
        m_serverID = 0;
        m_aarID = 0;
        m_kapsel_versioon = "";
    }
    
    
    
    public void loadByRegNr(String registrikood, Connection conn) {
        try {
            if (conn != null) {   
            	
            	Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("SELECT * FROM \"Get_AsutusByRegNr\"(?)");
                cs.setString(1, String.valueOf(registrikood));
                ResultSet rs = cs.executeQuery();
                
            	/*
            	Calendar cal = Calendar.getInstance();                                                        
                Statement cs = conn.createStatement();                                
                ResultSet rs = cs.executeQuery("SELECT * FROM \"Get_AsutusByRegNr\"(" + String.valueOf(registrikood) + ")");
            	*/
                while (rs.next()) {

	                m_id = rs.getInt("id");
	                m_registrikood = registrikood;
	                m_registrikood2 = rs.getString("registrikood2");
	                m_registrikoodVana = rs.getString("e_registrikood");
	                m_ksAsutuseID = rs.getInt("ks_asutus_id");
	                m_ksAsutuseKood = rs.getString("ks_asutus_kood");
	                m_nimetus = rs.getString("nimetus");
	                m_nimeLyhend = rs.getString("lnimi");
	                m_liik1 = rs.getString("liik1");
	                m_liik2 = rs.getString("liik2");
	                m_tegevusala = rs.getString("tegevusala");
	                m_tegevuspiirkond = rs.getString("tegevuspiirkond");
	                m_maakond = rs.getString("maakond");
	                m_asukoht = rs.getString("asukoht");
	                m_aadress = rs.getString("aadress");
	                m_postikood = rs.getString("postikood");
	                m_telefon = rs.getString("telefon");
	                m_faks = rs.getString("faks");
	                m_epost = rs.getString("e_post");
	                m_www = rs.getString("www");
	                m_logo = rs.getString("logo");
	                m_asutamiseKuupaev = rs.getTimestamp("asutamise_kp", cal);
	                m_moodustamiseAktiNimi = rs.getString("mood_akt_nimi");
	                m_moodustamiseAktiNumber = rs.getString("mood_akt_nr");
	                m_moodustamiseAktiKuupaev = rs.getTimestamp("mood_akt_kp", cal);
	                m_pohimaaruseAktiNimi = rs.getString("pm_akt_nimi");
	                m_pohimaaruseAktiNumber = rs.getString("pm_akt_nr");
	                m_pohimaaruseKinnitamiseKuupaev = rs.getTimestamp("pm_kinnitamise_kp", cal);
	                m_pohimaaruseKandeKuupaev = rs.getTimestamp("pm_kande_kp", cal);
	                m_loodud = rs.getTimestamp("created", cal);
	                m_muudetud = rs.getTimestamp("last_modified", cal);
	                m_muutja = rs.getString("username");
	                m_parameetrid = rs.getString("params");
	                m_dvkSaatmine = rs.getInt("dhl_saatmine") > 0;
	                m_dvkOtseSaatmine = rs.getInt("dhl_otse_saatmine") > 0;
	                m_dhsNimetus = rs.getString("dhs_nimetus");
	                m_toetatavDVKVersioon = rs.getString("toetatav_dvk_versioon");
	                m_serverID = rs.getInt("server_id");
	                m_aarID = rs.getInt("aar_id");
	                m_kapsel_versioon = rs.getString("kapsel_versioon");	                
                }
                rs.close();
                cs.close();
            } else {
                clear();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "loadByRegNr");
            clear();
        }
    }
    
    public void loadByID(int id, Connection conn) {    	
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();                                                        
                Statement cs = conn.createStatement();
                ResultSet rs = cs.executeQuery("SELECT * FROM \"Get_AsutusByID\"(" + id + ")");
                while (rs.next()) {
                    m_registrikood = rs.getString("registrikood");
                    m_registrikood2 = rs.getString("registrikood2");
                    m_registrikoodVana = rs.getString("registrikood_vana");
                    m_ksAsutuseID = rs.getInt("ks_asutus_id");
                    m_ksAsutuseKood = rs.getString("ks_asutus_kood");
                    m_nimetus = rs.getString("nimetus");
                    m_nimeLyhend = rs.getString("nime_lyhend");
                    m_liik1 = rs.getString("liik1");
                    m_liik2 = rs.getString("liik2");
                    m_tegevusala = rs.getString("tegevusala");
                    m_tegevuspiirkond = rs.getString("tegevuspiirkond");
                    m_maakond = rs.getString("maakond");
                    m_asukoht = rs.getString("asukoht");
                    m_aadress = rs.getString("aadress");
                    m_postikood = rs.getString("postikood");
                    m_telefon = rs.getString("telefon");
                    m_faks = rs.getString("faks");
                    m_epost = rs.getString("e_post");
                    m_www = rs.getString("www");
                    m_logo = rs.getString("logo");
                    m_asutamiseKuupaev = rs.getTimestamp("asutamise_kp", cal);
                    m_moodustamiseAktiNimi = rs.getString("mood_akt_nimi");
                    m_moodustamiseAktiNumber = rs.getString("mood_akt_nr");
                    m_moodustamiseAktiKuupaev = rs.getTimestamp("mood_akt_kp", cal);
                    m_pohimaaruseAktiNimi = rs.getString("pm_akt_nimi");
                    m_pohimaaruseAktiNumber = rs.getString("pm_akt_nr");
                    m_pohimaaruseKinnitamiseKuupaev = rs.getTimestamp("pm_kinnitamise_kp", cal);
                    m_pohimaaruseKandeKuupaev = rs.getTimestamp("pm_kande_kp", cal);
                    m_loodud = rs.getTimestamp("loodud", cal);
                    m_muudetud = rs.getTimestamp("muudetud", cal);
                    m_muutja = rs.getString("muutja");
                    m_parameetrid = rs.getString("parameetrid");
                    m_dvkSaatmine = rs.getInt("dhl_saatmine") > 0;
                    m_dvkOtseSaatmine = rs.getInt("dhl_otse_saatmine") > 0;
                    m_dhsNimetus = rs.getString("dhs_nimetus");
                    m_toetatavDVKVersioon = rs.getString("toetatav_dvk_versioon");
                    m_serverID = rs.getInt("server_id");
                    m_aarID = rs.getInt("aar_id");
                    m_kapsel_versioon = rs.getString("kapsel_versioon");                    
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

    public static int getIDByRegNr(String registrikood, boolean ainultDvkVoimelised, Connection conn) throws AxisFault {
        try {        	
            if (conn != null) {
            	CallableStatement cs = conn.prepareCall("{? = call \"Get_AsutusIdByRegNr\"(?,?)}");
                cs.registerOutParameter(1, Types.INTEGER);                
                cs.setString(2, registrikood);
                cs.setInt(3, (ainultDvkVoimelised ? 1 : 0));               
                cs.execute();                
                int result = cs.getInt(1);
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Asutus", "getIDByRegNr");
            throw new AxisFault(e.getMessage());
        }
    }
    

    public static int getIDByAarID(int aarID, Connection conn) throws AxisFault {
        try {
            if (conn != null) {            	
            	CallableStatement cs = conn.prepareCall("{? = call \"Get_AsutusIdByAarID\"(?)}");
                cs.registerOutParameter(1, Types.INTEGER);                
                cs.setInt(2, aarID);                
                cs.execute();                
                int result = cs.getInt(1);
                cs.close();
                return result;            	
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Asutus", "getIDByAarID");
            throw new AxisFault(e.getMessage());
        }
    }

    
    
    public static ArrayList<Asutus> getList(Connection conn) {    	
        try {
            if (conn != null) {
            	Calendar cal = Calendar.getInstance();
            	boolean defaultAutoCommit = conn.getAutoCommit();
            	try{
	            	conn.setAutoCommit(false);            	
	            	CallableStatement cs = conn.prepareCall("{? = call \"Get_AsutusList\"()}");
	            	cs.registerOutParameter(1, Types.OTHER);            	
	                cs.execute();
            	
	                ResultSet rs = (ResultSet) cs.getObject(1);	                
	                ArrayList<Asutus> result = new ArrayList<Asutus>();
	                while (rs.next()) {
	                    Asutus item = new Asutus();
	                    item.setId(rs.getInt("asutus_id"));
	                    item.setRegistrikood(rs.getString("registrikood"));
	                    item.setRegistrikood2(rs.getString("registrikood2"));
	                    item.setRegistrikoodVana(rs.getString("e_registrikood"));
	                    item.setKsAsutuseID(rs.getInt("ks_asutus_id"));
	                    item.setKsAsutuseKood(rs.getString("ks_asutus_kood"));
	                    item.setNimetus(rs.getString("nimetus"));
	                    item.setNimeLyhend(rs.getString("lnimi"));
	                    item.setLiik1(rs.getString("liik1"));
	                    item.setLiik2(rs.getString("liik2"));
	                    item.setTegevusala(rs.getString("tegevusala"));
	                    item.setTegevuspiirkond(rs.getString("tegevuspiirkond"));
	                    item.setMaakond(rs.getString("maakond"));
	                    item.setAsukoht(rs.getString("asukoht"));
	                    item.setAadress(rs.getString("aadress"));
	                    item.setPostikood(rs.getString("postikood"));
	                    item.setTelefon(rs.getString("telefon"));
	                    item.setFaks(rs.getString("faks"));
	                    item.setEpost(rs.getString("e_post"));
	                    item.setWww(rs.getString("www"));
	                    item.setLogo(rs.getString("logo"));
	                    item.setAsutamiseKuupaev(rs.getTimestamp("asutamise_kp", cal));
	                    item.setMoodustamiseAktiNimi(rs.getString("mood_akt_nimi"));
	                    item.setMoodustamiseAktiNumber(rs.getString("mood_akt_nr"));
	                    item.setMoodustamiseAktiKuupaev(rs.getTimestamp("mood_akt_kp", cal));
	                    item.setPohimaaruseAktiNimi(rs.getString("pm_akt_nimi"));
	                    item.setPohimaaruseAktiNumber(rs.getString("pm_akt_nr"));
	                    item.setPohimaaruseKinnitamiseKuupaev(rs.getTimestamp("pm_kinnitamise_kp", cal));
	                    item.setPohimaaruseKandeKuupaev(rs.getTimestamp("pm_kande_kp", cal));
	                    item.setLoodud(rs.getTimestamp("created", cal));
	                    item.setMuudetud(rs.getTimestamp("last_modified", cal));
	                    item.setMuutja(rs.getString("username"));
	                    item.setParameetrid(rs.getString("params"));
	                    item.setDvkSaatmine(rs.getInt("dhl_saatmine") > 0);
	                    item.setDvkOtseSaatmine(rs.getInt("dhl_otse_saatmine") > 0);
	                    item.setDHSNimetus(rs.getString("dhs_nimetus"));
	                    item.setToetatavDVKVersioon(rs.getString("toetatav_dvk_versioon"));
	                    item.setServerID(rs.getInt("server_id"));
	                    item.setAarID(rs.getInt("aar_id"));
	                    item.setKapselVersioon(rs.getString("kapsel_versioon"));
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
            CommonMethods.logError(ex, "dhl.users.Asutus", "getList");
            return null;
        }
    }
    

    
    public void addToDB(Connection conn, XRoadProtocolHeader xTeePais) {    	
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                

                CallableStatement cs = conn.prepareCall("{? = call \"Add_Asutus\"(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter(1, Types.INTEGER);

                cs.setString(2, m_registrikood);
                cs.setString(3, m_registrikood2);
                cs.setString(4, m_registrikoodVana);
                CommonMethods.setNullableIntParam(cs, 5, m_ksAsutuseID);
                cs.setString(6, m_ksAsutuseKood);
                cs.setString(7, m_nimetus);
                cs.setString(8, m_nimeLyhend);
                cs.setString(9, m_liik1);
                cs.setString(10, m_liik2);
                cs.setString(11, m_tegevusala);
                cs.setString(12, m_tegevuspiirkond);
                cs.setString(13, m_maakond);
                cs.setString(14, m_asukoht);
                cs.setString(15, m_aadress);
                cs.setString(16, m_postikood);
                cs.setString(17, m_telefon);
                cs.setString(18, m_faks);
                cs.setString(19, m_epost);
                cs.setString(20, m_www);
                cs.setString(21, m_logo);
                cs.setTimestamp(22, CommonMethods.sqlDateFromDate(m_asutamiseKuupaev), cal);
                cs.setString(23, m_moodustamiseAktiNimi);
                cs.setString(24, m_moodustamiseAktiNumber);
                cs.setTimestamp(25, CommonMethods.sqlDateFromDate(m_moodustamiseAktiKuupaev), cal);
                cs.setString(26, m_pohimaaruseAktiNimi);
                cs.setString(27, m_pohimaaruseAktiNumber);
                cs.setTimestamp(28, CommonMethods.sqlDateFromDate(m_pohimaaruseKinnitamiseKuupaev), cal);
                cs.setTimestamp(29, CommonMethods.sqlDateFromDate(m_pohimaaruseKandeKuupaev), cal);
                cs.setTimestamp(30, CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp(31, CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString(32, m_muutja);
                cs.setString(33, m_parameetrid);
                cs.setInt(34, m_dvkSaatmine ? 1 : 0);
                cs.setInt(35, m_dvkOtseSaatmine ? 1 : 0);
                cs.setString(36, m_dhsNimetus);
                cs.setString(37, m_toetatavDVKVersioon);

                CommonMethods.setNullableIntParam(cs, 38, m_serverID);
                CommonMethods.setNullableIntParam(cs, 39, m_aarID);

                if (xTeePais != null) {
                    cs.setString(40, xTeePais.getUserId());
                    cs.setString(41, xTeePais.getConsumer());
                } else {
                    cs.setString(40, null);
                    cs.setString(41, null);
                }
                
                cs.setString(42, m_kapsel_versioon);
                cs.execute();
                m_id = cs.getInt(1);
                cs.close();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "addToDB");
            clear();
        }
    }
    
    public void updateInDB(Connection conn, XRoadProtocolHeader xTeePais) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall(
                		"{call \"Update_Asutus\"(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                
                cs.setInt(1, m_id);
                cs.setString(2, m_registrikood);
                cs.setString(3, m_registrikood2);
                cs.setString(4, m_registrikoodVana);
                CommonMethods.setNullableIntParam(cs, 5, m_ksAsutuseID);
                cs.setString(6, m_ksAsutuseKood);
                cs.setString(7, m_nimetus);
                cs.setString(8, m_nimeLyhend);
                cs.setString(9, m_liik1);
                cs.setString(10, m_liik2);
                cs.setString(11, m_tegevusala);
                cs.setString(12, m_tegevuspiirkond);
                cs.setString(13, m_maakond);
                cs.setString(14, m_asukoht);
                cs.setString(15, m_aadress);
                cs.setString(16, m_postikood);
                cs.setString(17, m_telefon);
                cs.setString(18, m_faks);
                cs.setString(19, m_epost);
                cs.setString(20, m_www);
                cs.setString(21, m_logo);
                cs.setTimestamp(22, CommonMethods.sqlDateFromDate(m_asutamiseKuupaev), cal);
                cs.setString(23, m_moodustamiseAktiNimi);
                cs.setString(24, m_moodustamiseAktiNumber);
                cs.setTimestamp(25, CommonMethods.sqlDateFromDate(m_moodustamiseAktiKuupaev), cal);
                cs.setString(26, m_pohimaaruseAktiNimi);
                cs.setString(27, m_pohimaaruseAktiNumber);
                cs.setTimestamp(28, CommonMethods.sqlDateFromDate(m_pohimaaruseKinnitamiseKuupaev), cal);
                cs.setTimestamp(29, CommonMethods.sqlDateFromDate(m_pohimaaruseKandeKuupaev), cal);
                cs.setTimestamp(30, CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp(31, CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString(32, m_muutja);
                cs.setString(33, m_parameetrid);
                cs.setInt(34, m_dvkSaatmine ? 1 : 0);
                cs.setInt(35, m_dvkOtseSaatmine ? 1 : 0);
                cs.setString(36, m_dhsNimetus);
                cs.setString(37, m_toetatavDVKVersioon);

                CommonMethods.setNullableIntParam(cs, 38, m_serverID);
                CommonMethods.setNullableIntParam(cs, 39, m_aarID);
                
                if (xTeePais != null) {
                    cs.setString(40, xTeePais.getUserId());
                    cs.setString(41, xTeePais.getConsumer());
                } else {
                    cs.setString(40, null);
                    cs.setString(41, null);
                }
                cs.setString(42, m_kapsel_versioon);
                cs.execute();
                cs.close();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "updateInDB");
            clear();
        }
    }

    public void saveToDB(Connection conn, XRoadProtocolHeader xTeePais) {
        if (m_id > 0) {
            updateInDB(conn, xTeePais);
        } else {
            addToDB(conn, xTeePais);
        }
    }

    /**
     * Laeb kõigist teistest teadaolevatest serveritest asutuste nimekirjad
     * ja sünkroniseerib kohaliku asutuste registri saadud andmetega.
     */
    public static void getOrgsFromAllKnownServers(String orgCodeToFind, Connection conn, XRoadProtocolHeader xTeePais) throws Exception {
        boolean foundMissingOrg = false;
        ArrayList<RemoteServer> servers = RemoteServer.getList(conn);
        if (!servers.isEmpty()) {
            ClientAPI dvkClient = new ClientAPI();
            for (int i = 0; i < servers.size(); ++i) {
                RemoteServer server = servers.get(i);
                dvkClient.initClient(server.getAddress(), server.getProducerName());
                HeaderVariables header = new HeaderVariables(
                        Settings.Client_DefaultOrganizationCode,
                        Settings.Client_DefaultPersonCode,
                        "",
                        CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode)
                                ? Settings.Client_DefaultPersonCode : "EE" + Settings.Client_DefaultPersonCode);

                try {
                    GetSendingOptionsV3ResponseType result = dvkClient.getSendingOptions(header, null, null, null, false, -1, -1, 1);
                    if ((result != null) && (result.asutused != null)) {
                        for (int j = 0; j < result.asutused.size(); ++j) {
                            DhlCapability item = result.asutused.get(j);
                            int testID = getIDByRegNr(item.getOrgCode(), false, conn);
                            if (testID <= 0) {
                                Asutus newOrg = new Asutus();
                                newOrg.setRegistrikood(item.getOrgCode());
                                newOrg.setNimetus(item.getOrgName());
                                newOrg.setDvkSaatmine(item.getIsDhlCapable());
                                newOrg.setDvkOtseSaatmine(item.getIsDhlDirectCapable());
                                newOrg.setServerID(server.getID());
                                newOrg.addToDB(conn, xTeePais);
                                if ((orgCodeToFind != null)
                                        && !orgCodeToFind.equalsIgnoreCase("") && (orgCodeToFind == item.getOrgCode())) {
                                    foundMissingOrg = true;
                                }
                            }
                        }
                    }
                } catch (Exception ex) {
                    CommonMethods.logError(ex, "dhl.users.Asutus", "getOrgsFromAllKnownServers");
                }

                // If we found the necessary organization then let's not bother another server
                if (foundMissingOrg) {
                    return;
                }
            }
        }
    }

    public static void runAarSyncronization(Connection conn) {
        try {
            // Asutuste sünkroniseerimine
            ArrayList<Asutus> orgs = getList(conn);
            ArrayList<String> orgCodes = new ArrayList<String>();
            for (int i = 0; i < orgs.size(); ++i) {
                orgCodes.add(orgs.get(i).getRegistrikood());
            }

            AarClient aarClient = new AarClient(
                    Settings.Server_CentralRightsDatabaseURL,
                    Settings.Server_CentralRightsDatabaseOrgCode,
                    Settings.Server_CentralRightsDatabasePersonCode);
            ArrayList<AarAsutus> aarOrgs = aarClient.asutusedRequest(orgCodes, null);

            AarAsutus aarOrg = null;
            boolean found = false;
            for (int i = 0; i < aarOrgs.size(); ++i) {
                aarOrg = aarOrgs.get(i);
                found = false;
                for (int j = 0; j < orgs.size(); ++j) {
                    if (orgs.get(j).getRegistrikood().equalsIgnoreCase(aarOrg.getRegistrikood())) {
                        found = true;
                        aarOrgs.get(i).setDvkID(syncWithAar(orgs.get(j), aarOrg, conn));
                        break;
                    }
                }
                if (!found) {
                    aarOrgs.get(i).setDvkID(syncWithAar(null, aarOrg, conn));
                }
            }

            // Ametikohtade sünkroniseerimine
            for (int i = 0; i < aarOrgs.size(); ++i) {
                aarOrg = aarOrgs.get(i);
                if (aarOrg.getAmetikohad() != null) {
                    for (int j = 0; j < aarOrg.getAmetikohad().size(); ++j) {
                        AarAmetikoht aarJob = aarOrg.getAmetikohad().get(j);
                        Ametikoht tmpJob = Ametikoht.getByAarID(aarJob.getAmetikohtID(), conn);
                        if (tmpJob == null) {
                            ArrayList<Ametikoht> tmpJobs = Ametikoht.getList(aarOrg.getDvkID(), aarJob.getNimetus(), conn);
                            if (!tmpJobs.isEmpty()) {
                                tmpJob = tmpJobs.get(0);
                            }
                        }
                        Ametikoht.syncWithAar(tmpJob, aarJob, aarOrg.getDvkID(), conn);
                    }
                }
            }

            // Õiguste sünkroniseerimine
            for (int i = 0; i < aarOrgs.size(); ++i) {
                aarOrg = aarOrgs.get(i);
                ArrayList<AarOigus> aarRights = aarClient.oigusedRequest(aarOrg.getRegistrikood(), 0, "");
                if (aarRights != null) {
                    for (int j = 0; j < aarRights.size(); ++j) {
                        AarOigus aarRight = aarRights.get(j);
                        int ametikohtID = Ametikoht.getIdByAarID(aarRight.getAmetikohtID(), conn);
                        int allyksusID = Allyksus.getIdByAarID(aarRight.getAllyksusID(), conn);
                        Kasutusoigus right = Kasutusoigus.getFromDB(
                                aarRight.getOigusNimi(), aarOrg.getDvkID(), ametikohtID, allyksusID, conn);
                        Kasutusoigus.syncWithAar(right, aarRight, aarOrg.getDvkID(), ametikohtID, allyksusID, conn);
                    }
                }
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Asutus", "runAarSyncronization");
        }
    }

    private static int syncWithAar(Asutus org, AarAsutus aarOrg, Connection conn) {
        try {
            if (aarOrg == null) {
                return 0;
            }

            // Kõrgemalseisva asutuse andmed
            int topOrgID = 0;
            if (aarOrg.getKsAsutusID() > 0) {
                boolean getTopOrgData = true;
                if ((aarOrg.getKsAsutusKood() != null) && !aarOrg.getKsAsutusKood().equalsIgnoreCase("")) {
                    topOrgID = getIDByRegNr(aarOrg.getRegistrikood(), false, conn);
                    if (topOrgID > 0) {
                        getTopOrgData = false;
                    }
                }

                // Kui antud asutuse kõrgemalseisva asutuse andmeid kohalikus
                // asutuste registris ei ole, siis laeme need keskregistrist
                // ja salvestame kohalikku registrisse.
                if (getTopOrgData) {
                    AarClient aarClient = new AarClient(
                            Settings.Server_CentralRightsDatabaseURL,
                            Settings.Server_CentralRightsDatabaseOrgCode,
                            Settings.Server_CentralRightsDatabasePersonCode);
                    ArrayList<Integer> topOrgIDs = new ArrayList<Integer>();
                    ArrayList<AarAsutus> aarOrgs = aarClient.asutusedRequest(null, topOrgIDs);
                    if ((aarOrgs != null) && (aarOrgs.size() > 0)) {
                        topOrgID = syncWithAar(null, aarOrgs.get(0), conn);
                    }
                }
            }

            if (org == null) {
                org = new Asutus();
            }

            // Kannamae keskregistrist saadud andmed kohaliku
            // andmeobjekti külge
            org.setRegistrikood(aarOrg.getRegistrikood());
            org.setAarID(aarOrg.getAsutusID());
            org.setKsAsutuseID(topOrgID);
            org.setKsAsutuseKood(aarOrg.getKsAsutusKood());
            org.setNimetus(aarOrg.getNimetus());
            org.setLiik1(aarOrg.getLiik1());
            org.setLiik2(aarOrg.getLiik2());
            org.setMaakond(aarOrg.getMaakond());
            org.setAsukoht(aarOrg.getAsukoht());
            org.setAadress(aarOrg.getAadress());
            org.setPostikood(aarOrg.getPostikood());
            org.setTelefon(aarOrg.getTelefon());
            org.setEpost(aarOrg.getEPost());
            org.setWww(aarOrg.getWww());
            org.setAsutamiseKuupaev(aarOrg.getAsutamiseKp());
            org.saveToDB(conn, null);


            return org.getId();
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Asutus", "SyncWithAar");
            return 0;
        }
    }
    
    
    /*
    public void loadByID(int id, Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall(
                        "{call GET_ASUTUSBYID(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt("id", id);
                cs.registerOutParameter("registrikood", Types.VARCHAR);
                cs.registerOutParameter("registrikood_vana", Types.VARCHAR);
                cs.registerOutParameter("ks_asutuse_id", Types.INTEGER);
                cs.registerOutParameter("ks_asutuse_kood", Types.VARCHAR);
                cs.registerOutParameter("nimetus", Types.VARCHAR);
                cs.registerOutParameter("nime_lyhend", Types.VARCHAR);
                cs.registerOutParameter("liik1", Types.VARCHAR);
                cs.registerOutParameter("liik2", Types.VARCHAR);
                cs.registerOutParameter("tegevusala", Types.VARCHAR);
                cs.registerOutParameter("tegevuspiirkond", Types.VARCHAR);
                cs.registerOutParameter("maakond", Types.VARCHAR);
                cs.registerOutParameter("asukoht", Types.VARCHAR);
                cs.registerOutParameter("aadress", Types.VARCHAR);
                cs.registerOutParameter("postikood", Types.VARCHAR);
                cs.registerOutParameter("telefon", Types.VARCHAR);
                cs.registerOutParameter("faks", Types.VARCHAR);
                cs.registerOutParameter("e_post", Types.VARCHAR);
                cs.registerOutParameter("www", Types.VARCHAR);
                cs.registerOutParameter("logo", Types.VARCHAR);
                cs.registerOutParameter("asutamise_kp", Types.TIMESTAMP);
                cs.registerOutParameter("mood_akt_nimi", Types.VARCHAR);
                cs.registerOutParameter("mood_akt_nr", Types.VARCHAR);
                cs.registerOutParameter("mood_akt_kp", Types.TIMESTAMP);
                cs.registerOutParameter("pm_akt_nimi", Types.VARCHAR);
                cs.registerOutParameter("pm_akt_nr", Types.VARCHAR);
                cs.registerOutParameter("pm_kinnitamise_kp", Types.TIMESTAMP);
                cs.registerOutParameter("pm_kande_kp", Types.TIMESTAMP);
                cs.registerOutParameter("loodud", Types.TIMESTAMP);
                cs.registerOutParameter("muudetud", Types.TIMESTAMP);
                cs.registerOutParameter("muutja", Types.VARCHAR);
                cs.registerOutParameter("parameetrid", Types.VARCHAR);
                cs.registerOutParameter("dhl_saatmine", Types.INTEGER);
                cs.registerOutParameter("dhl_otse_saatmine", Types.INTEGER);
                cs.registerOutParameter("dhs_nimetus", Types.VARCHAR);
                cs.registerOutParameter("toetatav_dvk_versioon", Types.VARCHAR);
                cs.registerOutParameter("server_id", Types.INTEGER);
                cs.registerOutParameter("aar_id", Types.INTEGER);
                cs.registerOutParameter("kapsel_versioon", Types.VARCHAR);
                cs.executeUpdate();
                m_id = id;
                m_registrikood = cs.getString("registrikood");
                m_registrikoodVana = cs.getString("registrikood_vana");
                m_ksAsutuseID = cs.getInt("ks_asutuse_id");
                m_ksAsutuseKood = cs.getString("ks_asutuse_kood");
                m_nimetus = cs.getString("nimetus");
                m_nimeLyhend = cs.getString("nime_lyhend");
                m_liik1 = cs.getString("liik1");
                m_liik2 = cs.getString("liik2");
                m_tegevusala = cs.getString("tegevusala");
                m_tegevuspiirkond = cs.getString("tegevuspiirkond");
                m_maakond = cs.getString("maakond");
                m_asukoht = cs.getString("asukoht");
                m_aadress = cs.getString("aadress");
                m_postikood = cs.getString("postikood");
                m_telefon = cs.getString("telefon");
                m_faks = cs.getString("faks");
                m_epost = cs.getString("e_post");
                m_www = cs.getString("www");
                m_logo = cs.getString("logo");
                m_asutamiseKuupaev = cs.getTimestamp("asutamise_kp", cal);
                m_moodustamiseAktiNimi = cs.getString("mood_akt_nimi");
                m_moodustamiseAktiNumber = cs.getString("mood_akt_nr");
                m_moodustamiseAktiKuupaev = cs.getTimestamp("mood_akt_kp", cal);
                m_pohimaaruseAktiNimi = cs.getString("pm_akt_nimi");
                m_pohimaaruseAktiNumber = cs.getString("pm_akt_nr");
                m_pohimaaruseKinnitamiseKuupaev = cs.getTimestamp("pm_kinnitamise_kp", cal);
                m_pohimaaruseKandeKuupaev = cs.getTimestamp("pm_kande_kp", cal);
                m_loodud = cs.getTimestamp("loodud", cal);
                m_muudetud = cs.getTimestamp("muudetud", cal);
                m_muutja = cs.getString("muutja");
                m_parameetrid = cs.getString("parameetrid");
                m_dvkSaatmine = cs.getInt("dhl_saatmine") > 0;
                m_dvkOtseSaatmine = cs.getInt("dhl_otse_saatmine") > 0;
                m_dhsNimetus = cs.getString("dhs_nimetus");
                m_toetatavDVKVersioon = cs.getString("toetatav_dvk_versioon");
                m_serverID = cs.getInt("server_id");
                m_aarID = cs.getInt("aar_id");
                m_kapsel_versioon = cs.getString("kapsel_versioon");
                cs.close();
            } else {
                clear();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "loadByID");
            clear();
        }
    }
    */
    /*
    public void loadByRegNr(String registrikood, Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall(
                        "{call GET_ASUTUSBYREGNR(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setString("registrikood", registrikood);
                cs.registerOutParameter("id", Types.INTEGER);
                cs.registerOutParameter("registrikood_vana", Types.VARCHAR);
                cs.registerOutParameter("ks_asutuse_id", Types.INTEGER);
                cs.registerOutParameter("ks_asutuse_kood", Types.VARCHAR);
                cs.registerOutParameter("nimetus", Types.VARCHAR);
                cs.registerOutParameter("nime_lyhend", Types.VARCHAR);
                cs.registerOutParameter("liik1", Types.VARCHAR);
                cs.registerOutParameter("liik2", Types.VARCHAR);
                cs.registerOutParameter("tegevusala", Types.VARCHAR);
                cs.registerOutParameter("tegevuspiirkond", Types.VARCHAR);
                cs.registerOutParameter("maakond", Types.VARCHAR);
                cs.registerOutParameter("asukoht", Types.VARCHAR);
                cs.registerOutParameter("aadress", Types.VARCHAR);
                cs.registerOutParameter("postikood", Types.VARCHAR);
                cs.registerOutParameter("telefon", Types.VARCHAR);
                cs.registerOutParameter("faks", Types.VARCHAR);
                cs.registerOutParameter("e_post", Types.VARCHAR);
                cs.registerOutParameter("www", Types.VARCHAR);
                cs.registerOutParameter("logo", Types.VARCHAR);
                cs.registerOutParameter("asutamise_kp", Types.TIMESTAMP);
                cs.registerOutParameter("mood_akt_nimi", Types.VARCHAR);
                cs.registerOutParameter("mood_akt_nr", Types.VARCHAR);
                cs.registerOutParameter("mood_akt_kp", Types.TIMESTAMP);
                cs.registerOutParameter("pm_akt_nimi", Types.VARCHAR);
                cs.registerOutParameter("pm_akt_nr", Types.VARCHAR);
                cs.registerOutParameter("pm_kinnitamise_kp", Types.TIMESTAMP);
                cs.registerOutParameter("pm_kande_kp", Types.TIMESTAMP);
                cs.registerOutParameter("loodud", Types.TIMESTAMP);
                cs.registerOutParameter("muudetud", Types.TIMESTAMP);
                cs.registerOutParameter("muutja", Types.VARCHAR);
                cs.registerOutParameter("parameetrid", Types.VARCHAR);
                cs.registerOutParameter("dhl_saatmine", Types.INTEGER);
                cs.registerOutParameter("dhl_otse_saatmine", Types.INTEGER);
                cs.registerOutParameter("dhs_nimetus", Types.VARCHAR);
                cs.registerOutParameter("toetatav_dvk_versioon", Types.VARCHAR);
                cs.registerOutParameter("server_id", Types.INTEGER);
                cs.registerOutParameter("aar_id", Types.INTEGER);
                cs.registerOutParameter("kapsel_versioon", Types.VARCHAR);
                cs.executeUpdate();
                m_id = cs.getInt("id");
                m_registrikood = registrikood;
                m_registrikoodVana = cs.getString("registrikood_vana");
                m_ksAsutuseID = cs.getInt("ks_asutuse_id");
                m_ksAsutuseKood = cs.getString("ks_asutuse_kood");
                m_nimetus = cs.getString("nimetus");
                m_nimeLyhend = cs.getString("nime_lyhend");
                m_liik1 = cs.getString("liik1");
                m_liik2 = cs.getString("liik2");
                m_tegevusala = cs.getString("tegevusala");
                m_tegevuspiirkond = cs.getString("tegevuspiirkond");
                m_maakond = cs.getString("maakond");
                m_asukoht = cs.getString("asukoht");
                m_aadress = cs.getString("aadress");
                m_postikood = cs.getString("postikood");
                m_telefon = cs.getString("telefon");
                m_faks = cs.getString("faks");
                m_epost = cs.getString("e_post");
                m_www = cs.getString("www");
                m_logo = cs.getString("logo");
                m_asutamiseKuupaev = cs.getTimestamp("asutamise_kp", cal);
                m_moodustamiseAktiNimi = cs.getString("mood_akt_nimi");
                m_moodustamiseAktiNumber = cs.getString("mood_akt_nr");
                m_moodustamiseAktiKuupaev = cs.getTimestamp("mood_akt_kp", cal);
                m_pohimaaruseAktiNimi = cs.getString("pm_akt_nimi");
                m_pohimaaruseAktiNumber = cs.getString("pm_akt_nr");
                m_pohimaaruseKinnitamiseKuupaev = cs.getTimestamp("pm_kinnitamise_kp", cal);
                m_pohimaaruseKandeKuupaev = cs.getTimestamp("pm_kande_kp", cal);
                m_loodud = cs.getTimestamp("loodud", cal);
                m_muudetud = cs.getTimestamp("muudetud", cal);
                m_muutja = cs.getString("muutja");
                m_parameetrid = cs.getString("parameetrid");
                m_dvkSaatmine = cs.getInt("dhl_saatmine") > 0;
                m_dvkOtseSaatmine = cs.getInt("dhl_otse_saatmine") > 0;
                m_dhsNimetus = cs.getString("dhs_nimetus");
                m_toetatavDVKVersioon = cs.getString("toetatav_dvk_versioon");
                m_serverID = cs.getInt("server_id");
                m_aarID = cs.getInt("aar_id");
                m_kapsel_versioon = cs.getString("kapsel_versioon");
                cs.close();
            } else {
                clear();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "loadByRegNr");
            clear();
        }
    }
    */
    /*
    public static int getIDByRegNr(String registrikood, boolean ainultDvkVoimelised, Connection conn) throws AxisFault {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_ASUTUSIDBYREGNR(?,?,?)}");
                cs.setString("registrikood", registrikood);
                cs.setInt("dvk_voimeline", ainultDvkVoimelised ? 1 : 0);
                cs.registerOutParameter("id", Types.INTEGER);
                cs.executeUpdate();
                int result = cs.getInt("id");
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Asutus", "getIDByRegNr");
            throw new AxisFault(e.getMessage());
        }
    }
    */

    /*
    public static int getIDByAarID(int aarID, Connection conn) throws AxisFault {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call GET_ASUTUSIDBYAARID(?,?)}");
                cs.setInt("aar_id", aarID);
                cs.registerOutParameter("id", Types.INTEGER);
                cs.executeUpdate();
                int result = cs.getInt("id");
                cs.close();
                return result;
            } else {
                return 0;
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dhl.users.Asutus", "getIDByAarID");
            throw new AxisFault(e.getMessage());
        }
    }
    */

    /*
    public static ArrayList<Asutus> getList(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_ASUTUSLIST(?)}");
                cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
                cs.execute();
                ResultSet rs = (ResultSet) cs.getObject("RC1");
                ArrayList<Asutus> result = new ArrayList<Asutus>();
                while (rs.next()) {
                    Asutus item = new Asutus();
                    item.setId(rs.getInt("asutus_id"));
                    item.setRegistrikood(rs.getString("registrikood"));
                    item.setRegistrikoodVana(rs.getString("e_registrikood"));
                    item.setKsAsutuseID(rs.getInt("ks_asutus_id"));
                    item.setKsAsutuseKood(rs.getString("ks_asutus_kood"));
                    item.setNimetus(rs.getString("nimetus"));
                    item.setNimeLyhend(rs.getString("lnimi"));
                    item.setLiik1(rs.getString("liik1"));
                    item.setLiik2(rs.getString("liik2"));
                    item.setTegevusala(rs.getString("tegevusala"));
                    item.setTegevuspiirkond(rs.getString("tegevuspiirkond"));
                    item.setMaakond(rs.getString("maakond"));
                    item.setAsukoht(rs.getString("asukoht"));
                    item.setAadress(rs.getString("aadress"));
                    item.setPostikood(rs.getString("postikood"));
                    item.setTelefon(rs.getString("telefon"));
                    item.setFaks(rs.getString("faks"));
                    item.setEpost(rs.getString("e_post"));
                    item.setWww(rs.getString("www"));
                    item.setLogo(rs.getString("logo"));
                    item.setAsutamiseKuupaev(rs.getTimestamp("asutamise_kp", cal));
                    item.setMoodustamiseAktiNimi(rs.getString("mood_akt_nimi"));
                    item.setMoodustamiseAktiNumber(rs.getString("mood_akt_nr"));
                    item.setMoodustamiseAktiKuupaev(rs.getTimestamp("mood_akt_kp", cal));
                    item.setPohimaaruseAktiNimi(rs.getString("pm_akt_nimi"));
                    item.setPohimaaruseAktiNumber(rs.getString("pm_akt_nr"));
                    item.setPohimaaruseKinnitamiseKuupaev(rs.getTimestamp("pm_kinnitamise_kp", cal));
                    item.setPohimaaruseKandeKuupaev(rs.getTimestamp("pm_kande_kp", cal));
                    item.setLoodud(rs.getTimestamp("created", cal));
                    item.setMuudetud(rs.getTimestamp("last_modified", cal));
                    item.setMuutja(rs.getString("username"));
                    item.setParameetrid(rs.getString("params"));
                    item.setDvkSaatmine(rs.getInt("dhl_saatmine") > 0);
                    item.setDvkOtseSaatmine(rs.getInt("dhl_otse_saatmine") > 0);
                    item.setDHSNimetus(rs.getString("dhs_nimetus"));
                    item.setToetatavDVKVersioon(rs.getString("toetatav_dvk_versioon"));
                    item.setServerID(rs.getInt("server_id"));
                    item.setAarID(rs.getInt("aar_id"));
                    item.setKapselVersioon(rs.getString("kapsel_versioon"));
                    result.add(item);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.users.Asutus", "getList");
            return null;
        }
    }
     */
    
    /*
    public void addToDB(Connection conn, XHeader xTeePais) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall(
                        "{call ADD_ASUTUS(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.registerOutParameter("id", Types.INTEGER);
                cs.setString("registrikood", m_registrikood);
                cs.setString("registrikood_vana", m_registrikoodVana);
                CommonMethods.setNullableIntParam(cs, "ks_asutuse_id", m_ksAsutuseID);
                cs.setString("ks_asutuse_kood", m_ksAsutuseKood);
                cs.setString("nimetus", m_nimetus);
                cs.setString("nime_lyhend", m_nimeLyhend);
                cs.setString("liik1", m_liik1);
                cs.setString("liik2", m_liik2);
                cs.setString("tegevusala", m_tegevusala);
                cs.setString("tegevuspiirkond", m_tegevuspiirkond);
                cs.setString("maakond", m_maakond);
                cs.setString("asukoht", m_asukoht);
                cs.setString("aadress", m_aadress);
                cs.setString("postikood", m_postikood);
                cs.setString("telefon", m_telefon);
                cs.setString("faks", m_faks);
                cs.setString("e_post", m_epost);
                cs.setString("www", m_www);
                cs.setString("logo", m_logo);
                cs.setTimestamp("asutamise_kp", CommonMethods.sqlDateFromDate(m_asutamiseKuupaev), cal);
                cs.setString("mood_akt_nimi", m_moodustamiseAktiNimi);
                cs.setString("mood_akt_nr", m_moodustamiseAktiNumber);
                cs.setTimestamp("mood_akt_kp", CommonMethods.sqlDateFromDate(m_moodustamiseAktiKuupaev), cal);
                cs.setString("pm_akt_nimi", m_pohimaaruseAktiNimi);
                cs.setString("pm_akt_nr", m_pohimaaruseAktiNumber);
                cs.setTimestamp("pm_kinnitamise_kp", CommonMethods.sqlDateFromDate(m_pohimaaruseKinnitamiseKuupaev), cal);
                cs.setTimestamp("pm_kande_kp", CommonMethods.sqlDateFromDate(m_pohimaaruseKandeKuupaev), cal);
                cs.setTimestamp("loodud", CommonMethods.sqlDateFromDate(m_loodud), cal);
                cs.setTimestamp("muudetud", CommonMethods.sqlDateFromDate(m_muudetud), cal);
                cs.setString("muutja", m_muutja);
                cs.setString("parameetrid", m_parameetrid);
                cs.setInt("dhl_saatmine", m_dvkSaatmine ? 1 : 0);
                cs.setInt("dhl_otse_saatmine", m_dvkOtseSaatmine ? 1 : 0);
                cs.setString("dhs_nimetus", m_dhsNimetus);
                cs.setString("toetatav_dvk_versioon", m_toetatavDVKVersioon);

                if (xTeePais != null) {
                    cs.setString("xtee_isikukood", xTeePais.isikukood);
                    cs.setString("xtee_asutus", xTeePais.asutus);
                } else {
                    cs.setString("xtee_isikukood", null);
                    cs.setString("xtee_asutus", null);
                }

                CommonMethods.setNullableIntParam(cs, "server_id", m_serverID);
                CommonMethods.setNullableIntParam(cs, "aar_id", m_aarID);
                cs.setString("kapsel_versioon", m_kapsel_versioon);
                cs.executeUpdate();
                m_id = cs.getInt("id");
                cs.close();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "addToDB");
            clear();
        }
    }
    */
    
}
