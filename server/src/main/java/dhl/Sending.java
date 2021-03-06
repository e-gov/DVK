package dhl;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;

import dhl.users.UserProfile;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Settings;
import dvk.core.xroad.XRoadHeader;

public class Sending {
    private static Logger logger = Logger.getLogger(Sending.class);

    private int m_id;
    private int m_documentID;
    private Date m_startDate;
    private Date m_endDate;
    private int m_sendStatusID;
    private Sender m_sender;
    private Proxy m_proxy;
    private int m_receivedMethodID;
    private ArrayList<Recipient> m_recipients;
    private boolean m_isNewlyAdded;
    private String m_documentGUID;

    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setDocumentID(int documentID) {
        this.m_documentID = documentID;
    }

    public int getDocumentID() {
        return m_documentID;
    }

    public void setStartDate(Date startDate) {
        this.m_startDate = startDate;
    }

    public Date getStartDate() {
        return m_startDate;
    }

    public void setEndDate(Date endDate) {
        this.m_endDate = endDate;
    }

    public Date getEndDate() {
        return m_endDate;
    }

    public void setSendStatusID(int sendStatusID) {
        this.m_sendStatusID = sendStatusID;
    }

    public int getSendStatusID() {
        return m_sendStatusID;
    }

    public void setSender(Sender sender) {
        this.m_sender = sender;
    }

    public Sender getSender() {
        return m_sender;
    }

    public void setProxy(Proxy proxy) {
        this.m_proxy = proxy;
    }

    public Proxy getProxy() {
        return m_proxy;
    }

    public void setRecipients(ArrayList<Recipient> recipients) {
        this.m_recipients = recipients;
    }

    public void setReceivedMethodID(int receivedMethodID) {
        this.m_receivedMethodID = receivedMethodID;
    }

    public int getReceivedMethodID() {
        return m_receivedMethodID;
    }

    public ArrayList<Recipient> getRecipients() {
        return m_recipients;
    }

    public boolean getIsNewlyAdded() {
        return m_isNewlyAdded;
    }

    public void setIsNewlyAdded(boolean value) {
        m_isNewlyAdded = value;
    }

    public Sending() {
        clear();
    }

    public void clear() {
        m_id = 0;
        m_documentID = 0;
        m_startDate = null;
        m_endDate = null;
        m_sendStatusID = CommonStructures.SendStatus_Sending;
        m_receivedMethodID = CommonStructures.SendingMethod_XTee;

        if (m_sender == null) {
            m_sender = new Sender();
        } else {
            m_sender.clear();
        }

        if (m_proxy == null) {
            m_proxy = new Proxy();
        } else {
            m_proxy.clear();
        }

        if (m_recipients == null) {
            m_recipients = new ArrayList<Recipient>();
        } else {
            m_recipients.clear();
        }
        m_isNewlyAdded = false;
    }
    
    

    
    
