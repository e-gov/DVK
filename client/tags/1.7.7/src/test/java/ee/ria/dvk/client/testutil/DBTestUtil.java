package ee.ria.dvk.client.testutil;

import dvk.client.businesslayer.DhlMessage;
import dvk.client.conf.OrgSettings;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import integration.ClientRequestsIntegration;
import org.apache.log4j.Logger;

import java.sql.Clob;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.List;

public class DBTestUtil {
    private static Logger logger = Logger.getLogger(DBTestUtil.class);

    public static int insertNewMessageToDB(String propertiesFile, String xmlContainerFileName) throws Exception {
        // NB! DhlMessage.addToDB method requires document recipient orgCode matching to dhl_settings.institution_code
        int messageID = 0;
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(propertiesFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();

        try {
            OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();
            String xmlFileForMessage = ClientRequestsIntegration.class.getResource("../" + xmlContainerFileName).getPath();
            UnitCredential[] credentials = UnitCredential.getCredentials(orgSettings, dbConnection);
            DhlMessage newMessage = new DhlMessage();
            newMessage.loadFromXML(xmlFileForMessage, credentials[0]);
            newMessage.setFilePath(xmlFileForMessage);
            messageID = newMessage.addToDB(orgSettings, dbConnection);

        } catch (Exception e) {
            throw new RuntimeException("New message wasn't inserted! " + e.getMessage());
        } finally {
            DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
        }

        return messageID;
    }

    public static String getTheLastErrorsMessage(String path) throws Exception {
        String errorMessage = "";
        int receivedMessageId = 0;
        Connection dbConnection = null;
        try {
            IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(path);
            dbConnection = DatabaseSessionService.getInstance().getConnection();
            OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();
            PreparedStatement preparedStatement = null;

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

    public static DhlMessageData getMessageById(String configFile, Integer messageId) throws Exception {
        String data = "";
        int dhlId = 0;

        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();
        String sql = "SELECT * FROM dhl_message WHERE dhl_message_id = ?";
        try {
            PreparedStatement preparedStatement = dbConnection.prepareStatement(sql);
            preparedStatement.setInt(1, messageId);
            ResultSet resultSet = preparedStatement.executeQuery();

            if (resultSet.next()) {
                if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                        || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                    Clob dataClob = resultSet.getClob("data");
                    data = FileUtil.parseClobData(dataClob);
                } else {
                    data = resultSet.getString("data");
                }
                dhlId = resultSet.getInt("dhl_id");
            }
        } finally {
            DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
        }
        return new DhlMessageData(messageId, dhlId, data);
    }

    public static DhlMessageData getMessageByDhlId(String configFile, Integer dhlId, Boolean isIncoming) throws Exception {
        String data = "";
        int receivedMessageId = 0;

        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();
        String sql = "SELECT * FROM dhl_message WHERE dhl_id = ? AND is_incoming = ?";
        try {
            PreparedStatement preparedStatement = dbConnection.prepareStatement(sql);
            preparedStatement.setInt(1, dhlId);
            preparedStatement.setInt(2, isIncoming ? 1 : 0);
            ResultSet resultSet = preparedStatement.executeQuery();
            if (resultSet.next()) {
                if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_10G)
                        || orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_ORACLE_11G)) {
                    Clob dataClob = resultSet.getClob("data");
                    data = FileUtil.parseClobData(dataClob);
                } else {
                    data = resultSet.getString("data");
                }
                receivedMessageId = resultSet.getInt("dhl_message_id");
            }
        } finally {
            DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
        }
        return new DhlMessageData(receivedMessageId, data);
    }

    public static DhlSetting fetchDhlSettings(String configFile) throws Exception {
        DhlSetting result = new DhlSetting();

        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        String sql = "SELECT institution_code, institution_name, personal_id_code FROM dhl_settings WHERE id = 1";
        PreparedStatement preparedStatement = dbConnection.prepareStatement(sql);
        try {
            ResultSet rs = preparedStatement.executeQuery();
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next()) {
                result.setInstitutionCode(rs.getObject("institution_code").toString());
                result.setInstitutionName(rs.getObject("institution_name").toString());
                result.setPersonalIdCode(rs.getObject("personal_id_code").toString());
            }
        } finally {
            DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
        }
        return result;
    }

    public static void updateDhlSettings(String configFile, DhlSetting newSettings) throws Exception {
        IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        String sql = "UPDATE dhl_settings SET institution_code = ?, institution_name = ?, personal_id_code = ? WHERE id = 1";
        try {
            PreparedStatement preparedStatement = dbConnection.prepareStatement(sql);
            preparedStatement.setString(1, newSettings.getInstitutionCode());
            preparedStatement.setString(2, newSettings.getInstitutionName());
            preparedStatement.setString(3, newSettings.getPersonalIdCode());
            preparedStatement.executeUpdate();
            preparedStatement.close();
        } finally {
            DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
        }
    }

    public static void restoreDhlSettings(String configFile, DhlSetting oldSettings) {
        try {
            updateDhlSettings(configFile, oldSettings);
        } catch (Exception ex) {
            logger.error("Can't restore data in DHL_SETTINGS table\n" + ex.getMessage());
        }
    }

    public static void closeTheConnectionAndDoClearTheSession(Connection connection) {
        CommonMethods.safeCloseDatabaseConnection(connection);
        DatabaseSessionService.getInstance().clearSession();
    }

    public static void clearDataBaseAfterTest(String configFile, List<Integer> messageIds) {
        Connection dbConnection = null;
        PreparedStatement preparedSelectStatement = null;
        try {
            IntegrationTestsConfigUtil.setUpFromTheConfigurationFile(configFile);
            dbConnection = DatabaseSessionService.getInstance().getConnection();

            String sql = "SELECT dhl_error_log_id FROM dhl_error_log WHERE dhl_message_id IN (%s)";
            sql = String.format(sql, preparePlaceHolders(messageIds.size()));
            preparedSelectStatement = dbConnection.prepareStatement(sql);
            for (int i = 0; i < messageIds.size(); i++) {
                preparedSelectStatement.setObject(i + 1, messageIds.get(i));
            }
            ResultSet resultSet = preparedSelectStatement.executeQuery();
            List<Integer> errorLogIds = new ArrayList<Integer>();
            while (resultSet.next()) {
                errorLogIds.add(resultSet.getInt("dhl_error_log_id"));
            }
            if (errorLogIds.size() > 0) {
                deleteFromDataBaseByCriteriaList(dbConnection, "dhl_request_log", "dhl_error_log_id", errorLogIds);
            }
            deleteFromDataBaseByDhlMessageIdList(dbConnection, "dhl_error_log", messageIds);
            deleteFromDataBaseByDhlMessageIdList(dbConnection, "dhl_message_recipient", messageIds);
            deleteFromDataBaseByDhlMessageIdList(dbConnection, "dhl_message", messageIds);

        } catch (Exception ex) {
            logger.error(ex);

        } finally {
            try {
                DBTestUtil.closeTheConnectionAndDoClearTheSession(dbConnection);
            } catch (Exception e) {
                logger.error(e);
            }
        }
    }

    private static void deleteFromDataBaseByCriteria(Connection dbConnection, String tableName, String criteriaColumnName, Integer id) throws Exception {
        String sql = "DELETE FROM " + tableName + " WHERE " + criteriaColumnName + " = ?";
        PreparedStatement preparedDeleteStatement = dbConnection.prepareStatement(sql);
        try {
            preparedDeleteStatement.setInt(1, id);
            preparedDeleteStatement.executeUpdate();
        } finally {
            preparedDeleteStatement.close();
        }
    }

    private static void deleteFromDataBaseByDhlMessageIdList(Connection dbConnection, String tableName, List<Integer> idList) throws Exception {
        deleteFromDataBaseByCriteriaList(dbConnection, tableName, "dhl_message_id", idList);
    }

    private static void deleteFromDataBaseByCriteriaList(Connection dbConnection, String tableName, String criteriaColumnName, List<Integer> idList) throws Exception {
        String sql = "DELETE FROM " + tableName + " WHERE " + criteriaColumnName + " IN (%s)";
        sql = String.format(sql, preparePlaceHolders(idList.size()));
        PreparedStatement preparedDeleteStatement = dbConnection.prepareStatement(sql);
        try {
            for (int i = 0; i < idList.size(); i++) {
                preparedDeleteStatement.setObject(i + 1, idList.get(i));
            }
            preparedDeleteStatement.executeUpdate();
        } finally {
            preparedDeleteStatement.close();
        }
    }

    private static String preparePlaceHolders(int length) {
        StringBuilder builder = new StringBuilder();
        for (int i = 0; i < length; ) {
            builder.append("?");
            if (++i < length) {
                builder.append(",");
            }
        }
        return builder.toString();
    }


}
