package dhl.web.request;

import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;

import org.apache.axis.transport.http.HTTPConstants;

import edu.emory.mathcs.backport.java.util.Collections;

/**
 * <p>The purpose of this wrapper class is to provide SOAPAction HTTP header to Axis engine.</p>
 * 
 * The reason behind creating this class is that Axis 1 engine requires SOAPAction HTTP header to be present in an incoming request
 * in conformance with SOAP 1.1 specification, otherwise it will throw an {@link org.apache.axis.AxisFault AxisFault} exception.
 * But X-Road security server version 6 strips that header (and all other headers except for "Content-Type") from incoming requests.
 * 
 * @author Levan Kekelidze
 */
public class CustomHttpServletRequest extends HttpServletRequestWrapper {

	public CustomHttpServletRequest(HttpServletRequest request) {
		super(request);
	}
	
	@Override
	public String getHeader(String name) {
		String httpHeaderValue = null;

		if (name.equals(HTTPConstants.HEADER_SOAP_ACTION)) {
			httpHeaderValue = super.getHeader(HTTPConstants.HEADER_SOAP_ACTION);
			
			// If it was X-Road security server version 6 supply an empty value for SOAPAction header for Axis to be happy
			if (httpHeaderValue == null) {
				httpHeaderValue = "";
			}
		} else {
			httpHeaderValue = super.getHeader(name);
		}
		
		return httpHeaderValue;
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	public Enumeration getHeaderNames() {
		List<String> headerNames = new ArrayList<String>();
		headerNames.add(HTTPConstants.HEADER_SOAP_ACTION);
		
		@SuppressWarnings("unchecked")
		Enumeration<String> existingHeaderNames = ((HttpServletRequest) getRequest()).getHeaderNames();
		while (existingHeaderNames.hasMoreElements()) {
			headerNames.add(existingHeaderNames.nextElement());
		}
		
		return Collections.enumeration(headerNames);
	}

}
