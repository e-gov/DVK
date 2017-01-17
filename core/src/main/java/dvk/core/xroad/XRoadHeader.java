package dvk.core.xroad;

import java.util.Iterator;

import javax.xml.namespace.QName;
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
import org.apache.axis.AxisFault;
import org.apache.axis.Message;
import org.apache.axis.message.MessageElement;
import org.apache.axis.utils.StringUtils;

import dvk.core.CommonMethods;

/**
 * <p>This class representation the X-Road message protocol specific header section.</p>
 * 
 * NOTE:<br>
 * this class was made by merging the old existing functionality (which was left as is)
 * meant for handling X-Road message protocol version 2.0
 * and the new specific functionality required by X-Road message protocol version 4.0
 * 
 */
public final class XRoadHeader {

    // Fields specific to X-Road message protocol version 2.0, 3.0 and 3.1
    private String consumer;	// "asutus" in the X-Road message protocol version 2.0
    private String producer;	// "andmekogu" in the X-Road message protocol version 2.0
    private String service;		// "nimi" in the X-Road message protocol version 2.0
    
    @Deprecated
    public String official;		// "ametnik" in the X-Road message protocol version 2.0
    
    // Fields specific to X-Road message protocol version 4.0
    private XRoadClient xRoadClient;
	private XRoadService xRoadService;
	private XRoadMessageProtocolVersion messageProtocolVersion;
	
	// Common fields
    private String id;
    private String userId;
    private String issue;

    /**
     * A constructor for X-Road message protocol versions 2.0, 3.0, 3.1
     * 
     * @param asutus
     * @param andmekogu
     * @param ametnik
     * @param id
     * @param nimi
     * @param toimik
     * @param isikukood
     */
    public XRoadHeader(String asutus, String andmekogu, String ametnik, String id, String nimi, String toimik, String isikukood, XRoadMessageProtocolVersion xRoadMessageProtocolVersion) {
        this.consumer = asutus;
        this.producer = andmekogu;
        this.official = ametnik;
        this.id = id;
        this.service = nimi;
        this.issue = toimik;
        this.userId = isikukood;
        this.messageProtocolVersion = xRoadMessageProtocolVersion;
    }
    
    /**
     * A constructor for X-Road message protocol version 4.0
     * 
     * @param xRoadClient
     * @param xRoadService
     * @param id
     * @param userId
     * @param issue
     */
    public XRoadHeader(XRoadClient xRoadClient, XRoadService xRoadService, String id, String userId, String issue) {
    	this.xRoadClient = xRoadClient;
    	this.xRoadService = xRoadService;
    	this.id = id;
    	this.userId = userId;
    	this.issue = issue;
    	
    	this.messageProtocolVersion = XRoadMessageProtocolVersion.V4_0;
    }
    
    /**
     * Populates a SOAP header block with the related X-Road message protocol specific data.
     * 
     * @param envelope SOAPEnvelope for which to prepare X-Road message protocol related data
     * @param factory SOAP factory object to use for SOAP elements creation
     * @return SOAP envelope with filled SOAP header block
     * @throws Exception if unsupported X-Road message protocol version is used
     */
    public SOAPEnvelope prepareSOAPHeader(SOAPEnvelope envelope, SOAPFactory factory) throws Exception {
        if (messageProtocolVersion.equals(XRoadMessageProtocolVersion.V4_0)) {
        	prepareXRoadMessageProtocol_4_0_Header(envelope, factory);
        } else if (messageProtocolVersion.equals(XRoadMessageProtocolVersion.V2_0)) {
        	prepareXRoadMessageProtocol_2_0_Header(envelope, factory);
        } else {
        	throw new Exception("Unsupported X-Road message protocol version " + messageProtocolVersion.getValue());
        }
        
        return envelope;
    }

