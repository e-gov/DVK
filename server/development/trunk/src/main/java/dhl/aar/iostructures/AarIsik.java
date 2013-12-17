package dhl.aar.iostructures;

import dvk.core.CommonMethods;

import java.io.FileInputStream;
import java.util.ArrayList;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.apache.axis.AxisFault;

public class AarIsik {
    private int m_isikuID;
    private String m_isikukood;
    private String m_eesnimi;
    private String m_perenimi;
    private String m_telefon;
    private String m_ePost;

    public AarIsik() {
        m_isikuID = 0;
        m_isikukood = "";
        m_eesnimi = "";
        m_perenimi = "";
        m_telefon = "";
        m_ePost = "";
    }

    public int getIsikuID() {
        return m_isikuID;
    }

    public void setIsikuID(int value) {
        m_isikuID = value;
    }

    public String getIsikukood() {
        return m_isikukood;
    }

    public void setIsikukood(String value) {
        m_isikukood = value;
    }

    public String getEesnimi() {
        return m_eesnimi;
    }

    public void setEesnimi(String value) {
        m_eesnimi = value;
    }

    public String getPerenimi() {
        return m_perenimi;
    }

    public void setPerenimi(String value) {
        m_perenimi = value;
    }

    public String getTelefon() {
        return m_telefon;
    }

    public void setTelefon(String value) {
        m_telefon = value;
    }

    public String getEPost() {
        return m_ePost;
    }

    public void setEPost(String value) {
        m_ePost = value;
    }

    public static AarIsik fromXML(XMLStreamReader xmlReader, String rootTagName) throws AxisFault {
        try {
            AarIsik result = new AarIsik();

            while (xmlReader.hasNext()) {
                xmlReader.next();

                if (xmlReader.hasName()) {
                    if (xmlReader.getLocalName().equalsIgnoreCase(rootTagName) && xmlReader.isEndElement()) {
                        // Kui oleme jõudnud asutuse elemendi lõppu, siis katkestame tsükli
                        break;
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("isiku_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String isikuIDText = xmlReader.getText().trim();
                            if ((isikuIDText != null) && (isikuIDText.length() > 0)) {
                                try {
                                    result.setIsikuID(Integer.parseInt(isikuIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarIsik", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("isikukood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setIsikukood(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("eesnimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setEesnimi(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("perenimi") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setPerenimi(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("telefon") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setTelefon(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("e_post") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setEPost(xmlReader.getText().trim());
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

    public static ArrayList<AarIsik> getListFromXML(String dataFile) {
        try {
            ArrayList<AarIsik> result = new ArrayList<AarIsik>();

            XMLInputFactory inputFactory = XMLInputFactory.newInstance();
            XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(dataFile), "UTF-8");

            try {
                while (reader.hasNext()) {
                    reader.next();

                    if (reader.hasName()) {
                        if (reader.getLocalName().equalsIgnoreCase("isikud") && reader.isEndElement()) {
                            break;
                        } else if (reader.getLocalName().equalsIgnoreCase("isik") && reader.isStartElement()) {
                            AarIsik a = AarIsik.fromXML(reader, "isik");
                            result.add(a);
                        }
                    }
                }
            } finally {
                reader.close();
            }
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.aar.iostructures.AarIsik", "getListFromXML");
            return null;
        }
    }
}
