package ee.ml.dev;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;

import dvk.api.DVKAPI;
import dvk.api.ml.PojoMessage;

/**
 * For testing API.
 */
public class TestDVKAPI {
    private static Logger logger = Logger.getLogger(TestDVKAPI.class);
    /**
     * Main.
     *
     * @param args args
     */
    public static void main(String[] args) {

        SessionFactory sessionFactory = DVKAPI.createSessionFactory("hibernate_ora_dvk.cfg.xml");

        PojoMessage result = null;
        Session session = null;
        try {
            session = sessionFactory.openSession();

            Query query = session.createQuery("from PojoMessage where id = (select max(id) from PojoMessage)");

            result = (PojoMessage) query.uniqueResult();
        } catch (Exception e) {
            logger.error("Exception while fetching DVK incoming messages: ", e);
        } finally {
            if (session != null) {
                session.close();
            }
        }

        logger.info("result: " + result);

    }

}
