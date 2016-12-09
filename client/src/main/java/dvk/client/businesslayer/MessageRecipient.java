package dvk.client.businesslayer;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.LoggingService;
import dvk.client.iostructures.Fault;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Settings;

public class MessageRecipient {

	private static Logger logger = Logger.getLogger(MessageRecipient.class);

    private int m_id; //primary key of MessageRecipient
	private int m_messageID;
    private String m_recipientOrgCode;
    private String m_recipientOrgName;
    private String m_recipientPersonCode;
    private String m_recipientName;
    private int m_recipientDivisionID;
    private String m_recipientDivisionCode;
    private String m_recipientDivisionName;
    private int m_recipientPositionID;
    private String m_recipientPositionCode;
    private String m_recipientPositionName;
    private Date m_sendingDate;
    private Date m_receivedDate;
    private int m_sendingStatusID;
    private int m_recipientStatusID;
    private String m_faultCode;
    private String m_faultActor;
    private String m_faultString;
    private String m_faultDetail;
    private String m_metaXML;
    private int m_dhlID; // sõnumi saatmisel pannakse siis vastuvõtva DVK serveri poolt dokumendile antud ID väärtus
    private String m_producerName;
    private String m_serviceURL;

    /**
     * @return			Adressaadi unikaalne ID kohalikus andmetabelis
     */
    public int getId() {
        return this.m_id;
    }

    /**
     * @param value		Adressaadi unikaalne ID kohalikus andmetabelis
     */
    public void setId(int value) {
        this.m_id = value;
    }

    public void setMessageID(int messageID) {
        this.m_messageID = messageID;
    }

