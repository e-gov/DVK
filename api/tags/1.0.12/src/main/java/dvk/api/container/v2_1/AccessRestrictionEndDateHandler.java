package dvk.api.container.v2_1;

import org.exolab.castor.mapping.FieldHandler;
import org.exolab.castor.mapping.ValidityException;

import java.util.Date;

/**
 * @author Hendrik Pärna
 * @since 29.01.14
 */
public class AccessRestrictionEndDateHandler implements FieldHandler {

    private DvkDateHandler dateHandler = new DvkDateHandler("yyyy-MM-dd");;

    public AccessRestrictionEndDateHandler() {
        super();
    }

    @Override
    public Object getValue(Object parent) throws IllegalStateException {
        AccessRestriction accessRestriction = (AccessRestriction) parent;
        Date date = accessRestriction.getRestrictionEndDate();
        if (date != null) {
            return dateHandler.formatDateTime(date);
        }
        return null;
    }

    @Override
    public void setValue(Object parent, Object value) throws IllegalStateException, IllegalArgumentException {
        AccessRestriction accessRestriction = (AccessRestriction) parent;
        String date = (String) value;
        if (date != null) {
            accessRestriction.setRestrictionEndDate(dateHandler.parseDateTime(date));
        }
    }

    @Override
    public void resetValue(Object parent) throws IllegalStateException, IllegalArgumentException {
        AccessRestriction accessRestriction = (AccessRestriction) parent;
        accessRestriction.setRestrictionEndDate(null);
    }

    @Override
    public void checkValidity(Object o) throws ValidityException, IllegalStateException {
    }

    @Override
    public Object newInstance(Object o) throws IllegalStateException {
        return null;
    }
}