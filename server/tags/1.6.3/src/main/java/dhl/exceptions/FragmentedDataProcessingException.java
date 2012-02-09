package dhl.exceptions;

public class FragmentedDataProcessingException extends Exception {
	private static final long serialVersionUID = -7036989158526879014L;

	public FragmentedDataProcessingException() {
	    super();
	}

	public FragmentedDataProcessingException(String message) {
	    super(message);
	}

	public FragmentedDataProcessingException(String message, Throwable cause) {
	    super(message, cause);
	}

	public FragmentedDataProcessingException(Throwable cause) {
	    super(cause);
	}
}
