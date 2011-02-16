package dvk.client.db;

import dvk.client.conf.OrgSettings;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;

public class UnitCredential {
	private static Logger logger = Logger.getLogger(UnitCredential.class.getName());
	
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
    private List<String> m_folders;
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
    
    public void setFolders(List<String> folders) {
        this.m_folders = folders;
    }

    public List<String> getFolders() {
        return m_folders;
    }
    
	public int getContainerVersion() {
		return m_containerVersion;
	}

	public void setContainerVersion(int version) {
		m_containerVersion = version;
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

    public static UnitCredential[] getCredentials(OrgSettings settings, Connection dbConnection) throws Exception {
        if (dbConnection != null) {
            List<UnitCredential> result = new ArrayList<UnitCredential>();
        	boolean defaultAutoCommit = dbConnection.getAutoCommit();
    		try {
	        	dbConnection.setAutoCommit(false);
	            CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlSettings", 0, settings, dbConnection);
	            ResultSet rs = DBConnection.getResultSet(cs, settings, 0);
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
	                item.setFolders(loadFolders(item.getId(), dbConnection, settings));
	                result.add(item);
	            }
	            rs.close();
	            cs.close();
    		} finally {
    			dbConnection.setAutoCommit(defaultAutoCommit);
    		}

            UnitCredential[] credentials = new UnitCredential[result.size()];
            for (int i = 0; i < result.size(); ++i) {
                credentials[i] = result.get(i);
            }
            return credentials;
        } else {
        	throw new Exception("Database connection is NULL!");
        }
    }

    private static List<String> loadFolders(int credentialID, Connection conn, OrgSettings settings) {
        try {
            List<String> result = new ArrayList<String>();
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
        	logger.error(ex);
            return new ArrayList<String>();
        }
    }
    
    public static int getExchangedDocumentsCount(int unitID, OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
                int parNr = 1;
            	CallableStatement cs = dbConnection.prepareCall("{call Get_AsutusStat(?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Get_AsutusStat\"(?)}");
                }
                
                // SQL Anywhere JDBC client requires that output parameters are supplied as last parameter(s).
                // Otherwise all input parameters will be incorrectly moved down by one position in parameter list.
                if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	parNr++;
                }
                
                cs.setInt(parNr++, unitID);
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	cs.registerOutParameter(parNr, Types.INTEGER);
                } else {
                	cs.registerOutParameter(1, Types.INTEGER);
                }
                cs.execute();
                int result = 0;
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	result = cs.getInt(parNr);
                } else {
                	result = cs.getInt(1);
                }
                cs.close();

                return result;
            } else {
                return 0;
            }
        } catch (Exception ex) {
        	logger.error(ex);
            return 0;
        }
    }
}
