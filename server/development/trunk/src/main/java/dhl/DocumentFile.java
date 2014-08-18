package dhl;

import dhl.exceptions.ComponentException;
import dhl.exceptions.IncorrectSignatureException;
import dvk.core.CommonMethods;
import dvk.core.Settings;
import ee.sk.digidoc.DataFile;
import ee.sk.digidoc.DigiDocException;
import ee.sk.digidoc.SignedDoc;
import ee.sk.digidoc.factory.DigiDocFactory;
import ee.sk.utils.ConfigManager;
import org.apache.axis.AxisFault;
import org.apache.axis.encoding.Base64;
import org.apache.log4j.Logger;

import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;

/**
 * Dokumendi fail. Vastab andmebaasi tabelile DOKUMENDI_FAIL
 *
 * @author Jaak Lember
 */
public class DocumentFile {
    static Logger logger = Logger.getLogger(DocumentFile.class.getName());

    private int m_id;
    private int m_documentId;
    private String m_fileName;
    private int m_fileSizeBytes;
    private String m_mimeType;
    private boolean m_isMainFile;
    private boolean m_isAttachment;
    private String m_localFileFullName;

    public DocumentFile() {
        clear();
    }

    public int getId() {
        return this.m_id;
    }

    public void setId(int value) {
        this.m_id = value;
    }

    public int getDocumentId() {
        return this.m_documentId;
    }

    public void setDocumentId(int value) {
        this.m_documentId = value;
    }

    public String getFileName() {
        return this.m_fileName;
    }

    public void setFileName(String value) {
        this.m_fileName = value;
    }

    public int getFileSizeBytes() {
        return this.m_fileSizeBytes;
    }

    public void setFileSizeBytes(int value) {
        this.m_fileSizeBytes = value;
    }

    public String getMimeType() {
        return this.m_mimeType;
    }

    public void setMimeType(String value) {
        this.m_mimeType = value;
    }

    public boolean getIsMainFile() {
        return this.m_isMainFile;
    }

    public void setIsMainFile(boolean value) {
        this.m_isMainFile = value;
    }

    public boolean getIsAttachment() {
        return this.m_isAttachment;
    }

    public void setIsAttachment(boolean value) {
        this.m_isAttachment = value;
    }

    public String getLocalFileFullName() {
        return this.m_localFileFullName;
    }

    public void setLocalFileFullName(String value) {
        this.m_localFileFullName = value;
    }

    public void clear() {
        this.m_id = 0;
        this.m_documentId = 0;
        this.m_fileName = "";
        this.m_fileSizeBytes = 0;
        this.m_mimeType = "";
        this.m_isMainFile = false;
        this.m_isAttachment = false;
        this.m_localFileFullName = "";
    }

    public static ArrayList<DocumentFile> getListFromContainerV1(
            XMLStreamReader xmlReader, ArrayList<String> extensionFilter) throws IOException, XMLStreamException {
        ArrayList<DocumentFile> result = new ArrayList<DocumentFile>();
        int itemIndex = 1;

        while (xmlReader.hasNext()) {
            xmlReader.next();

            if (xmlReader.hasName()) {
                if (xmlReader.getLocalName().equalsIgnoreCase("signeddoc") && xmlReader.isEndElement()) {
                    // Kui oleme jõudnud faili ploki lõppu, siis katkestame tsükli
                    break;
                } else if (xmlReader.getLocalName().equalsIgnoreCase("datafile") && xmlReader.isStartElement()) {
                    DocumentFile item = new DocumentFile();

                    item.m_fileName = xmlReader.getAttributeValue(null, "Filename");

                    boolean skipFile = true;
                    if ((extensionFilter != null) && (extensionFilter.size() > 0)) {
                        for (int i = 0; i < extensionFilter.size(); i++) {
                            String ext = extensionFilter.get(i).toLowerCase();
                            if (item.m_fileName.toLowerCase().endsWith(ext)) {
                                skipFile = false;
                                break;
                            }
                        }
                    } else {
                        skipFile = false;
                    }

                    if (!skipFile) {
                        item.m_mimeType = xmlReader.getAttributeValue(null, "MimeType");
                        item.m_fileSizeBytes = Integer.parseInt(xmlReader.getAttributeValue(null, "Size"));
                        item.m_localFileFullName = CommonMethods.createPipelineFile(itemIndex);
                        FileOutputStream outStream = new FileOutputStream(item.m_localFileFullName, false);

                        try {
                            xmlReader.next();
                            if (xmlReader.isCharacters()) {
                                String fourByteString = "";
                                char[] buf = new char[1];
                                int sourceStart = 0;
                                while (xmlReader.getTextCharacters(sourceStart, buf, 0, buf.length) > 0) {
                                    if (((buf[0] >= 48) && (buf[0] <= 57))
                                            || ((buf[0] >= 65) && (buf[0] <= 90))
                                            || ((buf[0] >= 97) && (buf[0] <= 122))
                                            || (buf[0] == 43) || (buf[0] == 47) || (buf[0] == 61)) {
                                        fourByteString += buf[0];
                                    }
                                    if (fourByteString.length() == 4) {
                                        outStream.write(Base64.decode(fourByteString));
                                        fourByteString = "";
                                    }
                                    sourceStart++;
                                }
                                if (fourByteString.length() > 0) {
                                    outStream.write(Base64.decode(fourByteString));
                                }
                            }
                        } finally {
                            CommonMethods.safeCloseStream(outStream);
                            outStream = null;
                            itemIndex++;
                        }

                        result.add(item);
                    }
                }
            }
        }

        return result;
    }

