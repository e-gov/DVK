package dhl.requests;

import dhl.DocumentFragment;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dhl.Recipient;
import dhl.Sending;
import dhl.iostructures.XHeader;
import dhl.iostructures.markDocumentsReceivedRequestType;
import dhl.iostructures.markDocumentsReceivedV2Item;
import dhl.iostructures.markDocumentsReceivedV3RequestType;
import dhl.users.UserProfile;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Date;
import javax.activation.DataSource;
import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;

public class MarkDocumentsReceived{
	private static Logger logger = Logger.getLogger(MarkDocumentsReceived.class); 

    public static RequestInternalResult V1( org.apache.axis.MessageContext context, Connection conn, UserProfile user ) throws SQLException, AxisFault {
        logger.info("MarkDocumentsReceived.V1 invoked.");
        
		RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);
        
        try {
            // Lame SOAP keha endale sobivasse andmestruktuuri
            markDocumentsReceivedRequestType bodyData = markDocumentsReceivedRequestType.getFromSOAPBody( context );
            if (bodyData == null) {
                throw new AxisFault( CommonStructures.VIGA_VIGANE_KEHA );
            }
            result.folder = bodyData.kaust;
            
            org.apache.axis.attachments.AttachmentPart px = (org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().getAttachmentsImpl().getAttachmentByReference(bodyData.dokumendidHref);
            DataSource attachmentSource = px.getActivationDataHandler().getDataSource();
            if (attachmentSource == null) {
                throw new AxisFault( CommonStructures.VIGA_PUUDUV_MIME_LISA );
            }
            
            // Laeme SOAP attachmendis asunud andmed baidimassiivi
            String[] headers = px.getMimeHeader("Content-Transfer-Encoding");
            String encoding;
            if((headers == null) || (headers.length < 1)) {
                encoding = "base64";
            }
            else {
                encoding = headers[0];
            }
            result.dataMd5Hash = CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false);
            if (result.dataMd5Hash == null) {
                throw new AxisFault( CommonStructures.VIGA_VIGANE_MIME_LISA );
            }
            
            // Pakime andmed GZIPiga lahti
            if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA );
            }
            
            // Laeme andmed XML DOM dokumendi kujule
            Document inputMessage = CommonMethods.xmlDocumentFromFile(pipelineDataFile, false);
            
            // Find all XML elemets named "dhl_id"
            NodeList foundNodes = inputMessage.getElementsByTagName("dhl_id");
            
            // Convert all IDs to numbers
            int[] idList = new int[foundNodes.getLength()];
            String idText = null;
            for (int i = 0; i < idList.length; ++i) {
                idText = CommonMethods.getNodeText(foundNodes.item(i));
                idList[i] = CommonMethods.toIntSafe(idText, 0);
                if (idList[i] <= 0) {
                    throw new AxisFault("Vigane dokumendi ID: " + idText);
                }
            }
            
            // Kopeerime edasiste tegevuste jaoks vajalikud andmed oma
            // andmestruktuuri ümber.
            Recipient tmpRecipient = null;
            for (int i = 0; i < idList.length; ++i) {
                int docID = idList[i];
                Sending tmpSending = new Sending();
                if (tmpSending.loadByDocumentID(docID, conn)) {
                    boolean allSent = true;
                    boolean recipientFound = false;
                    for (int j = 0; j < tmpSending.getRecipients().size(); ++j) {
                        tmpRecipient = tmpSending.getRecipients().get(j);
                        if (tmpRecipient.getOrganizationID() == user.getOrganizationID()) {

                        	// Kui püringus on tüpsustatud, millise allüksuse ja/vüi ametikoha
                        	// dokumendid tuleb vastuvüetuks mürkida, siis kontrollime, et
                        	// ametikoha ja/vüi allüksuse ID adressaadi andmetes
                        	// vastaks püringu parameetritele.
                        	// Vastasel juhul mürgiks rakendus dokumendi vastuvüetuks küigi
                        	// adressaatide poolt, kes kuuluvad püringu teinud asutuse alla.
                        	if (((bodyData.allyksusId <= 0) || (tmpRecipient.getDivisionID() == bodyData.allyksusId))
                            	&& ((bodyData.ametikohtId <= 0) || (tmpRecipient.getPositionID() == bodyData.ametikohtId))) {
                        	
	                            recipientFound = true;
	                            tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Sent);
	                            tmpRecipient.setSendingEndDate(new Date());
	                            tmpRecipient.setStatusDate(new Date());
	                            XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
	                            tmpRecipient.update(conn, xTeePais);
                        	}
                        }
                        if (tmpRecipient.getSendStatusID() != CommonStructures.SendStatus_Sent) {
                            allSent = false;
                        }
                    }
                    
                    if (!recipientFound) {
                    	throw new AxisFault(createRecipientNotFoundMessage(docID, user.getOrganizationCode(), bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                    }
                    
                    if ((allSent == true) && (tmpSending.getSendStatusID() != CommonStructures.SendStatus_Sent)) {
                        tmpSending.setSendStatusID( CommonStructures.SendStatus_Sent );
                        tmpSending.setEndDate( new Date() );
                        XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                        tmpSending.update( false, conn, xTeePais );
                    }
                } else {
                	throw new AxisFault(createRecipientNotFoundMessage(docID, user.getOrganizationCode(), bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                }
            }
            
            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("")) {
                DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, false, conn);
            }
        }
        finally {
            (new File(pipelineDataFile)).delete();
        }
        
        return result;
    }
    
    public static RequestInternalResult V2( org.apache.axis.MessageContext context, Connection conn, UserProfile user ) throws SQLException, AxisFault {
        logger.info("MarkDocumentsReceived.V2 invoked.");
		
		RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);
        
        try {
            // Lame SOAP keha endale sobivasse andmestruktuuri
            markDocumentsReceivedRequestType bodyData = markDocumentsReceivedRequestType.getFromSOAPBody( context );
            if (bodyData == null) {
                throw new AxisFault( CommonStructures.VIGA_VIGANE_KEHA );
            }
            result.folder = bodyData.kaust;
            
            org.apache.axis.attachments.AttachmentPart px = (org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().getAttachmentsImpl().getAttachmentByReference(bodyData.dokumendidHref);
            DataSource attachmentSource = px.getActivationDataHandler().getDataSource();
            if (attachmentSource == null) {
                throw new AxisFault( CommonStructures.VIGA_PUUDUV_MIME_LISA );
            }
            
            // Laeme SOAP attachmendis asunud andmed baidimassiivi
            String[] headers = px.getMimeHeader("Content-Transfer-Encoding");
            String encoding;
            if((headers == null) || (headers.length < 1)) {
                encoding = "base64";
            }
            else {
                encoding = headers[0];
            }
            result.dataMd5Hash = CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false);
            if (result.dataMd5Hash == null) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }
            
            // Pakime andmed GZIPiga lahti
            if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA );
            }
            
            // Laeme andmed XML DOM dokumendi kujule
            Document inputMessage = CommonMethods.xmlDocumentFromFile(pipelineDataFile, false);
            
            // Leiame küik XML elemendid, mille nimi on "item"
            NodeList foundNodes = inputMessage.getElementsByTagName("item");
            
            // Kontrollime, et sisendis sisalduks vühemalt 1 dokumendi andmed
            if (foundNodes == null) {
                throw new AxisFault("Dokumentide nimekiri on tühi vüi vigase XML struktuuriga!");
            }
            if (foundNodes.getLength() < 1) {
                throw new AxisFault("Dokumentide nimekiri on tühi vüi vigase XML struktuuriga!");
            }
            
            // Kopeerime edasiste tegevuste jaoks vajalikud andmed oma
            // andmestruktuuri ümber.
            int nodeCount = foundNodes.getLength();
            Recipient tmpRecipient = null;
            for (int i = 0; i < nodeCount; ++i) {
                markDocumentsReceivedV2Item item = markDocumentsReceivedV2Item.getFromXML( (org.w3c.dom.Element)foundNodes.item(i) );
                
                // Kontrollime olulisemad sisendandmed üle
                if (item == null) {
                    throw new AxisFault("Sisendandmed on vigase XML struktuuriga!");
                }
                if (item.documentID < 1) {
                    throw new AxisFault("Vigane dokumendi ID vüi vigane andmete XML struktuur!");
                }
                
                Sending tmpSending = new Sending();
                if (tmpSending.loadByDocumentID(item.documentID, conn)) {
                    boolean allSent = true;
                    boolean recipientFound = false;
                    for (int j = 0; j < tmpSending.getRecipients().size(); ++j) {
                        tmpRecipient = tmpSending.getRecipients().get(j);
                        if (tmpRecipient.getOrganizationID() == user.getOrganizationID()) {
                            
                        	// Kui püringus on tüpsustatud, millise allüksuse ja/vüi ametikoha
                        	// dokumendid tuleb vastuvüetuks mürkida, siis kontrollime, et
                        	// ametikoha ja/vüi allüksuse ID adressaadi andmetes
                        	// vastaks püringu parameetritele.
                        	// Vastasel juhul mürgiks rakendus dokumendi vastuvüetuks küigi
                        	// adressaatide poolt, kes kuuluvad püringu teinud asutuse alla.
                        	if (((bodyData.allyksusId <= 0) || (tmpRecipient.getDivisionID() == bodyData.allyksusId))
                            	&& ((bodyData.ametikohtId <= 0) || (tmpRecipient.getPositionID() == bodyData.ametikohtId))) {
	                        	
                        		recipientFound = true;
	                            if (item.recipientFault == null) {
	                                // Kui veateadet ei saadetud, siis jüreldame, et dokument
	                                // vüeti edukalt vastu.
	                                tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Sent);
	                            }
	                            else {
	                                // Kui saadeti veateade, siis mürgime saatmise ebaünnestunuks.
	                                tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Canceled);
	                            }
	                            tmpRecipient.setFault(item.recipientFault);
	                            tmpRecipient.setSendingEndDate(new Date());
	                            tmpRecipient.setRecipientStatusId(item.recipientStatusID);
	                            tmpRecipient.setMetaXML(item.metaXML);
	                            
	                            // Praegusest juupüevast ja kellaajast hilisemaid staatuse
	                            // muutumise aegu ei saa ette anda.
	                            if (item.staatuseMuutmiseAeg.after(new Date())) {
	                            	tmpRecipient.setStatusDate(new Date());
	                            } else {
	                            	tmpRecipient.setStatusDate(item.staatuseMuutmiseAeg);
	                            }
	                            
	                            XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
	                            tmpRecipient.update(conn, xTeePais);
                        	}
                        }
                        if (tmpRecipient.getSendStatusID() != CommonStructures.SendStatus_Sent) {
                            allSent = false;
                        }
                    }
                    
                    if (!recipientFound) {
                        throw new AxisFault(createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(), bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                    }
                    
                    if ((allSent == true) && (tmpSending.getSendStatusID() != CommonStructures.SendStatus_Sent)) {
                        tmpSending.setSendStatusID( CommonStructures.SendStatus_Sent );
                        tmpSending.setEndDate( new Date() );
                        XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                        tmpSending.update( false, conn, xTeePais );
                    }
                } else {
                	throw new AxisFault(createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(), bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                }
            }
            
            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("")) {
                DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, false, conn);
            }
        }
        finally {
            (new File(pipelineDataFile)).delete();
        }
        
        return result;
    }
    
    public static RequestInternalResult V3(org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws SQLException, AxisFault {
        logger.info("MarkDocumentsReceived.V3 invoked.");
		
		RequestInternalResult result = new RequestInternalResult();
        result.requestElement = CommonMethods.getXRoadRequestBodyElement(context, "markDocumentsReceived");
        
        // Lame SOAP keha endale sobivasse andmestruktuuri
        markDocumentsReceivedV3RequestType bodyData = markDocumentsReceivedV3RequestType.getFromSOAPBody( context );
        if (bodyData == null) {
            throw new AxisFault( CommonStructures.VIGA_VIGANE_KEHA );
        }
        
        // Kopeerime edasiste tegevuste jaoks vajalikud andmed oma
        // andmestruktuuri ümber.
        int nodeCount = bodyData.dokumendid.size();
        Recipient tmpRecipient = null;
        for (int i = 0; i < nodeCount; ++i) {
            markDocumentsReceivedV2Item item = bodyData.dokumendid.get(i);
            
            // Kontrollime olulisemad sisendandmed üle
            if (item == null) {
                throw new AxisFault("Sisendandmed on vigase XML struktuuriga!");
            }
            if (item.documentID < 1 && (item.guid == null || item.guid.trim().equalsIgnoreCase(""))) {
                throw new AxisFault("Vigane dokumendi ID vüi vigane andmete XML struktuur!");
            }
            
            Sending tmpSending = new Sending();
            
            boolean documentLoadResult = false;
            
            if(item.documentID > 0) {
            	logger.debug("Loading document by document ID.");
            	documentLoadResult = tmpSending.loadByDocumentID(item.documentID, conn);
            } else if(item.guid != null && !item.guid.trim().equalsIgnoreCase("")) {
            	logger.debug("Loading document by document GUID.");
            	documentLoadResult = tmpSending.loadByDocumentGUID(item.guid, conn);
            }        
            
            if (documentLoadResult) {
                boolean allSent = true;
                boolean recipientFound = false;
                for (int j = 0; j < tmpSending.getRecipients().size(); ++j) {
                    tmpRecipient = tmpSending.getRecipients().get(j);
                    if (tmpRecipient.getOrganizationID() == user.getOrganizationID()) {
                        
                    	// Kui püringus on tüpsustatud, millise allüksuse ja/vüi ametikoha
                    	// dokumendid tuleb vastuvüetuks mürkida, siis kontrollime, et
                    	// ametikoha ja/vüi allüksuse lühinimetus adressaadi andmetes
                    	// vastaks püringu parameetritele.
                    	// Vastasel juhul mürgiks rakendus dokumendi vastuvüetuks küigi
                    	// adressaatide poolt, kes kuuluvad püringu teinud asutuse alla.
                    	if (((bodyData.allyksuseLyhinimetus == null) || (bodyData.allyksuseLyhinimetus.length() < 1) || CommonMethods.stringsEqualIgnoreNull(tmpRecipient.getDivisionShortName(), bodyData.allyksuseLyhinimetus))
                        	&& ((bodyData.ametikohaLyhinimetus == null) || (bodyData.ametikohaLyhinimetus.length() < 1) || CommonMethods.stringsEqualIgnoreNull(tmpRecipient.getPositionShortName(), bodyData.ametikohaLyhinimetus))) {
	                    	
                        	recipientFound = true;
	                        if (item.recipientFault == null) {
	                            // Kui veateadet ei saadetud, siis jüreldame, et dokument
	                            // vüeti edukalt vastu.
	                            tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Sent);
	                        }
	                        else {
	                            // Kui saadeti veateade, siis mürgime saatmise ebaünnestunuks.
	                            tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Canceled);
	                        }
	                        tmpRecipient.setFault(item.recipientFault);
	                        tmpRecipient.setSendingEndDate(new Date());
	                        tmpRecipient.setRecipientStatusId(item.recipientStatusID);
	                        tmpRecipient.setMetaXML(item.metaXML);
	                        
                            // Praegusest juupüevast ja kellaajast hilisemaid staatuse
                            // muutumise aegu ei saa ette anda.
                            if (item.staatuseMuutmiseAeg.after(new Date())) {
                            	tmpRecipient.setStatusDate(new Date());
                            } else {
                            	tmpRecipient.setStatusDate(item.staatuseMuutmiseAeg);
                            }
	                        
                            XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
	                        tmpRecipient.update(conn, xTeePais);
                        }
                    }
                    if (tmpRecipient.getSendStatusID() != CommonStructures.SendStatus_Sent) {
                        allSent = false;
                    }
                }
                
                if (!recipientFound) {
                	throw new AxisFault(createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(), 0, 0, bodyData.allyksuseLyhinimetus, bodyData.ametikohaLyhinimetus));
                }
                
                if ((allSent == true) && (tmpSending.getSendStatusID() != CommonStructures.SendStatus_Sent)) {
                    tmpSending.setSendStatusID( CommonStructures.SendStatus_Sent );
                    tmpSending.setEndDate( new Date() );
                    XHeader xTeePais = new XHeader(user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                    tmpSending.update( false, conn, xTeePais );
                }
            } else {
                throw new AxisFault(createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(), 0, 0, bodyData.allyksuseLyhinimetus, bodyData.ametikohaLyhinimetus));
            }
        }
        
        if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("")) {
            DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, false, conn);
        }
        
        return result;
    }
    
    private static String createRecipientNotFoundMessage(int docId, String orgCode, int subdivisionId, int occupationId, String subdivisionShortName, String occupationShortName) {
    	StringBuilder sb = new StringBuilder(1000);
    	sb.append("Dokumendi vastuvüetuks mürkimine ebaünnestus! Etteantud ID-le (").append(docId).append(") vastavat dokumenti ei ole antud asutusele");
        sb.append(orgCode);
        
        if ((subdivisionShortName != null) && (subdivisionShortName.length() > 1)) {
        	sb.append(", allüksusele \"").append(subdivisionShortName).append("\"");
        } else if (subdivisionId > 0) {
        	sb.append(", allüksusele ").append(subdivisionId);
        }
        
        if ((occupationShortName != null) && (occupationShortName.length() > 0)) {
        	sb.append(", ametikohale \"").append(occupationShortName).append("\"");
        } else if (occupationId > 0) {
        	sb.append(", ametikohale ").append(occupationId);
        }
        
        sb.append(" saadetud.");
        return sb.toString();
    }
}
