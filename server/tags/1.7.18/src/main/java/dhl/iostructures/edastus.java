package dhl.iostructures;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.Fault;
import dhl.Recipient;

import java.io.OutputStreamWriter;
import java.sql.Connection;
import java.util.Date;

public class edastus {
    private Recipient m_saaja;
    private Date m_saadud;

    public Recipient getSaaja() {
        return m_saaja;
    }

    public void setSaaja(Recipient value) {
        m_saaja = value;
    }

    public Date getSaadud() {
        return m_saadud;
    }

    public void setSaadud(Date value) {
        m_saadud = value;
    }


    public edastus(Recipient saaja, Date saadud) {
        m_saaja = saaja;
        m_saadud = saadud;
    }

    public void appendObjectXML(OutputStreamWriter xmlWriter, Connection conn) {
        try {
            // Item element start
            xmlWriter.write("<edastus>");

            // Saaja
            m_saaja.appendObjectXML(xmlWriter, conn);

            // Saadud
            xmlWriter.write("<saadud>" + CommonMethods.getDateISO8601(m_saadud) + "</saadud>");

            // Meetod
            String methodOut = "";
            switch (m_saaja.getSendingMethodID()) {
                case CommonStructures.SendingMethod_XTee:
                    methodOut = CommonStructures.SendingMethod_XTee_Name;
                    break;
                case CommonStructures.SendingMethod_EMail:
                    methodOut = CommonStructures.SendingMethod_EMail_Name;
                    break;
                default:
                    break;
            }
            xmlWriter.write("<meetod>" + methodOut + "</meetod>");

            // Edastatud
            if (m_saaja.getSendingStartDate() != null) {
                xmlWriter.write("<edastatud>" + CommonMethods.getDateISO8601(m_saaja.getSendingStartDate()) + "</edastatud>");
            }

            // Loetud
            if (m_saaja.getSendingEndDate() != null) {
                xmlWriter.write("<loetud>" + CommonMethods.getDateISO8601(m_saaja.getSendingEndDate()) + "</loetud>");
            }

            // Fault
            Fault tmpFault = m_saaja.getFault();
            if (tmpFault != null) {
                tmpFault.appendObjectXML(xmlWriter);
            }

            // Staatus
            String statOut = "";
            switch (m_saaja.getSendStatusID()) {
                case CommonStructures.SendStatus_Sending:
                    statOut = CommonStructures.SendStatus_Sending_Name;
                    break;
                case CommonStructures.SendStatus_Sent:
                    statOut = CommonStructures.SendStatus_Sent_Name;
                    break;
                case CommonStructures.SendStatus_Canceled:
                    statOut = CommonStructures.SendStatus_Canceled_Name;
                    break;
                default:
                    break;
            }
            xmlWriter.write("<staatus>" + statOut + "</staatus>");

            // Vastuvõtja saadetud staatus
            xmlWriter.write("<vastuvotja_staatus_id>" + String.valueOf(m_saaja.getRecipientStatusId()) + "</vastuvotja_staatus_id>");

            // Vabas vormis metaandmed
            if ((m_saaja.getMetaXML() != null) && !m_saaja.getMetaXML().equalsIgnoreCase("")) {
                xmlWriter.write("<metaxml>" + m_saaja.getMetaXML() + "</metaxml>");
            }

            // Item element end
            xmlWriter.write("</edastus>");
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "appendObjectXML");
        }
    }
}
