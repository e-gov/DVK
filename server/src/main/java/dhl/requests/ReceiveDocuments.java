package dhl.requests;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;

import dhl.Conversion;
import dhl.DocumentFragment;
import dhl.Folder;
import dhl.Recipient;
import dhl.Sending;
import dhl.iostructures.FragmentationResult;
import dhl.iostructures.receiveDocumentsRequestType;
import dhl.iostructures.receiveDocumentsV2RequestType;
import dhl.iostructures.receiveDocumentsV3RequestType;
import dhl.iostructures.receiveDocumentsV4RequestType;
import dhl.sys.Timer;
import dhl.users.Asutus;
import dhl.users.UserProfile;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.ContainerVersion;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolVersion;

public class ReceiveDocuments {

    private static Logger logger = Logger.getLogger(ReceiveDocuments.class);

    public static RequestInternalResult V1(org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws Exception {
        logger.info("ReceiveDocuments.V1 invoked.");

        Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Laeme SOAP keha endale sobivasse andmestruktuuri
            t.reset();
            receiveDocumentsRequestType bodyData = receiveDocumentsRequestType.getFromSOAPBody(context);
            result.count = bodyData.arv;
            result.folders = bodyData.kaust;
            t.markElapsed("Parsing SOAP body");

            // Check if all requested folders really exist
            validateFolders(bodyData.kaust, user, conn);

            t.reset();
            ArrayList<dhl.Document> documents = new ArrayList<dhl.Document>();
            if ((bodyData.kaust == null) || (bodyData.kaust.size() == 0)) {
                // Leiame antud kasutajale saadetud dokumendid
                documents = dhl.Document.getDocumentsSentTo(
                        user.getOrganizationID(), Folder.UNSPECIFIED_FOLDER,
                        user.getPersonID(), 0, "", 0, "", bodyData.arv, conn);
            } else {
                int resultLimit = bodyData.arv;
                for (int folderNr = 0; folderNr < bodyData.kaust.size(); ++folderNr) {
                    // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
                    XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                            user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);
                    int requestTargetFolder = Folder.getFolderIdByPath(
                            bodyData.kaust.get(folderNr).trim(), user.getOrganizationID(), conn, true, false, xTeePais);

                    // Leiame antud kasutajale saadetud dokumendid
                    ArrayList<dhl.Document> tmpDocs = dhl.Document.getDocumentsSentTo(
                            user.getOrganizationID(), requestTargetFolder,
                            user.getPersonID(), 0, "", 0, "", resultLimit, conn);
                    resultLimit -= tmpDocs.size();

                    // Lisame leitud dokumendid dokumentide täisnimekirja
                    documents.addAll(tmpDocs);
                    tmpDocs = null;

                    // Kui maksimaalne lubatud vastuste hulk on käes, siis
                    // rohkem dokumente andmebaasist välja ei võta
                    if (resultLimit <= 0) {
                        break;
                    }
                }
            }
            t.markElapsed("Reading documents from DB");

            // Pistame leitud dokumendid väljundisse
            t.reset();
            try {
                FileOutputStream out = null;
                OutputStreamWriter ow = null;
                BufferedWriter bw = null;
                try {
                    out = new FileOutputStream(pipelineDataFile, false);
                    ow = new OutputStreamWriter(out, "UTF-8");
                    bw = new BufferedWriter(ow);

                    if (documents != null) {
                        ArrayList<Integer> processedDocuments = new ArrayList<Integer>();
                        for (int i = 0; i < documents.size(); ++i) {
                            dhl.Document tmpDoc = documents.get(i);

                            if (tmpDoc != null) {
                                if (!processedDocuments.contains(tmpDoc.getId()) && (tmpDoc.getFilePath() != null)) {
                                    // Laeme konkreetse dokumendi saatmist puudutavad andmed
                                    Sending tmpSending = new Sending();
                                    tmpSending.loadByDocumentID(tmpDoc.getId(), conn);

                                    Recipient tmpRecipient = null;
                                    ArrayList<Recipient> tmpRecipients = tmpSending.getRecipients();

                                    Recipient recipientBuffer = null;
                                    for (int j = 0; j < tmpRecipients.size(); ++j) {
                                        recipientBuffer = tmpRecipients.get(j);
                                        if (recipientBuffer.getOrganizationID() == user.getOrganizationID()) {
                                            tmpRecipient = recipientBuffer;
                                            break;
                                        }
                                    }

                                    if ((tmpRecipient != null) && (tmpSending.getSender() != null)) {
                                        Asutus senderOrg = new Asutus(tmpSending.getSender().getOrganizationID(), conn);
                                        Asutus recipientOrg = new Asutus(tmpRecipient.getOrganizationID(), conn);

                                        if (isContainerConversionNeeded(
                                                recipientOrg.getKapselVersioon(), tmpDoc.getContainerVersion())) {
                                            tmpDoc.setFilePath(convertContainer(conn, tmpDoc, 21, 1).getOutputFile());
                                        }

                                        // Viskame XML failist välja suure mahuga SignedDoc elemendid
                                        CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);

                                        // Täidame DHL poolt automaatselt täidetavad väljad
                                        appendAutomaticMetaData(
                                                tmpDoc.getFilePath(),
                                                tmpSending,
                                                tmpRecipient,
                                                tmpDoc,
                                                senderOrg,
                                                recipientOrg,
                                                conn,
                                                tmpDoc.getDvkContainerVersion(),
                                                tmpDoc.getContainerVersion());

                                        // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
                                        // faili koosseisu tagasi.
                                        CommonMethods.joinSplitXML(tmpDoc.getFilePath(), bw);

                                        processedDocuments.add(tmpDoc.getId());
                                    }
                                }
                            }
                        }
                    }
                } catch (AxisFault fault) {
                    throw fault;
                } catch (Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    throw new AxisFault("Error composing response message: "
                            + " (" + ex.getClass().getName() + ": " + ex.getMessage() + ")");
                } finally {
                    CommonMethods.safeCloseWriter(bw);
                    CommonMethods.safeCloseWriter(ow);
                    CommonMethods.safeCloseStream(out);
                    bw = null;
                    ow = null;
                    out = null;
                }
            } catch (AxisFault fault) {
                throw fault;
            } catch (Exception ex) {
                logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            }
            t.markElapsed("Processing documents and creating answer");

