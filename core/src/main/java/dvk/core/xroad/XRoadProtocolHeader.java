package dvk.core.xroad;

public enum XRoadProtocolHeader {

	CLIENT("client"),
	SERVICE("service"),
	CENTRAL_SERVICE("centralService"),
	ID("id"),
	USER_ID("userId"),
	ISSUE("issue"),
	PROTOCOL_VERSION("protocolVersion"),
	REQUEST_HASH("requestHash"),
	REQUEST_HASH_ALGORITHM_ID("requestHash/@algorithmId");
	
	private final String field;
	
	private XRoadProtocolHeader(String field) {
		this.field = field;
	}
	
	public String getField() {
		return field;
	}
	
}
