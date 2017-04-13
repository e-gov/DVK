package dvk.core.xroad;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.builder.EqualsBuilder;
import org.apache.commons.lang3.builder.HashCodeBuilder;

/**
 * This class models XRoadServiceIdentifierType as defined in the related
 * <a href="http://x-road.eu/xsd/identifiers.xsd">XML schema</a>.
 * 
 * @author Levan Kekelidze
 *
 */
public class XRoadService extends XRoadIdentifier {
	
	private String serviceURL;
	
	public XRoadService() {}
	
	/**
	 * A constructor for XRoad service with <em>mandatory</em> parameters.
	 * 
	 * @param xRoadServiceInstance
	 * @param memberClass
	 * @param memberCode
	 * @param serviceCode
	 */
	public XRoadService(String xRoadInstance, String memberClass, String memberCode, String serviceCode) {
		this.xRoadInstance = xRoadInstance;
		this.memberClass = memberClass;
		this.memberCode = memberCode;
		this.serviceCode = serviceCode;
	}
	
	/**
	 * A constructor for XRoad service.
	 * 
	 * <p>
	 * NOTE:<br>
	 * According to the XRoadServiceIdentifierType XSD definition {@code subsystemCode} and {@code serviceVersion} are <em>optional</em>.
	 * </p>
	 * 
	 * @param xRoadServiceInstance
	 * @param memberClass
	 * @param memberCode
	 * @param subsystemCode
	 * @param serviceCode
	 * @param serviceVersion
	 */
	public XRoadService(String xRoadInstance, String memberClass, String memberCode, String subsystemCode, String serviceCode, String serviceVersion) {
		this(xRoadInstance, memberClass, memberCode, serviceCode);
		
		this.subsystemCode = subsystemCode;
		this.serviceVersion = serviceVersion;
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
	
	public String getServiceCode() {
		return serviceCode;
	}

	public void setServiceCode(String serviceCode) {
		this.serviceCode = serviceCode;
	}

	public String getServiceVersion() {
		if (StringUtils.isBlank(serviceVersion)) {
			serviceVersion = "v1";
		}
		
		return serviceVersion;
	}

	public void setServiceVersion(String serviceVersion) {
		this.serviceVersion = serviceVersion;
	}

	public String getServiceURL() {
		return serviceURL;
	}

	public void setServiceURL(String serviceURL) {
		this.serviceURL = serviceURL;
	}

	@Override
	public boolean isValid() {
		
		return StringUtils.isNotBlank(xRoadInstance)
				&& StringUtils.isNotBlank(memberClass)
				&& StringUtils.isNotBlank(memberCode)
				&& StringUtils.isNotBlank(subsystemCode)
				&& StringUtils.isNotBlank(serviceCode);
	}
	
	/**
	 * Same as {@link #isValid()}, but also checks that the service URL data is also present.
	 * <p>
	 * NOTE:<br>
	 * no validation for URL is performed here.
	 * </p>
	 * 
	 * @return {@code true} if both the required fields AND the related service URL are not empty or {@code null}, {@code false} otherwise.
	 */
	public boolean isValidWithAddress() {
		
		return isValid() && StringUtils.isNotBlank(serviceURL);
	}
	
	@Override
	public boolean isEmpty() {
		
		return StringUtils.isBlank(xRoadInstance)
				&& StringUtils.isBlank(memberClass)
				&& StringUtils.isBlank(memberCode)
				&& StringUtils.isBlank(subsystemCode)
				&& StringUtils.isBlank(serviceCode);
	}

	public boolean isEmptyWithAddress() {
		
		return isEmpty() && StringUtils.isBlank(serviceURL);
	}
	
	@Override
	public int hashCode() {
		return new HashCodeBuilder()
				.append(xRoadInstance)
				.append(memberClass)
				.append(memberCode)
				.append(subsystemCode)
				.append(serviceCode)
				.append(getServiceVersion()).hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		
		if (!(obj instanceof XRoadService)) {
			return false;
		}
		
		XRoadService other = (XRoadService) obj;

		EqualsBuilder equalsBuilder = new EqualsBuilder();
		equalsBuilder
			.append(xRoadInstance, other.getXRoadInstance())
			.append(memberClass, other.getMemberClass())
			.append(memberCode, other.getMemberCode())
			.append(subsystemCode, other.getSubsystemCode())
			.append(serviceCode, other.getServiceCode())
			.append(getServiceVersion(), other.getServiceVersion());
		
		return equalsBuilder.isEquals();
	}
	
}
