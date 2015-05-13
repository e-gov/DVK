package dvk.api.ml;

// Generated 4.02.2010 13:43:07 by Hibernate Tools 3.2.4.GA

import dvk.api.DVKAPI.DvkType;
import dvk.api.IMessage;
import dvk.api.IMessageRecipient;
import dvk.api.MessageRecipientCreateArgs;
import dvk.api.SelectCriteria;
import org.hibernate.Transaction;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * DhlCounter generated by hbm2java
 */
class DvkMessage extends DescendantsContainerFacade<PojoMessage> implements IMessage {
    private class CacheProxy extends CacheProxyBase<Long, DvkMessage, PojoMessage> {
        public CacheProxy(DvkSessionCacheBox cacheBox) {
            super(cacheBox);
        }

        public DvkMessage lookup(Object id, boolean allowCreateNew, Object... extraArgs) {
            if (id == null) {
                if (!allowCreateNew) {
                    throw new NullPointerException("Mandatory argument 'id' cannot be null");
                }

                return new DvkMessage(new PojoMessage(-1), cacheBox, true);
            }

            if (cache.containsKey(id)) {
                return cache.get(id);
            }

            Long idMessage = Util.getLong(id);

            PojoMessage pojo = (PojoMessage) cacheBox.getFromHibernateCache(PojoMessage.class, idMessage);

            if (pojo == null) {
                return null;
            }

            DvkMessage msg = new DvkMessage(pojo, cacheBox, false);

            cache.put(idMessage, msg);

            return msg;
        }

        @Override
        public String getIdFieldName() {
            return PojoMessage.FieldNames.dhlMessageId;
        }

        @Override
        protected String getPojoName() {
            return PojoMessage.PojoName;
        }

        @Override
        protected Long getPojoId(PojoMessage pojo) {
            return pojo.dhlMessageId;
        }

        @Override
        public SelectCriteria getSelectCriteria(boolean reset) {
            if (selectCriteria == null) {
                selectCriteria = new SelectCriteriaMessage();
                return selectCriteria;
            }

            return super.getSelectCriteria(reset);
        }
    }

    private PojoMessage pojo;
    private List<IMessageRecipient> pendingRecipients;

    DvkMessage(PojoMessage pojo, DvkSessionCacheBox cacheBox, boolean isNew) {
        super(cacheBox, isNew);

        this.pojo = pojo;
    }

    private DvkMessage() {
        // for service needs
        super(null, false);
    }

    @Override
    protected PojoMessage clonePojo() {
        PojoMessage clonedPojo = new PojoMessage();

        Util.copyValues(pojo, clonedPojo);

        return clonedPojo;
    }

    @Override
    PojoMessage getPojo() {
        return pojo;
    }

    public DvkType getType() {
        return DvkType.Message;
    }

    @Override
    Object getPojoId() {
        return pojo.dhlId;
    }

    @Override
    public void save(Transaction tx) {
        if (isNew()) {
            PojoMessage newPojo = (PojoMessage) createNewRecord(getType());
            pojo.setDhlMessageId(newPojo.getDhlMessageId());
            substituteInCache();
        }

        super.save(tx);
    }

    @Override
    public void destroy() {
        pojo = null;

        super.destroy();
    }

    @Override
    public String toString() {
        return String.format("DHL Message: dhlMessageId=%s\n\t%s", pojo.getDhlMessageId(), pojo.toString());
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this) {
            return true;
        }

        if (obj == null || !(obj instanceof DvkMessage)) {
            return false;
        }

        DvkMessage other = (DvkMessage) obj;

