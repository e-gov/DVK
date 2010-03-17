package dvk.core;

import dvk.core.Fault;
import dvk.core.FileSplitResult;
import dvk.core.Settings;
import java.io.*;
import java.security.MessageDigest;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Types;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.Properties;
import java.util.zip.*;
import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.apache.axis.attachments.AttachmentPart;
import org.apache.axis.encoding.Base64;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.xml.soap.SOAPBody;
import javax.xml.stream.XMLInputFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;
import org.codehaus.stax2.XMLInputFactory2;
import org.codehaus.stax2.XMLStreamReader2;
import org.codehaus.stax2.validation.XMLValidationException;
import org.codehaus.stax2.validation.XMLValidationSchema;
import org.codehaus.stax2.validation.XMLValidationSchemaFactory;
import org.w3c.dom.Text;
import org.xml.sax.InputSource;


public class CommonMethods {
	
	static Logger logger = Logger.getLogger(CommonMethods.class.getName());
	
	/**
	 * Genereerib operatsioonisüsteemi ajutiste failide kataloogi uue unikaalse nimega ajutise faili.
	 * 
	 * @param itemIndex		Faili järjekorranumber. Võimaldab vajadusel eristada näiteks tsüklis loodud ajutisi faile.
	 * @return				Faili nimi (absolute path)
	 */
	public static String createPipelineFile(int itemIndex) {
		return createPipelineFile(itemIndex, "");
	}
	
