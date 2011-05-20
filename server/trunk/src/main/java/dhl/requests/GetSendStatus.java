package dhl.requests;

import dhl.iostructures.edastus;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dhl.Document;
import dhl.DocumentStatusHistory;
import dhl.Recipient;
import dhl.RemoteServer;
import dhl.Sending;
import dhl.iostructures.XHeader;
import dhl.iostructures.getSendStatusRequestType;
import dhl.iostructures.getSendStatusResponse;
import dhl.iostructures.getSendStatusV2RequestType;
import dhl.iostructures.getSendStatusV2ResponseType;
import dhl.users.Asutus;
import dhl.users.UserProfile;
import dvk.client.ClientAPI;
import dvk.client.businesslayer.DhlMessage;
import dvk.client.businesslayer.MessageRecipient;
import dvk.client.conf.OrgSettings;
import dvk.client.iostructures.GetSendStatusResponseItem;
import dvk.core.AttachmentExtractionResult;
import dvk.core.Fault;
import dvk.core.HeaderVariables;
import dvk.core.Settings;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import javax.xml.soap.SOAPException;

import org.apache.axis.AxisFault;
import org.apache.axis.MessageContext;
import org.apache.log4j.Logger;

public class GetSendStatus {
	static Logger logger = Logger.getLogger(GetSendStatus.class.getName());

