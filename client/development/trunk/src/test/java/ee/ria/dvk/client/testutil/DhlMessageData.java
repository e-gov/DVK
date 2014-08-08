package ee.ria.dvk.client.testutil;

/**
 * Created with IntelliJ IDEA.
 * User: Liza Leo
 * Date: 8.08.14
 * Time: 13:48
 */

public class DhlMessageData {
    private int id;
    private int dhlId;
    private String xmlData;

    public DhlMessageData(int id, String xmlData) {
        this.id = id;
        this.dhlId = 0;
        this.xmlData = xmlData;
    }

    public DhlMessageData(int id, int dhlId, String xmlData) {
        this.id = id;
        this.dhlId = dhlId;
        this.xmlData = xmlData;
    }

    public DhlMessageData() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getDhlId() {
        return dhlId;
    }

    public void setDhlId(int dhlId) {
        this.dhlId = dhlId;
    }

    public String getXmlData() {
        return xmlData;
    }

    public void setXmlData(String xmlData) {
        this.xmlData = xmlData;
    }

}
