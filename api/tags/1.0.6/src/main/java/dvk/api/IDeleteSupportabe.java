package dvk.api;

import org.hibernate.HibernateException;

/**
 * @author User
 *         Interface for DVK entries which intend to provide delete facility.
 */
public interface IDeleteSupportabe
{
	/**
	 * Deletes the entry from the data storage.
	 * 
	 * @throws HibernateException
	 */
	void delete() throws HibernateException;
}
