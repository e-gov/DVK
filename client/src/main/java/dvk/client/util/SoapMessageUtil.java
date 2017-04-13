package dvk.client.util;

import org.apache.axiom.om.OMAbstractFactory;
import org.apache.axiom.om.OMElement;
import org.apache.axiom.om.OMNamespace;
import org.apache.axiom.om.impl.llom.util.AXIOMUtil;
import org.apache.axiom.soap.SOAPEnvelope;
import org.apache.axiom.soap.SOAPFactory;
import org.apache.axiom.soap.SOAPHeader;

import dvk.client.iostructures.XHeader;
import dvk.core.CommonStructures;
import dvk.core.Settings;
import dvk.core.xroad.XRoadHeader;

public class SoapMessageUtil {

	public static String getMessageAsText(XHeader xTeeHeader, String soapMessageBody) throws Exception {
		StringBuilder sb = new StringBuilder();
		sb.append(
				"<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" "
						+ "xmlns:SOAP-ENC=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:"
						+ CommonStructures.NS_DHL_PREFIX + "=\"" + CommonStructures.NS_DHL_URI
						+ "\" xmlns:xtee=\"http://x-tee.riik.ee/xsd/xtee.xsd\" xmlns:adit=\"http://producers.ametlikud-dokumendid.xtee.riik.ee/producer/ametlikud-dokumendid\">");

		// X-Tee päis
		sb.append("<env:Header>");
		sb.append(xTeeHeader.getHeaders());
		sb.append("</env:Header>");

		// Keha
		sb.append("<env:Body>");
		sb.append(soapMessageBody);
		sb.append("</env:Body>");

		// Ümbriku lõpp
		sb.append("</env:Envelope>");

		return sb.toString();
	}
	
	/**
	 * Creates and populates a SOAP envelope ready for use in SOAP requests.<br>
	 * SOAP header block is populated with the related X-Road message protocol headers.<br>
	 * SOAP body is populated with previously specified data.<br>
	 * 
	 * @param xRoadHeader X-Road service producer namespace prefix
	 * @param soapMessageBody X-Road service producer namespace URI
	 * @return ready to use SOAP envelope
	 * @throws Exception if an error occurred while preparing SOAP message
	 */
	public static SOAPEnvelope getSOAPEnvelope(XRoadHeader xRoadHeader, String soapMessageBody) throws Exception {
		SOAPFactory soapFactory = OMAbstractFactory.getSOAP11Factory();
		
		SOAPEnvelope soapEnvelope = soapFactory.getDefaultEnvelope();
		soapEnvelope.declareNamespace(CommonStructures.NS_DHL_URI, CommonStructures.NS_DHL_PREFIX);

		xRoadHeader.prepareSOAPHeader(soapEnvelope, soapFactory);

		OMElement soapBodyContent = AXIOMUtil.stringToOM(soapMessageBody);
		soapEnvelope.getBody().addChild(soapBodyContent);

		return soapEnvelope;
	}
	
	public static SOAPEnvelope getSOAPEnvelopeForAdit(XRoadHeader xRoadHeader, String soapMessageBody) throws Exception {
		SOAPEnvelope soapEnvelope = getSOAPEnvelope(xRoadHeader, soapMessageBody);
		
		OMNamespace aditNamespace = soapEnvelope.declareNamespace(CommonStructures.NS_ADIT_URI, CommonStructures.NS_ADIT_PREFIX);
		
		SOAPHeader header = soapEnvelope.getHeader();
		header.addHeaderBlock("infosysteem", aditNamespace).setText(Settings.CLIENT_ADIT_INFORMATION_SYSTEM_NAME);

		return soapEnvelope;
	}
	
}
