package dhl.exceptions;

public class IncorrectRequestVersionException extends Exception {
    private static final long serialVersionUID = 7268944453345177361L;

    public IncorrectRequestVersionException() {
        super();
    }

    public IncorrectRequestVersionException(String message) {
        super(message);
    }

    public IncorrectRequestVersionException(String message, Throwable cause) {
        super(message, cause);
    }

    public IncorrectRequestVersionException(Throwable cause) {
        super(cause);
    }
}