    public static RequestInternalResult V1(MessageContext context,
    	Connection conn, UserProfile user, OrgSettings hostOrgSettings)
        throws AxisFault, IllegalArgumentException, IOException, SOAPException {

    	logger.info("GetSendStatus.V1 invoked.");

        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Lame SOAP keha endale sobivasse andmestruktuuri
            getSendStatusRequestType bodyData = getSendStatusRequestType.getFromSOAPBody( context );
            if (bodyData == null) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_KEHA);
            }

            AttachmentExtractionResult attachment = CommonMethods.getExtractedFileFromAttachment(context, bodyData.kehaHref);
            result.dataMd5Hash = attachment.getAttachmentHash();

            // Leiame kõik XML elemendid, mille nimi on "dhl_id"
            ArrayList<Document> docIDs = dhl.Document.sendingStatusFromXML(attachment.getExtractedFileName(), 1);

            try {
                FileOutputStream out = null;
                OutputStreamWriter ow = null;
                try {
                    out = new FileOutputStream(pipelineDataFile, false);
                    ow = new OutputStreamWriter(out, "UTF-8");
                    ow.write("<keha>");

                    // Leiame andmebaasist küsitud dokumentide staatuse
                    Sending sendingData = null;
                    dhl.iostructures.edastus tmpEdastus = null;
                    boolean isCanceled = false;
                    boolean isSent = false;
                    boolean isSending = false;
                    int docID = 0;
                    for (int i = 0; i < docIDs.size(); ++i) {
                    	Document doc = docIDs.get(i);
                        docID = doc.getId();
                        logger.info("Getting status information of document: id: " + String.valueOf(docID) + ", guid: " + doc.getGuid());

                        getSendStatusResponse resp = new getSendStatusResponse();
                        resp.dhl_id = docID;
                        isCanceled = false;
                        isSent = false;
                        isSending = false;

                        if (Settings.Server_RunOnClientDatabase) {
                            ArrayList<DhlMessage> msgList = DhlMessage.getByDhlID(docID, true, true, hostOrgSettings, conn);
                            if ((msgList != null) && !msgList.isEmpty()) {
                                boolean senderOK = false;
                                for (int j = 0; j < msgList.size(); ++j) {
                                    DhlMessage msg = msgList.get(j);
                                    senderOK = ((!Settings.Server_DocumentSenderMustMatchXroadHeader) || user.getOrganizationCode().equalsIgnoreCase(msg.getSenderOrgCode()) || user.getOrganizationCode().equalsIgnoreCase(msg.getProxyOrgCode()));
                                    isCanceled = isCanceled || (msg.getSendingStatusID() == Settings.Client_StatusCanceled);

                                    Recipient r = new Recipient();
                                    r.setDepartmentName(msg.getRecipientDepartmentName());
                                    r.setDepartmentNumber(msg.getRecipientDepartmentNr());
                                    r.setDivisionID(msg.getRecipientDivisionID());
                                    r.setEmail(msg.getRecipientEmail());
                                    Fault f = new Fault();
                                    f.setFaultActor(msg.getFaultActor());
                                    f.setFaultCode(msg.getFaultCode());
                                    f.setFaultDetail(msg.getFaultDetail());
                                    f.setFaultString(msg.getFaultString());
                                    if (((f.getFaultCode() == null) || (f.getFaultCode().trim().length() == 0))
                                        && ((f.getFaultActor() == null) || (f.getFaultActor().trim().length() == 0))
                                        && ((f.getFaultString() == null) || (f.getFaultString().trim().length() == 0))
                                        && ((f.getFaultDetail() == null) || (f.getFaultDetail().trim().length() == 0))) {
                                        f = null;
                                    }
                                    r.setFault(f);
                                    r.setId(0);
                                    r.setIdInRemoteServer(0);
                                    r.setMetaXML(msg.getMetaXML());
                                    r.setName(msg.getRecipientName());
                                    r.setOrganizationID(0);
                                    r.setOrganizationCode(msg.getRecipientOrgCode());
                                    r.setOrganizationName(msg.getProxyOrgName());
                                    r.setPersonalIdCode(msg.getRecipientPersonCode());
                                    r.setPositionID(msg.getRecipientPositionID());
                                    r.setRecipientStatusId(msg.getRecipientStatusID());
                                    r.setSendingEndDate(msg.getReceivedDate());
                                    r.setSendingStartDate(msg.getReceivedDate());
                                    r.setSendStatusID((msg.getSendingStatusID() == Settings.Client_StatusCanceled) ? CommonStructures.SendStatus_Canceled : CommonStructures.SendStatus_Sent);
                                    tmpEdastus = new dhl.iostructures.edastus(r, msg.getReceivedDate());
                                    resp.edastus.add(tmpEdastus);
                                }
                                if (isCanceled) {
                                    resp.olek = CommonStructures.SendStatus_Canceled_Name;
                                } else {
                                    resp.olek = CommonStructures.SendStatus_Sent_Name;
                                }

                                // Kui sõnumi saatnud asutus on sama, mis praegu sõnumi
                                // staatust päriv asutus, siis lisame antud dokumendi
                                // andmed vastuse XML-i.
                                if (senderOK) {
                                    resp.appendObjectXML(ow, conn);
                                }
                            }
                        } else {
                        	sendingData = new Sending();
                            sendingData.loadByDocumentID(docID, conn);

                            // Kontrollime, et sisseloginud kasutajal on õigus antud dokumentide
                            // kohta infot saada
                            if (sendingData.isStatusAccessibleToUser(user)) {
                                logger.debug("Document recipient count: " + sendingData.getRecipients().size());
                                for (Recipient r : sendingData.getRecipients()) {
                                    if (r.getIdInRemoteServer() > 0) {
                                        logger.debug("Recipient " + r.getOrganizationCode() + " status is stored in remote server.");

                                    	// Teeme staatuse päringu välisesse serverisse
                                        tmpEdastus = getSendStatusFromRemoteServer(r, conn);
                                        if (tmpEdastus != null) {
                                            // Save status information to local server
                                        	r.copyStatusInformationFromAnotherInstance(tmpEdastus.getSaaja());
                                        	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                                        	r.update(conn, xTeePais);

                                        	resp.edastus.add(tmpEdastus);
                                            isCanceled = isCanceled || (tmpEdastus.getSaaja().getSendStatusID() == CommonStructures.SendStatus_Canceled);
                                            isSent = isSent || (tmpEdastus.getSaaja().getSendStatusID() == CommonStructures.SendStatus_Sent);
                                            isSending = isSending || (tmpEdastus.getSaaja().getSendStatusID() == CommonStructures.SendStatus_Sending);
                                        }
                                    } else {
                                    	logger.debug("Recipient " + r.getOrganizationCode() + " status is stored in local server.");

                                    	tmpEdastus = new dhl.iostructures.edastus( r, sendingData.getStartDate() );
                                        resp.edastus.add( tmpEdastus );
                                        isCanceled = isCanceled || (r.getSendStatusID() == CommonStructures.SendStatus_Canceled);
                                        isSent = isSent || (r.getSendStatusID() == CommonStructures.SendStatus_Sent);
                                        isSending = isSending || (r.getSendStatusID() == CommonStructures.SendStatus_Sending);
                                    }
                                }
                                if (isCanceled) {
                                    resp.olek = CommonStructures.SendStatus_Canceled_Name;
                                } else if (isSending) {
                                    resp.olek = CommonStructures.SendStatus_Sending_Name;
                                } else if (isSent) {
                                    resp.olek = CommonStructures.SendStatus_Sent_Name;
                                }

                                resp.appendObjectXML(ow, conn);
                            } else {
                                logger.info("Current user does not have rights to get sending status of document: " + String.valueOf(docID));
                            }
                        }
                    }
                    ow.write("</keha>");
                } catch (AxisFault fault) {
                	throw fault;
                } catch (Exception ex) {
                    logger.error(ex.getMessage(), ex);
                    throw new AxisFault( "Error composing response message: " +" ("+ ex.getClass().getName() +": "+ ex.getMessage() +")" );
                } finally {
                    CommonMethods.safeCloseWriter(ow);
                    CommonMethods.safeCloseStream(out);
                    ow = null;
                    out = null;
                }
            } catch (AxisFault fault) {
                throw fault;
            } catch (Exception ex) {
            	logger.error(ex.getMessage(), ex);
                throw new AxisFault(ex.getMessage());
            }

            result.responseFile = CommonMethods.gzipPackXML(pipelineDataFile, user.getOrganizationCode(), "getSendStatus");
        } finally {
            (new File(pipelineDataFile)).delete();
        }
        return result;
    }

    public static RequestInternalResult V2(MessageContext context,
    	Connection conn, UserProfile user, OrgSettings hostOrgSettings)
    	throws AxisFault, Exception, IllegalArgumentException, IOException, SOAPException, SQLException {

    	logger.info("GetSendStatus.V2 invoked.");

    	RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Lame SOAP keha endale sobivasse andmestruktuuri
            getSendStatusV2RequestType bodyData = getSendStatusV2RequestType.getFromSOAPBody(context);
            if (bodyData == null) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_KEHA);
            }

            AttachmentExtractionResult attachment = CommonMethods.getExtractedFileFromAttachment(context, bodyData.dokumendidHref);
            result.dataMd5Hash = attachment.getAttachmentHash();

            // Leiame kõik XML elemendid, mille nimi on "dhl_id"
            ArrayList<Document> docIDs = dhl.Document.sendingStatusFromXML(attachment.getExtractedFileName(), 2);



            FileOutputStream out = null;
            OutputStreamWriter ow = null;
            try {
                out = new FileOutputStream(pipelineDataFile, false);
                ow = new OutputStreamWriter(out, "UTF-8");
                ow.write("<keha>");

                // Leiame andmebaasist küsitud dokumentide staatuse
                Sending sendingData = null;
                dhl.iostructures.edastus tmpEdastus = null;
                boolean isCanceled = false;
                boolean isSent = false;
                boolean isSending = false;

                for (int i = 0; i < docIDs.size(); ++i) {
                	int docID = 0;
                	Document doc = docIDs.get(i);
                    docID = doc.getId();
                    logger.info("Getting status information of document: id: " + String.valueOf(docID) + ", guid: " + doc.getGuid());

                    ArrayList<edastus> edastusList = new ArrayList<edastus>();
                    ArrayList<DocumentStatusHistory> historyList = new ArrayList<DocumentStatusHistory>();
                    String totalStatus = "";
                    isCanceled = false;
                    isSent = false;
                    isSending = false;

                    if (Settings.Server_RunOnClientDatabase) {
                    	logger.debug("Running on client database.");
                    	ArrayList<DhlMessage> msgList = null;
                    	if(docID != 0) {
                    		logger.debug("Fetching messagelist. dhl_id: " + docID);
                    		msgList = DhlMessage.getByDhlID(docID, true, true, hostOrgSettings, conn);
                    	} else {
                    		logger.debug("Fetching messagelist. GUID: " + doc.getGuid());
                    		msgList = DhlMessage.getByGUID(doc.getGuid(), true, true, hostOrgSettings, conn);
                    	}

                        if ((msgList != null) && !msgList.isEmpty()) {
                            boolean senderOK = false;
                            for (int j = 0; j < msgList.size(); ++j) {
                                DhlMessage msg = msgList.get(j);
                                senderOK = ((!Settings.Server_DocumentSenderMustMatchXroadHeader) || user.getOrganizationCode().equalsIgnoreCase(msg.getSenderOrgCode()) || user.getOrganizationCode().equalsIgnoreCase(msg.getProxyOrgCode()));
                                isCanceled = isCanceled || (msg.getSendingStatusID() == Settings.Client_StatusCanceled);

                                Recipient r = new Recipient();
                                r.setDepartmentName(msg.getRecipientDepartmentName());
                                r.setDepartmentNumber(msg.getRecipientDepartmentNr());
                                r.setDivisionID(msg.getRecipientDivisionID());
                                r.setEmail(msg.getRecipientEmail());
                                Fault f = new Fault();
                                f.setFaultActor(msg.getFaultActor());
                                f.setFaultCode(msg.getFaultCode());
                                f.setFaultDetail(msg.getFaultDetail());
                                f.setFaultString(msg.getFaultString());
                                if (((f.getFaultCode() == null) || (f.getFaultCode().trim().length() == 0))
                                    && ((f.getFaultActor() == null) || (f.getFaultActor().trim().length() == 0))
                                    && ((f.getFaultString() == null) || (f.getFaultString().trim().length() == 0))
                                    && ((f.getFaultDetail() == null) || (f.getFaultDetail().trim().length() == 0))) {
                                    f = null;
                                }
                                r.setFault(f);
                                r.setId(0);
                                r.setIdInRemoteServer(0);
                                r.setMetaXML(msg.getMetaXML());
                                r.setName(msg.getRecipientName());
                                r.setOrganizationID(0);
                                r.setOrganizationCode(msg.getRecipientOrgCode());
                                r.setOrganizationName(msg.getProxyOrgName());
                                r.setPersonalIdCode(msg.getRecipientPersonCode());
                                r.setPositionID(msg.getRecipientPositionID());
                                r.setRecipientStatusId(msg.getRecipientStatusID());
                                r.setSendingEndDate(msg.getReceivedDate());
                                r.setSendingStartDate(msg.getReceivedDate());
                                r.setSendStatusID((msg.getSendingStatusID() == Settings.Client_StatusCanceled) ? CommonStructures.SendStatus_Canceled : CommonStructures.SendStatus_Sent);
                                tmpEdastus = new dhl.iostructures.edastus(r, msg.getReceivedDate());
                                edastusList.add(tmpEdastus);
                            }
                            if (isCanceled) {
                            	totalStatus = CommonStructures.SendStatus_Canceled_Name;
                            } else {
                            	totalStatus = CommonStructures.SendStatus_Sent_Name;
                            }

                            // Kui rakendus töötab kliendi andmetabelite peal, siis
                            // pole vahet, kas küsiti ajalugu või mitte, kuna mingeid mõistlikke
                            // staatuse ajaloo andmeid pole niikuinii (ega isegi teki töö käigus).

                            // Kui sõnumi saatnud asutus on sama, mis praegu sõnumi
                            // staatust päriv asutus, siis lisame antud dokumendi
                            // andmed vastuse XML-i.
                            if (senderOK) {
                            	getSendStatusV2ResponseType.appendObjectXML(docID, doc.getGuid(), edastusList, historyList, totalStatus, ow, conn);
                            }
                        }
                    } else {
                    	logger.debug("Running on server database.");
                        sendingData = new Sending();

                        if (docID != 0) {
                        	logger.debug("Fetching sendingData. dhl_id: " + docID);
                        	sendingData.loadByDocumentID(docID, conn);
                        } else if (!CommonMethods.isNullOrEmpty(doc.getGuid())) {
                        	logger.debug("Fetching sendingData. GUID: " + doc.getGuid());
                        	sendingData.loadByDocumentGUID(doc.getGuid(), conn);
                        	docID = sendingData.getDocumentID();
                        }

                        // Kontrollime, et sisseloginud kasutajal on õigus antud dokumentide
                        // kohta infot saada
                        if (sendingData.isStatusAccessibleToUser(user)) {
                        	logger.debug("Document recipient count: " + sendingData.getRecipients().size());
                        	for (Recipient r : sendingData.getRecipients()) {
                                if (r.getIdInRemoteServer() > 0) {
                                    // Teeme staatuse päringu välisesse serverisse
                                    tmpEdastus = getSendStatusFromRemoteServer(r, conn);
                                    if (tmpEdastus != null) {
                                    	logger.debug("Recipient " + r.getOrganizationCode() + " status is stored in remote server.");

                                    	// Save status information to local server
                                    	r.copyStatusInformationFromAnotherInstance(tmpEdastus.getSaaja());
                                    	XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                                    	r.update(conn, xTeePais);

                                    	edastusList.add(tmpEdastus);
                                        isCanceled = isCanceled || (tmpEdastus.getSaaja().getSendStatusID() == CommonStructures.SendStatus_Canceled);
                                        isSent = isSent || (tmpEdastus.getSaaja().getSendStatusID() == CommonStructures.SendStatus_Sent);
                                        isSending = isSending || (tmpEdastus.getSaaja().getSendStatusID() == CommonStructures.SendStatus_Sending);
                                     }
                                } else {
                                	logger.debug("Recipient " + r.getOrganizationCode() + " status is stored in local server.");

                                	tmpEdastus = new dhl.iostructures.edastus(r, sendingData.getStartDate());
                                    edastusList.add(tmpEdastus);
                                    isCanceled = isCanceled || (r.getSendStatusID() == CommonStructures.SendStatus_Canceled);
                                    isSent = isSent || (r.getSendStatusID() == CommonStructures.SendStatus_Sent);
                                    isSending = isSending || (r.getSendStatusID() == CommonStructures.SendStatus_Sending);
                                }
                            }
                            if (isCanceled) {
                            	totalStatus = CommonStructures.SendStatus_Canceled_Name;
                            } else if (isSending) {
                            	totalStatus = CommonStructures.SendStatus_Sending_Name;
                            } else if (isSent) {
                            	totalStatus = CommonStructures.SendStatus_Sent_Name;
                            }

                            // Kui küsiti ka ajalugu, siis võtame andmebaasist välja
                            // antud dokumendi staatuse ajaloo.
                            if (bodyData.staatuseAjalugu) {
                            	historyList = DocumentStatusHistory.getList(docID, conn);
                            }

                            getSendStatusV2ResponseType.appendObjectXML(docID, doc.getGuid(), edastusList, historyList, totalStatus, ow, conn);
                        } else {
                            logger.info("Current user does not have rights to get sending status of document: " + String.valueOf(docID));
                        }
                    }
                }
                ow.write("</keha>");
            } finally {
                CommonMethods.safeCloseWriter(ow);
                CommonMethods.safeCloseStream(out);
                ow = null;
                out = null;
            }

            result.responseFile = CommonMethods.gzipPackXML(pipelineDataFile, user.getOrganizationCode(), "getSendStatus");
        } finally {
            (new File(pipelineDataFile)).delete();
        }
        return result;
    }

    public static edastus getSendStatusFromRemoteServer(Recipient recipient, Connection conn) throws Exception, IOException, SOAPException {
        edastus result = null;
        Asutus org = new Asutus(recipient.getOrganizationID(), conn);
        RemoteServer server = new RemoteServer(org.getServerID(), conn);
        if (org.getRegistrikood() == null) {
            org.setRegistrikood("");
        }
        if (recipient.getPersonalIdCode() == null) {
            recipient.setPersonalIdCode("");
        }

        ClientAPI dvkClient = new ClientAPI();
        dvkClient.initClient(server.getAddress(), server.getProducerName());
        HeaderVariables header = new HeaderVariables(
            Settings.Client_DefaultOrganizationCode,
            Settings.Client_DefaultPersonCode,
            "",
            (CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode) ? Settings.Client_DefaultPersonCode : "EE"+Settings.Client_DefaultPersonCode));

        ArrayList<DhlMessage> msgArray = new ArrayList<DhlMessage>();
        DhlMessage dhlMessage = new DhlMessage();
        dhlMessage.setDhlID(recipient.getIdInRemoteServer());

        msgArray.add(dhlMessage);



        // TODO: Kas siin peaks vajadusel ka ajaloo välja küsima?

        logger.debug("Requesting status of " + msgArray.size() + " documents from server: " + server.getProducerName() + "(" + server.getAddress() + ")");
        ArrayList<GetSendStatusResponseItem> statusResponse = dvkClient.getSendStatus(header, msgArray, 1, false);
        logger.debug("Remote server returned status information about " + statusResponse.size() + " documents.");

        if (statusResponse.size() > 0) {
            GetSendStatusResponseItem item = statusResponse.get(0);
            ArrayList<MessageRecipient> recArray = item.getRecipients();
            MessageRecipient recItem = null;
            for (int i = 0; i < recArray.size(); ++i) {
                MessageRecipient rec = recArray.get(i);
                if (rec.getRecipientOrgCode() == null) {
                    rec.setRecipientOrgCode("");
                }
                if (rec.getRecipientPersonCode() == null) {
                    rec.setRecipientPersonCode("");
                }
                if (rec.getRecipientOrgCode().equalsIgnoreCase(org.getRegistrikood()) &&
                    rec.getRecipientPersonCode().equalsIgnoreCase(recipient.getPersonalIdCode())) {
                    recItem = rec;
                    break;
                }
            }
            if (recItem != null) {
                Fault f = null;
                if (((recItem.getFaultActor() != null) && (!recItem.getFaultActor().equalsIgnoreCase(""))) ||
                    ((recItem.getFaultCode() != null) && (!recItem.getFaultCode().equalsIgnoreCase(""))) ||
                    ((recItem.getFaultDetail() != null) && (!recItem.getFaultDetail().equalsIgnoreCase(""))) ||
                    ((recItem.getFaultString() != null) && (!recItem.getFaultString().equalsIgnoreCase("")))) {
                    f = new Fault(recItem.getFaultCode(), recItem.getFaultActor(), recItem.getFaultString(), recItem.getFaultDetail());
                }
                recipient.setFault(f);
                recipient.setMetaXML(recItem.getMetaXML());
                recipient.setRecipientStatusId(recItem.getRecipientStatusID());
                recipient.setSendingEndDate(recItem.getReceivedDate());
                recipient.setSendingStartDate(recItem.getSendingDate());

                // Kuna staatused saadi kliendi vahendusel, siis tuleb siin kliendi
                // staatuste koodid serveri staatuse koodideks teisendada.
                if (recItem.getSendingStatusID() == Settings.Client_StatusCanceled) {
                    recipient.setSendStatusID(CommonStructures.SendStatus_Canceled);
                } else if (recItem.getSendingStatusID() == Settings.Client_StatusSent) {
                    recipient.setSendStatusID(CommonStructures.SendStatus_Sent);
                } else {
                    recipient.setSendStatusID(CommonStructures.SendStatus_Sending);
                }

                result = new edastus(recipient, recItem.getReceivedDate());
            }
        }
        return result;
    }
}
