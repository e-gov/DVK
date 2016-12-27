package dvk.core.util;

import org.apache.commons.lang3.StringUtils;

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
		String xRoadInstance = Settings.getDvkXRoadServiceInstance();
		String memberClass = Settings.getDvkXRoadServiceMemberClass();
		String memberCode = Settings.getDvkXRoadServiceMemberCode();
		String subsystemCode = Settings.getDvkXRoadServiceSubsystemCode();
		
		return new XRoadService(xRoadInstance, memberClass, memberCode, subsystemCode, serviceCode, serviceVersion);
	}

	/**
	 * Helper method that checks all passed strings are not blank in the meaning as it described
	 * in the related Apache Commons Lang's utility method {@link StringUtils#isNoneBlank(CharSequence...)}.
	 * 
	 * @param strings strings to be checked
	 * @return {@code true} if all passed strings are not blank, {@code false} otherwise.<br>
	 *         This method also returns {@code false} if {@code null} was passed as a parameter,
	 *         or the passed arguments have zero length.
	 */
	public static boolean areNotBlank(String... strings) {
	    if (strings == null || strings.length == 0) {
	        return false;
	    }
	    
	    for (String string : strings) {
	        if (StringUtils.isBlank(string)) {
	            return false;
	        }
	    }
	    
	    return true;
	}
	
}
