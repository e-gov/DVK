package ee.ria.dvk.client.testutil;

import org.apache.log4j.Logger;

/**
 * Created with IntelliJ IDEA.
 * User: Liza Leo
 * Date: 4.08.14
 * Time: 17:53
 */

public class DhlSetting {
    public final static String CONTAINER_VERSION_1_0 = "1.0";
    public final static String CONTAINER_VERSION_2_1 = "2.1";
    private String institutionCode;
    private String institutionName;
    private String personalIdCode;

    private static Logger logger = Logger.getLogger(DhlSetting.class);

    public DhlSetting() {
    }

    public DhlSetting(String version) {
        if (CONTAINER_VERSION_1_0.equalsIgnoreCase(version)) {
            this.institutionCode = "icefire-test1";
            this.institutionName = "ICEFIRE TEST1";
            this.personalIdCode = "36212240216";
        } else if (CONTAINER_VERSION_2_1.equalsIgnoreCase(version)) {
            this.institutionCode = "10885324";
            this.institutionName = "Icefire OÜ";
            this.personalIdCode = "36212240216";
        } else {
            logger.error("DhlSetting constructor incorrect version:" + version);
        }
    }

    public DhlSetting(String institutionCode, String institutionName, String personalIdCode) {
        this.institutionCode = institutionCode;
        this.institutionName = institutionName;
        this.personalIdCode = personalIdCode;
    }

    public String getInstitutionCode() {
        return institutionCode;
    }

    public String getInstitutionName() {
        return institutionName;
    }

    public String getPersonalIdCode() {
        return personalIdCode;
    }

    public void setInstitutionCode(String institutionCode) {
        this.institutionCode = institutionCode;
    }

    public void setInstitutionName(String institutionName) {
        this.institutionName = institutionName;
    }

    public void setPersonalIdCode(String personalIdCode) {
        this.personalIdCode = personalIdCode;
    }

}
