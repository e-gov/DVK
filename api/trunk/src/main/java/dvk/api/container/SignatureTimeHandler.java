package dvk.api.container;

import org.exolab.castor.mapping.FieldHandler;
import org.exolab.castor.mapping.ValidityException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * FieldHandler for SignatureInfo signatureTime field.
 **/
public class SignatureTimeHandler implements FieldHandler {
    private static final String FORMAT = "HH:mm:ss";

    /**
     * Creates a new SignatureTimeHandler instance.
     */
    public SignatureTimeHandler() {
        super();
    }

    /**
     * Returns the value of the field from the object.
     *
     * @param object
     *      The object
     * @return
     *      The value of the field
     * @throws IllegalStateException
     *      The Java object has changed and is no longer supported by
     *      this handler, or the handler is not compatible with the Java object
     */
    public Object getValue(Object object) throws IllegalStateException {
        SignatureInfo sigInfo = (SignatureInfo) object;
        Date value = (Date) sigInfo.getSignatureDate();
        if (value == null) {
            return null;
        }
        SimpleDateFormat formatter = new SimpleDateFormat(FORMAT);
        return formatter.format(value);
    }

    /**
     * Sets the value of the field on the object.
     *
     * @param object
     *      The object
     * @param value
     *      The new value
     * @throws IllegalStateException
     *      The Java object has changed and is no longer supported by
     *      this handler, or the handler is not compatible with the Java object
     * @throws IllegalArgumentException
     *      The value passed is not of a supported type
     */
    public void setValue(Object object, Object value) throws IllegalStateException, IllegalArgumentException {
        SimpleDateFormat formatter = new SimpleDateFormat(FORMAT);
        Date date = null;
        try {
            date = formatter.parse((String) value);
        } catch (ParseException px) {
            throw new IllegalArgumentException(px.getMessage());
        }
        ((SignatureInfo) object).setSignatureDate(date);
    }

    /**
     * Creates a new instance of the object described by this field.
     *
     * @param parent
     *      The object for which the field is created
     * @return
     *      A new instance of the field's value
     * @throws IllegalStateException
     *      This field is a simple type and cannot be instantiated
     */
    public Object newInstance(Object parent) throws IllegalStateException {
        // -- Since it's marked as a string...just return null,
        // -- it's not needed.
        return null;
    }

    /**
     * Sets the value of the field to a default value.
     *
     * Reference fields are set to null, primitive fields are set to their
     * default value, collection fields are emptied of all elements.
     *
     * @param object
     *      The object
     * @throws IllegalStateException
     *      The Java object has changed and is no longer supported by
     *      this handler, or the handler is not compatible with the Java object
     */
    public void resetValue(Object object) throws IllegalStateException, IllegalArgumentException {
        ((SignatureInfo) object).setSignatureDate(null);
    }

    /**
     * @deprecated No longer supported
     */
    public void checkValidity(Object object) throws ValidityException, IllegalStateException {
        // do nothing
    }
}