package dvk.api;

/**
 * @author User
 *         Delegate for work with a record from the table DHL_COUNTER
 */
public interface ICounter extends ICounterObserver, IDvkElement
{
	/*
	 * (non-Javadoc)
	 * @see dvk.api.IDvkElement#getOrigin()
	 */
	ICounterObserver getOrigin();
}
