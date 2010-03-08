package dvk.client.businesslayer;

import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

public class Counter {
    public static int getNextDhlID(OrgSettings db) {
        Connection conn = null;
        int result = 0;
        try {
            conn = DBConnection.getConnection(db);
            if (conn != null) {
                CallableStatement cs = conn.prepareCall("{call Get_NextDhlID(?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = conn.prepareCall("{? = call \"Get_NextDhlID\"()}");
                }
                cs.registerOutParameter(1, Types.INTEGER);
                cs.execute();
                result = cs.getInt(1);
                cs.close();
            } else {
                result = 0;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dvk.client.businesslayer.getNextDhlID", "getNextDhlID");
            result = 0;
        } finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (Exception ex) {}
        }
        return result;
    }
}
