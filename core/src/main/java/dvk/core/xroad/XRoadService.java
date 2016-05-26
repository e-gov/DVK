package dvk.core.xroad;

import dvk.core.Settings;

/**
 * This class models XRoadServiceIdentifierType as defined in the related
 * <a href="http://x-road.eu/xsd/identifiers.xsd">XML schema</a>.
 * 
 * @author Levan Kekelidze
 *
 */
public class XRoadService extends XRoadIdentifier {
	
	public XRoadService() {}
	
	public XRoadService(String xRoadInstance, String memberClass, String memberCode, String serviceCode) {
		this.xRoadInstance = xRoadInstance;
		this.memberClass = memberClass;
		this.memberCode = memberCode;
		this.serviceCode = serviceCode;
	}
	
	public XRoadService(String xRoadInstance, String memberClass, String memberCode, String subsystemCode, String serviceCode, String serviceVersion) {
		this(xRoadInstance, memberClass, memberCode, serviceCode);
		this.subsystemCode = subsystemCode;
		this.serviceVersion = serviceVersion;
	}
	
	/**
	 * This constructor builds an X-Road service using predefined settings for
	 * <em>xRoadInstance</em>, <em>memberClass</em>, <em>memberCode</em> and <em>subsystemCode</em>.
	 * 
	 * @param serviceCode name of the <em>serviceCode</em> as defined in the X-Road protocol v.4.0 specification
	 * @param serviceVersion name of the <em>serviceVersion</em> as defined in the X-Road protocol v.4.0 specification
	 */
	public XRoadService(String serviceCode, String serviceVersion) {
		this.xRoadInstance = Settings.getXRoadInstance();
		this.memberClass = Settings.getXRoadMemberClass();
		this.memberCode = Settings.getxRoadMemberCode();
		this.subsystemCode = Settings.getXRoadSubsystemCode();
		
		this.serviceCode = serviceCode;
		this.serviceVersion = serviceVersion;
	}
	
	public String getxRoadInstance() {
		return xRoadInstance;
	}

	public void setxRoadInstance(String xRoadInstance) {
		this.xRoadInstance = xRoadInstance;
	}

	public String getMemberClass() {
		return memberClass;
	}

	public void setMemberClass(String memberClass) {
		this.memberClass = memberClass;
	}

	public String getMemberCode() {
		return memberCode;
	}

	public void setMemberCode(String memberCode) {
		this.memberCode = memberCode;
	}

	public String getSubsystemCode() {
		return subsystemCode;
	}

	public void setSubsystemCode(String subsystemCode) {
		this.subsystemCode = subsystemCode;
	}
	
	public String getServiceCode() {
		return serviceCode;
	}

	public void setServiceCode(String serviceCode) {
		this.serviceCode = serviceCode;
	}

	public String getServiceVersion() {
		return serviceVersion;
	}

	public void setServiceVersion(String serviceVersion) {
		this.serviceVersion = serviceVersion;
	}
	
}
