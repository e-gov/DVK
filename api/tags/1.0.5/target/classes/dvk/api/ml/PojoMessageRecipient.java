package dvk.api.ml;

// Generated 7.02.2010 22:22:31 by Hibernate Tools 3.2.4.GA

import java.lang.reflect.Field;
import java.math.BigDecimal;
import java.sql.Clob;
import java.util.Date;

import dvk.api.IMessageRecipientObserver;
import dvk.api.DVKAPI.DvkType;

/**
 * DhlMessageRecipient generated by hbm2java
 */
public class PojoMessageRecipient implements IMessageRecipientObserver, java.io.Serializable
{
	public static class FieldNames
	{
		public static final String id = "id";
		public static final String dhlMessageId = "dhlMessageId";
		public static final String recipientOrgCode = "recipientOrgCode";
		public static final String recipientPersonCode = "recipientPersonCode";
		public static final String recipientDivisionId = "recipientDivisionId";
		public static final String recipientPositionId = "recipientPositionId";
		public static final String recipientOrgName = "recipientOrgName";
		public static final String recipientName = "recipientName";
		public static final String sendingDate = "sendingDate";
		public static final String receivedDate = "receivedDate";
		public static final String sendingStatusId = "sendingStatusId";
		public static final String recipientStatusId = "recipientStatusId";
		public static final String faultCode = "faultCode";
		public static final String faultActor = "faultActor";
		public static final String faultString = "faultString";
		public static final String faultDetail = "faultDetail";
		public static final String metaxml = "metaxml";
		public static final String dhlId = "dhlId";
		public static final String queryId = "queryId";
		public static final String producerName = "producerName";
		public static final String serviceUrl = "serviceUrl";
		public static final String recipientDivisionName = "recipientDivisionName";
		public static final String recipientPositionName = "recipientPositionName";
	}

	/**
	 * 
	 */
	final static String PojoName = PojoMessageRecipient.class.getName();
	private static final long serialVersionUID = 6504791415331005492L;
	protected BigDecimal id;
	protected Long dhlMessageId;
	protected String recipientOrgCode;
	protected String recipientPersonCode;
	protected BigDecimal recipientDivisionId;
	protected BigDecimal recipientPositionId;
	protected String recipientOrgName;
	protected String recipientName;
	protected Date sendingDate;
	protected Date receivedDate;
	protected long sendingStatusId;
	protected Long recipientStatusId;
	protected String faultCode;
	protected String faultActor;
	protected String faultString;
	protected String faultDetail;
	protected Clob metaxml;
	protected BigDecimal dhlId;
	protected String queryId;
	protected String producerName;
	protected String serviceUrl;
	protected String recipientDivisionName;
	protected String recipientPositionName;

	public PojoMessageRecipient() {
	}

	public PojoMessageRecipient(BigDecimal id) {
		this.id = id;
	}

	public String getRecipientOrgName() {
		return this.recipientOrgName;
	}

	public void setRecipientOrgName(String recipientOrgName) {
		this.recipientOrgName = recipientOrgName;
	}

	public String getRecipientName() {
		return this.recipientName;
	}

	public void setRecipientName(String recipientName) {
		this.recipientName = recipientName;
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

	public long getSendingStatusId() {
		return this.sendingStatusId;
	}

	public void setSendingStatusId(long sendingStatusId) {
		this.sendingStatusId = sendingStatusId;
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

	public Clob getMetaxml() {
		return this.metaxml;
	}

	public void setMetaxml(Clob metaxml) {
		this.metaxml = metaxml;
	}

	public BigDecimal getDhlId() {
		return this.dhlId;
	}

	public void setDhlId(BigDecimal dhlId) {
		this.dhlId = dhlId;
	}

	public String getQueryId() {
		return this.queryId;
	}

	public void setQueryId(String queryId) {
		this.queryId = queryId;
	}

	public String getProducerName() {
		return this.producerName;
	}

	public void setProducerName(String producerName) {
		this.producerName = producerName;
	}

	public String getServiceUrl() {
		return this.serviceUrl;
	}

	public void setServiceUrl(String serviceUrl) {
		this.serviceUrl = serviceUrl;
	}

	public String getRecipientDivisionName() {
		return this.recipientDivisionName;
	}

	public void setRecipientDivisionName(String recipientDivisionName) {
		this.recipientDivisionName = recipientDivisionName;
	}

	public String getRecipientPositionName() {
		return this.recipientPositionName;
	}

	public void setRecipientPositionName(String recipientPositionName) {
		this.recipientPositionName = recipientPositionName;
	}

	public Long getDhlMessageId() {
		return dhlMessageId;
	}

	public void setDhlMessageId(Long dhlMessageId) {
		this.dhlMessageId = dhlMessageId;
	}

	public String getRecipientOrgCode() {
		return recipientOrgCode;
	}

	public void setRecipientOrgCode(String recipientOrgCode) {
		this.recipientOrgCode = recipientOrgCode;
	}

	public String getRecipientPersonCode() {
		return recipientPersonCode;
	}

	public void setRecipientPersonCode(String recipientPersonCode) {
		this.recipientPersonCode = recipientPersonCode;
	}

	public BigDecimal getRecipientDivisionId() {
		return recipientDivisionId;
	}

	public void setRecipientDivisionId(BigDecimal recipientDivisionId) {
		this.recipientDivisionId = recipientDivisionId;
	}

	public BigDecimal getRecipientPositionId() {
		return recipientPositionId;
	}

	public void setRecipientPositionId(BigDecimal recipientPositionId) {
		this.recipientPositionId = recipientPositionId;
	}

	public BigDecimal getId() {
		return id;
	}

	public void setId(BigDecimal id) {
		this.id = id;
	}

	public void printOutFields() {
		Field[] fields = getClass().getDeclaredFields();
		for (Field f : fields) {
			System.out.println("public final String " + f.getName() + " = \"" + f.getName() + "\";");
		}
	}

	@Override
	public String toString() {
		return Util.getDump(this);
	}

	public DvkType getType() {
		return DvkType.MessageRecipient;
	}
}
