package dvk.api.ml;

// Generated 7.02.2010 22:22:31 by Hibernate Tools 3.2.4.GA

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.sql.Clob;
import java.util.Date;

import dvk.api.IMessageObserver;
import dvk.api.DVKAPI.DvkType;

/**
 * DhlMessage generated by hbm2java
 */
public class PojoMessage implements IMessageObserver, java.io.Serializable
{
	public static class FieldNames
	{
		public static final String dhlMessageId = "dhlMessageId";
		public static final String isIncoming = "isIncoming";
		public static final String data = "data";
		public static final String title = "title";
		public static final String senderOrgCode = "senderOrgCode";
		public static final String senderOrgName = "senderOrgName";
		public static final String senderPersonCode = "senderPersonCode";
		public static final String senderName = "senderName";
		public static final String recipientOrgCode = "recipientOrgCode";
		public static final String recipientOrgName = "recipientOrgName";
		public static final String recipientPersonCode = "recipientPersonCode";
		public static final String recipientName = "recipientName";
		public static final String caseName = "caseName";
		public static final String dhlFolderName = "dhlFolderName";
		public static final String sendingStatusId = "sendingStatusId";
		public static final String unitId = "unitId";
		public static final String dhlId = "dhlId";
		public static final String sendingDate = "sendingDate";
		public static final String receivedDate = "receivedDate";
		public static final String localItemId = "localItemId";
		public static final String recipientStatusId = "recipientStatusId";
		public static final String faultCode = "faultCode";
		public static final String faultActor = "faultActor";
		public static final String faultString = "faultString";
		public static final String faultDetail = "faultDetail";
		public static final String statusUpdateNeeded = "statusUpdateNeeded";
		public static final String metaxml = "metaxml";
		public static final String queryId = "queryId";
		public static final String proxyOrgCode = "proxyOrgCode";
		public static final String proxyOrgName = "proxyOrgName";
		public static final String proxyPersonCode = "proxyPersonCode";
		public static final String proxyName = "proxyName";
		public static final String recipientDepartmentNr = "recipientDepartmentNr";
		public static final String recipientDepartmentName = "recipientDepartmentName";
		public static final String recipientEmail = "recipientEmail";
		public static final String recipientDivisionId = "recipientDivisionId";
		public static final String recipientDivisionName = "recipientDivisionName";
		public static final String recipientPositionId = "recipientPositionId";
		public static final String recipientPositionName = "recipientPositionName";
	}

	/**
	 * 
	 */
	final static String PojoName = PojoMessage.class.getName();
	private static final long serialVersionUID = 7862552201678593426L;
	protected long dhlMessageId = -1;
	protected boolean isIncoming;
	protected Clob data;
	protected String title;
	protected String senderOrgCode;
	protected String senderOrgName;
	protected String senderPersonCode;
	protected String senderName;
	protected String recipientOrgCode;
	protected String recipientOrgName;
	protected String recipientPersonCode;
	protected String recipientName;
	protected String caseName;
	protected String dhlFolderName;
	protected long sendingStatusId;
	protected long unitId;
	protected Long dhlId;
	protected Date sendingDate;
	protected Date receivedDate;
	protected Long localItemId;
	protected Long recipientStatusId;
	protected String faultCode;
	protected String faultActor;
	protected String faultString;
	protected String faultDetail;
	protected Long statusUpdateNeeded;
	protected Clob metaxml;
	protected String queryId;
	protected String proxyOrgCode;
	protected String proxyOrgName;
	protected String proxyPersonCode;
	protected String proxyName;
	protected String recipientDepartmentNr;
	protected String recipientDepartmentName;
	protected String recipientEmail;
	protected BigDecimal recipientDivisionId;
	protected String recipientDivisionName;
	protected BigDecimal recipientPositionId;
	protected String recipientPositionName;

	public PojoMessage() {
	}

	public PojoMessage(long dhlMessageId) {
		this.dhlMessageId = dhlMessageId;
	}

	public long getDhlMessageId() {
		return this.dhlMessageId;
	}

	public void setDhlMessageId(long dhlMessageId) {
		this.dhlMessageId = dhlMessageId;
	}

	public boolean isIsIncoming() {
		return this.isIncoming;
	}

	public void setIsIncoming(boolean isIncoming) {
		this.isIncoming = isIncoming;
	}

	public Clob getData() {
		return this.data;
	}

	public void setData(Clob data) {
		this.data = data;
	}

