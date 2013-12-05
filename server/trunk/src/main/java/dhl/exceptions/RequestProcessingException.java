package dhl.exceptions;

public class RequestProcessingException extends Exception {
    private static final long serialVersionUID = -4075138324125098200L;

    public RequestProcessingException() {
        super();
    }

    public RequestProcessingException(String message) {
        super(message);
    }

    public RequestProcessingException(String message, Throwable cause) {
        super(message, cause);
    }

    public RequestProcessingException(Throwable cause) {
        super(cause);
    }
}
