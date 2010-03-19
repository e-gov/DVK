package dhl.requests;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.FileSplitResult;
import dvk.core.Settings;
import dvk.core.XmlValidator;
import dhl.Document;
import dhl.DocumentFile;
import dhl.DocumentFragment;
import dhl.Folder;
import dhl.Recipient;
import dhl.RecipientTemplate;
import dhl.RemoteServer;
import dhl.Sending;
import dhl.exceptions.ComponentException;
import dhl.exceptions.ContainerValidationException;
import dhl.exceptions.FragmentedDataProcessingException;
import dhl.exceptions.IncorrectSignatureException;
import dhl.exceptions.RequestProcessingException;
import dhl.iostructures.OrgForwardHelper;
import dhl.iostructures.XHeader;
import dhl.iostructures.sendDocumentsRequestType;
import dhl.iostructures.sendDocumentsV2RequestType;
import dhl.sys.Timer;
import dhl.users.Asutus;
import dhl.users.UserProfile;
import dvk.client.ClientAPI;
import dvk.client.businesslayer.Counter;
import dvk.client.businesslayer.DhlMessage;
import dvk.client.conf.OrgSettings;
import dvk.client.db.UnitCredential;
import dvk.core.Fault;
import dvk.core.HeaderVariables;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Hashtable;
import javax.activation.DataSource;
import javax.xml.parsers.ParserConfigurationException;
import org.apache.axis.AxisFault;
import org.apache.log4j.Logger;

public class SendDocuments {
	private static Logger logger = Logger.getLogger(SendDocuments.class);
	
    public static RequestInternalResult V1(org.apache.axis.MessageContext context, Connection conn, UserProfile user, OrgSettings hostOrgSettings, XHeader xTeePais) throws Exception, ParserConfigurationException {
    	logger.info("SendDocuments.V1 invoked.");
    	
        Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);
        
