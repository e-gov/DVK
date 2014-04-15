package dvk.client.businesslayer;

import java.util.Date;

public class ErrorLog {

    private Date errorDateTime;
    private String organizationCode;
    private String userCode;
    private String actionName;
    private String errorMessage;
    private int messageId;
    private Exception cause;
    private String additionalInformation;

    public ErrorLog() {
        this.errorDateTime = new Date();
    }

    public ErrorLog(String errorMessage, String actionName) {
        this.errorDateTime = new Date();
        this.errorMessage = errorMessage;
        this.actionName = actionName;
    }

    public ErrorLog(Exception cause, String actionName) {
        this.errorDateTime = new Date();
        this.cause = cause;
        this.actionName = actionName;
        if (cause != null) {
            this.errorMessage = cause.getMessage();
        } else {
            throw new IllegalArgumentException("Exception is null");
        }
    }

    public ErrorLog(String errorMessage) {
        this.errorDateTime = new Date();
        this.errorMessage = errorMessage;
    }

    public void setErrorDateTime(Date date) {
        this.errorDateTime = date;
    }

    public Date getErrorDateTime(){
        return this.errorDateTime;
    }

    public void setOrganizationCode(String organizationCode) {
        this.organizationCode = organizationCode;
    }

    public String getOrganizationCode() {
        return this.organizationCode;
    }

    public void setUserCode(String userCode) {
        this.userCode = userCode;
    }

    public String getUserCode() {
        return this.userCode;
    }

    public void setActionName(String actionName) {
        this.actionName = actionName;
    }

    public String getActionName() {
        return this.actionName;
    }

    public void setErrorMessage(String errorMessage) {
        this.errorMessage = errorMessage;
    }

    public String getErrorMessage() {
        return this.errorMessage;
    }

    public void setMessageId(int messageId){
            this.messageId = messageId;
    }

    public int getMessageId(){
        return this.messageId;
    }

    public Exception getCause() {
        return cause;
    }

    public void setCause(Exception cause) {
        this.cause = cause;
    }

    public String getAdditionalInformation() {
        return additionalInformation;
    }

    public void setAdditionalInformation(String additionalInformation) {
        this.additionalInformation = additionalInformation;
    }
}