    /**
     * @deprecated Use {@link #prepareSOAPHeader(SOAPEnvelope, SOAPFactory)} instead
     * 
     * @param msg SOAP message
     * @return {@code true} if successfully appended the required elements or {@code false} if an error occurred
     */
    public boolean appendToSOAPHeader(org.apache.axis.Message msg) {
        try {
            // get SOAP envelope from SOAP message
            javax.xml.soap.SOAPEnvelope se = msg.getSOAPEnvelope();
            se.addNamespaceDeclaration(XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());

            SOAPHeader sh = se.getHeader();
            if (sh == null) {
                sh = se.addHeader();
            } else {
                sh.removeContents();
            }

            // create SOAP elements specifying prefix and URI
            SOAPElement sHelem1 = sh.addChildElement("asutus", XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());
            sHelem1.addTextNode(consumer);
            SOAPElement sHelem2 = sh.addChildElement("andmekogu",XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());
            sHelem2.addTextNode(producer);
            SOAPElement sHelem3 = sh.addChildElement("ametnik", XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());
            sHelem3.addTextNode(official);
            SOAPElement sHelem4 = sh.addChildElement("id", XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());
            sHelem4.addTextNode(id);
            SOAPElement sHelem5 = sh.addChildElement("nimi", XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());
            sHelem5.addTextNode(service);
            SOAPElement sHelem6 = sh.addChildElement("toimik", XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());
            sHelem6.addTextNode(issue);
            SOAPElement sHelem7 = sh.addChildElement("isikukood", XRoadMessageProtocolVersion.V2_0.getNamespacePrefix(), XRoadMessageProtocolVersion.V2_0.getNamespaceURI());
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
     * @param context message context
     * @return {@link XRoadHeader} object filled with data from the context or {@code null} if some error occurred 
     */
    @Deprecated
    public static XRoadHeader getFromSOAPHeader(MessageContext context) {
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

            return new XRoadHeader(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood, XRoadMessageProtocolVersion.V2_0);
        } catch (Exception ex) {
            CommonMethods.logError(ex, XRoadHeader.class.getCanonicalName(), "getFromSOAPHeader");
            
            return null;
        }
    }

    public static XRoadHeader getFromSOAPHeaderAxis(org.apache.axis.MessageContext context, String requiredMessageProtocolVersion) throws Exception {
    	XRoadHeader xRoadHeader = null;
    	
        try {
            Message message = context.getRequestMessage();
            org.apache.axis.message.SOAPEnvelope soapEnvelope = message.getSOAPEnvelope();
             
            org.apache.axis.message.SOAPHeaderElement xRoadProtocolVersion = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V4_0.getNamespaceURI(), XRoadHeaderField.PROTOCOL_VERSION.getValue());
	        if (requiredMessageProtocolVersion != null && (xRoadProtocolVersion == null || !xRoadProtocolVersion.getValue().equals(requiredMessageProtocolVersion))) {
	        	throw new Exception("X-Road message protocol version MUST be " + requiredMessageProtocolVersion);
	        }
	        
	        /*
	         *  IMPLEMENTATION NOTE
	         *  
	         *  Currently DVK supports two X-Road message protocol versions:
	         *  # version 2.0 (legacy)
	         *  # version 4.0 (latest version as of now)
	         *  
	         *  When new X-Road message protocol versions come add the required build logic.
	         *  
	         */
	        if (xRoadProtocolVersion != null) {
            	xRoadHeader = buildXRoadProtocol_v4_0_HeaderFromSoap(soapEnvelope);
            } else {
            	xRoadHeader = buildXRoadProtocol_v2_0_HeaderFromSoap(soapEnvelope);
            }
        } catch (Exception ex) {
            CommonMethods.logError(ex, XRoadHeader.class.getCanonicalName(), "getFromSOAPHeaderAxis");
            
            throw ex;
        }
        
        return xRoadHeader;
    }
    
    private SOAPEnvelope prepareXRoadMessageProtocol_2_0_Header(SOAPEnvelope envelope, SOAPFactory factory) {
    	// Deklareerime x-tee nimeruumi
    	OMNamespace nsXtee = factory.createOMNamespace(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), XRoadMessageProtocolVersion.V2_0.getNamespacePrefix());
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

