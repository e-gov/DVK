package dvk.client.dhl.service;

import dvk.client.conf.OrgSettings;

import java.sql.Connection;

public class DatabaseSessionService {

    private Connection connection;
    private OrgSettings orgSettings;

    private static DatabaseSessionService instance = null;

    private DatabaseSessionService() {

    }

    public static DatabaseSessionService getInstance() {
        if (instance == null) {
            instance = new DatabaseSessionService();
        }

        return instance;
    }

    public void setSession(Connection connection, OrgSettings orgSettings) {
        this.connection = connection;
        this.orgSettings = orgSettings;
    }

    public Connection getConnection() {
        return connection;
    }

    public OrgSettings getOrgSettings() {
        return orgSettings;
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

    public void setOrgSettings(OrgSettings orgSettings) {
        this.orgSettings = orgSettings;
    }

    public void clearSession() {
        this.connection = null;
        this.orgSettings = null;
    }
}
