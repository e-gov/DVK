package dhl.exceptions;

public class ComponentException extends Exception {
	private static final long serialVersionUID = 7836055066461064280L;

	public ComponentException() {
	    super();
	}

	public ComponentException(String message) {
	    super(message);
	}

	public ComponentException(String message, Throwable cause) {
	    super(message, cause);
	}

	public ComponentException(Throwable cause) {
	    super(cause);
	}
}
