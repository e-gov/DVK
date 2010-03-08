package dvk.core;

import java.io.OutputStreamWriter;

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
        StringBuffer result = new StringBuffer(250);
        result.append("<fault>");
        result.append("<faultcode>").append(m_faultCode).append("</faultcode>");
        result.append("<faultactor>").append(m_faultActor).append("</faultactor>");
        result.append("<faultstring>").append(m_faultString).append("</faultstring>");
        result.append("<faultdetail>").append(m_faultDetail).append("</faultdetail>");
        result.append("</fault>");
        return result.toString();
    }

    public boolean appendObjectXML(OutputStreamWriter xmlWriter) {
        try {
            // Item element start
            xmlWriter.write("<fault>");

            // Fault code
            if ((m_faultCode != null) && (m_faultCode.length() > 0)) {
            	xmlWriter.write("<faultcode>" + m_faultCode + "</faultcode>");
            }

            // Fault actor
            if ((m_faultActor != null) && (m_faultActor.length() > 0)) {
            	xmlWriter.write("<faultactor>" + m_faultActor + "</faultactor>");
            }

            // Fault string
            if ((m_faultString != null) && (m_faultString.length() > 0)) {
            	xmlWriter.write("<faultstring>" + m_faultString + "</faultstring>");
            }

            // Fault detail
            if ((m_faultDetail != null) && (m_faultDetail.length() > 0)) {
            	xmlWriter.write("<faultdetail>" + m_faultDetail + "</faultdetail>");
            }

            // Item element end
            xmlWriter.write("</fault>");
            return true;
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "appendObjectXML");
            return false;
        }
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
