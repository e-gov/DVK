package dhl.iostructures;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;

import java.util.Iterator;
import javax.xml.rpc.handler.MessageContext;
import javax.xml.rpc.handler.soap.SOAPMessageContext;
import javax.xml.soap.*;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axis.Message;

// X-Tee päise representatsioon koodi tasemel
public final class XHeader {
    public static String XTEE_PREFIX = "xtee";
    public static String XTEE_URI = "http://x-tee.riik.ee/xsd/xtee.xsd";

    public final String asutus;
    public final String andmekogu;
    public final String ametnik;
    public final String id;
    public final String nimi;
    public final String toimik;
    public final String isikukood;

    public XHeader(String asutus, String andmekogu, String ametnik, String id, String nimi, String toimik, String isikukood) {
        this.asutus = asutus;
        this.andmekogu = andmekogu;
        this.ametnik = ametnik;
        this.id = id;
        this.nimi = nimi;
        this.toimik = toimik;
        this.isikukood = isikukood;
    }

    // Lisab käesoleva objekti andmed SOAP päisesse
    public SOAPEnvelope appendToSOAPHeader(SOAPEnvelope envelope, SOAPFactory factory) {
        try {
            // Deklareerime x-tee nimeruumi
            OMNamespace nsXtee = factory.createOMNamespace(CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            envelope.declareNamespace(nsXtee);

            // Lisame päise väljad
            OMElement elAsutus = factory.createOMElement("asutus", CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            elAsutus.setText(asutus);
            OMElement elAndmekogu = factory.createOMElement("andmekogu", CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            elAndmekogu.setText(andmekogu);
            OMElement elAmetnik = factory.createOMElement("ametnik", CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            elAmetnik.setText(ametnik);
            OMElement elID = factory.createOMElement("id", CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            elID.setText(id);
            OMElement elNimi = factory.createOMElement("nimi", CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            elNimi.setText(nimi);
            OMElement elToimik = factory.createOMElement("toimik", CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            elToimik.setText(toimik);
            OMElement elIsikukood = factory.createOMElement("isikukood", CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
            elIsikukood.setText(isikukood);
            envelope.getHeader().addChild(elAsutus);
            envelope.getHeader().addChild(elAndmekogu);
            envelope.getHeader().addChild(elAmetnik);
            envelope.getHeader().addChild(elID);
            envelope.getHeader().addChild(elNimi);
            envelope.getHeader().addChild(elToimik);
            envelope.getHeader().addChild(elIsikukood);
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "appendToSOAPHeader");
        }
        return envelope;
    }

    // Lisab käesoleva objekti andmed SOAP päisesse
    public boolean appendToSOAPHeader(org.apache.axis.Message msg) {
        try {
            // get SOAP envelope from SOAP message
            javax.xml.soap.SOAPEnvelope se = msg.getSOAPEnvelope();
            se.addNamespaceDeclaration(XTEE_PREFIX, XTEE_URI);

            SOAPHeader sh = se.getHeader();
            if (sh == null) {
                sh = se.addHeader();
            } else {
                sh.removeContents();
            }

            // create SOAP elements specifying prefix and URI
            SOAPElement sHelem1 = sh.addChildElement("asutus", XTEE_PREFIX, XTEE_URI);
            sHelem1.addTextNode(asutus);
            SOAPElement sHelem2 = sh.addChildElement("andmekogu", XTEE_PREFIX, XTEE_URI);
            sHelem2.addTextNode(andmekogu);
            SOAPElement sHelem3 = sh.addChildElement("ametnik", XTEE_PREFIX, XTEE_URI);
            sHelem3.addTextNode(ametnik);
            SOAPElement sHelem4 = sh.addChildElement("id", XTEE_PREFIX, XTEE_URI);
            sHelem4.addTextNode(id);
            SOAPElement sHelem5 = sh.addChildElement("nimi", XTEE_PREFIX, XTEE_URI);
            sHelem5.addTextNode(nimi);
            SOAPElement sHelem6 = sh.addChildElement("toimik", XTEE_PREFIX, XTEE_URI);
            sHelem6.addTextNode(toimik);
            SOAPElement sHelem7 = sh.addChildElement("isikukood", XTEE_PREFIX, XTEE_URI);
            sHelem7.addTextNode(isikukood);

            return true;
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "appendToSOAPHeader");
            return false;
        }
    }

    public static XHeader getFromSOAPHeader(MessageContext context) {
        try {
            String asutus = "";
            String andmekogu = "";
            String ametnik = "";
            String id = "";
            String nimi = "";
            String toimik = "";
            String isikukood = "";

            SOAPMessageContext smc = (SOAPMessageContext) context;
            SOAPHeader header = smc.getMessage().getSOAPPart().getEnvelope().getHeader();
            Iterator headers = header.extractAllHeaderElements();

            String headerName = "";
            while (headers.hasNext()) {
                SOAPHeaderElement he = (SOAPHeaderElement) headers.next();
                headerName = he.getElementName().getLocalName();

                if (headerName.equalsIgnoreCase("asutus")) {
                    asutus = he.getValue();
                } else if (headerName.equalsIgnoreCase("andmekogu")) {
                    andmekogu = he.getValue();
                } else if (headerName.equalsIgnoreCase("ametnik")) {
                    ametnik = he.getValue();
                } else if (headerName.equalsIgnoreCase("id")) {
                    id = he.getValue();
                } else if (headerName.equalsIgnoreCase("nimi")) {
                    nimi = he.getValue();
                } else if (headerName.equalsIgnoreCase("toimik")) {
                    toimik = he.getValue();
                } else if (headerName.equalsIgnoreCase("isikukood")) {
                    isikukood = he.getValue();
                }
            }

            return new XHeader(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood);
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.XHeader", "getFromSOAPHeader");
            return null;
        }
    }

    public static XHeader getFromSOAPHeaderAxis(org.apache.axis.MessageContext context) {
        try {
            String asutus = "";
            String andmekogu = "";
            String ametnik = "";
            String id = "";
            String nimi = "";
            String toimik = "";
            String isikukood = "";

            Message message = context.getRequestMessage();
            org.apache.axis.message.SOAPEnvelope envelope = message.getSOAPEnvelope();

            org.apache.axis.message.SOAPHeaderElement element = envelope.getHeaderByName(XTEE_URI, "asutus");
            if (element != null) {
                asutus = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_URI, "andmekogu");
            if (element != null) {
                andmekogu = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_URI, "ametnik");
            if (element != null) {
                ametnik = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_URI, "id");
            if (element != null) {
                id = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_URI, "nimi");
            if (element != null) {
                nimi = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_URI, "toimik");
            if (element != null) {
                toimik = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_URI, "isikukood");
            if (element != null) {
                isikukood = element.getValue();
            }

            return new XHeader(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood);
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.XHeader", "getFromSOAPHeaderAxis");
            return null;
        }
    }
}
