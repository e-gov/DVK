package dvk.core.xroad;

import org.apache.commons.lang3.StringUtils;

/**
 * This class models XRoadClientIdentifierType as defined in the related
 * <a href="http://x-road.eu/xsd/identifiers.xsd">XML schema</a>.
 * 
 * @author Levan Kekelidze
 *
 */
public class XRoadClient extends XRoadIdentifier {
	
	/**
	 * The default constructor.
	 */
	public XRoadClient() {}
	
	/**
	 * A constructor for X-Road client with <em>mandatory</em> parameters.
	 * 
	 * @param xRoadServiceInstance 
	 * @param memberClass
	 * @param memberCode
	 */
	public XRoadClient(String xRoadInstance, String memberClass, String memberCode) {
		this.xRoadInstance = xRoadInstance;
		this.memberClass = memberClass;
		this.memberCode = memberCode;
	}
	
	/**
	 * A constructor for X-Road client.
	 * 
	 * <p>
	 * NOTE:<br>
	 * According to the XRoadServiceIdentifierType XSD definition {@code subsystemCode} is <em>optional</em>.
	 * </p>
	 * 
	 * @param xRoadServiceInstance
	 * @param memberClass
	 * @param memberCode
	 * @param subsytemCode
	 */
	public XRoadClient(String xRoadInstance, String memberClass, String memberCode, String subsytemCode) {
		this(xRoadInstance, memberClass, memberCode);
		
		this.subsystemCode = subsytemCode;
		
	}
	
	public String getXRoadInstance() {
		return xRoadInstance;
	}

	public void setXRoadInstance(String xRoadInstance) {
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

	@Override
	public boolean isValid() {
		
		return StringUtils.isNotBlank(xRoadInstance)
				&& StringUtils.isNotBlank(memberClass)
				&& StringUtils.isNotBlank(memberCode);
	}

	@Override
	public boolean isEmpty() {
		
		return StringUtils.isBlank(xRoadInstance)
				&& StringUtils.isBlank(memberClass)
				&& StringUtils.isBlank(memberCode);
	}
	
}
