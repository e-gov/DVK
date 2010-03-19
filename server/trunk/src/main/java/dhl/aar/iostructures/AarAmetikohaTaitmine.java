package dhl.aar.iostructures;

import dvk.core.CommonMethods;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Date;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import org.apache.axis.AxisFault;

public class AarAmetikohaTaitmine {
    private int m_taitmineID;
    private int m_asutusID;
    private String m_asutusRegistrikood;
    private String m_asutusNimetus;
    private String m_asutusNimetusEn;
    private String m_asutusNimetusRu;
    private int m_ametikohtID;
    private String m_ametikohtNimetus;
    private String m_ametikohtNimetusEn;
    private String m_ametikohtNimetusRu;
    private Date m_alates;
    private Date m_kuni;
    private String m_roll;
    private AarIsik m_isik;
    private int m_pkTaitmineID;
    private Date m_pkRoll;
    private Date m_pkAlates;
    private Date m_pkKuni;
    private AarIsik m_pkIsik;
    private AarTaitmineOigus m_oigused;

    public int getTaitmineID() {
        return m_taitmineID;
    }

    public void setTaitmineID(int value) {
        m_taitmineID = value;
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

    public int getAmetikohtID() {
        return m_ametikohtID;
    }

    public void setAmetikohtID(int value) {
        m_ametikohtID = value;
    }

    public String getAmetikohtNimetus() {
        return m_ametikohtNimetus;
    }

    public void setAmetikohtNimetus(String value) {
        m_ametikohtNimetus = value;
    }

    public String getAmetikohtNimetusEn() {
        return m_ametikohtNimetusEn;
    }

    public void setAmetikohtNimetusEn(String value) {
        m_ametikohtNimetusEn = value;
    }

    public String getAmetikohtNimetusRu() {
        return m_ametikohtNimetusRu;
    }

    public void setAmetikohtNimetusRu(String value) {
        m_ametikohtNimetusRu = value;
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

    public String getRoll() {
        return m_roll;
    }

    public void setRoll(String value) {
        m_roll = value;
    }

    public AarIsik getIsik() {
        return m_isik;
    }

    public void setIsik(AarIsik value) {
        m_isik = value;
    }

    public int getPkTaitmineID() {
        return m_pkTaitmineID;
    }

    public void setPkTaitmineID(int value) {
        m_pkTaitmineID = value;
    }

    public Date getPkRoll() {
        return m_pkRoll;
    }

    public void setPkRoll(Date value) {
        m_pkRoll = value;
    }

    public Date getPkAlates() {
        return m_pkAlates;
    }

    public void setPkAlates(Date value) {
        m_pkAlates = value;
    }

    public Date getPkKuni() {
        return m_pkKuni;
    }

    public void setPkKuni(Date value) {
        m_pkKuni = value;
    }

    public AarIsik getPkIsik() {
        return m_pkIsik;
    }

    public void setPkIsik(AarIsik value) {
        m_pkIsik = value;
    }

    public AarTaitmineOigus getOigused() {
        return m_oigused;
    }

    public void setOigused(AarTaitmineOigus value) {
        m_oigused = value;
    }

    public AarAmetikohaTaitmine() {
        m_taitmineID = 0;
        m_asutusID = 0;
        m_asutusRegistrikood = "";
        m_asutusNimetus = "";
        m_asutusNimetusEn = "";
        m_asutusNimetusRu = "";
        m_ametikohtID = 0;
        m_ametikohtNimetus = "";
        m_ametikohtNimetusEn = "";
        m_ametikohtNimetusRu = "";
        m_alates = null;
        m_kuni = null;
        m_roll = "";
        m_isik = null;
        m_pkTaitmineID = 0;
        m_pkRoll = null;
        m_pkAlates = null;
        m_pkKuni = null;
        m_pkIsik = null;
        m_oigused = null;
    }
    
    public static AarAmetikohaTaitmine fromXML(XMLStreamReader xmlReader) throws AxisFault {
        try {
            AarAmetikohaTaitmine result = new AarAmetikohaTaitmine();

            while (xmlReader.hasNext()) {
                xmlReader.next();

                if (xmlReader.hasName()) {
                    if (xmlReader.getLocalName().equalsIgnoreCase("taitmine") && xmlReader.isEndElement()) {
                        // Kui oleme jõudnud asutuse elemendi lõppu, siis katkestame tsõkli
                        break;
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("taitmine_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String taitmineIDText = xmlReader.getText().trim();
                            if ((taitmineIDText != null) && (taitmineIDText.length() > 0)) {
                                try {
                                    result.setTaitmineID(Integer.parseInt(taitmineIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikohaTaitmine", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutus_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String asutusIDText = xmlReader.getText().trim();
                            if ((asutusIDText != null) && (asutusIDText.length() > 0)) {
                                try {
                                    result.setAsutusID(Integer.parseInt(asutusIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikohaTaitmine", "fromXML");
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
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikohaTaitmine", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoht_nimetus") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setAmetikohtNimetus(xmlReader.getText().trim());
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoht_nimetus_en") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setAmetikohtNimetusEn(xmlReader.getText().trim());
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikoht_nimetus_ru") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setAmetikohtNimetusRu(xmlReader.getText().trim());
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
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("roll") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setRoll(xmlReader.getText().trim());
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("isik") && xmlReader.isStartElement()) {
                         result.setIsik(AarIsik.fromXML(xmlReader, "isik"));
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("pk_taitmine_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String pkTaitmineIDText = xmlReader.getText().trim();
                            if ((pkTaitmineIDText != null) && (pkTaitmineIDText.length() > 0)) {
                                try {
                                    result.setPkTaitmineID(Integer.parseInt(pkTaitmineIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikohaTaitmine", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("pk_roll") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setPkRoll(CommonMethods.getDateFromXML(xmlReader.getText().trim()));
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("pk_alates") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setPkAlates(CommonMethods.getDateFromXML(xmlReader.getText().trim()));
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("pk_kuni") && xmlReader.isStartElement()) {
                         xmlReader.next();
                         if (xmlReader.isCharacters()) {
                             result.setPkKuni(CommonMethods.getDateFromXML(xmlReader.getText().trim()));
                         }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("pk_isik") && xmlReader.isStartElement()) {
                         result.setPkIsik(AarIsik.fromXML(xmlReader, "pk_isik"));
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("oigused") && xmlReader.isStartElement()) {
                         result.setOigused(AarTaitmineOigus.fromXML(xmlReader, "oigused"));
                    }
                }
            }

            // Kui õhegi kontrolli taha pidama ei jõõnud, siis tagastame võõrtuse
            return result;
        } catch (XMLStreamException ex) {
            throw new AxisFault("Exception parsing AAR message organization data section: " + ex.getMessage());
        }
    }
    
    public static ArrayList<AarAmetikohaTaitmine> getListFromXML(String dataFile) {
        try {
            ArrayList<AarAmetikohaTaitmine> result = null;
            XMLInputFactory inputFactory = XMLInputFactory.newInstance();
            XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(dataFile), "UTF-8");
            try {
                result = getListFromXML(reader, "taitmised");
            } finally {
                reader.close();
            }
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikohaTaitmine", "getListFromXML");
            return null;
        }
    }
    
    public static ArrayList<AarAmetikohaTaitmine> getListFromXML(XMLStreamReader reader, String rootTagName) {
        try {
            ArrayList<AarAmetikohaTaitmine> result = new ArrayList<AarAmetikohaTaitmine>();
            while (reader.hasNext()) {
                reader.next();

                if (reader.hasName()) {
                    if (reader.getLocalName().equalsIgnoreCase(rootTagName) && reader.isEndElement()) {
                        break;
                    } else if (reader.getLocalName().equalsIgnoreCase("taitmine") && reader.isStartElement()) {
                        AarAmetikohaTaitmine a = AarAmetikohaTaitmine.fromXML(reader);
                        result.add(a);
                    }
                }
            }
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.aar.iostructures.AarAmetikohaTaitmine", "getListFromXML");
            return null;
        }
    }
}
