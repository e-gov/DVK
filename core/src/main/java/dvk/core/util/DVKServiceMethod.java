package dvk.core.util;

/**
 * This is a helper enumeration class that contains data regarding DVK service methods.  
 * 
 * @author Levan Kekelidze
 */
public enum DVKServiceMethod {
	
	SEND_DOCUMENTS("sendDocuments"),
	GET_SEND_STATUS("getSendStatus"),
	GET_SENDING_OPTIONS("getSendingOptions"),
	RECEIVE_DOCUMENTS("receiveDocuments"),
	MARK_DOCUMENTS_RECEIVED("markDocumentsReceived"),
	DELETE_OLD_DOCUMENTS("deleteOldDocuments"),
	CHANGE_ORGANIZATION_DATA("changeOrganizationData"),
	RUN_SYSTEM_CHECK("runSystemCheck"),
	GET_OCCUPATION_LIST("getOccupationList"),
	GET_SUBDIVISION_LIST("getSubdivisionList");
	
	private final String name;
	
	private DVKServiceMethod(String name) {
		this.name = name;
	}

	public String getName() {
		return name;
	}
	
}