        return pojo.equals(other.pojo);
    }

    static ICacheProxy<DvkMessage> createCacheProxy(DvkSessionCacheBox cacheBox) {
        DvkMessage counter = new DvkMessage();
        return counter.new CacheProxy(cacheBox);
    }

    public long getDhlMessageId() {
        return pojo.dhlMessageId;
    }

    public boolean isIsIncoming() {
        return pojo.isIncoming;
    }

    public void setIsIncoming(boolean isIncoming) {
        if (!hasSameValue(pojo.isIncoming, isIncoming)) {
            pojo.isIncoming = isIncoming;
            setDirty(true);
        }
    }

    public String getData() {
        return pojo.data;
    }

    public void setData(String data) {
        if (!hasSameValue(pojo.data, data)) {
            pojo.data = data;
            setDirty(true);
        }
    }

    public String getTitle() {
        return pojo.title;
    }

    public void setTitle(String title) {
        if (!hasSameValue(pojo.title, title)) {
            pojo.title = title;
            setDirty(true);
        }
    }

    public String getSenderOrgCode() {
        return pojo.senderOrgCode;
    }

    public void setSenderOrgCode(String senderOrgCode) {
        if (!hasSameValue(pojo.senderOrgCode, senderOrgCode)) {
            pojo.senderOrgCode = senderOrgCode;
            setDirty(true);
        }
    }

    public String getSenderOrgName() {
        return pojo.senderOrgName;
    }

    public void setSenderOrgName(String senderOrgName) {
        if (!hasSameValue(pojo.senderOrgName, senderOrgName)) {
            pojo.senderOrgName = senderOrgName;
            setDirty(true);
        }
    }

    public String getSenderPersonCode() {
        return pojo.senderPersonCode;
    }

    public void setSenderPersonCode(String senderPersonCode) {
        if (!hasSameValue(pojo.senderPersonCode, senderPersonCode)) {
            pojo.senderPersonCode = senderPersonCode;
            setDirty(true);
        }
    }

    public String getSenderName() {
        return pojo.senderName;
    }

    public void setSenderName(String senderName) {
        if (!hasSameValue(pojo.senderName, senderName)) {
            pojo.senderName = senderName;
            setDirty(true);
        }
    }

    public String getRecipientOrgCode() {
        return pojo.recipientOrgCode;
    }

    public void setRecipientOrgCode(String recipientOrgCode) {
        if (!hasSameValue(pojo.recipientOrgCode, recipientOrgCode)) {
            pojo.recipientOrgCode = recipientOrgCode;
            setDirty(true);
        }
    }

    public String getRecipientOrgName() {
        return pojo.recipientOrgName;
    }

    public void setRecipientOrgName(String recipientOrgName) {
        if (!hasSameValue(pojo.recipientOrgName, recipientOrgName)) {
            pojo.recipientOrgName = recipientOrgName;
            setDirty(true);
        }
    }

    public String getRecipientPersonCode() {
        return pojo.recipientPersonCode;
    }

    public void setRecipientPersonCode(String recipientPersonCode) {
        if (!hasSameValue(pojo.recipientPersonCode, recipientPersonCode)) {
            pojo.recipientPersonCode = recipientPersonCode;
            setDirty(true);
        }
    }

    public String getRecipientName() {
        return pojo.recipientName;
    }

    public void setRecipientName(String recipientName) {
        if (!hasSameValue(pojo.recipientName, recipientName)) {
            pojo.recipientName = recipientName;
            setDirty(true);
        }
    }

    public String getCaseName() {
        return pojo.caseName;
    }

    public void setCaseName(String caseName) {
        if (!hasSameValue(pojo.caseName, caseName)) {
            pojo.caseName = caseName;
            setDirty(true);
        }
    }

    public String getDhlFolderName() {
        return pojo.dhlFolderName;
    }

    public void setDhlFolderName(String dhlFolderName) {
        if (!hasSameValue(pojo.dhlFolderName, dhlFolderName)) {
            pojo.dhlFolderName = dhlFolderName;
            setDirty(true);
        }
    }

    public long getSendingStatusId() {
        return pojo.sendingStatusId;
    }

    public void setSendingStatusId(long sendingStatusId) {
        if (!hasSameValue(pojo.sendingStatusId, sendingStatusId)) {
            pojo.sendingStatusId = sendingStatusId;
            setDirty(true);
        }
    }

    public long getUnitId() {
        return pojo.unitId;
    }

    public void setUnitId(long unitId) {
        if (!hasSameValue(pojo.unitId, unitId)) {
            pojo.unitId = unitId;
            setDirty(true);
        }
    }

    public Long getDhlId() {
        return pojo.dhlId;
    }

    public void setDhlId(Long dhlId) {
        if (!hasSameValue(pojo.dhlId, dhlId)) {
            pojo.dhlId = dhlId;
            setDirty(true);
        }
    }

    public Date getSendingDate() {
        return pojo.sendingDate;
    }

    public void setSendingDate(Date sendingDate) {
        if (!hasSameValue(pojo.sendingDate, sendingDate)) {
            pojo.sendingDate = sendingDate;
            setDirty(true);
        }
    }

    public Date getReceivedDate() {
        return pojo.receivedDate;
    }

    public void setReceivedDate(Date receivedDate) {
        if (!hasSameValue(pojo.receivedDate, receivedDate)) {
            pojo.receivedDate = receivedDate;
            setDirty(true);
        }
    }

    public Long getLocalItemId() {
        return pojo.localItemId;
    }

    public void setLocalItemId(Long localItemId) {
        if (!hasSameValue(pojo.localItemId, localItemId)) {
            pojo.localItemId = localItemId;
            setDirty(true);
        }
    }

    public Long getRecipientStatusId() {
        return pojo.recipientStatusId;
    }

    public void setRecipientStatusId(Long recipientStatusId) {
        if (!hasSameValue(pojo.recipientStatusId, recipientStatusId)) {
            pojo.recipientStatusId = recipientStatusId;
            setDirty(true);
        }
    }

    public String getFaultCode() {
        return pojo.faultCode;
    }

    public void setFaultCode(String faultCode) {
        if (!hasSameValue(pojo.faultCode, faultCode)) {
            pojo.faultCode = faultCode;
            setDirty(true);
        }
    }

    public String getFaultActor() {
        return pojo.faultActor;
    }

    public void setFaultActor(String faultActor) {
        if (!hasSameValue(pojo.faultActor, faultActor)) {
            pojo.faultActor = faultActor;
            setDirty(true);
        }
    }

    public String getFaultString() {
        return pojo.faultString;
    }

    public void setFaultString(String faultString) {
        if (!hasSameValue(pojo.faultString, faultString)) {
            pojo.faultString = faultString;
            setDirty(true);
        }
    }

    public String getFaultDetail() {
        return pojo.faultDetail;
    }

    public void setFaultDetail(String faultDetail) {
        if (!hasSameValue(pojo.faultDetail, faultDetail)) {
            pojo.faultDetail = faultDetail;
            setDirty(true);
        }
    }

    public Long getStatusUpdateNeeded() {
        return pojo.statusUpdateNeeded;
    }

    public void setStatusUpdateNeeded(Long statusUpdateNeeded) {
        if (!hasSameValue(pojo.statusUpdateNeeded, statusUpdateNeeded)) {
            pojo.statusUpdateNeeded = statusUpdateNeeded;
            setDirty(true);
        }
    }


    public String getMetaxml() {
        return pojo.metaxml;
    }

    public void setMetaxml(String metaxml) {
        if (!hasSameValue(pojo.metaxml, metaxml)) {
            pojo.metaxml = metaxml;
            setDirty(true);
        }
    }

    public String getQueryId() {
        return pojo.queryId;
    }

    public void setQueryId(String queryId) {
        if (!hasSameValue(pojo.queryId, queryId)) {
            pojo.queryId = queryId;
            setDirty(true);
        }
    }

    public String getProxyOrgCode() {
        return pojo.proxyOrgCode;
    }

    public void setProxyOrgCode(String proxyOrgCode) {
        if (!hasSameValue(pojo.proxyOrgCode, proxyOrgCode)) {
            pojo.proxyOrgCode = proxyOrgCode;
            setDirty(true);
        }
    }

    public String getDhlGuid() {
        return pojo.dhlGuid;
    }

    public void setDhlGuid(String guid) {
        if (!hasSameValue(pojo.dhlGuid, guid)) {
            pojo.dhlGuid = guid;
            setDirty(true);
        }
    }

    public String getProxyOrgName() {
        return pojo.proxyOrgName;
    }

    public void setProxyOrgName(String proxyOrgName) {
        if (!hasSameValue(pojo.proxyOrgName, proxyOrgName)) {
            pojo.proxyOrgName = proxyOrgName;
            setDirty(true);
        }
    }

    public String getProxyPersonCode() {
        return pojo.proxyPersonCode;
    }

    public void setProxyPersonCode(String proxyPersonCode) {
        if (!hasSameValue(pojo.proxyPersonCode, proxyPersonCode)) {
            pojo.proxyPersonCode = proxyPersonCode;
            setDirty(true);
        }
    }

    public String getProxyName() {
        return pojo.proxyName;
    }

    public void setProxyName(String proxyName) {
        if (!hasSameValue(pojo.proxyName, proxyName)) {
            pojo.proxyName = proxyName;
            setDirty(true);
        }
    }

    public String getRecipientDepartmentNr() {
        return pojo.recipientDepartmentNr;
    }

    public void setRecipientDepartmentNr(String recipientDepartmentNr) {
        if (!hasSameValue(pojo.recipientDepartmentNr, recipientDepartmentNr)) {
            pojo.recipientDepartmentNr = recipientDepartmentNr;
            setDirty(true);
        }
    }

    public String getRecipientDepartmentName() {
        return pojo.recipientDepartmentName;
    }

    public void setRecipientDepartmentName(String recipientDepartmentName) {
        if (!hasSameValue(pojo.recipientDepartmentName, recipientDepartmentName)) {
            pojo.recipientDepartmentName = recipientDepartmentName;
            setDirty(true);
        }
    }

    public String getRecipientEmail() {
        return pojo.recipientEmail;
    }

    public void setRecipientEmail(String recipientEmail) {
        if (!hasSameValue(pojo.recipientEmail, recipientEmail)) {
            pojo.recipientEmail = recipientEmail;
            setDirty(true);
        }
    }

    public BigDecimal getRecipientDivisionId() {
        return pojo.recipientDivisionId;
    }

    public void setRecipientDivisionId(BigDecimal recipientDivisionId) {
        if (!hasSameValue(pojo.recipientDivisionId, recipientDivisionId)) {
            pojo.recipientDivisionId = recipientDivisionId;
            setDirty(true);
        }
    }

    public String getRecipientDivisionName() {
        return pojo.recipientDivisionName;
    }

    public void setRecipientDivisionName(String recipientDivisionName) {
        if (!hasSameValue(pojo.recipientDivisionName, recipientDivisionName)) {
            pojo.recipientDivisionName = recipientDivisionName;
            setDirty(true);
        }
    }

    public BigDecimal getRecipientPositionId() {
        return pojo.recipientPositionId;
    }

    public void setRecipientPositionId(BigDecimal recipientPositionId) {
        if (!hasSameValue(pojo.recipientPositionId, recipientPositionId)) {
            pojo.recipientPositionId = recipientPositionId;
            setDirty(true);
        }
    }

    public String getRecipientPositionName() {
        return pojo.recipientPositionName;
    }

    public void setRecipientPositionName(String recipientPositionName) {
        if (!hasSameValue(pojo.recipientPositionName, recipientPositionName)) {
            pojo.recipientPositionName = recipientPositionName;
            setDirty(true);
        }
    }

    @Override
    protected boolean hasDirtyDescendants() {
        return !Util.isEmpty(pendingRecipients);
    }

    @Override
    void removePending(PojoFacade<PojoMessage> pojo) {
        switch (pojo.getType()) {
            case SettingsFolder:
                if (pendingRecipients == null || pendingRecipients.size() == 0) {
                    return;
                }
                pendingRecipients.remove(pojo);
                break;
        }
    }

    @Override
    void saveDescendants(Transaction tx) {
        if (!Util.isEmpty(pendingRecipients)) {
            for (IMessageRecipient mr : pendingRecipients) {
                DvkMessageRecipient recipient = (DvkMessageRecipient) mr;

                if (recipient.isDeleted()) {
                    continue;
                }

                long currMessageId = recipient.getDhlMessageId();

                try {
                    recipient.setDhlMessageId(pojo.dhlMessageId);
                    recipient.save(tx);
                } catch (RuntimeException e) {
                    // restore initial
                    recipient.setDhlMessageId(currMessageId);
                    throw e;
                }
            }
        }
    }

    public boolean addRecipient(IMessageRecipient recipient) {
        if (recipient.isPersistent() && hasSameValue(recipient.getDhlMessageId(), pojo.dhlMessageId)) {
            return false;
        }

        if (pendingRecipients == null) {
            pendingRecipients = new ArrayList<IMessageRecipient>();
        }

        if (!pendingRecipients.contains(recipient)) {
            DvkMessageRecipient mr = (DvkMessageRecipient) recipient;
            mr.setPendingState(this, PendingState.Add);
            pendingRecipients.add(recipient);

            return true;
        }

        return false;
    }

    public IMessageRecipient createMessageRecipient(MessageRecipientCreateArgs createArgs) {
        IMessageRecipient mr = getCacheBox().createMessageRecipient(createArgs);
        addRecipient(mr);

        return mr;
    }

    @SuppressWarnings("unchecked")
    @Override
    void deleteDescendants(Transaction tx) {
        // Message Recipients
        CacheProxyBase<BigDecimal, ?, ?> proxyBase = ((CacheProxyBase<BigDecimal, ?, ?>) getCacheBox().getCacheProxy(
                DvkType.MessageRecipient));

        SelectCriteria criteria = proxyBase.getSelectCriteria(true);
        criteria.setValue(PojoMessageRecipient.FieldNames.dhlMessageId, pojo.dhlMessageId);
        List<BigDecimal> idList = proxyBase.getExistingIdList(criteria);

        for (BigDecimal id : idList) {
            getCacheBox().delete(DvkType.MessageRecipient, id, tx);
        }
    }

    @Override
    void commitPendingChanges(State state) {
        commitPendingDescendants(pendingRecipients, state);
    }

}
