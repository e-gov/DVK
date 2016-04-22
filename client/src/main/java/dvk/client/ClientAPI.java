package dvk.client;

import dvk.client.businesslayer.*;

import dvk.client.conf.OrgDvkSettings;
import dvk.client.conf.OrgSettings;
import dvk.client.db.DBConnection;
import dvk.client.db.UnitCredential;
import dvk.client.dhl.service.DatabaseSessionService;
import dvk.client.dhl.service.LoggingService;
import dvk.client.iostructures.*;
import dvk.core.AttachmentExtractionResult;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.FileSplitResult;
import dvk.core.HeaderVariables;
import dvk.core.Fault;
import dvk.core.Settings;
import dvk.core.ShortName;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.net.URL;
import java.security.Security;
import java.sql.Connection;
import java.util.*;

import javax.activation.DataHandler;
import javax.activation.DataSource;
import javax.activation.FileDataSource;
import javax.xml.namespace.QName;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPException;

import org.apache.axis.AxisFault;
import org.apache.axis.Message;
import org.apache.axis.MessageContext;
import org.apache.axis.attachments.AttachmentPart;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import org.apache.axis.transport.http.HTTPConstants;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ClientAPI {
	//static Logger logger = Logger.getLogger(ClientAPI.class.getName());
    private Service service;
    private Call call;
    private OrgDvkSettings orgSettings;
    private ArrayList<String> tempFiles;
    private String queryId; // viimase X-tee päringu ID
    private String producerName; // andmekogu nimetus (kui suhtlus käib äle X-tee)
    private ArrayList<OrgSettings> allKnownDatabases;
    static Logger logger = LogManager.getLogger(ClientAPI.class.getName());
    public void setOrgSettings(OrgDvkSettings value) {
        this.orgSettings = value;
    }
     
    public void setServiceURL(String value) throws Exception {
        this.call.setTargetEndpointAddress(new URL(value));
    }
    
    public String getServiceURL() {
        return this.call.getTargetEndpointAddress();
    }
    
    public void setProducerName(String value) {
        this.producerName = value;
    }
    
    public String getProducerName() {
        return this.producerName;
    }

    public String getQueryId() {
        return queryId;
    }
    
    public ArrayList<OrgSettings> getAllKnownDatabases() {
		return allKnownDatabases;
	}

	public void setAllKnownDatabases(ArrayList<OrgSettings> allKnownDatabases) {
		this.allKnownDatabases = allKnownDatabases;
	}
	
    public void initClient(String serverURL, String producer) throws Exception {
    	logger.debug("Initializing SOAP client for URL \"" + serverURL + "\" and x-road producer \"" + producer + "\"");
    	
        // Kui klient on seadistatud töötama HTTPS ühendusega,
        // siis teeme konfiguratsioonis vajalikud muudatused
    	URL url = new URL(serverURL);
        if (url.getProtocol().equalsIgnoreCase("https")) {
        	System.setProperty("java.protocol.handler.pkgs", "com.sun.net.ssl.internal.www.protocol");
        	Security.addProvider(new com.sun.net.ssl.internal.ssl.Provider());
        	
        	System.setProperty("javax.net.ssl.keyStore", Settings.Client_KeyStoreFile);
        	System.setProperty("javax.net.ssl.trustStore", Settings.Client_TrustStoreFile);
        	System.setProperty("javax.net.ssl.keyStorePassword", Settings.Client_KeyStorePassword);
        	System.setProperty("javax.net.ssl.trustStorePassword", Settings.Client_TrustStorePassword);
        	System.setProperty("javax.net.ssl.keyStoreType", Settings.Client_KeyStoreType);
        	System.setProperty("javax.net.ssl.trustStoreType", Settings.Client_TrustStoreType);
        }
    	
    	this.tempFiles = new ArrayList<String>();
        this.service = new Service();
        this.producerName = producer;
        this.call = (Call) service.createCall();
        this.call.setTargetEndpointAddress(new URL(serverURL));
        
        // Otsustame, kas saadame SOAPAction päise
        if ((producerName != null) && !producerName.equalsIgnoreCase("")) {
            this.call.setUseSOAPAction(true);
            this.call.setSOAPActionURI("http://producers." + this.producerName + ".xtee.riik.ee/producer/" + this.producerName);
        } else {
            this.call.setUseSOAPAction(true);
        }
        this.call.setProperty(MessageContext.HTTP_TRANSPORT_VERSION, HTTPConstants.HEADER_PROTOCOL_V11);
        
        
    }
    
    
    
    /**
     * DVK getSendStatus päringu käivitamine.
     * Kontrollib DVK keskserverist saadetud dokumentide staatusi.
     * 
     * @param headerVar			Päringu X-Tee päistesse kantavad andmed
     * @param messages			Dokumentide DVK ID-d
     * @return
     * @throws Exception
     */
    public ArrayList<GetSendStatusResponseItem> getSendStatus(HeaderVariables headerVar, ArrayList<DhlMessage> messages, boolean getStatusHistory) throws FileNotFoundException, IOException, SOAPException {
        return getSendStatus(headerVar, messages, orgSettings.getGetSendStatusRequestVersion(), getStatusHistory);
    }
    
    public ArrayList<GetSendStatusResponseItem> getSendStatus(HeaderVariables headerVar, ArrayList<DhlMessage> messages, int requestVersion, boolean getStatusHistory) throws FileNotFoundException, IOException, SOAPException {
    	logger.debug("Updating send status for sent messages.");
        FileOutputStream outStream = null;
        OutputStreamWriter outWriter = null;
        BufferedWriter writer = null;
        ArrayList<GetSendStatusResponseItem> result = null;

        String requestName = null;

        try {
            // Manuse ID
            String attachmentName = String.valueOf(System.currentTimeMillis());

            if (!messages.isEmpty()) {
                // Päringu nimi
                requestName = this.producerName + ".getSendStatus.v" + String.valueOf(requestVersion);
            	logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele GetSendStatus(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
                		+" isikukood:" + headerVar.getPersonalIDCode());
                // Päringu ID koostamine
                queryId =  "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());
                
                // Määrame X-Tee päise väärtused
                DvkXHeader header = new DvkXHeader(
                    headerVar.getOrganizationCode(),
                    this.producerName,
                    headerVar.getPersonalIDCode(),
                    queryId,
                    requestName,
                    headerVar.getCaseName(),
                    headerVar.getPIDWithCountryCode());

                // Väljundfail
                String attachmentFile = CommonMethods.createPipelineFile(0);
                outStream = new FileOutputStream(attachmentFile, false);
                outWriter = new OutputStreamWriter(outStream, "UTF-8");
                writer = new BufferedWriter(outWriter);

                // Koostame sänumi sisu
                ArrayList<Integer> processedIDs = new ArrayList<Integer>();
                for (int i = 0; i < messages.size(); ++i) {
                	DhlMessage dhlMessage = messages.get(i);
                	if(requestVersion > 1) {
                		 if (!processedIDs.contains(dhlMessage.getDhlID())) {
                			 writer.write("<item>");
                             writer.write("<dhl_id>" + String.valueOf(dhlMessage.getDhlID()) + "</dhl_id>");
                             writer.write("<dokument_guid>" + dhlMessage.getDhlGuid() + "</dokument_guid>");
                             writer.write("</item>");
                             processedIDs.add(dhlMessage.getDhlID());
                         }
                	} else {
                		if (!processedIDs.contains(dhlMessage.getDhlID())) {
                            writer.write("<dhl_id>" +  String.valueOf(dhlMessage.getDhlID()) + "</dhl_id>");
                            processedIDs.add(dhlMessage.getDhlID());
                        }
                	}                   
                }
                processedIDs = null;

                // Väljundstreamid kinni
                CommonMethods.safeCloseWriter(writer);
                CommonMethods.safeCloseWriter(outWriter);
                CommonMethods.safeCloseStream(outStream);

                // Koostame SOAP sänumi keha
                String messageData = "";
                switch (requestVersion) {
                	case 1:
                		GetSendStatusBody b = new GetSendStatusBody();
                		b.keha = attachmentName;
                		messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                		break;
                	case 2:
                		GetSendStatusV2Body b2 = new GetSendStatusV2Body();
                		b2.dokumendidHref = attachmentName;
                		b2.staatuseAjalugu = getStatusHistory;
                		messageData = (new SoapMessageBuilder(header, b2.getBodyContentsAsText())).getMessageAsText();
                		break;
                	default:
                		throw new IllegalArgumentException("Request version getSendStatus.v" + String.valueOf(requestVersion) + " does not exist!");
                }
                
                Message msg = new Message(messageData);
                call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "getSendStatus"));

                // Lisame sänumile manuse
                String tmpFile = CommonMethods.gzipPackXML(attachmentFile, headerVar.getOrganizationCode(), "getSendStatus");
                (new File(attachmentFile)).delete();
                tempFiles.add(tmpFile);
                FileDataSource ds = new FileDataSource(tmpFile);
                DataHandler d1 = new DataHandler(ds);
                AttachmentPart a1 = new AttachmentPart(d1);
                a1.setContentId(attachmentName);
                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                a1.addMimeHeader("Content-Encoding", "gzip");
                msg.addAttachmentPart(a1);
                msg.saveChanges();

                logger.debug("Calling service...");
                call.invoke(msg);
                
                logger.debug("Got response message. Processing...");
                // Teeme vastussänumi andmetest omad järeldused
                Message respMessage = call.getResponseMessage();

                RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

                if (respMessage != null) {
                    SOAPBody body = respMessage.getSOAPBody();
                    NodeList nList = body.getElementsByTagName("keha");
                    if (nList.getLength() > 0) {
                        Element msgBodyNode = (Element)nList.item(0);
                        if (msgBodyNode != null
                                && respMessage.getAttachments() != null
                                && respMessage.getAttachments().hasNext()) {
                            requestLog.setResponse(ResponseStatus.OK.toString());
                        } else {
                            requestLog.setResponse(ResponseStatus.NOK.toString());
                        }
                    }
                } else {
                    requestLog.setResponse(ResponseStatus.NOK.toString());
                }

                // harutame päringu vastuse lahti
                result = extractGetSendStatusResponse(respMessage);
                LoggingService.logRequest(requestLog);
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " getSendStatus");
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            int errorLogId = LoggingService.logError(errorLog);
            if (errorLogId != -1) {
                requestLog.setErrorLogId(errorLogId);
            }
            requestLog.setResponse(ResponseStatus.NOK.toString());
            LoggingService.logRequest(requestLog);
        } finally {
            CommonMethods.safeCloseWriter(writer);
            CommonMethods.safeCloseWriter(outWriter);
            CommonMethods.safeCloseStream(outStream);
        }
        return result;
    }

    /**
     * Harutab lahti getSendStatus päringu vastuseks saadud XML-i.
     * 
     */
    public ArrayList<GetSendStatusResponseItem> extractGetSendStatusResponse(Message response) throws SOAPException, AxisFault {
    	logger.debug("Extracting SendStatus response message.");
        ArrayList<GetSendStatusResponseItem> result = new ArrayList<GetSendStatusResponseItem>();
        String attachmentFile = null;
        Document xmldoc = null;
        NodeList nodes = null;
        try {
        	AttachmentExtractionResult attachment = CommonMethods.getExtractedFileFromAttachment(response);
        	attachmentFile = attachment.getExtractedFileName();
        	xmldoc = CommonMethods.xmlDocumentFromFile(attachmentFile, true);
            nodes = xmldoc.getElementsByTagName("item");
            for (int i = 0; i < nodes.getLength(); ++i) {
                GetSendStatusResponseItem item = GetSendStatusResponseItem.fromXML((Element)nodes.item(i));
                result.add(item);
            }        	
        } finally {
            if ((attachmentFile != null) && !attachmentFile.equalsIgnoreCase("")) {
                (new File(attachmentFile)).delete();
            }
            xmldoc = null;
            nodes = null;
        }
        
        return result;
    }

    public int sendDocuments(HeaderVariables headerVar, DhlMessage message) throws Exception {
        return sendDocuments(headerVar, message, orgSettings.getSendDocumentsRequestVersion());
    }
    
    public int sendDocuments(HeaderVariables headerVar, DhlMessage message, int requestVersion) throws Exception {
        // Manuse ID
        String attachmentName = String.valueOf((new Date()).getTime());
        
        // Päringu nimi
        String requestName = this.producerName + ".sendDocuments.v" + String.valueOf(requestVersion);
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele SendDocuments(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
        		+" isikukood:" + headerVar.getPersonalIDCode());
        // Päringu ID koostamine
        queryId = "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());
        
        // Saadetava sänumi päisesse kantavad parameetrid
        DvkXHeader header = new DvkXHeader(
            headerVar.getOrganizationCode(),
            this.producerName,
            headerVar.getPersonalIDCode(),
            queryId,
            requestName,
            headerVar.getCaseName(),
            headerVar.getPIDWithCountryCode());

        // Pakime dokumendi faili kokku
        String tmpFile = CommonMethods.gzipPackXML(message.getFilePath(), headerVar.getOrganizationCode(), "sendDocuments");
        tempFiles.add(tmpFile);
        
        if (requestVersion >= 2) {
            File f = new File(tmpFile);
            
            SendDocumentsV2Body b = new SendDocumentsV2Body();
            b.dokumendid = attachmentName;
            logger.debug("Kaust: " + b.kaust);
            b.kaust = message.getDhlFolderName();
            
            Calendar cal = Calendar.getInstance();
            cal.setTime(new Date());
            cal.add(Calendar.DAY_OF_YEAR, Settings.Client_SentMessageDefaultLifetime);
            b.sailitustahtaeg = cal.getTime();
            
            if(Settings.Client_UseFragmenting && (f.length() > Settings.Client_FragmentSizeBytes)) {
                ArrayList<String> fragmentFiles = CommonMethods.splitFileBySize(tmpFile, Settings.Client_FragmentSizeBytes);
                b.fragmenteKokku = fragmentFiles.size();
                b.edastusID = headerVar.getOrganizationCode() + String.valueOf(message.getId());
                int resultID = 0;
                for (int i = 0; i < b.fragmenteKokku; ++i) {
                    b.fragmentNr = i;
                    String messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                    resultID = runSendDocumentsRequest(messageData, fragmentFiles.get(i), attachmentName, headerVar, requestName);
                }
                return resultID;
            } else {
                b.edastusID = "";
                b.fragmenteKokku = 0;
                b.fragmentNr = -1;
                String messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                return runSendDocumentsRequest(messageData, tmpFile, attachmentName,  headerVar, requestName);
            }
        } else {
            // Koostame SOAP sänumi keha
            SendDocumentsBody b = new SendDocumentsBody();
            b.dokumendid = attachmentName;
            b.kaust = message.getDhlFolderName();
            String messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
            return runSendDocumentsRequest(messageData, tmpFile, attachmentName,  headerVar, requestName);
        }
    }
    
    public int sendDocumentFromDbToDb(DhlMessage message, OrgSettings sourceDb, Connection sourceDbConnection) throws Exception {
    	int result = 0;
    	
    	if ((message != null) && (sourceDb != null) && (message.getDeliveryChannel() != null)) {
	    	OrgSettings targetDb = message.getDeliveryChannel().getDatabase();
	    	MessageRecipient rec = message.getDeliveryChannel().getRecipient();
	    	
	    	if ((targetDb != null) && (rec != null)) {
		    	Connection targetDbConnection = null;
		    	try {
			    	DhlMessage recipientSideMessage = (DhlMessage)message.clone();
			
			    	// Nullime sänumi ID (kirje primaarväti andmebaasis), et
			    	// me sihtbaasis mända olemasolevat kirjet äle ei kirjutaks
			    	recipientSideMessage.setId(0);
			    	
			    	// Dokumendi DVK ID on praeguseks hetkske loodetavasti juba
			    	// keskserverist saadud ja sänumi käljes ilusti olemas.
			    	// S.t. teise andmebaasi kirjutatavad andmed tulevad kloonimisel
			    	
			    	// Märgime dokumendi sissetulevaks dokumendiks ja
			    	// määrame ära dokumendi unit_id vastuvätja andmebaasis.
			    	recipientSideMessage.setIsIncoming(true);
			    	recipientSideMessage.setUnitID(message.getDeliveryChannel().getUnitId());
			    	
			    	// Täidame adressaadi andmed
			    	recipientSideMessage.setRecipientOrgCode(rec.getRecipientOrgCode());
			    	recipientSideMessage.setRecipientOrgName(rec.getRecipientOrgName());
			    	recipientSideMessage.setRecipientPersonCode(rec.getRecipientPersonCode());
			    	recipientSideMessage.setRecipientName(rec.getRecipientName());
			    	recipientSideMessage.setRecipientDivisionID(rec.getRecipientDivisionID());
			    	recipientSideMessage.setRecipientDivisionCode(rec.getRecipientDivisionCode());
			    	recipientSideMessage.setRecipientDivisionName(rec.getRecipientDivisionName());
			    	recipientSideMessage.setRecipientPositionID(rec.getRecipientPositionID());
			    	recipientSideMessage.setRecipientPositionCode(rec.getRecipientPositionCode());
			    	recipientSideMessage.setRecipientPositionName(rec.getRecipientPositionName());
			    	
			    	// Saatmise ja vastuvätmise kuupäevad
			    	Date now = new Date();
			    	recipientSideMessage.setSendingDate(now);
			    	recipientSideMessage.setReceivedDate(now);
			    	
			    	// Open connection to target database
			    	targetDbConnection = DBConnection.getConnection(targetDb);
			    	
			    	// Märgime adressaadi poolel staatuseks, et tegemist on saabunud sõnumiga
			    	Classifier statusSent = new Classifier("STATUS_RECEIVED", targetDb, targetDbConnection);
			    	recipientSideMessage.setSendingStatusID(statusSent.getId());
			    	
			    	// Salvestame dokumendi teise andmebaasi
			    	result = recipientSideMessage.addToDB(targetDb, targetDbConnection);
			    	
			    	if (result > 0) {
			    		if (rec.getDhlID() == 0) {
			    			rec.setDhlId(result);
			    		}
			    		
			    		// Uuendame adressaadi andmeid lähteandmebaasis
			    		rec.setSendingDate(now);
			    		rec.setReceivedDate(now);
			    		rec.setSendingStatusID(Settings.Client_StatusSent);
			    		rec.saveToDB(sourceDb, sourceDbConnection);
			    		
			    		// Salvestame adressaadi andmed sihtandmebaasi
			    		rec.setSendingStatusID(Settings.Client_StatusReceived);
			    		rec.setMessageID(result);
			    		rec.saveToDB(targetDb, targetDbConnection);
			    		
			    		String recipientShortId = rec.getRecipientOrgCode() + "|" + rec.getRecipientPersonCode() + "|" + rec.getRecipientDivisionCode() + "|" + rec.getRecipientPositionCode() + "|" + String.valueOf(rec.getRecipientDivisionID()) + "|" + String.valueOf(rec.getRecipientPositionID());
	          			logger.info("Document "+ String.valueOf(message.getId()) +" was copied to database "+ targetDb.getDatabaseName() +" for recipient " + recipientShortId);
			    	}
		    	} finally {
		    		CommonMethods.safeCloseDatabaseConnection(targetDbConnection);
		    	}
	    	}
    	}
    	// Salvestame dokumendi ning tagastame dokumendi ID teises andmebaasis
    	return result;
    }

    private int runSendDocumentsRequest(String messageData, String attachmentFile, String attachmentName,
                                        HeaderVariables headerVar, String requestName) throws Exception {
        if ((attachmentFile == null) || (attachmentFile.length() < 1)) {
			throw new Exception("Unable to send message because message file is unspecified!");
		} else {
			File f = new File(attachmentFile);
			if (!f.exists()) {
				throw new Exception("Unable to send message because message file \""+ attachmentFile +"\" does not exist!");
			} else if (f.length() < 1) {
				throw new Exception("Unable to send message because message file \""+ attachmentFile +"\" is empty!");
			}
		}
		
		try {
	    	Message msg = new Message(messageData);
	        call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "sendDocuments"));
	        
	        // Lisame sänumile manuse
	        FileDataSource ds = new FileDataSource(attachmentFile);
	        DataHandler d1 = new DataHandler(ds);
	        AttachmentPart a1 = new AttachmentPart(d1);
	        a1.setContentId(attachmentName);
	        a1.setMimeHeader("Content-Transfer-Encoding", "base64");
	        a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
	        a1.addMimeHeader("Content-Encoding", "gzip");
	        msg.addAttachmentPart(a1);
	        msg.saveChanges();

            // Käivitame päringu
	        call.invoke(msg);
	        
	        // Vastuse täätlemine
	        Message response = call.getResponseMessage();

            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

            if (response != null && response.getAttachments() != null && response.getAttachments().hasNext()) {
                requestLog.setResponse(ResponseStatus.OK.toString());
            } else {
                requestLog.setResponse(ResponseStatus.NOK.toString());
            }

            LoggingService.logRequest(requestLog);

	        return extractSendDocumentsResponse(response);
        } catch (Exception ex) {
        	// Vea puhul logime vea pähjustanud SOAP sänumi keha
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " runSendDocumentsRequest");
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
        	throw ex;
        }
    }

    // Harutab lahti sendDocuments päringu vastuseks saadud XML-i
    private static int extractSendDocumentsResponse(Message response) throws Exception {
        int result = 0;
        Document xmldoc = null;
        NodeList nodes = null;
        String attachmentFile = null;

        try {
            Iterator attachments = response.getAttachments();
            while (attachments.hasNext()) {
                AttachmentPart a = (AttachmentPart)attachments.next();
                DataHandler dh = a.getDataHandler();
                DataSource ds = dh.getDataSource();

                String[] headers = a.getMimeHeader("Content-Transfer-Encoding");
                String encoding;
                if ((headers == null) || (headers.length < 1)) {
                    encoding = "base64";
                } else {
                    encoding = headers[0];
                }
                attachmentFile = CommonMethods.createPipelineFile(0);
                String md5Hash = CommonMethods.getDataFromDataSource(ds, encoding, attachmentFile, false);
                if (md5Hash == null) {
                    throw new Exception(CommonStructures.VIGA_VIGANE_MIME_LISA);
                }

                CommonMethods.gzipUnpackXML(attachmentFile, true);
                xmldoc = CommonMethods.xmlDocumentFromFile(attachmentFile, false);
                nodes = xmldoc.getElementsByTagName("dhl_id");
                if (nodes.getLength() == 1) {
                    result = Integer.parseInt(CommonMethods.getNodeText(nodes.item(0)));
                    logger.info("DVK server returned document ID: " + String.valueOf(result));
                } else {
                    throw new Exception("SendDocuments request returned too many document ID's!");
                }
            }
        } finally {
            if ((attachmentFile != null) && !attachmentFile.equalsIgnoreCase("")) {
                (new File(attachmentFile)).delete();
            }
            xmldoc = null;
            nodes = null;
        }
        return result;
    }

    public ReceiveDocumentsResult receiveDocuments(HeaderVariables headerVar, int limitDocuments, List<String> folders, int divisionID, String divisionShortName, int occupationID, String occupationShortName) throws Exception {
        return receiveDocuments(headerVar, limitDocuments, folders, divisionID, divisionShortName, occupationID, occupationShortName, orgSettings.getReceiveDocumentsRequestVersion());
    }

    public ReceiveDocumentsResult receiveDocuments(
        HeaderVariables headerVar,
        int limitDocuments,
        List<String> folders,
        int divisionID,
        String divisionShortName,
        int occupationID,
        String occupationShortName,
        int requestVersion) throws Exception {
        ReceiveDocumentsResult result = new ReceiveDocumentsResult();

        // Päringu nimi
        String requestName = this.producerName + ".receiveDocuments.v" + String.valueOf(requestVersion);
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele ReceiveDocuments(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
        		+" isikukood:" + headerVar.getPersonalIDCode());
        // Päringu ID koostamine
        queryId = "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());
        
        // Saadetava sänumi päisesse kantavad parameetrid
        DvkXHeader header = new DvkXHeader(
            headerVar.getOrganizationCode(),
            this.producerName,
            headerVar.getPersonalIDCode(),
            queryId,
            requestName,
            headerVar.getCaseName(),
            headerVar.getPIDWithCountryCode());

        // Koostame SOAP sänumi keha
        String messageData = "";
        if (requestVersion == 4) {
        	logger.debug("Invoking receiveDocuments.V4...");
            String attachmentFile = CommonMethods.createPipelineFile(0);
            ReceiveDocumentsV4Body b4 = new ReceiveDocumentsV4Body();
            b4.arv = limitDocuments;
            b4.kaust = folders;
            b4.allyksuseLyhinimetus = divisionShortName;
            b4.ametikohaLyhinimetus = occupationShortName;
            if (Settings.Client_UseFragmenting) {
                boolean hasMoreFragments = true;
                b4.fragmendiSuurusBaitides = Settings.Client_FragmentSizeBytes;
                b4.edastusID = headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());
                b4.fragmentNr = -1;
                result.deliverySessionID = b4.edastusID;
                while (hasMoreFragments) {
                    try {
                        b4.fragmentNr++;
                        messageData = (new SoapMessageBuilder(header, b4.getBodyContentsAsText())).getMessageAsText();
                        Message msg = new Message(messageData);
                        call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "receiveDocuments"));

                        // Teostame päringu
                        call.invoke(msg);

                        // Päringu tulemuste täätlemine
                        Message response = call.getResponseMessage();
                        RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

                        // Loeme päringu vastusest andmed fragmendi kohta
                        int fragmentNr = -1;
                        int fragmentCount = 0;
                        SOAPBody body = response.getSOAPBody();
                        NodeList nList = body.getElementsByTagName("keha");
                        if (nList.getLength() > 0) {
                            Element msgBodyNode = (Element)nList.item(0);
                            if (msgBodyNode != null) {
                                requestLog.setResponse(ResponseStatus.OK.toString());
                                nList = msgBodyNode.getElementsByTagName("fragment_nr");
                                if (nList.getLength() > 0) {
                                    try {
                                        fragmentNr = Integer.parseInt(CommonMethods.getNodeText(nList.item(0)));
                                    } catch (Exception e) {
                                        fragmentNr = -1;
                                    }
                                }
                                nList = msgBodyNode.getElementsByTagName("fragmente_kokku");
                                if (nList.getLength() > 0) {
                                    try {
                                        fragmentCount = Integer.parseInt(CommonMethods.getNodeText(nList.item(0)));
                                    } catch (Exception e) {
                                        fragmentCount = 0;
                                    }
                                }
                            } else {
                                requestLog.setResponse(ResponseStatus.NOK.toString());
                                logger.debug("Response <keha> element is empty.");
                            }
                        }

                        LoggingService.logRequest(requestLog);

                        logger.debug("Document fragment number: " + fragmentNr);
                        logger.debug("b4.fragmentNr: " + b4.fragmentNr);

                        if (fragmentNr != b4.fragmentNr) {
                            logger.debug("Server returned document fragment with wrong fragment index!");
                            throw new Exception("Server returned document fragment with wrong fragment index!");
                        }
                        hasMoreFragments = ((fragmentCount - fragmentNr) > 1);

                        Iterator attachments = response.getAttachments();
                        if (attachments.hasNext()) {
                            AttachmentPart a = (AttachmentPart)attachments.next();
                            DataHandler dh = a.getDataHandler();
                            DataSource ds = dh.getDataSource();

                            String[] headers = a.getMimeHeader("Content-Transfer-Encoding");
                            String encoding;
                            if((headers == null) || (headers.length < 1)) {
                                encoding = "base64";
                            }
                            else {
                                encoding = headers[0];
                            }
                            String md5Hash = CommonMethods.getDataFromDataSource(ds, encoding, attachmentFile, (fragmentNr > 0));
                            if (md5Hash == null) {
                                throw new Exception( CommonStructures.VIGA_VIGANE_MIME_LISA );
                            }

                            // Kui käik fragmendid on käes, siis täätleme faili ära
                            // ja salvestame saadud dokumendid andmebaasi.
                            if (!hasMoreFragments) {
                                CommonMethods.gzipUnpackXML(attachmentFile, true);
                                FileSplitResult splitResultVer1 = CommonMethods.splitOutTags(attachmentFile, "dokument", true, false, false);
                                FileSplitResult splitResultVer2_1 = CommonMethods.splitOutTags(attachmentFile, "DecContainer", true, false, false);
                                result.documents.addAll(splitResultVer1.subFiles);
                                result.documents.addAll(splitResultVer2_1.subFiles);

                                // Kustutame manuse faili, kuna kogu edasine tää toimub juba
                                // eraldatud dokumentide failidega.
                                (new File(attachmentFile)).delete();

                                return result;
                            }
                        }
                    } catch (Exception ex) {
                        ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " receiveDocuments");
                        errorLog.setOrganizationCode(headerVar.getOrganizationCode());
                        errorLog.setUserCode(headerVar.getPersonalIDCode());
                        RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
                        int errorLogId = LoggingService.logError(errorLog);
                        if (errorLogId != -1) {
                            requestLog.setErrorLogId(errorLogId);
                        }
                        requestLog.setResponse(ResponseStatus.NOK.toString());
                        LoggingService.logRequest(requestLog);
                        throw ex;
                    }
                }
            } else {
                messageData = (new SoapMessageBuilder(header, b4.getBodyContentsAsText())).getMessageAsText();
            }
        } else if (requestVersion == 3) {
            String attachmentFile = CommonMethods.createPipelineFile(0);
            ReceiveDocumentsV3Body b3 = new ReceiveDocumentsV3Body();
            b3.arv = limitDocuments;
            b3.kaust = folders;
            b3.allyksus = divisionID;
            b3.ametikoht = occupationID;
            if (Settings.Client_UseFragmenting) {
                boolean hasMoreFragments = true;
                b3.fragmendiSuurusBaitides = Settings.Client_FragmentSizeBytes;
                b3.edastusID = headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());
                b3.fragmentNr = -1;
                result.deliverySessionID = b3.edastusID;
                try {
                    while (hasMoreFragments) {
                        b3.fragmentNr++;
                        messageData = (new SoapMessageBuilder(header, b3.getBodyContentsAsText())).getMessageAsText();
                        Message msg = new Message(messageData);
                        call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "receiveDocuments"));

                        // Teostame päringu
                        call.invoke(msg);

                        // Päringu tulemuste täätlemine
                        Message response = call.getResponseMessage();

                        RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

                        // Loeme päringu vastusest andmed fragmendi kohta
                        int fragmentNr = -1;
                        int fragmentCount = 0;
                        SOAPBody body = response.getSOAPBody();
                        NodeList nList = body.getElementsByTagName("keha");
                        if (nList.getLength() > 0) {
                            Element msgBodyNode = (Element)nList.item(0);
                            if (msgBodyNode != null) {
                                requestLog.setResponse(ResponseStatus.OK.toString());
                                nList = msgBodyNode.getElementsByTagName("fragment_nr");
                                if (nList.getLength() > 0) {
                                    try {
                                        fragmentNr = Integer.parseInt(CommonMethods.getNodeText(nList.item(0)));
                                    } catch (Exception e) {
                                        fragmentNr = -1;
                                    }
                                }
                                nList = msgBodyNode.getElementsByTagName("fragmente_kokku");
                                if (nList.getLength() > 0) {
                                    try {
                                        fragmentCount = Integer.parseInt(CommonMethods.getNodeText(nList.item(0)));
                                    } catch (Exception e) {
                                        fragmentCount = 0;
                                    }
                                }
                            } else {
                                requestLog.setResponse(ResponseStatus.NOK.toString());
                            }
                        }

                        LoggingService.logRequest(requestLog);

                        if (fragmentNr != b3.fragmentNr) {
                            throw new Exception("Server returned document fragment with wrong fragment index!");
                        }
                        hasMoreFragments = ((fragmentCount - fragmentNr) > 1);

                        Iterator attachments = response.getAttachments();
                        if (attachments.hasNext()) {
                            AttachmentPart a = (AttachmentPart)attachments.next();
                            DataHandler dh = a.getDataHandler();
                            DataSource ds = dh.getDataSource();

                            String[] headers = a.getMimeHeader("Content-Transfer-Encoding");
                            String encoding;
                            if((headers == null) || (headers.length < 1)) {
                                encoding = "base64";
                            }
                            else {
                                encoding = headers[0];
                            }
                            String md5Hash = CommonMethods.getDataFromDataSource(ds, encoding, attachmentFile, (fragmentNr > 0));
                            if (md5Hash == null) {
                                throw new Exception( CommonStructures.VIGA_VIGANE_MIME_LISA );
                            }

                            // Kui käik fragmendid on käes, siis täätleme faili ära
                            // ja salvestame saadud dokumendid andmebaasi.
                            if (!hasMoreFragments) {
                                CommonMethods.gzipUnpackXML(attachmentFile, true);
                                FileSplitResult splitResult = CommonMethods.splitOutTags(attachmentFile, "dokument", true, false, false);
                                result.documents.addAll(splitResult.subFiles);

                                // Kustutame manuse faili, kuna kogu edasine tää toimub juba
                                // eraldatud dokumentide failidega.
                                (new File(attachmentFile)).delete();

                                return result;
                            }
                        }
                    }
                } catch (Exception ex) {
                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " receiveDocuments");
                    errorLog.setOrganizationCode(headerVar.getOrganizationCode());
                    errorLog.setUserCode(headerVar.getPersonalIDCode());
                    RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
                    int errorLogId = LoggingService.logError(errorLog);
                    if (errorLogId != -1) {
                        requestLog.setErrorLogId(errorLogId);
                    }
                    requestLog.setResponse(ResponseStatus.NOK.toString());
                    LoggingService.logRequest(requestLog);
                    throw ex;
                }
            } else {
                messageData = (new SoapMessageBuilder(header, b3.getBodyContentsAsText())).getMessageAsText();
            }
        } else if (requestVersion == 2) {
            String attachmentFile = CommonMethods.createPipelineFile(0);
            ReceiveDocumentsV2Body b2 = new ReceiveDocumentsV2Body();
            b2.arv = limitDocuments;
            b2.kaust = folders;
            if (Settings.Client_UseFragmenting) {
                boolean hasMoreFragments = true;
                b2.fragmendiSuurusBaitides = Settings.Client_FragmentSizeBytes;
                b2.edastusID = headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());
                b2.fragmentNr = -1;
                result.deliverySessionID = b2.edastusID;
                try {
                    while (hasMoreFragments) {
                        b2.fragmentNr++;
                        messageData = (new SoapMessageBuilder(header, b2.getBodyContentsAsText())).getMessageAsText();
                        Message msg = new Message(messageData);
                        call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "receiveDocuments"));

                        // Teostame päringu
                        call.invoke(msg);

                        // Päringu tulemuste täätlemine
                        Message response = call.getResponseMessage();

                        RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

                        // Loeme päringu vastusest andmed fragmendi kohta
                        int fragmentNr = -1;
                        int fragmentCount = 0;
                        SOAPBody body = response.getSOAPBody();
                        NodeList nList = body.getElementsByTagName("keha");
                        if (nList.getLength() > 0) {
                            Element msgBodyNode = (Element)nList.item(0);
                            if (msgBodyNode != null) {
                                requestLog.setResponse(ResponseStatus.OK.toString());
                                nList = msgBodyNode.getElementsByTagName("fragment_nr");
                                if (nList.getLength() > 0) {
                                    try {
                                        fragmentNr = Integer.parseInt(CommonMethods.getNodeText(nList.item(0)));
                                    } catch (Exception e) {
                                        fragmentNr = -1;
                                    }
                                }
                                nList = msgBodyNode.getElementsByTagName("fragmente_kokku");
                                if (nList.getLength() > 0) {
                                    try {
                                        fragmentCount = Integer.parseInt(CommonMethods.getNodeText(nList.item(0)));
                                    } catch (Exception e) {
                                        fragmentCount = 0;
                                    }
                                }
                            } else {
                                requestLog.setResponse(ResponseStatus.NOK.toString());
                            }
                        }

                        LoggingService.logRequest(requestLog);

                        if (fragmentNr != b2.fragmentNr) {
                            throw new Exception("Server returned document fragment with wrong fragment index!");
                        }
                        hasMoreFragments = ((fragmentCount - fragmentNr) > 1);

                        Iterator attachments = response.getAttachments();
                        if (attachments.hasNext()) {
                            AttachmentPart a = (AttachmentPart)attachments.next();
                            DataHandler dh = a.getDataHandler();
                            DataSource ds = dh.getDataSource();

                            String[] headers = a.getMimeHeader("Content-Transfer-Encoding");
                            String encoding;
                            if((headers == null) || (headers.length < 1)) {
                                encoding = "base64";
                            }
                            else {
                                encoding = headers[0];
                            }
                            String md5Hash = CommonMethods.getDataFromDataSource(ds, encoding, attachmentFile, (fragmentNr > 0));
                            if (md5Hash == null) {
                                throw new Exception( CommonStructures.VIGA_VIGANE_MIME_LISA );
                            }

                            // Kui käik fragmendid on käes, siis täätleme faili ära
                            // ja salvestame saadud dokumendid andmebaasi.
                            if (!hasMoreFragments) {
                                CommonMethods.gzipUnpackXML(attachmentFile, true);
                                FileSplitResult splitResult = CommonMethods.splitOutTags(attachmentFile, "dokument", true, false, false);
                                result.documents.addAll(splitResult.subFiles);

                                // Kustutame manuse faili, kuna kogu edasine tää toimub juba
                                // eraldatud dokumentide failidega.
                                (new File(attachmentFile)).delete();

                                return result;
                            }
                        }
                    }
                } catch (Exception ex) {
                    ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " receiveDocuments");
                    errorLog.setOrganizationCode(headerVar.getOrganizationCode());
                    errorLog.setUserCode(headerVar.getPersonalIDCode());
                    RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
                    int errorLogId = LoggingService.logError(errorLog);
                    if (errorLogId != -1) {
                        requestLog.setErrorLogId(errorLogId);
                    }
                    requestLog.setResponse(ResponseStatus.NOK.toString());
                    LoggingService.logRequest(requestLog);
                    throw ex;
                }
            } else {
                messageData = (new SoapMessageBuilder(header, b2.getBodyContentsAsText())).getMessageAsText();
            }
        } else {
            ReceiveDocumentsBody b = new ReceiveDocumentsBody();
            b.arv = limitDocuments;
            b.kaust = folders;
            messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
        }

        Message msg = new Message(messageData);
        call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "receiveDocuments"));

        Message response = null;

        try {
            // Teostame päringu
            call.invoke(msg);
            // Päringu tulemuste täätlemine
            response = call.getResponseMessage();

            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

            if (response != null && response.getAttachments() != null && response.getAttachments().hasNext()) {
                requestLog.setResponse(ResponseStatus.OK.toString());
            } else {
                requestLog.setResponse(ResponseStatus.NOK.toString());
            }

            LoggingService.logRequest(requestLog);

        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " receiveDocuments");
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            int errorLogId = LoggingService.logError(errorLog);
            if (errorLogId != -1) {
                requestLog.setErrorLogId(errorLogId);
            }
            requestLog.setResponse(ResponseStatus.NOK.toString());
            LoggingService.logRequest(requestLog);
            throw ex;
        }

        Iterator attachments = response.getAttachments();
        if (attachments.hasNext()) {
            String attachmentFile = CommonMethods.createPipelineFile(0);

            while (attachments.hasNext()) {
                AttachmentPart a = (AttachmentPart) attachments.next();
                DataHandler dh = a.getDataHandler();
                DataSource ds = dh.getDataSource();
                
                String[] headers = a.getMimeHeader("Content-Transfer-Encoding");
                String encoding;
                if((headers == null) || (headers.length < 1)) {
                    encoding = "base64";
                } else {
                    encoding = headers[0];
                }
                String md5Hash = CommonMethods.getDataFromDataSource(ds, encoding, attachmentFile, false);
                if (md5Hash == null) {
                    throw new Exception(CommonStructures.VIGA_VIGANE_MIME_LISA);
                }
                
                CommonMethods.gzipUnpackXML(attachmentFile, true);
                FileSplitResult splitResult = CommonMethods.splitOutTags(attachmentFile, "dokument", true, false, false);

                if (splitResult != null && splitResult.subFiles != null && splitResult.subFiles.size() == 0) {
                    splitResult = CommonMethods.splitOutTags(attachmentFile, "DecContainer", true, false, false);
                }

                result.documents.addAll(splitResult.subFiles);
                
                // Kustutame manuse faili, kuna kogu edasine tää toimub juba
                // eraldatud dokumentide failidega.
                (new File(attachmentFile)).delete();
            }
        }
        return result;
    }

    
    public void markDocumentsReceived(
    		HeaderVariables headerVar,
    		ArrayList<DhlMessage> documents,
    		int statusID,
    		Fault clientFault,
    		String metaXML,
    		String deliverySessionID,
    		boolean attemptDirectReply,
    		OrgSettings db,
    		Connection dbConnection,
    		UnitCredential unitSettings) throws Exception {
        
    	// Kontrollime, kas vajalikud andmed on olemas
    	ArrayList<DhlMessage> centralServerDocs = null;
    	if (attemptDirectReply) {
    		centralServerDocs = markDocumentsReceivedDirectId(documents, db, dbConnection);
    	} else {
    		centralServerDocs = documents;
    	}
    	
    	int length = centralServerDocs.size();
        if (length < 1) {
            return;
        }
    	
        // Päringu ID koostamine
        queryId = "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());
        
        // Päringu nimi ja versioon
        int requestVersion = orgSettings.getMarkDocumentsReceivedRequestVersion();
        String requestName = this.producerName + ".markDocumentsReceived.v" + String.valueOf(requestVersion);
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele MarkDocumentsReceived(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
        		+" isikukood:" + headerVar.getPersonalIDCode());
        try {
        // Saadetava sänumi päisesse kantavad parameetrid
            DvkXHeader header = new DvkXHeader(
                headerVar.getOrganizationCode(),
                this.producerName,
                headerVar.getPersonalIDCode(),
                queryId,
                requestName,
                headerVar.getCaseName(),
                headerVar.getPIDWithCountryCode());

            String attachmentName = "";
            String attachmentFile = "";
            String messageBody = "";

            ArrayList<Integer> dokumendidIdList = new ArrayList<Integer>();
            for(int i = 0; i < centralServerDocs.size(); i++) {
                DhlMessage msgTmp = centralServerDocs.get(i);
                dokumendidIdList.add(msgTmp.getDhlID());
            }

            if (requestVersion < 3) {
                logger.debug("RequestVersion < 3.");
                attachmentName = String.valueOf(System.currentTimeMillis());
                attachmentFile = MarkDocumentsReceivedBody.createResponseFile(dokumendidIdList, statusID, clientFault, metaXML, requestVersion, new Date());
                MarkDocumentsReceivedBody b = new MarkDocumentsReceivedBody();
                b.dokumendid = attachmentName;
                b.kaust = "";
                b.edastusID = deliverySessionID;

                // Alläksuse ja ametikoha parameetrid lisame markDocumentsReceived
                // päringule äksnes juhul, kui allalaadimisel kasutatud receiveDocuments
                // päring toetas alläksuse ja ametikoha parameetrite kasutamist.
                if ((unitSettings != null) && (orgSettings.getReceiveDocumentsRequestVersion() >= 3)) {
                    b.allyksuseId = unitSettings.getDivisionID();
                    b.ametikohaId = unitSettings.getOccupationID();
                }
                messageBody = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
            } else {
                logger.debug("RequestVersion = 3");
                MarkDocumentsReceivedV3Body b3 = new MarkDocumentsReceivedV3Body();
                b3.dokumendidIdList = dokumendidIdList;
                b3.kaust = "";
                b3.edastusID = deliverySessionID;
                b3.vastuvotjaStaatusId = statusID;
                b3.vastuvotjaVeateade = clientFault;
                b3.metaXml = metaXML;

                // Alläksuse ja ametikoha parameetrid lisame markDocumentsReceived
                // päringule äksnes juhul, kui allalaadimisel kasutatud receiveDocuments
                // päring toetas alläksuse ja ametikoha parameetrite kasutamist.
                if ((unitSettings != null) && (orgSettings.getReceiveDocumentsRequestVersion() >= 3)) {
                    b3.allyksuseLyhinimetus = unitSettings.getDivisionShortName();
                    b3.ametikohaLyhinimetus = unitSettings.getOccupationShortName();
                }
                messageBody = (new SoapMessageBuilder(header, b3.getBodyContentsAsText())).getMessageAsText();
            }

            Message msg = new Message(messageBody);
            call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "markDocumentsReceived"));

            // Lisame sänumile manuse
            if (requestVersion < 3) {
                String tempFile = CommonMethods.gzipPackXML(attachmentFile, header.getAsutus(), "markDocumentsReceived");
                tempFiles.add(tempFile);
                FileDataSource ds = new FileDataSource(tempFile);
                DataHandler d1 = new DataHandler(ds);
                AttachmentPart a1 = new AttachmentPart(d1);
                a1.setContentId(attachmentName);
                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                a1.addMimeHeader("Content-Encoding", "gzip");
                msg.addAttachmentPart(a1);
                msg.saveChanges();
            }

            call.invoke(msg);

            // Vastuse täätlemine
            Message response = call.getResponseMessage();

            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

            if (isMarkDocumentsResponseOK(response)) {
                requestLog.setResponse(ResponseStatus.OK.toString());
            } else {
                requestLog.setResponse(ResponseStatus.NOK.toString());
            }

            LoggingService.logRequest(requestLog);
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " markDocumentsReceived");
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            int errorLogId = LoggingService.logError(errorLog);
            if (errorLogId != -1) {
                requestLog.setErrorLogId(errorLogId);
            }
            requestLog.setResponse(ResponseStatus.NOK.toString());
            LoggingService.logRequest(requestLog);
            throw ex;
        }
    }

    private boolean isMarkDocumentsResponseOK(Message response) throws SOAPException {
        boolean result = false;

        if (response != null) {
            SOAPBody body = response.getSOAPBody();
            NodeList keha = body.getElementsByTagName("keha");

            if (keha.getLength() > 0) {
                Node kehaBody = keha.item(0);

                if (kehaBody != null && kehaBody.hasChildNodes()) {
                      if ("OK".equalsIgnoreCase(kehaBody.getFirstChild().toString())) {
                          result = true;
                      }
                }
            }
        }

        return result;
    }

    public void markDocumentsReceived(
    	HeaderVariables headerVar,
    	ArrayList<DhlMessage> documents,
    	String deliverySessionID,
    	OrgSettings db,
    	Connection dbConnection,
    	UnitCredential unitSettings) throws Exception {

        String requestName = null;

        try {
            // Kontrollime, kas vajalikud andmed on olemas
            ArrayList<DhlMessage> centralServerDocs = markDocumentsReceivedDirect(documents, db, dbConnection);

            int length = centralServerDocs.size();
            if (length < 1) {
                return;
            }

            // Päringu ID koostamine
            queryId = "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());

            // Päringu nimi ja versioon
            int requestVersion = orgSettings.getMarkDocumentsReceivedRequestVersion();
            requestName = this.producerName + ".markDocumentsReceived.v" + String.valueOf(requestVersion);
            logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele MarkDocumentsReceived(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
            		+" isikukood:" + headerVar.getPersonalIDCode());
            
            // Saadetava sänumi päisesse kantavad parameetrid
            DvkXHeader header = new DvkXHeader(
                headerVar.getOrganizationCode(),
                this.producerName,
                headerVar.getPersonalIDCode(),
                queryId,
                requestName,
                headerVar.getCaseName(),
                headerVar.getPIDWithCountryCode());

            String attachmentName = "";
            String attachmentFile = "";
            String messageBody = "";

            if (requestVersion < 3) {
                attachmentName = String.valueOf(System.currentTimeMillis());
                attachmentFile = MarkDocumentsReceivedBody.createResponseFile(centralServerDocs, requestVersion, new Date());
                MarkDocumentsReceivedBody b = new MarkDocumentsReceivedBody();
                b.dokumendid = attachmentName;
                b.kaust = "";
                b.edastusID = deliverySessionID;
                if (unitSettings != null) {
                    b.allyksuseId = unitSettings.getDivisionID();
                    b.ametikohaId = unitSettings.getOccupationID();
                }
                messageBody = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
            } else {
                MarkDocumentsReceivedV3Body b3 = new MarkDocumentsReceivedV3Body();
                b3.dokumendidObjectList = centralServerDocs;
                b3.kaust = "";
                b3.edastusID = deliverySessionID;

                // Vastuvätja staatus, veateade ja metaxml tulevad iga
                // konkreetse dokumendi andmetest.

                if (unitSettings != null) {
                    b3.allyksuseLyhinimetus = unitSettings.getDivisionShortName();
                    b3.ametikohaLyhinimetus = unitSettings.getOccupationShortName();
                }
                messageBody = (new SoapMessageBuilder(header, b3.getBodyContentsAsText())).getMessageAsText();
            }

            Message msg = new Message(messageBody);
            call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "markDocumentsReceived"));

            // Lisame sänumile manuse
            if (requestVersion < 3) {
                String tempFile = CommonMethods.gzipPackXML(attachmentFile, header.getAsutus(), "markDocumentsReceived");
                tempFiles.add(tempFile);
                FileDataSource ds = new FileDataSource(tempFile);
                DataHandler d1 = new DataHandler(ds);
                AttachmentPart a1 = new AttachmentPart(d1);
                a1.setContentId(attachmentName);
                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                a1.addMimeHeader("Content-Encoding", "gzip");
                msg.addAttachmentPart(a1);
                msg.saveChanges();
            }

            // Käivitame päringu
             call.invoke(msg);

            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            // Vastuse täätlemine
            Message response = call.getResponseMessage();
            // Käivitame päringu

            if (isMarkDocumentsResponseOK(response)) {
                requestLog.setResponse(ResponseStatus.OK.toString());
            } else {
                requestLog.setResponse(ResponseStatus.NOK.toString());
            }
            LoggingService.logRequest(requestLog);
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " markDocumentsReceived");
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            int errorLogId = LoggingService.logError(errorLog);
            if (errorLogId != -1) {
                requestLog.setErrorLogId(errorLogId);
            }
            requestLog.setResponse(ResponseStatus.NOK.toString());
            LoggingService.logRequest(requestLog);
            throw ex;
        }
    }

    /**
     * Meetod äritab etteantud sänumite staatusi otse saatja andmebaasi kirjutada.
     * Meetod tagastab nimekirja sänumitest, mille staatust tuleks uuendada DVK
     * keskserveri kaudu.
     * 
     * @param messages		Nimekiri sänumitest, mille stattusi oleks vaja uuendada.
     * @return				Nimekiri sänumitest, mille staatust ei ännestunud otse teise andmebaasi salvestada
     * @throws Exception 
     */
    public ArrayList<DhlMessage> markDocumentsReceivedDirect(ArrayList<DhlMessage> messages, OrgSettings db, Connection dbConnection) throws Exception {
    	ArrayList<DhlMessage> result = new ArrayList<DhlMessage>();
    	for (DhlMessage msg : messages) {
    		if (!markSingleDocumentReceivedDirect(msg, db, dbConnection)) {
    			result.add(msg);
    		}
    	}
    	return result;
    }
    
    public ArrayList<DhlMessage> markDocumentsReceivedDirectId(ArrayList<DhlMessage> idList, OrgSettings db, Connection dbConnection) throws Exception {
    	ArrayList<DhlMessage> result = new ArrayList<DhlMessage>();
    	for (DhlMessage id : idList) {
    		ArrayList<DhlMessage> messages = DhlMessage.getByDhlID(id.getDhlID(), false, true, db, dbConnection);
    		boolean success = true;
    		for (int i = 0; i < messages.size(); i++) {
    			if (!markSingleDocumentReceivedDirect(messages.get(i), db, dbConnection)) {
    				success = false;
    			}
    		}
    		if (!success) {
    			result.add(id);
    		}
    	}
    	return result;
    }
    
    public boolean markSingleDocumentReceivedDirect(DhlMessage message, OrgSettings currentDb, Connection dbConnection) throws Exception {
    	boolean result = false;
    	if ((message.getDhlGuid() != null) && (message.getDhlGuid().length() > 0)
    		&& message.getRecipientOrgCode().equalsIgnoreCase(message.getSenderOrgCode())) {
    		
    		for (OrgSettings db : this.allKnownDatabases) {
    			UnitCredential[] orgsInDB = UnitCredential.getCredentials(db, dbConnection);
    			for (int j = 0; j < orgsInDB.length; j++) {
    				if (orgsInDB[j].getInstitutionCode().equalsIgnoreCase(message.getSenderOrgCode())) {
    					int id = DhlMessage.getMessageID(message.getDhlGuid(), null, null, false, db, dbConnection);
    					if (id > 0) {
	    					ArrayList<MessageRecipient> recipients = MessageRecipient.getList(id, db, dbConnection);
	    					for (int k = 0; k < recipients.size(); k++) {
	    						MessageRecipient rec = recipients.get(k);
	    						if (CommonMethods.stringsEqualIgnoreNull(rec.getRecipientOrgCode(), message.getRecipientOrgCode())
	    							&& CommonMethods.stringsEqualIgnoreNull(rec.getRecipientDivisionCode(), message.getRecipientDivisionCode())
	    							&& CommonMethods.stringsEqualIgnoreNull(rec.getRecipientPositionCode(), message.getRecipientPositionCode())
	    							&& CommonMethods.stringsEqualIgnoreNull(rec.getRecipientPersonCode(), message.getRecipientPersonCode())
	    							&& (rec.getRecipientDivisionID() == message.getRecipientDivisionID())
	    							&& (rec.getRecipientPositionID() == message.getRecipientPositionID())) {
	    							
	    							rec.setRecipientStatusID(message.getRecipientStatusID());
	    							rec.setMetaXML(message.getMetaXML());
	    							rec.setFaultActor(message.getFaultActor());
	    							rec.setFaultCode(message.getFaultCode());
	    							rec.setFaultDetail(message.getFaultDetail());
	    							rec.setFaultString(message.getFaultString());
	    							rec.saveToDB(db, dbConnection);
	    							
	    							message.setStatusUpdateNeeded(false);
	    							message.updateStatusUpdateNeed(currentDb, dbConnection);
	    							
	    							result = true;
	    							break;
	    						}
	    					}
    					}	
    				}
    			}
    		}
    	}
    	
    	return result;
    }
    
    /**
     *  Väljastab nimekirja asutustest, kus on allalaadimist ootavaid dokumente
     */
    public ArrayList<String> receiveDownloadWaitingOrgs(HeaderVariables headerVar, ArrayList<OrgSettings> dbs) throws Exception {
        ArrayList<String> result = new ArrayList<String>();       
            
        GetSendingOptionsV3ResponseType serverAnswer = receiveDownloadWaitingOrgsV2(headerVar, dbs);
        for (int i = 0; i < serverAnswer.asutused.size(); ++i) {
        	if (!result.contains(serverAnswer.asutused.get(i).getOrgCode())) {
        		result.add(serverAnswer.asutused.get(i).getOrgCode());
        	}
        }
        
        return result;
    }
    
    /**
     *  Väljastab nimekirja asutustest, kus on allalaadimist ootavaid dokumente
     */
    public GetSendingOptionsV3ResponseType receiveDownloadWaitingOrgsV2(HeaderVariables headerVar, ArrayList<OrgSettings> dbs) throws Exception {
        // Loeme organisatsioonide koodid arraylisti        
        ArrayList<String> orgCodes = new ArrayList<String>();
        ArrayList<ShortName> subdivisions = new ArrayList<ShortName>();
        ArrayList<ShortName> occupations = new ArrayList<ShortName>();

        // Gather credentials from all known databases so we can find their
        // waiting aditDocuments with one single query
        for (OrgSettings db : dbs) {
        	Connection dbConnection = null;
        	try {
	        	dbConnection = DBConnection.getConnection(db);
                DatabaseSessionService.getInstance().setSession(dbConnection, db);
	            UnitCredential[] credentials = UnitCredential.getCredentials(db, dbConnection);
	            for (UnitCredential uc : credentials){
	                String orgCode = uc.getInstitutionCode();
	                String subdivisionShortName = uc.getDivisionShortName();
	                String occupationShortName = uc.getOccupationShortName();
	                
	                if ((orgCode != null) && (orgCode.length() > 0)) {
		            	if (!orgCodes.contains(orgCode)){
		                	orgCodes.add(orgCode);
		                }
		                if ((subdivisionShortName != null) && (subdivisionShortName.length() > 0)) {
		                	subdivisions.add(new ShortName(orgCode, subdivisionShortName));
		                }
		                if ((occupationShortName != null) && (occupationShortName.length() > 0)) {
		                	occupations.add(new ShortName(orgCode, occupationShortName));
		                }
	                }
	            }
        	} catch (Exception ex) {
        		// One misconfigured database connection or unreachable database
        		// should not cancel the whole process.
        		logger.warn("Error reading credentials from database \"" + db.getDatabaseName() +"\".");
        	} finally {
        		CommonMethods.safeCloseDatabaseConnection(dbConnection);
                DatabaseSessionService.getInstance().clearSession();
        	}
        }
        
		logger.debug("Getting sending options from DVK Server.");
        return getSendingOptions(headerVar, orgCodes, subdivisions, occupations, true, -1, -1, 3);
    }
    
    // Väljastab nimekirja asutustest, kus on allalaadimist ootavaid dokumente
    public GetSendingOptionsV3ResponseType getSendingOptions(
    		HeaderVariables headerVar,
    		ArrayList<String> orgCodes,
    		ArrayList<ShortName> subdivisions,
    		ArrayList<ShortName> occupations,
    		boolean onlyOrgsWithDocumentsWaiting,
    		int minimumCountOfDocumentsExchanged,
    		int maximumCountOfDocumentsExchanged,
    		int requestVersion) throws Exception {
    	
		logger.debug("getSendingOptionsV3 invoked.");
		
		GetSendingOptionsV3ResponseType result = new GetSendingOptionsV3ResponseType();

        String requestName = null;

        try {
            // Päringu nimi
            requestName = this.producerName + ".getSendingOptions.v" + String.valueOf(requestVersion);
            logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele GetSendingOptions(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
            		+" isikukood:" + headerVar.getPersonalIDCode());
            // Päringu ID koostamine
            this.queryId = "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());

            // Saadetava sänumi päisesse kantavad parameetrid
            DvkXHeader header = new DvkXHeader(
                headerVar.getOrganizationCode(),
                this.producerName,
                headerVar.getPersonalIDCode(),
                this.queryId,
                requestName,
                headerVar.getCaseName(),
                headerVar.getPIDWithCountryCode());

            // Koostame SOAP sänumi keha
            String messageData = "";
            String attachmentName = String.valueOf(System.currentTimeMillis());
            String attachmentFileName = "";
            switch (requestVersion) {
                case 1:
                    GetSendingOptionsBody b1 = new GetSendingOptionsBody();
                    b1.keha = orgCodes;
                    messageData = (new SoapMessageBuilder(header, b1.getBodyContentsAsText())).getMessageAsText();
                    break;
                case 2:
                    GetSendingOptionsV2Body b2 = new GetSendingOptionsV2Body();
                    b2.asutused = orgCodes;
                    b2.vastuvotmata_dokumente_ootel = onlyOrgsWithDocumentsWaiting;
                    b2.vahetatud_dokumente_vahemalt = minimumCountOfDocumentsExchanged;
                    b2.vahetatud_dokumente_kuni = maximumCountOfDocumentsExchanged;
                    messageData = (new SoapMessageBuilder(header, b2.getBodyContentsAsText())).getMessageAsText();
                    break;
                case 3:
                    GetSendingOptionsV3Body b3 = new GetSendingOptionsV3Body();
                    b3.kehaHref = attachmentName;
                    b3.asutused = orgCodes;
                    b3.allyksused = subdivisions;
                    b3.ametikohad = occupations;
                    b3.vastuvotmataDokumenteOotel = onlyOrgsWithDocumentsWaiting;
                    b3.vahetatudDokumenteVahemalt = minimumCountOfDocumentsExchanged;
                    b3.vahetatudDokumenteKuni = maximumCountOfDocumentsExchanged;
                    attachmentFileName = b3.createAttachmentFile();
                    messageData = (new SoapMessageBuilder(header, b3.getBodyContentsAsText())).getMessageAsText();
                    break;
                default:
                    break;
            }

            Message msg = new Message(messageData);
            call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "getSendingOptions"));

            // Lisame sänumile manuse
            if (requestVersion == 3) {
                FileDataSource ds = new FileDataSource(attachmentFileName);
                DataHandler d1 = new DataHandler(ds);
                AttachmentPart a1 = new AttachmentPart(d1);
                a1.setContentId(attachmentName);
                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                a1.addMimeHeader("Content-Encoding", "gzip");
                msg.addAttachmentPart(a1);
                msg.saveChanges();
            }

            // Teostame päringu
            call.invoke(msg);

            // Päringu tulemuste täätlemine
            Message response = call.getResponseMessage();

            if (requestVersion < 3) {
                ArrayList<DhlCapability> orgs = new ArrayList<DhlCapability>();
                SOAPBody body = response.getSOAPBody();
                NodeList nList = body.getElementsByTagName("keha");
                if (nList.getLength() > 0) {
                    Node msgBodyNode = nList.item(0);
                    if (msgBodyNode != null) {
                        nList = ((Element)msgBodyNode).getElementsByTagName("asutus");
                        for (int i = 0; i < nList.getLength(); ++i) {
                            DhlCapability item = DhlCapability.fromXML((Element)nList.item(i));
                            if (item != null) {
                                orgs.add(item);
                            }
                        }
                    }
                }
                result.asutused = orgs;
            } else {
                AttachmentExtractionResult responseData = CommonMethods.getExtractedFileFromAttachment(response);
                if (responseData != null) {
                    String fileName = responseData.getExtractedFileName();
                    if ((fileName != null) && (fileName.length() > 0) && (new File(fileName)).exists()) {
                        Document xmlDoc = CommonMethods.xmlDocumentFromFile(fileName, true);
                        result = GetSendingOptionsV3ResponseType.fromXML(xmlDoc.getDocumentElement());
                    }
                }
            }
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " getSendingOptions");
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            LoggingService.logError(errorLog);
            throw ex;
        }

        return result;
    }
    
    public ArrayList<Subdivision> getSubdivisionList(HeaderVariables headerVar, ArrayList<String> orgCodes) throws Exception {
    	int requestVersion = 1;
    	if (this.orgSettings != null) {
    		requestVersion = this.orgSettings.getGetSubdivisionListRequestVersion();
    	}
    	return getSubdivisionList(headerVar, orgCodes, requestVersion);
    }

    public ArrayList<Subdivision> getSubdivisionList(HeaderVariables headerVar, ArrayList<String> orgCodes, int requestVersion) throws Exception {
        ArrayList<Subdivision> result = new ArrayList<Subdivision>();
        String requestName = null;
        try {
            // Päringu nimi
            requestName = this.producerName + ".getSubdivisionList.v" + String.valueOf(requestVersion);
            logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele GetSubdivisionList(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
            		+" isikukood:" + headerVar.getPersonalIDCode());
            // Päringu ID koostamine
            queryId = "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());

            // Saadetava sänumi päisesse kantavad parameetrid
            DvkXHeader header = new DvkXHeader(
                    headerVar.getOrganizationCode(),
                    this.producerName,
                    headerVar.getPersonalIDCode(),
                    queryId,
                    requestName,
                    headerVar.getCaseName(),
                    headerVar.getPIDWithCountryCode());

            // Koostame SOAP sänumi keha
            String messageData = "";
            String attachmentName = String.valueOf(System.currentTimeMillis());
            String attachmentFileName = "";
            switch (requestVersion) {
                case 1:
                    GetSubdivisionListBody b = new GetSubdivisionListBody();
                    b.keha = orgCodes;
                    messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                    break;
                case 2:
                    GetSubdivisionListV2Body b2 = new GetSubdivisionListV2Body();
                    b2.asutusedHref = attachmentName;
                    b2.asutused = orgCodes;
                    attachmentFileName = b2.createAttachmentFile();
                    messageData = (new SoapMessageBuilder(header, b2.getBodyContentsAsText())).getMessageAsText();
                    break;
                default:
                    throw new Exception("Request getSubdivisionList does not have version v" + String.valueOf(requestVersion) + "!");
            }

            Message msg = new Message(messageData);
            call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "getSubdivisionList"));

            // Lisame sänumile manuse
            if (requestVersion == 2) {
                FileDataSource ds = new FileDataSource(attachmentFileName);
                DataHandler d1 = new DataHandler(ds);
                AttachmentPart a1 = new AttachmentPart(d1);
                a1.setContentId(attachmentName);
                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                a1.addMimeHeader("Content-Encoding", "gzip");
                msg.addAttachmentPart(a1);
                msg.saveChanges();
            }

            // Teostame päringu
            call.invoke(msg);
            Message response = call.getResponseMessage();

            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

            // Päringu tulemuste täätlemine
            Node msgBodyNode = null;
            if (requestVersion < 2) {
                SOAPBody body = response.getSOAPBody();
                NodeList nList = body.getElementsByTagName("keha");
                if (nList.getLength() > 0) {
                    msgBodyNode = nList.item(0);
                }
            } else {
                AttachmentExtractionResult responseData = CommonMethods.getExtractedFileFromAttachment(response);
                if (responseData != null) {
                    String fileName = responseData.getExtractedFileName();
                    if ((fileName != null) && (fileName.length() > 0) && (new File(fileName)).exists()) {
                        Document xmlDoc = CommonMethods.xmlDocumentFromFile(fileName, true);
                        NodeList nList = xmlDoc.getDocumentElement().getElementsByTagName("allyksused");
                        if (nList.getLength() > 0) {
                            msgBodyNode = nList.item(0);
                        }
                    }
                }
            }
            if (msgBodyNode != null) {
                requestLog.setResponse(ResponseStatus.OK.toString());
                NodeList nList = ((Element) msgBodyNode).getElementsByTagName("allyksus");
                for (int i = 0; i < nList.getLength(); ++i) {
                    Subdivision item = Subdivision.fromXML((Element) nList.item(i));
                    if (item != null) {
                        result.add(item);
                    }
                }
            } else {
                requestLog.setResponse(ResponseStatus.NOK.toString());
            }

            LoggingService.logRequest(requestLog);
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " getSubdivisionList");
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            int errorLogId = LoggingService.logError(errorLog);
            if (errorLogId != -1){
                requestLog.setErrorLogId(errorLogId);
            }
            requestLog.setResponse(ResponseStatus.NOK.toString());
            LoggingService.logRequest(requestLog);
            throw ex;
        }
        return result;
    }
    
    public ArrayList<Occupation> getOccupationList(HeaderVariables headerVar, ArrayList<String> orgCodes) throws Exception {
    	int requestVersion = 1;
    	if (this.orgSettings != null) {
    		requestVersion = this.orgSettings.getGetSubdivisionListRequestVersion();
    	}
    	return getOccupationList(headerVar, orgCodes, requestVersion);
    }
    
    public ArrayList<Occupation> getOccupationList(HeaderVariables headerVar, ArrayList<String> orgCodes, int requestVersion) throws Exception {
        ArrayList<Occupation> result = new ArrayList<Occupation>();

        String requestName = this.producerName + ".getOccupationList.v" + String.valueOf(requestVersion);
        logger.log(Level.getLevel("SERVICEINFO"), "Väljaminev päring teenusele GetOccupationList(xtee teenus:"+requestName+"). Asutusest:" + headerVar.getOrganizationCode() 
        		+" isikukood:" + headerVar.getPersonalIDCode());
        try {
        // Päringu nimi
            requestName = this.producerName + ".getOccupationList.v" + String.valueOf(requestVersion);

            // Päringu ID koostamine
            queryId = "dvk" + headerVar.getOrganizationCode() + String.valueOf((new Date()).getTime());

            // Saadetava sänumi päisesse kantavad parameetrid
            DvkXHeader header = new DvkXHeader(
                headerVar.getOrganizationCode(),
                this.producerName,
                headerVar.getPersonalIDCode(),
                queryId,
                requestName,
                headerVar.getCaseName(),
                headerVar.getPIDWithCountryCode());

            // Koostame SOAP sänumi keha
            String messageData = "";
            String attachmentName = String.valueOf(System.currentTimeMillis());
            String attachmentFileName = "";
            switch (requestVersion) {
                case 1:
                    GetOccupationListBody b = new GetOccupationListBody();
                    b.keha = orgCodes;
                    messageData = (new SoapMessageBuilder(header, b.getBodyContentsAsText())).getMessageAsText();
                    break;
                case 2:
                    GetOccupationListV2Body b2 = new GetOccupationListV2Body();
                    b2.asutusedHref = attachmentName;
                    b2.asutused = orgCodes;
                    attachmentFileName = b2.createAttachmentFile();
                    messageData = (new SoapMessageBuilder(header, b2.getBodyContentsAsText())).getMessageAsText();
                    break;
                default:
                    throw new Exception("Request getOccupationList does not have version v" + String.valueOf(requestVersion) + "!");
            }
            Message msg = new Message(messageData);
            call.setOperationName(new QName(CommonStructures.NS_DVK_MAIN, "getOccupationList"));

            // Lisame sänumile manuse
            if (requestVersion == 2) {
                FileDataSource ds = new FileDataSource(attachmentFileName);
                DataHandler d1 = new DataHandler(ds);
                AttachmentPart a1 = new AttachmentPart(d1);
                a1.setContentId(attachmentName);
                a1.setMimeHeader("Content-Transfer-Encoding", "base64");
                a1.setContentType("{http://www.w3.org/2001/XMLSchema}base64Binary");
                a1.addMimeHeader("Content-Encoding", "gzip");
                msg.addAttachmentPart(a1);
                msg.saveChanges();
            }

            // Teostame päringu
            call.invoke(msg);

            // Päringu tulemuste täätlemine
            Message response = call.getResponseMessage();

            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());

            Node msgBodyNode = null;
            if (requestVersion < 2) {
                SOAPBody body = response.getSOAPBody();
                NodeList nList = body.getElementsByTagName("keha");
                if (nList.getLength() > 0) {
                    msgBodyNode = nList.item(0);
                }
            } else {
                AttachmentExtractionResult responseData = CommonMethods.getExtractedFileFromAttachment(response);
                if (responseData != null) {
                    String fileName = responseData.getExtractedFileName();
                    if ((fileName != null) && (fileName.length() > 0) && (new File(fileName)).exists()) {
                        Document xmlDoc = CommonMethods.xmlDocumentFromFile(fileName, true);
                        NodeList nList = xmlDoc.getDocumentElement().getElementsByTagName("ametikohad");
                        if (nList.getLength() > 0) {
                            msgBodyNode = nList.item(0);
                        }
                    }
                }
            }
            if (msgBodyNode != null) {
                requestLog.setResponse(ResponseStatus.OK.toString());
                NodeList nList = ((Element)msgBodyNode).getElementsByTagName("ametikoht");
                for (int i = 0; i < nList.getLength(); ++i) {
                    Occupation item = Occupation.fromXML((Element)nList.item(i));
                    if (item != null) {
                        result.add(item);
                    }
                }
            } else {
                requestLog.setResponse(ResponseStatus.NOK.toString());
            }

            LoggingService.logRequest(requestLog);
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, "dvk.client.ClientAPI" + " getOccupationList");
            errorLog.setOrganizationCode(headerVar.getOrganizationCode());
            errorLog.setUserCode(headerVar.getPersonalIDCode());
            RequestLog requestLog = new RequestLog(requestName, headerVar.getOrganizationCode(), headerVar.getPersonalIDCode());
            int errorLogId = LoggingService.logError(errorLog);
            if (errorLogId != -1) {
                requestLog.setErrorLogId(errorLogId);
            }
            requestLog.setResponse(ResponseStatus.NOK.toString());
            LoggingService.logRequest(requestLog);
            throw ex;
        }
        return result;
    }

    public Call getCall() {
        return call;
    }

    public Connection getSafeDbConnection(OrgSettings db) {
        Connection dbConnection = null;
        try {
            dbConnection = DBConnection.getConnection(db);
            DatabaseSessionService.getInstance().setSession(dbConnection, db);
        } catch (Exception e) {
            logger.error("DVK kliendil ebaõnnestus andmebaasiga ühenduse tekitamine! " + e.getMessage());
            ErrorLog errorLog = new ErrorLog(e, "dvk.client.Client" + " main");
            LoggingService.logError(errorLog);
        }

        return dbConnection;
    }
}
