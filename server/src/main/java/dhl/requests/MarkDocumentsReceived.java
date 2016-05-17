package dhl.requests;

import dhl.DocumentFragment;
import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadProtocolHeader;
import dhl.Recipient;
import dhl.Sending;
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

public class MarkDocumentsReceived {
    private static Logger logger = Logger.getLogger(MarkDocumentsReceived.class);

    public static RequestInternalResult V1(
            org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws SQLException, AxisFault {
        logger.info("MarkDocumentsReceived.V1 invoked.");

        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Lame SOAP keha endale sobivasse andmestruktuuri
            markDocumentsReceivedRequestType bodyData = markDocumentsReceivedRequestType.getFromSOAPBody(context);
            if (bodyData == null) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_KEHA);
            }
            result.folder = bodyData.kaust;

            org.apache.axis.attachments.AttachmentPart px =
                    (org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().
                            getAttachmentsImpl().getAttachmentByReference(bodyData.dokumendidHref);
            DataSource attachmentSource = px.getActivationDataHandler().getDataSource();
            if (attachmentSource == null) {
                throw new AxisFault(CommonStructures.VIGA_PUUDUV_MIME_LISA);
            }

            // Laeme SOAP attachmendis asunud andmed baidimassiivi
            String[] headers = px.getMimeHeader("Content-Transfer-Encoding");
            String encoding;
            if ((headers == null) || (headers.length < 1)) {
                encoding = "base64";
            } else {
                encoding = headers[0];
            }
            result.dataMd5Hash = CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false);
            if (result.dataMd5Hash == null) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }

            // Pakime andmed GZIPiga lahti
            if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA);
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

                            // Kui päringus on täpsustatud, millise allüksuse ja/või ametikoha
                            // dokumendid tuleb vastuvõetuks märkida, siis kontrollime, et
                            // ametikoha ja/või allüksuse ID adressaadi andmetes
                            // vastaks päringu parameetritele.
                            // Vastasel juhul märgiks rakendus dokumendi vastuvõetuks kõigi
                            // adressaatide poolt, kes kuuluvad päringu teinud asutuse alla.
                            if (((bodyData.allyksusId <= 0) || (tmpRecipient.getDivisionID() == bodyData.allyksusId))
                                    && ((bodyData.ametikohtId <= 0) || (tmpRecipient.getPositionID() == bodyData.ametikohtId))) {
                                recipientFound = true;
                                tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Sent);
                                tmpRecipient.setSendingEndDate(new Date());
                                tmpRecipient.setStatusDate(new Date());
                                XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                        user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                                tmpRecipient.update(conn, xTeePais);
                            }
                        }
                        if (tmpRecipient.getSendStatusID() != CommonStructures.SendStatus_Sent) {
                            allSent = false;
                        }
                    }

                    if (!recipientFound) {
                        throw new AxisFault(createRecipientNotFoundMessage(
                                docID, user.getOrganizationCode(), bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                    }

                    if (allSent && (tmpSending.getSendStatusID() != CommonStructures.SendStatus_Sent)) {
                        tmpSending.setSendStatusID(CommonStructures.SendStatus_Sent);
                        tmpSending.setEndDate(new Date());
                        XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                        tmpSending.update(false, conn, xTeePais);
                    }
                } else {
                    throw new AxisFault(
                            createRecipientNotFoundMessage(
                                    docID, user.getOrganizationCode(),
                                    bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                }
            }

            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("")) {
                DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, false, conn);
            }
        } finally {
            (new File(pipelineDataFile)).delete();
        }

        return result;
    }

    public static RequestInternalResult V2(
            org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws SQLException, AxisFault {
        logger.info("MarkDocumentsReceived.V2 invoked.");

        RequestInternalResult result = new RequestInternalResult();
        String pipelineDataFile = CommonMethods.createPipelineFile(0);

        try {
            // Lame SOAP keha endale sobivasse andmestruktuuri
            markDocumentsReceivedRequestType bodyData = markDocumentsReceivedRequestType.getFromSOAPBody(context);
            if (bodyData == null) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_KEHA);
            }
            result.folder = bodyData.kaust;

            org.apache.axis.attachments.AttachmentPart px =
                    (org.apache.axis.attachments.AttachmentPart) context.getCurrentMessage().
                            getAttachmentsImpl().getAttachmentByReference(bodyData.dokumendidHref);
            DataSource attachmentSource = px.getActivationDataHandler().getDataSource();
            if (attachmentSource == null) {
                throw new AxisFault(CommonStructures.VIGA_PUUDUV_MIME_LISA);
            }

            // Laeme SOAP attachmendis asunud andmed baidimassiivi
            String[] headers = px.getMimeHeader("Content-Transfer-Encoding");
            String encoding;
            if ((headers == null) || (headers.length < 1)) {
                encoding = "base64";
            } else {
                encoding = headers[0];
            }
            result.dataMd5Hash = CommonMethods.getDataFromDataSource(attachmentSource, encoding, pipelineDataFile, false);
            if (result.dataMd5Hash == null) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }

            // Pakime andmed GZIPiga lahti
            if (!CommonMethods.gzipUnpackXML(pipelineDataFile, true)) {
                throw new AxisFault(CommonStructures.VIGA_VIGANE_MIME_LISA);
            }

            // Laeme andmed XML DOM dokumendi kujule
            Document inputMessage = CommonMethods.xmlDocumentFromFile(pipelineDataFile, false);

            // Leiame kõik XML elemendid, mille nimi on "item"
            NodeList foundNodes = inputMessage.getElementsByTagName("item");

            // Kontrollime, et sisendis sisalduks vähemalt 1 dokumendi andmed
            if (foundNodes == null) {
                throw new AxisFault("Dokumentide nimekiri on tühi või vigase XML struktuuriga!");
            }
            if (foundNodes.getLength() < 1) {
                throw new AxisFault("Dokumentide nimekiri on tühi või vigase XML struktuuriga!");
            }

            // Kopeerime edasiste tegevuste jaoks vajalikud andmed oma
            // andmestruktuuri ümber.
            int nodeCount = foundNodes.getLength();
            Recipient tmpRecipient = null;
            for (int i = 0; i < nodeCount; ++i) {
                markDocumentsReceivedV2Item item = markDocumentsReceivedV2Item.getFromXML((org.w3c.dom.Element) foundNodes.item(i));

                // Kontrollime olulisemad sisendandmed üle
                if (item == null) {
                    throw new AxisFault("Sisendandmed on vigase XML struktuuriga!");
                }
                if (item.documentID < 1) {
                    throw new AxisFault("Vigane dokumendi ID või vigane andmete XML struktuur!");
                }

                Sending tmpSending = new Sending();
                if (tmpSending.loadByDocumentID(item.documentID, conn)) {
                    boolean allSent = true;
                    boolean recipientFound = false;
                    for (int j = 0; j < tmpSending.getRecipients().size(); ++j) {
                        tmpRecipient = tmpSending.getRecipients().get(j);
                        if (tmpRecipient.getOrganizationID() == user.getOrganizationID()) {

                            // Kui päringus on täpsustatud, millise allüksuse ja/või ametikoha
                            // dokumendid tuleb vastuvõetuks märkida, siis kontrollime, et
                            // ametikoha ja/või allüksuse ID adressaadi andmetes
                            // vastaks päringu parameetritele.
                            // Vastasel juhul märgiks rakendus dokumendi vastuvõetuks kõigi
                            // adressaatide poolt, kes kuuluvad päringu teinud asutuse alla.
                            if (((bodyData.allyksusId <= 0) || (tmpRecipient.getDivisionID() == bodyData.allyksusId))
                                    && ((bodyData.ametikohtId <= 0) || (tmpRecipient.getPositionID() == bodyData.ametikohtId))) {

                                recipientFound = true;
                                if (item.recipientFault == null) {
                                    // Kui veateadet ei saadetud, siis järeldame, et dokument
                                    // võeti edukalt vastu.
                                    tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Sent);
                                } else {
                                    // Kui saadeti veateade, siis märgime saatmise ebaõnnestunuks.
                                    tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Canceled);
                                }
                                tmpRecipient.setFault(item.recipientFault);
                                tmpRecipient.setSendingEndDate(new Date());
                                tmpRecipient.setRecipientStatusId(item.recipientStatusID);
                                tmpRecipient.setMetaXML(item.metaXML);

                                // Praegusest kuupäevast ja kellaajast hilisemaid staatuse
                                // muutumise aegu ei saa ette anda.
                                if (item.staatuseMuutmiseAeg.after(new Date())) {
                                    tmpRecipient.setStatusDate(new Date());
                                } else {
                                    tmpRecipient.setStatusDate(item.staatuseMuutmiseAeg);
                                }

                                XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                        user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                                tmpRecipient.update(conn, xTeePais);
                            }
                        }
                        if (tmpRecipient.getSendStatusID() != CommonStructures.SendStatus_Sent) {
                            allSent = false;
                        }
                    }

                    if (!recipientFound) {
                        throw new AxisFault(
                                createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(),
                                        bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                    }

                    if (allSent && (tmpSending.getSendStatusID() != CommonStructures.SendStatus_Sent)) {
                        tmpSending.setSendStatusID(CommonStructures.SendStatus_Sent);
                        tmpSending.setEndDate(new Date());
                        XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                        tmpSending.update(false, conn, xTeePais);
                    }
                } else {
                    throw new AxisFault(
                            createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(),
                                    bodyData.allyksusId, bodyData.ametikohtId, "", ""));
                }
            }

            if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("")) {
                DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, false, conn);
            }
        } finally {
            (new File(pipelineDataFile)).delete();
        }

        return result;
    }

    public static RequestInternalResult V3(
            org.apache.axis.MessageContext context, Connection conn, UserProfile user) throws SQLException, AxisFault {
        logger.info("MarkDocumentsReceived.V3 invoked.");

        RequestInternalResult result = new RequestInternalResult();
        result.requestElement = CommonMethods.getXRoadRequestBodyElement(context, "markDocumentsReceived");

        // Lame SOAP keha endale sobivasse andmestruktuuri
        markDocumentsReceivedV3RequestType bodyData = markDocumentsReceivedV3RequestType.getFromSOAPBody(context);
        if (bodyData == null) {
            throw new AxisFault(CommonStructures.VIGA_VIGANE_KEHA);
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
                throw new AxisFault("Vigane dokumendi ID või vigane andmete XML struktuur!");
            }

            Sending tmpSending = new Sending();

            boolean documentLoadResult = false;

            if (item.documentID > 0) {
                logger.debug("Loading document by document ID.");
                documentLoadResult = tmpSending.loadByDocumentID(item.documentID, conn);
            } else if (!CommonMethods.isNullOrEmpty(item.guid)) {
                logger.debug("Loading document by document GUID.");
                documentLoadResult = tmpSending.loadByDocumentGUID(item.guid, conn);
            }

            if (documentLoadResult) {
                boolean allSent = true;
                boolean recipientFound = false;
                for (int j = 0; j < tmpSending.getRecipients().size(); ++j) {
                    tmpRecipient = tmpSending.getRecipients().get(j);
                    if (tmpRecipient.getOrganizationID() == user.getOrganizationID()) {

                        // Kui päringus on täpsustatud, millise allüksuse ja/või ametikoha
                        // dokumendid tuleb vastuvõetuks märkida, siis kontrollime, et
                        // ametikoha ja/või allüksuse lühinimetus adressaadi andmetes
                        // vastaks päringu parameetritele.
                        // Vastasel juhul märgiks rakendus dokumendi vastuvõetuks kõigi
                        // adressaatide poolt, kes kuuluvad päringu teinud asutuse alla.
                        if (((bodyData.allyksuseLyhinimetus == null)
                                || (bodyData.allyksuseLyhinimetus.length() < 1)
                                || CommonMethods.stringsEqualIgnoreNull(tmpRecipient.getDivisionShortName(), bodyData.allyksuseLyhinimetus))
                                && ((bodyData.ametikohaLyhinimetus == null)
                                || (bodyData.ametikohaLyhinimetus.length() < 1)
                                || CommonMethods.stringsEqualIgnoreNull(
                                        tmpRecipient.getPositionShortName(), bodyData.ametikohaLyhinimetus))) {

                            recipientFound = true;
                            if (item.recipientFault == null) {
                                // Kui veateadet ei saadetud, siis järeldame, et dokument
                                // võeti edukalt vastu.
                                tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Sent);
                            } else {
                                // Kui saadeti veateade, siis märgime saatmise ebaõnnestunuks.
                                tmpRecipient.setSendStatusID(CommonStructures.SendStatus_Canceled);
                            }
                            tmpRecipient.setFault(item.recipientFault);
                            tmpRecipient.setSendingEndDate(new Date());
                            tmpRecipient.setRecipientStatusId(item.recipientStatusID);
                            tmpRecipient.setMetaXML(item.metaXML);

                            // Praegusest kuupäevast ja kellaajast hilisemaid staatuse
                            // muutumise aegu ei saa ette anda.
                            if (item.staatuseMuutmiseAeg.after(new Date())) {
                                tmpRecipient.setStatusDate(new Date());
                            } else {
                                tmpRecipient.setStatusDate(item.staatuseMuutmiseAeg);
                            }

                            XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                                    user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                            tmpRecipient.update(conn, xTeePais);
                        }
                    }
                    if (tmpRecipient.getSendStatusID() != CommonStructures.SendStatus_Sent) {
                        allSent = false;
                    }
                }

                if (!recipientFound) {
                    throw new AxisFault(
                            createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(), 0, 0,
                                    bodyData.allyksuseLyhinimetus, bodyData.ametikohaLyhinimetus));
                }

                if (allSent && (tmpSending.getSendStatusID() != CommonStructures.SendStatus_Sent)) {
                    tmpSending.setSendStatusID(CommonStructures.SendStatus_Sent);
                    tmpSending.setEndDate(new Date());
                    XRoadProtocolHeader xTeePais = new XRoadProtocolHeader(
                            user.getOrganizationCode(), null, null, null, null, null, user.getPersonCode());
                    tmpSending.update(false, conn, xTeePais);
                }
            } else {
                throw new AxisFault(
                        createRecipientNotFoundMessage(item.documentID, user.getOrganizationCode(), 0, 0,
                                bodyData.allyksuseLyhinimetus, bodyData.ametikohaLyhinimetus));
            }
        }

        if ((bodyData.edastusID != null) && !bodyData.edastusID.equalsIgnoreCase("")) {
            DocumentFragment.deleteFragments(user.getOrganizationID(), bodyData.edastusID, false, conn);
        }

        return result;
    }

    private static String createRecipientNotFoundMessage(
            int docId, String orgCode, int subdivisionId, int occupationId,
            String subdivisionShortName, String occupationShortName) {
        StringBuilder sb = new StringBuilder(1000);
        sb.append("Dokumendi vastuvõetuks märkimine ebaõnnestus! Etteantud ID-le (")
                            .append(docId).append(") vastavat dokumenti ei ole antud asutusele");
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
