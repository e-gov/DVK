package dvk.client.amphora;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Types;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.conf.OrgSettings;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.LoggingService;

public class Department {
    private int m_partyID;
    private String m_name;
    private int m_dvkID;

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

    public int getDvkID() {
        return m_dvkID;
    }

    public void setDvkID(int value) {
        m_dvkID = value;
    }

    public Department() {
        Clear();
    }

    public void Clear() {
        m_partyID = 0;
        m_name = "";
        m_dvkID = 0;
    }

    public static boolean addDepartment(Connection conn, OrgSettings db, UnitCredential cred, int departmentDvkID, String departmentName, String orgCode) {
        int unitID = cred.getUnitID();
        int orgID = Organization.getOrgID(conn, db, unitID, orgCode);
        int departmentID = getDepartmentIDForUnit(conn, db, unitID, orgCode, departmentDvkID, departmentName);
        
        if ((orgID > 0) && (departmentID <= 0)) {
            int personID = Organization.getUnitFirstPersonID(conn, db, unitID);

            Item i = new Item();
            i.setName(departmentName);
            i.setOwnerID(personID);
            int itemID = i.addItem(conn);

            if (itemID > 0) {
                if (Party.addParty(conn, itemID, 133)) {
                    Department dep = new Department();
                    dep.setDvkID(departmentDvkID);
                    dep.setName(departmentName);
                    dep.setPartyID(itemID);
                    if (dep.addOrganization(conn, departmentDvkID)) {
                        if (Party.addPartyRole(conn, itemID, 333)) {
                            boolean ok = Party.addPartyRelationship(conn, personID, 309, itemID, 333, 269);
                            return (ok && Party.addPartyRelationship(conn, orgID, 332, itemID, 333, 334));
                        }
                    }
                }
            }
        }
        return false;
    }

    public boolean addOrganization(Connection conn, int departmentDvkID) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Add_ClientOrganization(?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, m_partyID); // @party_id
                cs.setString(2, m_name); // @full_name
                cs.setNull(3, Types.VARCHAR); // @org_code
                cs.setNull(4, Types.VARCHAR); // @org_abbrevation
                cs.setNull(5, Types.VARCHAR); // @org_number
                cs.setNull(6, Types.VARCHAR); // @org_comment
                cs.setNull(7, Types.VARCHAR); // @lead_name
                cs.setNull(8, Types.INTEGER); // @lead_type_id
                cs.setNull(9, Types.VARCHAR); // @notes
                cs.setInt(10, 1); // @active
                cs.setInt(11, 1); // @dhl_capability
                cs.setInt(12, departmentDvkID); // @dvk_id
                cs.executeUpdate();
                cs.close();
                return true;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", this.getClass().getName() + " addOrganization");
                LoggingService.logError(errorLog);
                return false;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " addOrganization");
            LoggingService.logError(errorLog);
            return false;
        }
    }

    public static int getDepartmentIDForUnit(Connection conn, OrgSettings db, int unitID, String orgCode, int departmentDvkID, String departmentName) {
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
                sqlString += " inner join party_relationship prel2 on prel2.p_role_id_to = prole.party_role_id";
                sqlString += " inner join party_role prole3 on prel2.p_role_id_from = prole3.party_role_id";
                if (db.getDbProvider().equalsIgnoreCase("ORACLE")) {
                    sqlString += " inner join organization_ org2 on org2.party_id = prole3.party_id";
                } else {
                    sqlString += " inner join organization org2 on org2.party_id = prole3.party_id";
                }
                sqlString += " where ug.unit_id=" + String.valueOf(unitID);
                sqlString += " and org.dvk_id = " + String.valueOf(departmentDvkID);
                sqlString += " and org2.org_code = '" + orgCode.replaceAll("'", "''") + "'";

                int result = 0;
                CallableStatement cs = conn.prepareCall(sqlString);
                ResultSet rs = cs.executeQuery();
                if (rs.next()) {
                    result = rs.getInt(1);
                } else {
                    sqlString = "select org.party_id";
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
                    sqlString += " inner join party_relationship prel2 on prel2.p_role_id_to = prole.party_role_id";
                    sqlString += " inner join party_role prole3 on prel2.p_role_id_from = prole3.party_role_id";
                    if (db.getDbProvider().equalsIgnoreCase("ORACLE")) {
                        sqlString += " inner join organization_ org2 on org2.party_id = prole3.party_id";
                    } else {
                        sqlString += " inner join organization org2 on org2.party_id = prole3.party_id";
                    }
                    sqlString += " where ug.unit_id=" + String.valueOf(unitID);
                    sqlString += " and ((org.dvk_id is null) or (org.dvk_id = 0))";
                    sqlString += " and org.full_name = '"+ departmentName.replaceAll("'", "''") +"'";
                    sqlString += " and org2.org_code = '" + orgCode.replaceAll("'", "''") + "'";
                    rs.close();
                    cs.close();
                    cs = conn.prepareCall(sqlString);
                    rs = cs.executeQuery();
                    if (rs.next()) {
                        result = rs.getInt(1);
                    } else {
                        result = 0;
                    }
                }
                rs.close();
                cs.close();
                return result;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.amphora.Department" + " getDepartmentIDForUnit");
                LoggingService.logError(errorLog);
                return 0;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.amphora.Department" + " getDepartmentIDForUnit");
            errorLog.setOrganizationCode(orgCode);
            LoggingService.logError(errorLog);
            return 0;
        }
    }
}
