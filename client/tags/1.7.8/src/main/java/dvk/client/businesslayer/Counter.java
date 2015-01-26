package dvk.client.businesslayer;

import dvk.client.conf.OrgSettings;
import dvk.client.dhl.service.LoggingService;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;

public class Counter {
    public static int getNextDhlID(OrgSettings db, Connection dbConnection) {
        int result = 0;
        try {
            if (dbConnection != null) {
                CallableStatement cs = dbConnection.prepareCall("{call Get_NextDhlID(?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Get_NextDhlID\"()}");
                }
                cs.registerOutParameter(1, Types.INTEGER);
                cs.execute();
                result = cs.getInt(1);
                cs.close();
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.businesslayer.Counter" + " getNextDhlID");
                LoggingService.logError(errorLog);
                result = 0;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.Counter" + " getNextDhlID");
            LoggingService.logError(errorLog);
            result = 0;
        }
        return result;
    }
}