        try {
            // Laeme põringu keha endale sobivasse andmestruktuuri
            sendDocumentsRequestType bodyData = sendDocumentsRequestType.getFromSOAPBody( context );
            if (bodyData == null) {
                throw new AxisFault( CommonStructures.VIGA_VIGANE_KEHA );
            }
            result.folder = bodyData.kaust;
            
            // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
            // - Kui DVK server on seadistatud tõõtama kliendi tabelite peal,
            //   siis pole meil kaustade tabelit olemas ja seega ei saa kausta
            //   ID-d tuvastada.
            int senderTargetFolder = Folder.GLOBAL_ROOT_FOLDER;
            if (!Settings.Server_RunOnClientDatabase) {
                senderTargetFolder = Folder.getFolderIdByPath( bodyData.kaust, user.getOrganizationID(), conn, false, true, xTeePais );
            }
            
            // Leiame sõnumi kehas olnud viite alusels MIME lisast vajalikud andmed
            org.apache.axis.attachments.AttachmentPart px = (org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().getAttachmentsImpl().getAttachmentByReference(bodyData.dokumendid);
            if (px == null) {
                throw new AxisFault( CommonStructures.VIGA_PUUDUV_MIME_LISA );
            }
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
            
            t.reset();
            result.dataMd5Hash = CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false);
            t.markElapsed("Extracting data from SOAP attachment");
            if (result.dataMd5Hash == null) {
                throw new AxisFault( CommonStructures.VIGA_VIGANE_MIME_LISA );
            }
            
            // Pakime andmed GZIPiga lahti
            t.reset();
            if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA );
            }
            t.markElapsed("Extracting attachment data");
            
            // Pakime saadetud dokumentide faili lahti ja laeme selle XML struktuuri
            t.reset();
            FileSplitResult docFiles = CommonMethods.splitOutTags(pipelineDataFile, "dokument", true, false, true);
            t.markElapsed("Splitting attachment data");
            if ((docFiles == null) || (docFiles.subFiles == null) || (docFiles.subFiles.size() < 1)) {
                 throw new AxisFault( CommonStructures.VIGA_VIGANE_MIME_LISA );
            }
            
            t.reset();
            FileOutputStream out = null;
            OutputStreamWriter ow = null;
            BufferedWriter bw = null;
            ArrayList<Document> serverDocuments = new ArrayList<Document>();
            ArrayList<DhlMessage> clientDocuments = new ArrayList<DhlMessage>();
            for (int i = 0; i < docFiles.subFiles.size(); ++i) {
                try {
                    // Valideerime XML dokumendi
                    Fault validationFault = CommonMethods.validateDVKContainer(docFiles.subFiles.get(i));
                    
                    // Sõltuvalt sellest, kas server tõõtab serveri või kliendi
                    // andmebaasi peal, koostame DVK konteineri XML failidest
                    // vastavad andmeobjektid ja salvestame need andmebaasi
                    if (Settings.Server_RunOnClientDatabase) {
                        // Võtame võlja antud andmebaasis seadistatud asutuste nimekirja, et
                        // saaksime XML parsimisel võtta võlja eraldi kirjed, kui smaa sõnumit
                        // on saadetud mitmele asutusele
                        UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings);
                        
                        // Leiame dokumendile DHL_ID
                        int dhlID = Counter.getNextDhlID(hostOrgSettings);
                        
                        ArrayList<DhlMessage> msgList = DhlMessage.getFromXML(docFiles.subFiles.get(i), credentials);
                        for (int j = 0; j < msgList.size(); ++j) {
                            DhlMessage msg = msgList.get(j);
                            msg.setDhlID(dhlID);
                            
                            // Kontrollime, et dokumendi saatjaks või vahendajaks mõrgitud asutus
                            // ja dokumendi reaalselt saatnud asutus oleksid samad.
                            if ((msg.getSenderOrgCode() != user.getOrganizationCode()) &&
                               (msg.getProxyOrgCode() !=  user.getOrganizationCode())) {
                                throw new AxisFault( CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD );
                            }
                            
                            if (validationFault != null) {
                                msg.setFaultActor(validationFault.getFaultActor());
                                msg.setFaultCode(validationFault.getFaultCode());
                                msg.setFaultDetail(validationFault.getFaultDetail());
                                msg.setFaultString(validationFault.getFaultString());
                            }
                            
                            clientDocuments.add(msg);
                        }
                    } else {
                    	// Loome dokumendi andmestruktuuri
                        Document doc = Document.fromXML(docFiles.subFiles.get(i), user.getOrganizationID(), Settings.Server_ValidateXmlFiles, conn, xTeePais);
                        
                        // Vajadusel valideerime saadetavad XML dokumendid
                        validateXmlFiles(doc.getFiles());
                        
                        // Vajadusel kontrollime saadetavate .ddoc ja .bdoc failide allkirjad õle
                        validateSignedFileSignatures(doc.getFiles());
                        
                        // Lisame võõrtused sõnumi põisest ja kehast
                        doc.setFolderID( senderTargetFolder );
                        doc.setOrganizationID( user.getOrganizationID() );
                        
                        // Mõõrame dokumendi sõilitustõhtajaks vaikimisi võõrtuse
                        Calendar calendar = Calendar.getInstance();
                        calendar.setTime(new Date());
                        calendar.add(Calendar.DATE, Settings.Server_DocumentDefaultLifetime);
                        doc.setConservationDeadline(calendar.getTime());
                        
                        // Kontrollime, et dokumendi saatjaks või vahendajaks mõrgitud asutus
                        // ja dokumendi reaalselt saatnud asutus oleksid samad.
                        if (doc.getSendingList() != null) {
                            Sending tmpSending;
                            for (int j = 0; j < doc.getSendingList().size(); ++j) {
                                tmpSending = doc.getSendingList().get(j);
                                if ((tmpSending.getSender() != null) && (tmpSending.getSender().getOrganizationID() != user.getOrganizationID()) &&
                                    (tmpSending.getProxy() != null) && (tmpSending.getProxy().getOrganizationID() != user.getOrganizationID())) {

                                    logger.info("User org ID: " + String.valueOf(user.getOrganizationID()));
                                    logger.info("Sender org ID: " + String.valueOf(tmpSending.getSender().getOrganizationID()));
                                    logger.info("Proxy org ID: " + String.valueOf(tmpSending.getProxy().getOrganizationID()));
                                	
                                	throw new AxisFault( CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD );
                                }
                                if (validationFault != null) {
                                    for (int k = 0; k < tmpSending.getRecipients().size(); ++k) {
                                        tmpSending.getRecipients().get(k).setFault(validationFault);
                                    }
                                }
                            }
                        }
                        
                        // Lisame dokumendile automaatselt lisatavad adressaadid
                        FileSplitResult splitResult = CommonMethods.splitOutTags(doc.getFilePath(), "SignedDoc", false, false, false);
                        doc.setSimplifiedXmlDoc(CommonMethods.xmlDocumentFromFile(splitResult.mainFile, false));
                        RecipientTemplate.applyToDocument(doc, splitResult.mainFile, conn);
                        doc.setSimplifiedXmlDoc(null);
                        out = new FileOutputStream(doc.getFilePath(), false);
                        ow = new OutputStreamWriter(out, "UTF-8");
                        bw = new BufferedWriter(ow);
                        CommonMethods.joinSplitXML(splitResult.mainFile, bw);
                        CommonMethods.safeCloseWriter(bw);
                        CommonMethods.safeCloseWriter(ow);
                        CommonMethods.safeCloseStream(out);
                        
                        // Lisame uue dokumendi laekunud dokumentide listi
                        serverDocuments.add(doc);
                    }
                } finally {
                    CommonMethods.safeCloseWriter(bw);
                    CommonMethods.safeCloseWriter(ow);
                    CommonMethods.safeCloseStream(out);
                    bw = null;
                    ow = null;
                    out = null;
                }
            }
            t.markElapsed("Parsing document XML");
            
            // Salvestame saadud dokumendid andmebaasi ja koostame
            // uute dokumentide ID-de põhjal vastussõnumi.
            try {
                t.reset();
                out = new FileOutputStream(pipelineDataFile, false);
                ow = new OutputStreamWriter(out, "UTF-8"); 
                ow.write("<keha>");
                
                if (Settings.Server_RunOnClientDatabase) {
                    DhlMessage tmpMsg;
                    for (int i = 0; i < clientDocuments.size(); ++i) {
                        tmpMsg = clientDocuments.get(i);
                        tmpMsg.setIsIncoming(true);
                        tmpMsg.setSendingStatusID(Settings.Client_StatusReceived);
                        tmpMsg.setReceivedDate(new Date());
                        tmpMsg.setRecipientStatusID(hostOrgSettings.getDvkSettings().getDefaultStatusID());
                        tmpMsg.setQueryID(xTeePais.id);
                        tmpMsg.setCaseName(xTeePais.toimik);
                        tmpMsg.setDhlFolderName(bodyData.kaust);
                        
                        // Salvestame dokumendi andmebaasi
                        tmpMsg.addToDB(hostOrgSettings);
                        
                        // Tagastame siin kirje ID asemel DHL_ID võõrtuse, kuna
                        // kliendi poolel peaks DVK unikaalne identifikaator
                        // asuma just sellel andmevõljal.
                        if (tmpMsg.getId() > 0) {
                            ow.write("<dhl_id>"+ String.valueOf(tmpMsg.getDhlID()) +"</dhl_id>");
                        } else {
                            throw new AxisFault( CommonStructures.VIGA_SAADETUD_DOKUMENDI_SALVESTAMISEL );
                        }
                    }
                } else {
                    dhl.Document tmpDoc;
                    for (int i = 0; i < serverDocuments.size(); ++i) {
                        tmpDoc = serverDocuments.get(i);
                        
                        // Salvestame dokumendi andmebaasi
                        tmpDoc.addToDB(conn, xTeePais);
                        
                        // Edastame dokumendi vajadusel mõnda teise DVK serverisse
                        ForwardDocument(tmpDoc, bodyData.kaust, conn, 1, xTeePais);
                        
                        if (tmpDoc.getId() > 0) {
                            ow.write("<dhl_id>"+ String.valueOf(tmpDoc.getId()) +"</dhl_id>");
                        }
                        else {
                            throw new AxisFault( CommonStructures.VIGA_SAADETUD_DOKUMENDI_SALVESTAMISEL );
                        }
                    }
                }
                ow.write("</keha>");
                t.markElapsed("Saving documents");
            } finally {
                CommonMethods.safeCloseWriter(ow);
                CommonMethods.safeCloseStream(out);
                ow = null;
                out = null;
                
                // Kustutame ajutisest kataloogist õra andmebaasi salvestatud failid
                t.reset();
                if (Settings.Server_RunOnClientDatabase) {
                    for (int i = 0; i < clientDocuments.size(); ++i) {
                        (new File(clientDocuments.get(i).getFilePath())).delete();
                    }
                } else {
                    for (int i = 0; i < serverDocuments.size(); ++i) {
                        (new File(serverDocuments.get(i).getFilePath())).delete();
                    }
                }
                t.markElapsed("Deleting temporary document files");
            }
            
            t.reset();
            result.responseFile = CommonMethods.gzipPackXML(pipelineDataFile, user.getOrganizationCode(), "sendDocuments");
            t.markElapsed("Compressing response XML");
        } finally {
        	if (pipelineDataFile != null) {
        		(new File(pipelineDataFile)).delete();
        	}
        }
        
        return result;
    }
    
    public static RequestInternalResult V2(org.apache.axis.MessageContext context, Connection conn, UserProfile user, OrgSettings hostOrgSettings, XHeader xTeePais) throws Exception, ParserConfigurationException {
        
    	logger.info("SendDocuments.V2 invoked.");
    	
    	Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);
        String responseDataFile = null;
        
        try {
            // Laeme põringu keha endale sobivasse andmestruktuuri
            sendDocumentsV2RequestType bodyData = sendDocumentsV2RequestType.getFromSOAPBody( context );
            if (bodyData == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_VIGANE_KEHA);
            }
            result.folder = bodyData.kaust;
            
            // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
            // - Kui DVK server on seadistatud tõõtama kliendi tabelite peal,
            //   siis pole meil kaustade tabelit olemas ja seega ei saa kausta
            //   ID-d tuvastada.
            int senderTargetFolder = Folder.GLOBAL_ROOT_FOLDER;
            if (!Settings.Server_RunOnClientDatabase) {
                senderTargetFolder = Folder.getFolderIdByPath( bodyData.kaust, user.getOrganizationID(), conn, false, true, xTeePais );
            }            
            
            // Leiame sõnumi kehas olnud viite alusels MIME lisast vajalikud andmed
            org.apache.axis.attachments.AttachmentPart px = (org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().getAttachmentsImpl().getAttachmentByReference(bodyData.dokumendid);
            if (px == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_PUUDUV_MIME_LISA);
            }
            DataSource attachmentSource = px.getActivationDataHandler().getDataSource();
            if (attachmentSource == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_PUUDUV_MIME_LISA);
            }
            
            // Kontrollime, kas andmeid soovitakse saata fragmentideks jaotatud kujul
            if (bodyData.fragmenteKokku > 0) {
                if ((bodyData.fragmentNr < 0) || (bodyData.fragmentNr >= bodyData.fragmenteKokku)) {
                    throw new FragmentedDataProcessingException("Fragmendi number peab olema vahemikus 0 kuni (fragmente_kokku - 1)!");
                }
                if ((bodyData.edastusID == null) || bodyData.edastusID.equals("")) {
                    throw new FragmentedDataProcessingException("Dokumendi saatmisel fragmentideks jaotatuna tuleks maarata ka elemendi edastus_id vaartus!");
                }
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
            
            t.reset();
            result.dataMd5Hash = CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false);
            t.markElapsed("Extracting data from SOAP attachment");
            if (result.dataMd5Hash == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }
            
            // Kui tegemist on dokumendi fragmendiga, siis salvestame selle
            // fragmentide tabelisse
            if (bodyData.fragmenteKokku > 0) {
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui DVK server on seadistatud tõõtama kliendi andmetabelite peal,
                    // siis teostame fragmentide tõõtlemise andmebaasi asemel kõvakettal
                    String uniqueFolder = CommonMethods.getUniqueDirectory(user.getOrganizationCode(), bodyData.edastusID);
                    if (uniqueFolder == null) {
                        throw new FragmentedDataProcessingException("Viga dokumendi fragmendi tootlemisel! Ei onnestunud luua ajutist kausta fragmentide salvestamiseks!");
                    }
                    String fragmentFileName = uniqueFolder + File.separator + String.valueOf(bodyData.fragmentNr);
                    File pipelineFile = new File(pipelineDataFile);
                    File fragmentFile = new File(fragmentFileName);
                    if (!pipelineFile.renameTo(fragmentFile)) {
                        throw new FragmentedDataProcessingException("Viga dokumendi fragmendi tootlemisel! Faili liigutamine kettal ebaonnestus!");
                    }
                } else {
                    DocumentFragment fragment = new DocumentFragment();
                    fragment.setDateCreated(new Date());
                    fragment.setDeliverySessionID(bodyData.edastusID);
                    fragment.setFileName(pipelineDataFile);
                    fragment.setFragmentCount(bodyData.fragmenteKokku);
                    fragment.setFragmentNr(bodyData.fragmentNr);
                    fragment.setOrganizationID(user.getOrganizationID());
                    fragment.setIsIncoming(true);
                    fragment.addToDBProc(conn, xTeePais);
                    (new File(pipelineDataFile)).delete();
                }
            
                // Kui tegemist on viimase saadetud fragmendiga, siis paneme
                // fragmentidest kokku tervikliku faili.
                if (bodyData.fragmentNr == (bodyData.fragmenteKokku-1)) {
                    if (Settings.Server_RunOnClientDatabase) {
                        pipelineDataFile = CommonMethods.createPipelineFile(0);
                        FileOutputStream fos = null;
                        FileInputStream fis = null;
                        int readLen = 0;
                        byte[] buf = new byte[Settings.getBinaryBufferSize()];
                        String uniqueFolder = CommonMethods.getUniqueDirectory(user.getOrganizationCode(), bodyData.edastusID);
                        try {
                            fos = new FileOutputStream(pipelineDataFile);
                            for (int i = 0; i < bodyData.fragmenteKokku; ++i) {
                                File fragmentFile = new File(uniqueFolder + File.separator + String.valueOf(i));
                                if (!fragmentFile.exists()) {
                                    throw new FragmentedDataProcessingException("Viga fragmentidena saadetud faili kokkupanemisel! Fragment nr "+ String.valueOf(i) +" on vahepealt puudu!");
                                }
                                fis = new FileInputStream(fragmentFile);
                                while ((readLen = fis.read(buf)) > 0) {
                                    fos.write(buf, 0, readLen);
                                }
                                CommonMethods.safeCloseStream(fis);
                            }
                            CommonMethods.safeCloseStream(fos);
                            CommonMethods.deleteDir(new File(uniqueFolder));
                        } finally {
                            CommonMethods.safeCloseStream(fis);
                            CommonMethods.safeCloseStream(fos);
                            fis = null;
                            fos = null;
                            buf = null;
                        }
                    } else {
                        pipelineDataFile = DocumentFragment.getFullDocument(user.getOrganizationID(), bodyData.edastusID, true, conn);
                        
                        // Kustutame andmebaasist fragmendid
                        DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, true, conn);
                        
                        if (pipelineDataFile == null) {
                            throw new FragmentedDataProcessingException("Viga fragmentidena saadetud faili kokkupanemisel!");
                        }
                    }
                }
            }
            
            FileOutputStream out = null;
            OutputStreamWriter ow = null;
            BufferedWriter bw = null;
            ArrayList<Document> serverDocuments = new ArrayList<Document>();
            ArrayList<DhlMessage> clientDocuments = new ArrayList<DhlMessage>();
            if ((bodyData.fragmenteKokku <= 0) || (bodyData.fragmentNr == (bodyData.fragmenteKokku-1))) {
                // Pakime andmed GZIPiga lahti
                t.reset();
                if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
                    throw new RequestProcessingException(CommonStructures.VIGA_VIGANE_MIME_LISA );
                }
                t.markElapsed("Extracting attachment data");
                
                // Pakime saadetud dokumentide faili lahti ja laeme selle XML struktuuri
                t.reset();
                FileSplitResult docFiles = CommonMethods.splitOutTags(pipelineDataFile, "dokument", true, false, true);
                t.markElapsed("Splitting attachment data");
                if ((docFiles == null) || (docFiles.subFiles == null) || (docFiles.subFiles.size() < 1)) {
                     throw new RequestProcessingException( CommonStructures.VIGA_VIGANE_MIME_LISA );
                }
                
                t.reset();
                for (int i = 0; i < docFiles.subFiles.size(); ++i) {
                    try {
                        // Valideerime XML dokumendi
                        Fault validationFault = CommonMethods.validateDVKContainer(docFiles.subFiles.get(i));
                        
                        // Sõltuvalt sellest, kas server tõõtab serveri või kliendi
                        // andmebaasi peal, koostame DVK konteineri XML failidest
                        // vastavad andmeobjektid ja salvestame need andmebaasi
                        if (Settings.Server_RunOnClientDatabase) {
                            // Võtame võlja antud andmebaasis seadistatud asutuste nimekirja, et
                            // saaksime XML parsimisel võtta võlja eraldi kirjed, kui smaa sõnumit
                            // on saadetud mitmele asutusele
                            UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings);

                            // Leiame dokumendile DHL_ID
                            int dhlID = Counter.getNextDhlID(hostOrgSettings);
                            
                            ArrayList<DhlMessage> msgList = DhlMessage.getFromXML(docFiles.subFiles.get(i), credentials);
                            for (int j = 0; j < msgList.size(); ++j) {
                                DhlMessage msg = msgList.get(j);
                                msg.setDhlID(dhlID);
                                
                                // Kontrollime, et dokumendi saatjaks või vahendajaks mõrgitud asutus
                                // ja dokumendi reaalselt saatnud asutus oleksid samad.
                                if (!msg.getSenderOrgCode().equalsIgnoreCase(user.getOrganizationCode()) &&
                                   !msg.getProxyOrgCode().equalsIgnoreCase(user.getOrganizationCode())) {
                                    throw new ContainerValidationException(CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD + " X-Tee: " + user.getOrganizationCode() + ", Sender: " + msg.getSenderOrgCode());
                                }
                                
                                if (validationFault != null) {
                                    msg.setFaultActor(validationFault.getFaultActor());
                                    msg.setFaultCode(validationFault.getFaultCode());
                                    msg.setFaultDetail(validationFault.getFaultDetail());
                                    msg.setFaultString(validationFault.getFaultString());
                                }
                                
                                clientDocuments.add(msg);
                            }
                        } else {
                            Document doc = Document.fromXML(docFiles.subFiles.get(i), user.getOrganizationID(), Settings.Server_ValidateXmlFiles, conn, xTeePais);
                            
                            // Vajadusel valideerime saadetavad XML dokumendid
                            validateXmlFiles(doc.getFiles());
                            
                            // Vajadusel kontrollime saadetavate .ddoc ja .bdoc failide allkirjad õle
                            validateSignedFileSignatures(doc.getFiles());
                            
                            // Lisame võõrtused sõnumi põisest ja kehast
                            doc.setFolderID( senderTargetFolder );
                            doc.setOrganizationID( user.getOrganizationID() );
                            
                            Date conservationDeadline = bodyData.sailitustahtaeg;
                            if (conservationDeadline == null) {
                                // Kui saatja on dokumendi sõilitustõhtaja mõõramata jõtnud või mõõranud
                                // tõhtaja vigaselt, siis mõõrame dokumendi sõilitustõhtajaks vaikimisi võõrtuse
                                Calendar calendar = Calendar.getInstance();
                                calendar.setTime(new Date());
                                calendar.add(Calendar.DATE, Settings.Server_DocumentDefaultLifetime);
                                doc.setConservationDeadline(calendar.getTime());
                                calendar = null;
                            } else {
                                doc.setConservationDeadline(conservationDeadline);
                            }
                            
                            // Kontrollime, et dokumendi saatjaks või vahendajaks mõrgitud asutus
                            // ja dokumendi reaalselt saatnud asutus oleksid samad.
                            if (doc.getSendingList() != null) {
                                Sending tmpSending;
                                for (int j = 0; j < doc.getSendingList().size(); ++j) {
                                    tmpSending = doc.getSendingList().get(j);
                                    if ((tmpSending.getSender() != null) && (tmpSending.getSender().getOrganizationID() != user.getOrganizationID()) &&
                                        (tmpSending.getProxy() != null) && (tmpSending.getProxy().getOrganizationID() != user.getOrganizationID())) {
                                        throw new ContainerValidationException(CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD);
                                    }
                                    if (validationFault != null) {
                                        for (int k = 0; k < tmpSending.getRecipients().size(); ++k) {
                                            tmpSending.getRecipients().get(k).setFault(validationFault);
                                        }
                                    }
                                }
                            }
                            
                            // Lisame dokumendile automaatselt lisatavad adressaadid
                            FileSplitResult splitResult = CommonMethods.splitOutTags(doc.getFilePath(), "SignedDoc", false, false, false);
                            doc.setSimplifiedXmlDoc(CommonMethods.xmlDocumentFromFile(splitResult.mainFile, false));
                            RecipientTemplate.applyToDocument(doc, splitResult.mainFile, conn);
                            doc.setSimplifiedXmlDoc(null);
                            out = new FileOutputStream(doc.getFilePath(), false);
                            ow = new OutputStreamWriter(out, "UTF-8");
                            bw = new BufferedWriter(ow);
                            CommonMethods.joinSplitXML(splitResult.mainFile, bw);
                            CommonMethods.safeCloseWriter(bw);
                            CommonMethods.safeCloseWriter(ow);
                            CommonMethods.safeCloseStream(out);
                            
                            // Lisame uue dokumendi laekunud dokumentide listi
                            serverDocuments.add(doc);
                        }
                    } finally {
                        CommonMethods.safeCloseWriter(bw);
                        CommonMethods.safeCloseWriter(ow);
                        CommonMethods.safeCloseStream(out);
                        bw = null;
                        ow = null;
                        out = null;
                    }
                }
                t.markElapsed("Parsing document XML");
            }
            
            // Salvestame saadud dokumendid andmebaasi ja koostame
            // uute dokumentide ID-de põhjal vastussõnumi.
            try {
                t.reset();
                responseDataFile = CommonMethods.createPipelineFile(0);
                out = new FileOutputStream(responseDataFile, false);
                ow = new OutputStreamWriter(out, "UTF-8"); 
                ow.write("<keha>");
                
                if ((bodyData.fragmenteKokku <= 0) || (bodyData.fragmentNr == (bodyData.fragmenteKokku-1))) {
                    if (Settings.Server_RunOnClientDatabase) {
                        DhlMessage tmpMsg;
                        for (int i = 0; i < clientDocuments.size(); ++i) {
                            tmpMsg = clientDocuments.get(i);
                            tmpMsg.setIsIncoming(true);
                            tmpMsg.setSendingStatusID(Settings.Client_StatusReceived);
                            tmpMsg.setReceivedDate(new Date());
                            tmpMsg.setRecipientStatusID(hostOrgSettings.getDvkSettings().getDefaultStatusID());
                            tmpMsg.setQueryID(xTeePais.id);
                            tmpMsg.setCaseName(xTeePais.toimik);
                            tmpMsg.setDhlFolderName(bodyData.kaust);
                            
                            // Salvestame dokumendi andmebaasi
                            tmpMsg.addToDB(hostOrgSettings);
                            
                            // Tagastame siin kirje ID asemel DHL_ID võõrtuse, kuna
                            // kliendi poolel peaks DVK unikaalne identifikaator
                            // asuma just sellel andmevõljal.
                            if (tmpMsg.getId() > 0) {
                                ow.write("<dhl_id>"+ String.valueOf(tmpMsg.getDhlID()) +"</dhl_id>");
                            } else {
                                throw new AxisFault( CommonStructures.VIGA_SAADETUD_DOKUMENDI_SALVESTAMISEL );
                            }
                        }
                    } else {
                        dhl.Document tmpDoc;
                        for (int i = 0; i < serverDocuments.size(); ++i) {
                            tmpDoc = serverDocuments.get(i);
                            
                            // Salvestame dokumendi andmebaasi
                            tmpDoc.addToDB(conn, xTeePais);
                            
                            // Edastame dokumendi vajadusel mõnda teise DVK serverisse
                            ForwardDocument(tmpDoc, bodyData.kaust, conn, 2, xTeePais);
                            
                            if (tmpDoc.getId() > 0) {
                                ow.write("<dhl_id>"+ String.valueOf(tmpDoc.getId()) +"</dhl_id>");
                            } else {
                                throw new AxisFault( CommonStructures.VIGA_SAADETUD_DOKUMENDI_SALVESTAMISEL );
                            }
                        }
                    }
                } else {
                    ow.write("<dhl_id>0</dhl_id>");
                }
                ow.write("</keha>");
                t.markElapsed("Saving documents");
            } finally {
                CommonMethods.safeCloseWriter(ow);
                CommonMethods.safeCloseStream(out);
                ow = null;
                out = null;
                
                // Kustutame ajutisest kataloogist õra andmebaasi salvestatud failid
                t.reset();
                if (Settings.Server_RunOnClientDatabase) {
                    for (int i = 0; i < clientDocuments.size(); ++i) {
                        (new File(clientDocuments.get(i).getFilePath())).delete();
                    }
                } else {
                    for (int i = 0; i < serverDocuments.size(); ++i) {
                        (new File(serverDocuments.get(i).getFilePath())).delete();
                    }
                }
                t.markElapsed("Deleting temporary document files");
            }
            
            t.reset();
            result.responseFile = CommonMethods.gzipPackXML(responseDataFile, user.getOrganizationCode(), "sendDocuments");
            t.markElapsed("Compressing response XML");
        }
        finally {
        	if (pipelineDataFile != null) {
        		(new File(pipelineDataFile)).delete();
        	}
        	if (responseDataFile != null) {
        		(new File(responseDataFile)).delete();
        	}
        }
        
        return result;
    }
    
    /**
     * Uus versioon põringust. Muudatused:
     * 
     * 1. Kaotatud element <allyksuse_kood />
     * 
     * @param context
     * @param conn
     * @param user
     * @param hostOrgSettings
     * @param xTeePais
     * @return
     * @throws AxisFault
     * @throws ParserConfigurationException
     */
    public static RequestInternalResult V3(org.apache.axis.MessageContext context, Connection conn, UserProfile user, OrgSettings hostOrgSettings, XHeader xTeePais) throws Exception, ParserConfigurationException {
        
    	logger.info("SendDocuments.V3 invoked.");
    	
    	Timer t = new Timer();
        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);
        String responseDataFile = null;
        
        try {
            // Laeme põringu keha endale sobivasse andmestruktuuri
            sendDocumentsV2RequestType bodyData = sendDocumentsV2RequestType.getFromSOAPBody( context );
            if (bodyData == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_VIGANE_KEHA);
            }
            result.folder = bodyData.kaust;
            
            // Tuvastame, millisesse kausta soovitakse dokumenti salvestada
            // - Kui DVK server on seadistatud tõõtama kliendi tabelite peal,
            //   siis pole meil kaustade tabelit olemas ja seega ei saa kausta
            //   ID-d tuvastada.
            int senderTargetFolder = Folder.GLOBAL_ROOT_FOLDER;
            if (!Settings.Server_RunOnClientDatabase) {
                senderTargetFolder = Folder.getFolderIdByPath( bodyData.kaust, user.getOrganizationID(), conn, false, true, xTeePais );
            }            
            
            // Leiame sõnumi kehas olnud viite alusels MIME lisast vajalikud andmed
            org.apache.axis.attachments.AttachmentPart px = (org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().getAttachmentsImpl().getAttachmentByReference(bodyData.dokumendid);
            if (px == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_PUUDUV_MIME_LISA);
            }
            DataSource attachmentSource = px.getActivationDataHandler().getDataSource();
            if (attachmentSource == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_PUUDUV_MIME_LISA);
            }
            
            // Kontrollime, kas andmeid soovitakse saata fragmentideks jaotatud kujul
            if (bodyData.fragmenteKokku > 0) {
                if ((bodyData.fragmentNr < 0) || (bodyData.fragmentNr >= bodyData.fragmenteKokku)) {
                    throw new FragmentedDataProcessingException("Fragmendi number peab olema vahemikus 0 kuni (fragmente_kokku - 1)!");
                }
                if ((bodyData.edastusID == null) || bodyData.edastusID.equals("")) {
                    throw new FragmentedDataProcessingException("Dokumendi saatmisel fragmentideks jaotatuna tuleks maarata ka elemendi edastus_id vaartus!");
                }
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
            
            t.reset();
            result.dataMd5Hash = CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false);
            t.markElapsed("Extracting data from SOAP attachment");
            if (result.dataMd5Hash == null) {
                throw new RequestProcessingException(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }
            
            // Kui tegemist on dokumendi fragmendiga, siis salvestame selle
            // fragmentide tabelisse
            if (bodyData.fragmenteKokku > 0) {
                if (Settings.Server_RunOnClientDatabase) {
                    // Kui DVK server on seadistatud tõõtama kliendi andmetabelite peal,
                    // siis teostame fragmentide tõõtlemise andmebaasi asemel kõvakettal
                    String uniqueFolder = CommonMethods.getUniqueDirectory(user.getOrganizationCode(), bodyData.edastusID);
                    if (uniqueFolder == null) {
                        throw new FragmentedDataProcessingException("Viga dokumendi fragmendi tootlemisel! Ei onnestunud luua ajutist kausta fragmentide salvestamiseks!");
                    }
                    String fragmentFileName = uniqueFolder + File.separator + String.valueOf(bodyData.fragmentNr);
                    File pipelineFile = new File(pipelineDataFile);
                    File fragmentFile = new File(fragmentFileName);
                    if (!pipelineFile.renameTo(fragmentFile)) {
                        throw new FragmentedDataProcessingException("Viga dokumendi fragmendi tootlemisel! Faili liigutamine kettal ebaonnestus!");
                    }
                } else {
                    DocumentFragment fragment = new DocumentFragment();
                    fragment.setDateCreated(new Date());
                    fragment.setDeliverySessionID(bodyData.edastusID);
                    fragment.setFileName(pipelineDataFile);
                    fragment.setFragmentCount(bodyData.fragmenteKokku);
                    fragment.setFragmentNr(bodyData.fragmentNr);
                    fragment.setOrganizationID(user.getOrganizationID());
                    fragment.setIsIncoming(true);
                    fragment.addToDBProc(conn, xTeePais);
                    (new File(pipelineDataFile)).delete();
                }
            
                // Kui tegemist on viimase saadetud fragmendiga, siis paneme
                // fragmentidest kokku tervikliku faili.
                if (bodyData.fragmentNr == (bodyData.fragmenteKokku-1)) {
                    if (Settings.Server_RunOnClientDatabase) {
                        pipelineDataFile = CommonMethods.createPipelineFile(0);
                        FileOutputStream fos = null;
                        FileInputStream fis = null;
                        int readLen = 0;
                        byte[] buf = new byte[Settings.getBinaryBufferSize()];
                        String uniqueFolder = CommonMethods.getUniqueDirectory(user.getOrganizationCode(), bodyData.edastusID);
                        try {
                            fos = new FileOutputStream(pipelineDataFile);
                            for (int i = 0; i < bodyData.fragmenteKokku; ++i) {
                                File fragmentFile = new File(uniqueFolder + File.separator + String.valueOf(i));
                                if (!fragmentFile.exists()) {
                                    throw new FragmentedDataProcessingException("Viga fragmentidena saadetud faili kokkupanemisel! Fragment nr "+ String.valueOf(i) +" on vahepealt puudu!");
                                }
                                fis = new FileInputStream(fragmentFile);
                                while ((readLen = fis.read(buf)) > 0) {
                                    fos.write(buf, 0, readLen);
                                }
                                CommonMethods.safeCloseStream(fis);
                            }
                            CommonMethods.safeCloseStream(fos);
                            CommonMethods.deleteDir(new File(uniqueFolder));
                        } finally {
                            CommonMethods.safeCloseStream(fis);
                            CommonMethods.safeCloseStream(fos);
                            fis = null;
                            fos = null;
                            buf = null;
                        }
                    } else {
                        pipelineDataFile = DocumentFragment.getFullDocument(user.getOrganizationID(), bodyData.edastusID, true, conn);
                        
                        // Kustutame andmebaasist fragmendid
                        DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, true, conn);
                        
                        if (pipelineDataFile == null) {
                            throw new FragmentedDataProcessingException("Viga fragmentidena saadetud faili kokkupanemisel!");
                        }
                    }
                }
            }
            
            FileOutputStream out = null;
            OutputStreamWriter ow = null;
            BufferedWriter bw = null;
            ArrayList<Document> serverDocuments = new ArrayList<Document>();
            ArrayList<DhlMessage> clientDocuments = new ArrayList<DhlMessage>();            
            if ((bodyData.fragmenteKokku <= 0) || (bodyData.fragmentNr == (bodyData.fragmenteKokku-1))) {
                // Pakime andmed GZIPiga lahti
                t.reset();
                if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
                    throw new RequestProcessingException(CommonStructures.VIGA_VIGANE_MIME_LISA);
                }
                t.markElapsed("Extracting attachment data");
                
                // Pakime saadetud dokumentide faili lahti ja laeme selle XML struktuuri
                t.reset();
                
                FileSplitResult docFiles = CommonMethods.splitOutTags(pipelineDataFile, "dokument", true, false, true);
                t.markElapsed("Splitting attachment data");
                    if ((docFiles == null) || (docFiles.subFiles == null) || (docFiles.subFiles.size() < 1)) {
                     throw new RequestProcessingException(CommonStructures.VIGA_VIGANE_MIME_LISA);
                }
                
                t.reset();
                for (int i = 0; i < docFiles.subFiles.size(); ++i) {
                    try {
                        // Valideerime XML dokumendi
                        Fault validationFault = CommonMethods.validateDVKContainer(docFiles.subFiles.get(i));
                        
                        // Sõltuvalt sellest, kas server tõõtab serveri või kliendi
                        // andmebaasi peal, koostame DVK konteineri XML failidest
                        // vastavad andmeobjektid ja salvestame need andmebaasi
                        if (Settings.Server_RunOnClientDatabase) {
                            // Võtame võlja antud andmebaasis seadistatud asutuste nimekirja, et
                            // saaksime XML parsimisel võtta võlja eraldi kirjed, kui smaa sõnumit
                            // on saadetud mitmele asutusele
                            UnitCredential[] credentials = UnitCredential.getCredentials(hostOrgSettings);

                            // Leiame dokumendile DHL_ID
                            int dhlID = Counter.getNextDhlID(hostOrgSettings);
                            
                            ArrayList<DhlMessage> msgList = DhlMessage.getFromXML(docFiles.subFiles.get(i), credentials);
                            for (int j = 0; j < msgList.size(); ++j) {
                                DhlMessage msg = msgList.get(j);
                                msg.setDhlID(dhlID);
                                
                                // Kontrollime, et dokumendi saatjaks või vahendajaks mõrgitud asutus
                                // ja dokumendi reaalselt saatnud asutus oleksid samad.
                                if (!msg.getSenderOrgCode().equalsIgnoreCase(user.getOrganizationCode()) &&
                                   !msg.getProxyOrgCode().equalsIgnoreCase(user.getOrganizationCode())) {
                                    throw new ContainerValidationException(CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD + " X-Tee: " + user.getOrganizationCode() + ", Sender: " + msg.getSenderOrgCode());
                                }
                                
                                if (validationFault != null) {
                                    msg.setFaultActor(validationFault.getFaultActor());
                                    msg.setFaultCode(validationFault.getFaultCode());
                                    msg.setFaultDetail(validationFault.getFaultDetail());
                                    msg.setFaultString(validationFault.getFaultString());
                                }
                                
                                clientDocuments.add(msg);
                            }
                        } else {
                            Document doc = Document.fromXML(docFiles.subFiles.get(i), user.getOrganizationID(), Settings.Server_ValidateXmlFiles, conn, xTeePais);
                            
                            // Vajadusel valideerime saadetavad XML dokumendid
                            validateXmlFiles(doc.getFiles());
                            
                            // Vajadusel kontrollime saadetavate .ddoc ja .bdoc failide allkirjad õle
                            validateSignedFileSignatures(doc.getFiles());
                            
                            // Lisame võõrtused sõnumi põisest ja kehast
                            doc.setFolderID( senderTargetFolder );
                            doc.setOrganizationID( user.getOrganizationID() );
                            
                            Date conservationDeadline = bodyData.sailitustahtaeg;
                            if (conservationDeadline == null) {
                                // Kui saatja on dokumendi sõilitustõhtaja mõõramata jõtnud või mõõranud
                                // tõhtaja vigaselt, siis mõõrame dokumendi sõilitustõhtajaks vaikimisi võõrtuse
                                Calendar calendar = Calendar.getInstance();
                                calendar.setTime(new Date());
                                calendar.add(Calendar.DATE, Settings.Server_DocumentDefaultLifetime);
                                doc.setConservationDeadline(calendar.getTime());
                                calendar = null;
                            } else {
                                doc.setConservationDeadline(conservationDeadline);
                            }
                            
                            // Kontrollime, et dokumendi saatjaks või vahendajaks mõrgitud asutus
                            // ja dokumendi reaalselt saatnud asutus oleksid samad.
                            if (doc.getSendingList() != null) {
                                Sending tmpSending;
                                for (int j = 0; j < doc.getSendingList().size(); ++j) {
                                    tmpSending = doc.getSendingList().get(j);
                                    if ((tmpSending.getSender() != null) && (tmpSending.getSender().getOrganizationID() != user.getOrganizationID()) &&
                                        (tmpSending.getProxy() != null) && (tmpSending.getProxy().getOrganizationID() != user.getOrganizationID())) {
                                        throw new ContainerValidationException(CommonStructures.VIGA_SAATJA_ASUTUSED_ERINEVAD);
                                    }
                                    if (validationFault != null) {
                                        for (int k = 0; k < tmpSending.getRecipients().size(); ++k) {
                                            tmpSending.getRecipients().get(k).setFault(validationFault);
                                        }
                                    }
                                }
                            }
                            
                            // Lisame dokumendile automaatselt lisatavad adressaadid
                            FileSplitResult splitResult = CommonMethods.splitOutTags(doc.getFilePath(), "failid", false, false, false);
                            doc.setSimplifiedXmlDoc(CommonMethods.xmlDocumentFromFile(splitResult.mainFile, false));
                            RecipientTemplate.applyToDocument(doc, splitResult.mainFile, conn);
                            doc.setSimplifiedXmlDoc(null);
                            out = new FileOutputStream(doc.getFilePath(), false);
                            ow = new OutputStreamWriter(out, "UTF-8");
                            bw = new BufferedWriter(ow);
                            CommonMethods.joinSplitXML(splitResult.mainFile, bw);
                            CommonMethods.safeCloseWriter(bw);
                            CommonMethods.safeCloseWriter(ow);
                            CommonMethods.safeCloseStream(out);
                            
                            // Lisame uue dokumendi laekunud dokumentide listi
                            serverDocuments.add(doc);
                        }
                    } finally {
                        CommonMethods.safeCloseWriter(bw);
                        CommonMethods.safeCloseWriter(ow);
                        CommonMethods.safeCloseStream(out);
                        bw = null;
                        ow = null;
                        out = null;
                    }
                }
                t.markElapsed("Parsing document XML");
            }
            
            // Salvestame saadud dokumendid andmebaasi ja koostame
            // uute dokumentide ID-de põhjal vastussõnumi.
            try {
                t.reset();
                responseDataFile = CommonMethods.createPipelineFile(0);
                out = new FileOutputStream(responseDataFile, false);
                ow = new OutputStreamWriter(out, "UTF-8"); 
                ow.write("<keha>");
                
                if ((bodyData.fragmenteKokku <= 0) || (bodyData.fragmentNr == (bodyData.fragmenteKokku-1))) {
                    if (Settings.Server_RunOnClientDatabase) {
                        DhlMessage tmpMsg;
                        for (int i = 0; i < clientDocuments.size(); ++i) {
                            tmpMsg = clientDocuments.get(i);
                            tmpMsg.setIsIncoming(true);
                            tmpMsg.setSendingStatusID(Settings.Client_StatusReceived);
                            tmpMsg.setReceivedDate(new Date());
                            tmpMsg.setRecipientStatusID(hostOrgSettings.getDvkSettings().getDefaultStatusID());
                            tmpMsg.setQueryID(xTeePais.id);
                            tmpMsg.setCaseName(xTeePais.toimik);
                            tmpMsg.setDhlFolderName(bodyData.kaust);
                            
                            // Salvestame dokumendi andmebaasi
                            tmpMsg.addToDB(hostOrgSettings);
                            
                            // Tagastame siin kirje ID asemel DHL_ID võõrtuse, kuna
                            // kliendi poolel peaks DVK unikaalne identifikaator
                            // asuma just sellel andmevõljal.
                            if (tmpMsg.getId() > 0) {
                                ow.write("<dhl_id>"+ String.valueOf(tmpMsg.getDhlID()) +"</dhl_id>");
                            } else {
                                throw new AxisFault( CommonStructures.VIGA_SAADETUD_DOKUMENDI_SALVESTAMISEL );
                            }
                        }
                    } else {
                        dhl.Document tmpDoc;
                        for (int i = 0; i < serverDocuments.size(); ++i) {
                            tmpDoc = serverDocuments.get(i);
                            
                            // Salvestame dokumendi andmebaasi
                            //tmpDoc.addToDB( conn );
                            tmpDoc.addToDB(conn, xTeePais);
                            
                            // Edastame dokumendi vajadusel mõnda teise DVK serverisse
                            ForwardDocument(tmpDoc, bodyData.kaust, conn, 3, xTeePais);
                            
                            if (tmpDoc.getId() > 0) {
                                ow.write("<dhl_id>"+ String.valueOf(tmpDoc.getId()) +"</dhl_id>");
                            }
                            else {
                                throw new AxisFault( CommonStructures.VIGA_SAADETUD_DOKUMENDI_SALVESTAMISEL );
                            }
                        }
                    }
                } else {
                    ow.write("<dhl_id>0</dhl_id>");
                }
                ow.write("</keha>");
                t.markElapsed("Saving documents");
            } finally {
                CommonMethods.safeCloseWriter(ow);
                CommonMethods.safeCloseStream(out);
                ow = null;
                out = null;
                
                // Kustutame ajutisest kataloogist õra andmebaasi salvestatud failid
                t.reset();
                if (Settings.Server_RunOnClientDatabase) {
                    for (int i = 0; i < clientDocuments.size(); ++i) {
                        (new File(clientDocuments.get(i).getFilePath())).delete();
                    }
                } else {
                    for (int i = 0; i < serverDocuments.size(); ++i) {
                        (new File(serverDocuments.get(i).getFilePath())).delete();
                    }
                }
                t.markElapsed("Deleting temporary document files");
            }
            
            t.reset();
            result.responseFile = CommonMethods.gzipPackXML(responseDataFile, user.getOrganizationCode(), "sendDocuments");
            t.markElapsed("Compressing response XML");
        } finally {
        	if (pipelineDataFile != null) {
        		(new File(pipelineDataFile)).delete();
        	}
        	if (responseDataFile != null) {
        		(new File(responseDataFile)).delete();
        	}
        }
        
        return result;
    }
    
    // Edastab dokumendi teise DVK serverisse
    private static ArrayList<Sending> ForwardDocument(dhl.Document doc, String kaust, Connection conn, int requestVersion, XHeader xTeePais) throws Exception {
        ArrayList<Sending> sendingList = doc.getSendingList();
        int lastSendingIndex = -1;
        if ((sendingList != null) && !sendingList.isEmpty()) {
            Sending lastSending = null;
            for (int i = sendingList.size()-1; i >= 0; --i) {
                if (sendingList.get(i).getIsNewlyAdded()) {
                    lastSending = sendingList.get(i);
                    lastSendingIndex = i;
                    break;
                }
            }
            
            if ((lastSending != null) && (lastSending.getRecipients() != null)) {
                ArrayList<Recipient> recipients = lastSending.getRecipients();
                Asutus org = new Asutus();
                Hashtable<Integer, ArrayList<OrgForwardHelper>> addressTable = new Hashtable<Integer, ArrayList<OrgForwardHelper>>();
                ArrayList<Integer> addressKeys = new ArrayList<Integer>();
                boolean needToForward = false;
                for (int i = 0; i < recipients.size(); ++i) {
                    org.loadByID(recipients.get(i).getOrganizationID(), conn);
                    logger.info("Organization " + String.valueOf(recipients.get(i).getOrganizationID()) + ", server ID: " + String.valueOf(org.getServerID()));
                    if (org.getServerID() > 0) {
                        needToForward = true;
                        if (addressTable.containsKey(org.getServerID())) {
                            ArrayList<OrgForwardHelper> orgArray = addressTable.get(org.getServerID());
                            orgArray.add(new OrgForwardHelper(i, org.getRegistrikood()));
                            addressTable.put(org.getServerID(), orgArray);
                        } else {
                            ArrayList<OrgForwardHelper> orgArray = new ArrayList<OrgForwardHelper>();
                            orgArray.add(new OrgForwardHelper(i, org.getRegistrikood()));
                            addressTable.put(org.getServerID(), orgArray);
                            addressKeys.add(org.getServerID());
                        }
                    }
                }
                
                if (needToForward) {
                	for (int j = 0; j < addressKeys.size(); ++j) {
                        int key = addressKeys.get(j);
                        ArrayList<OrgForwardHelper> orgArray = addressTable.get(key);
                        
                        // Koostame nimekirja asutustest, mille aadressid peavad konteineri
                        // <transport> plokki alles jõõma
                        ArrayList<String> allowedOrgs = new ArrayList<String>();
                        for (int i = 0; i < orgArray.size(); ++i) {
                            allowedOrgs.add(orgArray.get(i).OrgCode);
                            logger.info("Organization " + orgArray.get(i).OrgCode + " will be left to forwarded message addressee list.");
                        }
                        
                        // Kopeerime dokumendi faili uueks tõõfailiks
                        String simplifiedFile = CommonMethods.createPipelineFile(0);
                        if (CommonMethods.copyFile(doc.getFilePath(), simplifiedFile)) {
                            String newFile = CommonMethods.createPipelineFile(1);
                            if(requestVersion == 3) {
                            	CommonMethods.splitOutTags(simplifiedFile, "failid", false, false, true);
                            } else {
                            	CommonMethods.splitOutTags(simplifiedFile, "SignedDoc", false, false, true);
                            }
                            
                            FileOutputStream out = null;
                            OutputStreamWriter ow = null;
                            BufferedWriter bw = null;
                            try {
                                CommonMethods.changeTransportData(simplifiedFile, allowedOrgs, true);
                                out = new FileOutputStream(newFile, false);
                                ow = new OutputStreamWriter(out, "UTF-8");
                                bw = new BufferedWriter(ow);
                                CommonMethods.joinSplitXML(simplifiedFile, bw);
                            } finally {
                                CommonMethods.safeCloseWriter(bw);
                                CommonMethods.safeCloseWriter(ow);
                                CommonMethods.safeCloseStream(out);
                            }
                            
                            // Forward document
                            RemoteServer server = new RemoteServer(key, conn);
                            if ((server != null) && (server.getAddress() != null) && !server.getAddress().equalsIgnoreCase("")) {
                                ClientAPI dvkClient = new ClientAPI();
                                dvkClient.initClient(server.getAddress(), server.getProducerName());
                                HeaderVariables header = new HeaderVariables(
                                    Settings.Client_DefaultOrganizationCode,
                                    Settings.Client_DefaultPersonCode,
                                    "",
                                    (CommonMethods.personalIDCodeHasCountryCode(Settings.Client_DefaultPersonCode) ? Settings.Client_DefaultPersonCode : "EE"+Settings.Client_DefaultPersonCode));
        
                                DhlMessage dvkMessage = new DhlMessage();
                                dvkMessage.setFilePath(newFile);
                                dvkMessage.setDhlFolderName(kaust);
                                
                                int docNewID = dvkClient.sendDocuments(header, dvkMessage, requestVersion);
                                for (int i = 0; i < orgArray.size(); ++i) {
                                    // Mõrgime dokumendi ID vastuvõtja andmete juurde
                                    Recipient tmpRecipient = lastSending.getRecipients().get(orgArray.get(i).Index);
                                    tmpRecipient.setIdInRemoteServer(docNewID);
                                    tmpRecipient.update(conn, xTeePais);
                                    lastSending.getRecipients().set(i, tmpRecipient);
                                }
                            } else {
                                throw new Exception("Dokumendi edastamine ebaõnnestus!");
                            }
                        } else {
                            throw new Exception("Dokumendi faili kopeerimine edastamiseks ebaõnnestus!");
                        }
                    }
                } else {
                	logger.info("Document does not need to be forwarded");
                }
                sendingList.set(lastSendingIndex, lastSending);
            }
        } else {
        	logger.info("Document sending list is empty");
        }
        return sendingList;
    }
    
    private static void validateXmlFiles(ArrayList<DocumentFile> docFiles) throws AxisFault, Exception {
    	if (Settings.Server_ValidateXmlFiles && (docFiles != null)) {
    		logger.info("Starting XML validation of total " + String.valueOf(docFiles.size()) + " files.");
    		ArrayList<String> allErrors = new ArrayList<String>();
    		
    		for (int i = 0; i < docFiles.size(); i++) {
        		String originalFileName = docFiles.get(i).getFileName();
    			String localFileName = docFiles.get(i).getLocalFileFullName();
    			
    			if (originalFileName.toLowerCase().endsWith("xml")) {
	    			ArrayList<String> validationErrors = XmlValidator.Validate(localFileName);
	    			if ((validationErrors != null) && (validationErrors.size() > 0)) {
	    				allErrors.addAll(validationErrors);
	    			} else {
	    				logger.info("File \"" + originalFileName + "\" is valid.");
	    			}
    			} else if (originalFileName.toLowerCase().endsWith("ddoc") || originalFileName.toLowerCase().endsWith("bdoc")) {
    				ArrayList<String> signedFiles = docFiles.get(i).getFilesFromDdocBdoc("xml");
    				if ((signedFiles != null) && (signedFiles.size() > 0)) {
	    				for (int j = 0; j < signedFiles.size(); j++) {
	    	    			ArrayList<String> validationErrors = XmlValidator.Validate(signedFiles.get(j));
	    	    			if ((validationErrors != null) && (validationErrors.size() > 0)) {
	    	    				allErrors.addAll(validationErrors);
	    	    			} else {
	    	    				logger.info("File \"" + signedFiles.get(j) + "\" is valid.");
	    	    			}
	    				}
    				}
    			}
        	}
    		
    		if ((allErrors != null) && (allErrors.size() > 0)) {
    			StringBuilder sb = new StringBuilder(10000);
    			for (String error : allErrors) {
    				sb.append(error).append("; ");
    			}
    			throw new AxisFault(sb.toString());
    		}
        }
    }
    
    private static void validateSignedFileSignatures(ArrayList<DocumentFile> docFiles) throws ComponentException, IncorrectSignatureException {
    	if (Settings.Server_ValidateSignatures && (docFiles != null)) {
    		logger.info("Starting signature validation of total " + String.valueOf(docFiles.size()) + " files.");
    		ArrayList<String> allErrors = new ArrayList<String>();
    		
    		for (int i = 0; i < docFiles.size(); i++) {
        		String fileName = docFiles.get(i).getFileName();
    			
    			if (fileName.toLowerCase().endsWith("ddoc") || fileName.toLowerCase().endsWith("bdoc")) {
    				ArrayList<String> validationErrors = docFiles.get(i).validateFileSignatures();
    				if ((validationErrors != null) && (validationErrors.size() > 0)) {
    					allErrors.addAll(validationErrors);
    				}
    			}
        	}
    		
    		if ((allErrors != null) && (allErrors.size() > 0)) {
    			StringBuilder sb = new StringBuilder(10000);
    			for (String error : allErrors) {
    				sb.append(error).append("; ");
    			}
    			throw new IncorrectSignatureException(sb.toString());
    		}
    	}
    }
}
