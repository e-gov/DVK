package dhl.requests;

import dvk.core.CommonStructures;
import dvk.core.Settings;
import dhl.Document;
import dvk.core.Fault;
import dhl.Recipient;
import dhl.Sending;
import dhl.iostructures.ExpiredDocumentData;
import java.sql.Connection;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Properties;
import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.apache.axis.AxisFault;

public class DeleteOldDocuments {
    public static RequestInternalResult V1(Connection conn) throws AxisFault {
        RequestInternalResult result = new RequestInternalResult();
        
        // Laeme andmebaasist s�ilitust�htaja �letanud dokumendid
        ArrayList<ExpiredDocumentData> expiredDocuments = Document.getExpiredDocuments(conn);
        
        ExpiredDocumentData doc;
        for (int i = 0; i < expiredDocuments.size(); ++i) {
            doc = expiredDocuments.get(i);
            if (doc.getSendStatusID() == CommonStructures.SendStatus_Sending) {
                // Kui dokument on endiselt alles saatmisel, siis kuulutame
                // saatmise eb�nnestunuks, saadame saatjale e-maili ja anname
                // dokumenile veel N p�eva ajapikendust, enne kui see l�plikult
                // maha kustutatakse (et staatuse muutus j�uaks ka saatjale tagasi)
                Sending s = new Sending();
                s.loadByDocumentID(doc.getDocumentID(), conn);
                
                // Koostame aegumisest teatava vea objekti
                Fault f = new Fault();
                f.setFaultCode(CommonStructures.FAULT_EXPIRED_CODE);
                f.setFaultString("Dokumendi saatmine ebaonnestus, kuna adressaat ei laadinud antud dokumenti sailitustahtaja jooksul DVK-st alla.");
                f.setFaultActor(CommonStructures.FAULT_ACTOR);
                
                // M�rgime saatmisel olevad adressaadid katkestatuks
                ArrayList<Recipient> recipients = s.getRecipients();
                for (int j = 0; j < recipients.size(); ++j) {
                    if (recipients.get(j).getSendStatusID() == CommonStructures.SendStatus_Sending) {
                        recipients.get(j).setSendStatusID(CommonStructures.SendStatus_Canceled);
                        recipients.get(j).setFault(f);
                        recipients.get(j).setSendingEndDate(new Date());
                    }
                }
                
                // M�rgime saatmise katkestatuks
                s.setSendStatusID(CommonStructures.SendStatus_Canceled);
                s.setEndDate(new Date());
                
                // Salvestame saatmise andmetes tehtud muudatused
                s.update(true, conn);
                
                // Arvutame uue s�ilitust�htaja
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(doc.getConservationDeadline());
                calendar.add(Calendar.DATE, Settings.Server_ExpiredDocumentGracePeriod);
                doc.setConservationDeadline(calendar.getTime());
                
                // Salvestame uue s�ilitust�htaja andmebaasi
                Document.updateExpirationDate(doc.getDocumentID(), doc.getConservationDeadline(), conn);
                
                // Saadame dokumendi saatjale teavituskirja, et tema poolt
                // saadetud dokument on aegunud
                if ((s.getSender().getEmail() != null) && !s.getSender().getEmail().equalsIgnoreCase("")) {
                    sendEmail(s.getSender().getEmail(), s.getStartDate());
                }
            } else {
                // Kustutame dokumendi maha
                Document.deleteFromDB(doc.getDocumentID(), conn);
            }
        }
        
        return result;
    }
    
    private static void sendEmail(String toAddress, Date docSendingDate) {
        try {
            if ((Settings.currentProperties != null) && (Settings.currentProperties.getProperty("mail.host") != null)
                && (!Settings.currentProperties.getProperty("mail.host").equalsIgnoreCase(""))
                && (Settings.currentProperties.getProperty("mail.from") != null)
                && (!Settings.currentProperties.getProperty("mail.from").equalsIgnoreCase(""))) {
                
                Properties mailServerConfig = new Properties();
                mailServerConfig.setProperty("mail.host", Settings.currentProperties.getProperty("mail.host"));
    
                InternetAddress fromAddress = new InternetAddress(Settings.currentProperties.getProperty("mail.from"));
                fromAddress.setPersonal("Dokumendivahetuskeskus");
                
                Session session = Session.getDefaultInstance( mailServerConfig, null );
                MimeMessage message = new MimeMessage( session );
    
                message.addRecipient( Message.RecipientType.TO, new InternetAddress(toAddress) );
                message.addFrom( new InternetAddress[]{fromAddress} );
                message.setSubject( "Automaatteade dokumendi edastamise katkestamise kohta" );
                
                DateFormat dateFormat = new SimpleDateFormat("dd.MM.yyyy HH:mm");
                String docSendingDateString = dateFormat.format(docSendingDate);
                
                message.setText( "Dokumendivahetuskeskus katkestas Teie poolt "+ docSendingDateString +" saadetud dokumendi edastamise, kuna v�hemalt �ks adressaat ei ole dokumendi edastust�htaja jooksul saadetud dokumenti vastu v�tnud." );
                
                Transport.send( message );
            }
        }
        catch (Exception ex){}
    }
}
