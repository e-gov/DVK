package dvk.client.amphora;

import dvk.core.CommonMethods;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

public class Party {
    public static boolean addParty(Connection conn, int partyID, int partyTypeID) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Add_Party(?,?)}");
                cs.setInt(1, partyID); // @party_id
                cs.setInt(2, partyTypeID); // @party_type_id
                cs.executeUpdate();
                cs.close();
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dvk.client.amphora.Party", "addParty");
            return false;
        }
    }

    public static boolean addPartyRole(Connection conn, int partyID, int partyRoleTypeID) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Add_Party_Role(?,?)}");
                cs.setInt(1, partyID); // @party_id
                cs.setInt(2, partyRoleTypeID); // @party_role_type_id
                cs.executeUpdate();
                cs.close();
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dvk.client.amphora.Party", "addPartyRole");
            return false;
        }
    }

    public static boolean addPartyRelationship(Connection conn, int party1_ID, int party1_TypeID, int party2_ID, int party2_TypeID, int partyRelTypeID) {
        try {
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Add_Party_Relationship(?,?,?,?,?,?,?)}");
                cs.setInt(1, party1_ID); // @party_id1
                cs.setInt(2, party1_TypeID); // @party_type_id1
                cs.setInt(3, party2_ID); // @party_id2
                cs.setInt(4, party2_TypeID); // @party_type_id2
                cs.setInt(5, partyRelTypeID); // @party_relationship_type
                cs.setNull(6, Types.INTEGER); // @rating_id
                cs.setNull(7, Types.INTEGER); // @priority_id
                cs.executeUpdate();
                cs.close();
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            Exception e = new Exception("party1_id " + String.valueOf(party1_ID));
            CommonMethods.logError(e, "dvk.client.amphora.Party", "addPartyRelationship");
            e = new Exception("party2_id " + String.valueOf(party2_ID));
            CommonMethods.logError(e, "dvk.client.amphora.Party", "addPartyRelationship");
            CommonMethods.logError(ex, "dvk.client.amphora.Party", "addPartyRelationship");
            return false;
        }
    }
}