            t.reset();
            result.responseFile = CommonMethods.gzipPackXML(pipelineDataFile, user.getOrganizationCode(), "receiveDocuments");
            t.markElapsed("Compressing response data");
        } finally {
            (new File(pipelineDataFile)).delete();
        }

        return result;
    }

    public static Conversion convertContainer(Connection conn, dhl.Document document, Integer fromVersion, Integer toVersion) throws Exception {
        // Convert to DVK container version 1
        Conversion conversion = new Conversion();
        conversion.setInputFile(document.getFilePath());
        conversion.setOutputFile(document.getFilePath() + ".tmp");
        //TODO: this must be refactored,
        // the database field should map a string not an integer
        conversion.setVersion(fromVersion);
        conversion.setTargetVersion(toVersion);

        // Get the XSLT from database
        conversion.getConversionFromDB(conn);

        conversion.convert();
        return conversion;
    }

    /**
     * Decide if the document needs to be converted from 2.1 to 1.0
     * @param recipientSupportedContainerVersion {@link ContainerVersion}
     * @param documentContainerVersion if null it represents ContainerVersion.VERSION_1_0, if present then {@link ContainerVersion}
     * @return true if the conversion is needed othewise false.
     */
    public static boolean isContainerConversionNeeded(String recipientSupportedContainerVersion, String documentContainerVersion) {
        boolean result = false;
        if (documentContainerVersion != null
                && documentContainerVersion.equals(ContainerVersion.VERSION_2_1.toString())
                && ContainerVersion.VERSION_1_0.toString().equals(recipientSupportedContainerVersion)) {
            result = true;
        }
        return result;
    }

    public static RequestInternalResult V2(
            org.apache.axis.MessageContext context, Connection conn, UserProfile user, XRoadProtocolHeader xRoadProtocolHeader) throws Exception {
        logger.info("ReceiveDocuments.V2 invoked.");

        Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Laeme SOAP keha endale sobivasse andmestruktuuri
            t.reset();
            receiveDocumentsV2RequestType bodyData = receiveDocumentsV2RequestType.getFromSOAPBody(context, xRoadProtocolHeader);
            result.count = bodyData.arv;
            result.folders = bodyData.kaust;
            result.deliverySessionID = bodyData.edastusID;
            result.fragmentSizeBytes = bodyData.fragmentSizeBytesOrig;
            t.markElapsed("Parsing SOAP body");
            
            // Check if all requested folders really exist
            validateFolders(bodyData.kaust, user, conn);

            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr > 0)) {
                DocumentFragment fragment = new DocumentFragment(
                        user.getOrganizationID(), bodyData.edastusID, bodyData.fragmentNr, conn);
                result.responseFile = fragment.getFileName();
                result.fragmentNr = fragment.getFragmentNr();
                result.totalFragments = fragment.getFragmentCount();
            } else {
                t.reset();
                ArrayList<dhl.Document> documents = new ArrayList<dhl.Document>();
                if ((bodyData.kaust == null) || (bodyData.kaust.size() == 0)) {
                    // Leiame antud kasutajale saadetud dokumendid
                    documents = dhl.Document.getDocumentsSentTo(
                            user.getOrganizationID(), Folder.UNSPECIFIED_FOLDER,
                            user.getPersonID(), 0, "", 0, "", bodyData.arv, conn);
                } else {
                    int resultLimit = bodyData.arv;
                    for (int folderNr = 0; folderNr < bodyData.kaust.size(); ++folderNr) {
                        // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
                        XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);
                        int requestTargetFolder = Folder.getFolderIdByPath(
                                bodyData.kaust.get(folderNr).trim(),
                                user.getOrganizationID(), conn, true, false, xTeePais);

                        // Leiame antud kasutajale saadetud dokumendid
                        ArrayList<dhl.Document> tmpDocs = dhl.Document.getDocumentsSentTo(
                                user.getOrganizationID(), requestTargetFolder,
                                user.getPersonID(), 0, "", 0, "", resultLimit, conn);
                        resultLimit -= tmpDocs.size();

                        // Lisame leitud dokumendid dokumentide täisnimekirja
                        documents.addAll(tmpDocs);
                        tmpDocs = null;

                        // Kui maksimaalne lubatud vastuste hulk on käes, siis
                        // rohkem dokumente andmebaasist välja ei võta
                        if (resultLimit <= 0) {
                            break;
                        }
                    }
                }
                t.markElapsed("Reading documents from DB");

                // Pistame leitud dokumendid väljundisse
                t.reset();
                try {
                    FileOutputStream out = null;
                    OutputStreamWriter ow = null;
                    BufferedWriter bw = null;
                    try {
                        out = new FileOutputStream(pipelineDataFile, false);
                        ow = new OutputStreamWriter(out, "UTF-8");
                        bw = new BufferedWriter(ow);

                        if (documents != null) {
                            ArrayList<Integer> processedDocuments = new ArrayList<Integer>();
                            for (int i = 0; i < documents.size(); ++i) {
                                dhl.Document tmpDoc = documents.get(i);
                                
                                if (tmpDoc != null) {
                                    if (!processedDocuments.contains(tmpDoc.getId()) && (tmpDoc.getFilePath() != null)) {
                                        // Laeme konkreetse dokumendi saatmist puudutavad andmed
                                        Sending tmpSending = new Sending();
                                        tmpSending.loadByDocumentID(tmpDoc.getId(), conn);
                                        
                                        Recipient tmpRecipient = null;
                                        ArrayList<Recipient> tmpRecipients = tmpSending.getRecipients();

                                        Recipient recipientBuffer = null;
                                        for (int j = 0; j < tmpRecipients.size(); ++j) {
                                            recipientBuffer = tmpRecipients.get(j);
                                            if (recipientBuffer.getOrganizationID() == user.getOrganizationID()) {
                                                tmpRecipient = recipientBuffer;
                                                break;
                                            }
                                        }

                                        if ((tmpRecipient != null) && (tmpSending.getSender() != null)) {                                            
                                        	Asutus senderOrg = new Asutus(tmpSending.getSender().getOrganizationID(), conn);
                                            Asutus recipientOrg = new Asutus(tmpRecipient.getOrganizationID(), conn);
                                            
                                            if (isContainerConversionNeeded(
                                                    recipientOrg.getKapselVersioon(), tmpDoc.getContainerVersion())) {
                                                tmpDoc.setFilePath(convertContainer(conn, tmpDoc, 21, 1).getOutputFile());
                                            }

                                            // Viskame XML failist välja suure mahuga SignedDoc elemendid
                                            CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);

                                            // Täidame DHL poolt automaatselt täidetavad väljad
                                            appendAutomaticMetaData(
                                                    tmpDoc.getFilePath(),
                                                    tmpSending,
                                                    tmpRecipient,
                                                    tmpDoc,
                                                    senderOrg,
                                                    recipientOrg,
                                                    conn,
                                                    tmpDoc.getDvkContainerVersion(),
                                                    tmpDoc.getContainerVersion());

                                            // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
                                            // faili koosseisu tagasi.
                                            CommonMethods.joinSplitXML(tmpDoc.getFilePath(), bw);

                                            processedDocuments.add(tmpDoc.getId());
                                        }
                                    }
                                }
                            }
                        }
                    } catch (AxisFault fault) {
                        throw fault;
                    } catch (Exception ex) {
                        logger.error(ex.getMessage(), ex);
                        throw new AxisFault("Error composing response message: "
                                + " (" + ex.getClass().getName() + ": " + ex.getMessage() + ")");
                    } finally {
                        CommonMethods.safeCloseWriter(bw);
                        CommonMethods.safeCloseWriter(ow);
                        CommonMethods.safeCloseStream(out);
                        bw = null;
                        ow = null;
                        out = null;
                    }
                } catch (AxisFault fault) {
                    throw fault;
                } catch (Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    throw new AxisFault(ex.getMessage());
                }
                t.markElapsed("Processing documents and creating answer");

                t.reset();
                result.responseFile = CommonMethods.gzipPackXML(
                        pipelineDataFile, user.getOrganizationCode(), "receiveDocuments");
                t.markElapsed("Compressing response data");

                // Kui soovitakse vastust fragmenteeritud kujul, siis lammutame faili
                // tükkideks ja salvestame tükid saatmist ootama.
                if ((bodyData.edastusID != null)
                        && !bodyData.edastusID.equalsIgnoreCase("")
                        && (bodyData.fragmentNr >= 0)) {
                    XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                            user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);

                    FragmentationResult fragResult = DocumentFragment.getFragments(
                            result.responseFile, bodyData.fragmentSizeBytes,
                            user.getOrganizationID(), bodyData.edastusID, false, conn, xTeePais);

                    if ((fragResult != null)
                            && (fragResult.firstFragmentFile != null)
                            && (new File(fragResult.firstFragmentFile)).exists()) {
                        result.responseFile = fragResult.firstFragmentFile;
                        result.fragmentNr = 0;
                        result.totalFragments = fragResult.totalFragments;
                    }
                }
            }
        } finally {
            (new File(pipelineDataFile)).delete();
        }

        return result;
    }

    public static RequestInternalResult V3(
            org.apache.axis.MessageContext context, Connection conn, UserProfile user, XRoadProtocolHeader xRoadProtocolHeader) throws Exception {
        logger.info("ReceiveDocuments.V3 invoked.");

        Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Laeme SOAP keha endale sobivasse andmestruktuuri
            t.reset();
            receiveDocumentsV3RequestType bodyData = receiveDocumentsV3RequestType.getFromSOAPBody(context, xRoadProtocolHeader);
            result.count = bodyData.arv;
            result.folders = bodyData.kaust;
            result.deliverySessionID = bodyData.edastusID;
            result.fragmentSizeBytes = bodyData.fragmentSizeBytesOrig;
            t.markElapsed("Parsing SOAP body");

            // Check if all requested folders really exist
            validateFolders(bodyData.kaust, user, conn);

            logger.debug("Starting receiveDocuments.V3 Request. Org: "
                    + user.getOrganizationCode() + ", Personal ID: " + user.getPersonCode());

            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr > 0)) {
                DocumentFragment fragment = new DocumentFragment(
                        user.getOrganizationID(), bodyData.edastusID, bodyData.fragmentNr, conn);
                result.responseFile = fragment.getFileName();
                result.fragmentNr = fragment.getFragmentNr();
                result.totalFragments = fragment.getFragmentCount();
            } else {
                t.reset();
                ArrayList<dhl.Document> documents = new ArrayList<dhl.Document>();
                if ((bodyData.kaust == null) || (bodyData.kaust.size() == 0)) {
                    // Leiame antud kasutajale saadetud dokumendid
                    logger.debug("Searching documents using following parameters: Org ID:  "
                            + String.valueOf(user.getOrganizationID()) + ", Folder:  "
                            + String.valueOf(Folder.UNSPECIFIED_FOLDER) + ", Person ID: "
                            + String.valueOf(user.getPersonID()) + ", Subdivision ID: "
                            + String.valueOf(bodyData.allyksus) + ", Occupation ID: "
                            + String.valueOf(bodyData.ametikoht) + ", Max documents: "
                            + String.valueOf(bodyData.arv));
                    documents = dhl.Document.getDocumentsSentTo(
                            user.getOrganizationID(),
                            Folder.UNSPECIFIED_FOLDER,
                            user.getPersonID(),
                            bodyData.allyksus,
                            "",
                            bodyData.ametikoht,
                            "",
                            bodyData.arv,
                            conn);
                } else {
                    int resultLimit = bodyData.arv;
                    for (int folderNr = 0; folderNr < bodyData.kaust.size(); ++folderNr) {
                        // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
                        XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);
                        int requestTargetFolder = Folder.getFolderIdByPath(
                                bodyData.kaust.get(folderNr).trim(), user.getOrganizationID(), conn, true, false, xTeePais);

                        // Leiame antud kasutajale saadetud dokumendid
                        logger.debug("Searching documents using following parameters: Org ID:  "
                                + String.valueOf(user.getOrganizationID()) + ", Folder:  "
                                + String.valueOf(requestTargetFolder) + ", Person ID: "
                                + String.valueOf(user.getPersonID()) + ", Subdivision ID: "
                                + String.valueOf(bodyData.allyksus) + ", Occupation ID: "
                                + String.valueOf(bodyData.ametikoht) + ", Max documents: "
                                + String.valueOf(resultLimit));
                        ArrayList<dhl.Document> tmpDocs = dhl.Document.getDocumentsSentTo(
                                user.getOrganizationID(),
                                requestTargetFolder,
                                user.getPersonID(),
                                bodyData.allyksus,
                                "",
                                bodyData.ametikoht,
                                "",
                                resultLimit,
                                conn);
                        resultLimit -= tmpDocs.size();

                        // Lisame leitud dokumendid dokumentide täisnimekirja
                        documents.addAll(tmpDocs);
                        tmpDocs = null;

                        // Kui maksimaalne lubatud vastuste hulk on käes, siis
                        // rohkem dokumente andmebaasist välja ei võta
                        if (resultLimit <= 0) {
                            break;
                        }
                    }
                }
                t.markElapsed("Reading documents from DB");
                logger.info(String.valueOf(documents.size()) + " found.");

                // Pistame leitud dokumendid väljundisse
                t.reset();
                try {
                    FileOutputStream out = null;
                    OutputStreamWriter ow = null;
                    BufferedWriter bw = null;
                    try {
                        out = new FileOutputStream(pipelineDataFile, false);
                        ow = new OutputStreamWriter(out, "UTF-8");
                        bw = new BufferedWriter(ow);

                        if (documents != null) {
                            ArrayList<Integer> processedDocuments = new ArrayList<Integer>();
                            for (int i = 0; i < documents.size(); ++i) {
                                dhl.Document tmpDoc = documents.get(i);

                                if (tmpDoc != null) {
                                    if (!processedDocuments.contains(tmpDoc.getId()) && (tmpDoc.getFilePath() != null)) {
                                        // Laeme konkreetse dokumendi saatmist puudutavad andmed
                                        Sending tmpSending = new Sending();
                                        tmpSending.loadByDocumentID(tmpDoc.getId(), conn);

                                        Recipient tmpRecipient = null;
                                        ArrayList<Recipient> tmpRecipients = tmpSending.getRecipients();

                                        Recipient recipientBuffer = null;
                                        for (int j = 0; j < tmpRecipients.size(); ++j) {
                                            recipientBuffer = tmpRecipients.get(j);
                                            if (recipientBuffer.getOrganizationID() == user.getOrganizationID()) {
                                                tmpRecipient = recipientBuffer;
                                                break;
                                            }
                                        }

                                        if ((tmpRecipient != null) && (tmpSending.getSender() != null)) {
                                            Asutus senderOrg = new Asutus(tmpSending.getSender().getOrganizationID(), conn);
                                            Asutus recipientOrg = new Asutus(tmpRecipient.getOrganizationID(), conn);

                                            if (isContainerConversionNeeded(
                                                    recipientOrg.getKapselVersioon(), tmpDoc.getContainerVersion())) {
                                                tmpDoc.setFilePath(convertContainer(conn, tmpDoc, 21, 1).getOutputFile());
                                            }

                                            logger.debug("Splitting out file tag: 'SignedDoc' from file: " + tmpDoc.getFilePath());
                                            CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);

                                            // Täidame DHL poolt automaatselt täidetavad väljad
                                            appendAutomaticMetaData(
                                                    tmpDoc.getFilePath(),
                                                    tmpSending,
                                                    tmpRecipient,
                                                    tmpDoc,
                                                    senderOrg,
                                                    recipientOrg,
                                                    conn,
                                                    tmpDoc.getDvkContainerVersion(),
                                                    tmpDoc.getContainerVersion());

                                            // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
                                            // faili koosseisu tagasi.
                                            logger.debug("Joining split XML.");
                                            logger.debug("PipelineDatafile: " + pipelineDataFile);
                                            logger.debug("Temporary XML file: " + tmpDoc.getFilePath());
                                            CommonMethods.joinSplitXML(tmpDoc.getFilePath(), bw);

                                            processedDocuments.add(tmpDoc.getId());
                                        }
                                    }
                                }
                            }
                        }
                    } catch (AxisFault fault) {
                        throw fault;
                    } catch (Exception ex) {
                        logger.error(ex.getMessage(), ex);
                        throw new AxisFault("Error composing response message: "
                                + " (" + ex.getClass().getName() + ": " + ex.getMessage() + ")");
                    } finally {
                        CommonMethods.safeCloseWriter(bw);
                        CommonMethods.safeCloseWriter(ow);
                        CommonMethods.safeCloseStream(out);
                        bw = null;
                        ow = null;
                        out = null;
                    }
                } catch (AxisFault fault) {
                    throw fault;
                } catch (Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    throw new AxisFault(ex.getMessage());
                }
                t.markElapsed("Processing documents and creating answer");

                t.reset();
                result.responseFile = CommonMethods.gzipPackXML(
                        pipelineDataFile, user.getOrganizationCode(), "receiveDocuments");
                t.markElapsed("Compressing response data");

                // Kui soovitakse vastust fragmenteeritud kujul, siis lammutame faili
                // tükkideks ja salvestame tükid saatmist ootama.
                if ((bodyData.edastusID != null)
                        && !bodyData.edastusID.equalsIgnoreCase("")
                        && (bodyData.fragmentNr >= 0)) {

                    XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                            user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);

                    FragmentationResult fragResult = DocumentFragment.getFragments(
                            result.responseFile, bodyData.fragmentSizeBytes, user.getOrganizationID(),
                            bodyData.edastusID, false, conn, xTeePais);

                    if ((fragResult != null)
                            && (fragResult.firstFragmentFile != null)
                            && (new File(fragResult.firstFragmentFile)).exists()) {
                        result.responseFile = fragResult.firstFragmentFile;
                        result.fragmentNr = 0;
                        result.totalFragments = fragResult.totalFragments;
                    }
                }
            }
        } finally {
            (new File(pipelineDataFile)).delete();
        }

        return result;
    }

    public static RequestInternalResult V4(
            org.apache.axis.MessageContext context, Connection conn, UserProfile user, XRoadProtocolHeader xRoadProtocolHeader) throws Exception {
        logger.info("ReceiveDocuments.V4 invoked.");

        Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Laeme SOAP keha endale sobivasse andmestruktuuri
            t.reset();
            receiveDocumentsV4RequestType bodyData = receiveDocumentsV4RequestType.getFromSOAPBody(context, xRoadProtocolHeader);
            result.count = bodyData.arv;
            result.folders = bodyData.kaust;
            result.deliverySessionID = bodyData.edastusID;
            result.fragmentSizeBytes = bodyData.fragmentSizeBytesOrig;
            t.markElapsed("Parsing SOAP body");

            // Check if all requested folders really exist
            validateFolders(bodyData.kaust, user, conn);

            logger.debug("Starting receiveDocuments.V4 Request. Org: "
                    + user.getOrganizationCode() + ", Personal ID: " + user.getPersonCode());

            if ((bodyData.edastusID != null)
                    && !bodyData.edastusID.equalsIgnoreCase("")
                    && (bodyData.fragmentNr > 0)) {
                DocumentFragment fragment = new DocumentFragment(
                        user.getOrganizationID(), bodyData.edastusID, bodyData.fragmentNr, conn);
                result.responseFile = fragment.getFileName();
                result.fragmentNr = fragment.getFragmentNr();
                result.totalFragments = fragment.getFragmentCount();
            } else {
                t.reset();
                ArrayList<dhl.Document> documents = new ArrayList<dhl.Document>();
                if ((bodyData.kaust == null) || (bodyData.kaust.size() == 0)) {
                    // Leiame antud kasutajale saadetud dokumendid
                    logger.debug("Searching documents using following parameters: Org ID:  "
                            + String.valueOf(user.getOrganizationID()) + ", Folder:  "
                            + String.valueOf(Folder.UNSPECIFIED_FOLDER) + ", Person ID: "
                            + String.valueOf(user.getPersonID()) + ", Subdivision SN: "
                            + bodyData.allyksuseLyhinimetus + ", Occupation SN: "
                            + bodyData.ametikohaLyhinimetus + ", Max documents: "
                            + String.valueOf(bodyData.arv));
                    documents = dhl.Document.getDocumentsSentTo(
                            user.getOrganizationID(),
                            Folder.UNSPECIFIED_FOLDER,
                            user.getPersonID(),
                            0,
                            bodyData.allyksuseLyhinimetus,
                            0,
                            bodyData.ametikohaLyhinimetus,
                            bodyData.arv,
                            conn);
                } else {
                    int resultLimit = bodyData.arv;
                    for (int folderNr = 0; folderNr < bodyData.kaust.size(); ++folderNr) {
                        // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
                        XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);
                        int requestTargetFolder = Folder.getFolderIdByPath(
                                bodyData.kaust.get(folderNr).trim(), user.getOrganizationID(), conn, true, false, xTeePais);

                        // Leiame antud kasutajale saadetud dokumendid
                        logger.debug("Searching documents using following parameters: Org ID:  "
                                + String.valueOf(user.getOrganizationID()) + ", Folder:  "
                                + String.valueOf(requestTargetFolder) + ", Person ID: "
                                + String.valueOf(user.getPersonID()) + ", Subdivision SN: "
                                + bodyData.allyksuseLyhinimetus + ", Occupation SN: "
                                + bodyData.ametikohaLyhinimetus + ", Max documents: " + String.valueOf(resultLimit));
                        ArrayList<dhl.Document> tmpDocs = dhl.Document.getDocumentsSentTo(
                                user.getOrganizationID(),
                                requestTargetFolder,
                                user.getPersonID(),
                                0,
                                bodyData.allyksuseLyhinimetus,
                                0,
                                bodyData.ametikohaLyhinimetus,
                                resultLimit,
                                conn);
                        resultLimit -= tmpDocs.size();

                        // Lisame leitud dokumendid dokumentide täisnimekirja
                        documents.addAll(tmpDocs);
                        tmpDocs = null;

                        // Kui maksimaalne lubatud vastuste hulk on käes, siis
                        // rohkem dokumente andmebaasist välja ei võta
                        if (resultLimit <= 0) {
                            break;
                        }
                    }
                }
                t.markElapsed("Reading documents from DB");
                logger.info(String.valueOf(documents.size()) + " found.");

                // Pistame leitud dokumendid väljundisse
                t.reset();
                try {
                    FileOutputStream out = null;
                    OutputStreamWriter ow = null;
                    BufferedWriter bw = null;
                    try {
                        out = new FileOutputStream(pipelineDataFile, false);
                        ow = new OutputStreamWriter(out, "UTF-8");
                        bw = new BufferedWriter(ow);

                        if (documents != null) {
                            ArrayList<Integer> processedDocuments = new ArrayList<Integer>();
                            for (int i = 0; i < documents.size(); ++i) {
                                dhl.Document tmpDoc = documents.get(i);

                                if (tmpDoc != null) {
                                    if (!processedDocuments.contains(tmpDoc.getId()) && (tmpDoc.getFilePath() != null)) {
                                        // Laeme konkreetse dokumendi saatmist puudutavad andmed
                                        Sending tmpSending = new Sending();
                                        tmpSending.loadByDocumentID(tmpDoc.getId(), conn);

                                        Recipient tmpRecipient = null;
                                        ArrayList<Recipient> tmpRecipients = tmpSending.getRecipients();

                                        Recipient recipientBuffer = null;
                                        for (int j = 0; j < tmpRecipients.size(); ++j) {
                                            recipientBuffer = tmpRecipients.get(j);
                                            if (recipientBuffer.getOrganizationID() == user.getOrganizationID()) {
                                                tmpRecipient = recipientBuffer;
                                                break;
                                            }
                                        }

                                        if (tmpRecipient != null) {
                                            Asutus senderOrg = new Asutus(tmpSending.getSender().getOrganizationID(), conn);
                                            Asutus recipientOrg = new Asutus(tmpRecipient.getOrganizationID(), conn);

                                            if (isContainerConversionNeeded(
                                                    recipientOrg.getKapselVersioon(), tmpDoc.getContainerVersion())) {
                                                tmpDoc.setFilePath(convertContainer(conn, tmpDoc, 21, 1).getOutputFile());
                                            }

                                            // Viskame XML failist välja suure mahuga SignedDoc elemendid
                                            //CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);
                                            CommonMethods.splitOutTags(tmpDoc.getFilePath(), "failid", false, false, true);

                                            // Täidame DHL poolt automaatselt täidetavad väljad
                                            appendAutomaticMetaData(
                                                    tmpDoc.getFilePath(),
                                                    tmpSending,
                                                    tmpRecipient,
                                                    tmpDoc,
                                                    senderOrg,
                                                    recipientOrg,
                                                    conn,
                                                    tmpDoc.getDvkContainerVersion(),
                                                    tmpDoc.getContainerVersion());

                                            // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
                                            // faili koosseisu tagasi.
                                            CommonMethods.joinSplitXML(tmpDoc.getFilePath(), bw);

                                            processedDocuments.add(tmpDoc.getId());
                                        }
                                    }
                                }
                            }
                        }
                    } catch (AxisFault fault) {
                        throw fault;
                    } catch (Exception ex) {
                        logger.error(ex.getMessage(), ex);
                        throw new AxisFault("Error composing response message: "
                                + " (" + ex.getClass().getName() + ": " + ex.getMessage() + ")");
                    } finally {
                        CommonMethods.safeCloseWriter(bw);
                        CommonMethods.safeCloseWriter(ow);
                        CommonMethods.safeCloseStream(out);
                        bw = null;
                        ow = null;
                        out = null;
                    }
                } catch (AxisFault fault) {
                    throw fault;
                } catch (Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    throw new AxisFault(ex.getMessage());
                }
                t.markElapsed("Processing documents and creating answer");

                t.reset();
                result.responseFile = CommonMethods.gzipPackXML(
                        pipelineDataFile, user.getOrganizationCode(), "receiveDocuments");
                logger.debug("result.responseFile: " + result.responseFile);
                t.markElapsed("Compressing response data");

                // Kui soovitakse vastust fragmenteeritud kujul, siis lammutame faili
                // tükkideks ja salvestame tükid saatmist ootama.
                if ((bodyData.edastusID != null)
                        && !bodyData.edastusID.equalsIgnoreCase("")
                        && (bodyData.fragmentNr >= 0)) {
                    logger.debug("Vastust soovitakse fragmenteeritud kujul. Tükeldame faili.");
                    XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                            user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);
                    FragmentationResult fragResult = DocumentFragment.getFragments(
                            result.responseFile, bodyData.fragmentSizeBytes,
                            user.getOrganizationID(), bodyData.edastusID, false, conn, xTeePais);

                    if ((fragResult != null)
                            && (fragResult.firstFragmentFile != null)
                            && (new File(fragResult.firstFragmentFile)).exists()) {

                        logger.debug("fragResult.totalFragments: " + fragResult.totalFragments);
                        logger.debug("fragResult.firstFragmentFile: " + fragResult.firstFragmentFile);

                        result.responseFile = fragResult.firstFragmentFile;
                        result.fragmentNr = 0;
                        result.totalFragments = fragResult.totalFragments;
                    } else {
                        logger.debug("Problem with fragResult - null.");
                    }
                }
            }
        } finally {
            (new File(pipelineDataFile)).delete();
        }

        logger.debug("Returning result.");
        if (result != null) {
            logger.debug("result.fragmentNr: " + result.fragmentNr);
            logger.debug("result.totalFragments: " + result.totalFragments);
            logger.debug("result.responseFile: " + result.responseFile);
        }

        return result;
    }


    /**
     * Meetod lisab DVK poolt automaatselt lisatavad metaandmed
     * dokumendi XML struktuurile.
     *
     * @param filePath      Töödeldava XML faili asukoht
     * @param sendingData   Dokumendi saatmise andmed
     * @param recipientData Dokumenti hetkel vastuvõtva adressaadi andmed
     * @param documentData  Dokumendi saatja andmed
     * @param senderOrg     Dokumendi saatnud asutuse andmed
     * @param recipientOrg  Dokumenti hetkel vastuvõtva asutuse andmed
     * @param conn          Database connection
     * @param containerVersion old container version (int)
     * @param documentContainerVersion new container version
     * @throws Exception
     */
    public static void appendAutomaticMetaData(
            String filePath,
            Sending sendingData,
            Recipient recipientData,
            dhl.Document documentData,
            Asutus senderOrg,
            Asutus recipientOrg,
            Connection conn,
            int containerVersion, String documentContainerVersion) throws Exception {
        //if the documentContainerVersion is 2.1 && it was not needed to be converted to 1.0 then append metadata for 2.1
        if (documentContainerVersion != null
                    && ContainerVersion.VERSION_2_1.toString().equals(documentContainerVersion)
                && !isContainerConversionNeeded(recipientOrg.getKapselVersioon(), documentContainerVersion)) {
            appendAutomaticMetaDataForVersion21(filePath, sendingData, documentData, conn);
        } else {
            appendAutomaticMetaDataForVersions10And20(
                   filePath, sendingData, recipientData, documentData,
                   senderOrg, recipientOrg, conn, containerVersion);
        }
    }

    /**
     * Append metadata for container version 2.1
     *
     * @param filePath      Töödeldava XML faili asukoht
     * @param sendingData   Dokumendi saatmise andmed
     * @param documentData  Dokumendi saatja andmed
     * @param conn          Database connection
     * @throws Exception
     */
    private static void appendAutomaticMetaDataForVersion21(String filePath,
                                                                  Sending sendingData,
                                                                  dhl.Document documentData,
                                                                  Connection conn) throws Exception {
        logger.debug("Constructing document from XML. File: " + filePath);
        Document currentXmlContent = CommonMethods.xmlDocumentFromFile(filePath, true);

        if (currentXmlContent == null) {
            throw new Exception(
                    "Failed to process XML contents of document "
                            + documentData.getId() + "! Document XML is empty or invalid.");
        }
        Element decMetadata = null;

        NodeList foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS("*", "DecMetadata");
        if (foundNodes != null && foundNodes.getLength() > 0) {
            decMetadata = (Element) foundNodes.item(0);
        } else {
            decMetadata = currentXmlContent.createElement("DecMetadata");
            currentXmlContent.getDocumentElement().appendChild(decMetadata);
        }

        Node firstMetadataNode = decMetadata.getFirstChild();

        if (firstMetadataNode == null) {
            addTextElement(currentXmlContent, decMetadata,
                    "DecId", String.valueOf(documentData.getId()));
            addTextElement(currentXmlContent, decMetadata,
                    "DecFolder", Folder.getFolderFullPath(documentData.getFolderID(), conn));
            addTextElement(currentXmlContent, decMetadata,
                    "DecReceiptDate", CommonMethods.getDateISO8601(sendingData.getStartDate()));
        } else {
            decMetadata = appendTextElement(
                    currentXmlContent, decMetadata, "DecId", String.valueOf(documentData.getId()),
                    firstMetadataNode);

            decMetadata = appendTextElement(
                    currentXmlContent, decMetadata, "DecFolder",
                    Folder.getFolderFullPath(documentData.getFolderID(), conn), firstMetadataNode);

            appendTextElement(
                    currentXmlContent, decMetadata, "DecReceiptDate",
                    CommonMethods.getDateISO8601(sendingData.getStartDate()),
                    firstMetadataNode);
        }
        if( currentXmlContent.getDocumentElement().getPrefix() != null) {
          CommonMethods.removeNamespaceRecursive(currentXmlContent.getDocumentElement());
        }
        // Salvestame muudetud XML andmed faili
        CommonMethods.xmlElementToFile(currentXmlContent.getDocumentElement(), filePath);
    }

    private static void addTextElement(Document xmlDoc, Element parentNode, String tagName, String tagValue) {
        Element element = xmlDoc.createElement(tagName);
        Text value = xmlDoc.createTextNode(tagValue);
        element.appendChild(value);
        parentNode.appendChild(element);
    }

    private static Element appendTextElement(Document xmlDoc, Element parentNode, String tagName, String tagValue, Node refNode) {
        Element e = null;
        NodeList foundNodes = parentNode.getElementsByTagNameNS("*", tagName);
        if (foundNodes.getLength() == 0) {
            e = xmlDoc.createElement(tagName);
            if (refNode != null) {
                parentNode.insertBefore(e, refNode);
            } else {
                parentNode.appendChild(e);
            }
        } else {
            e = (Element) foundNodes.item(0);
            CommonMethods.removeNodeChildren(e);
        }
        Text t = xmlDoc.createTextNode(tagValue);
        if ((t != null) && (t.getNodeValue() != null) && !t.getNodeValue().equalsIgnoreCase("")) {
            e.appendChild(t);
        }
        return parentNode;
    }


    /**
     * Append metadata for container versions 1.0 and 2.0
     * @param filePath      Töödeldava XML faili asukoht
     * @param sendingData   Dokumendi saatmise andmed
     * @param recipientData Dokumenti hetkel vastuvõtva adressaadi andmed
     * @param documentData  Dokumendi saatja andmed
     * @param senderOrg     Dokumendi saatnud asutuse andmed
     * @param recipientOrg  Dokumenti hetkel vastuvõtva asutuse andmed
     * @param conn          Database connection
     * @param containerVersion old container version (int)
     * @throws Exception
     */
    private static void appendAutomaticMetaDataForVersions10And20(
            String filePath,
            Sending sendingData,
            Recipient recipientData,
            dhl.Document documentData,
            Asutus senderOrg,
            Asutus recipientOrg,
            Connection conn,
            int containerVersion) throws Exception {

        logger.debug("Constructing document from XML. File: " + filePath);
        Document currentXmlContent = CommonMethods.xmlDocumentFromFile(filePath, true);

        if (currentXmlContent == null) {
            throw new Exception(
                    "Failed to process XML contents of document "
                            + documentData.getId() + "! Document XML is empty or invalid.");
        }

        Element metainfoNode = null;

        NodeList foundNodes = null;
        if (containerVersion == 1) {
            foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(CommonStructures.DhlNamespace, "metainfo");
        } else {
            foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(CommonStructures.DhlNamespaceV2, "metainfo");
        }

        if (foundNodes != null && foundNodes.getLength() > 0) {
            metainfoNode = (Element) foundNodes.item(0);
        } else {
            String defaultPrefix = null;

            if (containerVersion == 1) {
                defaultPrefix = currentXmlContent.lookupPrefix(CommonStructures.DhlNamespace);
            } else {
                defaultPrefix = currentXmlContent.lookupPrefix(CommonStructures.DhlNamespaceV2);
            }

            if (defaultPrefix == null) {
                defaultPrefix = "dhl";
                int prefixCounter = 0;
                while (currentXmlContent.lookupNamespaceURI(defaultPrefix) != null) {
                    prefixCounter++;
                    defaultPrefix = "dhl" + String.valueOf(prefixCounter);
                }
            }

            if (containerVersion == 1) {
                metainfoNode = currentXmlContent.createElementNS(CommonStructures.DhlNamespace, defaultPrefix + ":metainfo");
            } else {
                metainfoNode = currentXmlContent.createElementNS(CommonStructures.DhlNamespaceV2, defaultPrefix + ":metainfo");
            }

            // Lisame metainfo elemendi esimeseks elemendiks
            try {
                currentXmlContent.getDocumentElement().insertBefore(metainfoNode, currentXmlContent.getDocumentElement().getFirstChild());
            } catch (Exception ex) {
                logger.warn("Failed to add \"metainfo\" element as first element in container. Adding as last.", ex);
                currentXmlContent.getDocumentElement().appendChild(metainfoNode);
            }
        }

        String prefix = metainfoNode.lookupPrefix(CommonStructures.AutomaticMetadataNamespace);
        if ((prefix == null) || prefix.equalsIgnoreCase("")) {
            // Koostame metadata-automatic nimeruumile prefiksi, mida pole metainfo
            // elemendi kontekstis veel deklareeritud.
            String tmpPrefix = "ma";
            int prefixCounter = 0;
            while (metainfoNode.lookupNamespaceURI(tmpPrefix) != null) {
                prefixCounter++;
                tmpPrefix = "ma" + String.valueOf(prefixCounter);
            }

            // registreerime metadata-automatic nimeruumi
            metainfoNode.setAttribute("xmlns:" + tmpPrefix, CommonStructures.AutomaticMetadataNamespace);
            prefix = tmpPrefix;
        }

        // Kohalikud muutujad
        Calendar cal = Calendar.getInstance();

        Node firstMetadataNode = metainfoNode.getFirstChild();

        // Dokumendi ID lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_id", String.valueOf(documentData.getId()),
                prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saabumisviisi lisamine
        switch (sendingData.getReceivedMethodID()) {
            case CommonStructures.SendingMethod_EMail:
                metainfoNode = CommonMethods.appendTextNodeBefore(
                        currentXmlContent, metainfoNode, "dhl_saabumisviis",
                        CommonStructures.SendingMethod_EMail_Name, prefix,
                        CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            case CommonStructures.SendingMethod_XTee:
                metainfoNode = CommonMethods.appendTextNodeBefore(
                        currentXmlContent, metainfoNode, "dhl_saabumisviis",
                        CommonStructures.SendingMethod_XTee_Name, prefix,
                        CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            default:
                break;
        }

        // Saabumisaja lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saabumisaeg",
                CommonMethods.getDateISO8601(sendingData.getStartDate()),
                prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatmisviisi lisamine
        switch (recipientData.getSendingMethodID()) {
            case CommonStructures.SendingMethod_EMail:
                metainfoNode = CommonMethods.appendTextNodeBefore(
                        currentXmlContent, metainfoNode, "dhl_saatmisviis",
                        CommonStructures.SendingMethod_EMail_Name, prefix,
                        CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            case CommonStructures.SendingMethod_XTee:
                metainfoNode = CommonMethods.appendTextNodeBefore(
                        currentXmlContent, metainfoNode, "dhl_saatmisviis",
                        CommonStructures.SendingMethod_XTee_Name, prefix,
                        CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            default:
                break;
        }

        // Saatmisaja lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saatmisaeg",
                CommonMethods.getDateISO8601(cal.getTime()), prefix,
                CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja asutuse numbri lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saatja_asutuse_nr",
                senderOrg.getRegistrikood(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja asutuse nime lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saatja_asutuse_nimi",
                senderOrg.getNimetus(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja isikukoodi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saatja_isikukood",
                sendingData.getSender().getPersonalIdCode(), prefix,
                CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja asutuse numbri lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saaja_asutuse_nr",
                recipientOrg.getRegistrikood(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja asutuse nime lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saaja_asutuse_nimi", recipientOrg.getNimetus(),
                prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja isikukoodi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saaja_isikukood", recipientData.getPersonalIdCode(),
                prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja e-posti aadressi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saatja_epost", sendingData.getSender().getEmail(),
                prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja e-posti aadressi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_saaja_epost", recipientData.getEmail(),
                prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Dokumendi kausta aadressi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(
                currentXmlContent, metainfoNode, "dhl_kaust",
                Folder.getFolderFullPath(documentData.getFolderID(), conn), prefix,
                CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Salvestame muudetud XML andmed faili
        CommonMethods.xmlElementToFile(currentXmlContent.getDocumentElement(), filePath);
    }

    /**
     * Checks if folders specified in request actually exist. If non-existing
     * folders are found then throws an {@link AxisFault} containing list
     * of folders that do not exist.
     *
     * @param folders List of folders from receiveDocuments request
     * @param user    Current user
     * @param conn    Active database connection
     * @throws AxisFault Error containing list of folders that do not exist
     */
    private static void validateFolders(final List<String> folders,
                                        final UserProfile user, final Connection conn) throws AxisFault {
        if ((folders != null) && (folders.size() > 0)) {
            List<String> nonExistingFolders = new ArrayList<String>();
            XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(user.getOrganizationCode(), null,
                    null, null, null, null, user.getPersonCode(), XRoadProtocolVersion.V2_0);

            for (String folderName : folders) {
                int folderId = Folder.getFolderIdByPath(folderName,
                        user.getOrganizationID(), conn, true, false, xTeePais);
                if (folderId == Folder.NONEXISTING_FOLDER) {
                    nonExistingFolders.add(folderName);
                }
            }

            if (nonExistingFolders.size() > 0) {
                throw new AxisFault(CommonStructures.
                        VIGA_ALLALAADIMINE_TUNDMATUST_KATALOOGIST.replaceFirst("#1",
                        CommonMethods.join(nonExistingFolders, ", ")));
            }
        }
    }
}
