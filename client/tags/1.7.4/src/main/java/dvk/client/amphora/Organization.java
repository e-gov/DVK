package dvk.client.amphora;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.conf.OrgSettings;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.LoggingService;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;

public class Organization {
    private int m_partyID;
    private String m_name;
    private String m_code;

    public void setPartyID(int partyID) {
        this.m_partyID = partyID;
    }

    public int getPartyID() {
        return m_partyID;
    }

    public void setName(String name) {
        this.m_name = name;
    }

    public String getName() {
        return m_name;
    }

    public void setCode(String code) {
        this.m_code = code;
    }

    public String getCode() {
        return m_code;
    }

    public Organization() {
        Clear();
    }

    public void Clear() {
        m_partyID = 0;
        m_name = "";
        m_code = "";
    }

    public static boolean updateOrgDhlCapability(String regNr, boolean capable, Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Update_OrgDhlCapability(?,?)}");
                cs.setString(1, regNr);
                cs.setInt(2, (capable ? 1 : 0));
                cs.executeUpdate();
                cs.close();
                return true;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.amphora.Organization" + " updateOrgDhlCapability");
                LoggingService.logError(errorLog);
                return false;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.amphora.Organization" + " updateOrgDhlCapability");
            LoggingService.logError(errorLog);
            return false;
        }
    }

    public static boolean syncOrgDhlCapability(Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("update organization set dhl_capability=null");
                cs.execute();
                cs.close();
                cs = conn.prepareCall("update organization set dhl_capability=1 where exists (select * from dhl_organization where dhl_organization.org_code=(organization.org_code COLLATE SQL_Latin1_General_CP1_CI_AS) and (dhl_capable=1 or dhl_direct_capable=1))");
                cs.execute();
                cs.close();
                return true;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.amphora.Organization" + " syncOrgDhlCapability");
                LoggingService.logError(errorLog);
                return false;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.amphora.Organization" + " syncOrgDhlCapability");
            LoggingService.logError(errorLog);
            return false;
        }
    }

    public static boolean addOrganization(Connection conn, OrgSettings db, UnitCredential cred, String orgCode, String orgName) {
        int unitID = cred.getUnitID();
        boolean orgExistsForUnit = getOrgExistsForUnit(conn, db, unitID, orgCode);

        if (orgExistsForUnit) {
            return updateOrgDhlCapability(orgCode, true, conn);
        } else {
            int personID = getUnitFirstPersonID(conn, db, unitID);

            Item i = new Item();
            i.setName(orgName);
            i.setOwnerID(personID);
            int itemID = i.addItem(conn);

            if (itemID > 0) {
                if (Party.addParty(conn, itemID, 133)) {
                    dvk.client.amphora.Organization ampOrg = new dvk.client.amphora.Organization();
                    ampOrg.setCode(orgCode);
                    ampOrg.setName(orgName);
                    ampOrg.setPartyID(itemID);
                    if (ampOrg.addOrganization(conn)) {
                        if (Party.addPartyRole(conn, itemID, 332)) {
                            boolean result = Party.addPartyRelationship(conn, personID, 309, itemID, 332, 269);
                            if (result) {
                                try {
                                    conn.commit();
                                }
                                catch (Exception ex) {
                                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.amphora.Organization" + " addOrganization");
                                    errorLog.setOrganizationCode(orgCode);
                                    LoggingService.logError(errorLog);
                                    result = false;
                                }
                            }
                            return result;
                        }
                    }
                }
            }
            return false;
        }
    }

    public boolean addOrganization(Connection conn) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Add_ClientOrganization(?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, m_partyID); // @party_id
                cs.setString(2, m_name); // @full_name
                cs.setString(3, m_code); // @org_code
                cs.setNull(4, Types.VARCHAR); // @org_abbrevation
                cs.setNull(5, Types.VARCHAR); // @org_number
                cs.setNull(6, Types.VARCHAR); // @org_comment
                cs.setNull(7, Types.VARCHAR); // @lead_name
                cs.setNull(8, Types.INTEGER); // @lead_type_id
                cs.setNull(9, Types.VARCHAR); // @notes
                cs.setInt(10, 1); // @active
                cs.setInt(11, 1); // @dhl_capability
                cs.setNull(12, Types.INTEGER); // @dvk_id
                cs.executeUpdate();
                cs.close();
                return true;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.amphora.Organization" + " addOrganization");
                LoggingService.logError(errorLog);
                return false;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " addOrganization");
            errorLog.setOrganizationCode(this.getCode());
            LoggingService.logError(errorLog);
            return false;
        }
    }


    public static int getUnitFirstPersonID(Connection conn, OrgSettings db, int unitID) {
        try {
            if (conn != null) {
                int result = 0;
                CallableStatement cs = null;
                if (db.getDbProvider().equalsIgnoreCase("ORACLE")) {
                    cs = conn.prepareCall("select p.party_id as pid from sys_users u inner join sys_u_ug ug on ug.id = u.id inner join person p on p.sys_users_id = u.id where ug.unit_id=" + String.valueOf(unitID) + " and rownum < 2");
                } else {
                    cs = conn.prepareCall("select top 1 p.party_id as pid from sys_users u inner join sys_u_ug ug on ug.id = u.id inner join person p on p.sys_users_id = u.id where ug.unit_id=" + String.valueOf(unitID));
                }
                ResultSet rs = cs.executeQuery();
                if (rs.next()) {
                    result = rs.getInt(1);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.amphora.Organization" + " getUnitFirstPersonID");
                LoggingService.logError(errorLog);
                return 0;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.amphora.Organization" + " getUnitFirstPersonID");
            LoggingService.logError(errorLog);
            return 0;
        }
    }

    public static boolean getOrgExistsForUnit(Connection conn, OrgSettings db, int unitID, String orgCode) {
        try {
            if (conn != null) {
                String sqlString = "select count(*) as nr";
                sqlString += " from party_relationship prel";
                sqlString += " inner join party_role prole on prel.p_role_id_to = prole.party_role_id";
                sqlString += " inner join party_role prole2 on prel.p_role_id_from = prole2.party_role_id";
                sqlString += " inner join person p on p.party_id = prole2.party_id";
                sqlString += " inner join sys_u_ug ug on ug.id = p.sys_users_id";
                if (db.getDbProvider().equalsIgnoreCase("ORACLE")) {
                    sqlString += " inner join organization_ org on org.party_id = prole.party_id";
                } else {
                    sqlString += " inner join organization org on org.party_id = prole.party_id";
                }
                sqlString += " where ug.unit_id=" + String.valueOf(unitID);
                sqlString += " and org.org_code = '" + orgCode.replaceAll("'", "''") + "'";

                int result = 0;
                CallableStatement cs = conn.prepareCall(sqlString);
                ResultSet rs = cs.executeQuery();
                if (rs.next()) {
                    result = rs.getInt(1);
                }
                rs.close();
                cs.close();
                return (result > 0);
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.amphora.Organization" + " getOrgExistsForUnit");
                LoggingService.logError(errorLog);
                return false;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.amphora.Organization" + " getOrgExistsForUnit");
            errorLog.setOrganizationCode(orgCode);
            LoggingService.logError(errorLog);
            return false;
        }
    }
    
    public static int getOrgID(Connection conn, OrgSettings db, int unitID, String orgCode) {
        try {
            if (conn != null) {
                String sqlString = "select org.party_id";
                sqlString += " from party_relationship prel";
                sqlString += " inner join party_role prole on prel.p_role_id_to = prole.party_role_id";
                sqlString += " inner join party_role prole2 on prel.p_role_id_from = prole2.party_role_id";
                sqlString += " inner join person p on p.party_id = prole2.party_id";
                sqlString += " inner join sys_u_ug ug on ug.id = p.sys_users_id";
                if (db.getDbProvider().equalsIgnoreCase("ORACLE")) {
                    sqlString += " inner join organization_ org on org.party_id = prole.party_id";
                } else {
                    sqlString += " inner join organization org on org.party_id = prole.party_id";
                }
                sqlString += " where ug.unit_id=" + String.valueOf(unitID);
                sqlString += " and org.org_code = '" + orgCode.replaceAll("'", "''") + "'";
                sqlString += " and org.org_code <> ''";

                int result = 0;
                CallableStatement cs = conn.prepareCall(sqlString);
                ResultSet rs = cs.executeQuery();
                if (rs.next()) {
                    result = rs.getInt(1);
                }
                rs.close();
                cs.close();
                return result;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.amphora.Organization" + " getOrgID");
                LoggingService.logError(errorLog);
                return 0;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.amphora.Organization" + " getOrgID");
            errorLog.setOrganizationCode(orgCode);
            LoggingService.logError(errorLog);
            return 0;
        }
    }
}
