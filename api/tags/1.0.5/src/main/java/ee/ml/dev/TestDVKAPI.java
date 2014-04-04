package ee.ml.dev;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import dvk.api.DVKAPI;

public class TestDVKAPI {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
	
		SessionFactory sessionFactory = DVKAPI.createSessionFactory("hibernate_ora_dvk.cfg.xml");
		
		
		Session session = sessionFactory.openSession();
		
		session.close();
		
		
	}

}
