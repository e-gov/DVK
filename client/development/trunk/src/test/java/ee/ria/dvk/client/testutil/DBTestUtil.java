package ee.ria.dvk.client.testutil;

import dvk.client.conf.OrgSettings;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import org.apache.log4j.Logger;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBTestUtil {
    private static Logger logger = Logger.getLogger(DBTestUtil.class);

    public static String getTheLastErrorsMessage(String path) throws Exception {
        String errorMessage = "";
        int receivedMessageId = 0;
        Connection dbConnection = null;
        try {
            // Before, connect to the database
            IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(path);

            dbConnection = DatabaseSessionService.getInstance().getConnection();
            OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

            PreparedStatement preparedStatement = null;

            // Different syntax for different databases
            if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                    || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                preparedStatement = dbConnection.prepareStatement("SELECT * FROM dhl_error_log" +
                        " WHERE rownum = 1 ORDER BY dhl_error_log_id DESC");
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                preparedStatement = dbConnection.prepareStatement("SELECT * FROM dvk.dhl_error_log ORDER BY " +
                        "dhl_error_log_id DESC LIMIT 1");
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL)
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005))
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))) {
                preparedStatement = dbConnection.prepareStatement("SELECT TOP 1 * FROM dhl_error_log " +
                        "ORDER BY dhl_error_log_id DESC");
            } else {
                throw new Exception("Can't recognize the database");
            }

            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                errorMessage = resultSet.getString("error_message");
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage());
            throw ex;
        } finally {
            CommonMethods.safeCloseDatabaseConnection(dbConnection);
            DatabaseSessionService.getInstance().clearSession();
        }

        return errorMessage;
    }

    public static int executeSQLToInsertTheMessage(String sql, Connection dbConnection, OrgSettings orgSettings) {
        int messageId = 0;
        try {
            // Insert the new message
            CallableStatement cs = dbConnection.prepareCall(sql);
            cs.execute();
            cs.close();
            dbConnection.commit();

            PreparedStatement preparedStatement = null;

            // Different syntax of SELECT command for different databases
            if ((orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL))
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_MSSQL_2005))
                    || (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_SQLANYWHERE))) {
                preparedStatement = dbConnection.prepareStatement("SELECT TOP 1 * FROM dhl_message " +
                        "ORDER BY dhl_message_id DESC");
            } else if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                preparedStatement = dbConnection.prepareStatement("SELECT dhl_message_id FROM " +
                        "dvk.dhl_message ORDER BY dhl_message_id DESC LIMIT 1");
            }

            ResultSet resultSet;
            try {
                resultSet = preparedStatement.executeQuery();
            } catch (NullPointerException ex) {
                throw ex;
            }

            if (resultSet.next()) {
                messageId = resultSet.getInt("dhl_message_id");
            }
        } catch (Exception ex) {

        } finally {
            closeTheConnectionAndDoClearTheSession(dbConnection);
        }

        return messageId;
    }

    public static void closeTheConnectionAndDoClearTheSession(Connection connection) {
        CommonMethods.safeCloseDatabaseConnection(connection);
        DatabaseSessionService.getInstance().clearSession();
    }
}
