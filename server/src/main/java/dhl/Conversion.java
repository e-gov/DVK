package dhl;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.xml.transform.stream.StreamResult;

import org.apache.log4j.Logger;

import dvk.core.CommonMethods;


/**
 * Contains functionality for converting DEC container from one version
 * to another.
 *
 * @author Marko Kurm, marko.kurm@mircolink.ee
 */
public class Conversion {

    private static Logger logger = Logger.getLogger(Conversion.class);

    private int version;

    private int targetVersion;

    private String xslt;

    private String inputFile;

    private String outputFile;

    /**
     * @param inputXMLFile
     * @param outputXMLFile
     * @param inputVersion
     * @param outputVersion
     * @param conn
     * @return
     */
    public boolean convertDVKContainer(String inputXMLFile,
                                       String outputXMLFile, int inputVersion, int outputVersion,
                                       Connection conn) {
        boolean result = false;

        return result;
    }

    /**
     * Retrieves the conversion data from the database according to the
     * inputVersion and outputVersion.
     *
     * @param conn database connection
     */    
    public void getConversionFromDB(Connection conn) {

        try {
            if (conn != null) {
                String sql = "SELECT * FROM konversioon WHERE version = ? AND result_version = ?";
                CallableStatement cs = conn.prepareCall(sql);
                cs.setInt(1, this.getVersion());
                cs.setInt(2, this.getTargetVersion());

                ResultSet rs = cs.executeQuery();
                if (rs.next()) {
                    String xsltClob = rs.getString("xslt");
                    if (xsltClob != null) {
                        this.setXslt(xsltClob);
                    } else {
                        throw new RuntimeException("xsltClob == null");
                    }
                }
                rs.close();
                cs.close();

            } else {
                throw new RuntimeException("Connection == null");
            }
        } catch (Exception e) {
            logger.error("Error retreiving conversion data from database: ", e);
        }
    }
    

    public void updateConversionInDB(Connection connection) {

        logger.debug("Updating conversion record...");
    	//PreparedStatement ps = conn.prepareStatement("UPDATE dokument SET sisu = ? WHERE dokument_id = ?");
        try {
            if (connection != null) {
            	ByteArrayInputStream fis = new ByteArrayInputStream(this.getXslt().getBytes("UTF-8"));                    	
            	PreparedStatement ps = connection.prepareStatement("UPDATE konversioon SET xslt = ? WHERE version = ? AND result_version = ?");
            	ps.setBinaryStream(1, fis, (int)this.getXslt().length());            	
            	ps.setInt(2, this.getVersion());
            	ps.setInt(3, this.getVersion());            	
            	ps.executeUpdate();            	
            	
                CommonMethods.safeCloseStream(fis);

                ps.close();
            	fis.close();
            	
            } else {
                throw new RuntimeException("Connection == null");
            }        	
        } catch (Exception e) {
            logger.error("Error updating Conversion in database: ", e);
        }
        logger.debug("Conversion updated.");
    }
    
    /**
     * Converts the inputFile to outputFile using the XSLT.
     *
     * @throws Exception
     */
    public void convert() throws Exception {
        logger.info("Transforming XML using XSLT...");
        logger.debug("InputFile: " + this.getInputFile());
        logger.debug("OutputFile: " + this.getOutputFile());
        logger.debug("Version: " + this.getVersion());
        logger.debug("TargetVersion: " + this.getTargetVersion());

        if ((new File(this.getInputFile())).exists()) {
            javax.xml.transform.TransformerFactory tFactory = javax.xml.transform.TransformerFactory.newInstance();
            if (tFactory != null) {
                if ((this.getXslt() != null) && (this.getXslt().length() > 0)) {
                    ByteArrayInputStream bis = new ByteArrayInputStream(this.getXslt().getBytes("UTF-8"));

                    javax.xml.transform.Transformer transformer = tFactory
                            .newTransformer(new javax.xml.transform.stream.StreamSource(bis));

                    if (transformer != null) {
                        StreamResult outputTarget = new StreamResult();
                        outputTarget.setOutputStream(new FileOutputStream(new File(this.getOutputFile())));
                        transformer.transform(new javax.xml.transform.stream.StreamSource(
                                new File(this.getInputFile())), outputTarget);

                        logger.debug("XML Transformed.");
                    } else {
                        logger.error("Container transformation failed! Failed creating Transformer for XSLT transformation.");
                    }
                } else {
                    logger.error("XSLT not defined (maybe missing from database?).");
                }
            } else {
                logger.error("Container transformation failed! Failed creating Transformer Factory for XSLT transformation.");
            }
        } else {
            logger.error("Container transformation failed! Input file does not exist.");
        }
    }

    /*
    private Connection initTestConnection() throws ClassNotFoundException,
            SQLException {
        // Load the JDBC driver    	
    	String driverName = "oracle.jdbc.driver.OracleDriver";
        Class.forName(driverName);        
        String serverName = "127.0.0.1";
        String portNumber = "1521";
        String sid = "XE";
        String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":"
                + sid;
        String username = "dvk";
        String password = "dvk123";

        return DriverManager.getConnection(url, username, password);
        
    }
    */

