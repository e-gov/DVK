package dvk.client.iostructures;

public class SoapMessageBuilder {
    private XHeader m_header;
    private String m_body;

    public SoapMessageBuilder(XHeader header, String body) {
        m_header = header;
        m_body = body;
    }

    public String getMessageAsText() {
        return getMessageAsText("dhl", "http://producers.dhl.xtee.riik.ee/producer/dhl");
    }

    public String getMessageAsText(String producerPrefix, String producerURI) {
        StringBuilder sb = new StringBuilder();
        sb.append("<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:"+ producerPrefix +"=\""+ producerURI +"\" xmlns:xtee=\"http://x-tee.riik.ee/xsd/xtee.xsd\">");

        // X-Tee päis
        sb.append("<env:Header>");
        sb.append("<xtee:asutus>" + m_header.getAsutus() + "</xtee:asutus>");
        sb.append("<xtee:andmekogu>" + m_header.getAndmekogu() + "</xtee:andmekogu>");
        sb.append("<xtee:ametnik>" + m_header.getAmetnik() + "</xtee:ametnik>");
        sb.append("<xtee:nimi>" + m_header.getNimi() + "</xtee:nimi>");
        sb.append("<xtee:id>" + m_header.getId() + "</xtee:id>");
        sb.append("<xtee:toimik>" + m_header.getToimik() + "</xtee:toimik>");
        sb.append("<xtee:isikukood>" + m_header.getIsikukood() + "</xtee:isikukood>");
        sb.append("</env:Header>");

        // Keha
        sb.append("<env:Body>");
        sb.append(m_body);
        sb.append("</env:Body>");

        // Ümbriku lõpp
        sb.append("</env:Envelope>");

        return sb.toString();
    }
}
