package dhl.exceptions;

public class IncorrectSignatureException extends Exception {
	private static final long serialVersionUID = -4204465232556712533L;
	
	public IncorrectSignatureException() {
	    super();
	}

	public IncorrectSignatureException(String message) {
	    super(message);
	}

	public IncorrectSignatureException(String message, Throwable cause) {
	    super(message, cause);
	}

	public IncorrectSignatureException(Throwable cause) {
	    super(cause);
	}
}
