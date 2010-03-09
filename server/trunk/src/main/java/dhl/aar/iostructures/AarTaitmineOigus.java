package dhl.aar.iostructures;

import dvk.core.CommonMethods;
import java.util.Date;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import org.apache.axis.AxisFault;

public class AarTaitmineOigus {
    private String m_nimetus;
    private Date m_alates;
    private Date m_kuni;

    public String getNimetus() {
        return m_nimetus;
    }

    public void setNimetus(String value) {
        m_nimetus = value;
    }

    public Date getAlates() {
        return m_alates;
    }

    public void setAlates(Date value) {
        m_alates = value;
    }

    public Date getKuni() {
        return m_kuni;
    }

    public void setKuni(Date value) {
        m_kuni = value;
    }

    public AarTaitmineOigus() {
        m_nimetus = "";
        m_alates = null;
        m_kuni = null;
    }
    
    public static AarTaitmineOigus fromXML(XMLStreamReader xmlReader, String rootTagName) throws AxisFault {
        try {
            AarTaitmineOigus result = new AarTaitmineOigus();

            while (xmlReader.hasNext()) {
                xmlReader.next();

                if (xmlReader.hasName()) {
                    if (xmlReader.getLocalName().equalsIgnoreCase(rootTagName) && xmlReader.isEndElement()) {
                        // Kui oleme jõudnud asutuse elemendi lõppu, siis katkestame tsükli
                        break;
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("nimetus") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setNimetus(xmlReader.getText().trim());
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("alates") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setAlates(CommonMethods.getDateFromXML(xmlReader.getText().trim()));
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("kuni") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setKuni(CommonMethods.getDateFromXML(xmlReader.getText().trim()));
                         }
                    }
                }
            }

            // Kui ühegi kontrolli taha pidama ei jäänud, siis tagastame väärtuse
            return result;
        } catch (XMLStreamException ex) {
            throw new AxisFault("Exception parsing AAR message organization data section: " + ex.getMessage());
        }
    }

}
