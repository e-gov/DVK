package dvk.core.xroad;

public enum XRoadObjectType {

	MEMBER("MEMBER"),
	SUBSYSTEM("SUBSYSTEM"),
	SERVICE("SERVICE"),
	CENTRAL_SERVICE("CENTRALSERVICE");
	
	private final String name;
	
	private XRoadObjectType(String name) {
		this.name = name;
	}
	
	public String getName() {
		return name;
	}
	
}
