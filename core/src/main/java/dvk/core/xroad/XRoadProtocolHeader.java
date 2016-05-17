package dvk.core.xroad;

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

/**
 * This class representation the X-Road protocol specific header section.
 * 
 */
public final class XRoadProtocolHeader {
	
	// X-Road protocol version 2.0
    public static final String XTEE_NS_PREFIX = "xtee";
    public static final String XTEE_NS_URI = "http://x-tee.riik.ee/xsd/xtee.xsd";
    
    // X-Road protocol version 4.0
    public static final String XROAD_NS_PREFIX = "xrd";
    public static final String XROAD_NS_URI = "http://x-road.eu/xsd/xroad.xsd";
    
    public static final String XROAD_NS_IDENTIFIERS_PREFIX = "id";
    public static final String XROAD_NS_IDENTIFIERS_URI = "http://x-road.eu/xsd/identifiers";

    // Fields specific to X-Road protocol version 2.0, 3.0 and 3.1
    private String consumer;	// "asutus" in the X-Road protocol version 2.0
    private String producer;	// "andmekogu" in the X-Road protocol version 2.0
    private String service;		// "nimi" in the X-Road protocol version 2.0
    
    @Deprecated
    public String official;		// "ametnik" in the X-Road protocol version 2.0
    
    // Fields specific to X-Road protocol version 4.0
    private XRoadClient xRoadClient;
	private XRoadService xRoadService;
	private XRoadProtocolVersion protocolVersion;
	
	// Common fields
    private String id;
    private String userId;
    private String issue;

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
    public XRoadProtocolHeader(String asutus, String andmekogu, String ametnik, String id, String nimi, String toimik, String isikukood) {
        this.consumer = asutus;
        this.producer = andmekogu;
        this.official = ametnik;
        this.id = id;
        this.service = nimi;
        this.issue = toimik;
        this.userId = isikukood;
        
        this.protocolVersion = XRoadProtocolVersion.V2_0;
    }
    
    /**
     * A constructor for X-Road protocol version 4.0
     * 
     * @param xRoadClient
     * @param xRoadService
     * @param id
     * @param userId
     * @param issue
     */
    public XRoadProtocolHeader(XRoadClient xRoadClient, XRoadService xRoadService, String id, String userId, String issue) {
    	this.xRoadClient = xRoadClient;
    	this.xRoadService = xRoadService;
    	this.id = id;
    	this.userId = userId;
    	this.issue = issue;
    	
    	this.protocolVersion = XRoadProtocolVersion.V4_0;
    }
    
    // Lisab käesoleva objekti andmed SOAP päisesse
    public SOAPEnvelope appendToSOAPHeader(SOAPEnvelope envelope, SOAPFactory factory) {
        try {
            if (protocolVersion.equals(XRoadProtocolVersion.V4_0)) {
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
            se.addNamespaceDeclaration(XTEE_NS_PREFIX, XTEE_NS_URI);

            SOAPHeader sh = se.getHeader();
            if (sh == null) {
                sh = se.addHeader();
            } else {
                sh.removeContents();
            }

            // create SOAP elements specifying prefix and URI
            SOAPElement sHelem1 = sh.addChildElement("asutus", XTEE_NS_PREFIX, XTEE_NS_URI);
            sHelem1.addTextNode(consumer);
            SOAPElement sHelem2 = sh.addChildElement("andmekogu", XTEE_NS_PREFIX, XTEE_NS_URI);
            sHelem2.addTextNode(producer);
            SOAPElement sHelem3 = sh.addChildElement("ametnik", XTEE_NS_PREFIX, XTEE_NS_URI);
            sHelem3.addTextNode(official);
            SOAPElement sHelem4 = sh.addChildElement("id", XTEE_NS_PREFIX, XTEE_NS_URI);
            sHelem4.addTextNode(id);
            SOAPElement sHelem5 = sh.addChildElement("nimi", XTEE_NS_PREFIX, XTEE_NS_URI);
            sHelem5.addTextNode(service);
            SOAPElement sHelem6 = sh.addChildElement("toimik", XTEE_NS_PREFIX, XTEE_NS_URI);
            sHelem6.addTextNode(issue);
            SOAPElement sHelem7 = sh.addChildElement("isikukood", XTEE_NS_PREFIX, XTEE_NS_URI);
            sHelem7.addTextNode(userId);

            return true;
        } catch (Exception ex) {
            CommonMethods.logError(ex, this.getClass().getName(), "appendToSOAPHeader");
            return false;
        }
    }

    /**
     * @deprecated Use {@link #getFromSOAPHeaderAxis(org.apache.axis.MessageContext)} instead.
     * 
     * @param context
     * @return
     */
    @Deprecated
    public static XRoadProtocolHeader getFromSOAPHeader(MessageContext context) {
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

            return new XRoadProtocolHeader(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood);
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.XHeader", "getFromSOAPHeader");
            return null;
        }
    }

