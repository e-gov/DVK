package dhl.aar.iostructures;

import dvk.core.CommonMethods;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Date;
import javax.xml.stream.XMLInputFactory;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.XMLStreamReader;
import org.apache.axis.AxisFault;

public class AarAsutus {
    private int m_asutusID;
    private String m_registrikood;
    private int m_ksAsutusID;
    private String m_ksAsutusKood;
    private String m_nimetus;
    private String m_nimetusEn;
    private String m_nimetusRu;
    private String m_liik1;
    private String m_liik2;
    private String m_maakond;
    private String m_asukoht;
    private String m_aadress;
    private String m_postikood;
    private String m_telefon;
    private String m_ePost;
    private String m_www;
    private Date m_asutamiseKp;
    private Date m_lopetamiseKp;
    private ArrayList<AarAmetikoht> m_ametikohad;
    private int m_dvkID;

    public int getAsutusID() {
        return m_asutusID;
    }

    public void setAsutusID(int value) {
        m_asutusID = value;
    }

    public String getRegistrikood() {
        return m_registrikood;
    }

    public void setRegistrikood(String value) {
        m_registrikood = value;
    }

    public int getKsAsutusID() {
        return m_ksAsutusID;
    }

    public void setKsAsutusID(int value) {
        m_ksAsutusID = value;
    }

    public String getKsAsutusKood() {
        return m_ksAsutusKood;
    }

    public void setKsAsutusKood(String value) {
        m_ksAsutusKood = value;
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

    public String getLiik1() {
        return m_liik1;
    }

    public void setLiik1(String value) {
        m_liik1 = value;
    }

    public String getLiik2() {
        return m_liik2;
    }

    public void setLiik2(String value) {
        m_liik2 = value;
    }

    public String getMaakond() {
        return m_maakond;
    }

    public void setMaakond(String value) {
        m_maakond = value;
    }

    public String getAsukoht() {
        return m_asukoht;
    }

    public void setAsukoht(String value) {
        m_asukoht = value;
    }

    public String getAadress() {
        return m_aadress;
    }

    public void setAadress(String value) {
        m_aadress = value;
    }

    public String getPostikood() {
        return m_postikood;
    }

    public void setPostikood(String value) {
        m_postikood = value;
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

    public String getWww() {
        return m_www;
    }

    public void setWww(String value) {
        m_www = value;
    }

    public Date getAsutamiseKp() {
        return m_asutamiseKp;
    }

    public void setAsutamiseKp(Date value) {
        m_asutamiseKp = value;
    }

    public Date getLopetamiseKp() {
        return m_lopetamiseKp;
    }

    public void setLopetamiseKp(Date value) {
        m_lopetamiseKp = value;
    }

    public ArrayList<AarAmetikoht> getAmetikohad() {
        return m_ametikohad;
    }

    public void setAmetikohad(ArrayList<AarAmetikoht> value) {
        m_ametikohad = value;
    }

    public int getDvkID() {
        return m_dvkID;
    }

    public void setDvkID(int value) {
        m_dvkID = value;
    }

    public AarAsutus() {
        m_asutusID = 0;
        m_registrikood = "";
        m_ksAsutusID = 0;
        m_ksAsutusKood = "";
        m_nimetus = "";
        m_nimetusEn = "";
        m_nimetusRu = "";
        m_liik1 = "";
        m_liik2 = "";
        m_maakond = "";
        m_asukoht = "";
        m_aadress = "";
        m_postikood = "";
        m_telefon = "";
        m_ePost = "";
        m_www = "";
        m_asutamiseKp = null;
        m_lopetamiseKp = null;
        m_ametikohad = new ArrayList<AarAmetikoht>();
        m_dvkID = 0;
    }

    public static AarAsutus fromXML(XMLStreamReader xmlReader) throws AxisFault {
        try {
            AarAsutus result = new AarAsutus();

            while (xmlReader.hasNext()) {
                xmlReader.next();

                if (xmlReader.hasName()) {
                    if (xmlReader.getLocalName().equalsIgnoreCase("asutus") && xmlReader.isEndElement()) {
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
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAsutus", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("registrikood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setRegistrikood(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ks_asutus_id") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            String ksAsutusIDText = xmlReader.getText().trim();
                            if ((ksAsutusIDText != null) && (ksAsutusIDText.length() > 0)) {
                                try {
                                    result.setKsAsutusID(Integer.parseInt(ksAsutusIDText));
                                } catch (Exception ex) {
                                    CommonMethods.logError(ex, "dhl.aar.iostructures.AarAsutus", "fromXML");
                                }
                            }
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ks_asutus_kood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setKsAsutusKood(xmlReader.getText().trim());
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
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("liik1") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setLiik1(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("liik2") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setLiik2(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("maakond") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setMaakond(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asukoht") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAsukoht(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("aadress") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAadress(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("postikood") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setPostikood(xmlReader.getText().trim());
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
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("www") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setWww(xmlReader.getText().trim());
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("asutamise_kp") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setAsutamiseKp(CommonMethods.getDateFromXML(xmlReader.getText().trim()));
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("lopet_kp") && xmlReader.isStartElement()) {
                        xmlReader.next();
                        if (xmlReader.isCharacters()) {
                            result.setLopetamiseKp(CommonMethods.getDateFromXML(xmlReader.getText().trim()));
                        }
                    } else if (xmlReader.getLocalName().equalsIgnoreCase("ametikohad") && xmlReader.isStartElement()) {
                        result.setAmetikohad(AarAmetikoht.getListFromXML(xmlReader, "ametikohad"));
                    }
                }
            }

            // Kui ühegi kontrolli taha pidama ei jäänud, siis tagastame väärtuse
            return result;
        } catch (XMLStreamException ex) {
            CommonMethods.logError(ex, "dhl.aar.iostructures.AarAsutus", "fromXML");
            throw new AxisFault("Exception parsing AAR message organization data section: " + ex.getMessage());
        }
    }

    public static ArrayList<AarAsutus> getListFromXML(String dataFile) {
        try {
            ArrayList<AarAsutus> result = new ArrayList<AarAsutus>();

            XMLInputFactory inputFactory = XMLInputFactory.newInstance();
            XMLStreamReader reader = inputFactory.createXMLStreamReader(new FileInputStream(dataFile), "UTF-8");

            try {
                while (reader.hasNext()) {
                    reader.next();

                    if (reader.hasName()) {
                        if (reader.getLocalName().equalsIgnoreCase("asutused") && reader.isEndElement()) {
                            break;
                        } else if (reader.getLocalName().equalsIgnoreCase("asutus") && reader.isStartElement()) {
                            AarAsutus a = AarAsutus.fromXML(reader);
                            result.add(a);
                        }
                    }
                }
            } finally {
                reader.close();
            }
            return result;
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.aar.iostructures.AarAsutus", "getListFromXML");
            return null;
        }
    }
}
