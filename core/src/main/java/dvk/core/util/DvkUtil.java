package dvk.core.util;

import dvk.core.Settings;
import dvk.core.xroad.XRoadService;

public class DvkUtil {

	public static XRoadService createDvkXRoadService(String serviceCode, String serviceVersion) {
		String xRoadInstance = Settings.getXRoadInstance();
		String memberClass = Settings.getXRoadMemberClass();
		String memberCode = Settings.getxRoadMemberCode();
		String subsystemCode = Settings.getXRoadSubsystemCode();
		
		return new XRoadService(xRoadInstance, memberClass, memberCode, subsystemCode, serviceCode, serviceVersion);
	}

}
