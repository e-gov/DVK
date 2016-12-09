package dvk.core.util;

import dvk.core.Settings;
import dvk.core.xroad.XRoadService;

public class DVKUtil {

	/**
	 * Helper method that creates DVK "service" data as required by the the X-Road message protocol version 4.0 specification.
	 * Common data used for creation of a DVK service data is taken from the related configuration data.
	 * 
	 * @param serviceCode a name of the required DVK service
	 * @param serviceVersion a version of the related DVK service
	 * @return XRoadService object with DVK service data
	 */
	public static XRoadService createXRoadService(String serviceCode, String serviceVersion) {
		String xRoadInstance = Settings.getXRoadServiceInstance();
		String memberClass = Settings.getXRoadServiceMemberClass();
		String memberCode = Settings.getXRoadServiceMemberCode();
		String subsystemCode = Settings.getXRoadServiceSubsystemCode();
		
		return new XRoadService(xRoadInstance, memberClass, memberCode, subsystemCode, serviceCode, serviceVersion);
	}

}
