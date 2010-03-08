package dvk.client.db;

import dvk.client.conf.OrgSettings;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;

public class UnitCredential {
    private int m_id;
    private String m_institutionCode;
    private String m_institutionName;
    private String m_personalIdCode;
    private int m_unitID;
    private int m_divisionID;
    private int m_occupationID;
    private String m_divisionShortName;
    private String m_occupationShortName;
    private String m_divisionName;
    private String m_occupationName;
    private ArrayList<String> m_folders;
    private int m_containerVersion;
    
    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setInstitutionCode(String institutionCode) {
        this.m_institutionCode = institutionCode;
    }

    public String getInstitutionCode() {
        return m_institutionCode;
    }

    public void setInstitutionName(String institutionName) {
        this.m_institutionName = institutionName;
    }

    public String getInstitutionName() {
        return m_institutionName;
    }

    public void setPersonalIdCode(String personalIdCode) {
        this.m_personalIdCode = personalIdCode;
    }

    public String getPersonalIdCode() {
        return m_personalIdCode;
    }

    public void setUnitID(int unitID) {
        this.m_unitID = unitID;
    }

    public int getUnitID() {
        return m_unitID;
    }

    public int getDivisionID() {
        return m_divisionID;
    }

    public void setDivisionID(int value) {
        m_divisionID = value;
    }

    public int getOccupationID() {
        return m_occupationID;
    }

    public void setOccupationID(int value) {
        m_occupationID = value;
    }
    
    public String getDivisionShortName() {
        return this.m_divisionShortName;
    }

    public void setDivisionShortName(String value) {
        this.m_divisionShortName = value;
    }

    public String getOccupationShortName() {
        return this.m_occupationShortName;
    }

    public void setOccupationShortName(String value) {
        this.m_occupationShortName = value;
    }

    public String getDivisionName() {
        return this.m_divisionName;
    }

    public void setDivisionName(String value) {
        this.m_divisionName = value;
    }

    public String getOccupationName() {
        return this.m_occupationName;
    }

    public void setOccupationName(String value) {
        this.m_occupationName = value;
    }
    
    public void setFolders(ArrayList<String> folders) {
        this.m_folders = folders;
    }

    public ArrayList<String> getFolders() {
        return m_folders;
    }

    public UnitCredential() {
        clear();
    }

    public void clear() {
        m_id = 0;
        m_institutionCode = "";
        m_institutionName = "";
        m_personalIdCode = "";
        m_unitID = 0;
        m_divisionID = 0;
        m_occupationID = 0;
        m_divisionShortName = "";
        m_occupationShortName = "";
        m_divisionName = "";
        m_occupationName = "";
        m_folders = new ArrayList<String>();
    }

    public static UnitCredential[] getCredentials(OrgSettings settings) {
        try {
            Connection conn = DBConnection.getConnection(settings);
            if (conn != null) {
                conn.setAutoCommit(false);
                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlSettings", 0, settings, conn);
                ResultSet rs = DBConnection.getResultSet(cs, settings, 0);
                ArrayList<UnitCredential> result = new ArrayList<UnitCredential>();
                while (rs.next()) {
                    UnitCredential item = new UnitCredential();
                    item.setId(rs.getInt("id"));
                    item.setInstitutionCode(rs.getString("institution_code"));
                    item.setInstitutionName(rs.getString("institution_name"));
                    item.setPersonalIdCode(rs.getString("personal_id_code"));
                    item.setUnitID(rs.getInt("unit_id"));
                    item.setDivisionID(rs.getInt("subdivision_code"));
                    item.setOccupationID(rs.getInt("occupation_code"));
                    item.setDivisionShortName(rs.getString("subdivision_short_name"));
                    item.setOccupationShortName(rs.getString("occupation_short_name"));
                    item.setDivisionName(rs.getString("subdivision_name"));
                    item.setOccupationName(rs.getString("occupation_name"));
                    item.setContainerVersion(rs.getInt("container_version"));
                    item.setFolders(loadFolders(item.getId(), conn, settings));
                    result.add(item);
                }
                rs.close();
                cs.close();
                conn.close();

                UnitCredential[] credentials = new UnitCredential[result.size()];
                for (int i = 0; i < result.size(); ++i) {
                    credentials[i] = result.get(i);
                }
                return credentials;
            } else {
                return new UnitCredential[] { };
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.db.UnitCredential", "getCredentials");
            return new UnitCredential[] { };
        }
    }

    private static ArrayList<String> loadFolders(int credentialID, Connection conn, OrgSettings settings) {
        try {
            ArrayList<String> result = new ArrayList<String>();
            if (conn != null) {
                int parNr = 1;
                if (settings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    parNr++;
                }
                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlSettingFolders", 1, settings, conn);
                cs.setInt(parNr++, credentialID);
                ResultSet rs = DBConnection.getResultSet(cs, settings, 1);
                while (rs.next()) {
                    result.add(rs.getString("folder_name"));
                }
                rs.close();
                cs.close();
            }
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dvk.client.db.UnitCredential", "loadFolders");
            return new ArrayList<String>();
        }
    }
    
    public static int getExchangedDocumentsCount(int unitID, OrgSettings db) {
        try {
            Connection conn = DBConnection.getConnection(db);
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Get_AsutusStat(?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = conn.prepareCall("{? = call \"Get_AsutusStat\"(?)}");
                }
                cs.registerOutParameter(1, Types.INTEGER);
                cs.setInt(2, unitID);
                cs.execute();
                int result = cs.getInt(1);
                cs.close();
                conn.close();

                return result;
            } else {
                return 0;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dvk.client.db.UnitCredential", "getExchangedDocumentsCount");
            return 0;
        }
    }

	public int getContainerVersion() {
		return m_containerVersion;
	}

	public void setContainerVersion(int version) {
		m_containerVersion = version;
	}
}