	/**
	 * Genereerib operatsioonisüsteemi ajutiste failide kataloogi uue unikaalse nimega ajutise faili.
	 * 
	 * @param itemIndex		Faili järjekorranumber. Võimaldab vajadusel eristada näiteks tsüklis loodud ajutisi faile.
	 * @param extension		Faililaiend. Võimaldab ajutisele failile vajadusel ka faililaiendi anda. 
	 * @return				Faili nimi (absolute path)
	 */
    public static String createPipelineFile(int itemIndex, String extension) {
        try {
            if (extension == null) {
            	extension = "";
            }
            if ((extension.length() > 0) && !extension.startsWith(".")) {
            	extension = "." + extension;
            }
        	
        	String tmpDir = System.getProperty("java.io.tmpdir", "");
            String result = tmpDir + File.separator + "dhl_" + String.valueOf((new Date()).getTime()) + ((itemIndex > 0) ? "_item" + String.valueOf(itemIndex) : "") + extension;
            int uniqueCounter = 0;
            while ((new File(result)).exists()) {
                ++uniqueCounter;
                result = tmpDir + File.separator + "dhl_" + String.valueOf((new Date()).getTime()) + ((itemIndex > 0) ? "_item" + String.valueOf(itemIndex) : "") + "_" + String.valueOf(uniqueCounter) + extension;
            }
            File file = new File(result);
            file.createNewFile();
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "createPipelineFile");
            return null;
        }
    }
    
    public static void deleteOldPipelineFiles(int maxFilesToDelete, boolean giveFeedbackOnConsole) {
        // Kustutame üle 10 minuti vanused failid
        File tempPath = new File(System.getProperty("java.io.tmpdir", ""));
        if ((tempPath != null) && tempPath.exists() && tempPath.isDirectory()) {
            if (giveFeedbackOnConsole) {
                System.out.println("Deleting old temporary files from "+ tempPath.getAbsolutePath());
            }
            
            FilenameFilter filter = new FilenameFilter() {
                    String startMarker = "dhl_";
                    public boolean accept(File dir, String name) {
                        return name.startsWith(startMarker);
                    }
                };

            File[] files = tempPath.listFiles(filter);
            if ((files != null) && (files.length > 0)) {
                int count = Math.min(maxFilesToDelete, files.length);
                if (giveFeedbackOnConsole) {
                    System.out.println(String.valueOf(count) +" files to delete...");
                }
                for (int i = 0; i < count; ++i) {
                    try {
                        if ((System.currentTimeMillis() - files[i].lastModified()) > (1000 * 60 * 10)) {
                            files[i].delete();
                        }
                    } catch (Exception ex) {
                        CommonMethods.logError(ex, "CommonMethods", "deleteOldPipelineFiles");
                    }
                }
                if (giveFeedbackOnConsole) {
                    System.out.println("Old files deleted.");
                }
            }
            else {
                System.out.println("No files found!");
            }
        }
    }
    
    public static String getUniqueDirectory(String orgCode, String uniqueID) {
        try {
            String tmpDir = System.getProperty("java.io.tmpdir", "");
            String result = tmpDir + File.separator + "dhldir_" + orgCode + "_" + uniqueID;
            if (!(new File(result)).exists()) {
                if ((new File(result)).mkdir()) {
                    return result;
                } else {
                    return null;
                }
            } else {
                return result;
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "getUniqueDirectory");
            return null;
        }
    }

    public static boolean gzipUnpackXML(String sourceFile, boolean appendDocumentHeader) {
        byte[] buf = new byte[Settings.getBinaryBufferSize()];
        int len;
        FileInputStream sourceStream = null;
        GZIPInputStream in = null;
        FileOutputStream out = null;

        try {
            // Init streams needed for uncompressing data
            sourceStream = new FileInputStream(sourceFile);
            in = new GZIPInputStream(sourceStream);
            String targetFile = sourceFile + ".out";
            out = new FileOutputStream(targetFile, false);
            if (appendDocumentHeader) {
                out.write("<?xml version=\"1.0\" encoding=\"utf-8\"?><root>".getBytes("UTF-8"));
            }

            // Uncompress data in input stream
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
            if (appendDocumentHeader) {
                out.write("</root>".getBytes("UTF-8"));
            }

            // Paneme failid kinni, et saaks ülearuse faili maha kustutada ja
            // vajaliku ümber nimetada.
            safeCloseStream(in);
            safeCloseStream(sourceStream);
            safeCloseStream(out);

            // Kustutame esialgse faili ja nimetame uue ümber nii,
            // et see saaks vana asemele
            (new File(sourceFile)).delete();
            (new File(targetFile)).renameTo(new File(sourceFile));

            return true;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "gzipUnpackXML");
            return false;
        } finally {
            safeCloseStream(in);
            safeCloseStream(sourceStream);
            safeCloseStream(out);

            sourceStream = null;
            in = null;
            out = null;
            buf = null;
        }
    }

    public static String gzipPackXML(String filePath, String orgCode, String requestName) throws IllegalArgumentException, IOException {
        if (!(new File(filePath)).exists()) {
        	logger.debug("Input file \""+ filePath +"\" does not exist!");
            throw new IllegalArgumentException("Data file does not exist!");
        }

        String tmpDir = System.getProperty("java.io.tmpdir", "");

        // Pakime andmed kokku
        FileInputStream in = new FileInputStream(filePath);
        String zipOutFileName = tmpDir + File.separator + "dhl_" + requestName + "_" + orgCode + "_" + String.valueOf((new Date()).getTime()) + "_zipOutBuffer.dat";
        FileOutputStream zipOutFile = new FileOutputStream(zipOutFileName, false);
        GZIPOutputStream out = new GZIPOutputStream(zipOutFile);
        byte[] buf = new byte[Settings.getBinaryBufferSize()];
        int len;
        while ((len = in.read(buf)) > 0) {
            out.write(buf, 0, len);
        }
        in.close();
        out.finish();
        out.close();

        // Kodeerime pakitud andmed base64 kujule
        String base64OutFileName = tmpDir + File.separator + "dhl_" + requestName + "_" + orgCode + "_" + String.valueOf((new Date()).getTime()) + "_base64OutBuffer.dat";
        in = new FileInputStream(zipOutFileName);
        FileOutputStream b64out = new FileOutputStream(base64OutFileName, false);
        buf = new byte[66000];  // Puhvri pikkus peaks jaguma 3-ga
        while ((len = in.read(buf)) > 0) {
            b64out.write(Base64.encode(buf, 0, len).getBytes());
        }
        in.close();
        b64out.close();

        // Kustutame vaheproduktideks olnud failid ära
        (new File(zipOutFileName)).delete();

        return base64OutFileName;
    }
    
    public static String base64EncodeFile(String filePath, String orgCode, String requestName) {
        if (!(new File(filePath)).exists()) {
            CommonMethods.logError(new Exception("Data file does not exist!"), "CommonMethods", "gzipPackXML");
            return null;
        }

        try {
            String tmpDir = System.getProperty("java.io.tmpdir", "");

            // Kodeerime pakitud andmed base64 kujule
            String base64OutFileName = tmpDir + File.separator + "dhl_" + requestName + "_" + orgCode + "_" + String.valueOf((new Date()).getTime()) + "_base64OutBuffer.dat";
            FileInputStream in = new FileInputStream(filePath);
            FileOutputStream b64out = new FileOutputStream(base64OutFileName, false);
            byte[] buf = new byte[66000];  // Puhvri pikkus peaks jaguma 3-ga
            int len;
            while ((len = in.read(buf)) > 0) {
                b64out.write(Base64.encode(buf, 0, len).getBytes());
            }
            in.close();
            b64out.close();

            return base64OutFileName;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "gzipPackXML");
            return null;
        }
    }

    public static byte[] xmlElementToBinary(Element xmlElement) {
        try {
            return xmlElementToString(xmlElement).getBytes("UTF-8");
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "xmlElementToBinary");
            return null;
        }
    }

    public static boolean xmlElementToFile(Element xmlElement, String filePath) {
        boolean result = true;
        FileOutputStream out = null;
        OutputStreamWriter ow = null;
        try {
            out = new FileOutputStream(filePath, false);
            ow = new OutputStreamWriter(out, "UTF-8");

            Source source = new DOMSource(xmlElement);
            Transformer trans = TransformerFactory.newInstance().newTransformer();
            trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.transform(source, new StreamResult(ow));

            trans = null;
            source = null;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "xmlDocumentToFile");
            result = false;
        } finally {
            safeCloseWriter(ow);
            safeCloseStream(out);
            ow = null;
            out = null;
        }

        return result;
    }

    public static String xmlElementToString(Element xmlElement) {
        try {
            StringWriter sw = new StringWriter();
            Source source = new DOMSource(xmlElement);
            Transformer trans = TransformerFactory.newInstance().newTransformer();
            trans.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            trans.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
            trans.transform(source, new StreamResult(sw));
            return sw.toString();
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "xmlElementToString");
            return "";
        }
    }

    public static Document xmlDocumentFromBinary(byte[] data) {
        try {
            ByteArrayInputStream resultStream = new ByteArrayInputStream(data);
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            DocumentBuilder builder = factory.newDocumentBuilder();
            return builder.parse(resultStream);
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "xmlDocumentFromBinary");
            return null;
        }
    }

    public static Document xmlDocumentFromFile(String filePath, boolean namespaceAware) {
        try {
            DocumentBuilderFactory xmlFact = DocumentBuilderFactory.newInstance();
            xmlFact.setValidating(false);
            xmlFact.setNamespaceAware(namespaceAware);
            xmlFact.setIgnoringElementContentWhitespace(true);
            DocumentBuilder builder = xmlFact.newDocumentBuilder();
            FileInputStream inStream = null;
            InputStreamReader inReader = null;
            Document result = null;
            try {
                inStream = new FileInputStream(filePath);
                inReader = new InputStreamReader(inStream, "UTF-8");
                InputSource src = new InputSource(inReader);
                result = builder.parse(src);
            } finally {
                safeCloseReader(inReader);
                safeCloseStream(inStream);
                inReader = null;
                inStream = null;
            }
            return result;
        } catch (Exception ex) {
            //CommonMethods.logError(ex, "CommonMethods", "xmlDocumentFromFile");
            logger.error(ex.getMessage(), ex);
            return null;
        }
    }

    // Meetod teisendab Java kuupäeva ISO 8601 kuupäevastringiks,
    // mida saab kasutada XQuery ja XPath-iga.
    public static String getDateISO8601(Date date) {
        try {
            if (date == null) {
                return "";
            }

            DateFormat format = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
            String result = format.format(date);
            result = result.substring(0, result.length() - 2) + ":" + result.substring(result.length() - 2);
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "getDateISO8601");
            return "";
        }
    }

    public static Date getDateFromXML(String xmlDate) {
        Date result = null;
        if ((xmlDate != null) && !xmlDate.equalsIgnoreCase("")) {
            SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ");
            df.setLenient(false);
            try {
                result = df.parse(xmlDate);
            } catch (ParseException e1) {
                df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSZ");
                df.setLenient(false);
                try {
                    result = df.parse(xmlDate);
                } catch (ParseException e2) {
                    df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SZ");
                    df.setLenient(false);
                    try {
                        result = df.parse(xmlDate);
                    } catch (ParseException e3) {
                        df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
                        df.setLenient(false);
                        try {
                            result = df.parse(xmlDate);
                        } catch (ParseException e4) {
                            df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                            df.setLenient(false);
                            try {
                                result = df.parse(xmlDate);
                            } catch (ParseException e5) {
                                if (xmlDate.contains("T")) {
                                    return null;
                                }
                                df = new SimpleDateFormat("yyyy-MM-ddZ");
                                df.setLenient(false);
                                try {
                                    result = df.parse(xmlDate);
                                } catch (ParseException e6) {
                                    df = new SimpleDateFormat("yyyy-MM-dd");
                                    df.setLenient(false);
                                    try {
                                        result = df.parse(xmlDate);
                                    } catch (ParseException e7) {
                                        result = null;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return result;
    }

    public static java.sql.Timestamp sqlDateFromDate(java.util.Date date) {
        if (date == null) {
            return null;
        }
        return new java.sql.Timestamp(date.getTime());
    }

    public static boolean booleanFromXML(String xmlBool) {
        if (xmlBool == null) {
        	return false;
        } else {
        	xmlBool = xmlBool.trim();
        	if (xmlBool.length() < 1) {
                return false;
            } else if (xmlBool.equalsIgnoreCase("true")) {
                return true;
            } else if (xmlBool.equalsIgnoreCase("false")) {
                return false;
            } else if (xmlBool.equalsIgnoreCase("yes")) {
                return true;
            } else if (xmlBool.equalsIgnoreCase("no")) {
                return false;
            } else if (xmlBool.equals("1")) {
                return true;
            } else if (xmlBool.equals("0")) {
                return true;
            } else {
                return false;
            }
        }
    }

    public static byte[] getDataFromDataHandler(DataHandler handler) {
        try {
            InputStream dataStream = handler.getInputStream();
            ByteArrayOutputStream byteStream = new ByteArrayOutputStream();
            byte[] buf = new byte[Settings.getBinaryBufferSize()];
            int len = 0;
            while ((len = dataStream.read(buf, 0, buf.length)) > 0) {
                byteStream.write(buf, 0, len);
            }
            return byteStream.toByteArray();
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "getDataFromDataHandler");
            return null;
        }
    }

    public static String getDataFromDataSource(DataSource source, String transferEncoding, String targetFile, boolean append) {
        try {
            // Väldime andmete korduvat lugemist ja arvutame andmete esmakordsel
            // lugemisel ühtlasi ka andmete MD5 kontrollsumma
            MessageDigest md = MessageDigest.getInstance("MD5");
            InputStream dataStream = source.getInputStream();
            FileOutputStream outStream = new FileOutputStream(targetFile, append);

            // Puhvri pikkus peab jaguma 4-ga, kuna meil on potentsiaalselt tegemist
            // Base64 kodeeringus andmetega, mille me tahame kohe ka dekodeerida
            byte[] buf = new byte[65536];
            int len = 0;
            try {
                if (transferEncoding.equalsIgnoreCase("base64")) {
                    while ((len = dataStream.read(buf, 0, buf.length)) > 0) {
                        md.update(buf, 0, len);
                        outStream.write(buf, 0, len);
                    }
                } else {
                    String base64String = "";
                    while ((len = dataStream.read(buf, 0, buf.length)) > 0) {
                        md.update(buf, 0, len);
                        base64String = new String(buf, 0, len);
                        outStream.write(Base64.decode(base64String));
                    }
                }
            } finally {
                buf = null;
                safeCloseStream(dataStream);
                safeCloseStream(outStream);
                dataStream = null;
                outStream = null;
            }

            byte[] digest = md.digest();
            md = null;

            return byteArrayToHex(digest);
        } catch (Exception ex) {
            CommonMethods.logError(ex, "CommonMethods", "getDataFromDataSource");
            return null;
        }
    }

    public static String byteArrayToHex(byte[] data) {
        StringBuffer result = new StringBuffer(2 * data.length);
        for (int i = 0; i < data.length; ++i) {
            appendHexPair(data[i], result);
        }
        return result.toString();
    }

    private static void appendHexPair(byte b, StringBuffer hexString) {
        char highNibble = kHexChars[(b & 0xF0) >> 4];
        char lowNibble = kHexChars[b & 0x0F];
        hexString.append(highNibble);
        hexString.append(lowNibble);
    }

    private static final char kHexChars[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };

    public static boolean writeToFile(String fileName, byte[] data) {
        try {
            FileOutputStream fs = new FileOutputStream(fileName, true);
            fs.write(data);
            fs.close();
            return true;
        } catch (Exception ex) {
            return false;
        }
    }

    public static void writeLog(String data) {
        writeLog(data, false);
    }

    public static void writeLog(String data, boolean onScreen) {
        if (onScreen) {
            System.out.println(data);
        }
        
        String logLocation = null;
        if (Settings.currentProperties != null) {
            logLocation = Settings.Test_LogFile;
        } else {
            String tmpDir = System.getProperty("java.io.tmpdir", "");
            logLocation = tmpDir + File.separator + "dvk_test_log.txt";            
        }
        
        if ((logLocation != null) && (logLocation.length() > 0)) {
            writeToFile(logLocation, (data + "\r\n").getBytes());
        }
    }

    public static void debugWrite(String data) {
        boolean logErrors = false;
        String logLocation = null;
        
        if (Settings.currentProperties != null) {
            logErrors = Settings.LogErrors;
            logLocation = Settings.ErrorLogFile;
        } else {
            logErrors = true;
            String tmpDir = System.getProperty("java.io.tmpdir", "");
            logLocation = tmpDir + File.separator + "dvk_error_log.txt";
        }
        
        if (logErrors && (logLocation != null) && (logLocation.length() > 0)) {
            writeToFile(logLocation, (data + "\r\n").getBytes());
        }
    }

    public static void logError(Exception ex, String className, String methodName) {
        logger.error(className + "." + methodName + "()", ex);
    	/*
    	boolean logErrors = false;
        String logLocation = null;
        
        if (Settings.currentProperties != null) {
            logErrors = Settings.LogErrors;
            logLocation = Settings.ErrorLogFile;
        } else {
            logErrors = true;
            String tmpDir = System.getProperty("java.io.tmpdir", "");
            logLocation = tmpDir + File.separator + "dvk_error_log.txt";
        }
        
        if (logErrors && (logLocation != null) && (logLocation.length() > 0)) {
            StringBuffer data = new StringBuffer();
            data.append("ERROR: [").append(className).append('|').append(methodName).append("] [").append((new Date()).toString()).append("]\r\n");
            data.append("    ").append(ex.getClass().getName()).append(": ").append(ex.getMessage()).append("\r\n");
            writeToFile(logLocation, (data.toString() + "\r\n").getBytes());

            FileOutputStream fs = null;
            PrintStream ps = null;
            try {
                fs = new FileOutputStream(logLocation, true);
                ps = new PrintStream(fs, true);
                ex.printStackTrace(ps);
            } catch (Exception e) {
            } finally {
                safeCloseStream(ps);
                safeCloseStream(fs);
                ps = null;
                fs = null;
            }

            writeToFile(logLocation, ("\r\n").getBytes());
            sendEmail(data.toString());
        }*/
    }

    public static String getNodeText(Node node) {
        if (node.getNodeType() == Node.TEXT_NODE) {
            return (node.getNodeValue() == null) ? "" : node.getNodeValue();
        } else {
            NodeList nodes = node.getChildNodes();
            int nodesCount = nodes.getLength();
            if (nodesCount > 0) {
                for (int i = 0; i < nodesCount; ++i) {
                    String tmp = getNodeText(nodes.item(i));
                    if ((tmp != null) && (tmp.length() > 0)) {
                        return tmp;
                    }
                }
            }
            return "";
        }
    }

    public static void removeNodeChildren(Node root) {
        NodeList nl = root.getChildNodes();
        for (int i = 0; i < nl.getLength(); ++i) {
            root.removeChild(nl.item(i));
        }
    }

    public static String getXRoadRequestVersion(String xroadRequestName) {
        String[] splitName = xroadRequestName.split("[.]");
        if ((splitName != null) && (splitName.length > 0)) {
            return splitName[splitName.length - 1];
        } else {
            return "";
        }
    }

    public static void closeConnectionSafely(Connection conn) {
        try {
            if ((conn != null) && (!conn.isClosed())) {
                conn.close();
            }
        } catch (Exception e) {
            CommonMethods.logError(e, "dvk.core.CommonMethods", "closeConnectionSafely");
        }
    }

    public static CallableStatement setNullableIntParam(CallableStatement cs, int index, int value) throws SQLException {
        if (cs != null) {
            if (value != 0) {
                cs.setInt(index, value);
            } else {
                cs.setNull(index, Types.INTEGER);
            }
            return cs;
        } else {
            return null;
        }
    }
    
    public static CallableStatement setNullableIntParam(CallableStatement cs, String paramName, int value) throws SQLException {
        if (cs != null) {
            if (value != 0) {
                cs.setInt(paramName, value);
            } else {
                cs.setNull(paramName, Types.INTEGER);
            }
            return cs;
        } else {
            return null;
        }
    }

    public static void safeCloseReader(Reader r) {
        if (r != null) {
            try {
                r.close();
            } catch (Exception ex) {
            } finally {
                r = null;
            }
        }
    }

    public static void safeCloseWriter(Writer w) {
        if (w != null) {
            try {
                w.flush();
                w.close();
            } catch (Exception ex) {
            } finally {
                w = null;
            }
        }
    }

    public static void safeCloseStream(InputStream s) {
        if (s != null) {
            try {
                s.close();
            } catch (Exception ex) {
            } finally {
                s = null;
            }
        }
    }

    public static void safeCloseStream(OutputStream s) {
        if (s != null) {
            try {
                s.close();
            } catch (Exception ex) {
            } finally {
                s = null;
            }
        }
    }    
    
    public static FileSplitResult splitOutTags(String xmlFileName, String tagLocalName, boolean noMainFile, boolean noSubFiles, boolean replaceMain) {
        FileSplitResult result = new FileSplitResult();
        result.subFiles = new ArrayList<String>();
        
        int dvkContainerVersion = 0;
        
        FileInputStream mainInStream = null;
        InputStreamReader mainInReader = null;
        BufferedReader mainReader = null;
        FileOutputStream mainOutStream = null;
        OutputStreamWriter mainOutWriter = null;
        BufferedWriter mainWriter = null;
        FileOutputStream subOutStream = null;
        OutputStreamWriter subOutWriter = null;
        BufferedWriter subWriter = null;

        Pattern startPattern = Pattern.compile("<([\\w]+:)?" + tagLocalName, Pattern.DOTALL | Pattern.CANON_EQ | Pattern.CASE_INSENSITIVE);
        Pattern endPattern = Pattern.compile("<\\/([\\w]+:)?" + tagLocalName, Pattern.DOTALL | Pattern.CANON_EQ | Pattern.CASE_INSENSITIVE);
        Pattern startAndEndPattern = Pattern.compile("<([\\w]+:)?" + tagLocalName + "([^>])*\\/([\\s])*>", Pattern.DOTALL | Pattern.CANON_EQ | Pattern.CASE_INSENSITIVE);

        int charsRead = 0;
        char[] readBuffer = new char[1];
        String ioBuffer = "";
        boolean isTag = false;
        boolean isMainDocument = true;
        int currentLevel = 0;
        int itemNr = 0;

        String mainDataFile = null;
        String subFileName = null;

        if (!noMainFile) {
            mainDataFile = createPipelineFile(0);
        }

        try {
            mainInStream = new FileInputStream(xmlFileName);
            mainInReader = new InputStreamReader(mainInStream, "UTF-8");
            mainReader = new BufferedReader(mainInReader);

            if (!noMainFile) {
                mainOutStream = new FileOutputStream(mainDataFile, false);
                mainOutWriter = new OutputStreamWriter(mainOutStream, "UTF-8");
                mainWriter = new BufferedWriter(mainOutWriter);
            }

            while ((charsRead = mainReader.read(readBuffer, 0, readBuffer.length)) > 0) {
                if (readBuffer[0] == '<') {
                    isTag = true;
                }

                // Kui asume keset lõputähiseta TAGi, siis lisame sümboli puhvrisse
                if (isTag) {
                    ioBuffer += readBuffer[0];
                } else {
                    if (isMainDocument) {
                        if (!noMainFile) {
                            mainWriter.write(readBuffer, 0, charsRead);
                        }
                    } else {
                        if (!noSubFiles) {
                            subWriter.write(readBuffer, 0, charsRead);
                        }
                    }
                }

                if (readBuffer[0] == '>') {
                    isTag = false;

                    Matcher startMatcher = startPattern.matcher(ioBuffer);
                    Matcher endMatcher = endPattern.matcher(ioBuffer);
                    Matcher startAndEndMatcher = startAndEndPattern.matcher(ioBuffer);

                    if (startAndEndMatcher.find()) {
                    	
                    	dvkContainerVersion = 1;
                    	
                        if (!noSubFiles) {
                            if (currentLevel == 0) {
                                subFileName = createPipelineFile(++itemNr);
                                result.subFiles.add(subFileName);
                                subOutStream = new FileOutputStream(subFileName, false);
                                subOutWriter = new OutputStreamWriter(subOutStream, "UTF-8");
                                subWriter = new BufferedWriter(subOutWriter);
                                subWriter.write(ioBuffer);

                                // Kirjutame põhifaili kommentaari, mille alusel me pärast
                                // eraldatud TAGi tagasi saame panna.
                                if (!noMainFile) {
                                    mainWriter.write("<!--DVK_SYS_INCLUDE_" + (new File(subFileName)).getName() + "-->");
                                }

                                safeCloseWriter(subWriter);
                                safeCloseWriter(subOutWriter);
                                safeCloseStream(subOutStream);
                            } else {
                                subWriter.write(ioBuffer);
                            }
                        }
                    } else if (startMatcher.find()) {
                    	
                    	dvkContainerVersion = 1;
                    	
                        // Puhvris on eraldatava TAGi algus
                        ++currentLevel;

                        // Veendume, et tegemist on kõige ülemise taseme algusega
                        if (currentLevel == 1) {
                            isMainDocument = false;
                            if (!noSubFiles) {
                                subFileName = createPipelineFile(++itemNr);
                                result.subFiles.add(subFileName);
                                subOutStream = new FileOutputStream(subFileName, false);
                                subOutWriter = new OutputStreamWriter(subOutStream, "UTF-8");
                                subWriter = new BufferedWriter(subOutWriter);
                            }
                        }

                        if (!noSubFiles) {
                            subWriter.write(ioBuffer);

                            // Kirjutame põhifaili kommentaari, mille alusel me pärast
                            // eraldatud TAGi tagasi saame panna.
                            if (!noMainFile && (currentLevel == 1)) {
                                mainWriter.write("<!--DVK_SYS_INCLUDE_" + (new File(subFileName)).getName() + "-->");
                            }
                        }
                    } else if (endMatcher.find()) {
                    	
                    	dvkContainerVersion = 1;
                    	
                        if (!noSubFiles) {
                            // Puhvris on eraldatava TAGi lõpp
                            subWriter.write(ioBuffer);
                        }
                        // Veendume, et tegemist on kõige ülemise taseme lõpuga
                        if (currentLevel == 1) {
                            if (!noSubFiles) {
                                safeCloseWriter(subWriter);
                                safeCloseWriter(subOutWriter);
                                safeCloseStream(subOutStream);
                            }
                            isMainDocument = true;
                        }
                        --currentLevel;
                    } else {
                        if (isMainDocument) {
                            if (!noMainFile) {
                                mainWriter.write(ioBuffer);
                            }
                        } else {
                            if (!noSubFiles) {
                                subWriter.write(ioBuffer);
                            }
                        }
                    }

                    ioBuffer = "";
                    startMatcher = null;
                    endMatcher = null;
                    startAndEndMatcher = null;
                }
            }

            // Paneme kasutatud failid kinni
            safeCloseReader(mainReader);
            safeCloseReader(mainInReader);
            safeCloseStream(mainInStream);
            safeCloseWriter(mainWriter);
            safeCloseWriter(mainOutWriter);
            safeCloseStream(mainOutStream);
            safeCloseWriter(subWriter);
            safeCloseWriter(subOutWriter);
            safeCloseStream(subOutStream);

            // Nimetame failid ümber nii, et töödeldud fail asendaks algselt
            // ette antud faili.
            if (!noMainFile) {
                if (replaceMain) {
                    (new File(xmlFileName)).delete();
                    (new File(mainDataFile)).renameTo(new File(xmlFileName));
                    result.mainFile = xmlFileName;
                } else {
                    result.mainFile = mainDataFile;
                }
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.CommonMethods", "splitOutTags");
        } finally {
            // Streamid kinni
            safeCloseReader(mainReader);
            safeCloseReader(mainInReader);
            safeCloseStream(mainInStream);
            safeCloseWriter(mainWriter);
            safeCloseWriter(mainOutWriter);
            safeCloseStream(mainOutStream);
            safeCloseWriter(subWriter);
            safeCloseWriter(subOutWriter);
            safeCloseStream(subOutStream);

            mainInStream = null;
            mainInReader = null;
            mainReader = null;
            mainOutStream = null;
            mainOutWriter = null;
            mainWriter = null;
            subOutStream = null;
            subOutWriter = null;
            subWriter = null;

            startPattern = null;
            endPattern = null;
            startAndEndPattern = null;
            ioBuffer = null;
            mainDataFile = null;
        }

        // What version of DVK Container
        if(dvkContainerVersion == 0) {
        	result.setDvkContainerVersion(2);
        } else {
        	result.setDvkContainerVersion(1);
        }
        
        return result;
    }

    public static void joinSplitXML(String xmlFileName, BufferedWriter mainOutWriter) {
        FileInputStream mainInStream = null;
        InputStreamReader mainInReader = null;
        BufferedReader mainReader = null;
        FileInputStream subInStream = null;
        InputStreamReader subInReader = null;
        BufferedReader subReader = null;

        int charsRead = 0;
        char[] readBuffer = new char[1];
        String ioBuffer = "";
        boolean isTag = false;
        String tmpDir = System.getProperty("java.io.tmpdir", "");

        try {
            mainInStream = new FileInputStream(xmlFileName);
            mainInReader = new InputStreamReader(mainInStream, "UTF-8");
            mainReader = new BufferedReader(mainInReader);
            while ((charsRead = mainReader.read(readBuffer, 0, readBuffer.length)) > 0) {
                if (readBuffer[0] == '<') {
                    isTag = true;
                }

                // Kui asume keset lõputähiseta TAGi, siis lisame sümboli puhvrisse
                if (isTag) {
                    ioBuffer += readBuffer[0];
                } else {
                    mainOutWriter.write(readBuffer, 0, charsRead);
                }

                if (readBuffer[0] == '>') {
                    isTag = false;

                    if (ioBuffer.startsWith("<!--DVK_SYS_INCLUDE_")) {
                        String subFileName = tmpDir + File.separator + ioBuffer.replace("<!--DVK_SYS_INCLUDE_", "").replace("-->", "").trim();
                        if ((new File(subFileName)).exists()) {
                            subInStream = new FileInputStream(subFileName);
                            subInReader = new InputStreamReader(subInStream, "UTF-8");
                            subReader = new BufferedReader(subInReader);
                            int subCharsRead = 0;
                            char[] subReadBuffer = new char[Settings.getBinaryBufferSize()];
                            while ((subCharsRead = subReader.read(subReadBuffer, 0, subReadBuffer.length)) > 0) {
                                mainOutWriter.write(subReadBuffer, 0, subCharsRead);
                            }
                            safeCloseReader(subReader);
                            safeCloseReader(subInReader);
                            safeCloseStream(subInStream);

                            // Kustutame ajutise faili
                            (new File(subFileName)).delete();
                        }
                    } else {
                        mainOutWriter.write(ioBuffer);
                    }

                    ioBuffer = "";
                }
            }

            // Paneme sisendfaili kinni, et saaks ülearuse faili ära kustutada
            safeCloseReader(mainReader);
            safeCloseReader(mainInReader);
            safeCloseStream(mainInStream);

            // Kustutame ajutise faili 
            (new File(xmlFileName)).delete();
        } catch (Exception ex) {
        	logger.error("Exception: ", ex);
            CommonMethods.logError(ex, "dhl.CommonMethods", "joinSplitXML");
        } finally {
            safeCloseReader(mainReader);
            safeCloseReader(mainInReader);
            safeCloseStream(mainInStream);
            safeCloseReader(subReader);
            safeCloseReader(subInReader);
            safeCloseStream(subInStream);

            mainInStream = null;
            mainInReader = null;
            mainReader = null;
            subInStream = null;
            subInReader = null;
            subReader = null;

            ioBuffer = null;
        }
    }

    public static Fault validateDVKContainerWithLocalSchema(String containerFilename) throws AxisFault {
        if (Settings.Server_ValidateContainer && (Settings.Server_ValidationSchemaFile != null) && (new File(Settings.Server_ValidationSchemaFile)).exists()) {
            XMLValidationSchemaFactory schemaFactory = XMLValidationSchemaFactory.newInstance(XMLValidationSchema.SCHEMA_ID_W3C_SCHEMA);
            XMLValidationSchema schema = null;
            XMLInputFactory2 xmlIF = (XMLInputFactory2)XMLInputFactory.newInstance();
            xmlIF.configureForLowMemUsage();
            XMLStreamReader2 reader = null;

            try {
                schema = schemaFactory.createSchema(new File(Settings.Server_ValidationSchemaFile));
            } catch (Exception ex) {
                throw new AxisFault("Error initializing validation schema: " + ex.getMessage());
            }

            try {
                reader = xmlIF.createXMLStreamReader(new File(containerFilename));
                
                reader.validateAgainst(schema);
                while (reader.hasNext()) {
                    reader.next();
                }
            } catch (XMLValidationException ex) {
                if (Settings.Server_IgnoreInvalidContainers) {
                    Fault result = new Fault();
                    result.setFaultActor(CommonStructures.FAULT_ACTOR);
                    result.setFaultCode(CommonStructures.FAULT_INVALID_CONTAINER_CODE);
                    result.setFaultString("DVK container XML is invalid!");
                    result.setFaultDetail(ex.getMessage());
                    return result;
                } else {
                    throw new AxisFault("DVK container XML is invalid: " + ex.getMessage());
                }
            } catch (Exception ex) {
                throw new AxisFault("Error initializing validator: " + ex.getMessage());
            } finally {
                if (reader != null) {
                    try {
                        reader.closeCompletely();
                    } catch (Exception ex) {
                    }
                    reader = null;
                }
            }
        }
        return null;
    }

    public static Fault validateDVKContainer(String containerFilename) throws AxisFault {
        if (Settings.Server_ValidateContainer) {
            try {
                ArrayList<String> errors = XmlValidator.Validate(containerFilename);
                if ((errors != null) && !errors.isEmpty()) {
                    String msg = String.valueOf(errors.size()) + " XML validation errors:\n";
                    for (int i = 0; i < errors.size(); ++i) {
                        msg += errors.get(i) + "\n";
                    }
                    if (Settings.Server_IgnoreInvalidContainers) {
                        Fault result = new Fault();
                        result.setFaultActor(CommonStructures.FAULT_ACTOR);
                        result.setFaultCode(CommonStructures.FAULT_INVALID_CONTAINER_CODE);
                        result.setFaultString("DVK container XML is invalid!");
                        result.setFaultDetail(msg);
                        return result;
                    } else {
                        throw new AxisFault("DVK container XML is invalid: " + msg);
                    }
                }
            } catch (Exception ex) {
                throw new AxisFault(ex.getMessage());
            }
        }
        return null;
    }
    
    public static boolean deleteDir(File dir) {
        if (dir.isDirectory()) {
            String[] children = dir.list();
            for (int i = 0; i < children.length; i++) {
                boolean success = deleteDir(new File(dir, children[i]));
                if (!success) {
                    return false;
                }
            }
        }
        return dir.delete();
    }
    
    public static boolean copyFile(String sourceFile, String destinationFile) {
        InputStream in = null;
        OutputStream out = null;
        byte[] buf = new byte[Settings.getBinaryBufferSize()];
        int len = 0;
        boolean result = true;
        try {
            in = new FileInputStream(sourceFile);
            out = new FileOutputStream(destinationFile);
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
        } catch (Exception ex) {
            result = false;
        } finally {
            safeCloseStream(in);
            safeCloseStream(out);
            in = null;
            out = null;
            buf = null;
        }
        return result;
    }
    
    public static ArrayList<String> splitFileBySize(String filePath, long maxSizeBytes) throws Exception {
        ArrayList<String> result = new ArrayList<String>();
        
        int bufferSize = Settings.getBinaryBufferSize();
        if (bufferSize > maxSizeBytes) {
            bufferSize = (int)maxSizeBytes;
        }
        
        byte[] buf = new byte[bufferSize];
        FileInputStream sourceStream = null;
        FileOutputStream outStream = null;
        long currentFileSize = 0;
        int len = 0;
        int readLen = 0;
        long fileSize = (new File(filePath)).length();
        int fragmentCount = (int)Math.floor((double) (fileSize / maxSizeBytes)) + 1;
        
        try {
            sourceStream = new FileInputStream(filePath);
            for (int i = 0; i < fragmentCount; ++i) {
                try {
                    String fragmentFileName = createPipelineFile(i);
                    result.add(fragmentFileName);
                    currentFileSize = 0;
                    outStream = new FileOutputStream(fragmentFileName, false);
                    readLen = buf.length;
                    if (readLen > (maxSizeBytes - currentFileSize)) {
                        readLen = (int)(maxSizeBytes - currentFileSize);
                    }
                    while ((currentFileSize < maxSizeBytes) && ((len = sourceStream.read(buf, 0, readLen)) > 0)) {
                        outStream.write(buf, 0, len);
                        currentFileSize += len;
                        readLen = buf.length;
                        if (readLen > (maxSizeBytes - currentFileSize)) {
                            readLen = (int)(maxSizeBytes - currentFileSize);
                        }
                    }
                } finally {
                    safeCloseStream(outStream);
                    outStream = null;
                }
            }
        } finally {
            safeCloseStream(sourceStream);
            sourceStream = null;
            buf = null;
        }
        
        return result;
    }
    
    public static Element appendTextNode(Document xmlDoc, Element parentNode, String tagName, String tagValue, String nsPrefix, String nsURI) {
        Element e = null;
        NodeList foundNodes = parentNode.getElementsByTagNameNS(nsURI, tagName);
        if (foundNodes.getLength() == 0) {
            e = xmlDoc.createElementNS(nsURI, nsPrefix + ":"+ tagName);
            parentNode.appendChild(e);
        } else {
            e = (Element)foundNodes.item(0);
            CommonMethods.removeNodeChildren(e);
        }
        Text t = xmlDoc.createTextNode(tagValue);
        if ((t != null) && (t.getNodeValue() != null) && !t.getNodeValue().equalsIgnoreCase("")) {
            e.appendChild(t);
        }
        return parentNode;
    }

    public static Element appendTextNodeBefore(Document xmlDoc, Element parentNode, String tagName, String tagValue, String nsPrefix, String nsURI, Node refNode) {
        Element e = null;
        NodeList foundNodes = parentNode.getElementsByTagNameNS(nsURI, tagName);
        if (foundNodes.getLength() == 0) {
            e = xmlDoc.createElementNS(nsURI, nsPrefix + ":"+ tagName);
            if (refNode != null) {
                parentNode.insertBefore(e, refNode);
            } else {
                parentNode.appendChild(e);
            }
        } else {
            e = (Element)foundNodes.item(0);
            CommonMethods.removeNodeChildren(e);
        }
        Text t = xmlDoc.createTextNode(tagValue);
        if ((t != null) && (t.getNodeValue() != null) && !t.getNodeValue().equalsIgnoreCase("")) {
            e.appendChild(t);
        }
        return parentNode;
    }
    
    // Eemaldab DVK konteineri <transport> plokist need asutused, kellele pole
    // antud dokumenti enam vaja edastada.
    public static void changeTransportData(String filePath, ArrayList<String> allowedOrgs, boolean addProxy) throws Exception {
        org.w3c.dom.Document currentXmlContent = CommonMethods.xmlDocumentFromFile(filePath, true);
        Element transportNode = null;

        // Tuvastame DVK nimeruumi versiooni
        String dvkNamespace = CommonStructures.DhlNamespace; 
        NodeList foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(dvkNamespace, "transport");
        if (foundNodes.getLength() < 1) {
        	dvkNamespace = CommonStructures.DhlNamespaceV2;
        	foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(dvkNamespace, "transport");
        }
        
        if (foundNodes.getLength() > 0) {
            transportNode = (Element)foundNodes.item(0);
            foundNodes = transportNode.getElementsByTagNameNS(dvkNamespace, "saaja");
            
            // Eemaldame saajate hulgast nende asutuste/isikute andmed,
            // kellele on dokument antud serveri piires juba kohale toimetatud
            for (int i = 0; i < foundNodes.getLength(); ++i) {
                NodeList regNrNodes = ((Element)foundNodes.item(i)).getElementsByTagNameNS(dvkNamespace, "regnr");
                String regNr = "";
                if (regNrNodes.getLength() > 0) {
                    regNr = CommonMethods.getNodeText(regNrNodes.item(0));
                }
                if ((regNr != null) && !regNr.equalsIgnoreCase("") && !allowedOrgs.contains(regNr)) {
                    transportNode.removeChild(foundNodes.item(i));
                }
            }
            
            // Tuvastame DHL nimeruumi prefiksi
            String defaultPrefix = currentXmlContent.lookupPrefix(dvkNamespace);
            if (defaultPrefix == null) {
                defaultPrefix = "dhl";
                int prefixCounter = 0;
                while (currentXmlContent.lookupNamespaceURI(defaultPrefix) != null) {
                    prefixCounter++;
                    defaultPrefix = "dhl" + String.valueOf(prefixCounter);
                }
            }
            
            // Märgime antud DVK serveri sõnumi vahendajaks
            if (addProxy){
            	Element elProxy = currentXmlContent.createElementNS(dvkNamespace, defaultPrefix + ":vahendaja");
                elProxy = CommonMethods.appendTextNode(currentXmlContent, elProxy, "regnr", Settings.Client_DefaultOrganizationCode, defaultPrefix, dvkNamespace);
                elProxy = CommonMethods.appendTextNode(currentXmlContent, elProxy, "isikukood", Settings.Client_DefaultPersonCode, defaultPrefix, dvkNamespace);
                transportNode.appendChild(elProxy);
            }
        }

        // Salvestame muudetud XML andmed faili
        CommonMethods.xmlElementToFile(currentXmlContent.getDocumentElement(), filePath);
    }
    
    public static int toIntSafe(String val, int defaultValue) {
        try {
            if (val == null) {
                return defaultValue;
            }
            return Integer.parseInt(val);
        }
        catch (Exception ex) {
            return defaultValue;
        }
    }
    
    public static boolean personalIDCodeHasCountryCode(String personalIDCode) {
        if (personalIDCode == null) {
            return false;
        }
        
        personalIDCode = personalIDCode.trim();
        if (personalIDCode.length() < 2) {
            return false;
        }
        
        if ("0123456789".indexOf(personalIDCode.substring(0,1)) >= 0) {
            return false;
        }
        if ("0123456789".indexOf(personalIDCode.substring(1,2)) >= 0) {
            return false;
        }
        
        return true;
    }
    
    public static int getCharacterCountInFile(String fileName) {
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
            logError(ex, "dvk.core.CommonMethods", "getCharacterCountInFile");
        } finally {
            safeCloseReader(reader);
            safeCloseReader(inReader);
            safeCloseStream(inStream);
            reader = null;
            inReader = null;
            inStream = null;
        }
        
        return result;
    }
    
    public static int compareVersions(String version1, String version2) {
        if ((version1 == null) || (version2 == null)) {
            return 0;
        }
        String[] v1Split = version1.split("[.]");
        String[] v2Split = version2.split("[.]");
        int result = 0;
        int minLength = Math.min(v1Split.length, v2Split.length);
        int v1Part = 0;
        int v2Part = 0;
        for (int i = 0; i < minLength; ++i) {
            v1Part = toIntSafe(v1Split[i], 0);
            v2Part = toIntSafe(v2Split[i], 0);
            if (v1Part > v2Part) {
                result = 1;
                break;
            } else if (v1Part < v2Part) {
                result = -1;
                break;
            }
        }
        if (result == 0) {
            if (v1Split.length > minLength) {
                result = 1;
            } else if (v2Split.length > minLength) {
                result = -1;
            }
        }
        return result;
    }
    
    /**
     * Saadab veakirjelduse e-mailiga administraatorile.
     * 
     * @param emailBody     Veakirjeldus
     */
    public static void sendEmail(String emailBody) {
        try {
            Properties mailServerConfig = new Properties();
            if ((Settings.currentProperties != null) && (Settings.currentProperties.getProperty("mail.host") != null) && (Settings.currentProperties.getProperty("mail.host").length() > 0)) {
                mailServerConfig.setProperty("mail.host", Settings.currentProperties.getProperty("mail.host"));
                String emailTo = Settings.currentProperties.getProperty("mail.to");
                
                InternetAddress fromAddress = new InternetAddress(Settings.currentProperties.getProperty("mail.from"));
                fromAddress.setPersonal("DVK klient");
                
                Session session = Session.getDefaultInstance( mailServerConfig, null );
                MimeMessage message = new MimeMessage( session );
    
                message.addRecipient( Message.RecipientType.TO, new InternetAddress(emailTo) );
                message.addFrom( new InternetAddress[]{fromAddress} );
                message.setSubject( "DVK client error!" );
                message.setText( emailBody );
                Transport.send( message );
            }
        } catch( Exception ex ){}
    }
    
    public static String TruncateString(String text, int len) {
        if ((text == null) || (text.length() < 1) || (len < 1)) {
            return "";
        }
        if (len >= text.length()) {
            return text;
        }
        return text.substring(0, len);
    }
    
    public static int getNumberFromChildNode(Element parentNode, String valueNodeName, int defaultValue) {
        int result = defaultValue;
        NodeList nodes = parentNode.getElementsByTagName(valueNodeName);
        if (nodes.getLength() > 0) {
            Node itemNode = nodes.item(0);
            String itemString = getNodeText(itemNode);
            result = toIntSafe(itemString, defaultValue);
        }
        return result;
    }
    
    public static boolean stringsEqualIgnoreNull(String s1, String s2) {
    	if (s1 == null) {
    		return ((s2 == null) || (s2.length() < 1));
    	} else if (s2 == null) {
    		return (s1.length() < 1);
    	} else {
    		return s1.trim().equalsIgnoreCase(s2.trim());
    	}
    }
    
    public static AttachmentExtractionResult getExtractedFileFromAttachment(org.apache.axis.MessageContext context, String attachmentReference) throws AxisFault {
        return getExtractedFileFromAttachmentPart((org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().getAttachmentsImpl().getAttachmentByReference(attachmentReference));
    }
    
    public static AttachmentExtractionResult getExtractedFileFromAttachment(org.apache.axis.Message response) throws AxisFault {
    	AttachmentExtractionResult result = new AttachmentExtractionResult();
    	Iterator attachments = response.getAttachments();
        if (attachments.hasNext()) {
        	result = getExtractedFileFromAttachmentPart((AttachmentPart)attachments.next());
        }
    	return result;
    }
    
    private static AttachmentExtractionResult getExtractedFileFromAttachmentPart(org.apache.axis.attachments.AttachmentPart attachmentPart) throws AxisFault {
    	AttachmentExtractionResult result = new AttachmentExtractionResult();
    	
    	// Leiame sõnumi kehas olnud viite alusels MIME lisast vajalikud andmed
        if (attachmentPart == null) {
            throw new AxisFault( CommonStructures.VIGA_PUUDUV_MIME_LISA );
        }
        DataSource attachmentSource = attachmentPart.getActivationDataHandler().getDataSource();
        if (attachmentSource == null) {
            throw new AxisFault( CommonStructures.VIGA_PUUDUV_MIME_LISA );
        }
        
        // Laeme SOAP attachmendis asunud andmed baidimassiivi
        String[] headers = attachmentPart.getMimeHeader("Content-Transfer-Encoding");
        String encoding;
        if((headers == null) || (headers.length < 1)) {
            encoding = "base64";
        }
        else {
            encoding = headers[0];
        }
        
        String pipelineDataFile = CommonMethods.createPipelineFile(0);
        result.setAttachmentHash(CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false));
        if (result.getAttachmentHash() == null) {
            throw new AxisFault( CommonStructures.VIGA_VIGANE_MIME_LISA );
        }
        
        // Pakime andmed GZIPiga lahti
        if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
            throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA);
        }
        
        result.setExtractedFileName(pipelineDataFile);
        
        return result;
    }
    
    /**
     * Eraldab X-Tee päringu kehast elemendi <heha>, mis  tuleb vastussõnumi
     * koosseisus hiljem päringu teostajale tagasi saata.
     * 
     * @param context			Axis sõnumi kontekst
     * @param requestName		X-Tee päringu nimi (näit. sendDocuments)
     * @return					SOAP sõnumi kehas asuv <keha> element.
     */
    public static Element getXRoadRequestBodyElement(org.apache.axis.MessageContext context, String requestName) {
        Element result = null;
        try {
            org.apache.axis.Message msg = context.getRequestMessage();
            SOAPBody b = msg.getSOAPBody();
            NodeList nodes = b.getElementsByTagName(requestName);
            if (nodes.getLength() > 0) {
                Element el = (Element)nodes.item(0);
                nodes = el.getElementsByTagName("keha");
                if (nodes.getLength() > 0) {
                    result = (Element)nodes.item(0);
                }
            }
        } catch (Exception ex) {
            result = null;
        }
        return result;
    }
}
