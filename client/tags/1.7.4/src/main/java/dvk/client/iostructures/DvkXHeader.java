package dvk.client.iostructures;

import dvk.client.businesslayer.ErrorLog;
import dvk.client.dhl.service.LoggingService;
import dvk.core.CommonStructures;
import javax.xml.rpc.handler.MessageContext;
import javax.xml.rpc.handler.soap.SOAPMessageContext;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPFactory;
import javax.xml.soap.SOAPHeader;

public class DvkXHeader implements XHeader {
    private String m_asutus;
    private String m_andmekogu;
    private String m_ametnik;
    private String m_id;
    private String m_nimi;
    private String m_toimik;
    private String m_isikukood;

    public void setAsutus(String asutus) {
        this.m_asutus = asutus;
    }

    public String getAsutus() {
        return m_asutus;
    }

    public void setAndmekogu(String andmekogu) {
        this.m_andmekogu = andmekogu;
    }

    public String getAndmekogu() {
        return m_andmekogu;
    }

    public void setAmetnik(String ametnik) {
        this.m_ametnik = ametnik;
    }

    public String getAmetnik() {
        return m_ametnik;
    }

    public void setId(String id) {
        this.m_id = id;
    }

    public String getId() {
        return m_id;
    }

    public void setNimi(String nimi) {
        this.m_nimi = nimi;
    }

    public String getNimi() {
        return m_nimi;
    }

    public void setToimik(String toimik) {
        this.m_toimik = toimik;
    }

    public String getToimik() {
        return m_toimik;
    }

    public String getIsikukood() {
        return m_isikukood;
    }

    public void setIsikukood(String value) {
        m_isikukood = value;
    }

    public DvkXHeader() {
        clear();
    }

    public DvkXHeader(String asutus, String andmekogu, String ametnik, String id, String nimi, String toimik, String isikukood) {
        this.m_asutus = asutus;
        this.m_andmekogu = andmekogu;
        this.m_ametnik = ametnik;
        this.m_id = id;
        this.m_nimi = nimi;
        this.m_toimik = toimik;
        this.m_isikukood = isikukood;
    }

    public void clear() {
        this.m_asutus = "";
        this.m_andmekogu = "";
        this.m_ametnik = "";
        this.m_id = "";
        this.m_nimi = "";
        this.m_toimik = "";
        this.m_isikukood = "";
    }

    public boolean appendToSOAPHeader(MessageContext context) {
        try {
            SOAPMessageContext smc = (SOAPMessageContext)context;

            // get SOAP envelope from SOAP message
            SOAPEnvelope se = smc.getMessage().getSOAPPart().getEnvelope();
            se.addNamespaceDeclaration(CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            se.addNamespaceDeclaration(CommonStructures.NS_XSI_PREFIX, CommonStructures.NS_XSI_URI);
            se.addNamespaceDeclaration(CommonStructures.NS_SOAPENC_PREFIX, CommonStructures.NS_SOAPENC_URI);

            // create instance of SOAP factory
            SOAPFactory sFactory = SOAPFactory.newInstance();

            // create SOAP elements specifying prefix and URI
            SOAPElement sHelem1 = sFactory.createElement("asutus", CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            sHelem1.addTextNode(m_asutus);
            SOAPElement sHelem2 = sFactory.createElement("andmekogu", CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            sHelem2.addTextNode(m_andmekogu);
            SOAPElement sHelem3 = sFactory.createElement("ametnik", CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            sHelem3.addTextNode(m_ametnik);
            SOAPElement sHelem4 = sFactory.createElement("id", CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            sHelem4.addTextNode(m_id);
            SOAPElement sHelem5 = sFactory.createElement("nimi", CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            sHelem5.addTextNode(m_nimi);
            SOAPElement sHelem6 = sFactory.createElement("toimik", CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            sHelem6.addTextNode(m_toimik);
            SOAPElement sHelem7 = sFactory.createElement("isikukood", CommonStructures.NS_XTEE_PREFIX, CommonStructures.NS_XTEE_URI);
            sHelem7.addTextNode(m_isikukood);

            // create SOAPHeader instance for SOAP envelope
            SOAPHeader sh = se.addHeader();

            // add SOAP element for header to SOAP header object
            sh.addChildElement(sHelem1);
            sh.addChildElement(sHelem2);
            sh.addChildElement(sHelem3);
            sh.addChildElement(sHelem4);
            sh.addChildElement(sHelem5);
            sh.addChildElement(sHelem6);
            sh.addChildElement(sHelem7);

            return true;
        } catch (Exception ex) {
            ErrorLog errorLog = new ErrorLog(ex, this.getClass().getName() + " appendToSOAPHeader");
            LoggingService.logError(errorLog);
            return false;
        }
    }

    @Override
    public String getHeaders() {
        StringBuilder sb = new StringBuilder();
        sb.append("<xtee:asutus>").append(getAsutus()).append("</xtee:asutus>");
        sb.append("<xtee:andmekogu>").append(getAndmekogu()).append("</xtee:andmekogu>");
        sb.append("<xtee:ametnik>").append(getAmetnik()).append("</xtee:ametnik>");
        sb.append("<xtee:nimi>").append(getNimi()).append("</xtee:nimi>");
        sb.append("<xtee:id>").append(getId()).append("</xtee:id>");
        sb.append("<xtee:toimik>").append(getToimik()).append("</xtee:toimik>");
        sb.append("<xtee:isikukood>").append(getIsikukood()).append("</xtee:isikukood>");
        return sb.toString();
    }
}
