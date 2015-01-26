package dvk.client.businesslayer;

import java.util.Date;

public class RequestLog {
    private Date requestDateTime;
    private String organizationCode;
    private String userCode;
    private String requestName;
    private String response;

    private int errorLogId;

    public RequestLog() {
        this.requestDateTime = new Date();
    }

    public RequestLog(String requestName, String organizationCode, String userCode) {
        this.requestDateTime = new Date();
        this.requestName = requestName;
        this.organizationCode = organizationCode;
        this.userCode = userCode;
        this.errorLogId = 0;
    }

    public void setRequestDateTime(Date requestDateTime) {
        this.requestDateTime = requestDateTime;
    }

    public Date getRequestDateTime(){
        return this.requestDateTime;
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

    public void setRequestName(String requestName) {
        this.requestName = requestName;
    }

    public String getRequestName() {
        return this.requestName;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public String getResponse() {
        return this.response;
    }

    public void setErrorLogId(int errorLogId) {
        this.errorLogId = errorLogId;
    }

    public int getErrorLogId() {
        return this.errorLogId;
    }
}
