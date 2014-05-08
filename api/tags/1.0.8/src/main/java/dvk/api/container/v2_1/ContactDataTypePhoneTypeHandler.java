package dvk.api.container.v2_1;

import org.exolab.castor.mapping.FieldHandler;
import org.exolab.castor.mapping.ValidityException;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * @author Hendrik Pärna
 * @since 28.01.14
 */
public class ContactDataTypePhoneTypeHandler implements FieldHandler {

    private static final String patternRegex = "([0-9])*|[+]([0-9])*";
    private Pattern pattern;

    public ContactDataTypePhoneTypeHandler() {
        super();
        pattern = Pattern.compile(patternRegex);
    }

    @Override
    public Object getValue(Object o) throws IllegalStateException {
        ContactDataType contactDataType = (ContactDataType) o;
        String phoneNumber = contactDataType.getPhone();
        if (phoneNumber != null) {
            checkIfPhoneNumberIsValid(phoneNumber);
        }
        return phoneNumber;
    }

    @Override
    public void setValue(Object parent, Object value) throws IllegalStateException, IllegalArgumentException {
        ContactDataType contactData = (ContactDataType) parent;
        String phoneNumber = (String) value;
        checkIfPhoneNumberIsValid(phoneNumber);
        contactData.setPhone(phoneNumber);
    }

    @Override
    public void resetValue(Object parent) throws IllegalStateException, IllegalArgumentException {
        ContactDataType contactData = (ContactDataType) parent;
        contactData.setPhone(null);
    }

    @Override
    @Deprecated
    public void checkValidity(Object parent) throws ValidityException, IllegalStateException {
    }

    private void checkIfPhoneNumberIsValid(String phoneNumber) {
        Matcher matcher = pattern.matcher(phoneNumber);
        if (!matcher.matches()) {
           throw new IllegalArgumentException("Illegal phone number input");
        }
    }

    @Override
    public Object newInstance(Object o) throws IllegalStateException {
        // not used
        return null;
    }
}
