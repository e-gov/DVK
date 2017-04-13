package dvk.client.test;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;

import org.apache.log4j.Logger;

import dvk.client.conf.OrgSettings;
import dvk.core.CommonMethods;
import dvk.core.Settings;

public class AddDHLMessage {

	private static Logger logger = Logger.getLogger(AddDHLMessage.class);
	
	/**
	 * @param args
	 * @thrjows Exception 
	 */
	public static void main(String[] args) throws Exception {

		logger.debug("Running AddDHLMessage...");
		
		String propertiesFile = "C:\\development\\ws\\dvk\\client\\src\\main\\resources\\dvk_client.properties";
		String dataFilePath = "C:\\development\\ws\\dvk\\doc\\test\\testkonteinerid\\2dvk_konteiner_v2_metaxml.xml";
		// Laeme rakenduse seaded
		Settings.loadProperties(propertiesFile);
		ArrayList<OrgSettings> allKnownDatabases = OrgSettings
				.getSettings(Settings.Client_ConfigFile);

		Class.forName("oracle.jdbc.driver.OracleDriver");
		String url = "jdbc:oracle:thin:@//127.0.0.1:1521/XE";
		Connection conn = DriverManager.getConnection(url,"dvkclient", "dvkclient123");
		int dhlMessageID = 0;
		
		File file = new File(dataFilePath);
		
		// File reader
		
		FileInputStream fis = new FileInputStream(file);
		BufferedInputStream bis = new BufferedInputStream(fis);
		
		InputStreamReader isr = new InputStreamReader(bis, "UTF-8");
		
		int fileCharsCount = getCharacterCountInFile(file.getAbsolutePath());
		logger.debug("fileCharsCount: " + fileCharsCount);
		Calendar cal = Calendar.getInstance();
		
		int m_dhlID = 0;
		String m_title = "Avaldus";
		String m_senderOrgCode = "87654321";
		String m_senderOrgName = "Riigikantselei";
		String m_senderPersonCode = "38005130332";
		String m_senderName = "Jaak Lember";
		String m_recipientOrgCode = "";
		String m_recipientOrgName = "";
		String m_recipientPersonCode = "";
		String m_recipientName = "";
		String m_caseName = "";
		String m_dhlFolderName = null;
		int m_sendingStatusID = 1; // 1 = waiting
		int m_unitID = 0;
		Date m_sendingDate = null;
		Date m_receivedDate = null;
		int m_localItemID = 3456;
		int m_recipientStatusID = 0;
		String m_faultCode = "";
		String m_faultActor = "";
		String m_faultString = "";
		String m_faultDetail = "";
		String m_metaXML = "";
		String m_queryID = "";
		String m_proxyOrgCode = "";
		String m_proxyOrgName = "";
		String m_proxyPersonCode = "";
		String m_proxyName = "";
		String m_recipientDepartmentNr = "";
		String m_recipientDepartmentName = "";
		String m_recipientEmail = "";
		int m_recipientDivisionID = 0;
		String m_recipientDivisionName = "";
		int m_recipientPositionID = 0;
		String m_recipientPositionName = "";
		String m_recipientDivisionCode = "";
		String m_recipientPositionCode = "";
		String m_dhlGuid = "cd171f7c-560d-4a62-8d65-16b87419a58c";
		
        if (conn != null) {
            
            CallableStatement cs = conn.prepareCall("{call Add_DhlMessage(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
            
            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, 0);
            cs.setCharacterStream(3, isr, fileCharsCount);
            cs.setInt(4, m_dhlID);
            cs.setString(5, m_title);
            cs.setString(6, m_senderOrgCode);
            cs.setString(7, m_senderOrgName);
            cs.setString(8, m_senderPersonCode);
            cs.setString(9, m_senderName);
            cs.setString(10, m_recipientOrgCode);
            cs.setString(11, m_recipientOrgName);
            cs.setString(12, m_recipientPersonCode);
            cs.setString(13, m_recipientName);
            cs.setString(14, m_caseName);
            cs.setString(15, m_dhlFolderName);
            cs.setInt(16, m_sendingStatusID);
            cs.setInt(17, m_unitID);
            cs.setTimestamp(18, CommonMethods.sqlDateFromDate(m_sendingDate), cal);
            cs.setTimestamp(19, CommonMethods.sqlDateFromDate(m_receivedDate), cal);
            cs.setInt(20, m_localItemID);
            cs.setInt(21, m_recipientStatusID);
            cs.setString(22, m_faultCode);
            cs.setString(23, m_faultActor);
            cs.setString(24, m_faultString);
            cs.setString(25, m_faultDetail);
            cs.setInt(26, 1);
            cs.setString(27, m_metaXML);
            cs.setString(28, m_queryID);
            cs.setString(29, m_proxyOrgCode);
            cs.setString(30, m_proxyOrgName);
            cs.setString(31, m_proxyPersonCode);
            cs.setString(32, m_proxyName);
            cs.setString(33, m_recipientDepartmentNr);
            cs.setString(34, m_recipientDepartmentName);
            cs.setString(35, m_recipientEmail);
            cs.setInt(36, m_recipientDivisionID);
            cs.setString(37, m_recipientDivisionName);
            cs.setInt(38, m_recipientPositionID);
            cs.setString(39, m_recipientPositionName);
            cs.setString(40, m_recipientDivisionCode);
            cs.setString(41, m_recipientPositionCode);
            cs.setString(42, m_dhlGuid);
            
            cs.execute();
            dhlMessageID = cs.getInt(1);
            cs.close();
            conn.close();
            
        } else {
            throw new SQLException("Database connection is NULL!");
        }

        isr.close();
        
		logger.debug("AddDHLMessage finished.");
		
	}
	
	public static int getCharacterCountInFile(String fileName) throws Exception {
        if ((fileName == null) || (fileName.length() < 1)) {
            return -1;
        }
        if (!(new File(fileName)).exists()) {
            return -1;
        }
        
        int result = -1;
        FileInputStream inStream = null;;
        InputStreamReader inReader = null;;
        BufferedReader reader = null;;
        int charsRead = 0;
        char[] readBuffer = new char[1];

        try {
            inStream = new FileInputStream(fileName);
            inReader = new InputStreamReader(inStream, "UTF-8");
            reader = new BufferedReader(inReader);
            result = 0;
            while ((charsRead = reader.read(readBuffer, 0, readBuffer.length)) > 0) {
                result += charsRead;
            }
        } catch (Exception ex) {
            result = -1;
            throw ex;
        } finally {
            reader = null;
            inReader = null;
            inStream = null;
        }
        
        return result;
    }

}
