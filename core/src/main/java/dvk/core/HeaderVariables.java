package dvk.core;

public class HeaderVariables {
	
    private String m_organizationCode;
    private String m_personalIDCode;
    private String m_caseName;
    private String m_PIDWithCountryCode;
    
    private String xRoadClientInstance;
    private String xRoadClientMemberClass;
    private String xRoadClientSubsystemCode;
    
    public HeaderVariables(String organizationCode, String personalIDCode, String caseName, String pidWithCountryCode,
    		String xRoadClientInstance, String xRoadClientMemberClass, String xRoadClientSubsystemCode) {
    	
        this.m_organizationCode = organizationCode;
        this.m_personalIDCode = personalIDCode;
        this.m_caseName = caseName;
        this.m_PIDWithCountryCode = pidWithCountryCode;
    	
    	this.xRoadClientInstance = xRoadClientInstance;
    	this.xRoadClientMemberClass = xRoadClientMemberClass;
    	this.xRoadClientSubsystemCode = xRoadClientSubsystemCode;
    }

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
    
    public String getXRoadClientInstance() {
		return xRoadClientInstance;
	}

	public void setXRoadClientInstance(String xRoadClientInstance) {
		this.xRoadClientInstance = xRoadClientInstance;
	}

	public String getXRoadClientMemberClass() {
		return xRoadClientMemberClass;
	}

	public void setXRoadClientMemberClass(String xRoadClientMemberClass) {
		this.xRoadClientMemberClass = xRoadClientMemberClass;
	}

	public String getXRoadClientSubsystemCode() {
		return xRoadClientSubsystemCode;
	}

	public void setXRoadClientSubsystemCode(String xRoadClientSubsystemCode) {
		this.xRoadClientSubsystemCode = xRoadClientSubsystemCode;
	}
    
}