    public static XRoadProtocolHeader getFromSOAPHeaderAxis(org.apache.axis.MessageContext context) {
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

            org.apache.axis.message.SOAPHeaderElement element = envelope.getHeaderByName(XTEE_NS_URI, "asutus");
            if (element != null) {
                asutus = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_NS_URI, "andmekogu");
            if (element != null) {
                andmekogu = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_NS_URI, "ametnik");
            if (element != null) {
                ametnik = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_NS_URI, "id");
            if (element != null) {
                id = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_NS_URI, "nimi");
            if (element != null) {
                nimi = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_NS_URI, "toimik");
            if (element != null) {
                toimik = element.getValue();
            }

            element = envelope.getHeaderByName(XTEE_NS_URI, "isikukood");
            if (element != null) {
                isikukood = element.getValue();
            }

            return new XRoadProtocolHeader(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood);
        } catch (Exception ex) {
            CommonMethods.logError(ex, "dhl.iostructures.XHeader", "getFromSOAPHeaderAxis");
            return null;
        }
    }
    
    private SOAPEnvelope prepareXRoadProtocol_2_0_Header(SOAPEnvelope envelope, SOAPFactory factory) {
    	// Deklareerime x-tee nimeruumi
    	OMNamespace nsXtee = factory.createOMNamespace(XTEE_NS_URI, XTEE_NS_PREFIX);
    	envelope.declareNamespace(nsXtee);
    	
    	// Lisame päise väljad
        SOAPHeaderBlock elAsutus = factory.createSOAPHeaderBlock("asutus", nsXtee);
        elAsutus.setText(consumer);
        SOAPHeaderBlock elAndmekogu = factory.createSOAPHeaderBlock("andmekogu", nsXtee);
        elAndmekogu.setText(producer);
        SOAPHeaderBlock elAmetnik = factory.createSOAPHeaderBlock("ametnik", nsXtee);
        elAmetnik.setText(official);
        SOAPHeaderBlock elID = factory.createSOAPHeaderBlock("id", nsXtee);
        elID.setText(id);
        SOAPHeaderBlock elNimi = factory.createSOAPHeaderBlock("nimi", nsXtee);
        elNimi.setText(service);
        SOAPHeaderBlock elToimik = factory.createSOAPHeaderBlock("toimik", nsXtee);
        elToimik.setText(issue);
        SOAPHeaderBlock elIsikukood = factory.createSOAPHeaderBlock("isikukood", nsXtee);
        elIsikukood.setText(userId);
        
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
		OMNamespace nsXRoad = factory.createOMNamespace(XROAD_NS_URI, XROAD_NS_PREFIX);
		OMNamespace nsId = factory.createOMNamespace(XROAD_NS_IDENTIFIERS_URI, XROAD_NS_IDENTIFIERS_PREFIX);

		envelope.declareNamespace(nsXRoad);
		envelope.declareNamespace(nsId);

		// Populating client block
		SOAPHeaderBlock clientHeaderBlock = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.CLIENT.getValue(), nsXRoad);
		clientHeaderBlock.addAttribute("objectType", XRoadObjectType.SUBSYSTEM.getName(), nsId);

		OMElement clientXRoadInstance = factory.createOMElement(XRoadIdentifierType.XROAD_INSTANCE.getName(), nsId);
		clientXRoadInstance.setText(xRoadClient.getxRoadInstance());
		OMElement clientMemberClass = factory.createOMElement(XRoadIdentifierType.MEMBER_CLASS.getName(), nsId);
		clientMemberClass.setText(xRoadClient.getMemberClass());
		OMElement clientMemberCode = factory.createOMElement(XRoadIdentifierType.MEMBER_CODE.getName(), nsId);
		clientMemberCode.setText(xRoadClient.getMemberCode());

		clientHeaderBlock.addChild(clientXRoadInstance);
		clientHeaderBlock.addChild(clientMemberClass);
		clientHeaderBlock.addChild(clientMemberCode);

		// Populating service block
		SOAPHeaderBlock serviceHeaderBlock = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.SERVICE.getValue(), nsXRoad);
		serviceHeaderBlock.addAttribute("objectType", XRoadObjectType.SUBSYSTEM.getName(), nsId);

		OMElement serviceXRoadInstance = factory.createOMElement(XRoadIdentifierType.XROAD_INSTANCE.getName(), nsId);
		serviceXRoadInstance.setText(xRoadService.getxRoadInstance());
		OMElement serviceMemberClass = factory.createOMElement(XRoadIdentifierType.MEMBER_CLASS.getName(), nsId);
		serviceMemberClass.setText(xRoadService.getMemberClass());
		OMElement serviceMemberCode = factory.createOMElement(XRoadIdentifierType.MEMBER_CODE.getName(), nsId);
		serviceMemberCode.setText(xRoadService.getMemberCode());

		OMElement subsystemCode = factory.createOMElement(XRoadIdentifierType.SUBSYSTEM_CODE.getName(), nsId);
		subsystemCode.setText(xRoadService.getSubsystemCode());
		OMElement serviceCode = factory.createOMElement(XRoadIdentifierType.SERVICE_CODE.getName(), nsId);
		serviceCode.setText(xRoadService.getServiceCode());
		OMElement serviceVersion = factory.createOMElement(XRoadIdentifierType.SERVICE_VERSION.getName(), nsId);
		serviceVersion.setText(xRoadService.getServiceVersion());

		serviceHeaderBlock.addChild(serviceXRoadInstance);
		serviceHeaderBlock.addChild(serviceMemberClass);
		serviceHeaderBlock.addChild(serviceMemberCode);
		serviceHeaderBlock.addChild(subsystemCode);
		serviceHeaderBlock.addChild(serviceCode);
		serviceHeaderBlock.addChild(serviceVersion);

		// Populating the remaining headers
		SOAPHeaderBlock uniqueIdHeader = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.ID.getValue(), nsXRoad);
		uniqueIdHeader.setText(id);
		SOAPHeaderBlock userIdHeader = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.USER_ID.getValue(), nsXRoad);
		userIdHeader.setText(userId);
		SOAPHeaderBlock issueHeader = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.ISSUE.getValue(), nsXRoad);
		issueHeader.setText(issue);
		SOAPHeaderBlock protocolVersionHeader = factory.createSOAPHeaderBlock(XRoadProtocolHeaderField.PROTOCOL_VERSION.getValue(), nsXRoad);
		protocolVersionHeader.setText(protocolVersion.getValue());

		envelope.getHeader().addChild(clientHeaderBlock);
		envelope.getHeader().addChild(serviceHeaderBlock);
		envelope.getHeader().addChild(uniqueIdHeader);
		envelope.getHeader().addChild(userIdHeader);
		envelope.getHeader().addChild(issueHeader);
		envelope.getHeader().addChild(protocolVersionHeader);

		return envelope;
	}
    
	public String getConsumer() {
		// This is for backward compatibility
		if (protocolVersion.equals(XRoadProtocolVersion.V4_0)) {
			return xRoadClient.getMemberCode();
		}
		
		return consumer;
	}

	/**
	 * Use <b>ONLY</b> for X-Road protocol versions 2.0, 3.X 
	 */
	public void setConsumer(String consumer) {
		this.consumer = consumer;
	}

	public String getProducer() {
		// This is for backward compatibility
		if (protocolVersion.equals(XRoadProtocolVersion.V4_0)) {
			return xRoadService.getSubsystemCode();
		}
		
		return producer;
	}

	/**
	 * Use <b>ONLY</b> for X-Road protocol versions 2.0, 3.X 
	 */
	public void setProducer(String producer) {
		this.producer = producer;
	}

	/**
	 * Use <b>ONLY</b> for X-Road protocol versions 2.0, 3.X 
	 */
	public String getService() {
		// This is for backward compatibility
		if (protocolVersion.equals(XRoadProtocolVersion.V4_0)) {
			return xRoadService.getServiceCode() + " " + xRoadService.getServiceVersion();
		}
		
		return service;
	}

	/**
	 * Use <b>ONLY</b> for X-Road protocol versions 2.0, 3.X 
	 */
	public void setService(String service) {
		this.service = service;
	}

	/**
	 * @deprecated Since X-Road security server v5.0 is not used, replaced by {@link #getUserId()}.
	 * 
	 * @return identity code of the official who uses the related service
	 */
	public String getOfficial() {
		if (official == null) {
			return userId;
		}
		
		return official;
	}

	/**
	 * @deprecated Since X-Road security server v5.0 is not used, replaced by {@link #setUserId()}.
	 * 
	 * @param official identity code of the official who uses the related service
	 */
	public void setOfficial(String official) {
		this.official = official;
	}

	public XRoadClient getXRoadClient() {
		return xRoadClient;
	}

	public void setXRoadClient(XRoadClient xRoadClient) {
		this.xRoadClient = xRoadClient;
	}

	public XRoadService getXRoadService() {
		return xRoadService;
	}

	public void setXRoadService(XRoadService xRoadService) {
		this.xRoadService = xRoadService;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIssue() {
		return issue;
	}

	public void setIssue(String issue) {
		this.issue = issue;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public XRoadProtocolVersion getProtocolVersion() {
		return protocolVersion;
	}

	public void setProtocolVersion(XRoadProtocolVersion protocolVersion) {
		this.protocolVersion = protocolVersion;
	}
    
}
