package dvk.api.ml;

import dvk.api.SelectCriteria;
import org.hibernate.HibernateException;
import org.hibernate.Transaction;

import java.util.Iterator;
import java.util.List;

public interface ICacheProxy<E> {
    E lookup(Object id, boolean allowCreateNew, Object... extraArgs);

    void destroy();

    void delete(Object id, Transaction tx, Object... extraArgs) throws HibernateException;

    void clearCache();

    List<? extends E> select(String query);

    List<? extends E> select(SelectCriteria criteria);

    String getDefaultQuery();

    void stateChanged(PojoFacade<?> facade);

    Iterator<E> elements();

    E lookupLocal(Object id);

    SelectCriteria getSelectCriteria(boolean reset);

    Object getOriginVersion(Object id);
}
