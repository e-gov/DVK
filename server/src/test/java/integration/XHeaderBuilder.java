package integration;

import dvk.core.xroad.XRoadHeader;
import dvk.core.xroad.XRoadMessageProtocolVersion;

/**
 * {@link dvk.core.xroad.XRoadHeader} builder class for simpler testing purposes.
 */
class XHeaderBuilder {
    private String asutus;
    private String andmekogu;
    private String ametnik;
    private String id;
    private String nimi;
    private String toimik;
    private String isikukood;

    public XHeaderBuilder setAsutus(String asutus) {
        this.asutus = asutus;
        return this;
    }

    public XHeaderBuilder setAndmekogu(String andmekogu) {
        this.andmekogu = andmekogu;
        return this;
    }

    public XHeaderBuilder setAmetnik(String ametnik) {
        this.ametnik = ametnik;
        return this;
    }

    public XHeaderBuilder setId(String id) {
        this.id = id;
        return this;
    }

    public XHeaderBuilder setNimi(String nimi) {
        this.nimi = nimi;
        return this;
    }

    public XHeaderBuilder setToimik(String toimik) {
        this.toimik = toimik;
        return this;
    }

    public XHeaderBuilder setIsikukood(String isikukood) {
        this.isikukood = isikukood;
        return this;
    }

    public XRoadHeader build() {
        return new XRoadHeader(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood, XRoadMessageProtocolVersion.V2_0);
    }
    
}
