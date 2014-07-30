package dhl.xslt;

import dvk.core.Settings;
import org.apache.axis.AxisFault;
import org.apache.commons.codec.binary.Base64InputStream;
import org.apache.commons.codec.binary.Base64OutputStream;
import org.apache.commons.io.IOUtils;
import org.apache.log4j.Logger;
import org.apache.xml.dtm.ref.DTMNodeIterator;
import org.w3c.dom.DOMException;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.naming.Context;
import javax.naming.InitialContext;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Random;
import java.util.zip.GZIPInputStream;

public class CustomFunctions {

    private static Logger logger = Logger.getLogger(CustomFunctions.class);

    static final int BASE64_CHUNK_SIZE = 76;
    static final String BASE64_LINE_SEPARATOR = "\n";

    private Connection connection;

    @Override
    protected void finalize() throws Throwable {

        if (this.getConnection() != null) {
            this.getConnection().close();
        }

        super.finalize();
    }

    /**
     * Converts position short name to position code by querying the database.
     *
     * @param positionShortName
     * @return positionCode
     * @throws AxisFault
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public String getPositionCodeByShortName(String positionShortName)
            throws AxisFault, SQLException, ClassNotFoundException {
        String result = null;

        try {

            // Check if the connection is established
            if (this.getConnection() == null) {
                // this.setConnection(initConnection());
                this.setConnection(initTestConnection());
            }

            result = getPositionCodeByShortNameFromDB(positionShortName);

        } catch (SQLException e) {
            logger.error("Error querying database: ", e);
        }

        return result;
    }

    public String getDivisionCodeByShortName(String divisionShortName)
            throws ClassNotFoundException {
        String result = null;

        try {

            // Check if the connection is established
            if (this.getConnection() == null) {
                // this.setConnection(initConnection());
                this.setConnection(initTestConnection());
            }

            result = getDivisionCodeByShortNameFromDB(divisionShortName);

        } catch (SQLException e) {
            logger.error("Error querying database: ", e);
        }

        return result;
    }

    /**
     * 1. Dekodeeritakse Base64 string
     * 2. Pakitakse lahti
     * 3. Kodeeritakse Base64 stringiks
     *
     * @param base64ZippedValue
     * @return
     * @throws DOMException
     * @throws IOException
     */
    public String unzip(Object base64ZippedValue) throws DOMException,
            IOException {
        String result = null;
        logger.debug("Unzipping...");

        String tmpDir = System.getProperty("java.io.tmpdir");

        try {
            DTMNodeIterator nodeIterator = (DTMNodeIterator) base64ZippedValue;

            byte[] buf = new byte[Settings.getBinaryBufferSize()];
            int len;
            Node n = nodeIterator.nextNode();
            NodeList nl = n.getChildNodes();

            if (nl.getLength() > 0) {
                Node contentNode = nl.item(0);
                if (contentNode != null) {
                    // siin läheb midagi sisendfailiga valesti.
                    // Generate file names
                    String decodedZipFileName = tmpDir + generateRandomFileName();
                    String unzippedDataFileName = tmpDir + generateRandomFileName();
                    logger.debug("decodedZipFileName: " + decodedZipFileName);
                    logger.debug("unzippedDataFileName: " + unzippedDataFileName);

                    // Open a stream to the text node in the XSLT
                    ByteArrayInputStream xsltContentInputStream = new ByteArrayInputStream(
                            contentNode.getTextContent().getBytes("UTF-8"));

                    Base64InputStream base64InputStream = new Base64InputStream(xsltContentInputStream);

                    // Open an outputStream to the unzipped datafile
                    FileOutputStream unzippedDataFileOutputStream = new FileOutputStream(
                            unzippedDataFileName);

                    // Open a ZipInputStream (Unzips)
                    GZIPInputStream gzipInputStream = new GZIPInputStream(base64InputStream);

                    IOUtils.copy(gzipInputStream, unzippedDataFileOutputStream);

                    // Open an inputStream for the base64 encoding
                    FileInputStream unzippedDataFileInputStream = new FileInputStream(
                            unzippedDataFileName);
                    System.out.println("unzippedDataFileName: " + unzippedDataFileName);
                    // Open an outputStream for base64 encoding
                    ByteArrayOutputStream encodedByteArrayOutputStream = new ByteArrayOutputStream();
                    // Base64 encode
                    Base64OutputStream base64OutputStream = new Base64OutputStream(encodedByteArrayOutputStream, true, BASE64_CHUNK_SIZE, BASE64_LINE_SEPARATOR.getBytes());
                    IOUtils.copy(unzippedDataFileInputStream, base64OutputStream);

                    // Close the streams
                    base64InputStream.close();
                    encodedByteArrayOutputStream.close();
                    unzippedDataFileInputStream.close();
                    gzipInputStream.close();
                    unzippedDataFileOutputStream.close();
                    xsltContentInputStream.close();

                    // Write the result back to the XSLT
                    return encodedByteArrayOutputStream.toString("UTF-8");
                }
            }

        } catch (Exception e) {
            logger.error("Error unzipping file data: ", e);
            throw new RuntimeException(e);
        }
        return result;
    }