	private SOAPEnvelope prepareXRoadMessageProtocol_4_0_Header(SOAPEnvelope soapEnvelope, SOAPFactory factory) {
		if (xRoadClient.isValid() && xRoadService.isValid()) {
			OMNamespace nsXRoad = factory.createOMNamespace(XRoadMessageProtocolVersion.V4_0.getNamespaceURI(), XRoadMessageProtocolVersion.V4_0.getNamespacePrefix());
			OMNamespace nsId = factory.createOMNamespace(XRoadIdentifier.NAMESPACE_URI, XRoadIdentifier.NAMESPACE_PREFIX);
	
			soapEnvelope.declareNamespace(nsXRoad);
			soapEnvelope.declareNamespace(nsId);
	
			org.apache.axiom.soap.SOAPHeader soapHeader = soapEnvelope.getHeader();
			
			// Populating client block
			SOAPHeaderBlock clientHeaderBlock = factory.createSOAPHeaderBlock(XRoadHeaderField.CLIENT.getValue(), nsXRoad);
			clientHeaderBlock.addAttribute(XRoadIdentifier.OBJECT_TYPE_ATTRIBUTE, XRoadObjectType.SUBSYSTEM.getName(), nsId);
	
			OMElement clientXRoadInstance = factory.createOMElement(XRoadIdentifierType.XROAD_INSTANCE.getName(), nsId);
			clientXRoadInstance.setText(xRoadClient.getXRoadInstance());
			clientHeaderBlock.addChild(clientXRoadInstance);
			
			OMElement clientMemberClass = factory.createOMElement(XRoadIdentifierType.MEMBER_CLASS.getName(), nsId);
			clientMemberClass.setText(xRoadClient.getMemberClass());
			clientHeaderBlock.addChild(clientMemberClass);
			
			OMElement clientMemberCode = factory.createOMElement(XRoadIdentifierType.MEMBER_CODE.getName(), nsId);
			clientMemberCode.setText(xRoadClient.getMemberCode());
			clientHeaderBlock.addChild(clientMemberCode);
			
			if (!StringUtils.isEmpty(xRoadClient.getSubsystemCode())) {
				OMElement clientSubsystemCode = factory.createOMElement(XRoadIdentifierType.SUBSYSTEM_CODE.getName(), nsId);
				clientSubsystemCode.setText(xRoadClient.getSubsystemCode());
				clientHeaderBlock.addChild(clientSubsystemCode);
			}
			
			soapHeader.addChild(clientHeaderBlock);
			
			
			// Populating service block
			SOAPHeaderBlock serviceHeaderBlock = factory.createSOAPHeaderBlock(XRoadHeaderField.SERVICE.getValue(), nsXRoad);
			serviceHeaderBlock.addAttribute(XRoadIdentifier.OBJECT_TYPE_ATTRIBUTE, XRoadObjectType.SERVICE.getName(), nsId);
	
			OMElement serviceXRoadInstance = factory.createOMElement(XRoadIdentifierType.XROAD_INSTANCE.getName(), nsId);
			serviceXRoadInstance.setText(xRoadService.getXRoadInstance());
			serviceHeaderBlock.addChild(serviceXRoadInstance);
			
			OMElement serviceMemberClass = factory.createOMElement(XRoadIdentifierType.MEMBER_CLASS.getName(), nsId);
			serviceMemberClass.setText(xRoadService.getMemberClass());
			serviceHeaderBlock.addChild(serviceMemberClass);
			
			OMElement serviceMemberCode = factory.createOMElement(XRoadIdentifierType.MEMBER_CODE.getName(), nsId);
			serviceMemberCode.setText(xRoadService.getMemberCode());
			serviceHeaderBlock.addChild(serviceMemberCode);
	
			OMElement serviceSubsystemCode = factory.createOMElement(XRoadIdentifierType.SUBSYSTEM_CODE.getName(), nsId);
			serviceSubsystemCode.setText(xRoadService.getSubsystemCode());
			serviceHeaderBlock.addChild(serviceSubsystemCode);
			
			OMElement serviceCode = factory.createOMElement(XRoadIdentifierType.SERVICE_CODE.getName(), nsId);
			serviceCode.setText(xRoadService.getServiceCode());
			serviceHeaderBlock.addChild(serviceCode);
			
			OMElement serviceVersion = factory.createOMElement(XRoadIdentifierType.SERVICE_VERSION.getName(), nsId);
			serviceVersion.setText(xRoadService.getServiceVersion());
			serviceHeaderBlock.addChild(serviceVersion);
	
			soapHeader.addChild(serviceHeaderBlock);
			
			
			// Populating the remaining headers
			SOAPHeaderBlock uniqueIdHeader = factory.createSOAPHeaderBlock(XRoadHeaderField.ID.getValue(), nsXRoad);
			uniqueIdHeader.setText(id);
			soapHeader.addChild(uniqueIdHeader);
			
			SOAPHeaderBlock userIdHeader = factory.createSOAPHeaderBlock(XRoadHeaderField.USER_ID.getValue(), nsXRoad);
			userIdHeader.setText(userId);
			soapHeader.addChild(userIdHeader);
			
			if (!StringUtils.isEmpty(getIssue())) {
				SOAPHeaderBlock issueHeader = factory.createSOAPHeaderBlock(XRoadHeaderField.ISSUE.getValue(), nsXRoad);
				issueHeader.setText(issue);
				soapHeader.addChild(issueHeader);
			}
			
			SOAPHeaderBlock protocolVersionHeader = factory.createSOAPHeaderBlock(XRoadHeaderField.PROTOCOL_VERSION.getValue(), nsXRoad);
			protocolVersionHeader.setText(messageProtocolVersion.getValue());
			soapHeader.addChild(protocolVersionHeader);
		}
		
		return soapEnvelope;
	}
	
