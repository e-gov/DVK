package dhl.iostructures;

import java.util.Iterator;

import javax.xml.rpc.handler.MessageContext;
import javax.xml.rpc.handler.soap.SOAPMessageContext;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPHeaderElement;

import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axiom.soap.SOAPHeaderBlock;
import org.apache.axis.Message;

import dvk.core.CommonMethods;
import dvk.core.CommonStructures;
import dvk.core.xroad.XRoadIdentifierType;
import dvk.core.xroad.XRoadObjectType;
import dvk.core.xroad.XRoadProtocolHeader;
import dvk.core.xroad.XRoadProtocolHeaderField;
import dvk.core.xroad.XRoadProtocolVersion;

/**
 * This class representation the X-Road protocol specific header section.
 * 
 */
public final class XHeader {
	
    public static final String XTEE_PREFIX = "xtee";
    public static final String XTEE_URI = "http://x-tee.riik.ee/xsd/xtee.xsd";

    // Fields common to both X-Road protocol version 2.0 and 4.0 (in version 4.0 English names are used)
    public String asutus;			// client in version 4.0
    public String andmekogu;		// subsystemCode in version 4.0
    public String id;				// id in version 4.0
    public String toimik;			// issue in version 4.0
    public String isikukood;		// userId in version 4.0
    
    // Fields specific to X-Road protocol version 2.0
    public String nimi;
    public String ametnik;		// deprecated; use "isikukood" instead
    
    // SOAP header container for X-Road protocol version 4.0
    public XRoadProtocolHeader xRoadHeader;

    /**
     * A constructor for X-Road protocol version 2.0
     * 
     * @param asutus
     * @param andmekogu
     * @param ametnik
     * @param id
     * @param nimi
     * @param toimik
     * @param isikukood
     */
    public XHeader(String asutus, String andmekogu, String ametnik, String id, String nimi, String toimik, String isikukood) {
        this.asutus = asutus;
        this.andmekogu = andmekogu;
        this.ametnik = ametnik;
        this.id = id;
        this.nimi = nimi;
        this.toimik = toimik;
        this.isikukood = isikukood;
    }
    
    /**
     * A constructor for X-Road protocol version 4.0
     * 
     * @param xRoadHeader
     */
    public XHeader(XRoadProtocolHeader xRoadHeader) {
    	this.xRoadHeader = xRoadHeader;
    	
    	// For backward compatibility
    	this.asutus = xRoadHeader.getxRoadClient().getMemberCode();
        this.andmekogu = xRoadHeader.getxRoadService().getSubsystemCode();
        this.ametnik = xRoadHeader.getUserId();
        this.id = xRoadHeader.getId();
        this.toimik = xRoadHeader.getIssue();
        this.isikukood = xRoadHeader.getUserId();
    }
    
