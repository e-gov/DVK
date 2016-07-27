package dhl.aar.iostructures;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Date;

import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;

import org.apache.axis.AxisFault;

import dvk.core.CommonMethods;

public class AarAmetikoht {
    private int m_ametikohtID;
    private int m_asutusID;
    private String m_asutusRegistrikood;
    private String m_asutusNimetus;
    private String m_asutusNimetusEn;
    private String m_asutusNimetusRu;
    private String m_nimetus;
    private String m_nimetusEn;
    private String m_nimetusRu;
    private Date m_alates;
    private Date m_kuni;
    private int m_allyksusID;
    private String m_allyksusNimetus;
    private ArrayList<AarAmetikohaTaitmine> m_taitmised;

    public AarAmetikoht() {
        m_ametikohtID = 0;
        m_asutusID = 0;
        m_asutusRegistrikood = "";
        m_asutusNimetus = "";
        m_asutusNimetusEn = "";
        m_asutusNimetusRu = "";
        m_nimetus = "";
        m_nimetusEn = "";
        m_nimetusRu = "";
        m_alates = null;
        m_kuni = null;
        m_allyksusID = 0;
        m_allyksusNimetus = "";
        m_taitmised = new ArrayList<AarAmetikohaTaitmine>();
    }

    public int getAmetikohtID() {
        return m_ametikohtID;
    }

    public void setAmetikohtID(int value) {
        m_ametikohtID = value;
    }

    public int getAsutusID() {
        return m_asutusID;
    }

    public void setAsutusID(int value) {
        m_asutusID = value;
    }

    public String getAsutusRegistrikood() {
        return m_asutusRegistrikood;
    }

    public void setAsutusRegistrikood(String value) {
        m_asutusRegistrikood = value;
    }

    public String getAsutusNimetus() {
        return m_asutusNimetus;
    }

    public void setAsutusNimetus(String value) {
        m_asutusNimetus = value;
    }

    public String getAsutusNimetusEn() {
        return m_asutusNimetusEn;
    }

    public void setAsutusNimetusEn(String value) {
        m_asutusNimetusEn = value;
    }

    public String getAsutusNimetusRu() {
        return m_asutusNimetusRu;
    }

    public void setAsutusNimetusRu(String value) {
        m_asutusNimetusRu = value;
    }

    public String getNimetus() {
        return m_nimetus;
    }

    public void setNimetus(String value) {
        m_nimetus = value;
    }

    public String getNimetusEn() {
        return m_nimetusEn;
    }

    public void setNimetusEn(String value) {
        m_nimetusEn = value;
    }

    public String getNimetusRu() {
        return m_nimetusRu;
    }

    public void setNimetusRu(String value) {
        m_nimetusRu = value;
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

    public int getAllyksusID() {
        return m_allyksusID;
    }

    public void setAllyksusID(int value) {
        m_allyksusID = value;
    }

    public String getAllyksusNimetus() {
        return m_allyksusNimetus;
    }

    public void setAllyksusNimetus(String value) {
        m_allyksusNimetus = value;
    }

    public ArrayList<AarAmetikohaTaitmine> getTaitmised() {
        return m_taitmised;
    }

    public void setTaitmised(ArrayList<AarAmetikohaTaitmine> value) {
        m_taitmised = value;
    }

    public static AarAmetikoht fromXML(XMLStreamReader xmlReader) throws AxisFault {
        try {
            AarAmetikoht result = new AarAmetikoht();

            while (xmlReader.hasNext()) {
                xmlReader.next();

                if (xmlReader.hasName()) {
                    if (xmlReader.getLocalName().equalsIgnoreCase("ametikoht") && xmlReader.isEndElement()) {
                        // Kui oleme jõudnud asutuse elemendi lõppu, siis katkestame tsükli
                        break;
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutus_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String asutusIDText = xmlReader.getText().trim();
                            if ((asutusIDText != null) && (asutusIDText.length() > 0)) {
                                try {
                                    result.setAsutusID(Integer.parseInt(asutusIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikoht", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutus_registrikood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAsutusRegistrikood(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutus_nimetus") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAsutusNimetus(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutus_nimetus_en") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAsutusNimetusEn(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutus_nimetus_ru") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAsutusNimetusRu(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoht_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String ametikohtIDText = xmlReader.getText().trim();
                            if ((ametikohtIDText != null) && (ametikohtIDText.length() > 0)) {
                                try {
                                    result.setAmetikohtID(Integer.parseInt(ametikohtIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikoht", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("nimetus") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setNimetus(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("nimetus_en") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setNimetusEn(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("nimetus_ru") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setNimetusRu(xmlReader.getText().trim());
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
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("allyksus_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String allyksusIDText = xmlReader.getText().trim();
                            if ((allyksusIDText != null) && (allyksusIDText.length() > 0)) {
                                try {
                                    result.setAllyksusID(Integer.parseInt(allyksusIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikoht", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("allyksus_nimetus") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAllyksusNimetus(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("taitmised") && xmlReader.isStartElement()) {
                        result.setTaitmised(AarAmetikohaTaitmine.getListFromXML(xmlReader, "taitmised"));
                    }
                }
            }

            // Kui ühegi kontrolli taha pidama ei jäänud, siis tagastame väärtuse
            return result;
        } catch (XMLStreamException ex) {
            throw new AxisFault("Exception parsing AAR message organization data section: " + ex.getMessage());
        }
    }

    public static ArrayList<AarAmetikoht> getListFromXML(String dataFile) {
        try {
            ArrayList<AarAmetikoht> result = null;
            XMLInputFactory inputFactory = XMLInputFactory.newInstance();
            XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(dataFile), "UTF-8");
            try {
                result = getListFromXML(reader, "ametikohad");
            } finally {
                reader.close();
            }
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikoht", "getListFromXML");
            return null;
        }
    }

    public static ArrayList<AarAmetikoht> getListFromXML(XMLStreamReader reader, String rootTagName) {
        try {
            ArrayList<AarAmetikoht> result = new ArrayList<AarAmetikoht>();
            while (reader.hasNext()) {
                reader.next();

                if (reader.hasName()) {
                    if (reader.getLocalName().equalsIgnoreCase(rootTagName) && reader.isEndElement()) {
                        break;
                    } else if (reader.getLocalName().equalsIgnoreCase("ametikoht") && reader.isStartElement()) {
                        AarAmetikoht a = AarAmetikoht.fromXML(reader);
                        result.add(a);
                    }
                }
            }
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikoht", "getListFromXML");
            return null;
        }
    }
}