	private static XRoadHeader buildXRoadProtocol_v2_0_HeaderFromSoap(org.apache.axis.message.SOAPEnvelope soapEnvelope) throws AxisFault {
		String asutus = "";
        String andmekogu = "";
        String ametnik = "";
        String id = "";
        String nimi = "";
        String toimik = "";
        String isikukood = "";
        
        org.apache.axis.message.SOAPHeaderElement element = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), "asutus");
        if (element != null) {
            asutus = element.getValue();
        }

        element = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), "andmekogu");
        if (element != null) {
            andmekogu = element.getValue();
        }

        element = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), "ametnik");
        if (element != null) {
            ametnik = element.getValue();
        }

        element = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), "id");
        if (element != null) {
            id = element.getValue();
        }

        element = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), "nimi");
        if (element != null) {
            nimi = element.getValue();
        }

        element = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), "toimik");
        if (element != null) {
            toimik = element.getValue();
        }

        element = soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V2_0.getNamespaceURI(), "isikukood");
        if (element != null) {
            isikukood = element.getValue();
        }

        return new XRoadHeader(asutus, andmekogu, ametnik, id, nimi, toimik, isikukood, XRoadMessageProtocolVersion.V2_0);
	}
    
	private static XRoadHeader buildXRoadProtocol_v4_0_HeaderFromSoap(org.apache.axis.message.SOAPEnvelope soapEnvelope) throws AxisFault {
		XRoadClient xRoadClient = new XRoadClient();
		XRoadService xRoadService = new XRoadService();
		String id = "";
		String userId = "";
		String issue = "";
		
		QName xRoadInstanceQNname = new QName(XRoadIdentifier.NAMESPACE_URI, XRoadIdentifierType.XROAD_INSTANCE.getName());
		QName memberClassQNname = new QName(XRoadIdentifier.NAMESPACE_URI, XRoadIdentifierType.MEMBER_CLASS.getName());
		QName memberCodeQNname = new QName(XRoadIdentifier.NAMESPACE_URI, XRoadIdentifierType.MEMBER_CODE.getName());

		QName subsystemCodeQNname = new QName(XRoadIdentifier.NAMESPACE_URI, XRoadIdentifierType.SUBSYSTEM_CODE.getName());
		QName serviceCodeQNname = new QName(XRoadIdentifier.NAMESPACE_URI, XRoadIdentifierType.SERVICE_CODE.getName());
		QName serviceVersionQNname = new QName(XRoadIdentifier.NAMESPACE_URI, XRoadIdentifierType.SERVICE_VERSION.getName());
		
		/***** Retrieving data from the CLIENT header block *****/
		org.apache.axis.message.SOAPHeaderElement clientHeaderBlock =
				soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V4_0.getNamespaceURI(), XRoadHeaderField.CLIENT.getValue());
		
		MessageElement clientXRoadInstanceElement = clientHeaderBlock.getChildElement(xRoadInstanceQNname);
		if (clientXRoadInstanceElement != null) {
			xRoadClient.setXRoadInstance(clientXRoadInstanceElement.getValue());
		}
		
		MessageElement clientMemberClassElement = clientHeaderBlock.getChildElement(memberClassQNname);
		if (clientMemberClassElement != null) {
			xRoadClient.setMemberClass(clientMemberClassElement.getValue());
		}
		
		MessageElement clientMemberCodeElement = clientHeaderBlock.getChildElement(memberCodeQNname);
		if (clientMemberCodeElement != null) {
			xRoadClient.setMemberCode(clientMemberCodeElement.getValue());
		}
		
		MessageElement clientSubsystemCodeElement = clientHeaderBlock.getChildElement(subsystemCodeQNname);
		if (clientSubsystemCodeElement != null) {
			xRoadClient.setSubsystemCode(clientSubsystemCodeElement.getValue());
		}
		/***** end of retrieving data from the CLIENT header block *****/
		
		
		/***** Retrieving data from the SERVICE header block *****/
		org.apache.axis.message.SOAPHeaderElement serviceHeaderBlock =
				soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V4_0.getNamespaceURI(), XRoadHeaderField.SERVICE.getValue());
		
		MessageElement serviceXRoadInstanceElement = serviceHeaderBlock.getChildElement(xRoadInstanceQNname);
		if (serviceXRoadInstanceElement != null) {
			xRoadService.setXRoadInstance(serviceXRoadInstanceElement.getValue());
		}
		
		MessageElement serviceMemberClassElement = serviceHeaderBlock.getChildElement(memberClassQNname);
		if (serviceMemberClassElement != null) {
			xRoadService.setMemberClass(serviceMemberClassElement.getValue());
		}
		
		MessageElement serviceMemberCodeElement = serviceHeaderBlock.getChildElement(memberCodeQNname);
		if (serviceMemberCodeElement != null) {
			xRoadService.setMemberCode(serviceMemberCodeElement.getValue());
		}
		
		MessageElement serviceSubsystemCodeElement = serviceHeaderBlock.getChildElement(subsystemCodeQNname);
		if (serviceSubsystemCodeElement != null) {
			xRoadService.setSubsystemCode(serviceSubsystemCodeElement.getValue());
		}
		
		MessageElement serviceCodeElement = serviceHeaderBlock.getChildElement(serviceCodeQNname);
		if (serviceCodeElement != null) {
			xRoadService.setServiceCode(serviceCodeElement.getValue());
		}
		
		MessageElement serviceVersionElement = serviceHeaderBlock.getChildElement(serviceVersionQNname);
		if (serviceVersionElement != null) {
			xRoadService.setServiceVersion(serviceVersionElement.getValue());
		}
		/***** end of retrieving data from the SERVICE header block *****/
		
		
		org.apache.axis.message.SOAPHeaderElement idHeaderElement =
				soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V4_0.getNamespaceURI(), XRoadHeaderField.ID.getValue());
		if (idHeaderElement != null) {
			id = idHeaderElement.getValue();
		}
		
		org.apache.axis.message.SOAPHeaderElement userIdHeaderElement =
				soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V4_0.getNamespaceURI(), XRoadHeaderField.USER_ID.getValue());
		if (userIdHeaderElement != null) {
			userId = userIdHeaderElement.getValue();
		}
		
		org.apache.axis.message.SOAPHeaderElement issueHeaderElement =
				soapEnvelope.getHeaderByName(XRoadMessageProtocolVersion.V4_0.getNamespaceURI(), XRoadHeaderField.ISSUE.getValue());
		if (issueHeaderElement != null) {
			issue = issueHeaderElement.getValue();
		}
		
		return new XRoadHeader(xRoadClient, xRoadService, id, userId, issue);
	}
	
	public String getConsumer() {
		// This is for backward compatibility
		if (messageProtocolVersion.equals(XRoadMessageProtocolVersion.V4_0)) {
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
		if (messageProtocolVersion.equals(XRoadMessageProtocolVersion.V4_0)) {
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
		if (messageProtocolVersion.equals(XRoadMessageProtocolVersion.V4_0)) {
			StringBuilder sb = new StringBuilder();
			
			if (!StringUtils.isEmpty(xRoadService.getSubsystemCode())) {
				sb.append(xRoadService.getSubsystemCode()).append(".");
			}
			
			sb.append(xRoadService.getServiceCode());
			
			if (!StringUtils.isEmpty(xRoadService.getServiceVersion())) {
				sb.append(".").append(xRoadService.getServiceVersion());
			} else {
				sb.append(".v1");
			}
			
			return sb.toString();
		}
		
		return service;
	}

	/**
	 * Use <b>ONLY</b> for X-Road message protocol versions 2.0, 3.X 
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

	public XRoadMessageProtocolVersion getMessageProtocolVersion() {
		return messageProtocolVersion;
	}

	public void setMessageProtocolVersion(XRoadMessageProtocolVersion messageProtocolVersion) {
		this.messageProtocolVersion = messageProtocolVersion;
	}
    
}