    public static ArrayList<DocumentFile> getListFromContainerV2(
            XMLStreamReader xmlReader, ArrayList<String> extensionFilter) throws IOException, XMLStreamException {
        ArrayList<DocumentFile> result = new ArrayList<DocumentFile>();
        DocumentFile item = null;
        int itemIndex = 1;

        while (xmlReader.hasNext()) {
            xmlReader.next();

            if (xmlReader.hasName()) {
                if (xmlReader.getLocalName().equalsIgnoreCase("failid") && xmlReader.isEndElement()) {
                    // Kui oleme jõudnud failide ploki lõppu, siis katkestame tsükli
                    break;
                } else if (xmlReader.getLocalName().equalsIgnoreCase("fail") && xmlReader.isEndElement()) {
                    // Kui jõuame faili lõpuelemendi juurde, siis lisame andmetega täidetud faili
                    // objekti failide nimekirja.
                    if (item != null) {
                        boolean skipFile = true;
                        if ((extensionFilter != null) && (extensionFilter.size() > 0)) {
                            for (int i = 0; i < extensionFilter.size(); i++) {
                                String ext = extensionFilter.get(i).toLowerCase();
                                if (item.m_fileName.toLowerCase().endsWith(ext)) {
                                    skipFile = false;
                                    break;
                                }
                            }
                        } else {
                            skipFile = false;
                        }

                        if (!skipFile) {
                            result.add(item);
                        }
                    }
                } else if (xmlReader.getLocalName().equalsIgnoreCase("fail") && xmlReader.isStartElement()) {
                    item = new DocumentFile();
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("fail_nimi") && xmlReader.isStartElement()) {
                    xmlReader.next();
                    if (xmlReader.isCharacters()) {
                        item.m_fileName = xmlReader.getText().trim();
                    }
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("fail_tyyp") && xmlReader.isStartElement()) {
                    xmlReader.next();
                    if (xmlReader.isCharacters()) {
                        item.m_mimeType = xmlReader.getText().trim();
                    }
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("fail_suurus") && xmlReader.isStartElement()) {
                    xmlReader.next();
                    if (xmlReader.isCharacters()) {
                        try {
                            item.m_fileSizeBytes = Integer.parseInt(xmlReader.getText().trim());
                        } catch (Exception ex) {
                            logger.warn("Unable to parse value of \"fail_suurus\" to integer. Defaulting to 0.");
                            item.m_fileSizeBytes = 0;
                        }
                    }
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("zip_base64_sisu") && xmlReader.isStartElement()) {
                    item.m_localFileFullName = CommonMethods.createPipelineFile(itemIndex);
                    FileOutputStream outStream = new FileOutputStream(item.m_localFileFullName, false);

                    try {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String fourByteString = "";
                            char[] buf = new char[1];
                            int sourceStart = 0;
                            while (xmlReader.getTextCharacters(sourceStart, buf, 0, buf.length) > 0) {
                                if (((buf[0] >= 48) && (buf[0] <= 57))
                                        || ((buf[0] >= 65) && (buf[0] <= 90))
                                        || ((buf[0] >= 97) && (buf[0] <= 122))
                                        || (buf[0] == 43) || (buf[0] == 47) || (buf[0] == 61)) {
                                    fourByteString += buf[0];
                                }
                                if (fourByteString.length() == 4) {
                                    outStream.write(Base64.decode(fourByteString));
                                    fourByteString = "";
                                }
                                sourceStart++;
                            }
                            if (fourByteString.length() > 0) {
                                outStream.write(Base64.decode(fourByteString));
                            }
                        }
                    } finally {
                        CommonMethods.safeCloseStream(outStream);
                        outStream = null;
                        itemIndex++;
                    }

                    // Pakime faili lahti
                    if (!CommonMethods.gzipUnpackXML(item.m_localFileFullName, false)) {
                        throw new AxisFault("File data extraction failed!");
                    }
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("pohi_dokument") && xmlReader.isStartElement()) {
                    xmlReader.next();
                    if (xmlReader.isCharacters()) {
                        item.m_isMainFile = CommonMethods.booleanFromXML(xmlReader.getText().trim());
                    }
                }

            }
        }