    // Lisab käesoleva objekti andmed SOAP päisesse
    public SOAPEnvelope appendToSOAPHeader(SOAPEnvelope envelope, SOAPFactory factory, XRoadProtocolVersion xRoadProtocol) {
        try {
            if (xRoadProtocol != null && xRoadProtocol.equals(XRoadProtocolVersion.V4_0)) {
            	prepareXRoadProtocol_4_0_Header(envelope, factory);
            } else {
            	prepareXRoadProtocol_2_0_Header(envelope, factory);
            }
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
            @SuppressWarnings("rawtypes")
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
    
    private SOAPEnvelope prepareXRoadProtocol_2_0_Header(SOAPEnvelope envelope, SOAPFactory factory) {
    	// Deklareerime x-tee nimeruumi
    	OMNamespace nsXtee = factory.createOMNamespace(CommonStructures.NS_XTEE_URI, CommonStructures.NS_XTEE_PREFIX);
    	envelope.declareNamespace(nsXtee);
    	
    	// Lisame päise väljad
        SOAPHeaderBlock elAsutus = factory.createSOAPHeaderBlock("asutus", nsXtee);
        elAsutus.setText(asutus);
        SOAPHeaderBlock elAndmekogu = factory.createSOAPHeaderBlock("andmekogu", nsXtee);
        elAndmekogu.setText(andmekogu);
        SOAPHeaderBlock elAmetnik = factory.createSOAPHeaderBlock("ametnik", nsXtee);
        elAmetnik.setText(ametnik);
        SOAPHeaderBlock elID = factory.createSOAPHeaderBlock("id", nsXtee);
        elID.setText(id);
        SOAPHeaderBlock elNimi = factory.createSOAPHeaderBlock("nimi", nsXtee);
        elNimi.setText(nimi);
        SOAPHeaderBlock elToimik = factory.createSOAPHeaderBlock("toimik", nsXtee);
        elToimik.setText(toimik);
        SOAPHeaderBlock elIsikukood = factory.createSOAPHeaderBlock("isikukood", nsXtee);
        elIsikukood.setText(isikukood);
        
        envelope.getHeader().addChild(elAsutus);
        envelope.getHeader().addChild(elAndmekogu);
        envelope.getHeader().addChild(elAmetnik);
        envelope.getHeader().addChild(elID);
        envelope.getHeader().addChild(elNimi);
        envelope.getHeader().addChild(elToimik);
        envelope.getHeader().addChild(elIsikukood);
    	
    	return envelope;
    }
    
    private SOAPEnvelope prepareXRoadProtocol_4_0_Header(SOAPEnvelope envelope, SOAPFactory factory) {
    	OMNamespace nsXRoad = factory.createOMNamespace(CommonStructures.NS_XTEE_URI, CommonStructures.NS_XROAD_PREFIX);
    	OMNamespace nsId = factory.createOMNamespace(CommonStructures.NS_XROAD_IDENTIFIERS_URI, CommonStructures.NS_XROAD_IDENTIFIERS_PREFIX);
    	
        envelope.declareNamespace(nsXRoad);
        envelope.declareNamespace(nsId);
        
        
        // Populating client block
        SOAPHeaderBlock client = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.CLIENT.getValue(), nsXRoad);
        client.addAttribute("objectType", XRoadObjectType.SUBSYSTEM.getName(), nsId);
        
        OMElement clientXRoadInstance = factory.createOMElement(XRoadIdentifierType.XROAD_INSTANCE.getName(), nsId);
        clientXRoadInstance.setText(this.xRoadHeader.getxRoadClient().getxRoadInstance());
        OMElement clientMemberClass = factory.createOMElement(XRoadIdentifierType.MEMBER_CLASS.getName(), nsId);
        clientMemberClass.setText(this.xRoadHeader.getxRoadClient().getMemberClass());
        OMElement clientMemberCode = factory.createOMElement(XRoadIdentifierType.MEMBER_CODE.getName(), nsId);
        clientMemberCode.setText(this.xRoadHeader.getxRoadClient().getMemberCode());
        
        client.addChild(clientXRoadInstance);
        client.addChild(clientMemberClass);
        client.addChild(clientMemberCode);
        
        
        // Populating service block
        SOAPHeaderBlock service = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.SERVICE.getValue(), nsXRoad);
        service.addAttribute("objectType", XRoadObjectType.SUBSYSTEM.getName(), nsId);
        
        OMElement serviceXRoadInstance = factory.createOMElement(XRoadIdentifierType.XROAD_INSTANCE.getName(), nsId);
        serviceXRoadInstance.setText(this.xRoadHeader.getxRoadService().getxRoadInstance());
        OMElement serviceMemberClass = factory.createOMElement(XRoadIdentifierType.MEMBER_CLASS.getName(), nsId);
        serviceMemberClass.setText(this.xRoadHeader.getxRoadService().getMemberClass());
        OMElement serviceMemberCode = factory.createOMElement(XRoadIdentifierType.MEMBER_CODE.getName(), nsId);
        serviceMemberCode.setText(this.xRoadHeader.getxRoadService().getMemberCode());
        
        OMElement subsystemCode = factory.createOMElement(XRoadIdentifierType.SUBSYSTEM_CODE.getName(), nsId);
        subsystemCode.setText(this.xRoadHeader.getxRoadService().getSubsystemCode());
        OMElement serviceCode = factory.createOMElement(XRoadIdentifierType.SERVICE_CODE.getName(), nsId);
        serviceCode.setText(this.xRoadHeader.getxRoadService().getServiceCode());
        OMElement serviceVersion = factory.createOMElement(XRoadIdentifierType.SERVICE_VERSION.getName(), nsId);
        serviceVersion.setText(this.xRoadHeader.getxRoadService().getServiceVersion());
        
        service.addChild(serviceXRoadInstance);
        service.addChild(serviceMemberClass);
        service.addChild(serviceMemberCode);
        service.addChild(subsystemCode);
        service.addChild(serviceCode);
        service.addChild(serviceVersion);
        
        // Populating the remaining headers
        SOAPHeaderBlock userId = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.USER_ID.getValue(), nsXRoad);
        userId.setText(this.xRoadHeader.getUserId());
        SOAPHeaderBlock uniqueId = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.ID.getValue(), nsXRoad);
        uniqueId.setText(this.xRoadHeader.getId());
        SOAPHeaderBlock protocolVersion = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.PROTOCOL_VERSION.getValue(), nsXRoad);
        protocolVersion.setText(this.xRoadHeader.getProtocolVersion().getValue());
        SOAPHeaderBlock issue = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.ISSUE.getValue(), nsXRoad);
        issue.setText(this.xRoadHeader.getIssue());
        
        envelope.getHeader().addChild(client);
        envelope.getHeader().addChild(service);
        envelope.getHeader().addChild(userId);
        envelope.getHeader().addChild(uniqueId);
        envelope.getHeader().addChild(protocolVersion);
        
    	return envelope;
    }
    
}
