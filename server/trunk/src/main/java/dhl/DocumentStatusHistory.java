package dhl;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.Reader;
import java.io.StringReader;
import java.sql.CallableStatement;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import org.apache.log4j.Logger;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Fault;
import dvk.core.Settings;

public class DocumentStatusHistory {
	static Logger logger = Logger.getLogger(DocumentStatusHistory.class.getName());
	private int m_id;
	private int m_recipientId;
	private int m_sendingStatusId;
	private Date m_statusDate;
	private Fault m_fault;
    private int m_recipientStatusId;
    private String m_metaXML;
    
    // Abimuutujad, mida andmebaasi ei salvestata
    private String m_orgCode;
    private String m_personCode;
    private String m_subdivisionShortName;
    private String m_occupationShortName;
    
    public int getId() {
        return this.m_id;
    }

    public void setId(int value) {
        this.m_id = value;
    }

    public int getRecipientId() {
        return this.m_recipientId;
    }

    public void setRecipientId(int value) {
        this.m_recipientId = value;
    }

    public int getSendingStatusId() {
        return this.m_sendingStatusId;
    }

    public void setSendingStatusId(int value) {
        this.m_sendingStatusId = value;
    }

    public Date getStatusDate() {
        return this.m_statusDate;
    }

    public void setStatusDate(Date value) {
        this.m_statusDate = value;
    }

    public Fault getFault() {
        return this.m_fault;
    }

    public void setFault(Fault value) {
        this.m_fault = value;
    }

    public int getRecipientStatusId() {
        return this.m_recipientStatusId;
    }

    public void setRecipientStatusId(int value) {
        this.m_recipientStatusId = value;
    }

    public String getMetaXML() {
        return this.m_metaXML;
    }

    public void setMetaXML(String value) {
        this.m_metaXML = value;
    }
    
    
    public String getOrgCode() {
        return this.m_orgCode;
    }

    public void setOrgCode(String value) {
        this.m_orgCode = value;
    }

    public String getPersonCode() {
        return this.m_personCode;
    }

    public void setPersonCode(String value) {
        this.m_personCode = value;
    }

    public String getSubdivisionShortName() {
        return this.m_subdivisionShortName;
    }

    public void setSubdivisionShortName(String value) {
        this.m_subdivisionShortName = value;
    }

    public String getOccupationShortName() {
        return this.m_occupationShortName;
    }

    public void setOccupationShortName(String value) {
        this.m_occupationShortName = value;
    }

    public DocumentStatusHistory() {
    	this.m_id = 0;
    	this.m_recipientId = 0;
    	this.m_sendingStatusId = 0;
    	this.m_statusDate = null;
    	this.m_fault = null;
    	this.m_recipientStatusId = 0;
    	this.m_metaXML = "";
        
    	this.m_orgCode = "";
    	this.m_personCode = "";
    	this.m_subdivisionShortName = "";
    	this.m_occupationShortName = "";
    }
    
    public DocumentStatusHistory(
    	int id,
    	int recipientId,
    	int sendingStatusId,
    	Date statusDate,
    	Fault fault,
    	int recipientStatusId,
    	String metaXml) {
    	
    	this.m_id = id;
    	this.m_recipientId = recipientId;
    	this.m_sendingStatusId = sendingStatusId;
    	this.m_statusDate = statusDate;
    	this.m_fault = fault;
    	this.m_recipientStatusId = recipientStatusId;
    	this.m_metaXML = metaXml;
    	
    	this.m_orgCode = "";
    	this.m_personCode = "";
    	this.m_subdivisionShortName = "";
    	this.m_occupationShortName = "";
    }
    
