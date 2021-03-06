package dhl;

import java.io.OutputStreamWriter;
import java.io.StringReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.apache.axis.AxisFault;
import org.apache.commons.lang3.StringEscapeUtils;
import org.apache.log4j.Logger;

import dhl.users.Allyksus;
import dhl.users.Ametikoht;
import dhl.users.Asutus;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Fault;
import dvk.core.Settings;
import dvk.core.xroad.XRoadHeader;

public class Recipient {
    private static Logger logger = Logger.getLogger(Recipient.class);

    private int m_id;
    private int m_sendingID;
    private int m_organizationID;
    private int m_positionID;
    private int m_divisionID;
    private String m_personalIdCode;
    private String m_name;
    private String m_organizationName;
    private String m_email;
    private String m_departmentNumber;
    private String m_departmentName;
    private int m_sendingMethodID;
    private int m_sendStatusID;
    private Date m_sendingStartDate;
    private Date m_sendingEndDate;
    private Fault m_fault;
    private int m_recipientStatusID;
    private String m_metaXML;
    private int m_idInRemoteServer;
    private String m_organizationCode;

    private String m_positionShortName;
    private String m_divisionShortName;
    private boolean m_cc;
    private Date m_statusDate;
    
    private String m_dhxInternalConsignmentId;
    private String m_dhxExternalConsignmentId;
    private String m_dhxExternalReceiptId;

    private Date m_lastSendDate;
    
    public void setId(int id) {
        this.m_id = id;
    }

    public int getId() {
        return m_id;
    }

    public void setSendingID(int sendingID) {
        this.m_sendingID = sendingID;
    }

    public int getSendingID() {
        return m_sendingID;
    }

    public void setOrganizationID(int organizationID) {
        this.m_organizationID = organizationID;
    }

    public int getOrganizationID() {
        return m_organizationID;
    }

    public void setPositionID(int positionID) {
        this.m_positionID = positionID;
    }

    public int getPositionID() {
        return m_positionID;
    }

    public void setDivisionID(int divisionID) {
        this.m_divisionID = divisionID;
    }

    public int getDivisionID() {
        return m_divisionID;
    }

    public void setPersonalIdCode(String personalIdCode) {
        this.m_personalIdCode = personalIdCode;
    }

    public String getPersonalIdCode() {
        return m_personalIdCode;
    }

    public void setName(String name) {
        this.m_name = name;
    }

    public String getName() {
        return m_name;
    }

    public void setOrganizationName(String organizationName) {
        this.m_organizationName = organizationName;
    }

    public String getOrganizationName() {
        return m_organizationName;
    }

    public void setEmail(String email) {
        this.m_email = email;
    }

    public String getEmail() {
        return m_email;
    }

    public void setDepartmentNumber(String departmentNumber) {
        this.m_departmentNumber = departmentNumber;
    }

    public String getDepartmentNumber() {
        return m_departmentNumber;
    }

    public void setDepartmentName(String departmentName) {
        this.m_departmentName = departmentName;
    }

    public String getDepartmentName() {
        return m_departmentName;
    }

    public void setSendingMethodID(int sendingMethodID) {
        this.m_sendingMethodID = sendingMethodID;
    }

    public int getSendingMethodID() {
        return m_sendingMethodID;
    }

    public void setSendStatusID(int sendStatusID) {
        this.m_sendStatusID = sendStatusID;
    }

    public int getSendStatusID() {
        return m_sendStatusID;
    }

    public void setSendingStartDate(Date sendingStartDate) {
        this.m_sendingStartDate = sendingStartDate;
    }

    public Date getSendingStartDate() {
        return m_sendingStartDate;
    }

    public void setSendingEndDate(Date sendingEndDate) {
        this.m_sendingEndDate = sendingEndDate;
    }

    public Date getSendingEndDate() {
        return m_sendingEndDate;
    }

    public void setFault(Fault fault) {
        this.m_fault = fault;
    }

    public Fault getFault() {
        return m_fault;
    }

    public void setRecipientStatusId(int recipientStatusID) {
        this.m_recipientStatusID = recipientStatusID;
    }

    public int getRecipientStatusId() {
        return m_recipientStatusID;
    }

    public String getMetaXML() {
        return m_metaXML;
    }

    public void setMetaXML(String metaXML) {
        this.m_metaXML = metaXML;
    }

    public int getIdInRemoteServer() {
        return m_idInRemoteServer;
    }

    public void setIdInRemoteServer(int value) {
        m_idInRemoteServer = value;
    }

    public String getOrganizationCode() {
        return m_organizationCode;
    }

    public void setOrganizationCode(String value) {
        m_organizationCode = value;
    }

    public String getPositionShortName() {
        return m_positionShortName;
    }

    public void setPositionShortName(String shortName) {
        m_positionShortName = shortName;
    }

    public String getDivisionShortName() {
        return m_divisionShortName;
    }

    public void setDivisionShortName(String shortName) {
        m_divisionShortName = shortName;
    }
    
    public String getDhxInternalConsignmentId() {
        return m_dhxInternalConsignmentId;
      }

      public void setDhxInternalConsignmentId(String m_dhxInternalConsignmentId) {
        this.m_dhxInternalConsignmentId = m_dhxInternalConsignmentId;
      }
      
      public String getDhxExternalConsignmentId() {
        return m_dhxExternalConsignmentId;
      }

