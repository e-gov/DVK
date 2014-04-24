package dhl.exceptions;

public class ResponseProcessingException extends Exception {
    private static final long serialVersionUID = -3505175357330441758L;

    public ResponseProcessingException() {
        super();
    }

    public ResponseProcessingException(String message) {
        super(message);
    }

    public ResponseProcessingException(String message, Throwable cause) {
        super(message, cause);
    }

    public ResponseProcessingException(Throwable cause) {
        super(cause);
    }
}
