package dvk.client.conf;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

public class OrgSettings implements Cloneable {
    
	private static Logger logger = Logger.getLogger(OrgSettings.class);
	
	private String m_dbProvider;
    private String m_serverName;
    private String m_instanceName;
    private String m_serverPort;
    private String m_databaseName;
    private String m_userName;
    private String m_password;
    private String m_processName;
    private String m_schemaName;
    private boolean m_dbToDbCommunicationOnly;
    private int m_deleteOldDocumentsAfterDays;
    private OrgDvkSettings m_dvkSettings;

    public void setDbProvider(String dbProvider) {
        this.m_dbProvider = dbProvider;
    }

    public String getDbProvider() {
        return m_dbProvider;
    }

    public void setServerName(String serverName) {
        this.m_serverName = serverName;
    }

    public String getServerName() {
        return m_serverName;
    }

    public void setInstanceName(String instanceName) {
        this.m_instanceName = instanceName;
    }

    public String getInstanceName() {
        return m_instanceName;
    }

    public void setServerPort(String serverPort) {
        this.m_serverPort = serverPort;
    }

    public String getServerPort() {
        return m_serverPort;
    }

    public void setDatabaseName(String databaseName) {
        this.m_databaseName = databaseName;
    }

    public String getDatabaseName() {
        return m_databaseName;
    }

    public void setUserName(String userName) {
        this.m_userName = userName;
    }

    public String getUserName() {
        return m_userName;
    }

    public void setPassword(String password) {
        this.m_password = password;
    }

    public String getPassword() {
        return m_password;
    }

    public void setProcessName(String processName) {
        this.m_processName = processName;
    }

    public String getProcessName() {
        return m_processName;
    }

    public void setSchemaName(String schemaName) {
        this.m_schemaName = schemaName;
    }

    public String getSchemaName() {
        return m_schemaName;
    }

    public boolean getDbToDbCommunicationOnly() {
		return m_dbToDbCommunicationOnly;
	}

	public void setDbToDbCommunicationOnly(boolean dbToDbCommunicationOnly) {
		m_dbToDbCommunicationOnly = dbToDbCommunicationOnly;
	}

	public int getDeleteOldDocumentsAfterDays() {
		return m_deleteOldDocumentsAfterDays;
	}

	public void setDeleteOldDocumentsAfterDays(int deleteOldDocumentsAfterDays) {
		this.m_deleteOldDocumentsAfterDays = deleteOldDocumentsAfterDays;
	}

	public void setDvkSettings(OrgDvkSettings dvkSettings) {
        this.m_dvkSettings = dvkSettings;
    }

    public OrgDvkSettings getDvkSettings() {
        return m_dvkSettings;
    }
    
    public OrgSettings() {
        clear();
    }

    public void clear() {
        m_dbProvider = CommonStructures.PROVIDER_TYPE_MSSQL;
        m_serverName = "";
        m_instanceName = "";
        m_serverPort = "";
        m_databaseName = "";
        m_userName = "";
        m_password = "";
        m_processName = "";
        m_schemaName = "";
        m_dbToDbCommunicationOnly = false;
        m_deleteOldDocumentsAfterDays = -1;
        m_dvkSettings = new OrgDvkSettings();
    }
    
    public Object clone() throws CloneNotSupportedException {
        return super.clone();
    }

    public static ArrayList<OrgSettings> getSettings(String fileName) {
        try {
        	logger.info("Loading database configuration from file: " + fileName);
            Document confDoc = CommonMethods.xmlDocumentFromFile(fileName, true);

            ArrayList<OrgSettings> result = new ArrayList<OrgSettings>();
            NodeList dbNodes = confDoc.getElementsByTagName("database");
            for (int i = 0; i < dbNodes.getLength(); ++i) {
                result.add(getFromXML(dbNodes.item(i)));
            }
            return result;
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            return new ArrayList<OrgSettings>();
        }
    }

    /**
     * Reads configuration parameters from XML document
     * 
     * @param rootNode
     * 		Root element of XML configuration file (XML document)
     * @return
     * 		{@link OrgSettings} object with filled-in values from configuration file
     */
    private static OrgSettings getFromXML(Node rootNode) {
        Node n;
        NodeList nl = rootNode.getChildNodes();
        OrgSettings result = new OrgSettings();
        for (int i = 0; i < nl.getLength(); ++i) {
            n = nl.item(i);
            if (n.getNodeType() == Node.ELEMENT_NODE) {
                if (n.getLocalName().equalsIgnoreCase("provider")) {
                    result.setDbProvider(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("server_name")) {
                    result.setServerName(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("instance_name")) {
                    result.setInstanceName(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("server_port")) {
                    result.setServerPort(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("database_name")) {
                    result.setDatabaseName(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("username")) {
                    result.setUserName(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("password")) {
                    result.setPassword(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("process_name")) {
                    result.setProcessName(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("dvk_settings")) {
                    result.setDvkSettings(OrgDvkSettings.getFromXML(n));
                } else if (n.getLocalName().equalsIgnoreCase("schema_name")) {
                    result.setSchemaName(CommonMethods.getNodeText(n));
                } else if (n.getLocalName().equalsIgnoreCase("db_to_db_communication_only")) {
                    result.setDbToDbCommunicationOnly(CommonMethods.booleanFromXML(CommonMethods.getNodeText(n)));
                } else if (n.getLocalName().equalsIgnoreCase("delete_old_documents_after_days")) {
                    result.setDeleteOldDocumentsAfterDays(CommonMethods.toIntSafe(CommonMethods.getNodeText(n), -1));
                }
            }
        }
        return result;
    }

    /**
     * Checks if database connection parameters specified in current
     * {@link OrgSettings} instance match the same parameters specified in
     * another {@link OrgSettings} instance.
     *   
     * @param anotherInstance
     *     {@link OrgSettings} instance to compare with this instance.
     * @return
     *     True if current {@link OrgSettings} instance and given
     *     {@link OrgSettings} instance have exactly the same database
     *     connection parameters.  
     */
    public boolean connectionParametersEqual(OrgSettings anotherInstance) {
    	boolean result = CommonMethods.stringsEqualIgnoreNull(this.getDbProvider(), anotherInstance.getDbProvider());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getServerName(), anotherInstance.getServerName());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getInstanceName(), anotherInstance.getInstanceName());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getServerPort(), anotherInstance.getServerPort());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getDatabaseName(), anotherInstance.getDatabaseName());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getUserName(), anotherInstance.getUserName());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getPassword(), anotherInstance.getPassword());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getProcessName(), anotherInstance.getProcessName());
    	result = result && CommonMethods.stringsEqualIgnoreNull(this.getSchemaName(), anotherInstance.getSchemaName());
    	return result;
    }
}
