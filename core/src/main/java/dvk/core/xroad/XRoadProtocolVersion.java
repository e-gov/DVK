package dvk.core.xroad;

public enum XRoadProtocolVersion {

	V1_0("1.0"),	// supported by X-Road v1 - v4
	V2_0("2.0"),	// supported by X-Road v2 - v5
	V3_0("3.0"),	// supported by X-Road v5
	V3_1("3.1"),	// supported by X-Road v5
	V4_0("4.0");	// supported by X-Road v6
	
	private final String value;
	
	private XRoadProtocolVersion(String value) {
		this.value = value;
	}
	
	public String getValue() {
		return value;
	}
	
}
