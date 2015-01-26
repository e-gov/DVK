package dvk.client.businesslayer;

public enum ResponseStatus {
    OK("OK"), NOK("NOK");
    private String status;

    ResponseStatus(String status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return status;
    }
}
