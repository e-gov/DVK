package dvk.core.xroad;

public class XRoadProtocolHeader {

	private XRoadClient xRoadClient;
	
	private XRoadService xRoadService;
	
	private String id;
	
	private String userId;
	
	private String issue;
	
	private XRoadProtocolVersion protocolVersion;
	
	public XRoadProtocolHeader(XRoadClient xRoadClient, String id) {
		this(xRoadClient, id, XRoadProtocolVersion.V4_0);
	}
	
	public XRoadProtocolHeader(XRoadClient xRoadClient, String id, XRoadProtocolVersion protocolVersion) {
		this.xRoadClient = xRoadClient;
		this.id = id;
		this.protocolVersion = protocolVersion;
	}
	
	public XRoadProtocolHeader(XRoadClient xRoadClient, XRoadService xRoadService, String id, String userId, String issue) {
    	this(xRoadClient, id);
    	
    	this.xRoadService = xRoadService;
    	this.userId = userId;
    	this.issue = issue;
    }

	public XRoadClient getxRoadClient() {
		return xRoadClient;
	}

	public void setxRoadClient(XRoadClient xRoadClient) {
		this.xRoadClient = xRoadClient;
	}

	public XRoadService getxRoadService() {
		return xRoadService;
	}

	public void setxRoadService(XRoadService xRoadService) {
		this.xRoadService = xRoadService;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getIssue() {
		return issue;
	}

	public void setIssue(String issue) {
		this.issue = issue;
	}

	public XRoadProtocolVersion getProtocolVersion() {
		return protocolVersion;
	}

	public void setProtocolVersion(XRoadProtocolVersion protocolVersion) {
		this.protocolVersion = protocolVersion;
	}
	
}