      public void setDhxExternalConsignmentId(String m_dhxExternalConsignmentId) {
        this.m_dhxExternalConsignmentId = m_dhxExternalConsignmentId;
      }
      
      public String getDhxExternalReceiptId() {
        return m_dhxExternalReceiptId;
      }

      public void setDhxExternalReceiptId(String m_dhxExternalReceiptId) {
        this.m_dhxExternalReceiptId = m_dhxExternalReceiptId;
      }

    public boolean isCc() {
        return m_cc;
    }

    public void setCc(boolean cc) {
        this.m_cc = cc;
    }

    public Date getStatusDate() {
        return this.m_statusDate;
    }

    public void setStatusDate(Date value) {
        this.m_statusDate = value;
    }


    public Date getLastSendDate() {
      return m_lastSendDate;
  }

  public void setLastSendDate(Date m_lastSendDate) {
      this.m_lastSendDate = m_lastSendDate;
  }
  
	public Recipient() {
        clear();
    }

    public void clear() {
        m_id = 0;
        m_sendingID = 0;
        m_organizationID = 0;
        m_positionID = 0;
        m_divisionID = 0;
        m_personalIdCode = "";
        m_name = "";
        m_organizationName = "";
        m_email = "";
        m_departmentNumber = "";
        m_departmentName = "";
        m_sendingMethodID = 0;
        m_sendStatusID = 0;
        m_sendingStartDate = null;
        m_sendingEndDate = null;
        m_fault = null;
        m_recipientStatusID = 0;
        m_metaXML = "";
        m_idInRemoteServer = 0;
        m_organizationCode = "";
        m_positionShortName = "";
        m_divisionShortName = "";
        m_cc = false;
        m_statusDate = new Date();
        m_lastSendDate = new Date();
    }
    
    public static Boolean isDuplicate (Connection conn, String externalConsignmentId, Integer asutusId) throws Exception{
        if (conn != null) {
          boolean defaultAutoCommit = conn.getAutoCommit();
          try{
              conn.setAutoCommit(false);
              Boolean result = false;
              CallableStatement cs = conn.prepareCall("select count(*) cnt from vastuvotja v, saatja s where s.transport_id=v.transport_id and s.asutus_id=? and v.dhx_external_consignment_id=?");
              cs.setInt(1, asutusId);
              cs.setString(2, externalConsignmentId);
              ResultSet rs = cs.executeQuery();
              while (rs.next()) {
                result = rs.getInt("cnt") > 0;
              }
              rs.close();
              cs.close();
              return result;
          } finally {
              conn.setAutoCommit(defaultAutoCommit);
          }                                                                   
      } else {
          throw new Exception("Database connection is NULL!");
      }
      }
    

