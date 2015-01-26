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
        sb.append("<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:"+ producerPrefix +"=\""+ producerURI +"\" xmlns:xtee=\"http://x-tee.riik.ee/xsd/xtee.xsd\" xmlns:adit=\"http://producers.ametlikud-dokumendid.xtee.riik.ee/producer/ametlikud-dokumendid\">");

        // X-Tee päis
        sb.append("<env:Header>");
        sb.append(m_header.getHeaders());
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
