package dvk.client.db;

import dvk.client.conf.OrgSettings;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Types;

import java.util.Properties;

import org.apache.log4j.Logger;

public class DBConnection {
	
	private static Logger logger = Logger.getLogger(DBConnection.class);
	
    public static Connection getConnection(OrgSettings settings) {
        Connection connection = null;
        String connectionString = null;
        try {
            Properties connInfo = new Properties();
            connInfo.put("user", settings.getUserName());
            connInfo.put("password", settings.getPassword());

            if (settings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL)) {
                Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
                connectionString = "jdbc:microsoft:sqlserver://" + settings.getServerName();
                if ((settings.getInstanceName() != null) && (settings.getInstanceName().length() > 0)) {
                    connectionString += "\\" + settings.getInstanceName();
                }
                if ((settings.getServerPort() != null) && (settings.getServerPort().length() > 0)) {
                    connectionString += ":" + settings.getServerPort();
                }
                connectionString += ";DatabaseName=" + settings.getDatabaseName() + ";sendStringAsUnicode=true";
                connInfo.put("charSet", "UTF8");
                connection = DriverManager.getConnection(connectionString, connInfo);
            } else if (settings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005)) {
                Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
                connectionString = "jdbc:sqlserver://" + settings.getServerName();
                if ((settings.getInstanceName() != null) && (settings.getInstanceName().length() > 0)) {
                    connectionString += ";instanceName=" + settings.getInstanceName();
                }
                if ((settings.getServerPort() != null) && (settings.getServerPort().length() > 0)) {
                    connectionString += ":" + settings.getServerPort();
                }
                connectionString += ";databaseName=" + settings.getDatabaseName() + ";sendStringAsUnicode=true";
                connInfo.put("charSet", "UTF8");
                connection = DriverManager.getConnection(connectionString, connInfo);
            } else if (settings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE)) {
                Class.forName("oracle.jdbc.driver.OracleDriver");
                connectionString = "jdbc:oracle:thin:@" + settings.getServerName() + ":" + settings.getServerPort() + ":" + settings.getProcessName();
                connection = DriverManager.getConnection(connectionString, connInfo);
            } else if (settings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                Class.forName("org.postgresql.Driver");
                if ((settings.getServerName() != null) && (settings.getServerName().length() > 0)) {
                    connectionString = "jdbc:postgresql://" + settings.getServerName();
                    if ((settings.getServerPort() != null) && (settings.getServerPort().length() > 0)) {
                        connectionString += ":" + settings.getServerPort();
                    }
                    connectionString += "/" + settings.getDatabaseName();
                } else {
                    connectionString = "jdbc:postgresql:" + settings.getDatabaseName();
                }
                connection = DriverManager.getConnection(connectionString, connInfo);

                if ((settings.getSchemaName() != null) && (settings.getSchemaName().length() > 0)) {
                    CallableStatement cs = connection.prepareCall("SET search_path=" + settings.getSchemaName());
                    cs.execute();
                    cs.close();
                }
            }
        } catch (Exception ex) {
        	logger.error("Exception: " , ex);
            CommonMethods.logError(ex, "clnt.db.DBConnection", "getConnection");
            CommonMethods.logError(new Exception(connectionString), "clnt.db.DBConnection", "getConnection");
            return null;
        }
        return connection;
    }

    public static CallableStatement getStatementForResultSet(String procName, int paramCount, OrgSettings db, Connection conn) throws Exception {
        int localParamCount = paramCount;
        if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE)) {
            localParamCount++;
        }

        String callString;
        if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
            callString = "{ ? = call \"" + procName + "\"(";
        } else {
            callString = "{call " + procName + "(";
        }
        for (int i = 0; i < localParamCount; ++i) {
            callString += "?";
            if ((i + 1) < localParamCount) {
                callString += ",";
            }
        }
        callString += ")}";

        CallableStatement result = conn.prepareCall(callString);
        if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE)) {
            result.registerOutParameter(localParamCount, oracle.jdbc.OracleTypes.CURSOR);
        } else if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
            result.registerOutParameter(1, Types.OTHER);
        }

        return result;
    }

    public static ResultSet getResultSet(CallableStatement cs, OrgSettings db, int paramCount) throws Exception {
        if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE)) {
            cs.execute();
            return (ResultSet)cs.getObject(paramCount + 1);
        } else if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
            cs.execute();
            return (ResultSet)cs.getObject(1);
        } else {
            return cs.executeQuery();
        }
    }
}