    public static ArrayList<Recipient> getList(int sendingID, Connection conn) throws Exception {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
        	boolean defaultAutoCommit = conn.getAutoCommit();
        	try{
        		conn.setAutoCommit(false);
        		
            	CallableStatement cs = conn.prepareCall("{? = call \"Get_Recipients\"(?)}");
            	cs.registerOutParameter(1, Types.OTHER);
            	cs.setInt(2, sendingID);
                cs.execute();
            
	            ResultSet rs = (ResultSet) cs.getObject(1);
	            ArrayList<Recipient> result = new ArrayList<Recipient>();
	            while (rs.next()) {
	                Recipient item = new Recipient();
	                item.setId(rs.getInt("vastuvotja_id"));
	                item.setSendingID(rs.getInt("transport_id"));
	                item.setOrganizationID(rs.getInt("asutus_id"));
	                item.setPositionID(rs.getInt("ametikoht_id"));
	                item.setDivisionID(rs.getInt("allyksus_id"));
	                item.setPersonalIdCode(rs.getString("isikukood"));
	                item.setName(rs.getString("nimi"));
	                item.setOrganizationName(rs.getString("asutuse_nimi"));
	                item.setEmail(rs.getString("email"));
	                item.setDepartmentNumber(rs.getString("osakonna_nr"));
	                item.setDepartmentName(rs.getString("osakonna_nimi"));
	                item.setSendingMethodID(rs.getInt("saatmisviis_id"));
	                item.setSendStatusID(rs.getInt("staatus_id"));
	                item.setSendingStartDate(rs.getTimestamp("saatmise_algus", cal));
	                item.setSendingEndDate(rs.getTimestamp("saatmise_lopp", cal));
	
	                String faultString = rs.getString("fault_string");
	                if ((faultString != null) && (faultString.length() > 0)) {
	                    Fault f = new Fault(rs.getString("fault_code"), rs.getString("fault_actor"), faultString, rs.getString("fault_detail"));
	                    item.setFault(f);
	                }
	
	                item.setRecipientStatusId(rs.getInt("vastuvotja_staatus_id"));
	                item.setIdInRemoteServer(rs.getInt("dok_id_teises_serveris"));
	                item.setDivisionShortName(rs.getString("allyksuse_lyhinimetus"));
	                item.setPositionShortName(rs.getString("ametikoha_lyhinimetus"));
	                item.setDhxInternalConsignmentId(rs.getString("dhx_internal_consignment_id"));
	                item.setDhxExternalConsignmentId(rs.getString("dhx_external_consignment_id"));
	                item.setDhxExternalReceiptId(rs.getString("dhx_external_receipt_id"));
	                item.setLastSendDate(rs.getTimestamp("last_send_date", cal));
	                
	
	                // Loeme CLOB-ist dokumendi andmed
	                String tmpBlob = rs.getString("metaxml");
	                if (tmpBlob != null) {
	                    item.setMetaXML(tmpBlob);
	                }
	
	                result.add(item);
	            }
	            rs.close();
	            cs.close();
	            return result;
            } finally {
    			conn.setAutoCommit(defaultAutoCommit);
    		}	               	               	                	            
        } else {
            throw new Exception("Database connection is NULL!");
        }
    }
    
    
    public static Recipient getById(int id, Connection conn) throws Exception {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
        	boolean defaultAutoCommit = conn.getAutoCommit();
        	try{
        		conn.setAutoCommit(false);
        		
            	CallableStatement cs = conn.prepareCall("{? = call \"Get_Recipient_By_Id\"(?)}");
            	cs.registerOutParameter(1, Types.OTHER);
            	cs.setInt(2, id);
                cs.execute();
            
	            ResultSet rs = (ResultSet) cs.getObject(1);
	            Recipient result = null;
	            while (rs.next()) {
	            	result = new Recipient();
	            	result.setId(rs.getInt("vastuvotja_id"));
	            	result.setSendingID(rs.getInt("transport_id"));
	            	result.setOrganizationID(rs.getInt("asutus_id"));
	            	result.setPositionID(rs.getInt("ametikoht_id"));
	            	result.setDivisionID(rs.getInt("allyksus_id"));
	            	result.setPersonalIdCode(rs.getString("isikukood"));
	                result.setName(rs.getString("nimi"));
	                result.setOrganizationName(rs.getString("asutuse_nimi"));
	                result.setEmail(rs.getString("email"));
	                result.setDepartmentNumber(rs.getString("osakonna_nr"));
	                result.setDepartmentName(rs.getString("osakonna_nimi"));
	                result.setSendingMethodID(rs.getInt("saatmisviis_id"));
	                result.setSendStatusID(rs.getInt("staatus_id"));
	                result.setSendingStartDate(rs.getTimestamp("saatmise_algus", cal));
	                result.setSendingEndDate(rs.getTimestamp("saatmise_lopp", cal));
	
	                String faultString = rs.getString("fault_string");
	                if ((faultString != null) && (faultString.length() > 0)) {
	                    Fault f = new Fault(rs.getString("fault_code"), rs.getString("fault_actor"), faultString, rs.getString("fault_detail"));
	                    result.setFault(f);
	                }
	
	                result.setRecipientStatusId(rs.getInt("vastuvotja_staatus_id"));
	                result.setIdInRemoteServer(rs.getInt("dok_id_teises_serveris"));
	                result.setDivisionShortName(rs.getString("allyksuse_lyhinimetus"));
	                result.setPositionShortName(rs.getString("ametikoha_lyhinimetus"));
	                result.setDhxInternalConsignmentId(rs.getString("dhx_internal_consignment_id"));
	                result.setDhxExternalConsignmentId(rs.getString("dhx_external_consignment_id"));
	                result.setDhxExternalReceiptId(rs.getString("dhx_external_receipt_id"));
	                result.setLastSendDate(rs.getTimestamp("last_send_date", cal));
	                
	
	                // Loeme CLOB-ist dokumendi andmed
	                String tmpBlob = rs.getString("metaxml");
	                if (tmpBlob != null) {
	                	result.setMetaXML(tmpBlob);
	                }
	            }
	            rs.close();
	            cs.close();
	            return result;
            } finally {
    			conn.setAutoCommit(defaultAutoCommit);
    		}	               	               	                	            
        } else {
            throw new Exception("Database connection is NULL!");
        }
    }
    
    
    public int addToDB(Connection conn, XRoadHeader xTeePais) throws SQLException, IllegalArgumentException {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
            boolean defaultAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            try {
                m_id = getNextID(conn);
                StringReader r = new StringReader(m_metaXML);
                CallableStatement cs = conn.prepareCall("{call \"Add_Vastuvotja\"(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, m_id);
                cs.setInt(2, m_sendingID);
                cs = CommonMethods.setNullableIntParam(cs, 3, m_organizationID);
                cs = CommonMethods.setNullableIntParam(cs, 4, m_positionID);
                cs = CommonMethods.setNullableIntParam(cs, 5, m_divisionID);
                cs.setString(6, m_personalIdCode);
                cs.setString(7, m_name);
                cs.setString(8, m_organizationName);
                cs.setString(9, m_email);
                cs.setString(10, m_departmentNumber);
                cs.setString(11, m_departmentName);
                cs.setInt(12, m_sendingMethodID);
                cs.setInt(13, m_sendStatusID);
                cs.setTimestamp(14, CommonMethods.sqlDateFromDate(m_sendingStartDate), cal);
                cs.setTimestamp(15, CommonMethods.sqlDateFromDate(m_sendingEndDate), cal);
                if (m_fault != null) {
                    cs.setString(16, CommonMethods.TruncateString(m_fault.getFaultCode(), 50));
                    cs.setString(17, CommonMethods.TruncateString(m_fault.getFaultActor(), 250));
                    cs.setString(18, CommonMethods.TruncateString(m_fault.getFaultString(), 500));
                    cs.setString(19, CommonMethods.TruncateString(m_fault.getFaultDetail(), 2000));
                } else {
                    cs.setString(16, "");
                    cs.setString(17, "");
                    cs.setString(18, "");
                    cs.setString(19, "");
                }
                cs = CommonMethods.setNullableIntParam(cs, 20, m_recipientStatusID);
                cs.setCharacterStream(21, r, m_metaXML.length());
                cs = CommonMethods.setNullableIntParam(cs, 22, m_idInRemoteServer);
                cs.setString(23, m_divisionShortName);
                cs.setString(24, m_positionShortName);

                if (xTeePais != null) {
                    cs.setString(25, xTeePais.getUserId());
                    cs.setString(26, xTeePais.getConsumer());
                } else {
                    cs.setString(25, "");
                    cs.setString(26, "");
                }
                cs.setString(27, m_dhxInternalConsignmentId);
                cs.setString(28, m_dhxExternalConsignmentId);
                cs.setString(29, m_dhxExternalReceiptId);

                cs.setTimestamp(30, CommonMethods.sqlDateFromDate(m_lastSendDate), cal);

                cs.execute();
                cs.close();

                // Lisame staatuse ajaloo kirje
                DocumentStatusHistory historyEntry = new DocumentStatusHistory(
                        0, m_id, m_sendStatusID, m_statusDate, m_fault, m_recipientStatusID, m_metaXML);
                historyEntry.addToDB(conn, xTeePais);

                conn.commit();
            } catch (SQLException ex) {
                logger.error("Error while saving recipient data: ", ex);
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(defaultAutoCommit);
            }
            return m_id;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }
    

    public boolean updateProc(Connection conn, XRoadHeader xTeePais) throws SQLException, IllegalArgumentException {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
            boolean defaultAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            try {
                StringReader r = new StringReader(m_metaXML);
                CallableStatement cs = conn.prepareCall("{call \"Update_Vastuvotja\"(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");                
                cs.setInt(2, m_sendingID);
                cs = CommonMethods.setNullableIntParam(cs, 3, m_organizationID);
                cs = CommonMethods.setNullableIntParam(cs, 4, m_positionID);
                cs = CommonMethods.setNullableIntParam(cs, 5, m_divisionID);
                cs.setString(6, m_personalIdCode);
                cs.setString(7, m_email);
                cs.setString(8, m_name);
                cs.setString(9, m_organizationName);
                cs.setString(10, m_departmentNumber);
                cs.setString(11, m_departmentName);
                cs.setInt(12, m_sendingMethodID);
                cs.setInt(13, m_sendStatusID);
                cs.setTimestamp(14, CommonMethods.sqlDateFromDate(m_sendingStartDate), cal);
                cs.setTimestamp(15, CommonMethods.sqlDateFromDate(m_sendingEndDate), cal);

                if (m_fault != null) {
                    cs.setString(16, CommonMethods.TruncateString(m_fault.getFaultCode(), 50));
                    cs.setString(17, CommonMethods.TruncateString(m_fault.getFaultActor(), 250));
                    cs.setString(18, CommonMethods.TruncateString(m_fault.getFaultString(), 500));
                    cs.setString(19, CommonMethods.TruncateString(m_fault.getFaultDetail(), 2000));
                } else {
                    cs.setString(16, "");
                    cs.setString(17, "");
                    cs.setString(18, "");
                    cs.setString(19, "");
                }

                cs = CommonMethods.setNullableIntParam(cs, 20, m_recipientStatusID);
                cs.setCharacterStream(21, r, m_metaXML.length());
                cs = CommonMethods.setNullableIntParam(cs, 22, m_idInRemoteServer);
                cs.setString(23, m_divisionShortName);
                cs.setString(24, m_positionShortName);

                if (xTeePais != null) {
                    cs.setString(25, xTeePais.getUserId());
                    cs.setString(26, xTeePais.getConsumer());
                } else {
                    cs.setString(25, "");
                    cs.setString(26, "");
                }

                cs.setString(27, m_dhxInternalConsignmentId);
                cs.setString(28, m_dhxExternalConsignmentId);
                cs.setString(29, m_dhxExternalReceiptId);
                cs.setTimestamp(30, CommonMethods.sqlDateFromDate(m_lastSendDate), cal);
                
                cs.executeUpdate();
                cs.close();

                // Lisame staatuse ajaloo kirje
                DocumentStatusHistory historyEntry = new DocumentStatusHistory(
                        0, m_id, m_sendStatusID, m_statusDate, m_fault, m_recipientStatusID, m_metaXML);
                historyEntry.addToDB(conn, xTeePais);

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(defaultAutoCommit);
            }

            return true;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }
    
    
    public boolean update(Connection conn, XRoadHeader xTeePais) throws SQLException, IllegalArgumentException {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
            boolean defaultAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            try {
                StringReader r = new StringReader(m_metaXML);
                CallableStatement cs = conn.prepareCall(
                        "UPDATE vastuvotja SET transport_id=?, "
                                + "asutus_id=?, ametikoht_id=?, allyksus_id=?, "
                                + "isikukood=?, email=?, nimi=?, asutuse_nimi=?, "
                                + "osakonna_nr=?, osakonna_nimi=?, saatmisviis_id=?, "
                                + "staatus_id=?, saatmise_algus=?, saatmise_lopp=?, fault_code=?, "
                                + "fault_actor=?, fault_string=?, fault_detail=?, vastuvotja_staatus_id=?, "
                                + "metaxml=?, dok_id_teises_serveris=?, allyksuse_lyhinimetus=?, "
                                + "ametikoha_lyhinimetus=?, dhx_internal_consignment_id=?,"
                                + "dhx_external_consignment_id=?, dhx_external_receipt_id=?, last_send_date=? WHERE vastuvotja_id=?");
                cs.setInt(1, m_sendingID);
                cs = CommonMethods.setNullableIntParam(cs, 2, m_organizationID);
                cs = CommonMethods.setNullableIntParam(cs, 3, m_positionID);
                cs = CommonMethods.setNullableIntParam(cs, 4, m_divisionID);
                cs.setString(5, m_personalIdCode);
                cs.setString(6, m_email);
                cs.setString(7, m_name);
                cs.setString(8, m_organizationName);
                cs.setString(9, m_departmentNumber);
                cs.setString(10, m_departmentName);
                cs.setInt(11, m_sendingMethodID);
                cs.setInt(12, m_sendStatusID);
                cs.setTimestamp(13, CommonMethods.sqlDateFromDate(m_sendingStartDate), cal);
                cs.setTimestamp(14, CommonMethods.sqlDateFromDate(m_sendingEndDate), cal);

                if (m_fault != null) {
                    cs.setString(15, CommonMethods.TruncateString(m_fault.getFaultCode(), 50));
                    cs.setString(16, CommonMethods.TruncateString(m_fault.getFaultActor(), 250));
                    cs.setString(17, CommonMethods.TruncateString(m_fault.getFaultString(), 500));
                    cs.setString(18, CommonMethods.TruncateString(m_fault.getFaultDetail(), 2000));
                } else {
                    cs.setString(15, "");
                    cs.setString(16, "");
                    cs.setString(17, "");
                    cs.setString(18, "");
                }

                cs = CommonMethods.setNullableIntParam(cs, 19, m_recipientStatusID);
                cs.setCharacterStream(20, r, m_metaXML.length());
                cs = CommonMethods.setNullableIntParam(cs, 21, m_idInRemoteServer);
                cs.setString(22, m_divisionShortName);
                cs.setString(23, m_positionShortName);
                cs.setString(24, m_dhxInternalConsignmentId);
                cs.setString(25, m_dhxExternalConsignmentId);
                cs.setString(26, m_dhxExternalReceiptId);

                cs.setTimestamp(27, CommonMethods.sqlDateFromDate(m_lastSendDate), cal);

                cs.setInt(28, m_id);

                cs.executeUpdate();
                cs.close();

                // Lisame staatuse ajaloo kirje
                DocumentStatusHistory historyEntry = new DocumentStatusHistory(
                        0, m_id, m_sendStatusID, m_statusDate, m_fault, m_recipientStatusID, m_metaXML);
                historyEntry.addToDB(conn, xTeePais);

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(defaultAutoCommit);
            }

            return true;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }

    public static int getNextID(Connection conn) throws SQLException, IllegalArgumentException {
        if (conn != null) {
            CallableStatement cs = conn.prepareCall("{? = call \"Get_NextRecipientID\"()}");
            cs.registerOutParameter(1, Types.INTEGER);
            cs.execute();
            int result = cs.getInt(1);
            cs.close();
            return result;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }

    public boolean appendObjectXML(OutputStreamWriter xmlWriter, Connection conn) {
        try {
            // Item element start
            xmlWriter.write("<saaja>");

            // RegNr
            if (Settings.Server_RunOnClientDatabase) {
                xmlWriter.write("<regnr>" + m_organizationCode + "</regnr>");
            } else {
                Asutus org = new Asutus(m_organizationID, conn);
                xmlWriter.write("<regnr>" + org.getRegistrikood() + "</regnr>");
            }

            // Isikukood
            if ((m_personalIdCode != null) && (!m_personalIdCode.equalsIgnoreCase(""))) {
                xmlWriter.write("<isikukood>" + m_personalIdCode + "</isikukood>");
            }

            // Ametikoha kood
            if (m_positionID > 0) {
                xmlWriter.write("<ametikoha_kood>" + String.valueOf(m_positionID) + "</ametikoha_kood>");
            }

            // Allüksuse kood
            if (m_divisionID > 0) {
                xmlWriter.write("<allyksuse_kood>" + String.valueOf(m_divisionID) + "</allyksuse_kood>");
            }

            // E-post
            if ((m_email != null) && (!m_email.equalsIgnoreCase(""))) {
                xmlWriter.write("<epost>" + m_email + "</epost>");
            }

            // Nimi
            if ((m_name != null) && (!m_name.equalsIgnoreCase(""))) {
                xmlWriter.write("<nimi>" + m_name + "</nimi>");
            }

            // Asutuse nimi
            if ((m_organizationName != null) && (!m_organizationName.equalsIgnoreCase(""))) {
                xmlWriter.write("<asutuse_nimi>" + StringEscapeUtils.escapeXml11(m_organizationName)
                                                 + "</asutuse_nimi>");
            }

            // Osakonna kood
            if ((m_departmentNumber != null) && (!m_departmentNumber.equalsIgnoreCase(""))) {
                xmlWriter.write("<osakonna_kood>" + m_departmentNumber + "</osakonna_kood>");
            }

            // Osakonna nimi
            if ((m_departmentName != null) && (!m_departmentName.equalsIgnoreCase(""))) {
                xmlWriter.write("<osakonna_nimi>" + m_departmentName + "</osakonna_nimi>");
            }

            // Item element end
            xmlWriter.write("</saaja>");
            return true;
        } catch (Exception ex) {
            logger.error(ex.getMessage(), ex);
            return false;
        }
    }

    public static Recipient fromXML(XMLStreamReader xmlReader, Connection conn, XRoadHeader xTeePais) throws AxisFault {
        try {
            Recipient result = new Recipient();

            // Jätame järgnevas väärtustamata järgmised andmeväljad:
            //   ID - sest see saab vääruse andmebaasi salvestamisel
            //   SendingID - sest see saab väärtuse alles siis, kuin saatmisinfo on
            //       andmebaasi salvatstaud
            //   SendingEndDate - sest see fikseeritakse hetkel, mil adressaat
            //       dokumendi kätte saab
            //   Fault - sest see väärtustatakse juhul, kui saatmisel mingi viga
            //       peaks esinema.
            int orgID = 0;
            int positionID = 0;
            int divisionID = 0;
            String orgCode = "";
            String occupationShortName = "";
            String subdivisionShortName = "";

            while (xmlReader.hasNext()) {
                xmlReader.next();

                if (xmlReader.hasName()) {
                    if ((xmlReader.getLocalName().equalsIgnoreCase("saaja")
                            || xmlReader.getLocalName().equalsIgnoreCase("DecRecipient"))
                            && xmlReader.isEndElement()) {
                        // Kui oleme jõudnud saaja elemendi lõppu, siis katkestame tsükli
                        break;
                    } else if ((xmlReader.getLocalName().equalsIgnoreCase("regnr")
                            || xmlReader.getLocalName().equalsIgnoreCase("OrganisationCode"))
                            && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            // Tuvastame adressaadi asutuse
                            orgCode = xmlReader.getText().trim();
                            orgID = Asutus.getIDByRegNr(orgCode, true, conn);

                            // Proovime asutust tuvastada teiste teadaolevate DVK serverite abiga
                            if (orgID == 0) {
                                try {
                                    Asutus.getOrgsFromAllKnownServers(orgCode, conn, xTeePais);
                                    orgID = Asutus.getIDByRegNr(orgCode, true, conn);
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage(), ex);
                                    orgID = 0;
                                }
                            }

                            result.setOrganizationID(orgID);
                            result.setOrganizationCode(orgCode);
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoha_kood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            // Tuvastame adressaadi ametikoha
                            String positionIDText = xmlReader.getText().trim();
                            if ((positionIDText != null) && (positionIDText.length() > 0)) {
                                try {
                                    positionID = Integer.parseInt(positionIDText);
                                    result.setPositionID(positionID);
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage(), ex);
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoha_lyhinimetus") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            occupationShortName = xmlReader.getText().trim();
                            result.setPositionShortName(occupationShortName);
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("allyksuse_kood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            // Tuvastame adressaadi ametikoha
                            String divisionIDText = xmlReader.getText().trim();
                            if ((divisionIDText != null) && (divisionIDText.length() > 0)) {
                                try {
                                    divisionID = Integer.parseInt(divisionIDText);
                                    result.setDivisionID(divisionID);
                                } catch (Exception ex) {
                                    logger.error(ex.getMessage(), ex);
                                }
                            }
                        }
                    } else if ((xmlReader.getLocalName().equalsIgnoreCase("allyksuse_lyhinimetus")
                            || xmlReader.getLocalName().equalsIgnoreCase("StructuralUnit"))
                            && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            subdivisionShortName = xmlReader.getText().trim();
                            result.setDivisionShortName(subdivisionShortName);
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("epost") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setEmail(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("nimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setName(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutuse_nimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setOrganizationName(xmlReader.getText().trim());
                        }
                    } else if ((xmlReader.getLocalName().equalsIgnoreCase("isikukood")
                            || (xmlReader.getLocalName().equalsIgnoreCase("PersonalIdCode")))
                            && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setPersonalIdCode(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("osakonna_kood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setDepartmentNumber(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("osakonna_nimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setDepartmentName(xmlReader.getText().trim());
                        }
                    }
                }
            }

            // Määrame väärtused andmeväljadele, mida ei saa otseselt XML-st lugeda,
            // aga mille väärtused tulenevad kaudselt XML-s esitatud andmetest
            result.setSendStatusID(CommonStructures.SendStatus_Sending);
            result.setSendingStartDate(new Date());

            // Kui saajale ei saa saata X-Tee kaudu ja e-posti aadressi pole ka
            // määratud, siis järelikult pole lootustki talle midagi edastada
            // ning väljastame veateate.
            // [Jaak Lember | 03.05.2006]: Kuna e-posti lüüsi ei eksisteeri,
            // siis peab asutus kindlasti määratud ja DHL-võimeline olema!
            if ((orgID < 1)) {
                throw new AxisFault(CommonStructures.VIGA_PUUDULIKUD_VASTUVOTJA_KONTAKTID
                        .replaceFirst("#1", orgCode));
            }

            // Tuvastame osakonna lühinime järgi osakonna ID
            // Seda ei saa enne teha, kui kogu XML on läbi käidud, kuna ametikoha
            // leidmiseks peab lisaks lühinimele tedma ka asutuse ID-d.
            if ((occupationShortName != null) && (occupationShortName.length() > 0)) {
                int occupationId = Ametikoht.getIdByShortName(orgID, occupationShortName, conn);
                if (occupationId > 0) {
                    result.setPositionID(occupationId);
                }
            }

            // Tuvastame allüksuse lühinime järgi allüksuse ID
            // Seda ei saa enne teha, kui kogu XML on läbi käidud, kuna allüksuse
            // leidmiseks peab lisaks lühinimele tedma ka asutuse ID-d.
            if ((subdivisionShortName != null) && (subdivisionShortName.length() > 0)) {
                int subdivisionId = Allyksus.getIdByShortName(orgID, subdivisionShortName, conn);
                if (subdivisionId > 0) {
                    result.setDivisionID(subdivisionId);
                }
            }

            // Kui asutusele on võimalik saata X-Tee kaudu, siis saadame X-Tee kaudu.
            // Kui X-Tee kaudu saata ei saa ja on teada saaja e-posti aadress, siis
            // saadame e-posti teel.
            int sendingMethod = CommonStructures.SendingMethod_XTee;
            if ((orgID < 1) && (result.getEmail() != null) && (result.getEmail().length() > 0)) {
                sendingMethod = CommonStructures.SendingMethod_EMail;
            }
            result.setSendingMethodID(sendingMethod);
            return result;
        } catch (XMLStreamException ex) {
            logger.error(ex.getMessage(), ex);
            throw new AxisFault("Exception parsing DVK message recipient section: " + ex.getMessage());
        }
    }

    /**
     * Copies DVK-specific and recipient-specific information
     * from another recipient instance to this recipient instance.
     *
     * @param anotherRecipient Recipient to copy sending status data from
     */
    public void copyStatusInformationFromAnotherInstance(Recipient anotherRecipient) {
        if (anotherRecipient != null) {
            // DVK status ID and sending end date
            this.setSendStatusID(anotherRecipient.getSendStatusID());
            this.setSendingEndDate(anotherRecipient.getSendingEndDate());

            // Recipient-specific status information
            this.setRecipientStatusId(anotherRecipient.getRecipientStatusId());
            this.setMetaXML(anotherRecipient.getMetaXML());
            this.setFault(anotherRecipient.getFault());
        } else {
            logger.warn("Unable to copy recipient status from another recipient instance because the other instance is NULL!");
        }
    }
    
    /*
    public static ArrayList<Recipient> getList(int sendingID, Connection conn) throws Exception {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
            CallableStatement cs = conn.prepareCall("{call GET_RECIPIENTS(?,?)}");
            cs.setInt("sending_id", sendingID);
            cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
            cs.execute();
            ResultSet rs = (ResultSet) cs.getObject("RC1");
            ArrayList<Recipient> result = new ArrayList<Recipient>();
            while (rs.next()) {
                Recipient item = new Recipient();
                item.setId(rs.getInt("vastuvotja_id"));
                item.setSendingID(rs.getInt("transport_id"));
                item.setOrganizationID(rs.getInt("asutus_id"));
                item.setPositionID(rs.getInt("ametikoht_id"));
                item.setDivisionID(rs.getInt("allyksus_id"));
                item.setPersonalIdCode(rs.getString("isikukood"));
                item.setName(rs.getString("nimi"));
                item.setOrganizationName(rs.getString("asutuse_nimi"));
                item.setEmail(rs.getString("email"));
                item.setDepartmentNumber(rs.getString("osakonna_nr"));
                item.setDepartmentName(rs.getString("osakonna_nimi"));
                item.setSendingMethodID(rs.getInt("saatmisviis_id"));
                item.setSendStatusID(rs.getInt("staatus_id"));
                item.setSendingStartDate(rs.getTimestamp("saatmise_algus", cal));
                item.setSendingEndDate(rs.getTimestamp("saatmise_lopp", cal));

                String faultString = rs.getString("fault_string");
                if ((faultString != null) && (faultString.length() > 0)) {
                    Fault f = new Fault(rs.getString("fault_code"), rs.getString("fault_actor"), faultString, rs.getString("fault_detail"));
                    item.setFault(f);
                }

                item.setRecipientStatusId(rs.getInt("vastuvotja_staatus_id"));
                item.setIdInRemoteServer(rs.getInt("dok_id_teises_serveris"));
                item.setDivisionShortName(rs.getString("allyksuse_lyhinimetus"));
                item.setPositionShortName(rs.getString("ametikoha_lyhinimetus"));

                // Loeme CLOB-ist dokumendi andmed
                Clob tmpBlob = rs.getClob("metaxml");
                if (tmpBlob != null) {
                    Reader r = tmpBlob.getCharacterStream();

                    StringBuffer sb = new StringBuffer();
                    try {
                        char[] charbuf = new char[Settings.getBinaryBufferSize()];
                        for (int i = r.read(charbuf); i > 0; i = r.read(charbuf)) {
                            sb.append(charbuf, 0, i);
                        }
                    } catch (Exception e) {
                        CommonMethods.logError(e, "dhl.Recipient", "getList");
                        throw e;
                    }
                    item.setMetaXML(sb.toString());
                }

                result.add(item);
            }
            rs.close();
            cs.close();
            return result;
        } else {
            throw new Exception("Database connection is NULL!");
        }
    }
    */
    
    /*
    public int addToDB(Connection conn, XHeader xTeePais) throws SQLException, IllegalArgumentException {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
            boolean defaultAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            try {
                m_id = getNextID(conn);
                StringReader r = new StringReader(m_metaXML);

                CallableStatement cs = conn.prepareCall("{call ADD_VASTUVOTJA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
                cs.setInt(1, m_id);
                cs.setInt(2, m_sendingID);
                cs = CommonMethods.setNullableIntParam(cs, 3, m_organizationID);
                cs = CommonMethods.setNullableIntParam(cs, 4, m_positionID);
                cs = CommonMethods.setNullableIntParam(cs, 5, m_divisionID);
                cs.setString(6, m_personalIdCode);
                cs.setString(7, m_name);
                cs.setString(8, m_organizationName);
                cs.setString(9, m_email);
                cs.setString(10, m_departmentNumber);
                cs.setString(11, m_departmentName);
                cs.setInt(12, m_sendingMethodID);
                cs.setInt(13, m_sendStatusID);
                cs.setTimestamp(14, CommonMethods.sqlDateFromDate(m_sendingStartDate), cal);
                cs.setTimestamp(15, CommonMethods.sqlDateFromDate(m_sendingEndDate), cal);
                if (m_fault != null) {
                    cs.setString(16, CommonMethods.TruncateString(m_fault.getFaultCode(), 50));
                    cs.setString(17, CommonMethods.TruncateString(m_fault.getFaultActor(), 250));
                    cs.setString(18, CommonMethods.TruncateString(m_fault.getFaultString(), 500));
                    cs.setString(19, CommonMethods.TruncateString(m_fault.getFaultDetail(), 2000));
                } else {
                    cs.setString(16, "");
                    cs.setString(17, "");
                    cs.setString(18, "");
                    cs.setString(19, "");
                }
                cs = CommonMethods.setNullableIntParam(cs, 20, m_recipientStatusID);
                cs.setCharacterStream(21, r, m_metaXML.length());
                cs = CommonMethods.setNullableIntParam(cs, 22, m_idInRemoteServer);
                cs.setString(23, m_divisionShortName);
                cs.setString(24, m_positionShortName);

                if (xTeePais != null) {
                    cs.setString(25, xTeePais.isikukood);
                    cs.setString(26, xTeePais.asutus);
                } else {
                    cs.setString(25, "");
                    cs.setString(26, "");
                }

                cs.executeUpdate();
                cs.close();

                // Lisame staatuse ajaloo kirje
                DocumentStatusHistory historyEntry = new DocumentStatusHistory(
                        0, m_id, m_sendStatusID, m_statusDate, m_fault, m_recipientStatusID, m_metaXML);
                historyEntry.addToDB(conn, xTeePais);

                conn.commit();
            } catch (SQLException ex) {
                logger.error("Error while saving recipient data: ", ex);
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(defaultAutoCommit);
            }
            return m_id;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }
    */
    
    /*
    public boolean updateProc(Connection conn, XHeader xTeePais) throws SQLException, IllegalArgumentException {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
            boolean defaultAutoCommit = conn.getAutoCommit();
            conn.setAutoCommit(false);

            try {
                StringReader r = new StringReader(m_metaXML);
                CallableStatement cs = conn.prepareCall("{call UPDATE_VASTUVOTJA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");

                cs.setInt(2, m_sendingID);
                cs = CommonMethods.setNullableIntParam(cs, 3, m_organizationID);
                cs = CommonMethods.setNullableIntParam(cs, 4, m_positionID);
                cs = CommonMethods.setNullableIntParam(cs, 5, m_divisionID);
                cs.setString(6, m_personalIdCode);
                cs.setString(7, m_email);
                cs.setString(8, m_name);
                cs.setString(9, m_organizationName);
                cs.setString(10, m_departmentNumber);
                cs.setString(11, m_departmentName);
                cs.setInt(12, m_sendingMethodID);
                cs.setInt(13, m_sendStatusID);
                cs.setTimestamp(14, CommonMethods.sqlDateFromDate(m_sendingStartDate), cal);
                cs.setTimestamp(15, CommonMethods.sqlDateFromDate(m_sendingEndDate), cal);

                if (m_fault != null) {
                    cs.setString(16, CommonMethods.TruncateString(m_fault.getFaultCode(), 50));
                    cs.setString(17, CommonMethods.TruncateString(m_fault.getFaultActor(), 250));
                    cs.setString(18, CommonMethods.TruncateString(m_fault.getFaultString(), 500));
                    cs.setString(19, CommonMethods.TruncateString(m_fault.getFaultDetail(), 2000));
                } else {
                    cs.setString(16, "");
                    cs.setString(17, "");
                    cs.setString(18, "");
                    cs.setString(19, "");
                }

                cs = CommonMethods.setNullableIntParam(cs, 20, m_recipientStatusID);
                cs.setCharacterStream(21, r, m_metaXML.length());
                cs = CommonMethods.setNullableIntParam(cs, 22, m_idInRemoteServer);
                cs.setString(23, m_divisionShortName);
                cs.setString(24, m_positionShortName);

                if (xTeePais != null) {
                    cs.setString("xtee_isikukood", xTeePais.isikukood);
                    cs.setString("xtee_asutus", xTeePais.asutus);
                } else {
                    cs.setString("xtee_isikukood", "");
                    cs.setString("xtee_asutus", "");
                }

                cs.executeUpdate();
                cs.close();

                // Lisame staatuse ajaloo kirje
                DocumentStatusHistory historyEntry = new DocumentStatusHistory(
                        0, m_id, m_sendStatusID, m_statusDate, m_fault, m_recipientStatusID, m_metaXML);
                historyEntry.addToDB(conn, xTeePais);

                conn.commit();
            } catch (SQLException ex) {
                conn.rollback();
                throw ex;
            } finally {
                conn.setAutoCommit(defaultAutoCommit);
            }

            return true;
        } else {
            throw new IllegalArgumentException("Database connection is NULL!");
        }
    }
    */
    
    
}
