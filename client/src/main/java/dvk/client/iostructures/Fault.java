package dvk.client.iostructures;

import dvk.core.CommonMethods;
import org.apache.commons.lang3.StringEscapeUtils;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

public class Fault {
    private String m_faultCode;
    private String m_faultActor;
    private String m_faultString;
    private String m_faultDetail;

    public void setFaultCode(String faultCode) {
        this.m_faultCode = faultCode;
    }

    public String getFaultCode() {
        return m_faultCode;
    }

    public void setFaultActor(String faultActor) {
        this.m_faultActor = faultActor;
    }

    public String getFaultActor() {
        return m_faultActor;
    }

    public void setFaultString(String faultString) {
        this.m_faultString = faultString;
    }

    public String getFaultString() {
        return m_faultString;
    }

    public void setFaultDetail(String faultDetail) {
        this.m_faultDetail = faultDetail;
    }

    public String getFaultDetail() {
        return m_faultDetail;
    }

    public Fault() {
        clear();
    }

    public Fault(String faultCode, String faultActor, String faultString, String faultDetail) {
        m_faultCode = faultCode;
        m_faultActor = faultActor;
        m_faultString = faultString;
        m_faultDetail = faultDetail;
    }

    public void clear() {
        m_faultCode = "";
        m_faultActor = "";
        m_faultString = "";
        m_faultDetail = "";
    }

    public String toXML() {
        String result = "<fault>";
        result += "<faultcode>" + m_faultCode + "</faultcode>";
        result += "<faultactor>" + m_faultActor + "</faultactor>";
        result += "<faultstring>" + m_faultString + "</faultstring>";
        result += "<faultdetail>" + StringEscapeUtils.escapeXml11(m_faultDetail) + "</faultdetail>";
        result += "</fault>";

        return result;
    }

    public static Fault getFromXML(Element root) {
        Fault result = new Fault();

        NodeList nl = root.getElementsByTagName("faultcode");
        if ((nl != null) && (nl.getLength() > 0)) {
            result.setFaultCode(CommonMethods.getNodeText(nl.item(0)));
        }

        nl = root.getElementsByTagName("faultactor");
        if ((nl != null) && (nl.getLength() > 0)) {
            result.setFaultActor(CommonMethods.getNodeText(nl.item(0)));
        }

        nl = root.getElementsByTagName("faultstring");
        if ((nl != null) && (nl.getLength() > 0)) {
            result.setFaultString(CommonMethods.getNodeText(nl.item(0)));
        }

        nl = root.getElementsByTagName("faultdetail");
        if ((nl != null) && (nl.getLength() > 0)) {
            result.setFaultDetail(CommonMethods.getNodeText(nl.item(0)));
        }

        if (((result.getFaultCode() == null) || (result.getFaultCode().trim().length() == 0)) && ((result.getFaultActor() == null) || (result.getFaultActor().trim().length() == 0)) && ((result.getFaultString() == null) || (result.getFaultString().trim().length() == 0)) && ((result.getFaultDetail() == null) || (result.getFaultDetail().trim().length() == 0))) {
            result = null;
        }

        return result;
    }
}
