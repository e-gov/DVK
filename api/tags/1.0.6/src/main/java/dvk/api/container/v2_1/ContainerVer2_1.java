package dvk.api.container.v2_1;

import dvk.api.container.Container;
import dvk.api.ml.Util;
import org.apache.log4j.Logger;
import org.exolab.castor.mapping.MappingException;
import org.exolab.castor.xml.MarshalException;
import org.exolab.castor.xml.Marshaller;
import org.exolab.castor.xml.ValidationException;

import java.io.*;
import java.util.List;

/**
 * @author Hendrik Pärna
 * @since 27.01.14
 */
public class ContainerVer2_1 extends Container {
    private static Logger logger = Logger.getLogger(ContainerVer2_1.class);

    private Transport transport;
    private DecMetadata decMetadata;
    private Initiator initiator;
    private RecordCreator recordCreator;
    private RecordSenderToDec recordSenderToDec;
    private List<Recipient> recipient;
    private RecordMetadata recordMetadata;
    private Access access;
    private List<SignatureMetadata> signatureMetadata;
    private List<File> file;
    private String recordTypeSpecificMetadata;

    @Override
    public String getContent() throws MarshalException, ValidationException, IOException, MappingException {
        StringWriter sw = new StringWriter();

        try {
            Marshaller marshaller = createMarshaller(sw);
            marshaller.marshal(this);

            return sw.toString();
        } catch (RuntimeException e) {
            logger.error(e.getMessage());
            throw e;
        } finally {
            sw.close();
        }
    }

    @Override
    protected Version getInternalVersion() {
        return Version.Ver2_1;
    }

    /**
     * Parse 2.1 container from xml.
     *
     * @param xml String
     * @return 2.1 container object representation.
     * @throws MappingException
     * @throws MarshalException
     * @throws ValidationException
     * @throws IOException
     */
    public static ContainerVer2_1 parse(String xml)
            throws MappingException, MarshalException, ValidationException, IOException {
        if (Util.isEmpty(xml)) {
           return null;
        }

        StringReader in = new StringReader(xml);

        try {
            return (ContainerVer2_1) Container.marshal(in, Version.Ver2_1);

        } finally {
            in.close();
        }
    }

    /**
     * Parse 2.1 container from file.
     * @param fileName filename
     * @return
     * @throws MappingException
     * @throws MarshalException
     * @throws ValidationException
     * @throws IOException
     */
    public static ContainerVer2_1 parseFile(String fileName)
            throws MappingException, MarshalException, ValidationException, IOException {
        if (fileName == null || (fileName != null && fileName.trim().equals(""))) {
            logger.error("Cannot parse DVK container: empty filename.");
            throw new RuntimeException("Cannot parse DVK container: empty filename.");
        }

        ContainerVer2_1 result = null;
        FileReader fileReader = new FileReader(fileName);

        try {
            result = (ContainerVer2_1) Container.marshal(fileReader, Version.Ver2_1);
        } finally {
            fileReader.close();
        }

        return result;
    }

    public static ContainerVer2_1 parse(Reader reader)
            throws MappingException, MarshalException, ValidationException, IOException {
        if (reader == null) {
            logger.error("Cannot parse DVK Container: reader not initialized");
            throw new RuntimeException("Cannot parse DVK Container: reader not initialized");
        }

        return (ContainerVer2_1) Container.marshal(reader, Version.Ver2_1);
    }


    public Transport getTransport() {
        return transport;
    }

    public void setTransport(Transport transport) {
        this.transport = transport;
    }

    public DecMetadata getDecMetadata() {
        return decMetadata;
    }

    public void setDecMetadata(DecMetadata decMetadata) {
        this.decMetadata = decMetadata;
    }

    public Initiator getInitiator() {
        return initiator;
    }

    public void setInitiator(Initiator initiator) {
        this.initiator = initiator;
    }

    public RecordCreator getRecordCreator() {
        return recordCreator;
    }

    public void setRecordCreator(RecordCreator recordCreator) {
        this.recordCreator = recordCreator;
    }

    public RecordSenderToDec getRecordSenderToDec() {
        return recordSenderToDec;
    }

    public void setRecordSenderToDec(RecordSenderToDec recordSenderToDec) {
        this.recordSenderToDec = recordSenderToDec;
    }

    public List<Recipient> getRecipient() {
        return recipient;
    }

    public void setRecipient(List<Recipient> recipient) {
        this.recipient = recipient;
    }

    public RecordMetadata getRecordMetadata() {
        return recordMetadata;
    }

    public void setRecordMetadata(RecordMetadata recordMetadata) {
        this.recordMetadata = recordMetadata;
    }

    public Access getAccess() {
        return access;
    }

    public void setAccess(Access access) {
        this.access = access;
    }

    public List<SignatureMetadata> getSignatureMetadata() {
        return signatureMetadata;
    }

    public void setSignatureMetadata(List<SignatureMetadata> signatureMetadata) {
        this.signatureMetadata = signatureMetadata;
    }

    public List<File> getFile() {
        return file;
    }

    public String getRecordTypeSpecificMetadata() {
        return recordTypeSpecificMetadata;
    }

    public void setRecordTypeSpecificMetadata(String recordTypeSpecificMetadata) {
        this.recordTypeSpecificMetadata = recordTypeSpecificMetadata;
    }

    public void setFile(List<File> file) {
        this.file = file;
    }
}
