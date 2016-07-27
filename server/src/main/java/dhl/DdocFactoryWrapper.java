package dhl;

import java.util.ArrayList;

import org.apache.log4j.Logger;

import dhl.exceptions.ComponentException;
import ee.sk.digidoc.DigiDocException;
import ee.sk.digidoc.SignedDoc;
import ee.sk.digidoc.factory.DigiDocFactory;
import ee.sk.utils.ConfigManager;

/**
 * Created with IntelliJ IDEA.
 * User: Liza Leo
 * Date: 14.10.14
 * Time: 0:32
 */

public final class DdocFactoryWrapper {

    /**/
    private DdocFactoryWrapper() {
    }

    /**/
    private static Logger logger = Logger.getLogger(DdocFactoryWrapper.class.getName());

    /**
     * Catch DigiDocException on DigiDocFactory initialization
     *
     * @return DigiDocFactory instance
     * @throws ComponentException DigiDoc initialization fail
     */
    public static DigiDocFactory initializeDdocFactory() throws ComponentException {
        DigiDocFactory ddocFactory = null;
        try {
            ddocFactory = ConfigManager.instance().getDigiDocFactory();
        } catch (DigiDocException ex) {
            throw new ComponentException("DigiDoc teegi initsialiseerimine ebaõnnestus!", ex);
        }
        return ddocFactory;
    }

    /**
     * Wraps DigiDocFactory readSignedDoc(String param) method and catch exceptions like
     * DigiDocException.ERR_ISSUER_XMLNS,
     * DigiDocException.ERR_OLD_VER.
     * <p/>
     * fix for problem http://www.id.ee/?id=36510
     *
     * @param ddocFactory       DigiDocFactory instance
     * @param localFileFullName file name
     * @return ee.sk.digidoc.SignedDoc
     * @throws DigiDocException ee.sk.digidoc.DigiDocException
     */
    public static SignedDoc readSignedDoc(final DigiDocFactory ddocFactory, final String localFileFullName)
            throws DigiDocException {

        ArrayList<Integer> exceptionsToCatch = new ArrayList<Integer>();
        exceptionsToCatch.add(DigiDocException.ERR_ISSUER_XMLNS);
        exceptionsToCatch.add(DigiDocException.ERR_OLD_VER);

        SignedDoc container = null;
        try {
            container = ddocFactory.readSignedDoc(localFileFullName);
        } catch (DigiDocException ddocEx) {
            DigiDocException nestedDdocException = (DigiDocException) ddocEx.getNestedException();
            if (nestedDdocException != null && exceptionsToCatch.contains(nestedDdocException.getCode())) {
                logger.warn("Ignored DigiDocException: " + ddocEx.getMessage());
                logger.warn("Impossible to get DDOC or BDOC from localFileFullname: " + localFileFullName);
            } else {
                throw ddocEx;
            }
        }
        return container;
    }

}
