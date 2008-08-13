package car.pool.user.authentication.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.verisign.joid.OpenIdException;
import org.verisign.joid.consumer.OpenIdFilter;
import org.verisign.joid.util.UrlUtils;


/**
 * Servlet implementation class for Servlet: OpenIdConsumer
 *
 */
 public class OpenIdConsumer extends javax.servlet.http.HttpServlet implements javax.servlet.Servlet {
   static final long serialVersionUID = 1L;
/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public OpenIdConsumer() {
		super();
	}   	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(request.getParameter("signin") != null) {
			try {
				HttpSession session = request.getSession();
				if(session.isNew() != true) {
					//session.invalidate();
					//HttpSession nsession = request.getSession(true);
					
				}
				StringBuffer returnTo = new StringBuffer(UrlUtils.getBaseUrl(request));
				//returnTo.append(request.getServletPath());
				
				String id = request.getParameter("openid_url");
				if (!id.startsWith("http:")) {
					id = "http://" + id;
				}
				String trustRoot = UrlUtils.getBaseUrl(request);
				String s = OpenIdFilter.joid().getAuthUrl(id, returnTo.toString(), trustRoot);
				response.sendRedirect(s);
			} catch (OpenIdException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				printLoginPage(request, response, false);
			}
			
		} else {
			String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
			if( loggedInAs == null  && request.getParameter(OpenIdFilter.OPENID_ATTRIBUTE) != null) {
				request.getSession(true).setAttribute(OpenIdFilter.OPENID_IDENTITY, request.getParameter(OpenIdFilter.OPENID_IDENTITY));
				loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
			}
			if(loggedInAs != null) {
				printLoginPage(request, response, true);
			} else {
				printLoginPage(request, response, false);
			}
		}
	}  	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		if(request.getParameter("signin") != null) {
			try {
				HttpSession session = request.getSession();
				if(session.isNew() != true) {
					//session.invalidate();
					//HttpSession nsession = request.getSession(true);
					
				}
				StringBuffer returnTo = new StringBuffer(UrlUtils.getBaseUrl(request));
				//returnTo.append(request.getServletPath());
				String id = request.getParameter("openid_url");
				if (!id.startsWith("http:")) {
					id = "http://" + id;
				}
				String trustRoot = UrlUtils.getBaseUrl(request);
				String s = OpenIdFilter.joid().getAuthUrl(id, returnTo.toString(), trustRoot);
				response.sendRedirect(s);
			} catch (OpenIdException e) {
				// TODO Auto-generated catch block
				//e.printStackTrace();
				printLoginPage(request, response, false);
			}
		} else {
			String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
			if( loggedInAs == null  && request.getParameter(OpenIdFilter.OPENID_ATTRIBUTE) != null) {
				request.getSession(true).setAttribute(OpenIdFilter.OPENID_IDENTITY, request.getParameter(OpenIdFilter.OPENID_IDENTITY));
				loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
			}
			if(loggedInAs != null) {
				if(request.getParameter("signout") != null) {
					OpenIdFilter.logout(request.getSession());
					printLoginPage(request, response, false);
				}
				printLoginPage(request, response, true);
				
			} else {
				printLoginPage(request, response, false);
			}
		}
	}   	  	  
	
	@SuppressWarnings("unchecked")
	private void printLoginPage(HttpServletRequest request, HttpServletResponse response, boolean loggedin) 
	throws ServletException, IOException {
		Log log = LogFactory.getLog(OpenIdConsumer.class);
		log.info("Printing login page");
		PrintWriter out = response.getWriter();
		StringBuffer buff = new StringBuffer();
		buff.append(request.getContextPath());
		buff.append(request.getServletPath());
		out.println("<html>");
		out.println("\t<head><title>Login Page</title></head>");
		out.println("\t<body>");
		out.print("\t\t<p>");
		if(loggedin) {
			out.print("Logged in as ");
			out.print(OpenIdFilter.getCurrentUser(request.getSession()));
			out.print(HtmlUtils.generateSignoutForm(buff.toString(), "post"));
		} else {
			out.print(OpenIdFilter.getCurrentUser(request.getSession()));
			out.print(HtmlUtils.generateSigninForm(buff.toString(), "post"));
		}
		Enumeration e = request.getParameterNames();
		out.print("<p>Attributes</p>");
		while( e.hasMoreElements() ) {
			out.print("<p> -");
			Object elem = e.nextElement();
			out.print(elem);
			out.print(request.getParameter((String) elem));
			out.print("</p>");
		}
		out.println("</p>");
		out.println("\t</body>");
		out.println("</html>");
		
		out.close();
	}
}