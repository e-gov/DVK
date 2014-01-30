package dvk.api.container.v2_1;

import org.exolab.castor.mapping.FieldHandler;
import org.exolab.castor.mapping.ValidityException;

import java.util.Date;

/**
 * @author Hendrik Pärna
 * @since 28.01.14
 */
public class RecordMetadataReplyDueDateHandler implements FieldHandler {

    private DvkDateHandler dateHandler = new DvkDateHandler("yyyy-MM-dd");;

    public RecordMetadataReplyDueDateHandler() {
        super();
    }

    @Override
    public Object getValue(Object parent) throws IllegalStateException {
        RecordMetadata recordMetadata = (RecordMetadata) parent;
        Date date = recordMetadata.getReplyDueDate();

        if (date != null) {
            return dateHandler.formatDateTime(date);
        }

        return null;
    }

    @Override
    public void setValue(Object parent, Object value) throws IllegalStateException, IllegalArgumentException {
        RecordMetadata recordMetadata = (RecordMetadata) parent;
        String date = (String) value;
        if (date != null) {
            recordMetadata.setReplyDueDate(dateHandler.parseDateTime(date));
        }
    }

    @Override
    public void resetValue(Object parent) throws IllegalStateException, IllegalArgumentException {
        RecordMetadata recordMetadata = (RecordMetadata) parent;
        recordMetadata.setReplyDueDate(null);
    }

    @Override
    @Deprecated
    public void checkValidity(Object o) throws ValidityException, IllegalStateException {
    }

    @Override
    public Object newInstance(Object o) throws IllegalStateException {
        return null;
    }
}