        return result;
    }

    private void initJdigiDoc() {
        String jdigidocConfigPath = Settings.serverJdigidocConfigLocation;
        logger.debug("jdigidocConfigPath: " + jdigidocConfigPath);
        ConfigManager.init(jdigidocConfigPath);
    }

    public ArrayList<String> getFilesFromDdocBdoc(String extensionFilter) throws Exception {
        logger.debug("getFilesFromDdocBdoc");
        ArrayList<String> result = new ArrayList<String>();
        logger.debug("this.m_fileName: " + this.m_fileName);
        if (this.m_fileName.toLowerCase().endsWith("ddoc") || this.m_fileName.toLowerCase().endsWith("bdoc")) {
            logger.debug("this file is a ddoc or bdoc");
            initJdigiDoc();
            DigiDocFactory ddocFactory = ConfigManager.instance().getDigiDocFactory();

            logger.debug("localFileFullname: " + this.m_localFileFullName);
            SignedDoc container = ddocFactory.readSignedDoc(this.m_localFileFullName);
            int dataFileCount = container.countDataFiles();
            for (int i = 0; i < dataFileCount; i++) {
                DataFile df = container.getDataFile(i);
                String dataFileName = df.getFileName();

                if ((extensionFilter == null)
                        || (extensionFilter.length() < 1)
                        || (dataFileName.toLowerCase().endsWith(extensionFilter.toLowerCase()))) {
                    String extension = dataFileName.substring(dataFileName.lastIndexOf("."));
                    String fileName = CommonMethods.createPipelineFile(i, extension);

                    InputStream in = null;
                    OutputStream out = null;
                    int val = 0;
                    try {
                        out = new FileOutputStream(fileName);
                        in = df.getBodyAsStream();

                        // TODO: test - remove it
                        logger.debug("Before IF in getFilesFromDdocBdoc method");

                        if ((in != null) && (out != null)) {
                            // Siin ei tasu puhverdamist üritada, kuna JDigiDoc teek ei toeta seda.
                            while ((val = in.read()) >= 0) {
                                out.write((byte) val);
                            }
                            result.add(fileName);
                            // TODO: test - remove it
                            logger.debug("inside IF in getFilesFromDdocBdoc method");

                        }
                        // TODO: test - remove it
                        logger.debug("End of try in getFilesFromDdocBdoc method");
                    } finally {
                        CommonMethods.safeCloseStream(in);
                        CommonMethods.safeCloseStream(out);
                        in = null;
                        out = null;
                        // TODO: test - remove it
                        logger.debug("End of finally  in getFilesFromDdocBdoc method");
                    }
                }
            }
        }

        // TODO: test - remove it
        logger.debug("End of getFilesFromDdocBdoc method");

        return result;
    }

    public ArrayList<String> validateFileSignatures() throws ComponentException, IncorrectSignatureException {
        ArrayList<String> result = new ArrayList<String>();

        if (this.m_fileName.toLowerCase().endsWith("ddoc") || this.m_fileName.toLowerCase().endsWith("bdoc")) {
            logger.info("Validating signatures of file " + this.m_fileName + " (" + this.m_localFileFullName + ").");
            initJdigiDoc();
            DigiDocFactory ddocFactory = null;
            try {
                ddocFactory = ConfigManager.instance().getDigiDocFactory();
            } catch (DigiDocException ex) {
                throw new ComponentException("DigiDoc teegi initsialiseerimine ebaõnnestus!", ex);
            }

            SignedDoc container = null;
            try {
                container = ddocFactory.readSignedDoc(this.m_localFileFullName);
            } catch (DigiDocException ex) {
                throw new ComponentException("DigiDoc faili avamine ebaõnnestus!", ex);
            }

            if (container.countSignatures() > 0) {
                ArrayList errs = container.verify(true, true);
                if (errs.size() >= 0) {
                    for (int j = 0; j < errs.size(); j++) {
                        result.add("Dokumendi \""
                                + this.m_fileName + "\" allkirjade kontrollimisel tuvastati viga: "
                                + ((DigiDocException) errs.get(j)).getLocalizedMessage());
                        logger.info(
                                "Error found in signature container " + this.m_fileName
                                        + " (" + this.m_localFileFullName + "): "
                                        + ((DigiDocException) errs.get(j)).getLocalizedMessage());
                    }
                }
            } else {
                logger.info("Signature container \"" + this.m_fileName
                        + "\" (" + this.m_localFileFullName + ") does not contain any signatures to validate.");
            }
        } else {
            logger.warn("Signatures of file " + this.m_fileName + " (" + this.m_localFileFullName
                    + ") cannot be validated because this file is not a signature container!");
        }

        return result;
    }

    /**
     * Parse DocumentFile from container.
     * @param xmlReader reader
     * @param extensionFilter filter
     * @return DocumentFile
     * @throws IOException
     * @throws XMLStreamException
     */
    public static DocumentFile getListFromContainerV2_1(XMLStreamReader xmlReader, ArrayList<String> extensionFilter) throws IOException, XMLStreamException {
        DocumentFile item = null;
        int itemIndex = 1;

        while (xmlReader.hasNext()) {
            if (xmlReader.hasName()) {
                if (xmlReader.getLocalName().equalsIgnoreCase("File") && xmlReader.isEndElement()) {
                    // Kui oleme jõudnud failide ploki lõppu, siis katkestame tsükli
                    break;
                } else if (xmlReader.getLocalName().equalsIgnoreCase("File") && xmlReader.isStartElement()) {
                    item = new DocumentFile();
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("FileName") && xmlReader.isStartElement()) {
                    xmlReader.next();
                    if (xmlReader.isCharacters()) {
                        item.m_fileName = xmlReader.getText().trim();
                    }
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("MimeType") && xmlReader.isStartElement()) {
                    xmlReader.next();
                    if (xmlReader.isCharacters()) {
                        item.m_mimeType = xmlReader.getText().trim();
                    }
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("FileSize") && xmlReader.isStartElement()) {
                    xmlReader.next();
                    if (xmlReader.isCharacters()) {
                        try {
                            item.m_fileSizeBytes = Integer.parseInt(xmlReader.getText().trim());
                        } catch (Exception ex) {
                            logger.warn("Unable to parse value of \"filesize\" to integer. Defaulting to 0.");
                            item.m_fileSizeBytes = 0;
                        }
                    }
                } else if ((item != null) && xmlReader.getLocalName().equalsIgnoreCase("ZipBase64Content") && xmlReader.isStartElement()) {
                    item.m_localFileFullName = CommonMethods.createPipelineFile(itemIndex);
                    FileOutputStream outStream = new FileOutputStream(item.m_localFileFullName, false);

                    try {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String fourByteString = "";
                            char[] buf = new char[1];
                            int sourceStart = 0;
                            while (xmlReader.getTextCharacters(sourceStart, buf, 0, buf.length) > 0) {
                                if (((buf[0] >= 48) && (buf[0] <= 57))
                                        || ((buf[0] >= 65) && (buf[0] <= 90))
                                        || ((buf[0] >= 97) && (buf[0] <= 122))
                                        || (buf[0] == 43) || (buf[0] == 47) || (buf[0] == 61)) {
                                    fourByteString += buf[0];
                                }
                                if (fourByteString.length() == 4) {
                                    outStream.write(Base64.decode(fourByteString));
                                    fourByteString = "";
                                }
                                sourceStart++;
                            }
                            if (fourByteString.length() > 0) {
                                outStream.write(Base64.decode(fourByteString));
                            }
                        }
                    } finally {
                        CommonMethods.safeCloseStream(outStream);
                        outStream = null;
                        itemIndex++;
                    }

                    // Pakime faili lahti
                    if (!CommonMethods.gzipUnpackXML(item.m_localFileFullName, false)) {
                        throw new AxisFault("File data extraction failed!");
                    }
                }
            }
            xmlReader.next();
        }

        return item;
    }
}