	public String getTitle() {
		return this.title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getSenderOrgCode() {
		return this.senderOrgCode;
	}

	public void setSenderOrgCode(String senderOrgCode) {
		this.senderOrgCode = senderOrgCode;
	}

	public String getSenderOrgName() {
		return this.senderOrgName;
	}

	public void setSenderOrgName(String senderOrgName) {
		this.senderOrgName = senderOrgName;
	}

	public String getSenderPersonCode() {
		return this.senderPersonCode;
	}

	public void setSenderPersonCode(String senderPersonCode) {
		this.senderPersonCode = senderPersonCode;
	}

	public String getSenderName() {
		return this.senderName;
	}

	public void setSenderName(String senderName) {
		this.senderName = senderName;
	}

	public String getRecipientOrgCode() {
		return this.recipientOrgCode;
	}

	public void setRecipientOrgCode(String recipientOrgCode) {
		this.recipientOrgCode = recipientOrgCode;
	}

	public String getRecipientOrgName() {
		return this.recipientOrgName;
	}

	public void setRecipientOrgName(String recipientOrgName) {
		this.recipientOrgName = recipientOrgName;
	}

	public String getRecipientPersonCode() {
		return this.recipientPersonCode;
	}

	public void setRecipientPersonCode(String recipientPersonCode) {
		this.recipientPersonCode = recipientPersonCode;
	}

	public String getRecipientName() {
		return this.recipientName;
	}

	public void setRecipientName(String recipientName) {
		this.recipientName = recipientName;
	}

	public String getCaseName() {
		return this.caseName;
	}

	public void setCaseName(String caseName) {
		this.caseName = caseName;
	}

	public String getDhlFolderName() {
		return this.dhlFolderName;
	}

	public void setDhlFolderName(String dhlFolderName) {
		this.dhlFolderName = dhlFolderName;
	}

	public long getSendingStatusId() {
		return this.sendingStatusId;
	}

	public void setSendingStatusId(long sendingStatusId) {
		this.sendingStatusId = sendingStatusId;
	}

	public long getUnitId() {
		return this.unitId;
	}

	public void setUnitId(long unitId) {
		this.unitId = unitId;
	}

	public Long getDhlId() {
		return this.dhlId;
	}

	public void setDhlId(Long dhlId) {
		this.dhlId = dhlId;
	}

	public Date getSendingDate() {
		return this.sendingDate;
	}

	public void setSendingDate(Date sendingDate) {
		this.sendingDate = sendingDate;
	}

	public Date getReceivedDate() {
		return this.receivedDate;
	}

	public void setReceivedDate(Date receivedDate) {
		this.receivedDate = receivedDate;
	}

	public Long getLocalItemId() {
		return this.localItemId;
	}

	public void setLocalItemId(Long localItemId) {
		this.localItemId = localItemId;
	}

	public Long getRecipientStatusId() {
		return this.recipientStatusId;
	}

	public void setRecipientStatusId(Long recipientStatusId) {
		this.recipientStatusId = recipientStatusId;
	}

	public String getFaultCode() {
		return this.faultCode;
	}

	public void setFaultCode(String faultCode) {
		this.faultCode = faultCode;
	}

	public String getFaultActor() {
		return this.faultActor;
	}

	public void setFaultActor(String faultActor) {
		this.faultActor = faultActor;
	}

	public String getFaultString() {
		return this.faultString;
	}

	public void setFaultString(String faultString) {
		this.faultString = faultString;
	}

	public String getFaultDetail() {
		return this.faultDetail;
	}

	public void setFaultDetail(String faultDetail) {
		this.faultDetail = faultDetail;
	}

	public Long getStatusUpdateNeeded() {
		return this.statusUpdateNeeded;
	}

	public void setStatusUpdateNeeded(Long statusUpdateNeeded) {
		this.statusUpdateNeeded = statusUpdateNeeded;
	}

	public Clob getMetaxml() {
		return this.metaxml;
	}

	public void setMetaxml(Clob metaxml) {
		this.metaxml = metaxml;
	}

	public String getQueryId() {
		return this.queryId;
	}

	public void setQueryId(String queryId) {
		this.queryId = queryId;
	}

	public String getProxyOrgCode() {
		return this.proxyOrgCode;
	}

	public void setProxyOrgCode(String proxyOrgCode) {
		this.proxyOrgCode = proxyOrgCode;
	}

	public String getProxyOrgName() {
		return this.proxyOrgName;
	}

	public void setProxyOrgName(String proxyOrgName) {
		this.proxyOrgName = proxyOrgName;
	}

	public String getProxyPersonCode() {
		return this.proxyPersonCode;
	}

	public void setProxyPersonCode(String proxyPersonCode) {
		this.proxyPersonCode = proxyPersonCode;
	}

	public String getProxyName() {
		return this.proxyName;
	}

	public void setProxyName(String proxyName) {
		this.proxyName = proxyName;
	}

	public String getRecipientDepartmentNr() {
		return this.recipientDepartmentNr;
	}

	public void setRecipientDepartmentNr(String recipientDepartmentNr) {
		this.recipientDepartmentNr = recipientDepartmentNr;
	}

	public String getRecipientDepartmentName() {
		return this.recipientDepartmentName;
	}

	public void setRecipientDepartmentName(String recipientDepartmentName) {
		this.recipientDepartmentName = recipientDepartmentName;
	}

	public String getRecipientEmail() {
		return this.recipientEmail;
	}

	public void setRecipientEmail(String recipientEmail) {
		this.recipientEmail = recipientEmail;
	}

	public BigDecimal getRecipientDivisionId() {
		return this.recipientDivisionId;
	}

	public void setRecipientDivisionId(BigDecimal recipientDivisionId) {
		this.recipientDivisionId = recipientDivisionId;
	}

	public String getRecipientDivisionName() {
		return this.recipientDivisionName;
	}

	public void setRecipientDivisionName(String recipientDivisionName) {
		this.recipientDivisionName = recipientDivisionName;
	}

	public BigDecimal getRecipientPositionId() {
		return this.recipientPositionId;
	}

	public void setRecipientPositionId(BigDecimal recipientPositionId) {
		this.recipientPositionId = recipientPositionId;
	}

	public String getRecipientPositionName() {
		return this.recipientPositionName;
	}

	public void setRecipientPositionName(String recipientPositionName) {
		this.recipientPositionName = recipientPositionName;
	}

	@Override
	public String toString() {
		return Util.getDump(this);
	}

	public void printOutFields() {
		Field[] fields = getClass().getDeclaredFields();
		for (Field f : fields) {
			System.out.println("public final String " + f.getName() + " = \"" + f.getName() + "\";");
		}
	}

	public DvkType getType() {
		return DvkType.Message;
	}
}