    public boolean loadByDocumentID(int documentID, Connection conn) {
        clear();
        boolean find = false;
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                Statement cs = conn.createStatement();
                ResultSet rs = cs.executeQuery("SELECT * FROM \"Get_LastSendingByDocID\"(" + documentID + ")");
                while (rs.next()) {
	                m_id = rs.getInt("sending_id");
	                m_startDate = rs.getTimestamp("sending_start_date", cal);
	                m_endDate = rs.getTimestamp("sending_end_date", cal);
	                m_sendStatusID = rs.getInt("send_status_id");
	                m_documentID = documentID;	
	                if (m_id > 0) {
	                    m_sender.getBySendingID(m_id, conn);
	                    m_proxy.LoadBySendingID(m_id, conn);
	                    m_recipients = Recipient.getList(m_id, conn);
	                }	
	                find = true;
                }
                rs.close();
                cs.close();                
            } else {
            	find = false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            find = false;
        }
        return find;
    }
    
    
    public boolean loadByDocumentGUID(String document_guid, Connection conn) {    	
        clear();
        boolean find = false;
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                Statement cs = conn.createStatement();
                ResultSet rs = cs.executeQuery("SELECT * FROM \"Get_LastSendingByDocGUID\"(" + document_guid + ")");
                while (rs.next()) {
	                m_id = rs.getInt("sending_id");
	                m_startDate = rs.getTimestamp("sending_start_date", cal);
	                m_endDate = rs.getTimestamp("sending_end_date", cal);
	                m_sendStatusID = rs.getInt("send_status_id");
	                m_documentID = rs.getInt("document_id");
	                m_documentGUID = document_guid;
	
	                if (m_id > 0) {
	                    m_sender.getBySendingID(m_id, conn);
	                    m_proxy.LoadBySendingID(m_id, conn);
	                    m_recipients = Recipient.getList(m_id, conn);
	                }
	                find = true;
                }
                rs.close();
                cs.close();                
            } else {
            	find = false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            find = false;
        }
        return find;
    }
    
    
    public int addToDB(Connection conn, XRoadHeader xTeePais) throws IllegalArgumentException, SQLException {
    	if (conn != null) {

            logger.debug("Adding transport info to database: ");
            logger.debug("m_documentID: " + m_documentID);
            logger.debug("m_startDate: " + m_startDate);
            logger.debug("m_endDate: " + m_endDate);
            logger.debug("m_sendStatusID: " + m_sendStatusID);
            
            Calendar cal = Calendar.getInstance();
            CallableStatement cs = conn.prepareCall("{? = call \"Add_Sending\"(?,?,?,?,?,?)}");
            cs.registerOutParameter(1, Types.INTEGER);
            
            cs.setInt(2, m_documentID);
            cs.setTimestamp(3, CommonMethods.sqlDateFromDate(m_startDate), cal);
            cs.setTimestamp(4, CommonMethods.sqlDateFromDate(m_endDate), cal);
            cs.setInt(5, m_sendStatusID);

            if (xTeePais != null) {
                cs.setString(6, xTeePais.getUserId());
                cs.setString(7, xTeePais.getConsumer());
            } else {
                cs.setString(6, null);
                cs.setString(7, null);
            }

            cs.executeUpdate();
            m_id = cs.getInt(1);
            cs.close();

            if (m_id > 0) {
                m_sender.setSendingID(m_id);
                m_sender.addToDB(conn, xTeePais);

                if ((m_proxy != null) && (m_proxy.getOrganizationID() > 0)) {
                    m_proxy.setSendingID(m_id);
                    m_proxy.addToDB(conn, xTeePais);
                }

                for (Recipient tmpRecipient : m_recipients) {
                    tmpRecipient.setSendingID(m_id);
                    tmpRecipient.addToDB(conn, xTeePais);
                }
            }

            return m_id;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }

    public static boolean updateStatus (int sendingId, int sendStatus, Date endDate, Connection conn) {
      
      logger.debug("Updating sending. Parameters: ");
      logger.debug("sending_id: " + sendingId);
      logger.debug("sending_end_date: " + endDate);
      logger.debug("send_status_id: " + sendStatus);

      try {
          if (conn != null) {
              Calendar cal = Calendar.getInstance();
              CallableStatement cs = conn.prepareCall("UPDATE transport set staatus_id=?, saatmise_lopp=? where transport_id = ?");
              cs.setInt(1, sendStatus);
              cs.setTimestamp(2, CommonMethods.sqlDateFromDate(endDate), cal);
              cs.setInt(3, sendingId);
              cs.executeUpdate();
              cs.close();
             // conn.commit();
              return true;
          } else {
              return false;
          }
      } catch (Exception ex) {
          logger.error(ex.getMessage(), ex);
          return false;
      }
    }
    
    public boolean update(boolean updateChildObjects, Connection conn, XRoadHeader xTeePais) {
        logger.debug("Updating sending. Parameters: ");
        logger.debug("sending_id: " + m_id);
        logger.debug("document_id: " + m_documentID);
        logger.debug("sending_start_date: " + m_startDate);
        logger.debug("sending_end_date: " + m_endDate);
        logger.debug("send_status_id: " + m_sendStatusID);

        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call \"Update_Sending\"(?,?,?,?,?)}");
                cs.setInt(1, m_id);
                cs.setInt(2, m_documentID);
                cs.setTimestamp(3, CommonMethods.sqlDateFromDate(m_startDate), cal);
                cs.setTimestamp(4, CommonMethods.sqlDateFromDate(m_endDate), cal);
                cs.setInt(5, m_sendStatusID);
                cs.executeUpdate();
                cs.close();

                if (updateChildObjects) {
                    for (Recipient tmpRecipient : m_recipients) {
                        tmpRecipient.update(conn, xTeePais);
                    }
                }

                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            return false;
        }
    }
    
    
    public static Sending fromXML(XMLStreamReader xmlReader, Connection conn, XRoadHeader xTeePais) throws AxisFault {
        logger.debug("Parsing sending information from XML...");
        try {
            Calendar cal = Calendar.getInstance();
            Sending result = new Sending();
            result.setSender(null);

            // Enne alamstruktuuride juurde asumist väärtustame ära kõik lihtandmetüüpi
            // muutujad. Väärtustamata jätame:
            //   ID - sest see saab väärtuse andmebaasi salvestamisel
            //   DocumentID - sest see saab väärtuse, kui dokument andmebaasi salvestatakse
            //   EndDate - sest see saab väärtuse alles siis, kui kõik adressaadid
            //       on oma koopia antud dokumendist kätte saanud

            // Märgime, et lisatud dokument on saatmisel
            result.setSendStatusID(CommonStructures.SendStatus_Sending);

            // Saatmise alguskuupäevaks-kellaajaks märgime praeguse hetke
            result.setStartDate(cal.getTime());

            int senderCount = 0;
            int recipientCount = 0;

            while (xmlReader.hasNext()) {
                xmlReader.next();
                if (xmlReader.hasName()) {
                    logger.debug("Element localName: " + xmlReader.getLocalName());
                    if (xmlReader.getLocalName().equalsIgnoreCase("transport") && xmlReader.isEndElement()) {
                        logger.debug("Found transport.");
                        // Kui oleme jõudnud transport ploki lõppu, siis katkestame tsükli
                        break;
                    } else if ((xmlReader.getLocalName().equalsIgnoreCase("saatja")
                            || xmlReader.getLocalName().equalsIgnoreCase("DecSender")) && xmlReader.isStartElement()) {
                        logger.debug("Found sender.");
                        // Laeme saatja andmed XML-st oma andmestruktuuri
                        result.setSender(Sender.fromXML(xmlReader, conn, xTeePais));
                        ++senderCount;
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("vahendaja") && xmlReader.isStartElement()) {
                        logger.debug("Found proxy.");
                        // Laeme vahendaja andmed XML-st oma andmestruktuuri
                        result.setProxy(Proxy.fromXML(xmlReader, conn));
                    } else if ((xmlReader.getLocalName().equalsIgnoreCase("saaja")
                            || xmlReader.getLocalName().equalsIgnoreCase("DecRecipient"))
                            && xmlReader.isStartElement()) {
                        logger.debug("Found recipient.");
                        // Laeme saaja andmed XML-st oma andmestruktuuri
                        Recipient r = Recipient.fromXML(xmlReader, conn, xTeePais);
                        ++recipientCount;
                        if (r != null) {
                            result.getRecipients().add(r);
                        }
                    }
                }
            }

            // Kui "transport" plokk saatja ega saajate kohta infot ei sisalda,
            // siis järelikult ei saadetud dokumenti edastamiseks.
            if (((result.getSender() == null) || (result.getSender().getOrganizationID() < 1)) && (result.getRecipients().size() < 1)) {
                return null;
            }

            // Kuna saatjaid saab olla täpselt üks, siis anname veateate niipea,
            // kui saatjaid pole või on üle ühe.
            if (senderCount != 1) {
                throw new AxisFault(CommonStructures.VIGA_VALE_ARV_SAATJAID);
            }

            // Kui ühtegi saajat pole esitatud, siis tagastame veateate
            if (recipientCount < 1) {
                throw new AxisFault(CommonStructures.VIGA_VALE_ARV_VASTUVOTJAID);
            }

            // Kui ühegi kontrolli taha pidama ei jäänud, siis tagastame väärtuse
            return result;
        } catch (XMLStreamException ex) {
            throw new AxisFault("Exception parsing DVK message transport section: " + ex.getMessage());
        }
    }

    public String getDocumentGUID() {
        return m_documentGUID;
    }

    public void setDocumentGUID(String mDocumentGUID) {
        m_documentGUID = mDocumentGUID;
    }

    /**
     * Checks (and defines) the rules, when a user can see documents status information.
     *
     * @param user User who executed current request
     * @return True, if current user can access documents status information
     */
    public boolean isStatusAccessibleToUser(UserProfile user) {
        // By default user cannot access a documents status data
        // This is to avoid giving out any information about documents
        // not belonging to users organization.
        boolean result = false;

        // If server is configured so that x-road request sender must not match
        // document sender, then access to status information must also not be
        // restricted by x-road credentials.
        if (!Settings.Server_DocumentSenderMustMatchXroadHeader) {
            result = true;
        } else if (user != null) {
            // User can access documents status data if
            // - user sent the document
            // - document was sent by someone else filling the same role in organization
            // - user is marked as organization admin in DVK (for the org. that sent the document)
            result = CommonMethods.stringsEqualIgnoreNull(m_sender.getPersonalIdCode(), user.getPersonCode())
                    || user.getPositions().contains(m_sender.getPositionID())
                    || ((m_sender.getOrganizationID() == user.getOrganizationID()) && user.getRoles().contains(CommonStructures.ROLL_ASUTUSE_ADMIN));

                // User can also access documents status data if
        // - user forwarded the document
            // - document was forwarded by someone else filling the same role in organization
            // - user is marked as organization admin in DVK (for the org. that forwarded the document)
            if (!result) {
                result = result || ((m_proxy != null)
                        && (CommonMethods.stringsEqualIgnoreNull(m_proxy.getPersonalIdCode(), user.getPersonCode())
                        || user.getPositions().contains(m_proxy.getPositionID())
                        || ((m_proxy.getOrganizationID() == user.getOrganizationID()) && user.getRoles().contains(CommonStructures.ROLL_ASUTUSE_ADMIN))));
            }

            // Message recipient can also access status information.
            if (!result) {
                for (Recipient r : m_recipients) {
                    if ((CommonMethods.stringsEqualIgnoreNull(r.getPersonalIdCode(), user.getPersonCode()))
                            || user.getPositions().contains(r.getPositionID())
                            || ((r.getOrganizationID() == user.getOrganizationID()) && user.getRoles().contains(CommonStructures.ROLL_ASUTUSE_ADMIN))) {
                        result = true;
                        break;
                    }
                }
            }
        }

        return result;
    }

    /*
    public boolean loadByDocumentID(int documentID, Connection conn) {
        clear();
        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call GET_LASTSENDINGBYDOCID(?,?,?,?,?)}");
                cs.setInt("document_id", documentID);
                cs.registerOutParameter("sending_id", Types.INTEGER);
                cs.registerOutParameter("sending_start_date", Types.TIMESTAMP);
                cs.registerOutParameter("sending_end_date", Types.TIMESTAMP);
                cs.registerOutParameter("send_status_id", Types.INTEGER);
                cs.executeUpdate();
                m_id = cs.getInt("sending_id");
                m_startDate = cs.getTimestamp("sending_start_date", cal);
                m_endDate = cs.getTimestamp("sending_end_date", cal);
                m_sendStatusID = cs.getInt("send_status_id");
                m_documentID = documentID;

                if (m_id > 0) {
                    m_sender.getBySendingID(m_id, conn);
                    m_proxy.LoadBySendingID(m_id, conn);
                    m_recipients = Recipient.getList(m_id, conn);
                }

                cs.close();
                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            return false;
        }
    }
     */
    
    /*
    public int addToDB(Connection conn, XHeader xTeePais) throws IllegalArgumentException, SQLException {
        if (conn != null) {

            logger.debug("Adding transport info to database: ");
            logger.debug("m_documentID: " + m_documentID);
            logger.debug("m_startDate: " + m_startDate);
            logger.debug("m_endDate: " + m_endDate);
            logger.debug("m_sendStatusID: " + m_sendStatusID);

            Calendar cal = Calendar.getInstance();
            CallableStatement cs = conn.prepareCall("{call ADD_SENDING(?,?,?,?,?,?,?)}");
            cs.registerOutParameter("sending_id", Types.INTEGER);
            cs.setInt("document_id", m_documentID);
            cs.setTimestamp("sending_start_date", CommonMethods.sqlDateFromDate(m_startDate), cal);
            cs.setTimestamp("sending_end_date", CommonMethods.sqlDateFromDate(m_endDate), cal);
            cs.setInt("send_status_id", m_sendStatusID);

            if (xTeePais != null) {
                cs.setString("xtee_isikukood", xTeePais.isikukood);
                cs.setString("xtee_asutus", xTeePais.asutus);
            } else {
                cs.setString("xtee_isikukood", null);
                cs.setString("xtee_asutus", null);
            }

            cs.executeUpdate();
            m_id = cs.getInt("sending_id");
            cs.close();

            if (m_id > 0) {
                m_sender.setSendingID(m_id);
                m_sender.addToDB(conn, xTeePais);

                if ((m_proxy != null) && (m_proxy.getOrganizationID() > 0)) {
                    m_proxy.setSendingID(m_id);
                    m_proxy.addToDB(conn, xTeePais);
                }

                for (Recipient tmpRecipient : m_recipients) {
                    tmpRecipient.setSendingID(m_id);
                    tmpRecipient.addToDB(conn, xTeePais);
                }
            }

            return m_id;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }
    */
    
    /*
    public boolean update(boolean updateChildObjects, Connection conn, XHeader xTeePais) {
        logger.debug("Updating sending. Parameters: ");
        logger.debug("sending_id: " + m_id);
        logger.debug("document_id: " + m_documentID);
        logger.debug("sending_start_date: " + m_startDate);
        logger.debug("sending_end_date: " + m_endDate);
        logger.debug("send_status_id: " + m_sendStatusID);

        try {
            if (conn != null) {
                Calendar cal = Calendar.getInstance();
                CallableStatement cs = conn.prepareCall("{call UPDATE_SENDING(?,?,?,?,?)}");
                cs.setInt("sending_id", m_id);
                cs.setInt("document_id", m_documentID);
                cs.setTimestamp("sending_start_date", CommonMethods.sqlDateFromDate(m_startDate), cal);
                cs.setTimestamp("sending_end_date", CommonMethods.sqlDateFromDate(m_endDate), cal);
                cs.setInt("send_status_id", m_sendStatusID);
                cs.executeUpdate();
                cs.close();

                if (updateChildObjects) {
                    for (Recipient tmpRecipient : m_recipients) {
                        tmpRecipient.update(conn, xTeePais);
                    }
                }

                return true;
            } else {
                return false;
            }
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            return false;
        }
    }
     */
    
}
