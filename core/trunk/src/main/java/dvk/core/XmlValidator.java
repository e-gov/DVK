package dvk.core;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;
import org.xml.sax.SAXException;
import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;
import org.xml.sax.SAXParseException;
import org.xml.sax.helpers.DefaultHandler;

public class XmlValidator extends DefaultHandler {
    private static final String JAXP_SCHEMA_LANGUAGE = "http://java.sun.com/xml/jaxp/properties/schemaLanguage";
    private static final String W3C_XML_SCHEMA = "http://www.w3.org/2001/XMLSchema";

    private ArrayList<String> m_errors;

    public XmlValidator() {
        m_errors = new ArrayList<String>();
    }

    public static ArrayList<String> Validate(String fileName) throws Exception {
        // Kontrollime, et valideerimiseks antud faili nimi ei oleks määramata
        // ja et etteantud fail üldse eksisteeriks
        if (CommonMethods.isNullOrEmpty(fileName)) {
            throw new Exception("DVK tarkvaraline viga: Valideeritava XML faili nimi on määramata!");
        }
        if (!(new File(fileName)).exists()) {
            throw new Exception("DVK tarkvaraline viga: Valideeritavat XML faili ei eksisteeri!");
        }

        DefaultHandler handler = new XmlValidator();

        // ParserFactory initsialiseerimine
        SAXParserFactory factory = SAXParserFactory.newInstance();
        factory.setNamespaceAware(true);
        factory.setValidating(true);

        // Parseri initsialiseerimine
        SAXParser saxParser = null;
        try {
            saxParser = factory.newSAXParser();
            saxParser.setProperty(JAXP_SCHEMA_LANGUAGE, W3C_XML_SCHEMA);
        } catch (ParserConfigurationException ex) {
             throw new Exception("DVK tarkvaraline viga: " + ex.getMessage());
        } catch (SAXNotSupportedException ex) {
            throw new Exception("DVK tarkvaraline viga: XML parser ei toeta JAXP 1.2 spetsifikatsiooni!");
        } catch (SAXNotRecognizedException ex) {
            throw new Exception("DVK tarkvaraline viga: XML parser ei toeta JAXP 1.2 spetsifikatsiooni!");
        } catch (SAXException ex) {
             throw new Exception("DVK tarkvaraline viga: " + ex.getMessage());
        }

        // XML parsimine
        try {
            saxParser.parse(new File(fileName), handler);
        } catch (SAXException ex) {
            ((XmlValidator) handler).m_errors.add(ex.getMessage());
        } catch (IOException ex) {
            throw new Exception("DVK tarkvaraline viga: " + ex.getMessage());
        }

        return ((XmlValidator) handler).m_errors;
    }

    @Override
	public void error(SAXParseException e) throws SAXParseException {
        // üritame vältida viitamata või vigaselt viidatud XSD failist
        // tingitud vigade sattumist vigade nimekirja.
        if (e.getMessage().indexOf("Cannot find the declaration of element") < 0) {
            m_errors.add(e.getMessage());
        }
    }
}
