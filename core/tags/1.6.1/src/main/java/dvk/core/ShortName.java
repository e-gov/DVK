package dvk.core;

public class ShortName {
	private String m_orgCode;
	private String m_shortName;
	
    public String getOrgCode() {
        return this.m_orgCode;
    }

    public void setOrgCode(String value) {
        this.m_orgCode = value;
    }

    public String getShortName() {
        return this.m_shortName;
    }

    public void setShortName(String value) {
        this.m_shortName = value;
    }
    
    public ShortName() {
    	m_orgCode = "";
    	m_shortName = "";
    }
    
    public ShortName(String orgCode, String shortName) {
    	m_orgCode = orgCode;
    	m_shortName = shortName;
    }
}