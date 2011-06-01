package dvk.client.iostructures;

public class SimpleAddressData {
    private String m_orgCode;
    private String m_orgName;
    private String m_personCode;
    private String m_personName;
    private String m_email;
    private String m_departmentNr;
    private String m_departmentName;
    private int m_divisionID;
    private String m_divisionCode;
    private String m_divisionName;
    private int m_positionID;
    private String m_positionCode;
    private String m_positionName;
    private int m_unitID;
    private boolean m_fyi;

    public String getOrgCode() {
        return m_orgCode;
    }

    public void setOrgCode(String value) {
        m_orgCode = value;
    }

    public String getOrgName() {
        return m_orgName;
    }

    public void setOrgName(String value) {
        m_orgName = value;
    }

    public String getPersonCode() {
        return m_personCode;
    }

    public void setPersonCode(String value) {
        m_personCode = value;
    }

    public String getPersonName() {
        return m_personName;
    }

    public void setPersonName(String value) {
        m_personName = value;
    }

    public String getEmail() {
        return m_email;
    }

    public void setEmail(String value) {
        m_email = value;
    }

    public String getDepartmentNr() {
        return m_departmentNr;
    }

    public void setDepartmentNr(String value) {
        m_departmentNr = value;
    }

    public String getDepartmentName() {
        return m_departmentName;
    }

    public void setDepartmentName(String value) {
        m_departmentName = value;
    }

    public int getDivisionID() {
        return m_divisionID;
    }

    public void setDivisionID(int value) {
        m_divisionID = value;
    }

    public String getDivisionCode() {
        return this.m_divisionCode;
    }

    public void setDivisionCode(String value) {
        this.m_divisionCode = value;
    }

    public String getDivisionName() {
        return m_divisionName;
    }

    public void setDivisionName(String value) {
        m_divisionName = value;
    }

    public int getPositionID() {
        return m_positionID;
    }

    public String getPositionCode() {
        return this.m_positionCode;
    }

    public void setPositionCode(String value) {
        this.m_positionCode = value;
    }

    public void setPositionID(int value) {
        m_positionID = value;
    }

    public String getPositionName() {
        return m_positionName;
    }

    public void setPositionName(String value) {
        m_positionName = value;
    }

    public int getUnitID() {
        return m_unitID;
    }

    public void setUnitID(int value) {
        m_unitID = value;
    }

    public SimpleAddressData() {
        clear();
    }

    public void clear() {
        m_orgCode = "";
        m_orgName = "";
        m_personCode = "";
        m_personName = "";
        m_email = "";
        m_departmentNr = "";
        m_departmentName = "";
        m_divisionID = 0;
        m_divisionCode = "";
        m_divisionName = "";
        m_positionID = 0;
        m_positionCode = "";
        m_positionName = "";
        m_unitID = 0;
    }

	public boolean isFyi() {
		return m_fyi;
	}

	public void setFyi(boolean fyi) {
		this.m_fyi = fyi;
	}
}
