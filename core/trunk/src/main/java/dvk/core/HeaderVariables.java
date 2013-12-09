package dvk.core;

public class HeaderVariables {
    private String m_organizationCode;
    private String m_personalIDCode;
    private String m_caseName;
    private String m_PIDWithCountryCode;

    public String getOrganizationCode() {
        return m_organizationCode;
    }

    public void setOrganizationCode(String value) {
        m_organizationCode = value;
    }

    public String getPersonalIDCode() {
        return m_personalIDCode;
    }

    public void setPersonalIDCode(String value) {
        m_personalIDCode = value;
    }

    public String getCaseName() {
        return m_caseName;
    }

    public void setCaseName(String value) {
        m_caseName = value;
    }

    public String getPIDWithCountryCode() {
        return m_PIDWithCountryCode;
    }

    public void setPIDWithCountryCode(String value) {
        m_PIDWithCountryCode = value;
    }

    public HeaderVariables(String organizationCode, String personalIDCode, String caseName, String pidWithCountryCode) {
        this.m_organizationCode = organizationCode;
        this.m_personalIDCode = personalIDCode;
        this.m_caseName = caseName;
        this.m_PIDWithCountryCode = pidWithCountryCode;
    }
}
