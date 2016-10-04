package dhl.aar.iostructures;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

import javax.xml.namespace.QName;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.soap.SOAPBody;

import dvk.core.CommonMethods;

public class AarOigus {
    private String m_oigusNimi;
    private Date m_oigusAlates;
    private Date m_oigusKuni;
    private String m_grupp;
    private String m_registrikood;
    private int m_ametikohtID;
    private String m_isikukood;
    private int m_ksAmetikohtID;
    private String m_ametikohtNimetus;
    private Date m_ametikohtAlates;
    private Date m_ametikohtKuni;
    private int m_allyksusID;

    public AarOigus() {
        m_oigusNimi = "";
        m_oigusAlates = null;
        m_oigusKuni = null;
        m_grupp = "";
        m_registrikood = "";
        m_ametikohtID = 0;
        m_isikukood = "";
        m_ksAmetikohtID = 0;
        m_ametikohtNimetus = "";
        m_ametikohtAlates = null;
        m_ametikohtKuni = null;
        m_allyksusID = 0;
    }

    public String getOigusNimi() {
        return m_oigusNimi;
    }

    public void setOigusNimi(String value) {
        m_oigusNimi = value;
    }

    public Date getOigusAlates() {
        return m_oigusAlates;
    }

    public void setOigusAlates(Date value) {
        m_oigusAlates = value;
    }

    public Date getOigusKuni() {
        return m_oigusKuni;
    }

    public void setOigusKuni(Date value) {
        m_oigusKuni = value;
    }

    public String getGrupp() {
        return m_grupp;
    }

    public void setGrupp(String value) {
        m_grupp = value;
    }

    public String getRegistrikood() {
        return m_registrikood;
    }

    public void setRegistrikood(String value) {
        m_registrikood = value;
    }

    public int getAmetikohtID() {
        return m_ametikohtID;
    }

    public void setAmetikohtID(int value) {
        m_ametikohtID = value;
    }

    public String getIsikukood() {
        return m_isikukood;
    }

    public void setIsikukood(String value) {
        m_isikukood = value;
    }

    public int getKsAmetikohtID() {
        return m_ksAmetikohtID;
    }

    public void setKsAmetikohtID(int value) {
        m_ksAmetikohtID = value;
    }

    public String getAmetikohtNimetus() {
        return m_ametikohtNimetus;
    }

    public void setAmetikohtNimetus(String value) {
        m_ametikohtNimetus = value;
    }

    public Date getAmetikohtAlates() {
        return m_ametikohtAlates;
    }

    public void setAmetikohtAlates(Date value) {
        m_ametikohtAlates = value;
    }

    public Date getAmetikohtKuni() {
        return m_ametikohtKuni;
    }

    public void setAmetikohtKuni(Date value) {
        m_ametikohtKuni = value;
    }

    public int getAllyksusID() {
        return m_allyksusID;
    }

    public void setAllyksusID(int value) {
        m_allyksusID = value;
    }

    public static ArrayList<AarOigus> getListFromSOAP(SOAPBody body) {
        ArrayList<AarOigus> result = new ArrayList<AarOigus>();

        OMElement elKeha = body.getFirstChildWithName(new QName("keha"));
        if (elKeha != null) {
            OMElement elOigused = elKeha.getFirstChildWithName(new QName("oigused"));
            if (elOigused != null) {
                Iterator rightNodes = elOigused.getChildrenWithLocalName("oigus");
                while (rightNodes.hasNext()) {
                    OMElement oigus = (OMElement) rightNodes.next();
                    if (oigus != null) {
                        AarOigus item = AarOigus.getFromSOAP(oigus);
                        if (item != null) {
                            result.add(item);
                        }
                    }
                }
            }
        }

        return result;
    }

    private static AarOigus getFromSOAP(OMElement rootElement) {
        if (rootElement == null) {
            return null;
        }

        AarOigus result = new AarOigus();
        Iterator dataFields = rootElement.getChildElements();
        while (dataFields.hasNext()) {
            OMElement el = (OMElement) dataFields.next();
            if (el.getLocalName().equalsIgnoreCase("oigusNimi")) {
                result.setOigusNimi(el.getText());
            } else if (el.getLocalName().equalsIgnoreCase("oigusAlates")) {
                result.setOigusAlates(CommonMethods.getDateFromXML(el.getText()));
            } else if (el.getLocalName().equalsIgnoreCase("oigusKuni")) {
                result.setOigusKuni(CommonMethods.getDateFromXML(el.getText()));
            } else if (el.getLocalName().equalsIgnoreCase("grupp")) {
                result.setGrupp(el.getText());
            } else if (el.getLocalName().equalsIgnoreCase("registrikood")) {
                result.setRegistrikood(el.getText());
            } else if (el.getLocalName().equalsIgnoreCase("ametikohtId")) {
                result.setAmetikohtID(Integer.parseInt(el.getText()));
            } else if (el.getLocalName().equalsIgnoreCase("isikukood")) {
                result.setIsikukood(el.getText());
            } else if (el.getLocalName().equalsIgnoreCase("ksAmetikohtId")) {
                result.setKsAmetikohtID(Integer.parseInt(el.getText()));
            } else if (el.getLocalName().equalsIgnoreCase("ametikohtNimetus")) {
                result.setAmetikohtNimetus(el.getText());
            } else if (el.getLocalName().equalsIgnoreCase("ametikohtAlates")) {
                result.setAmetikohtAlates(CommonMethods.getDateFromXML(el.getText()));
            } else if (el.getLocalName().equalsIgnoreCase("ametikohtKuni")) {
                result.setAmetikohtKuni(CommonMethods.getDateFromXML(el.getText()));
            } else if (el.getLocalName().equalsIgnoreCase("allyksusId")) {
                result.setAllyksusID(Integer.parseInt(el.getText()));
            }
        }
        return result;
    }
}
