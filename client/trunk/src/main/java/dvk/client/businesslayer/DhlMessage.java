package dvk.client.businesslayer;

import dvk.client.ClientAPI;
import dvk.client.conf.OrgAddressFilter;
import dvk.client.conf.OrgSettings;
import dvk.core.Settings;
import dvk.client.db.DBConnection;
import dvk.client.db.UnitCredential;
import dvk.client.iostructures.Fault;
import dvk.client.iostructures.GetSendStatusResponseItem;
import dvk.client.iostructures.SimpleAddressData;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.FileSplitResult;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Stack;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamReader;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class DhlMessage implements Cloneable {
	
	static Logger logger = Logger.getLogger(ClientAPI.class.getName());
	
	private int m_id;
    private boolean m_isIncoming;
    private String m_filePath;
    private int m_dhlID;
    private String m_dhlGuid;
    private String m_title;
    private String m_senderOrgCode;
    private String m_senderOrgName;
    private String m_senderPersonCode;
    private String m_senderName;
    private String m_proxyOrgCode;
    private String m_proxyOrgName;
    private String m_proxyPersonCode;
    private String m_proxyName;
    private String m_recipientOrgCode;
    private String m_recipientOrgName;
    private String m_recipientPersonCode;
    private String m_recipientName;
    private String m_caseName;
    private String m_dhlFolderName;
    private int m_sendingStatusID;
    private int m_unitID;
    private Date m_sendingDate;
    private Date m_receivedDate;
    private int m_localItemID;
    private int m_recipientStatusID;
    private String m_faultCode;
    private String m_faultActor;
    private String m_faultString;
    private String m_faultDetail;
    private boolean m_statusUpdateNeeded;
    private String m_metaXML;    
    private String m_queryID; // X-tee põringu põise ID
    private ArrayList<MessageRecipient> m_recipients; // sõnumi saajad
    private String m_recipientDepartmentNr;
    private String m_recipientDepartmentName;
    private String m_recipientEmail;
    private int m_recipientDivisionID;
    private String m_recipientDivisionName;
    private int m_recipientPositionID;
    private String m_recipientPositionName;
    private String m_recipientDivisionCode;
    private String m_recipientPositionCode;
    
    // ametikoha_lyhinimetus
    private String m_recipientPositionShortName;
    
    // allyksuse_lyhinimetus
    private String m_recipientDivisionShortName;
    
    // teadmiseks
    private boolean m_fyi;
    
    private int m_containerVersion;
    
    // DeliveryChannel tõidetakse saatmisel ja seda infot
    // andmebaasi ei salvestata.
    private DeliveryChannel m_deliveryChannel;
    

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setIsIncoming(boolean isIncoming) {
        this.m_isIncoming = isIncoming;
    }

    public boolean isIsIncoming() {
        return m_isIncoming;
    }

    public void setFilePath(String filePath) {
        this.m_filePath = filePath;
    }

    public String getFilePath() {
        return m_filePath;
    }

    public void setDhlID(int dhlID) {
        this.m_dhlID = dhlID;
    }

    public int getDhlID() {
        return m_dhlID;
    }

    public String getDhlGuid() {
        return this.m_dhlGuid;
    }

    public void setDhlGuid(String value) {
        this.m_dhlGuid = value;
    }
    
    public void setTitle(String title) {
        this.m_title = title;
    }

    public String getTitle() {
        return m_title;
    }

    public void setSenderOrgCode(String senderOrgCode) {
        this.m_senderOrgCode = senderOrgCode;
    }

    public String getSenderOrgCode() {
        return m_senderOrgCode;
    }

    public void setSenderOrgName(String senderOrgName) {
        this.m_senderOrgName = senderOrgName;
    }

    public String getSenderOrgName() {
        return m_senderOrgName;
    }

    public void setSenderPersonCode(String senderPersonCode) {
        this.m_senderPersonCode = senderPersonCode;
    }

    public String getSenderPersonCode() {
        return m_senderPersonCode;
    }

    public void setSenderName(String senderName) {
        this.m_senderName = senderName;
    }

    public String getSenderName() {
        return m_senderName;
    }

    public String getProxyOrgCode() {
        return m_proxyOrgCode;
    }

    public void setProxyOrgCode(String value) {
        m_proxyOrgCode = value;
    }

    public String getProxyOrgName() {
        return m_proxyOrgName;
    }

    public void setProxyOrgName(String value) {
        m_proxyOrgName = value;
    }

    public String getProxyPersonCode() {
        return m_proxyPersonCode;
    }

    public void setProxyPersonCode(String value) {
        m_proxyPersonCode = value;
    }

    public String getProxyName() {
        return m_proxyName;
    }

    public void setProxyName(String value) {
        m_proxyName = value;
    }

    public void setRecipientOrgCode(String recipientOrgCode) {
        this.m_recipientOrgCode = recipientOrgCode;
    }

    public String getRecipientOrgCode() {
        return m_recipientOrgCode;
    }

    public void setRecipientOrgName(String recipientOrgName) {
        this.m_recipientOrgName = recipientOrgName;
    }

    public String getRecipientOrgName() {
        return m_recipientOrgName;
    }

    public void setRecipientPersonCode(String recipientPersonCode) {
        this.m_recipientPersonCode = recipientPersonCode;
    }

    public String getRecipientPersonCode() {
        return m_recipientPersonCode;
    }

    public void setRecipientName(String recipientName) {
        this.m_recipientName = recipientName;
    }

    public String getRecipientName() {
        return m_recipientName;
    }

    public void setCaseName(String caseName) {
        this.m_caseName = caseName;
    }

    public String getCaseName() {
        return m_caseName;
    }

    public void setDhlFolderName(String dhlFolderName) {
        this.m_dhlFolderName = dhlFolderName;
    }

    public String getDhlFolderName() {
        return m_dhlFolderName;
    }

    public void setSendingStatusID(int sendingStatusID) {
        this.m_sendingStatusID = sendingStatusID;
    }

    public int getSendingStatusID() {
        return m_sendingStatusID;
    }

    public void setUnitID(int unitID) {
        this.m_unitID = unitID;
    }

    public int getUnitID() {
        return m_unitID;
    }

    public void setSendingDate(Date sendingDate) {
        this.m_sendingDate = sendingDate;
    }

    public Date getSendingDate() {
        return m_sendingDate;
    }

    public void setReceivedDate(Date receivedDate) {
        this.m_receivedDate = receivedDate;
    }

    public Date getReceivedDate() {
        return m_receivedDate;
    }

    public void setLocalItemID(int localItemID) {
        this.m_localItemID = localItemID;
    }

    public int getLocalItemID() {
        return m_localItemID;
    }

    public int getRecipientStatusID() {
        return m_recipientStatusID;
    }

    public void setRecipientStatusID(int recipientStatusID) {
        m_recipientStatusID = recipientStatusID;
    }

    public String getFaultCode() {
        return m_faultCode;
    }

    public void setFaultCode(String faultCode) {
        m_faultCode = faultCode;
    }

    public String getFaultActor() {
        return m_faultActor;
    }

    public void setFaultActor(String faultActor) {
        m_faultActor = faultActor;
    }

    public String getFaultString() {
        return m_faultString;
    }

    public void setFaultString(String faultString) {
        m_faultString = faultString;
    }

    public String getFaultDetail() {
        return m_faultDetail;
    }

    public void setFaultDetail(String faultDetail) {
        m_faultDetail = faultDetail;
    }

    public boolean getStatusUpdateNeeded() {
        return m_statusUpdateNeeded;
    }

    public void setStatusUpdateNeeded(boolean statusUpdateNeeded) {
        m_statusUpdateNeeded = statusUpdateNeeded;
    }


    public ArrayList<MessageRecipient> getRecipients() {
        return m_recipients;
    }

    public void  setRecipients(ArrayList<MessageRecipient> messageRecipients) {
        m_recipients = messageRecipients;
    }
    
    public Fault getFault() {
        if (((m_faultCode == null) || (m_faultCode.trim().length() == 0)) && ((m_faultActor == null) || (m_faultActor.trim().length() == 0)) && ((m_faultString == null) || (m_faultString.trim().length() == 0)) && ((m_faultDetail == null) || (m_faultDetail.trim().length() == 0))) {
            return null;
        } else {
            return new Fault(m_faultCode, m_faultActor, m_faultString, m_faultDetail);
        }
    }

    public void setMetaXML(String metaXML) {
        this.m_metaXML = metaXML;
    }

    public String getMetaXML() {
        return m_metaXML;
    }

    public void setQueryID(String queryID) {
        this.m_queryID = queryID;
    }

    public String getQueryID() {
        return m_queryID;
    }

    public String getRecipientDepartmentNr() {
        return m_recipientDepartmentNr;
    }

    public void setRecipientDepartmentNr(String value) {
        m_recipientDepartmentNr = value;
    }

    public String getRecipientDepartmentName() {
        return m_recipientDepartmentName;
    }

    public void setRecipientDepartmentName(String value) {
        m_recipientDepartmentName = value;
    }

    public String getRecipientEmail() {
        return m_recipientEmail;
    }

    public void setRecipientEmail(String value) {
        m_recipientEmail = value;
    }

    public int getRecipientDivisionID() {
        return m_recipientDivisionID;
    }

    public void setRecipientDivisionID(int value) {
        m_recipientDivisionID = value;
    }

    public String getRecipientDivisionName() {
        return m_recipientDivisionName;
    }

    public void setRecipientDivisionName(String value) {
        m_recipientDivisionName = value;
    }

    public int getRecipientPositionID() {
        return m_recipientPositionID;
    }

    public void setRecipientPositionID(int value) {
        m_recipientPositionID = value;
    }

    public String getRecipientPositionName() {
        return m_recipientPositionName;
    }

    public void setRecipientPositionName(String value) {
        m_recipientPositionName = value;
    }

    public String getRecipientDivisionCode() {
        return this.m_recipientDivisionCode;
    }

    public void setRecipientDivisionCode(String value) {
        this.m_recipientDivisionCode = value;
    }

    public String getRecipientPositionCode() {
        return this.m_recipientPositionCode;
    }

    public void setRecipientPositionCode(String value) {
        this.m_recipientPositionCode = value;
    }
    
    public DeliveryChannel getDeliveryChannel() {
        return this.m_deliveryChannel;
    }

    public void setDeliveryChannel(DeliveryChannel value) {
        this.m_deliveryChannel = value;
    }
    
    public static String generateGUID() {
    	return java.util.UUID.randomUUID().toString();
    }

	public String getRecipientPositionShortName() {
		return m_recipientPositionShortName;
	}

	public void setRecipientPositionShortName(String positionShortName) {
		m_recipientPositionShortName = positionShortName;
	}

	public String getRecipientDivisionShortName() {
		return m_recipientDivisionShortName;
	}

	public void setRecipientDivisionShortName(String divisionShortName) {
		m_recipientDivisionShortName = divisionShortName;
	}

	public boolean isFyi() {
		return m_fyi;
	}

	public void setFyi(boolean fyi) {
		this.m_fyi = fyi;
	}

	public int getContainerVersion() {
		return m_containerVersion;
	}

	public void setContainerVersion(int version) {
		m_containerVersion = version;
	}
    
    public DhlMessage() {
        clear();
    }
    
    public DhlMessage(int id, boolean metadataOnly, OrgSettings db, Connection dbConnection) throws Exception {
        clear();
        this.getByID(id, metadataOnly, db, dbConnection);
    }

    public DhlMessage(String dataFilePath, UnitCredential unit) throws Exception {
        clear();
        m_filePath = dataFilePath;
        loadFromXML(dataFilePath, unit);
    }

    public void clear() {
        m_id = 0;
        m_isIncoming = false;
        m_filePath = "";
        m_dhlID = 0;
        m_dhlGuid = generateGUID();
        m_title = "";
        m_senderOrgCode = "";
        m_senderOrgName = "";
        m_senderPersonCode = "";
        m_senderName = "";
        m_proxyOrgCode = "";
        m_proxyOrgName = "";
        m_proxyPersonCode = "";
        m_proxyName = "";
        m_recipientOrgCode = "";
        m_recipientOrgName = "";
        m_recipientPersonCode = "";
        m_recipientName = "";
        m_caseName = "";
        m_dhlFolderName = "";
        m_sendingStatusID = Settings.Client_StatusWaiting;
        m_unitID = 0;
        m_sendingDate = null;
        m_receivedDate = null;
        m_localItemID = 0;
        m_recipientStatusID = 0;
        m_faultCode = "";
        m_faultActor = "";
        m_faultString = "";
        m_faultDetail = "";
        m_statusUpdateNeeded = false;
        m_metaXML = "";
        m_queryID = "";
        m_recipientDepartmentNr = "";
        m_recipientDepartmentName = "";
        m_recipientEmail = "";
        m_recipientDivisionID = 0;
        m_recipientDivisionName = "";
        m_recipientPositionID = 0;
        m_recipientPositionName = "";
        m_recipientDivisionCode = "";
        m_recipientPositionCode = "";
        m_deliveryChannel = new DeliveryChannel();
    }

    public void getByID(int id, boolean metadataOnly, OrgSettings db, Connection dbConnection) throws Exception {
        try {
            if (dbConnection != null) {
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                Calendar cal = Calendar.getInstance();
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlMessageByID", 3, db, dbConnection);
	                cs.setInt(parNr++, id);
	                cs.setInt(parNr++, (metadataOnly ? 1 : 0));
	                
	                ResultSet rs = DBConnection.getResultSet(cs, db, 2);
	                while (rs.next()) {
	                    this.setId(rs.getInt("dhl_message_id"));
	                    this.setIsIncoming(rs.getBoolean("is_incoming"));                    
	                    
	                    if (!metadataOnly) {
	                    	String itemDataFile = CommonMethods.createPipelineFile(0);
	                    	this.setFilePath(itemDataFile);
	                    	
	                    	if (CommonStructures.PROVIDER_TYPE_POSTGRE.equalsIgnoreCase(db.getDbProvider())
	                        	|| CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
	                    		byte[] containerData = rs.getString("data").getBytes("UTF-8");
	                    		logger.debug("Container data was read from database. Container size: " + containerData.length + " bytes.");
	                    		CommonMethods.writeToFile(itemDataFile, containerData);
	                    	} else {
		                        Clob tmpBlob = rs.getClob("data");
		                        Reader r = tmpBlob.getCharacterStream();
		                        FileOutputStream fos = new FileOutputStream(itemDataFile);
		                        OutputStreamWriter out = new OutputStreamWriter(fos, "UTF-8");
		                        try {
			                        long totalSize = 0;
			                        int actualReadLength = 0;
		                            char[] charbuf = new char[Settings.getDBBufferSize()];
		                            while ((actualReadLength = r.read(charbuf)) > 0) {
		                                out.write(charbuf, 0, actualReadLength);
		                                totalSize += actualReadLength;
		                            }
		                            logger.debug("Container data was read from database. Container size: " + totalSize + " characters.");
		                        } catch (Exception e) {
		                            CommonMethods.logError(e, "dhl.Document", "getDocumentsSentTo");
		                            throw e;
		                        } finally {
		                            out.flush();
		                            out.close();
		                        }
	                    	}
	                    }
	                    
	                    this.setTitle(rs.getString("title"));
	                    this.setSenderOrgCode(rs.getString("sender_org_code"));
	                    this.setSenderOrgName(rs.getString("sender_org_name"));
	                    this.setSenderPersonCode(rs.getString("sender_person_code"));
	                    this.setSenderName(rs.getString("sender_name"));
	                    this.setProxyOrgCode(rs.getString("proxy_org_code"));
	                    this.setProxyOrgName(rs.getString("proxy_org_name"));
	                    this.setProxyPersonCode(rs.getString("proxy_person_code"));
	                    this.setProxyName(rs.getString("proxy_name"));
	                    this.setRecipientOrgCode(rs.getString("recipient_org_code"));
	                    this.setRecipientOrgName(rs.getString("recipient_org_name"));
	                    this.setRecipientPersonCode(rs.getString("recipient_person_code"));
	                    this.setRecipientName(rs.getString("recipient_name"));
	                    this.setCaseName(rs.getString("case_name"));
	                    this.setDhlFolderName(rs.getString("dhl_folder_name"));
	                    this.setSendingStatusID(rs.getInt("sending_status_id"));
	                    this.setUnitID(rs.getInt("unit_id"));
	                    this.setDhlID(rs.getInt("dhl_id"));
	                    this.setSendingDate(rs.getDate("sending_date", cal));
	                    this.setReceivedDate(rs.getDate("received_date", cal));
	                    this.setLocalItemID(rs.getInt("local_item_id"));
	                    this.setRecipientStatusID(rs.getInt("recipient_status_id"));
	                    this.setFaultCode(rs.getString("fault_code"));
	                    this.setFaultActor(rs.getString("fault_actor"));
	                    this.setFaultString(rs.getString("fault_string"));
	                    this.setFaultDetail(rs.getString("fault_detail"));
	                    this.setStatusUpdateNeeded(rs.getBoolean("status_update_needed"));
	                    this.setMetaXML(rs.getString("metaxml"));
	                    this.setQueryID(rs.getString("query_id"));
	                    this.setRecipientDepartmentNr(rs.getString("recipient_department_nr"));
	                    this.setRecipientDepartmentName(rs.getString("recipient_department_name"));
	                    this.setRecipientEmail(rs.getString("recipient_email"));
	                    this.setRecipientDivisionID(rs.getInt("recipient_division_id"));
	                    this.setRecipientDivisionName(rs.getString("recipient_division_name"));
	                    this.setRecipientPositionID(rs.getInt("recipient_position_id"));
	                    this.setRecipientPositionName(rs.getString("recipient_position_name"));
	                    this.setRecipientDivisionCode(rs.getString("recipient_division_code"));
	                    this.setRecipientPositionCode(rs.getString("recipient_position_code"));
	                    this.setDhlGuid(rs.getString("dhl_guid"));
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "getByID");
        }
    }
    
    public static ArrayList<DhlMessage> getList(boolean incoming, int statusID, int unitID, boolean statusUpdateNeeded, boolean metadataOnly, OrgSettings db, Connection dbConnection) {
        
    	logger.debug("Getting messageList...");
    	logger.debug("incoming: " + incoming);
    	logger.debug("statusID: " + statusID);
    	logger.debug("unitID: " + unitID);
    	logger.debug("statusUpdateNeeded: " + statusUpdateNeeded);
    	logger.debug("metadataOnly: " + metadataOnly);
		
		try {
            if (dbConnection != null) {
            	ArrayList<DhlMessage> result = new ArrayList<DhlMessage>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                Calendar cal = Calendar.getInstance();
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlMessages", 5, db, dbConnection);
	                cs.setInt(parNr++, (incoming ? 1 : 0));
	                if (statusID == 0) {
	                    cs.setNull(parNr++, Types.INTEGER);
	                } else {
	                    cs.setInt(parNr++, statusID);
	                }
	                cs.setInt(parNr++, unitID);
	                cs.setInt(parNr++, (statusUpdateNeeded ? 1 : 0));
	                cs.setInt(parNr++, (metadataOnly ? 1 : 0));
	                ResultSet rs = DBConnection.getResultSet(cs, db, 5);
	                int docCounter = 0;
	                while (rs.next()) {
	                    ++docCounter;
	                    DhlMessage item = new DhlMessage();
	                    
	                    if (!metadataOnly){
	                        String itemDataFile = CommonMethods.createPipelineFile(docCounter);
	                        item.setFilePath(itemDataFile);
	                    	
	                    	if (CommonStructures.PROVIDER_TYPE_POSTGRE.equalsIgnoreCase(db.getDbProvider())
	                    		|| CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
	                    		byte[] containerData = rs.getString("data").getBytes("UTF-8");
	                    		logger.debug("Container data was read from database. Container size: " + containerData.length + " bytes.");
	                    		CommonMethods.writeToFile(itemDataFile, containerData);
	                    	} else {
		                        Clob tmpBlob = rs.getClob("data");
		                        Reader r = tmpBlob.getCharacterStream();
		                        FileOutputStream fos = new FileOutputStream(itemDataFile);
		                        OutputStreamWriter out = new OutputStreamWriter(fos, "UTF-8");
		                        try {
			                        long totalSize = 0;
			                        int actualReadLength = 0;
		                            char[] charbuf = new char[Settings.getDBBufferSize()];
		                            while ((actualReadLength = r.read(charbuf)) > 0) {
		                                out.write(charbuf, 0, actualReadLength);
		                                totalSize += actualReadLength;
		                            }
		                            logger.debug("Container data was read from database. Container size: " + totalSize + " characters.");
		                        } catch (Exception e) {
		                            CommonMethods.logError(e, "dvk.client.businesslayer.DhlMessage", "getList");
		                            throw e;
		                        } finally {
		                            out.flush();
		                            out.close();
		                        }
	                    	}
	                    }
	                    
	                    item.setId(rs.getInt("dhl_message_id"));
	                    item.setDhlID(rs.getInt("dhl_id"));
	                    item.setIsIncoming(rs.getBoolean("is_incoming"));                        
	                    item.setTitle(rs.getString("title"));
	                    item.setSenderOrgCode(rs.getString("sender_org_code"));
	                    item.setSenderOrgName(rs.getString("sender_org_name"));
	                    item.setSenderPersonCode(rs.getString("sender_person_code"));
	                    item.setSenderName(rs.getString("sender_name"));
	                    item.setProxyOrgCode(rs.getString("proxy_org_code"));
	                    item.setProxyOrgName(rs.getString("proxy_org_name"));
	                    item.setProxyPersonCode(rs.getString("proxy_person_code"));
	                    item.setProxyName(rs.getString("proxy_name"));
	                    item.setRecipientOrgCode(rs.getString("recipient_org_code"));
	                    item.setRecipientOrgName(rs.getString("recipient_org_name"));
	                    item.setRecipientPersonCode(rs.getString("recipient_person_code"));
	                    item.setRecipientName(rs.getString("recipient_name"));
	                    item.setCaseName(rs.getString("case_name"));
	                    item.setDhlFolderName(rs.getString("dhl_folder_name"));
	                    item.setSendingStatusID(rs.getInt("sending_status_id"));
	                    item.setUnitID(rs.getInt("unit_id"));
	                    item.setSendingDate(rs.getDate("sending_date", cal));
	                    item.setReceivedDate(rs.getDate("received_date", cal));
	                    item.setLocalItemID(rs.getInt("local_item_id"));
	                    item.setRecipientStatusID(rs.getInt("recipient_status_id"));
	                    item.setFaultCode(rs.getString("fault_code"));
	                    item.setFaultActor(rs.getString("fault_actor"));
	                    item.setFaultString(rs.getString("fault_string"));
	                    item.setFaultDetail(rs.getString("fault_detail"));
	                    item.setStatusUpdateNeeded(rs.getBoolean("status_update_needed"));
	                    item.setMetaXML(rs.getString("metaxml"));
	                    item.setQueryID(rs.getString("query_id"));
	                    item.setRecipientDepartmentNr(rs.getString("recipient_department_nr"));
	                    item.setRecipientDepartmentName(rs.getString("recipient_department_name"));
	                    item.setRecipientEmail(rs.getString("recipient_email"));
	                    item.setRecipientDivisionID(rs.getInt("recipient_division_id"));
	                    item.setRecipientDivisionName(rs.getString("recipient_division_name"));
	                    item.setRecipientPositionID(rs.getInt("recipient_position_id"));
	                    item.setRecipientPositionName(rs.getString("recipient_position_name"));
	                    item.setRecipientDivisionCode(rs.getString("recipient_division_code"));
	                    item.setRecipientPositionCode(rs.getString("recipient_position_code"));
	                    item.setDhlGuid(rs.getString("dhl_guid"));
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlMessage", "getList");
            return null;
        }
    }
    
    public int addToDB(OrgSettings db, Connection dbConnection) throws Exception {
        FileInputStream inStream = null;
        InputStreamReader inReader = null;
        BufferedReader reader = null;
        try {
            // Loendame failis olevad tähed kokku, kuna Oracle JDBC draiver tahab
            // kindlasti teada, kui pikk on CLOB väljale kirjutatav stream.
            int fileCharsCount = CommonMethods.getCharacterCountInFile(m_filePath);
            logger.debug("Going to write container data to database. Container length: " + fileCharsCount + " characters.");
            
            inStream = new FileInputStream(m_filePath);
            inReader = new InputStreamReader(inStream, "UTF-8");
            reader = new BufferedReader(inReader);
            
            if (dbConnection != null) {
                Calendar cal = Calendar.getInstance();
                
                int parNr = 1;
                CallableStatement cs = dbConnection.prepareCall("{call Add_DhlMessage(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Add_DhlMessage\"(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                }
                
                // SQL Anywhere JDBC client requires that output parameters are supplied as last parameter(s).
                // Otherwise all input parameters will be incorrectly moved down by one position in parameter list.
                if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	parNr++;
                }
                
                cs.setInt(parNr++, (m_isIncoming ? 1 : 0));
                cs.setCharacterStream(parNr++, reader, fileCharsCount);
                cs.setInt(parNr++, m_dhlID);
                cs.setString(parNr++, m_title);
                cs.setString(parNr++, m_senderOrgCode);
                cs.setString(parNr++, m_senderOrgName);
                cs.setString(parNr++, m_senderPersonCode);
                cs.setString(parNr++, m_senderName);
                cs.setString(parNr++, m_recipientOrgCode);
                cs.setString(parNr++, m_recipientOrgName);
                cs.setString(parNr++, m_recipientPersonCode);
                cs.setString(parNr++, m_recipientName);
                cs.setString(parNr++, m_caseName);
                cs.setString(parNr++, m_dhlFolderName);
                cs.setInt(parNr++, m_sendingStatusID);
                cs.setInt(parNr++, m_unitID);
                cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(m_sendingDate), cal);
                cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(m_receivedDate), cal);
                cs.setInt(parNr++, m_localItemID);
                cs.setInt(parNr++, m_recipientStatusID);
                cs.setString(parNr++, m_faultCode);
                cs.setString(parNr++, m_faultActor);
                cs.setString(parNr++, m_faultString);
                cs.setString(parNr++, m_faultDetail);
                cs.setInt(parNr++, (m_statusUpdateNeeded ? 1 : 0));
                cs.setString(parNr++, m_metaXML);
                cs.setString(parNr++, m_queryID);
                cs.setString(parNr++, m_proxyOrgCode);
                cs.setString(parNr++, m_proxyOrgName);
                cs.setString(parNr++, m_proxyPersonCode);
                cs.setString(parNr++, m_proxyName);
                cs.setString(parNr++, m_recipientDepartmentNr);
                cs.setString(parNr++, m_recipientDepartmentName);
                cs.setString(parNr++, m_recipientEmail);
                cs.setInt(parNr++, m_recipientDivisionID);
                cs.setString(parNr++, m_recipientDivisionName);
                cs.setInt(parNr++, m_recipientPositionID);
                cs.setString(parNr++, m_recipientPositionName);
                cs.setString(parNr++, m_recipientDivisionCode);
                cs.setString(parNr++, m_recipientPositionCode);
                cs.setString(parNr++, m_dhlGuid);
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	cs.registerOutParameter(parNr, Types.INTEGER);
                } else {
                	cs.registerOutParameter(1, Types.INTEGER);
                }
                cs.execute();
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	m_id = cs.getInt(parNr);
                } else {
                	m_id = cs.getInt(1);
                }
                cs.close();

                return m_id;
            } else {
            	logger.debug("Database connection is NULL!");
                throw new SQLException("Database connection is NULL!");
            }
        } finally {
            CommonMethods.safeCloseReader(reader);
            CommonMethods.safeCloseReader(inReader);
            CommonMethods.safeCloseStream(inStream);
            inStream = null;
            inReader = null;
            reader = null;
        }
    }

    public boolean updateInDB(OrgSettings db, Connection dbConnection) {
        FileInputStream inStream = null;
        InputStreamReader inReader = null;
        BufferedReader reader = null;
        try {
            // Loendame failis olevad tähed kokku, kuna Oracle JDBC draiver tahab
            // kindlasti teada, kui pikk on CLOB väljale kirjutatav stream.
            int fileCharsCount = CommonMethods.getCharacterCountInFile(m_filePath);
            logger.debug("Going to write container data to database. Container length: " + fileCharsCount + " characters.");
            
            inStream = new FileInputStream(m_filePath);
            inReader = new InputStreamReader(inStream, "UTF-8");
            reader = new BufferedReader(inReader);
            
            if (dbConnection != null) {
                Calendar cal = Calendar.getInstance();

                int parNr = 1;
                CallableStatement cs = dbConnection.prepareCall("{call Update_DhlMessage(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Update_DhlMessage\"(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, m_id);
                cs.setInt(parNr++, (m_isIncoming ? 1 : 0));
                cs.setCharacterStream(parNr++, reader, fileCharsCount);
                cs.setInt(parNr++, m_dhlID);
                cs.setString(parNr++, m_title);
                cs.setString(parNr++, m_senderOrgCode);
                cs.setString(parNr++, m_senderOrgName);
                cs.setString(parNr++, m_senderPersonCode);
                cs.setString(parNr++, m_senderName);
                cs.setString(parNr++, m_recipientOrgCode);
                cs.setString(parNr++, m_recipientOrgName);
                cs.setString(parNr++, m_recipientPersonCode);
                cs.setString(parNr++, m_recipientName);
                cs.setString(parNr++, m_caseName);
                cs.setString(parNr++, m_dhlFolderName);
                cs.setInt(parNr++, m_sendingStatusID);
                cs.setInt(parNr++, m_unitID);
                cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(m_sendingDate), cal);
                cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(m_receivedDate), cal);
                cs.setInt(parNr++, m_localItemID);
                cs.setInt(parNr++, m_recipientStatusID);
                cs.setString(parNr++, m_faultCode);
                cs.setString(parNr++, m_faultActor);
                cs.setString(parNr++, m_faultString);
                cs.setString(parNr++, m_faultDetail);
                cs.setInt(parNr++, (m_statusUpdateNeeded ? 1 : 0));
                cs.setString(parNr++, m_metaXML);
                cs.setString(parNr++, m_queryID);
                cs.setString(parNr++, m_proxyOrgCode);
                cs.setString(parNr++, m_proxyOrgName);
                cs.setString(parNr++, m_proxyPersonCode);
                cs.setString(parNr++, m_proxyName);
                cs.setString(parNr++, m_recipientDepartmentNr);
                cs.setString(parNr++, m_recipientDepartmentName);
                cs.setString(parNr++, m_recipientEmail);
                cs.setInt(parNr++, m_recipientDivisionID);
                cs.setString(parNr++, m_recipientDivisionName);
                cs.setInt(parNr++, m_recipientPositionID);
                cs.setString(parNr++, m_recipientPositionName);
                cs.setString(parNr++, m_recipientDivisionCode);
                cs.setString(parNr++, m_recipientPositionCode);
                cs.setString(parNr++, m_dhlGuid);
                cs.execute();
                cs.close();

                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "updateInDB");
            return false;
        } finally {
            CommonMethods.safeCloseReader(reader);
            CommonMethods.safeCloseReader(inReader);
            CommonMethods.safeCloseStream(inStream);
            inStream = null;
            inReader = null;
            reader = null;
        }
    }

    public static int getMessageID(int dhlID, String producerName, String serviceURL, boolean isIncoming, OrgSettings db, Connection dbConnection) {
    	logger.debug("Getting message ID from database. Parameters: ");
    	logger.debug("dhlID: " + dhlID);
    	logger.debug("isIncoming: " + isIncoming);
    	logger.debug("producerName: " + producerName);
    	logger.debug("serviceURL: " + serviceURL);
        try {
            if (dbConnection != null) {
            	int parNr = 1;
            	CallableStatement cs = dbConnection.prepareCall("{call Get_DhlMessageID(?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Get_DhlMessageID\"(?,?,?,?)}");
                }
                
                // SQL Anywhere JDBC client requires that output parameters are supplied as last parameter(s).
                // Otherwise all input parameters will be incorrectly moved down by one position in parameter list.
                if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	parNr++;
                }
                
                cs.setInt(parNr++, dhlID);
                cs.setString(parNr++, producerName);
                cs.setString(parNr++, serviceURL);
                cs.setInt(parNr++, (isIncoming ? 1 : 0));
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	cs.registerOutParameter(parNr, Types.INTEGER);
                } else {
                	cs.registerOutParameter(1, Types.INTEGER);
                }
                cs.execute();
                int result = 0;
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	result = cs.getInt(parNr);
                } else {
                	result = cs.getInt(1);
                }
                cs.close();

                return result;
            } else {
                return 0;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlMessage", "getMessageID");
            return 0;
        }
    }
    
    public static int getMessageID(String dhlGuid, String producerName, String serviceURL, boolean isIncoming, OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
            	int parNr = 1;
                CallableStatement cs = dbConnection.prepareCall("{call Get_DhlMessageIDByGuid(?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Get_DhlMessageIDByGuid\"(?,?,?,?)}");
                }
                
                // SQL Anywhere JDBC client requires that output parameters are supplied as last parameter(s).
                // Otherwise all input parameters will be incorrectly moved down by one position in parameter list.
                if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	parNr++;
                }
                
                cs.setString(parNr++, dhlGuid);
                cs.setString(parNr++, producerName);
                cs.setString(parNr++, serviceURL);
                cs.setInt(parNr++, (isIncoming ? 1 : 0));
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	cs.registerOutParameter(parNr, Types.INTEGER);
                } else {
                	cs.registerOutParameter(1, Types.INTEGER);
                }
                cs.execute();
                int result = 0;
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	result = cs.getInt(parNr);
                } else {
                	result = cs.getInt(1);
                }
                cs.close();

                return result;
            } else {
                return 0;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlMessage", "getMessageID");
            return 0;
        }
    }

    public static boolean updateStatus(int messageID, int statusID, Date sendingDate, boolean statusUpdateNeeded, OrgSettings db, Connection dbConnection) {
        try {
            Calendar cal = Calendar.getInstance();
            if (dbConnection != null) {
                CallableStatement cs = dbConnection.prepareCall("{call Update_DhlMessageStatus(?,?,?,?,?)}");
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Update_DhlMessageStatus\"(?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, messageID);
                cs.setInt(parNr++, statusID);
                cs.setInt(parNr++, (statusUpdateNeeded ? 1 : 0));
                if (statusID == Settings.Client_StatusSent) {
                    cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(new Date()), cal);
                } else {
                    cs.setNull(parNr++, Types.TIMESTAMP);
                }
                if ((sendingDate != null) &&
                	((statusID == Settings.Client_StatusSent) || (statusID == Settings.Client_StatusSending) || (statusID == Settings.Client_StatusCanceled))) {
                    cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(sendingDate), cal);
                } else {
                    cs.setNull(parNr++, Types.TIMESTAMP);
                }
                cs.execute();
                cs.close();

                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
        	logger.error("Exception while updating message status: ", ex);
            CommonMethods.logError(ex, "clnt.businesslayer.DhlMessage", "updateStatus");
            return false;
        }
    }

    public static boolean updateStatus(int messageID, GetSendStatusResponseItem item, OrgSettings db, Connection dbConnection) {
    	logger.debug("Updating message status. Message ID: " + messageID);
        try {
            ArrayList<MessageRecipient> recipients = MessageRecipient.getList(messageID, db, dbConnection);
            Date dateAllReceived = new Date(0L);
            Date dateSent = new Date(0L);
            for (int i = 0; i < item.getRecipients().size(); ++i) {
                MessageRecipient r = item.getRecipients().get(i);
                if ((r.getSendingStatusID() == Settings.Client_StatusSent) && (dateAllReceived.compareTo(r.getReceivedDate()) < 0)) {
                    dateAllReceived = r.getReceivedDate();
                }
                if (dateSent.compareTo(r.getSendingDate()) < 0) {
                    dateSent = r.getSendingDate();
                }

                MessageRecipient originalRecipient = MessageRecipient.FindRecipientFromList(recipients, r.getRecipientOrgCode(), r.getRecipientPersonCode());
                if (originalRecipient != null) {
                	logger.debug("Original recipient is defined. Saving messageRecipient to database.");
                    // Kuna antud juhul on ilmselt tegemist DVK serveri poolel automaatselt
                    // lisatud adressaadiga, siis jääb siin määramata saatmise põringu ID
                    originalRecipient.setSendingDate(r.getSendingDate());
                    originalRecipient.setSendingStatusID(r.getSendingStatusID());
                    originalRecipient.setReceivedDate(r.getReceivedDate());
                    originalRecipient.setRecipientStatusID(r.getRecipientStatusID());
                    originalRecipient.setMetaXML(r.getMetaXML());
                    originalRecipient.setFaultCode(r.getFaultCode());
                    originalRecipient.setFaultActor(r.getFaultActor());
                    originalRecipient.setFaultString(r.getFaultString());
                    originalRecipient.setFaultDetail(r.getFaultDetail());
                    originalRecipient.setDhlId(r.getDhlID());
                    originalRecipient.saveToDB(db, dbConnection);
                } else {
                	logger.debug("Original recipient is undefined. Saving messageRecipient to database.");
                    r.setMessageID(messageID);
                    r.saveToDB(db, dbConnection);
                }
            }
            
            // Ajaloo salvestamine andmebaasi
            if ((item.getHistory() != null) && (item.getHistory().size() > 0)) {
            	for (int i = 0; i < item.getHistory().size(); i++) {
            		DocumentStatusHistory historyItem = item.getHistory().get(i); 

            		// õritame nõõd adressaadi andmete mõõramata adressaadi ID ka tuvastada
	                int recipientId = MessageRecipient.getId(messageID, historyItem.getOrgCode(), historyItem.getPersonCode(), historyItem.getSubdivisionShortName(), historyItem.getOccupationShortName(), db, dbConnection);
	                if (recipientId > 0) {
	                	historyItem.setRecipientId(recipientId);
	                	historyItem.saveToDB(db, dbConnection);
	                } else {
	                	logger.info("Cannot save history event "+ String.valueOf(historyItem.getServerSideId()) +" to DB because matching recipient was not found!");
	                }
            	}
            }

            Calendar cal = Calendar.getInstance();
            cal.setTime(dateSent);
            cal.add(Calendar.DAY_OF_YEAR, Settings.Client_SentMessageStatusFollowupDays);
            boolean statusUpdateNeeded = (cal.getTime().compareTo(new Date()) > 0);

            if (dbConnection != null) {
                CallableStatement cs = dbConnection.prepareCall("{call Update_DhlMessageStatus(?,?,?,?,?)}");
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Update_DhlMessageStatus\"(?,?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, messageID);
                cs.setInt(parNr++, item.getSendingStatusID());
                cs.setInt(parNr++, (statusUpdateNeeded ? 1 : 0));
                if (item.getSendingStatusID() == Settings.Client_StatusSent) {
                    cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(dateAllReceived), cal);
                } else {
                    cs.setNull(parNr++, Types.TIMESTAMP);
                }
                cs.setNull(parNr++, Types.TIMESTAMP);
                cs.execute();
                cs.close();

                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlMessage", "updateStatus");
            return false;
        }
    }

    public boolean updateDhlID(OrgSettings db, Connection dbConnection) {
    	logger.debug("Updating DhlId...");
        try {
            if (dbConnection != null) {
                CallableStatement cs = dbConnection.prepareCall("{call Update_DhlMessageDhlID(?,?,?,?)}");
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Update_DhlMessageDhlID\"(?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, m_id);
                cs.setInt(parNr++, m_dhlID);
                cs.setString(parNr++, m_queryID);
                cs.setString(parNr++, m_dhlGuid);
                cs.execute();
                cs.close();
                return true;
            } else {
            	logger.warn("Database connection is null.");
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "updateDhlID");
            return false;
        }
    }

    public boolean updateStatusUpdateNeed(OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
                CallableStatement cs = dbConnection.prepareCall("{call Update_DhlMsgStatusUpdateNeed(?,?)}");
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Update_DhlMsgStatusUpdateNeed\"(?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, m_id);
                if (m_statusUpdateNeeded) {
                    cs.setInt(parNr++, 1);
                } else {
                    cs.setNull(parNr++, Types.INTEGER);
                }
                cs.execute();
                cs.close();
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "updateStatusUpdateNeed");
            return false;
        }
    }
    
    public static ArrayList<DhlMessage> getByDhlID(int dhlID, boolean incoming, boolean metadataOnly, OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
            	ArrayList<DhlMessage> result = new ArrayList<DhlMessage>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                Calendar cal = Calendar.getInstance();
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlMessagesByDhlID", 3, db, dbConnection);
	                cs.setInt(parNr++, dhlID);
	                cs.setInt(parNr++, (incoming ? 1 : 0));
	                cs.setInt(parNr++, (metadataOnly ? 1 : 0));
	                ResultSet rs = DBConnection.getResultSet(cs, db, 3);
	                int docCounter = 0;
	                while (rs.next()) {
	                    ++docCounter;
	                    DhlMessage item = new DhlMessage();
	                    item.setId(rs.getInt("dhl_message_id"));
	                    item.setIsIncoming(rs.getBoolean("is_incoming"));                    
	                    
	                    if (!metadataOnly) {
	                        String itemDataFile = CommonMethods.createPipelineFile(docCounter);
	                        item.setFilePath(itemDataFile);
	                    	
	                    	if (CommonStructures.PROVIDER_TYPE_POSTGRE.equalsIgnoreCase(db.getDbProvider())
	                            || CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
	                    		byte[] containerData = rs.getString("data").getBytes("UTF-8");
	                    		logger.debug("Container data was read from database. Container size: " + containerData.length + " bytes.");
	                    		CommonMethods.writeToFile(itemDataFile, containerData);
	                    	} else {
		                        Clob tmpBlob = rs.getClob("data");
		                        Reader r = tmpBlob.getCharacterStream();
		                        FileOutputStream fos = new FileOutputStream(itemDataFile);
		                        OutputStreamWriter out = new OutputStreamWriter(fos, "UTF-8");
		                        try {
			                        long totalSize = 0;
			                        int actualReadLength = 0;
		                            char[] charbuf = new char[Settings.getDBBufferSize()];
		                            while ((actualReadLength = r.read(charbuf)) > 0) {
		                                out.write(charbuf, 0, actualReadLength);
		                                totalSize += actualReadLength;
		                            }
		                            logger.debug("Container data was read from database. Container size: " + totalSize + " characters.");
		                        } catch (Exception e) {
		                            CommonMethods.logError(e, "dhl.Document", "getDocumentsSentTo");
		                            throw e;
		                        } finally {
		                            out.flush();
		                            out.close();
		                        }
	                    	}
	                    }
	                    
	                    item.setTitle(rs.getString("title"));
	                    item.setSenderOrgCode(rs.getString("sender_org_code"));
	                    item.setSenderOrgName(rs.getString("sender_org_name"));
	                    item.setSenderPersonCode(rs.getString("sender_person_code"));
	                    item.setSenderName(rs.getString("sender_name"));
	                    item.setProxyOrgCode(rs.getString("proxy_org_code"));
	                    item.setProxyOrgName(rs.getString("proxy_org_name"));
	                    item.setProxyPersonCode(rs.getString("proxy_person_code"));
	                    item.setProxyName(rs.getString("proxy_name"));
	                    item.setRecipientOrgCode(rs.getString("recipient_org_code"));
	                    item.setRecipientOrgName(rs.getString("recipient_org_name"));
	                    item.setRecipientPersonCode(rs.getString("recipient_person_code"));
	                    item.setRecipientName(rs.getString("recipient_name"));
	                    item.setCaseName(rs.getString("case_name"));
	                    item.setDhlFolderName(rs.getString("dhl_folder_name"));
	                    item.setSendingStatusID(rs.getInt("sending_status_id"));
	                    item.setUnitID(rs.getInt("unit_id"));
	                    item.setDhlID(rs.getInt("dhl_id"));
	                    item.setSendingDate(rs.getDate("sending_date", cal));
	                    item.setReceivedDate(rs.getDate("received_date", cal));
	                    item.setLocalItemID(rs.getInt("local_item_id"));
	                    item.setRecipientStatusID(rs.getInt("recipient_status_id"));
	                    item.setFaultCode(rs.getString("fault_code"));
	                    item.setFaultActor(rs.getString("fault_actor"));
	                    item.setFaultString(rs.getString("fault_string"));
	                    item.setFaultDetail(rs.getString("fault_detail"));
	                    item.setStatusUpdateNeeded(rs.getBoolean("status_update_needed"));
	                    item.setMetaXML(rs.getString("metaxml"));
	                    item.setQueryID(rs.getString("query_id"));
	                    item.setRecipientDepartmentNr(rs.getString("recipient_department_nr"));
	                    item.setRecipientDepartmentName(rs.getString("recipient_department_name"));
	                    item.setRecipientEmail(rs.getString("recipient_email"));
	                    item.setRecipientDivisionID(rs.getInt("recipient_division_id"));
	                    item.setRecipientDivisionName(rs.getString("recipient_division_name"));
	                    item.setRecipientPositionID(rs.getInt("recipient_position_id"));
	                    item.setRecipientPositionName(rs.getString("recipient_position_name"));
	                    item.setRecipientDivisionCode(rs.getString("recipient_division_code"));
	                    item.setRecipientPositionCode(rs.getString("recipient_position_code"));
	                    item.setDhlGuid(rs.getString("dhl_guid"));
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlMessage", "updateStatusUpdateNeed");
            return null;
        }
    }

    public static ArrayList<DhlMessage> getByGUID(String guid, boolean incoming, boolean metadataOnly, OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
            	ArrayList<DhlMessage> result = new ArrayList<DhlMessage>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                Calendar cal = Calendar.getInstance();
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlMessageByGUID", 3, db, dbConnection);
	                cs.setString(parNr++, guid);
	                cs.setInt(parNr++, (incoming ? 1 : 0));
	                cs.setInt(parNr++, (metadataOnly ? 1 : 0));
	                ResultSet rs = DBConnection.getResultSet(cs, db, 3);
	                int docCounter = 0;
	                while (rs.next()) {
	                    ++docCounter;
	                    DhlMessage item = new DhlMessage();
	                    item.setId(rs.getInt("dhl_message_id"));
	                    item.setIsIncoming(rs.getBoolean("is_incoming"));                    
	                    
	                    if (!metadataOnly) {
	                        String itemDataFile = CommonMethods.createPipelineFile(docCounter);
	                        item.setFilePath(itemDataFile);
	                    	
	                    	if (CommonStructures.PROVIDER_TYPE_POSTGRE.equalsIgnoreCase(db.getDbProvider())
	                            || CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
	                    		byte[] containerData = rs.getString("data").getBytes("UTF-8");
	                    		logger.debug("Container data was read from database. Container size: " + containerData.length + " bytes.");
	                    		CommonMethods.writeToFile(itemDataFile, containerData);
	                    	} else {
		                        Clob tmpBlob = rs.getClob("data");
		                        Reader r = tmpBlob.getCharacterStream();
		                        FileOutputStream fos = new FileOutputStream(itemDataFile);
		                        OutputStreamWriter out = new OutputStreamWriter(fos, "UTF-8");
		                        try {
			                        long totalSize = 0;
			                        int actualReadLength = 0;
		                        	char[] charbuf = new char[Settings.getDBBufferSize()];
		                            while ((actualReadLength = r.read(charbuf)) > 0) {
		                                out.write(charbuf, 0, actualReadLength);
		                                totalSize += actualReadLength;
		                            }
		                            logger.debug("Container data was read from database. Container size: " + totalSize + " characters.");
		                        } catch (Exception e) {
		                            CommonMethods.logError(e, "dhl.Document", "getDocumentsSentTo");
		                            throw e;
		                        } finally {
		                            out.flush();
		                            out.close();
		                        }
	                    	}
	                    }
	                    
	                    item.setTitle(rs.getString("title"));
	                    item.setSenderOrgCode(rs.getString("sender_org_code"));
	                    item.setSenderOrgName(rs.getString("sender_org_name"));
	                    item.setSenderPersonCode(rs.getString("sender_person_code"));
	                    item.setSenderName(rs.getString("sender_name"));
	                    item.setProxyOrgCode(rs.getString("proxy_org_code"));
	                    item.setProxyOrgName(rs.getString("proxy_org_name"));
	                    item.setProxyPersonCode(rs.getString("proxy_person_code"));
	                    item.setProxyName(rs.getString("proxy_name"));
	                    item.setRecipientOrgCode(rs.getString("recipient_org_code"));
	                    item.setRecipientOrgName(rs.getString("recipient_org_name"));
	                    item.setRecipientPersonCode(rs.getString("recipient_person_code"));
	                    item.setRecipientName(rs.getString("recipient_name"));
	                    item.setCaseName(rs.getString("case_name"));
	                    item.setDhlFolderName(rs.getString("dhl_folder_name"));
	                    item.setSendingStatusID(rs.getInt("sending_status_id"));
	                    item.setUnitID(rs.getInt("unit_id"));
	                    item.setDhlID(rs.getInt("dhl_id"));
	                    item.setSendingDate(rs.getDate("sending_date", cal));
	                    item.setReceivedDate(rs.getDate("received_date", cal));
	                    item.setLocalItemID(rs.getInt("local_item_id"));
	                    item.setRecipientStatusID(rs.getInt("recipient_status_id"));
	                    item.setFaultCode(rs.getString("fault_code"));
	                    item.setFaultActor(rs.getString("fault_actor"));
	                    item.setFaultString(rs.getString("fault_string"));
	                    item.setFaultDetail(rs.getString("fault_detail"));
	                    item.setStatusUpdateNeeded(rs.getBoolean("status_update_needed"));
	                    item.setMetaXML(rs.getString("metaxml"));
	                    item.setQueryID(rs.getString("query_id"));
	                    item.setRecipientDepartmentNr(rs.getString("recipient_department_nr"));
	                    item.setRecipientDepartmentName(rs.getString("recipient_department_name"));
	                    item.setRecipientEmail(rs.getString("recipient_email"));
	                    item.setRecipientDivisionID(rs.getInt("recipient_division_id"));
	                    item.setRecipientDivisionName(rs.getString("recipient_division_name"));
	                    item.setRecipientPositionID(rs.getInt("recipient_position_id"));
	                    item.setRecipientPositionName(rs.getString("recipient_position_name"));
	                    item.setRecipientDivisionCode(rs.getString("recipient_division_code"));
	                    item.setRecipientPositionCode(rs.getString("recipient_position_code"));
	                    item.setDhlGuid(rs.getString("dhl_guid"));
	                    result.add(item);
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
                return null;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "clnt.businesslayer.DhlMessage", "updateStatusUpdateNeed");
            return null;
        }
    }
    
    public void loadFromXML(String dataFilePath, UnitCredential unit) throws Exception {
        UnitCredential[] units = new UnitCredential[] {unit};
        ArrayList<DhlMessage> messageList = getFromXML(dataFilePath, units);
        if (!messageList.isEmpty()) {
            DhlMessage msg = messageList.get(0);
            this.m_recipientOrgCode = msg.m_recipientOrgCode;
            this.m_recipientOrgName = msg.m_recipientOrgName;
            this.m_recipientPersonCode = msg.m_recipientPersonCode;
            this.m_recipientName = msg.m_recipientName;
            this.m_dhlID = msg.m_dhlID;
            this.m_dhlFolderName = msg.m_dhlFolderName;
            this.m_sendingDate = msg.m_sendingDate;
            this.m_title = msg.m_title;
            this.m_senderOrgName = msg.m_senderOrgName;
            this.m_senderName = msg.m_senderName;
            this.m_senderPersonCode = msg.m_senderPersonCode;
            this.m_senderOrgCode = msg.m_senderOrgCode;
            this.m_proxyName = msg.m_proxyName;
            this.m_proxyPersonCode = msg.m_proxyPersonCode;
            this.m_proxyOrgCode = msg.m_proxyOrgCode;
            this.m_proxyName = msg.m_proxyName;
            this.m_recipientDivisionID = msg.m_recipientDivisionID;
            this.m_recipientDivisionName = msg.m_recipientDivisionName;
            this.m_recipientPositionID = msg.m_recipientPositionID;
            this.m_recipientPositionName = msg.m_recipientPositionName;
            this.m_recipientDivisionCode = msg.m_recipientDivisionCode;
            this.m_recipientPositionCode = msg.m_recipientPositionCode;
            this.m_dhlGuid = msg.m_dhlGuid;
            msg = null;
        }
        messageList = null;
        units = null;
    }
    
    // Lisab sõnumi XMLi transpordi saajate osasse etteantud saajad (eemaldab õleliigsed)
    // võljastab uue faili PATHi, eisalgne faile jõõb ka alles
    public String CreateNewFile(ArrayList<String> allowedOrgs, int containerVersion)throws Exception{
        String newFile = "";
        // Kopeerime dokumendi faili uueks tõõfailiks
        String simplifiedFile = CommonMethods.createPipelineFile(0);
        if (CommonMethods.copyFile(getFilePath(), simplifiedFile)) {
            newFile = CommonMethods.createPipelineFile(1);
            
            FileSplitResult splitResult = null;
            if(containerVersion == 1) {
            	splitResult = CommonMethods.splitOutTags(simplifiedFile, "SignedDoc", false, false, false);
            } else {
            	splitResult = CommonMethods.splitOutTags(simplifiedFile, "failid", false, false, false);
            }
            FileOutputStream out = null;
            OutputStreamWriter ow = null;
            BufferedWriter bw = null;
            try {
                CommonMethods.changeTransportData(splitResult.mainFile, allowedOrgs, false);
                out = new FileOutputStream(newFile, false);
                ow = new OutputStreamWriter(out, "UTF-8");
                bw = new BufferedWriter(ow);
                CommonMethods.joinSplitXML(splitResult.mainFile, bw);
            } finally {
                CommonMethods.safeCloseWriter(bw);
                CommonMethods.safeCloseWriter(ow);
                CommonMethods.safeCloseStream(out);
            }            
        } else {
            throw new Exception("Dokumendi faili kopeerimine edastamiseks ebaõnnestus!");
        }
        return newFile;
    }
    
    public String createNewFile(ArrayList<MessageRecipient> allowedRecipients, int containerVersion) throws Exception{
        String newFile = "";
        
        // Kopeerime dokumendi faili uueks tõõfailiks
        if (!CommonMethods.isNullOrEmpty(this.m_filePath) && (new File(this.m_filePath)).exists()) {
	        String simplifiedFile = CommonMethods.createPipelineFile(0);
	        if (CommonMethods.copyFile(this.m_filePath, simplifiedFile)) {
	            newFile = CommonMethods.createPipelineFile(1);
	            
	            FileSplitResult splitResult = null;
	            if(containerVersion == 1) {
	            	splitResult = CommonMethods.splitOutTags(simplifiedFile, "SignedDoc", false, false, false);
	            } else {
	            	splitResult = CommonMethods.splitOutTags(simplifiedFile, "failid", false, false, false);
	            }
	           
	            FileOutputStream out = null;
	            OutputStreamWriter ow = null;
	            BufferedWriter bw = null;
	            try {
	            	createNewXmlFileForSpecifiedRecipients(splitResult.mainFile, allowedRecipients, false);
	                out = new FileOutputStream(newFile, false);
	                ow = new OutputStreamWriter(out, "UTF-8");
	                bw = new BufferedWriter(ow);
	                CommonMethods.joinSplitXML(splitResult.mainFile, bw);
	            } finally {
	                CommonMethods.safeCloseWriter(bw);
	                CommonMethods.safeCloseWriter(ow);
	                CommonMethods.safeCloseStream(out);
	            }            
	        } else {
	            throw new Exception("Dokumendi faili kopeerimine edastamiseks ebaõnnestus!");
	        }
        }
        
        return newFile;
    }
    
    public static ArrayList<DhlMessage> getFromXML(String dataFilePath, UnitCredential[] units) throws Exception {
        String TAG_DOKUMENT = "dokument";
        String TAG_TRANSPORT = "transport";
        String TAG_METAINFO = "metainfo";
        String TAG_METAXML = "metaxml";
        String TAG_RK_LETTERMETADATA_V1 = "LetterMetaData";
        String TAG_SAATJA = "saatja";
        String TAG_SAAJA = "saaja";
        String TAG_VAHENDAJA = "vahendaja";
        String recipientOrgCode = "";
        String recipientOrgName = "";
        String recipientPersonCode = "";
        String recipientPersonName = "";
        String recipientEmail = "";
        String recipientDepartmentNr = "";
        String recipientDepartmentName = "";
        int recipientDivisionID = 0;
        int recipientPositionID = 0;
        String recipientDivisionName = "";
        String recipientPositionName = "";
        String recipientDivisionCode = "";
        String recipientPositionCode = "";
        
        String recipientDivisionShortName = "";
        String recipientPositionShortName = "";
        boolean fyi = false;
        int containerVersion = 1;
        
        String rkTitle = "";
        String rkType = "";
        Stack<String> hierarchy = new Stack<String>();
        ArrayList<SimpleAddressData> addr = new ArrayList<SimpleAddressData>();
        
        DhlMessage templateMessage = new DhlMessage();
        templateMessage.setFilePath(dataFilePath);
        templateMessage.setContainerVersion(containerVersion);
        
        XMLInputFactory inputFactory = XMLInputFactory.newInstance();
        XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(dataFilePath), "UTF-8");

        try {
            while (reader.hasNext()) {
                reader.next();

                if (reader.hasName()) {
                    if (reader.getLocalName().equalsIgnoreCase(TAG_DOKUMENT) && reader.isStartElement()) {
                        hierarchy.push(TAG_DOKUMENT);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_DOKUMENT) && reader.isEndElement()) {
                        if (hierarchy.peek() == TAG_DOKUMENT) {
                            hierarchy.pop();
                            break;
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_METAINFO) && reader.isStartElement() && (hierarchy.peek() == TAG_DOKUMENT)) {
                        hierarchy.push(TAG_METAINFO);
                    } else if (reader.getLocalName().equalsIgnoreCase("konteineri_versioon") && reader.isStartElement() && (hierarchy.peek() == TAG_DOKUMENT)) {
                    	reader.next();
                        if (reader.isCharacters()) {
                        	String tmpContainerVersion = reader.getText().trim();
                        	containerVersion = Integer.parseInt(tmpContainerVersion);
                        	templateMessage.setContainerVersion(containerVersion);
                        } else {
                        	logger.debug("Tag <konteineri_versioon> does not contain character data.");
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_METAINFO) && reader.isEndElement() && (hierarchy.peek() == TAG_METAINFO)) {
                        if (hierarchy.peek() == TAG_METAINFO) {
                            hierarchy.pop();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_METAXML) && reader.isStartElement() && (hierarchy.peek() == TAG_DOKUMENT)) {
                        hierarchy.push(TAG_METAXML);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_METAXML) && reader.isEndElement() && (hierarchy.peek() == TAG_METAXML)) {
                        if (hierarchy.peek() == TAG_METAXML) {
                            hierarchy.pop();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_TRANSPORT) && reader.isStartElement() && (hierarchy.peek() == TAG_DOKUMENT)) {
                        hierarchy.push(TAG_TRANSPORT);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_TRANSPORT) && reader.isEndElement() && (hierarchy.peek() == TAG_TRANSPORT)) {
                        if (hierarchy.peek() == TAG_TRANSPORT) {
                            hierarchy.pop();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_SAATJA) && reader.isStartElement() && (hierarchy.peek() == TAG_TRANSPORT)) {
                        hierarchy.push(TAG_SAATJA);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_SAATJA) && reader.isEndElement() && (hierarchy.peek() == TAG_SAATJA)) {
                        if (hierarchy.peek() == TAG_SAATJA) {
                            hierarchy.pop();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_VAHENDAJA) && reader.isStartElement() && (hierarchy.peek() == TAG_TRANSPORT)) {
                        hierarchy.push(TAG_VAHENDAJA);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_VAHENDAJA) && reader.isEndElement() && (hierarchy.peek() == TAG_VAHENDAJA)) {
                        if (hierarchy.peek() == TAG_VAHENDAJA) {
                            hierarchy.pop();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_RK_LETTERMETADATA_V1) && reader.isStartElement() && (hierarchy.peek() == TAG_METAXML)) {
                        hierarchy.push(TAG_RK_LETTERMETADATA_V1);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_RK_LETTERMETADATA_V1) && reader.isEndElement() && (hierarchy.peek() == TAG_RK_LETTERMETADATA_V1)) {
                        if (hierarchy.peek() == TAG_RK_LETTERMETADATA_V1) {
                            hierarchy.pop();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_SAAJA) && reader.isStartElement() && (hierarchy.peek() == TAG_TRANSPORT)) {
                        hierarchy.push(TAG_SAAJA);
                        recipientOrgCode = "";
                        recipientOrgName = "";
                        recipientPersonCode = "";
                        recipientPersonName = "";
                        recipientEmail = "";
                        recipientDepartmentNr = "";
                        recipientDepartmentName = "";
                        recipientDivisionID = 0;
                        recipientPositionID = 0;
                        recipientDivisionName = "";
                        recipientPositionName = "";
                        recipientDivisionCode = "";
                        recipientPositionCode = "";
                        
                        recipientDivisionShortName = "";
                        recipientPositionShortName = "";
                        
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_SAAJA) && reader.isEndElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        if (hierarchy.peek() == TAG_SAAJA) {
                            hierarchy.pop();
                            for (int i = 0; i < units.length; ++i) {
                            	logger.debug("recipientOrgCode: " + recipientOrgCode);
                            	logger.debug("units[i].getInstitutionCode(): " + units[i].getInstitutionCode());
                                if (recipientOrgCode.equalsIgnoreCase(units[i].getInstitutionCode())) {
                                    SimpleAddressData a = new SimpleAddressData();
                                    a.setOrgCode(recipientOrgCode);
                                    a.setOrgName(recipientOrgName);
                                    a.setPersonCode(recipientPersonCode);
                                    a.setPersonName(recipientPersonName);
                                    a.setEmail(recipientEmail);
                                    a.setDepartmentNr(recipientDepartmentNr);
                                    a.setDepartmentName(recipientDepartmentName);
                                    a.setDivisionID(recipientDivisionID);
                                    a.setPositionID(recipientPositionID);
                                    a.setUnitID(units[i].getUnitID());
                                    a.setPositionName(recipientPositionName);
                                    a.setDivisionName(recipientDivisionName);
                                    a.setPositionCode(recipientPositionCode);
                                    a.setDivisionCode(recipientDivisionCode);
                                    a.setDivisionShortName(recipientDivisionShortName);
                                    a.setPositionShortName(recipientPositionShortName);
                                    a.setFyi(fyi);
                                    logger.debug("Adding address data to array.");
                                    addr.add(a);
                                    
                                    // Kui tegemist on esimese leitud kohaliku adressaadiga, siis kirjutame
                                    // selle andmed kohe ka sõnumi kõlge.
                                    if (addr.size() == 1) {
                                        templateMessage.m_recipientOrgCode = recipientOrgCode;
                                        templateMessage.m_recipientOrgName = recipientOrgName;
                                        templateMessage.m_recipientPersonCode = recipientPersonCode;
                                        templateMessage.m_recipientName = recipientPersonName;
                                        templateMessage.m_recipientEmail = recipientEmail;
                                        templateMessage.m_recipientDepartmentNr = recipientDepartmentNr;
                                        templateMessage.m_recipientDepartmentName = recipientDepartmentName;
                                        templateMessage.m_recipientDivisionID = recipientDivisionID;
                                        templateMessage.m_recipientDivisionCode = recipientDivisionCode;
                                        templateMessage.m_recipientDivisionName = recipientDivisionName;
                                        templateMessage.m_recipientDivisionShortName = recipientDivisionShortName;
                                        templateMessage.m_recipientPositionID = recipientPositionID;
                                        templateMessage.m_recipientPositionCode = recipientPositionCode;
                                        templateMessage.m_recipientPositionName = recipientPositionName;
                                        templateMessage.m_recipientDivisionShortName = recipientPositionShortName;
                                        templateMessage.setFyi(fyi);
                                        templateMessage.m_unitID = units[i].getUnitID();
                                    }
                                }
                            }
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("dhl_id") && reader.isStartElement() && (hierarchy.peek() == TAG_METAINFO)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_dhlID = Integer.parseInt(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("dokument_guid") && reader.isStartElement() && (hierarchy.peek() == TAG_METAINFO)) {
                    	logger.debug("Found element <dokument_guid>. Reading data...");
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_dhlGuid = reader.getText().trim();
                            logger.debug("Setting message GUID to: " + templateMessage.m_dhlGuid);
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("dhl_kaust") && reader.isStartElement() && (hierarchy.peek() == TAG_METAINFO)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_dhlFolderName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("dhl_saabumisaeg") && reader.isStartElement() && (hierarchy.peek() == TAG_METAINFO)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_sendingDate = CommonMethods.getDateFromXML(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("dhl_saatja_asutuse_nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_METAINFO)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_senderOrgName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("dhl_saaja_asutuse_nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_METAINFO)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_recipientOrgName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("koostaja_dokumendinimi") && reader.isStartElement() && (hierarchy.peek() == TAG_METAINFO)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_title = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_SAATJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_senderName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("isikukood") && reader.isStartElement() && (hierarchy.peek() == TAG_SAATJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_senderPersonCode = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("regnr") && reader.isStartElement() && (hierarchy.peek() == TAG_SAATJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_senderOrgCode = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("asutuse_nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_SAATJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_senderOrgName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_VAHENDAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_proxyName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("isikukood") && reader.isStartElement() && (hierarchy.peek() == TAG_VAHENDAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_proxyPersonCode = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("regnr") && reader.isStartElement() && (hierarchy.peek() == TAG_VAHENDAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_proxyOrgCode = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("asutuse_nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_VAHENDAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            templateMessage.m_proxyOrgName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("regnr") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientOrgCode = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("asutuse_nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientOrgName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("isikukood") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientPersonCode = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientPersonName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("epost") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientEmail = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("osakonna_kood") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientDepartmentNr = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("osakonna_nimi") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientDepartmentName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("ametikoha_kood") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientPositionCode = reader.getText().trim();
                        	recipientPositionID = CommonMethods.toIntSafe(reader.getText().trim(), 0);
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("allyksuse_kood") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                        	recipientDivisionCode = reader.getText().trim();
                            recipientDivisionID = CommonMethods.toIntSafe(reader.getText().trim(), 0);
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("ametikoha_nimetus") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientPositionName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("allyksuse_nimetus") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientDivisionName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("allyksuse_lyhinimetus") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientDivisionShortName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("ametikoha_lyhinimetus") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            recipientPositionShortName = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("teadmiseks") && reader.isStartElement() && (hierarchy.peek() == TAG_SAAJA)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            String fyiTmp = reader.getText().trim();
                            if(fyiTmp != null && !fyiTmp.trim().equalsIgnoreCase("")) {
                            	try {
                            		Boolean b = new Boolean(fyiTmp);
                            		fyi = b.booleanValue();
                            	} catch (Exception e) {
                            		logger.warn("Could not parse string to boolean: " + fyiTmp, e);
                            	}
                            } else {
                            	fyi = false;
                            }
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("Title") && reader.isStartElement() && (hierarchy.peek() == TAG_RK_LETTERMETADATA_V1)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            rkTitle = reader.getText().trim();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("Type") && reader.isStartElement() && (hierarchy.peek() == TAG_RK_LETTERMETADATA_V1)) {
                        reader.next();
                        if (reader.isCharacters()) {
                            rkType = reader.getText().trim();
                        }
                    }
                }
            }
        } finally {
            reader.close();
        }

        // Kui dokumendi pealkiri ei ole esitatud võljal mm:koostaja_dokumendinimi, siis
        // võõrtustame selle Riigikantselei XML-is oleva pealkirja või dokumendiliigi
        // mõõramata (dokumendiliigi mõõramata võõrtustamine on kasulik ennekõike Kodanikuportaali)
        // andmete puhul, kuna seal on reeglina pealkiri võõrtustamata.
        if (templateMessage != null) {
            if ((templateMessage.m_title == null) || (templateMessage.m_title.length() < 1)) {
                if ((rkTitle != null) && (rkTitle.length() > 0)) {
                    templateMessage.m_title = rkTitle;
                } else if ((rkType != null) && (rkType.length() > 0)) {
                    templateMessage.m_title = rkType;
                }
            }
        }
        
        ArrayList<DhlMessage> result = new ArrayList<DhlMessage>();
        result.add(templateMessage);
        if (addr.size() > 1) {
            for (int i = 1; i < addr.size(); ++i) {
                SimpleAddressData a = addr.get(i);
                DhlMessage tmpMsg = (DhlMessage)templateMessage.clone();
                tmpMsg.m_recipientOrgCode = a.getOrgCode();
                tmpMsg.m_recipientOrgName = a.getOrgName();
                tmpMsg.m_recipientPersonCode = a.getPersonCode();
                tmpMsg.m_unitID = a.getUnitID();
                result.add(tmpMsg);
            }
        } else {
        	logger.debug("No addressee defined.");
        }
        
        return result;
    }
    
    public Object clone() throws CloneNotSupportedException {
        DhlMessage clone = (DhlMessage)super.clone();
        return clone;
    }
    
    public void loadRecipientsFromXML() {
        if (this.m_recipients == null) {
        	this.m_recipients = new ArrayList<MessageRecipient>();
        } else {
        	this.m_recipients.clear();
        }
    	
    	ArrayList<SimpleAddressData> recipients = null;
        try {
            recipients = extractRecipientData(this.m_filePath);
        } catch(Exception ex) {
            CommonMethods.logError(ex, "dvk.client.businesslayer.DhlMessage", "loadRecipientsFromXML");
            recipients = null;
        }
        
        if ((recipients != null) && !recipients.isEmpty()) {
            for (int i = 0; i < recipients.size(); i++) {
                SimpleAddressData xmlRec = recipients.get(i);
                MessageRecipient newRecipient = new MessageRecipient();
                newRecipient.setMessageID(this.m_id);
                newRecipient.setRecipientName(xmlRec.getPersonName());
                newRecipient.setRecipientOrgCode(xmlRec.getOrgCode());
                newRecipient.setRecipientOrgName(xmlRec.getOrgName());
                newRecipient.setRecipientPersonCode(xmlRec.getPersonCode());
                newRecipient.setRecipientDivisionID(xmlRec.getDivisionID());
                newRecipient.setRecipientDivisionCode(xmlRec.getDivisionCode());
                newRecipient.setRecipientDivisionName(xmlRec.getDivisionName());
                newRecipient.setRecipientPositionID(xmlRec.getPositionID());
                newRecipient.setRecipientPositionCode(xmlRec.getPositionCode());
                newRecipient.setRecipientPositionName(xmlRec.getPositionName());
                newRecipient.setSendingStatusID(this.m_sendingStatusID);
                this.m_recipients.add(newRecipient);
            }
        }
    }
    
    public static void prepareUnsentMessages(int unitID, OrgSettings db, Connection dbConnection) {
        ArrayList<DhlMessage> messages = DhlMessage.getList(false, Settings.Client_StatusWaiting, unitID, false, false, db, dbConnection);
        for (int i = 0; i < messages.size(); ++i) {
            DhlMessage msg = messages.get(i);
            
            // Kui saadetava sõnumi GUID on mõõramata, siis anname sõnumile GUID-i
            // ja salvestame selle kohe ka andmebaasi.
            if ((msg.getDhlGuid() == null) || (msg.getDhlGuid().length() < 1)) {
            	msg.setDhlGuid(generateGUID());
            	msg.updateDhlID(db, dbConnection);
            }
            
            ArrayList<MessageRecipient> msgRec = MessageRecipient.getList(msg.getId(), db, dbConnection);
            ArrayList<SimpleAddressData> recipients = null;
            try {
                recipients = extractRecipientData(msg.getFilePath());
            } catch(Exception ex) {
                CommonMethods.logError(ex, "dvk.client.businesslayer.DhlMessage", "prepareUnsentMessages");
                recipients = null;
            }
            
            if ((recipients != null) && !recipients.isEmpty()) {
                for (int k = 0; k < recipients.size(); ++k) {
                    SimpleAddressData xmlRec = recipients.get(k);
                    boolean exists = false;
                    for (int m = 0; m < msgRec.size(); ++m) {
                        MessageRecipient rec = msgRec.get(m);
                        if (rec.getRecipientOrgCode().equalsIgnoreCase(xmlRec.getOrgCode()) &&
                            rec.getRecipientPersonCode().equalsIgnoreCase(xmlRec.getPersonCode()) &&
                            (rec.getRecipientDivisionID() == xmlRec.getDivisionID()) &&
                            (rec.getRecipientDivisionCode() == xmlRec.getDivisionCode()) &&
                            (rec.getRecipientDivisionCode().equalsIgnoreCase(xmlRec.getDivisionCode())) &&
                            (rec.getRecipientPositionID() == xmlRec.getPositionID()) &&
                            (rec.getRecipientPositionCode() == xmlRec.getPositionCode()) &&
                            (rec.getRecipientPositionCode().equalsIgnoreCase(xmlRec.getPositionCode()))) {
                            exists = true;
                            rec = null;
                            break;
                        }
                        rec = null;
                    }
                    if (!exists) {
                        MessageRecipient newRecipient = new MessageRecipient();
                        newRecipient.setMessageID(msg.getId());
                        newRecipient.setRecipientName(xmlRec.getPersonName());
                        newRecipient.setRecipientOrgCode(xmlRec.getOrgCode());
                        newRecipient.setRecipientOrgName(xmlRec.getOrgName());
                        newRecipient.setRecipientPersonCode(xmlRec.getPersonCode());
                        newRecipient.setRecipientDivisionID(xmlRec.getDivisionID());
                        newRecipient.setRecipientDivisionCode(xmlRec.getDivisionCode());
                        newRecipient.setRecipientDivisionName(xmlRec.getDivisionName());
                        newRecipient.setRecipientPositionID(xmlRec.getPositionID());
                        newRecipient.setRecipientPositionCode(xmlRec.getPositionCode());
                        newRecipient.setRecipientPositionName(xmlRec.getPositionName());
                        newRecipient.setSendingStatusID(msg.getSendingStatusID());
                        newRecipient.saveToDB(db, dbConnection);
                        logger.info("Extracted reipient "+ newRecipient.getRecipientOrgCode() +" from XML and added to database.");
                    }
                }
            }
        }
    }
    
    public static ArrayList<SimpleAddressData> extractRecipientData(String xmlFilePath) throws Exception {
        String TAG_DOKUMENT = "dokument";
        String TAG_TRANSPORT = "transport";
        String TAG_SAAJA = "saaja";
        Stack<String> hierarchy = new Stack<String>();
        ArrayList<SimpleAddressData> result = new ArrayList<SimpleAddressData>();
        SimpleAddressData item = null;
        
        XMLInputFactory inputFactory = XMLInputFactory.newInstance();
        XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(xmlFilePath), "UTF-8");

        logger.debug("Starting to read XML.");
        
        try {
            while (reader.hasNext()) {            	
                reader.next();

                if (reader.hasName()) {
                    if (reader.getLocalName().equalsIgnoreCase(TAG_DOKUMENT) && reader.isStartElement()) {
                        hierarchy.push(TAG_DOKUMENT);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_DOKUMENT) && reader.isEndElement()) {
                        if (TAG_DOKUMENT.equalsIgnoreCase(hierarchy.peek())) {
                            hierarchy.pop();
                            break;
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_TRANSPORT) && reader.isStartElement() && TAG_DOKUMENT.equalsIgnoreCase(hierarchy.peek())) {
                        hierarchy.push(TAG_TRANSPORT);
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_TRANSPORT) && reader.isEndElement() && TAG_TRANSPORT.equalsIgnoreCase(hierarchy.peek())) {
                        if (TAG_TRANSPORT.equalsIgnoreCase(hierarchy.peek())) {
                            hierarchy.pop();
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_SAAJA) && reader.isStartElement() && TAG_TRANSPORT.equalsIgnoreCase(hierarchy.peek())) {
                        hierarchy.push(TAG_SAAJA);
                        item = new SimpleAddressData();
                    } else if (reader.getLocalName().equalsIgnoreCase(TAG_SAAJA) && reader.isEndElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        if (TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                            hierarchy.pop();
                            result.add(item);
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("regnr") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setOrgCode(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("asutuse_nimi") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setOrgName(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("isikukood") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setPersonCode(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("nimi") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setPersonName(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("epost") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setEmail(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("osakonna_kood") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setDepartmentNr(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("osakonna_nimi") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setDepartmentName(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("ametikoha_kood") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setPositionID(CommonMethods.toIntSafe(reader.getText().trim(), 0));
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("allyksuse_kood") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setDivisionID(CommonMethods.toIntSafe(reader.getText().trim(), 0));
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("ametikoha_lyhinimetus") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                        	item.setPositionCode(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("allyksuse_lyhinimetus") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                        	item.setDivisionCode(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("ametikoha_nimetus") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setPositionName(reader.getText().trim());
                        }
                    } else if (reader.getLocalName().equalsIgnoreCase("allyksuse_nimetus") && reader.isStartElement() && TAG_SAAJA.equalsIgnoreCase(hierarchy.peek())) {
                        reader.next();
                        if (reader.isCharacters()) {
                            item.setDivisionName(reader.getText().trim());
                        }
                    }
                    
                }
            }
        } finally {
            reader.close();
        }
        return result;
    }
    
    /**
     *  Eemaldab DVK konteineri <transport> plokist need asutused, kellele pole
     *  antud dokumenti enam vaja edastada.
     */
    public static void createNewXmlFileForSpecifiedRecipients(String filePath, ArrayList<MessageRecipient> allowedRecipients, boolean addProxy) throws Exception {
    	logger.info("XML Fail: " + filePath);
    	org.w3c.dom.Document currentXmlContent = CommonMethods.xmlDocumentFromFile(filePath, true);
        Element transportNode = null;

        // Tuvastame katse-eksituse meetodil õige nimeruumi.
        String namespaceUri = CommonStructures.DhlNamespace;
        NodeList foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(namespaceUri, "transport");
        if (foundNodes.getLength() < 1) {
        	namespaceUri = CommonStructures.DhlNamespaceV2;
            foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(namespaceUri, "transport");
        }
        
        if (foundNodes.getLength() > 0) {
            transportNode = (Element)foundNodes.item(0);
            foundNodes = transportNode.getElementsByTagNameNS(namespaceUri, "saaja");
            
            logger.info("Leitud adressaate: " + String.valueOf(foundNodes.getLength()));
            
            // Eemaldame saajate hulgast nende asutuste/isikute andmed,
            // kellele on dokument antud serveri piires juba kohale toimetatud
            int recipientIndex = 0;
            while (recipientIndex < foundNodes.getLength()) {
            	Element recipientRoot = (Element)foundNodes.item(recipientIndex);
            	
            	logger.info("Adressaat nr " + String.valueOf(recipientIndex));
            	String regNr = "";
            	String personalIdCode = "";
            	int subdivisionId = 0;
            	int occupationId = 0;
            	String subdivisionShortName = "";
            	String occupationShortName = "";
            	
            	// Adressaadi asutuse registrikood XML konteineris
            	NodeList regNrNodes = recipientRoot.getElementsByTagNameNS(namespaceUri, "regnr");
                if (regNrNodes.getLength() > 0) {
                    regNr = CommonMethods.getNodeText(regNrNodes.item(0));
                }
                
                // Adressaadi isikukood XML konteineris
            	NodeList personalIdNodes = recipientRoot.getElementsByTagNameNS(namespaceUri, "isikukood");
                if (personalIdNodes.getLength() > 0) {
                	personalIdCode = CommonMethods.getNodeText(personalIdNodes.item(0));
                }
                
                // Adressaadi allõksuse kood XML konteineris
            	NodeList subdivisionNodes = recipientRoot.getElementsByTagNameNS(namespaceUri, "allyksuse_kood");
                if (subdivisionNodes.getLength() > 0) {
                	try {
                		subdivisionId = Integer.parseInt(CommonMethods.getNodeText(subdivisionNodes.item(0)));
                	} catch (Exception ex) {
                		logger.warn("Unable to parse value of \"allyksuse_kood\" to integer. Defaulting to 0.");
                		subdivisionId = 0;
                	}
                }
                
                // Adressaadi ametikoha kood XML konteineris
            	NodeList occupationNodes = recipientRoot.getElementsByTagNameNS(namespaceUri, "ametikoha_kood");
                if (occupationNodes.getLength() > 0) {
                	try {
                		occupationId = Integer.parseInt(CommonMethods.getNodeText(occupationNodes.item(0)));
                	} catch (Exception ex) {
                		logger.warn("Unable to parse value of \"ametikoha_kood\" to integer. Defaulting to 0.");
                		occupationId = 0;
                	}
                }
                
                // Adressaadi allõksuse lõhinimetus XML konteineris
            	NodeList subdivisionSnNodes = recipientRoot.getElementsByTagNameNS(namespaceUri, "allyksuse_lyhinimetus");
                if (subdivisionSnNodes.getLength() > 0) {
                	subdivisionShortName = CommonMethods.getNodeText(subdivisionSnNodes.item(0));
                }
                
                // Adressaadi ametikoha lõhinimetus XML konteineris
            	NodeList occupationSnNodes = recipientRoot.getElementsByTagNameNS(namespaceUri, "ametikoha_lyhinimetus");
                if (occupationSnNodes.getLength() > 0) {
                	occupationShortName = CommonMethods.getNodeText(occupationSnNodes.item(0));
                }
                
                boolean recipientFound = false;
                for (MessageRecipient recipient : allowedRecipients) {
                	if (recipient.getRecipientOrgCode().equalsIgnoreCase(regNr)
                		&& CommonMethods.stringsEqualIgnoreNull(recipient.getRecipientPersonCode(), personalIdCode)
                		&& (recipient.getRecipientDivisionID() == subdivisionId)
                		&& (recipient.getRecipientPositionID() == occupationId)
                		&& CommonMethods.stringsEqualIgnoreNull(recipient.getRecipientDivisionCode(), subdivisionShortName)
                		&& CommonMethods.stringsEqualIgnoreNull(recipient.getRecipientPositionCode(), occupationShortName)) {
                		recipientFound = true;
                	}
                }
                
                if (!recipientFound) {
                    transportNode.removeChild(recipientRoot);
                    logger.info("");
                	logger.info("Failist võlja visatud asutus");
                	logger.info("Reg nr: " + regNr);
                	logger.info("Isikukood: " + personalIdCode);
                	logger.info("allõksuse ID: " + String.valueOf(subdivisionId));
                	logger.info("Ametikoha ID: " + String.valueOf(occupationId));
                	logger.info("allõksuse lõhinimetus: " + subdivisionShortName);
                	logger.info("Ametikoha lõhinimetus: " + occupationShortName);
                } else {
                	recipientIndex++;
                	logger.info("");
                	logger.info("Uude faili lubatud asutus.");
                	logger.info("Reg nr: " + regNr);
                	logger.info("Isikukood: " + personalIdCode);
                	logger.info("allõksuse ID: " + String.valueOf(subdivisionId));
                	logger.info("Ametikoha ID: " + String.valueOf(occupationId));
                	logger.info("allõksuse lõhinimetus: " + subdivisionShortName);
                	logger.info("Ametikoha lõhinimetus: " + occupationShortName);
                }
            }
            
            // Tuvastame DHL nimeruumi prefiksi
            String defaultPrefix = currentXmlContent.lookupPrefix(namespaceUri);
            if (defaultPrefix == null) {
                defaultPrefix = "dhl";
                int prefixCounter = 0;
                while (currentXmlContent.lookupNamespaceURI(defaultPrefix) != null) {
                    prefixCounter++;
                    defaultPrefix = "dhl" + String.valueOf(prefixCounter);
                }
            }
            
            // Mõrgime antud DVK serveri sõnumi vahendajaks
            if (addProxy){
                Element elProxy = currentXmlContent.createElementNS(namespaceUri, defaultPrefix + ":vahendaja");
                elProxy = CommonMethods.appendTextNode(currentXmlContent, elProxy, "regnr", Settings.Client_DefaultOrganizationCode, defaultPrefix, namespaceUri);
                elProxy = CommonMethods.appendTextNode(currentXmlContent, elProxy, "isikukood", Settings.Client_DefaultPersonCode, defaultPrefix, namespaceUri);
                transportNode.appendChild(elProxy);
            }
        }

        // Salvestame muudetud XML andmed faili
        CommonMethods.xmlElementToFile(currentXmlContent.getDocumentElement(), filePath);
    }
    
    /**
     * Jaotab sõnumi iga erineva edastuskanali jaoks omaette alamsõnumiteks.
     * Alamsõnumid erinevad õksteisest DVK konteineri <transport> elemendis
     * asuvate adressaatide poolest.
     * 
     * @return		Alamsõnumite nimekiri
     */
    public ArrayList<DhlMessage> splitMessageByDeliveryChannel(OrgSettings myDatabase, ArrayList<OrgSettings> allKnownDatabases, int containerVersion, Connection dbConnection) throws Exception {
    	
		logger.debug("Splitting messages by delivery channel.");
		
		ArrayList<DhlMessage> result = new ArrayList<DhlMessage>();
    	
    	if ((this.m_recipients == null) || (this.m_recipients.size() < 1)) {
    		this.m_recipients = MessageRecipient.getList(this.m_id, myDatabase, dbConnection);
    	}
    	
		// Kontrollime, kas mõnedele adressaatidele saaks otse andmebaasist
    	// andmebaasi saata.
    	// 
    	// Esmalt eraldame adressaatide hulgast need adressaadid, kes
    	// on saatjaga samas asutuses.
    	String senderOrgCode = this.m_senderOrgCode;
    	ArrayList<MessageRecipient> allRecipients = this.getRecipients();
    	ArrayList<MessageRecipient> centralServerRecipients = allRecipients;	    	
    	ArrayList<MessageRecipient> myOrgRecipients = new ArrayList<MessageRecipient>(); 
    	if ((allRecipients.size() == 1) && (allRecipients.get(0).getRecipientOrgCode().equalsIgnoreCase(senderOrgCode))) {
    		myOrgRecipients = allRecipients;
    	} else if (allRecipients.size() > 1) {
    		for (int i = 0; i < allRecipients.size(); i++) {
    			if (allRecipients.get(i).getRecipientOrgCode().equalsIgnoreCase(senderOrgCode)) {
    				myOrgRecipients.add(allRecipients.get(i));
    			}
    		}
    	}
    	logger.info("Minuga samas asutuses on " + String.valueOf(myOrgRecipients.size()) + " adressaati.");
    	
    	// Kui mõni adressaat on saatjaga samas asutuses, siis tuvastame,
    	// kas meil on teada andmebaasiõhendus dokumendi otse saatmiseks.
    	//
		// Isegi juhul, kui sama dokument lõheb samas andmebaasis mitmele
		// adressaadile, saadame ta sinna mitmes eksemplaris. Vastasel juhul
		// ei saa adressaadipõhiselt jõlgida, milline adressaat on dokumendi
		// kõtte saanud ja milline mitte.
		for (OrgSettings db : allKnownDatabases) {
			// Teise andmebaasi dhl_settings andmebaasis on kirjas, millise
			// asutuse, allõksuse ja ametikohaga on tegemist.
			UnitCredential[] orgsInDB = UnitCredential.getCredentials(db, dbConnection);
			for (int j = 0; j < orgsInDB.length; j++) {
				UnitCredential cred = orgsInDB[j];
				if (cred.getInstitutionCode().equalsIgnoreCase(senderOrgCode)) {
					OrgAddressFilter addressFilter = new OrgAddressFilter();
					addressFilter.setSubdivisionId(cred.getDivisionID());
					addressFilter.setOccupationId(cred.getOccupationID());
					addressFilter.setSubdivisionCode(cred.getDivisionShortName());
					addressFilter.setOccupationCode(cred.getOccupationShortName());
					ArrayList<MessageRecipient> directSendRecipients = addressFilter.getMatchingRecipients(myOrgRecipients);
					for (int k = 0; k < directSendRecipients.size(); k++) {
						MessageRecipient rec = directSendRecipients.get(k);
						
						DhlMessage newMessage = (DhlMessage)this.clone();
						newMessage.m_deliveryChannel = new DeliveryChannel();
						newMessage.m_deliveryChannel.setDatabase(db);
						newMessage.m_deliveryChannel.setUnitId(cred.getUnitID());
						newMessage.m_deliveryChannel.setRecipient(rec);
						result.add(newMessage);
						logger.info("Added message clone for direct copy delivery");
						
						if (centralServerRecipients.contains(rec)) {
							centralServerRecipients.remove(rec);
						}
					}
				}
			}
		}
    	
    	// Tuvastame, kas mõnele adressaadile tuleks ka DVK keskserveri kaudu saata.
    	if ((centralServerRecipients != null) && (centralServerRecipients.size() > 0)) {
    		DhlMessage centralServerMessage = (DhlMessage)this.clone();
    		String centralServerFilePath = centralServerMessage.createNewFile(centralServerRecipients, containerVersion);
    		centralServerMessage.setFilePath(centralServerFilePath);
    		
    		// Uuendame objektis olevat adressaatide nimekirja vastavalt
    		// XML konteineris tehtud muudatustele.
    		centralServerMessage.loadRecipientsFromXML();
    		
        	// Leiame nimekirja erinevatest serveritest, kuhu antud dokument tuleks saata.
        	// S.t. kui dokument peab jõudma erinevatele adressaatidele erinevate serverite kaudu
        	ArrayList<DhlCapability> destinationServers = DhlCapability.getListByMessageID(centralServerMessage.getId(), myDatabase, dbConnection);
            
        	// Võtame filtreerimiseks võlja kõigi teadaolevate asutuste nimekirja
        	ArrayList<DhlCapability> allKnownOrgs = DhlCapability.getList(myDatabase, dbConnection);
        	
        	// Kui serverite massiiv on tõhi, siis lisame sinna
            // õhe tõhja võõrtuse DVK keskserveri jaoks
            if (destinationServers == null) {
            	destinationServers = new ArrayList<DhlCapability>();
            }
            if (destinationServers.size() < 1) {
                DhlCapability defaultServer = new DhlCapability();
                defaultServer.setIsDhlCapable(true);
                defaultServer.setIsDhlDirectCapable(false);
                defaultServer.setDhlDirectProducerName("");
                defaultServer.setDhlDirectServiceUrl("");
                destinationServers.add(defaultServer);
            }
            
            // Komplekteerime erinevate serverite jaoks omaette alamsõnumid
            for (int i = 0; i < destinationServers.size(); i++){
                // Paneme kokku konkreetsesse serverisse saadetavate saajate sõnumi,
            	// ehk siis  eemaldame saajate hulgast need, kes selles sihtserveris ei paikne
                String currentProducer = destinationServers.get(i).getDhlDirectProducerName();
                String currentServiceUrl = destinationServers.get(i).getDhlDirectServiceUrl();
                if (((currentServiceUrl == null)) || (currentServiceUrl.length() == 0)) {
                    currentServiceUrl = Settings.Client_ServiceUrl;
                }
                if ((currentProducer == null) || (currentProducer.length() == 0)) {
                    currentProducer = Settings.Client_ProducerName;
                }
                
                // Filtreerime võlja asutused, kes saavad sõnumit aktiivse (indexiga i) DVK serveri kaudu
                ArrayList<String> orgs = DhlCapability.getOrgsByCapability(destinationServers.get(i), myDatabase, dbConnection); // nimekiri asutuse koodidest
                if ((orgs != null) && (orgs.size() > 0)) {
                	DhlMessage newMessage = (DhlMessage)centralServerMessage.clone();
                	
                	ArrayList<String> allowedOrgs = new ArrayList<String>();
                    for(MessageRecipient mr : newMessage.getRecipients()){
                    	if (orgs.contains(mr.getRecipientOrgCode())){
                            allowedOrgs.add(mr.getRecipientOrgCode());
                        } else {
                        	// Kontrollime, kas me sellist asutust õldse tunneme.
                        	// Kui ei tunne, siis õrme teda igaks juhuks võlja viska.
                        	boolean orgFound = false;
                        	for (int j = 0; j < allKnownOrgs.size(); j++) {
                        		if (CommonMethods.stringsEqualIgnoreNull(allKnownOrgs.get(i).getOrgCode(), mr.getRecipientOrgCode())) {
                        			orgFound = true;
                        			break;
                        		}
                        	}
                        	if (!orgFound) {
                        		allowedOrgs.add(mr.getRecipientOrgCode());
                        	}
                        }
                    }
                    
                    String newFilePath = newMessage.CreateNewFile(allowedOrgs, containerVersion); // eemldada sõnumi XMList need saajad, kes aktiivse serveri kaudu kirja ei saa
                    newMessage.setFilePath(newFilePath);
                    
                    newMessage.getDeliveryChannel().setServiceUrl(currentServiceUrl);
                    newMessage.getDeliveryChannel().setProducerName(currentProducer);
                    
                    // Paneme keskserveri kaudu saadetavad sõnumid ettepoole,
                    // et saatmisel saaks keskserveri ID võimalikult kiiresti kõtte.
                    result.add(0, newMessage);
                    logger.info("Added message clone for central server delivery");
                }
            }
    	}
    	
    	return result;
    }

    
    /**
     * Arvutab adressaadipõhiste staatuse koodide alusel võlja kogu sõnumi
     * staatuse ja uuendab seda andmebaasis.
     * 
     * @param messageId		sõnumi kohalik ID
     * @param db			Andmebaasiühenduse seaded
     */
    public static void calculateAndUpdateMessageStatus(int messageId, OrgSettings db, Connection dbConnection) {
    	ArrayList<MessageRecipient> recipients = MessageRecipient.getList(messageId, db, dbConnection);
    	
    	int totalStatusId = Settings.Client_StatusSent;
    	Calendar cal = Calendar.getInstance();
    	cal.set(1900, 0, 1, 0, 0);
    	Date dateSent = cal.getTime();
    	
    	if (recipients != null) {
    		for (MessageRecipient rec : recipients) {
    			if (rec.getSendingStatusID() == Settings.Client_StatusCanceled) {
    				totalStatusId = Settings.Client_StatusCanceled;
    			} else if (rec.getSendingStatusID() == Settings.Client_StatusWaiting) {
    				totalStatusId = Settings.Client_StatusWaiting;
    			} else if (rec.getSendingStatusID() == Settings.Client_StatusSending) {
    				totalStatusId = Settings.Client_StatusSending;
    			}
    			
    			if ((rec.getSendingStatusID() == Settings.Client_StatusSent) || (rec.getSendingStatusID() == Settings.Client_StatusSending) || (rec.getSendingStatusID() == Settings.Client_StatusCanceled)) {
    				if ((rec.getSendingDate() != null) && rec.getSendingDate().after(dateSent)) {
    					dateSent = rec.getSendingDate(); 
    				}
    			}
    		}
    	}
    	updateStatus(messageId, totalStatusId, dateSent, false, db, dbConnection);
    }
    
    public static int deleteOldDocuments(int documentLifetimeInDays, OrgSettings db, Connection dbConnection) throws Exception {
        int result = 0;
    	try {
            if (dbConnection != null) {
                CallableStatement cs = dbConnection.prepareCall("{call Delete_OldDhlMessages(?,?)}");
                int parNr = 1;
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Delete_OldDhlMessages\"(?)}");
                }

                if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	parNr++;
                }
                
                cs.setInt(parNr++, documentLifetimeInDays);
                
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	cs.registerOutParameter(parNr, Types.INTEGER);
                } else {
                	cs.registerOutParameter(1, Types.INTEGER);
                }
                cs.execute();
                if (CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	result = cs.getInt(parNr);
                } else {
                	result = cs.getInt(1);
                }
                
                cs.execute();
                cs.close();
            } else {
            	logger.warn("Database connection is NULL.");
            }
        } catch (Exception ex) {
            logger.error(ex);
        }
        return result;
    }
}
