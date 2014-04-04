package dvk.client;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.businesslayer.MessageRecipient;
import dvk.client.businesslayer.RequestLog;
import dvk.client.businesslayer.ResponseStatus;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
import dvk.client.iostructures.*;
import dvk.core.*;
import org.apache.axis.Message;
import org.apache.axis.attachments.AttachmentPart;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.xml.namespace.QName;
import java.io.File;
import java.sql.Connection;
import java.util.Date;
import java.util.List;
import java.util.UUID;

/**
 * @author Hendrik Pärna
 * @since 2.04.14
 */
public class AditGetSendStatusService {
    static Logger logger = Logger.getLogger(AditGetSendStatusService.class);

    private String producerName;
    private ClientAPI client;
    private AditGetSendStatusRequest aditGetSendStatusRequest = new AditGetSendStatusRequest();

    public AditGetSendStatusService(final String producerName, ClientAPI clientAPI) {
        this.producerName = producerName;
        this.client = clientAPI;
    }

    /**
     * Update all MessageRecipient.opened column values which have been sent to Adit.
     *
     * @param currentDatabases all configured databases.
     */
    public void updateAditSendStatusFor(List<OrgSettings> currentDatabases) {
        if (currentDatabases == null) {
           throw new IllegalArgumentException("No databases configured");
        }

        for (OrgSettings db : currentDatabases) {
            Connection dbConnection = client.getSafeDbConnection(db);

            client.setOrgSettings(db.getDvkSettings());

            if (dbConnection != null) {

                String secureServer = db.getDvkSettings().getServiceUrl();
                if ((secureServer == null) || secureServer.equalsIgnoreCase("")) {
                    secureServer = Settings.Client_ServiceUrl;
                }

                try {
                    client.setServiceURL(secureServer);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }


                HeaderVariables headerVar = createHeaderVariables();

                String requestName = this.producerName + ".getSendStatus.v" + db.getDvkSettings().getAditGetSendStatusRequestVersion();
                String queryId = "dvkAdit" + headerVar.getOrganizationCode() + (new Date()).getTime();

                // Saadetava sõnumi päisesse kantavad parameetrid
                XHeader xHeader = createXHeader(headerVar, requestName, queryId);

                List<MessageRecipient> messageRecipients = null;

                try {
                    messageRecipients = MessageRecipient.
                            findMessageRecipientsRelatedWithAdit(db, dbConnection);
                    if (logger.isInfoEnabled()) {
                        logger.info("Leitud " + messageRecipients.size() + " Adit'is avamata sõnumit!");
                    }

                    if (messageRecipients.size() > 0) {
                        Message response = sendAndRecieveRequestToAdit(
                                messageRecipients, xHeader, headerVar, requestName);

                        AttachmentExtractionResult responseData = CommonMethods.getExtractedFileFromAttachment(response);
                        if (responseData != null) {
                            String fileName = responseData.getExtractedFileName();
                            if ((fileName != null) && (fileName.length() > 0) && (new File(fileName)).exists()) {
                                Document xmlDoc = CommonMethods.xmlDocumentFromFile(fileName, true);
                                AditGetSendStatusResponse parsedResponse = AditGetSendStatusResponse.fromXML((Element) xmlDoc);

                                if (parsedResponse != null) {
                                    updateOpenedDateFor(parsedResponse, db, dbConnection);
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    System.out.println("DVK kliendi töös tekkis viga! " + e.getMessage());
                    ErrorLog errorLog = new ErrorLog(e, "dvk.client.Client" + " main");
                    LoggingService.logError(errorLog);
                } finally {
                    CommonMethods.safeCloseDatabaseConnection(dbConnection);
                    DatabaseSessionService.getInstance().clearSession();
                }
            }
        }
    }

    protected void updateOpenedDateFor(
            AditGetSendStatusResponse parsedResponse, OrgSettings orgSettings, Connection dbConnection) {
         for (AditDocument aditDocument: parsedResponse.aditDocuments) {

             for (AditReciever aditReciever: aditDocument.aditRecievers) {
                 if (aditReciever.opened && aditReciever.openedDate != null) {
                     int dhlId = aditDocument.dhlId;
                     String personIdCode = aditReciever.personIdCode.substring(2);

                     MessageRecipient.updateOpenedDate(
                             dhlId, personIdCode, aditReciever.openedDate, orgSettings, dbConnection);
                 }
             }
         }
    }

    private Message sendAndRecieveRequestToAdit(
            List<MessageRecipient> messageRecipients, XHeader xHeader,
            HeaderVariables headerVar, String requestName) {

        File tempFileWithRequest = aditGetSendStatusRequest.createAndSaveTempFile(
                messageRecipients, UUID.randomUUID().toString());

        AditGetSendStatusV1Body requestBody = new AditGetSendStatusV1Body();
        requestBody.keha = tempFileWithRequest.getName();
        String messageData = (new SoapMessageBuilder(xHeader, requestBody.getBodyContentsAsText())).getMessageAsText();

        return runAditGetSendStatusRequest(
                messageData, tempFileWithRequest, headerVar, requestName);
    }

    private XHeader createXHeader(HeaderVariables headerVar, String requestName, String queryId) {
        return new AditXHeader(Settings.CLIENT_ADIT_INFORMATION_SYSTEM_NAME,
                headerVar.getOrganizationCode(),
                this.producerName,
                headerVar.getPersonalIDCode(),
                queryId,
                requestName,
                headerVar.getCaseName(),
                headerVar.getPIDWithCountryCode());
    }

    private HeaderVariables createHeaderVariables() {
        return new HeaderVariables(
                Settings.Client_DefaultOrganizationCode,
                Settings.Client_DefaultPersonCode,
                "",
                CommonMethods.personalIDCodeHasCountryCode(
                        Settings.Client_DefaultPersonCode)
                            ? Settings.Client_DefaultPersonCode : "EE" + Settings.Client_DefaultPersonCode);
    }

    private Message runAditGetSendStatusRequest(
            String messageData, File attachmentFile, HeaderVariables headerVar, String requestName) {
        if (attachmentFile == null || !attachmentFile.exists()) {
            throw new IllegalArgumentException("AttachmentFile is missing!");
        }

        try {
            Message msg = new Message(messageData);
            client.getCall().setOperationName(new QName(CommonStructures.NS_ADIT_MAIN, "getSendStatus"));

            FileDataSource ds = new FileDataSource(attachmentFile);
            DataHandler d1 = new DataHandler(ds);
            AttachmentPart a1 = new AttachmentPart(d1);
            a1.setContentId(attachmentFile.getName());
            a1.setMimeHeader("Content-Transfer-Encoding", "base64");
            a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
            a1.addMimeHeader("Content-Encoding", "gzip");
            msg.addAttachmentPart(a1);
            //msg.getMimeHeaders().setHeader("Content-Type", "multipart/related;charset=utf-8");
            //msg.getMimeHeaders().setHeader("Content-Type", "multipart/related;charset=utf-8");

            msg.saveChanges();

            // Käivitame päringu
            client.getCall().invoke(msg);

            // Vastuse töötlemine
            Message response = client.getCall().getResponseMessage();

            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

            if (response != null && response.getAttachments() != null && response.getAttachments().hasNext()) {
                requestLog.setResponse(ResponseStatus.OK.toString());
            } else {
                requestLog.setResponse(ResponseStatus.NOK.toString());
            }

            LoggingService.logRequest(requestLog);

            return response;
        } catch (Exception ex) {
            // Vea puhul logime vea pähjustanud SOAP sänumi keha
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " runAditGetSendStatusRequest");
            errorLog.setAdditionalInformation("SOAP message body: " + messageData);
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            int errorLogId = LoggingService.logError(errorLog);
            if (errorLogId != -1) {
                requestLog.setErrorLogId(errorLogId);
            }
            requestLog.setResponse(ResponseStatus.NOK.toString());
            LoggingService.logRequest(requestLog);
        }
        return null;
    }


}