    private Connection initTestConnection() throws ClassNotFoundException, SQLException {    
    	// Load the JDBC driver    	
		String url = "jdbc:postgresql://127.0.0.1:5432/postgres";       
		String username = "postgres";
		String password = "postgres";
		return DriverManager.getConnection(url, username, password);


}
    
    /**
     * Testimiseks.
     *
     * @throws Exception
     */
    public static void main(String[] args) throws Exception {

        String docFolder = "C:\\development\\ws\\dvk\\doc\\test\\testkonteinerid\\";

        String inputFile = docFolder + "2dvk_konteiner_v2_metaxml.xml";
        String outputFile = docFolder + "2dvk_konteiner_v2_metaxml_result.xml";
        String xslt = "C:\\development\\ws\\dvk\\doc\\conversion\\v2_v1\\v2_v1.xsl";

        try {

            // Convert to DVK container version 1
            Conversion conversion = new Conversion();
            Connection conn = conversion.initTestConnection();
            conversion.setInputFile(inputFile);
            conversion.setOutputFile(inputFile + ".tmp");
            conversion.setVersion(2);
            conversion.setTargetVersion(1);

            conversion.getConversionFromDB(conn);

            // Convert
            conversion.convert();

        } catch (Exception e) {
            logger.error("Exception: ", e);
            throw e;
        }
    }

    public int getVersion() {
        return version;
    }

    public void setVersion(int version) {
        this.version = version;
    }

    public int getTargetVersion() {
        return targetVersion;
    }

    public void setTargetVersion(int targetVersion) {
        this.targetVersion = targetVersion;
    }

    public String getXslt() {
        return xslt;
    }

    public void setXslt(String xslt) {
        this.xslt = xslt;
    }

    public String getInputFile() {
        return inputFile;
    }

    public void setInputFile(String inputFile) {
        this.inputFile = inputFile;
    }

    public String getOutputFile() {
        return outputFile;
    }

    public void setOutputFile(String outputFile) {
        this.outputFile = outputFile;
    }

    /*
    public void updateConversionInDB(Connection connection) {

        logger.debug("Updating conversion record...");

        try {
            if (connection != null) {
                String sql = "SELECT xslt FROM konversioon WHERE version = "
                        + this.getVersion() + " AND result_version = "
                        + this.getTargetVersion() + " FOR UPDATE";
                logger.debug("Executing SQL: " + sql);
                Statement stmt = connection.createStatement();

                ResultSet rs = stmt.executeQuery(sql);

                if (rs.next()) {
                    logger.debug("Writing clob...");
                    Clob xslt = rs.getClob(1);
                    Writer clobWriter = xslt.setCharacterStream(0);
                    ByteArrayInputStream fis = new ByteArrayInputStream(this
                            .getXslt().getBytes("UTF-8"));
                    InputStreamReader r = new InputStreamReader(fis, "UTF-8");
                    char[] cbuffer = new char[Settings.getDBBufferSize()];
                    int nread = 0;
                    while ((nread = r.read(cbuffer)) > 0) {
                        clobWriter.write(cbuffer, 0, nread);
                    }
                    CommonMethods.safeCloseWriter(clobWriter);
                    CommonMethods.safeCloseReader(r);
                    CommonMethods.safeCloseStream(fis);
                }

                rs.close();

            } else {
                throw new RuntimeException("Connection == null");
            }

        } catch (Exception e) {
            logger.error("Error updating Conversion in database: ", e);
        }
        logger.debug("Conversion updated.");
    }
    */
    
    /*
    public void getConversionFromDB(Connection conn) {

        try {
            if (conn != null) {
                String sql = "SELECT * FROM konversioon WHERE version = ? AND result_version = ?";
                CallableStatement cs = conn.prepareCall(sql);
                cs.setInt(1, this.getVersion());
                cs.setInt(2, this.getTargetVersion());

                ResultSet rs = cs.executeQuery();

                if (rs.next()) {

                    Clob xsltClob = rs.getClob("xslt");
                    if (xsltClob != null) {
                        Reader r = xsltClob.getCharacterStream();
                        StringBuffer sb = new StringBuffer();
                        char[] charbuf = new char[Settings.getBinaryBufferSize()];

                        for (int i = r.read(charbuf); i > 0; i = r.read(charbuf)) {
                            sb.append(charbuf, 0, i);
                        }

                        this.setXslt(sb.toString());

                    } else {
                        throw new RuntimeException("xsltClob == null");
                    }
                }
                rs.close();
                cs.close();

            } else {
                throw new RuntimeException("Connection == null");
            }
        } catch (Exception e) {
            logger.error("Error retreiving conversion data from database: ", e);
        }
    }
    */
    
}