    public int addToDB(Connection conn) throws SQLException, IllegalArgumentException {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();

            StringReader r = new StringReader(m_metaXML);
            String sql = "BEGIN INSERT INTO staatuse_ajalugu(staatuse_ajalugu_id, vastuvotja_id, staatus_id, staatuse_muutmise_aeg, fault_code, fault_actor, fault_string, fault_detail, vastuvotja_staatus_id, metaxml) VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?) RETURNING staatuse_ajalugu_id INTO ?; END;";
            CallableStatement cs = conn.prepareCall(sql);
            
            cs.setInt(1, m_id);
            cs.setInt(2, m_recipientId);
            cs.setInt(3, m_sendingStatusId);
            cs.setTimestamp(4, CommonMethods.sqlDateFromDate(m_statusDate), cal);
            if (m_fault != null) {
                cs.setString(5, CommonMethods.TruncateString(m_fault.getFaultCode(), 50));
                cs.setString(6, CommonMethods.TruncateString(m_fault.getFaultActor(), 250));
                cs.setString(7, CommonMethods.TruncateString(m_fault.getFaultString(), 500));
                cs.setString(8, CommonMethods.TruncateString(m_fault.getFaultDetail(), 2000));
            } else {
                cs.setNull(5, Types.VARCHAR);
                cs.setNull(6, Types.VARCHAR);
                cs.setNull(7, Types.VARCHAR);
                cs.setNull(8, Types.VARCHAR);
            }
            cs = CommonMethods.setNullableIntParam(cs, 9, m_recipientStatusId);
            cs.setCharacterStream(10, r, m_metaXML.length());
            cs.registerOutParameter(11, Types.INTEGER);
            cs.executeUpdate();
            m_id = cs.getInt(11);
            logger.debug("Added new history entry with ID: " + String.valueOf(m_id));
            cs.close();

            return m_id;
        } else {
        	throw new IllegalArgumentException("Database connection is NULL!");
        }
    }
    
    public static ArrayList<DocumentStatusHistory> getList(int documentId, Connection conn) throws IllegalArgumentException, IOException, SQLException {
        if (conn != null) {
            Calendar cal = Calendar.getInstance();
            CallableStatement cs = conn.prepareCall("{call GET_DOCUMENTSTATUSHISTORY(?,?)}");
            cs.setInt("document_id", documentId);
            cs.registerOutParameter("RC1", oracle.jdbc.OracleTypes.CURSOR);
            cs.execute();
            ResultSet rs = (ResultSet)cs.getObject("RC1");
            ArrayList<DocumentStatusHistory> result = new ArrayList<DocumentStatusHistory>();
            while (rs.next()) {
            	DocumentStatusHistory item = new DocumentStatusHistory();
            	item.setId(rs.getInt("staatuse_ajalugu_id"));
            	item.setRecipientId(rs.getInt("vastuvotja_id"));
            	item.setSendingStatusId(rs.getInt("staatus_id"));
            	item.setStatusDate(rs.getTimestamp("staatuse_muutmise_aeg", cal));
                
            	String faultString = rs.getString("fault_string");
                if ((faultString != null) && (faultString.length() > 0)) {
                    Fault f = new Fault(rs.getString("fault_code"), rs.getString("fault_actor"), faultString, rs.getString("fault_detail"));
                    item.setFault(f);
                }
            	
                item.setRecipientStatusId(rs.getInt("vastuvotja_staatus_id"));
                item.setOrgCode(rs.getString("asutuse_regnr"));
                item.setPersonCode(rs.getString("isikukood"));
                item.setSubdivisionShortName(rs.getString("allyksuse_lyhinimetus"));
                item.setOccupationShortName(rs.getString("ametikoha_lyhinimetus"));
                
                // Loeme CLOB-ist dokumendi andmed
                Clob tmpBlob = rs.getClob("metaxml");
                if (tmpBlob != null) {
                    Reader r = tmpBlob.getCharacterStream();

                    StringBuffer sb = new StringBuffer();
                    char[] charbuf = new char[Settings.getBinaryBufferSize()];
                    for (int i = r.read(charbuf); i > 0; i = r.read(charbuf)) {
                        sb.append(charbuf, 0, i);
                    }
                    item.setMetaXML(sb.toString());
                }
                result.add(item);
            }
            rs.close();
            cs.close();
            return result;
        } else {
        	throw new IllegalArgumentException("Database connection is NULL!");
        }
    }
    
    public void appendObjectXML(OutputStreamWriter xmlWriter, Connection conn) throws IOException {
        // Item element start
        xmlWriter.write("<staatus>");

        // Saaja
        xmlWriter.write("<saaja>");
        if ((m_orgCode != null) && (m_orgCode.length() > 0)) {
            xmlWriter.write("<regnr>" + m_orgCode + "</regnr>");
        }
        if ((m_personCode != null) && (m_personCode.length() > 0)) {
            xmlWriter.write("<isikukood>" + m_personCode + "</isikukood>");
        }
        if ((m_subdivisionShortName != null) && (m_subdivisionShortName.length() > 0)) {
            xmlWriter.write("<allyksuse_lyhinimetus>" + m_subdivisionShortName + "</allyksuse_lyhinimetus>");
        }
        if ((m_occupationShortName != null) && (m_occupationShortName.length() > 0)) {
            xmlWriter.write("<ametikoha_lyhinimetus>" + m_occupationShortName + "</ametikoha_lyhinimetus>");
        }
        xmlWriter.write("</saaja>");
        
        // Ajaloo kirje unikaalne ID
        xmlWriter.write("<staatuse_ajalugu_id>" + String.valueOf(m_id) + "</staatuse_ajalugu_id>");
        
        // Staatuse kuupäev
        xmlWriter.write("<staatuse_muutmise_aeg>" + CommonMethods.getDateISO8601(m_statusDate) + "</staatuse_muutmise_aeg>");

        // Staatuse kood
        String statOut = "";
        switch (m_sendingStatusId) {
            case CommonStructures.SendStatus_Sending:
                statOut = CommonStructures.SendStatus_Sending_Name;
                break;
            case CommonStructures.SendStatus_Sent:
                statOut = CommonStructures.SendStatus_Sent_Name;
                break;
            case CommonStructures.SendStatus_Canceled:
                statOut = CommonStructures.SendStatus_Canceled_Name;
                break;
            default:
                break;
        }
        xmlWriter.write("<staatus>" + statOut + "</staatus>");
        
        // Fault
        if (m_fault != null) {
        	m_fault.appendObjectXML(xmlWriter);
        }
        
        // Vastuvõtja saadetud staatus
        xmlWriter.write("<vastuvotja_staatus_id>" + String.valueOf(m_recipientStatusId) + "</vastuvotja_staatus_id>");

        // Vabas vormis metaandmed
        if ((m_metaXML != null) && (m_metaXML.length() > 0)) {
            xmlWriter.write("<metaxml>" + m_metaXML + "</metaxml>");
        }

        // Item element end
        xmlWriter.write("</staatus>");
    }
}
