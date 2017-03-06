package dvk.client;

import java.io.File;
import java.sql.Connection;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.xml.namespace.QName;

import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axis.Message;
import org.apache.axis.attachments.AttachmentPart;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.businesslayer.MessageRecipient;
import dvk.client.businesslayer.RequestLog;
import dvk.client.businesslayer.ResponseStatus;
import dvk.client.conf.OrgSettings;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
import dvk.client.iostructures.AditDocument;
import dvk.client.iostructures.AditGetSendStatusRequest;
import dvk.client.iostructures.AditGetSendStatusResponse;
import dvk.client.iostructures.AditGetSendStatusV1Body;
import dvk.client.iostructures.AditReciever;
import dvk.client.util.SoapMessageUtil;
import dvk.core.AttachmentExtractionResult;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.HeaderVariables;
import dvk.core.Settings;
import dvk.core.util.DVKServiceMethod;
import dvk.core.xroad.XRoadClient;
import dvk.core.xroad.XRoadHeader;
import dvk.core.xroad.XRoadService;

/**
 * @author Hendrik Pärna
 * @since 2.04.14
 */
public class AditGetSendStatusService {
	
    private static final Logger logger = Logger.getLogger(AditGetSendStatusService.class);

    private ClientAPI client;
    private AditGetSendStatusRequest aditGetSendStatusRequest = new AditGetSendStatusRequest();

    public AditGetSendStatusService(ClientAPI clientAPI) {
        this.client = clientAPI;
    }

    /**
     * Update all MessageRecipient.opened column values which have been sent to ADIT.
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
                String queryId = "dvkAdit" + headerVar.getOrganizationCode() + (new Date()).getTime();

                XRoadHeader xRoadHeader = createXRoadHeader(headerVar, db.getDvkSettings().getAditGetSendStatusRequestVersion(), queryId);

                List<MessageRecipient> messageRecipients = null;
                try {
                    messageRecipients = MessageRecipient.findMessageRecipientsRelatedWithAdit(db, dbConnection);
                    if (logger.isInfoEnabled()) {
                        logger.info("Leitud " + messageRecipients.size() + " Adit'is avamata sõnumit!");
                    }

                    if (messageRecipients.size() > 0) {
                    	// The request name is used in the old X-Road message protocol 2.0 format to compactly save it in the related logs
                    	String requestName = xRoadHeader.getService();
                    	
                        Message response = sendAndRecieveRequestToAdit(messageRecipients, xRoadHeader, headerVar, requestName);

                        AttachmentExtractionResult responseData = CommonMethods.getExtractedFileFromAttachmentWithoutDocumentHeader(response);
                        if (responseData != null) {
                            String fileName = responseData.getExtractedFileName();
                            if ((fileName != null) && (fileName.length() > 0) && (new File(fileName)).exists()) {
                                Document xmlDoc = CommonMethods.xmlDocumentFromFile(fileName, true);
                                AditGetSendStatusResponse parsedResponse = AditGetSendStatusResponse.fromXML(xmlDoc.getDocumentElement());

                                if (parsedResponse != null) {
                                    updateOpenedDateFor(parsedResponse, db, dbConnection);
                                }
                            }
                        }
                    }
                } catch (Exception e) {
                    logger.error("DVK kliendi töös tekkis viga! " + e.getMessage());
                    ErrorLog errorLog = new ErrorLog(e, "dvk.client.Client" + " main");
                    LoggingService.logError(errorLog);
                } finally {
                    CommonMethods.safeCloseDatabaseConnection(dbConnection);
                    DatabaseSessionService.getInstance().clearSession();
                }
            }
        }
    }

    protected void updateOpenedDateFor(AditGetSendStatusResponse parsedResponse, OrgSettings orgSettings, Connection dbConnection) {
         for (AditDocument aditDocument: parsedResponse.aditDocuments) {
             for (AditReciever aditReciever: aditDocument.aditRecievers) {
                 if (aditReciever.opened && aditReciever.openedDate != null) {
                     int dhlId = aditDocument.dhlId;
                     MessageRecipient.updateOpenedDate(dhlId, aditReciever.personIdCode, aditReciever.openedDate, orgSettings, dbConnection);
                 }
             }
         }
    }

    private Message sendAndRecieveRequestToAdit(List<MessageRecipient> messageRecipients, XRoadHeader xRoadHeader, HeaderVariables headerVar, String requestName) throws Exception {
        File tempFileWithRequest = aditGetSendStatusRequest.createAndSaveTempFile(messageRecipients, UUID.randomUUID().toString());

        AditGetSendStatusV1Body requestBody = new AditGetSendStatusV1Body();
        requestBody.keha = tempFileWithRequest.getName();
        SOAPEnvelope soapEnvelope = SoapMessageUtil.getSOAPEnvelope(xRoadHeader, requestBody.getBodyContentsAsText());

        return runAditGetSendStatusRequest(soapEnvelope, tempFileWithRequest, headerVar, requestName);
    }
    
    private XRoadHeader createXRoadHeader(HeaderVariables headerVar, int requestVersion, String queryId) {
    	XRoadClient xRoadClient = new XRoadClient(headerVar.getXRoadClientInstance(), headerVar.getXRoadClientMemberClass(), headerVar.getOrganizationCode(), headerVar.getXRoadClientSubsystemCode());
	  	XRoadService xRoadService = new XRoadService(
	  			Settings.getAditXRoadServiceInstance(),
	  			Settings.getAditXRoadServiceMemberClass(),
	  			Settings.getAditXRoadServiceMemberCode(),
	  			Settings.getAditXRoadServiceSubsystemCode(),
	  			DVKServiceMethod.GET_SEND_STATUS.getName(),
	  			String.valueOf(requestVersion));
	      
	      return new XRoadHeader(xRoadClient, xRoadService, queryId, headerVar.getPIDWithCountryCode(), headerVar.getCaseName());
	}

    private HeaderVariables createHeaderVariables() {
    	
        return new HeaderVariables(
        		Settings.getXRoadClientMemberCode(),
                Settings.Client_DefaultPersonCode,
                "",
                CommonMethods.personalIDCodeHasCountryCode(
                        Settings.Client_DefaultPersonCode)
                            ? Settings.Client_DefaultPersonCode : "EE" + Settings.Client_DefaultPersonCode,
                Settings.getXRoadClientInstance(),
                Settings.getXRoadClientMemberClass(),
                Settings.getXRoadClientSubsystemCode());
    }

    private Message runAditGetSendStatusRequest(SOAPEnvelope soapEnvelope, File attachmentFile, HeaderVariables headerVar, String requestName) {
        if (attachmentFile == null || !attachmentFile.exists()) {
            throw new IllegalArgumentException("AttachmentFile is missing!");
        }

        try {
            Message msg = new Message(soapEnvelope.toString());
            client.getCall().setOperationName(new QName(CommonStructures.NS_ADIT_URI, "getSendStatus"));

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
            errorLog.setAdditionalInformation("SOAP message body: " + soapEnvelope.toString());
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
