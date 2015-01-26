package dhl.sys;

import dvk.core.CommonMethods;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Types;
import java.util.Calendar;
import java.util.Date;

public class ApplicationParams {
    private Date m_lastAarSync;

    public ApplicationParams() {
        clear();
    }

    public Date getLastAarSync() {
        return m_lastAarSync;
    }

    public void setLastAarSync(Date value) {
        m_lastAarSync = value;
    }

    public ApplicationParams(Connection conn) {
        clear();
        loadFromDB(conn);
    }

    public void clear() {
        m_lastAarSync = null;
    }

    public void loadFromDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{? = call \"Get_Parameters\"()}");
                cs.registerOutParameter(1, Types.TIMESTAMP);
                cs.executeUpdate();
                m_lastAarSync = cs.getTimestamp(1, cal);
                cs.close();
            } else {
                clear();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, this.getClass().getName(), "loadFromDB");
            clear();
        }
    }

    public boolean saveToDB(Connection conn) {
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call \"Save_Parameters\"(?)}");
                cs.setTimestamp(1, CommonMethods.sqlDateFromDate(m_lastAarSync), cal);
                cs.executeUpdate();
                cs.close();
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "saveToDB");
            return false;
        }
    }
}
