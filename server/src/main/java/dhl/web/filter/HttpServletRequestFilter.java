package dhl.web.filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import dhl.web.request.CustomHttpServletRequest;

/**
 * <p>The purpose of this filter is to wrap an original HTTP request into the custom wrapper request object.
 * See {@link CustomHttpServletRequest} documentation for more details.</p>
 * 
 * @author Levan Kekelidze
 */
public class HttpServletRequestFilter implements Filter {

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest originalHttpRequest = (HttpServletRequest) request;
		CustomHttpServletRequest customHttpRequest = new CustomHttpServletRequest(originalHttpRequest);
		
		chain.doFilter(customHttpRequest, response);
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {}

}
