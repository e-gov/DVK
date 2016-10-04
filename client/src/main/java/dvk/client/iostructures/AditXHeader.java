package dvk.client.iostructures;

/**
 * @author Hendrik Pärna
 * @since 3.04.14
 */
public class AditXHeader extends DvkXHeader implements XHeader {

    private String infosysteem;

    public AditXHeader(String infosysteem, String asutus, String andmekogu, String ametnik, String id, String nimi, String toimik, String isikukood) {
        super(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood);
        this.infosysteem = infosysteem;
    }

    @Override
    public String getHeaders() {
        StringBuilder sb = new StringBuilder();
        sb.append("<adit:infosysteem>").append(getInfosysteem()).append("</adit:infosysteem>");
        sb.append(super.getHeaders());
        return sb.toString();
    }

    public String getInfosysteem() {
        return infosysteem;
    }
}
