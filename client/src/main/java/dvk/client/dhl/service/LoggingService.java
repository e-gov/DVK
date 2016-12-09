package dvk.client.dhl.service;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;

import org.apache.log4j.Logger;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.businesslayer.RequestLog;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

public class LoggingService {
    static Logger logger = Logger.getLogger(LoggingService.class.getName());

    public static void logErrorToFile(ErrorLog errorLog) {
        try {
            if (errorLog.getCause() != null) {
                logger.error(errorLog.getErrorMessage() + " " + errorLog.getActionName() +
                        " " + errorLog.getAdditionalInformation(), errorLog.getCause());
            } else {
                logger.error(errorLog.getErrorMessage() + " " + errorLog.getActionName() +
                        " " + errorLog.getAdditionalInformation());
            }
        } catch (Exception ex) {
            logger.error("Logging service: Unable to save the error log to the file", ex);
        }
    }

    public static int logError(ErrorLog errorLog) {
        // Get the current connection to DB, and settings
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        // Error message and cause checks
        if (errorLog.getErrorMessage() == null) {
            if (errorLog.getCause() == null) {
                logger.error("Logging service: Unable to save the error log - error message and cause are null");
                return -1;
            } else {
                errorLog.setErrorMessage(errorLog.getCause().getClass().getName());
            }
        }

        // Save error stacktrace to file
        logErrorToFile(errorLog);

        // Connection and settings checks
        if ((dbConnection == null) || (orgSettings == null)) {
            logger.error("LoggingService: Database connection or settings is NULL. Unable to save the error log");
            return -1;
        }

        return logErrorToDataBase(errorLog, dbConnection, orgSettings);
    }

    private static int logErrorToDataBase(ErrorLog errorLog, Connection dbConnection, OrgSettings orgSettings) {
        int logEntryId = -1;

        try {
            Calendar cal = Calendar.getInstance();

            int parNr = 1;

            CallableStatement cs = dbConnection.prepareCall("{call Add_DhlErrorLog(?,?,?,?,?,?,?)}");
            if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                cs = dbConnection.prepareCall("{? = call \"Add_DhlErrorLog\"(?,?,?,?,?,?)}");
            }

            if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(orgSettings.getDbProvider())) {
                cs.setInt(parNr++, 0);
            }

            cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(errorLog.getErrorDateTime()), cal);
            cs.setString(parNr++, errorLog.getOrganizationCode());
            cs.setString(parNr++, errorLog.getUserCode());
            cs.setString(parNr++, errorLog.getActionName());
            cs.setString(parNr++, CommonMethods.replaceAllSpecialCharactersInString(errorLog.getErrorMessage()));
            if (errorLog.getMessageId() > 0) {
                cs.setInt(parNr++, errorLog.getMessageId());
            } else {
                cs.setNull(parNr++, Types.INTEGER);
            }

            if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(orgSettings.getDbProvider())) {
                cs.registerOutParameter(parNr, Types.INTEGER);
            } else {
                cs.registerOutParameter(1, Types.INTEGER);
            }

            cs.execute();

            if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(orgSettings.getDbProvider())) {
                logEntryId = cs.getInt(parNr);
            } else {
                logEntryId = cs.getInt(1);
            }
            cs.close();
            dbConnection.commit();

            return logEntryId;
        } catch (Exception ex) {
            logger.error("LoggingService: Unable to save the error log to database", ex);
            try {
                dbConnection.rollback();
            } catch (SQLException ex1) {
                logger.error("LoggingService: Unable to rollback", ex1);
            }
            return -1;
        }
    }

    public static int logRequest(RequestLog requestLog) {
        Connection dbConnection = DatabaseSessionService.getInstance().getConnection();
        OrgSettings orgSettings = DatabaseSessionService.getInstance().getOrgSettings();

        if (requestLog.getRequestName() == null) {
            logger.error("LoggingService: RequestName is missing. Unable to save the request log");
            return -1;
        }

        if (requestLog.getOrganizationCode() == null) {
            logger.error("LoggingService: Requests organization code is missing. Unable to save the request log");
            return -1;
        }

        if ((dbConnection == null) || (orgSettings == null)) {
            logger.error("LoggingService: Database connection or settings is NULL. Unable to save the request log");
            return -1;
        }

        int logEntryId = -1;

        try {
            Calendar cal = Calendar.getInstance();

            int parNr = 1;
            CallableStatement cs = dbConnection.prepareCall("{call Add_DhlRequestLog(?,?,?,?,?,?,?)}");
            if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                cs = dbConnection.prepareCall("{? = call \"Add_DhlRequestLog\"(?,?,?,?,?,?)}");
            }

            if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(orgSettings.getDbProvider())) {
                cs.setInt(parNr++, 0);
            }
            cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(requestLog.getRequestDateTime()), cal);
            cs.setString(parNr++, requestLog.getOrganizationCode());
            cs.setString(parNr++, requestLog.getUserCode());
            cs.setString(parNr++, requestLog.getRequestName());
            cs.setString(parNr++, requestLog.getResponse());
            if (requestLog.getErrorLogId() > 0) {
                cs.setInt(parNr++, requestLog.getErrorLogId());
            } else {
                cs.setNull(parNr++, Types.INTEGER);
            }

            if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(orgSettings.getDbProvider())) {
                cs.registerOutParameter(parNr, Types.INTEGER);
            } else {
                cs.registerOutParameter(1, Types.INTEGER);
            }

            cs.execute();

            if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(orgSettings.getDbProvider())) {
                logEntryId = cs.getInt(parNr);
            } else {
                logEntryId = cs.getInt(1);
            }
            cs.close();
            dbConnection.commit();

            return logEntryId;
        } catch (Exception ex) {
            logger.error("LoggingService: Unable to save the request log to database", ex);
            try {
                dbConnection.rollback();
            } catch (SQLException ex1) {
                logger.error("LoggingService: Unable to rollback", ex1);
            }
            return -1;
        }
    }

    public static void logMarkDocumentsRequestToDataBases(ArrayList<OrgSettings> currentClientDatabases, RequestLog requestLog) {
        Connection dbConnection = null;
        int markDocumentsReceivedRequestVersion = 0;

        for (OrgSettings db : currentClientDatabases) {
            try {
                dbConnection = null;
                dbConnection = DBConnection.getConnection(db);
                DatabaseSessionService.getInstance().setSession(dbConnection, db);
                markDocumentsReceivedRequestVersion = db.getDvkSettings().getMarkDocumentsReceivedRequestVersion();
                requestLog.setRequestName(requestLog.getRequestName() + String.valueOf(markDocumentsReceivedRequestVersion));
                LoggingService.logRequest(requestLog);
            } catch (Exception ex) {
                ErrorLog errorLog = new ErrorLog(ex, "dvk.client.dhl.service.LoggingService " +
                        " logMarkDocumentsRequestToDataBases");
                LoggingService.logError(errorLog);
            } finally {
                CommonMethods.safeCloseDatabaseConnection(dbConnection);
                DatabaseSessionService.getInstance().clearSession();
            }
        }
    }
}
