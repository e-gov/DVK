package dhl.requests;

import dhl.DocumentFragment;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dhl.Conversion;
import dhl.Folder;
import dhl.Recipient;
import dhl.Sending;
import dhl.iostructures.FragmentationResult;
import dhl.iostructures.XHeader;
import dhl.iostructures.receiveDocumentsRequestType;
import dhl.iostructures.receiveDocumentsV2RequestType;
import dhl.iostructures.receiveDocumentsV3RequestType;
import dhl.iostructures.receiveDocumentsV4RequestType;
import dhl.sys.Timer;
import dhl.users.Asutus;
import dhl.users.UserProfile;
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
                documents = dhl.Document.getDocumentsSentTo(user.getOrganizationID(), Folder.UNSPECIFIED_FOLDER, user.getPersonID(), 0, "", 0, "", bodyData.arv, conn);
            } else {
                int resultLimit = bodyData.arv;
                for (int folderNr = 0; folderNr < bodyData.kaust.size(); ++folderNr) {
                    // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
                	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                    int requestTargetFolder = Folder.getFolderIdByPath( bodyData.kaust.get(folderNr).trim(), user.getOrganizationID(), conn, true, false, xTeePais );

                    // Leiame antud kasutajale saadetud dokumendid
                    ArrayList<dhl.Document> tmpDocs = dhl.Document.getDocumentsSentTo( user.getOrganizationID(), requestTargetFolder, user.getPersonID(), 0, "", 0, "", resultLimit, conn );
                    resultLimit -= tmpDocs.size();

                    // Lisame leitud dokumendid dokumentide tõisnimekirja
                    documents.addAll(tmpDocs);
                    tmpDocs = null;

                    // Kui maksimaalne lubatud vastuste hulk on kões, siis
                    // rohkem dokumente andmebaasist võlja ei võta
                    if (resultLimit <= 0) {
                        break;
                    }
                }
            }
            t.markElapsed("Reading documents from DB");

            // Pistame leitud dokumendid võljundisse
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
                                    tmpSending.loadByDocumentID( tmpDoc.getId(), conn );

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
                                        Asutus senderOrg = new Asutus( tmpSending.getSender().getOrganizationID(), conn );
                                        Asutus recipientOrg = new Asutus( tmpRecipient.getOrganizationID(), conn );

                                        if(tmpDoc.getDvkContainerVersion() == 2) {

                                        	// Convert to DVK container version 1
                                        	Conversion conversion = new Conversion();
                                			conversion.setInputFile(tmpDoc.getFilePath());
                                			conversion.setOutputFile(tmpDoc.getFilePath() + ".tmp");
                                			conversion.setVersion(2);
                                			conversion.setTargetVersion(1);

                                			// Get the XSLT from database
                                			conversion.getConversionFromDB(conn);

                                			conversion.convert();

                                			tmpDoc.setFilePath(tmpDoc.getFilePath() + ".tmp");
                                        }

                                        // Viskame XML failist võlja suure mahuga SignedDoc elemendid
                                        CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);

                                        // Tõidame DHL poolt automaatselt tõidetavad võljad
                                        appendAutomaticMetaData(
                                            tmpDoc.getFilePath(),
                                            tmpSending,
                                            tmpRecipient,
                                            tmpDoc,
                                            senderOrg,
                                            recipientOrg,
                                            conn,
                                            tmpDoc.getDvkContainerVersion());

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
                    throw new AxisFault("Error composing response message: " +" ("+ ex.getClass().getName() +": "+ ex.getMessage() +")");
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

    public static RequestInternalResult V2( org.apache.axis.MessageContext context, Connection conn, UserProfile user ) throws Exception {
    	logger.info("ReceiveDocuments.V2 invoked.");

        Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Laeme SOAP keha endale sobivasse andmestruktuuri
            t.reset();
            receiveDocumentsV2RequestType bodyData = receiveDocumentsV2RequestType.getFromSOAPBody(context);
            result.count = bodyData.arv;
            result.folders = bodyData.kaust;
            result.deliverySessionID = bodyData.edastusID;
            result.fragmentSizeBytes = bodyData.fragmentSizeBytesOrig;
            t.markElapsed("Parsing SOAP body");

            // Check if all requested folders really exist
            validateFolders(bodyData.kaust, user, conn);

            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr > 0)) {
                DocumentFragment fragment = new DocumentFragment(user.getOrganizationID(), bodyData.edastusID, bodyData.fragmentNr, conn);
                result.responseFile = fragment.getFileName();
                result.fragmentNr = fragment.getFragmentNr();
                result.totalFragments = fragment.getFragmentCount();
            } else {
                t.reset();
                ArrayList<dhl.Document> documents = new ArrayList<dhl.Document>();
                if ((bodyData.kaust == null) || (bodyData.kaust.size() == 0)) {
                    // Leiame antud kasutajale saadetud dokumendid
                    documents = dhl.Document.getDocumentsSentTo(user.getOrganizationID(), Folder.UNSPECIFIED_FOLDER, user.getPersonID(), 0, "", 0, "", bodyData.arv,  conn);
                } else {
                    int resultLimit = bodyData.arv;
                    for (int folderNr = 0; folderNr < bodyData.kaust.size(); ++folderNr) {
                        // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
                    	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                        int requestTargetFolder = Folder.getFolderIdByPath( bodyData.kaust.get(folderNr).trim(), user.getOrganizationID(), conn, true, false, xTeePais );

                        // Leiame antud kasutajale saadetud dokumendid
                        ArrayList<dhl.Document> tmpDocs = dhl.Document.getDocumentsSentTo( user.getOrganizationID(), requestTargetFolder, user.getPersonID(), 0, "", 0, "", resultLimit, conn );
                        resultLimit -= tmpDocs.size();

                        // Lisame leitud dokumendid dokumentide tõisnimekirja
                        documents.addAll(tmpDocs);
                        tmpDocs = null;

                        // Kui maksimaalne lubatud vastuste hulk on kões, siis
                        // rohkem dokumente andmebaasist võlja ei võta
                        if (resultLimit <= 0) {
                            break;
                        }
                    }
                }
                t.markElapsed("Reading documents from DB");

                // Pistame leitud dokumendid võljundisse
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

                                        if ((tmpRecipient != null) && (tmpSending.getSender() != null))
                                        {
                                            Asutus senderOrg = new Asutus(tmpSending.getSender().getOrganizationID(), conn);
                                            Asutus recipientOrg = new Asutus(tmpRecipient.getOrganizationID(), conn);

                                            if(tmpDoc.getDvkContainerVersion() == 2) {

                                            	// Convert to DVK container version 1
                                            	Conversion conversion = new Conversion();
                                    			conversion.setInputFile(tmpDoc.getFilePath());
                                    			conversion.setOutputFile(tmpDoc.getFilePath() + ".tmp");
                                    			conversion.setVersion(2);
                                    			conversion.setTargetVersion(1);

                                    			// Get the XSLT from database
                                    			conversion.getConversionFromDB(conn);

                                    			conversion.convert();

                                    			tmpDoc.setFilePath(tmpDoc.getFilePath() + ".tmp");

                                            }

                                            // Viskame XML failist võlja suure mahuga SignedDoc elemendid
                                            CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);

                                            // Tõidame DHL poolt automaatselt tõidetavad võljad
                                            appendAutomaticMetaData(
                                                tmpDoc.getFilePath(),
                                                tmpSending,
                                                tmpRecipient,
                                                tmpDoc,
                                                senderOrg,
                                                recipientOrg,
                                                conn,
                                                tmpDoc.getDvkContainerVersion());

                                            // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
                                            // faili koosseisu tagasi.
                                            CommonMethods.joinSplitXML(tmpDoc.getFilePath(), bw);

                                            processedDocuments.add( tmpDoc.getId() );
                                        }
                                    }
                                }
                            }
                        }
                    } catch (AxisFault fault) {
                    	throw fault;
                    } catch (Exception ex) {
                    	logger.error(ex.getMessage(), ex);
                        throw new AxisFault("Error composing response message: " +" ("+ ex.getClass().getName() +": "+ ex.getMessage() +")");
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
                result.responseFile = CommonMethods.gzipPackXML(pipelineDataFile, user.getOrganizationCode(), "receiveDocuments" );
                t.markElapsed("Compressing response data");

                // Kui soovitakse vastust fragmenteeritud kujul, siis lammutame faili
                // tõkkideks ja salvestame tõkid saatmist ootama.
                if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr >= 0)) {
                	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                    FragmentationResult fragResult = DocumentFragment.getFragments(result.responseFile, bodyData.fragmentSizeBytes, user.getOrganizationID(), bodyData.edastusID, false, conn, xTeePais);
                    if ((fragResult != null) && (fragResult.firstFragmentFile != null) && (new File(fragResult.firstFragmentFile)).exists()) {
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

    public static RequestInternalResult V3( org.apache.axis.MessageContext context, Connection conn, UserProfile user ) throws Exception {
    	logger.info("ReceiveDocuments.V3 invoked.");

    	Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Laeme SOAP keha endale sobivasse andmestruktuuri
            t.reset();
            receiveDocumentsV3RequestType bodyData = receiveDocumentsV3RequestType.getFromSOAPBody( context );
            result.count = bodyData.arv;
            result.folders = bodyData.kaust;
            result.deliverySessionID = bodyData.edastusID;
            result.fragmentSizeBytes = bodyData.fragmentSizeBytesOrig;
            t.markElapsed("Parsing SOAP body");

            // Check if all requested folders really exist
            validateFolders(bodyData.kaust, user, conn);

            logger.debug("Starting receiveDocuments.V3 Request. Org: " + user.getOrganizationCode() + ", Personal ID: " + user.getPersonCode());

            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr > 0)) {
                DocumentFragment fragment = new DocumentFragment(user.getOrganizationID(), bodyData.edastusID, bodyData.fragmentNr, conn);
                result.responseFile = fragment.getFileName();
                result.fragmentNr = fragment.getFragmentNr();
                result.totalFragments = fragment.getFragmentCount();
            } else {
                t.reset();
                ArrayList<dhl.Document> documents = new ArrayList<dhl.Document>();
                if ((bodyData.kaust == null) || (bodyData.kaust.size() == 0)) {
                    // Leiame antud kasutajale saadetud dokumendid
                    logger.debug("Searching documents using following parameters: Org ID:  " + String.valueOf(user.getOrganizationID()) + ", Folder:  " + String.valueOf(Folder.UNSPECIFIED_FOLDER) + ", Person ID: " + String.valueOf(user.getPersonID()) + ", Subdivision ID: " + String.valueOf(bodyData.allyksus) + ", Occupation ID: " + String.valueOf(bodyData.ametikoht) + ", Max documents: " + String.valueOf(bodyData.arv));
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
                    	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                        int requestTargetFolder = Folder.getFolderIdByPath( bodyData.kaust.get(folderNr).trim(), user.getOrganizationID(), conn, true, false, xTeePais );

                        // Leiame antud kasutajale saadetud dokumendid
                        logger.debug("Searching documents using following parameters: Org ID:  " + String.valueOf(user.getOrganizationID()) + ", Folder:  " + String.valueOf(requestTargetFolder) + ", Person ID: " + String.valueOf(user.getPersonID()) + ", Subdivision ID: " + String.valueOf(bodyData.allyksus) + ", Occupation ID: " + String.valueOf(bodyData.ametikoht) + ", Max documents: " + String.valueOf(resultLimit));
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

                        // Lisame leitud dokumendid dokumentide tõisnimekirja
                        documents.addAll(tmpDocs);
                        tmpDocs = null;

                        // Kui maksimaalne lubatud vastuste hulk on kões, siis
                        // rohkem dokumente andmebaasist võlja ei võta
                        if (resultLimit <= 0) {
                            break;
                        }
                    }
                }
                t.markElapsed("Reading documents from DB");
                logger.info(String.valueOf(documents.size()) + " found.");

                // Pistame leitud dokumendid võljundisse
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
                                        tmpSending.loadByDocumentID( tmpDoc.getId(), conn );

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
                                            Asutus senderOrg = new Asutus( tmpSending.getSender().getOrganizationID(), conn );
                                            Asutus recipientOrg = new Asutus( tmpRecipient.getOrganizationID(), conn );

                                            if(tmpDoc.getDvkContainerVersion() == 2) {
                                            	logger.debug("Converting DVK container to older version.");

                                            	try {
                                            		logger.debug("TmpDoc filePath: " + tmpDoc.getFilePath());
                                            		logger.debug("TmpDoc filePath out: " + tmpDoc.getFilePath() + ".tmp");

                                            		// Convert to DVK container version 1
	                                            	Conversion conversion = new Conversion();
	                                    			conversion.setInputFile(tmpDoc.getFilePath());
	                                    			conversion.setOutputFile(tmpDoc.getFilePath() + ".tmp");
	                                    			conversion.setVersion(2);
	                                    			conversion.setTargetVersion(1);

	                                    			// Get the XSLT from database
	                                    			conversion.getConversionFromDB(conn);

	                                    			conversion.convert();

	                                    			tmpDoc.setFilePath(tmpDoc.getFilePath() + ".tmp");
                                            	} catch (Exception e) {
                                            		logger.error("Error while converting DVK container: ", e);
                                            	}
                                            }

                                            logger.debug("Splitting out file tag: 'SignedDoc' from file: " + tmpDoc.getFilePath());
                                            CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);

                                            // Tõidame DHL poolt automaatselt tõidetavad võljad
                                            appendAutomaticMetaData(
                                                tmpDoc.getFilePath(),
                                                tmpSending,
                                                tmpRecipient,
                                                tmpDoc,
                                                senderOrg,
                                                recipientOrg,
                                                conn,
                                                tmpDoc.getDvkContainerVersion());

                                            // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
                                            // faili koosseisu tagasi.
                                            logger.debug("Joining split XML.");
                                            logger.debug("PipelineDatafile: " + pipelineDataFile);
                                            logger.debug("Temporary XML file: " + tmpDoc.getFilePath());
                                            CommonMethods.joinSplitXML(tmpDoc.getFilePath(), bw);

                                            processedDocuments.add( tmpDoc.getId() );
                                        }
                                    }
                                }
                            }
                        }
                    } catch (AxisFault fault) {
                    	throw fault;
                    } catch (Exception ex) {
                    	logger.error(ex.getMessage(), ex);
                        throw new AxisFault("Error composing response message: " +" ("+ ex.getClass().getName() +": "+ ex.getMessage() +")");
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
                result.responseFile = CommonMethods.gzipPackXML(pipelineDataFile, user.getOrganizationCode(), "receiveDocuments" );
                t.markElapsed("Compressing response data");

                // Kui soovitakse vastust fragmenteeritud kujul, siis lammutame faili
                // tõkkideks ja salvestame tõkid saatmist ootama.
                if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr >= 0)) {
                	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                    FragmentationResult fragResult = DocumentFragment.getFragments(result.responseFile, bodyData.fragmentSizeBytes, user.getOrganizationID(), bodyData.edastusID, false, conn, xTeePais);
                    if ((fragResult != null) && (fragResult.firstFragmentFile != null) && (new File(fragResult.firstFragmentFile)).exists()) {
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

    public static RequestInternalResult V4(org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws Exception {
    	logger.info("ReceiveDocuments.V4 invoked.");

    	Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Laeme SOAP keha endale sobivasse andmestruktuuri
            t.reset();
            receiveDocumentsV4RequestType bodyData = receiveDocumentsV4RequestType.getFromSOAPBody( context );
            result.count = bodyData.arv;
            result.folders = bodyData.kaust;
            result.deliverySessionID = bodyData.edastusID;
            result.fragmentSizeBytes = bodyData.fragmentSizeBytesOrig;
            t.markElapsed("Parsing SOAP body");

            // Check if all requested folders really exist
            validateFolders(bodyData.kaust, user, conn);

            logger.debug("Starting receiveDocuments.V4 Request. Org: " + user.getOrganizationCode() + ", Personal ID: " + user.getPersonCode());

            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr > 0)) {
                DocumentFragment fragment = new DocumentFragment(user.getOrganizationID(), bodyData.edastusID, bodyData.fragmentNr, conn);
                result.responseFile = fragment.getFileName();
                result.fragmentNr = fragment.getFragmentNr();
                result.totalFragments = fragment.getFragmentCount();
            } else {
                t.reset();
                ArrayList<dhl.Document> documents = new ArrayList<dhl.Document>();
                if ((bodyData.kaust == null) || (bodyData.kaust.size() == 0)) {
                    // Leiame antud kasutajale saadetud dokumendid
                    logger.debug("Searching documents using following parameters: Org ID:  " + String.valueOf(user.getOrganizationID()) + ", Folder:  " + String.valueOf(Folder.UNSPECIFIED_FOLDER) + ", Person ID: " + String.valueOf(user.getPersonID()) + ", Subdivision SN: " + bodyData.allyksuseLyhinimetus + ", Occupation SN: " + bodyData.ametikohaLyhinimetus + ", Max documents: " + String.valueOf(bodyData.arv));
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
                    	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                        int requestTargetFolder = Folder.getFolderIdByPath( bodyData.kaust.get(folderNr).trim(), user.getOrganizationID(), conn, true, false, xTeePais );

                        // Leiame antud kasutajale saadetud dokumendid
                        logger.debug("Searching documents using following parameters: Org ID:  " + String.valueOf(user.getOrganizationID()) + ", Folder:  " + String.valueOf(requestTargetFolder) + ", Person ID: " + String.valueOf(user.getPersonID()) + ", Subdivision SN: " + bodyData.allyksuseLyhinimetus + ", Occupation SN: " + bodyData.ametikohaLyhinimetus + ", Max documents: " + String.valueOf(resultLimit));
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

                        // Lisame leitud dokumendid dokumentide tõisnimekirja
                        documents.addAll(tmpDocs);
                        tmpDocs = null;

                        // Kui maksimaalne lubatud vastuste hulk on kões, siis
                        // rohkem dokumente andmebaasist võlja ei võta
                        if (resultLimit <= 0) {
                            break;
                        }
                    }
                }
                t.markElapsed("Reading documents from DB");
                logger.info(String.valueOf(documents.size()) + " found.");

                // Pistame leitud dokumendid võljundisse
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
                                        tmpSending.loadByDocumentID( tmpDoc.getId(), conn );

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
                                            Asutus senderOrg = new Asutus( tmpSending.getSender().getOrganizationID(), conn );
                                            Asutus recipientOrg = new Asutus( tmpRecipient.getOrganizationID(), conn );

                                            // Viskame XML failist võlja suure mahuga SignedDoc elemendid
                                            //CommonMethods.splitOutTags(tmpDoc.getFilePath(), "SignedDoc", false, false, true);
                                            CommonMethods.splitOutTags(tmpDoc.getFilePath(), "failid", false, false, true);

                                            // Tõidame DHL poolt automaatselt tõidetavad võljad
                                            appendAutomaticMetaData(
                                                tmpDoc.getFilePath(),
                                                tmpSending,
                                                tmpRecipient,
                                                tmpDoc,
                                                senderOrg,
                                                recipientOrg,
                                                conn,
                                                tmpDoc.getDvkContainerVersion());

                                            // Paigaldame varem eraldatud SignedDoc elemendid uuesti XML
                                            // faili koosseisu tagasi.
                                            CommonMethods.joinSplitXML(tmpDoc.getFilePath(), bw);

                                            processedDocuments.add( tmpDoc.getId() );
                                        }
                                    }
                                }
                            }
                        }
                    } catch (AxisFault fault) {
                    	throw fault;
                    } catch (Exception ex) {
                    	logger.error(ex.getMessage(), ex);
                        throw new AxisFault( "Error composing response message: " +" ("+ ex.getClass().getName() +": "+ ex.getMessage() +")" );
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
                result.responseFile = CommonMethods.gzipPackXML(pipelineDataFile, user.getOrganizationCode(), "receiveDocuments" );
                logger.debug("result.responseFile: " + result.responseFile);
                t.markElapsed("Compressing response data");

                // Kui soovitakse vastust fragmenteeritud kujul, siis lammutame faili
                // tõkkideks ja salvestame tõkid saatmist ootama.
                if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("") && (bodyData.fragmentNr >= 0)) {
                	logger.debug("Vastust soovitakse fragmenteeritud kujul. Tükeldame faili.");
                	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                    FragmentationResult fragResult = DocumentFragment.getFragments(result.responseFile, bodyData.fragmentSizeBytes, user.getOrganizationID(), bodyData.edastusID, false, conn, xTeePais);
                    if ((fragResult != null) && (fragResult.firstFragmentFile != null) && (new File(fragResult.firstFragmentFile)).exists()) {

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
     * @param filePath              Tõõdeldava XML faili asukoht
     * @param sendingData           Dokumendi saatmise andmed
     * @param recipientData         Dokumenti hetkel vastuvõtva adressaadi andmed
     * @param documentData          Dokumendi saatja andmed
     * @param senderOrg             Dokumendi saatnud asutuse andmed
     * @param recipientOrg          Dokumenti hetkel vastuvõtva asutuse andmed
     * @throws Exception
     */
    private static void appendAutomaticMetaData(
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
        	throw new Exception("Failed to process XML contents of document " + documentData.getId() + "! Document XML is empty or invalid.");
        }

        Element metainfoNode = null;

        NodeList foundNodes = null;
        if(containerVersion == 1) {
        	foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(CommonStructures.DhlNamespace, "metainfo");
        } else {
        	foundNodes = currentXmlContent.getDocumentElement().getElementsByTagNameNS(CommonStructures.DhlNamespaceV2, "metainfo");
        }

        if (foundNodes != null && foundNodes.getLength() > 0) {
            metainfoNode = (Element)foundNodes.item(0);
        } else {
            String defaultPrefix = null;

            if(containerVersion == 1) {
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

            if(containerVersion == 1) {
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
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_id", String.valueOf(documentData.getId()), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saabumisviisi lisamine
        switch (sendingData.getReceivedMethodID()) {
            case CommonStructures.SendingMethod_EMail:
                metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saabumisviis", CommonStructures.SendingMethod_EMail_Name, prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            case CommonStructures.SendingMethod_XTee:
                metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saabumisviis", CommonStructures.SendingMethod_XTee_Name, prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            default:
                break;
        }

        // Saabumisaja lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saabumisaeg", CommonMethods.getDateISO8601(sendingData.getStartDate()), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatmisviisi lisamine
        switch (recipientData.getSendingMethodID()) {
            case CommonStructures.SendingMethod_EMail:
                metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saatmisviis", CommonStructures.SendingMethod_EMail_Name, prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            case CommonStructures.SendingMethod_XTee:
                metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saatmisviis", CommonStructures.SendingMethod_XTee_Name, prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);
                break;
            default:
                break;
        }

        // Saatmisaja lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saatmisaeg", CommonMethods.getDateISO8601(cal.getTime()), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja asutuse numbri lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saatja_asutuse_nr", senderOrg.getRegistrikood(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja asutuse nime lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saatja_asutuse_nimi", senderOrg.getNimetus(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja isikukoodi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saatja_isikukood", sendingData.getSender().getPersonalIdCode(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja asutuse numbri lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saaja_asutuse_nr", recipientOrg.getRegistrikood(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja asutuse nime lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saaja_asutuse_nimi", recipientOrg.getNimetus(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja isikukoodi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saaja_isikukood", recipientData.getPersonalIdCode(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saatja e-posti aadressi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saatja_epost", sendingData.getSender().getEmail(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Saaja e-posti aadressi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_saaja_epost", recipientData.getEmail(), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Dokumendi kausta aadressi lisamine
        metainfoNode = CommonMethods.appendTextNodeBefore(currentXmlContent, metainfoNode, "dhl_kaust", Folder.getFolderFullPath(documentData.getFolderID(), conn), prefix, CommonStructures.AutomaticMetadataNamespace, firstMetadataNode);

        // Salvestame muudetud XML andmed faili
        CommonMethods.xmlElementToFile(currentXmlContent.getDocumentElement(), filePath);
    }

    /**
     * Checks if folders specified in request actually exist. If non-existing
     * folders are found then throws an {@link AxisFault} containing list
     * of folders that do not exist.
     * @param folders
     *     List of folders from receiveDocuments request
     * @param user
     *     Current user
     * @param conn
     *     Active database connection
     * @throws AxisFault
     *     Error containing list of folders that do not exist
     */
    private static void validateFolders(final List<String> folders,
    	final UserProfile user, final Connection conn) throws AxisFault {
    	if ((folders != null) && (folders.size() > 0)) {
	    	List<String> nonExistingFolders = new ArrayList<String>();
    		XHeader xTeePais = new XHeader(user.getOrganizationCode(), null,
	    		null, null, null, null, user.getPersonCode());

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