    public static String generateRandomFileName() {
        StringBuffer result = new StringBuffer();
        Random r = new Random();
        for (int i = 0; i < 30; i++) {
            result.append(r.nextInt(10));
        }
        result.append(".dat");
        return result.toString();
    }

    public String getDataFileID(String jrkNr) throws Exception {
        String result = null;

        try {
            int jrknr = Integer.parseInt(jrkNr);
            result = "D" + (new Integer(jrknr - 1)).toString();
        } catch (Exception e) {
            logger.error("Error generating DataFile ID. jrkNr: " + jrkNr, e);
            throw e;
        }

        return result;
    }

    private String getPositionCodeByShortNameFromDB(String positionShortName)
            throws SQLException {
        String result = null;

        String sql = "SELECT ametikoht_id FROM ametikoht WHERE UPPER(lyhinimetus) = UPPER(?)";
        PreparedStatement preparedStatement = this.getConnection()
                .prepareStatement(sql);
        preparedStatement.setString(1, positionShortName);

        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            result = (new Integer(resultSet.getInt("ametikoht_id"))).toString();
        }

        preparedStatement.close();

        return result;
    }

    private String getDivisionCodeByShortNameFromDB(String divisionShortName)
            throws SQLException {
        String result = null;

        String sql = "SELECT id FROM allyksus WHERE UPPER(lyhinimetus) = UPPER(?)";
        PreparedStatement preparedStatement = this.getConnection()
                .prepareStatement(sql);
        preparedStatement.setString(1, divisionShortName);

        ResultSet resultSet = preparedStatement.executeQuery();

        if (resultSet.next()) {
            result = (new Integer(resultSet.getInt("id"))).toString();
        }

        preparedStatement.close();

        return result;
    }

    private Connection initTestConnection() throws ClassNotFoundException,
            SQLException {
        // Load the JDBC driver
        String driverName = "oracle.jdbc.driver.OracleDriver";
        Class.forName(driverName);

        // Create a connection to the database
        String serverName = "127.0.0.1";
        String portNumber = "1521";
        String sid = "XE";
        String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":"
                + sid;
        String username = "dvk";
        String password = "dvk123";

        return DriverManager.getConnection(url, username, password);
    }

    private Connection initConnection() throws AxisFault {
        try {
            Context initContext = new InitialContext();
            Context envContext = (Context) initContext.lookup("java:/comp/env");
            javax.sql.DataSource ds = (javax.sql.DataSource) envContext
                    .lookup(Settings.Server_DatabaseEnvironmentVariable);
            return ds.getConnection();
        } catch (Exception e) {
            logger.error("DVK Internal error. Error connecting to database: ",
                    e);
            throw new AxisFault(
                    "DVK Internal error. Error connecting to database: "
                            + e.getMessage());
        }
    }

    public Connection getConnection() {
        return this.connection;
    }

    public void setConnection(Connection connection) {
        this.connection = connection;
    }

}
