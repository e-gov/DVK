package dhl.exceptions;

public class ContainerValidationException extends Exception {
    private static final long serialVersionUID = -4289650339130909576L;

    public ContainerValidationException() {
        super();
    }

    public ContainerValidationException(String message) {
        super(message);
    }

    public ContainerValidationException(String message, Throwable cause) {
        super(message, cause);
    }

    public ContainerValidationException(Throwable cause) {
        super(cause);
    }
}