    public int getMessageID() {
        return m_messageID;
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

    public int getRecipientDivisionID() {
        return m_recipientDivisionID;
    }

    public void setRecipientDivisionID(int value) {
        m_recipientDivisionID = value;
    }

    /**
     * @return			Adressaadi allüksuse lühinimi
     */
    public String getRecipientDivisionCode() {
        return this.m_recipientDivisionCode;
    }

    /**
     * @param value		Adressaadi allüksuse lühinimi
     */
    public void setRecipientDivisionCode(String value) {
        this.m_recipientDivisionCode = value;
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

    /**
     * @return			Adressaadi ametikoha lühinimi
     */
    public String getRecipientPositionCode() {
        return this.m_recipientPositionCode;
    }

    /**
     * @param value		Adressaadi ametikoha lühinimi
     */
    public void setRecipientPositionCode(String value) {
        this.m_recipientPositionCode = value;
    }

    public String getRecipientPositionName() {
        return m_recipientPositionName;
    }

    public void setRecipientPositionName(String value) {
        m_recipientPositionName = value;
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

    public void setSendingStatusID(int sendingStatusID) {
        this.m_sendingStatusID = sendingStatusID;
    }

    public int getSendingStatusID() {
        return m_sendingStatusID;
    }

    public void setRecipientStatusID(int recipientStatusID) {
        this.m_recipientStatusID = recipientStatusID;
    }

    public int getRecipientStatusID() {
        return m_recipientStatusID;
    }

    public void setFaultCode(String faultCode) {
        this.m_faultCode = faultCode;
    }

    public String getFaultCode() {
        return m_faultCode;
    }

    public void setFaultActor(String faultActor) {
        this.m_faultActor = faultActor;
    }

    public String getFaultActor() {
        return m_faultActor;
    }

    public void setFaultString(String faultString) {
        this.m_faultString = faultString;
    }

    public String getFaultString() {
        return m_faultString;
    }

    public void setFaultDetail(String faultDetail) {
        this.m_faultDetail = faultDetail;
    }

    public String getFaultDetail() {
        return m_faultDetail;
    }

    public void setMetaXML(String metaXML) {
        this.m_metaXML = metaXML;
    }

    public String getMetaXML() {
        return m_metaXML;
    }

    public void setDhlId(int dhlID) {
        this.m_dhlID = dhlID;
    }

    public int getDhlID() {
        return m_dhlID;
    }

    public String getProducerName() {
        return m_producerName;
    }

    public void setProducerName(String value) {
        m_producerName = value;
    }

    public String getServiceURL() {
        return m_serviceURL;
    }

    public void setServiceURL(String value) {
        m_serviceURL = value;
    }

    public MessageRecipient() {
        m_id = 0;
    	m_messageID = 0;
        m_recipientOrgCode = "";
        m_recipientOrgName = "";
        m_recipientPersonCode = "";
        m_recipientName = "";
        m_recipientDivisionID = 0;
        m_recipientDivisionCode = "";
        m_recipientDivisionName = "";
        m_recipientPositionID = 0;
        m_recipientPositionCode = "";
        m_recipientPositionName = "";
        m_sendingDate = null;
        m_receivedDate = null;
        m_sendingStatusID = 0;
        m_recipientStatusID = 0;
        m_faultCode = "";
        m_faultActor = "";
        m_faultString = "";
        m_faultDetail = "";
        m_metaXML = "";
        m_dhlID = 0;
        m_producerName = "";
        m_serviceURL = "";
    }

    public static ArrayList<MessageRecipient> getList(int messageID, OrgSettings db, Connection dbConnection) {
        try {
            if (dbConnection != null) {
                ArrayList<MessageRecipient> result = new ArrayList<MessageRecipient>();
            	boolean defaultAutoCommit = dbConnection.getAutoCommit();
        		try {
	            	dbConnection.setAutoCommit(false);
	                int parNr = 1;
	                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
	                    parNr++;
	                }
	                CallableStatement cs = DBConnection.getStatementForResultSet("Get_DhlMessageRecipients", 1, db, dbConnection);
	                cs.setInt(parNr++, messageID);
	                ResultSet rs = DBConnection.getResultSet(cs, db, 1);
	                while (rs.next()) {
	                    result.add(getMessageRecipientFromResultSet(rs));
	                }
	                rs.close();
	                cs.close();
        		} finally {
        			dbConnection.setAutoCommit(defaultAutoCommit);
        		}
                return result;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.businesslayer.MessageRecipient" + " getList");
                LoggingService.logError(errorLog);
                return null;
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.MessageRecipient" + " getList");
            LoggingService.logError(errorLog);
            return null;
        }
    }

    private static MessageRecipient getMessageRecipientFromResultSet(ResultSet rs) throws Exception {
        Calendar cal = Calendar.getInstance();
        MessageRecipient item = new MessageRecipient();
        item.setId(rs.getInt("dhl_message_recipient_id"));
        item.setMessageID(rs.getInt("dhl_message_id"));
        item.setRecipientOrgCode(rs.getString("recipient_org_code"));
        item.setRecipientOrgName(rs.getString("recipient_org_name"));
        item.setRecipientPersonCode(rs.getString("recipient_person_code"));
        item.setRecipientName(rs.getString("recipient_name"));
        item.setSendingDate(rs.getTimestamp("sending_date", cal));
        item.setReceivedDate(rs.getTimestamp("received_date", cal));
        item.setSendingStatusID(rs.getInt("sending_status_id"));
        item.setRecipientStatusID(rs.getInt("recipient_status_id"));
        item.setFaultCode(rs.getString("fault_code"));
        item.setFaultActor(rs.getString("fault_actor"));
        item.setFaultString(rs.getString("fault_string"));
        item.setFaultDetail(rs.getString("fault_detail"));
        item.setMetaXML(rs.getString("metaxml"));
        item.setDhlId(rs.getInt("dhl_id"));
        item.setProducerName(rs.getString("producer_name"));
        item.setServiceURL(rs.getString("service_url"));
        item.setRecipientDivisionID(rs.getInt("recipient_division_id"));
        item.setRecipientDivisionName(rs.getString("recipient_division_name"));
        item.setRecipientPositionID(rs.getInt("recipient_position_id"));
        item.setRecipientPositionName(rs.getString("recipient_position_name"));
        item.setRecipientDivisionCode(rs.getString("recipient_division_code"));
        item.setRecipientPositionCode(rs.getString("recipient_position_code"));
        return item;
    }

    public int saveToDB(OrgSettings db, Connection dbConnection) throws Exception {
    	logger.debug("m_messageID: " + m_messageID);
    	logger.debug("m_recipientOrgCode: " + m_recipientOrgCode);
    	logger.debug("m_recipientOrgName: " + m_recipientOrgName);
    	logger.debug("m_recipientPersonCode: " + m_recipientPersonCode);
    	logger.debug("m_recipientName: " + m_recipientName);
    	logger.debug("m_sendingDate: " + m_sendingDate);
    	logger.debug("m_receivedDate: " + m_receivedDate);
    	logger.debug("m_sendingStatusID: " + m_sendingStatusID);
    	logger.debug("m_recipientStatusID: " + m_recipientStatusID);
    	logger.debug("m_faultCode: " + m_faultCode);
    	logger.debug("m_faultActor: " + m_faultActor);
    	logger.debug("m_faultString: " + m_faultString);
    	logger.debug("m_faultDetail: " + m_faultDetail);
    	logger.debug("m_dhlID: " + m_dhlID);
    	logger.debug("m_producerName: " + m_producerName);
    	logger.debug("m_serviceURL: " + m_serviceURL);
    	logger.debug("m_recipientDivisionID" + m_recipientDivisionID);
    	logger.debug("m_recipientPositionID: " + m_recipientPositionID);
    	logger.debug("m_recipientDivisionName: " + m_recipientDivisionName);
    	logger.debug("m_recipientPositionName: " + m_recipientPositionName);
    	logger.debug("m_recipientDivisionCode: " + m_recipientDivisionCode);
    	logger.debug("m_recipientPositionCode: " + m_recipientPositionCode);

        try {
            if (dbConnection != null) {
                Calendar cal = Calendar.getInstance();

                int parNr = 1;
                CallableStatement cs = dbConnection.prepareCall("{call Save_DhlMessageRecipient(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Save_DhlMessageRecipient\"(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                }

                // SQL Anywhere JDBC client requires that output parameters are supplied as last parameter(s).
                // Otherwise all input parameters will be incorrectly moved down by one position in parameter list.
                if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
                	parNr++;
                }

                cs.setInt(parNr++, m_messageID);
                cs.setString(parNr++, m_recipientOrgCode);
                cs.setString(parNr++, m_recipientOrgName);
                cs.setString(parNr++, m_recipientPersonCode);
                cs.setString(parNr++, m_recipientName);
            	if (m_sendingDate != null) {
            		cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(m_sendingDate), cal);
            	} else {
            		cs.setNull(parNr++, Types.TIMESTAMP);
            	}
                if (m_receivedDate != null) {
                    cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(m_receivedDate), cal);
                } else {
                    cs.setNull(parNr++, Types.TIMESTAMP);
                }
                cs.setInt(parNr++, m_sendingStatusID);
                cs.setInt(parNr++, m_recipientStatusID);
                cs.setString(parNr++, m_faultCode);
                cs.setString(parNr++, m_faultActor);
                cs.setString(parNr++, m_faultString);
                cs.setString(parNr++, m_faultDetail);
                cs.setString(parNr++, m_metaXML);
                cs.setInt(parNr++, m_dhlID);
                cs.setString(parNr++, m_producerName);
                cs.setString(parNr++, m_serviceURL);
                cs.setInt(parNr++, m_recipientDivisionID);
                cs.setString(parNr++, m_recipientDivisionName);
                cs.setInt(parNr++, m_recipientPositionID);
                cs.setString(parNr++, m_recipientPositionName);
                cs.setString(parNr++, m_recipientDivisionCode);
                cs.setString(parNr++, m_recipientPositionCode);
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
                logger.debug("m_id: " + m_id);
                cs.close();
                dbConnection.commit();
                return m_id;
            } else {
                ErrorLog errorLog = new ErrorLog("Database connection is NULL", "dvk.client.businesslayer.MessageRecipient" + " saveToDB");
                LoggingService.logError(errorLog);
                return m_id;
            }
        } catch (Exception ex) {
            if (dbConnection != null) {
                try {
                	dbConnection.rollback();
                } catch(SQLException ex1) {
                    ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " saveToDB");
                    LoggingService.logError(errorLog);
                }
            }
            ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " saveToDB");
            errorLog.setOrganizationCode(this.getRecipientOrgCode());
            errorLog.setUserCode(this.getRecipientPersonCode());
            LoggingService.logError(errorLog);
            throw ex;
        }
    }

    public static int getId(int messageId, String orgCode, String personCode, String subdivisionShortName, String occupationShortName, OrgSettings db, Connection dbConnection) throws Exception {
        int result = 0;
        if (dbConnection != null) {
            int parNr = 1;
            CallableStatement cs = dbConnection.prepareCall("{call Get_DhlMessageRecipientId(?,?,?,?,?,?)}");
            if (db.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                cs = dbConnection.prepareCall("{? = call \"Get_DhlMessageRecipientId\"(?,?,?,?,?)}");
            }

            // SQL Anywhere JDBC client requires that output parameters are supplied as last parameter(s).
            // Otherwise all input parameters will be incorrectly moved down by one position in parameter list.
            if (!CommonStructures.PROVIDER_TYPE_SQLANYWHERE.equalsIgnoreCase(db.getDbProvider())) {
            	parNr++;
            }

            cs.setInt(parNr++, messageId);
            cs.setString(parNr++, orgCode);
            cs.setString(parNr++, personCode);
            cs.setString(parNr++, subdivisionShortName);
            cs.setString(parNr++, occupationShortName);
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
            cs.close();
            dbConnection.commit();
        }
        return result;
    }

    public static MessageRecipient fromXML(Element root) {
        try {
            if (root == null) {
                return null;
            }

            MessageRecipient result = new MessageRecipient();

            NodeList nl = root.getChildNodes();
            Node n = null;
            for (int i = 0; i < nl.getLength(); ++i) {
                n = nl.item(i);
                if (n.getNodeType() == Node.ELEMENT_NODE) {
                    if (n.getLocalName().equalsIgnoreCase("saaja")) {
                        NodeList nl2 = n.getChildNodes();
                        Node n2 = null;
                        for (int j = 0; j < nl2.getLength(); ++j) {
                            n2 = nl2.item(j);
                            if (n2.getNodeType() == Node.ELEMENT_NODE) {
                                if (n2.getLocalName().equalsIgnoreCase("regnr")) {
                                    result.setRecipientOrgCode(CommonMethods.getNodeText(n2));
                                } else if (n2.getLocalName().equalsIgnoreCase("nimi")) {
                                    result.setRecipientName(CommonMethods.getNodeText(n2));
                                } else if (n2.getLocalName().equalsIgnoreCase("asutuse_nimi")) {
                                    result.setRecipientOrgName(CommonMethods.getNodeText(n2));
                                } else if (n2.getLocalName().equalsIgnoreCase("isikukood")) {
                                    result.setRecipientPersonCode(CommonMethods.getNodeText(n2));
                                } else if (n2.getLocalName().equalsIgnoreCase("allyksuse_kood")) {
                                    result.setRecipientDivisionID(CommonMethods.toIntSafe(CommonMethods.getNodeText(n2),0));
                                } else if (n2.getLocalName().equalsIgnoreCase("ametikoha_kood")) {
                                    result.setRecipientPositionID(CommonMethods.toIntSafe(CommonMethods.getNodeText(n2),0));
                                } else if (n2.getLocalName().equalsIgnoreCase("allyksuse_nimetus")) {
                                    result.setRecipientDivisionName(CommonMethods.getNodeText(n2));
                                } else if (n2.getLocalName().equalsIgnoreCase("ametikoha_nimetus")) {
                                    result.setRecipientPositionName(CommonMethods.getNodeText(n2));
                                }
                            }
                        }
                    } else if (n.getLocalName().equalsIgnoreCase("saadud")) {
                        result.setSendingDate(CommonMethods.getDateFromXML(CommonMethods.getNodeText(n)));
                    } else if (n.getLocalName().equalsIgnoreCase("loetud")) {
                        result.setReceivedDate(CommonMethods.getDateFromXML(CommonMethods.getNodeText(n)));
                    } else if (n.getLocalName().equalsIgnoreCase("staatus")) {
                        String status = CommonMethods.getNodeText(n);
                        if (status.equalsIgnoreCase("saadetud")) {
                            result.setSendingStatusID(Settings.Client_StatusSent);
                        } else if (status.equalsIgnoreCase("katkestatud")) {
                            result.setSendingStatusID(Settings.Client_StatusCanceled);
                        } else {
                            result.setSendingStatusID(Settings.Client_StatusSending);
                        }
                    } else if (n.getLocalName().equalsIgnoreCase("vastuvotja_staatus_id")) {
                        result.setRecipientStatusID(Integer.parseInt(CommonMethods.getNodeText(n)));
                    } else if (n.getLocalName().equalsIgnoreCase("fault")) {
                        Fault f = Fault.getFromXML((Element)n);
                        result.setFaultCode(f.getFaultCode());
                        result.setFaultActor(f.getFaultActor());
                        result.setFaultString(f.getFaultString());
                        result.setFaultDetail(f.getFaultDetail());
                    } else if (n.getLocalName().equalsIgnoreCase("metaxml")) {
                        Element e = (Element)n;
                        String meta = CommonMethods.xmlElementToString(e).trim();
                        if (meta != null) {
                            if (meta.equalsIgnoreCase("<metaxml/>") || meta.equalsIgnoreCase("<metaxml />")) {
                                meta = "";
                            } else if (meta.startsWith("<metaxml>") && meta.endsWith("</metaxml>")) {
                                meta = meta.substring(9, meta.lastIndexOf("</metaxml>"));
                            }
                            result.setMetaXML(meta);
                        }
                    }
                }
            }
            return result;
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.MessageRecipient" + " fromXML");
            LoggingService.logError(errorLog);
            return null;
        }
    }

    public static MessageRecipient FindRecipientFromList(ArrayList<MessageRecipient> list, String orgCode, String personCode) {
        try {
            for (int i = 0; i < list.size(); ++i) {
                MessageRecipient r = list.get(i);
                if (!personCode.toLowerCase().equals("null")){
                    if (r.getRecipientOrgCode().equals(orgCode) && r.getRecipientPersonCode().equals(personCode)) {
                        return r;
                    }
                }
                else{
                    if (r.getRecipientOrgCode().equals(orgCode)) {
                        return r;
                    }
                }
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.businesslayer.MessageRecipient" + " FindRecipientFromList");
            errorLog.setOrganizationCode(orgCode);
            errorLog.setUserCode(personCode);
            LoggingService.logError(errorLog);
            return null;
        }
        return null;
    }

    /**
     * Find all MessageRecipients which recipientCode is Adit and which are not opened yet.
     * @param orgSettings {@link OrgSettings}
     * @param dbConnection {@link Connection}
     * @return list of MessageRecipients
     */
    public static List<MessageRecipient> findMessageRecipientsRelatedWithAdit(OrgSettings orgSettings, Connection dbConnection) {
        List<MessageRecipient> results = new ArrayList<MessageRecipient>();

        if (dbConnection != null) {

            try {
                dbConnection.setAutoCommit(false);
                CallableStatement cs = DBConnection.getStatementForResultSet(
                        "Get_NotOpenedInAdit", 0, orgSettings, dbConnection);
                ResultSet rs = DBConnection.getResultSet(cs, orgSettings, 0);
                while (rs.next()) {
                    results.add(getMessageRecipientFromResultSet(rs));
                }
                rs.close();
                cs.close();
            } catch (Exception e) {
                ErrorLog errorLog = new ErrorLog(e, "dvk.client.businesslayer.MessageRecipient" + " findMessageRecipientsRelatedWithAdit");
                LoggingService.logError(errorLog);
            }
        }

        return results;
    }

    /**
     * Update opened field for MessageRecipient where dhlId and personCode matches.
     * @param dhlId dhl_id
     * @param personCode with country code
     * @param openedDate opened date
     * @param orgSettings orgsettings
     * @param dbConnection databaseConnection
     * @return true if the update was successful otherwise false
     */
    public static boolean updateOpenedDate(int dhlId, String personCode, Date openedDate,
                                           OrgSettings orgSettings, Connection dbConnection) {
        boolean result = false;

        if (dbConnection != null) {
            CallableStatement cs = null;

            try {
                Calendar cal = Calendar.getInstance();

                int parNr = 1;
                cs = dbConnection.prepareCall("{call Update_MessageRecipientOpened(?,?,?,?)}");
                if (orgSettings.getDbProvider().equalsIgnoreCase(CommonStructures.PROVIDER_TYPE_POSTGRE)) {
                    cs = dbConnection.prepareCall("{? = call \"Update_MessageRecipientOpened\"(?,?,?,?)}");
                    cs.registerOutParameter(parNr++, Types.BOOLEAN);
                }

                cs.setInt(parNr++, dhlId);
                String personCodeWithoutEEPrefix = personCode;
                if (personCode != null && personCode.toUpperCase().startsWith("EE")) {
                    personCodeWithoutEEPrefix = personCode.substring(2);
                }
                cs.setString(parNr++, personCodeWithoutEEPrefix);
                cs.setString(parNr++, personCode);
                cs.setTimestamp(parNr++, CommonMethods.sqlDateFromDate(openedDate), cal);
                cs.execute();
                dbConnection.commit();
                result = true;
            } catch (Exception e) {
                ErrorLog errorLog = new ErrorLog(e, "dvk.client.businesslayer.MessageRecipient.updateOpenedDate");
                LoggingService.logError(errorLog);
            } finally {
                try {
                    if (cs != null) {
                        cs.close();
                    }
                } catch (SQLException e) {
                    ErrorLog errorLog = new ErrorLog(e, "dvk.client.businesslayer.MessageRecipient.updateOpenedDate");
                    LoggingService.logError(errorLog);
                }
            }
        }
        return result;
    }
}
