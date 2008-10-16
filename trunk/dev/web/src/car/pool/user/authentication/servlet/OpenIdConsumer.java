package car.pool.user.authentication.servlet;

import java.io.IOException;
import java.net.ProxySelector;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.verisign.joid.OpenIdException;
import org.verisign.joid.consumer.OpenIdFilter;
import org.verisign.joid.util.UrlUtils;

import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.proxy.ProxyConfig;
import car.pool.user.User;
import car.pool.user.UserManager;


/**
 * Servlet implementation class for Servlet: OpenIdConsumer
 * Processes any authentication requests by those using OpenID as a means of authentication.
 * 
 * @author James Hurford <terrasea@gmail.com>
 *
 */
 public class OpenIdConsumer extends HttpServlet {
   static final long serialVersionUID = 1L;
   /**
    * The plugin ProxySelector used to determine what proxy to use, if any for any network connections made by this servlet. 
    */
   public ProxyConfig proxyConfig = null;
/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#HttpServlet()
	 */
	public OpenIdConsumer() {
		super();
	}
	
	/* Happens when web server started.  The init method is run once and a instance of this class is kept around and used over and over.
	 * This is a useful method for some config setting up.
	 * (non-Javadoc)
	 * @see javax.servlet.GenericServlet#init()
	 */
	@Override
	public void init() {
		try {
			proxyConfig = new ProxyConfig(ProxySelector.getDefault());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		ProxySelector.setDefault(proxyConfig);
	}
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		doPost(request, response);
	}  	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession();
		
		System.out.println("OpenIdConsumer: start");
		//phase one of authenticating a OpenId URL
		if(OpenIdFilter.getCurrentUser(session) == null && request.getParameter("openid_url") != null) {
			System.out.println("OpenIdConsumer: phase 1");
			try {
				//The url that is going to be returned to after the OpenId has been verified or not
				StringBuffer returnTo = new StringBuffer(UrlUtils.getBaseUrl(request));
				returnTo.append("/");
				//returnTo.append("test.jsp");
				returnTo.append(request.getServletPath());
				//The actual OpenId the user supplied in the previous pages login form
				String id = request.getParameter("openid_url");
				/*if(id == null) {
					response.sendRedirect(String.format("%s/openidfailed.jsp", request.getContextPath()));
					return;
				}*/
				//part of the normalisation of the OpenId making sure it starts with http
				if (!id.startsWith("http:")) {
					id = "http://" + id;
				}
				//The web site url that you want the OpenId provider to trust
				String trustRoot = UrlUtils.getBaseUrl(request);
				//The url plus query string is created here for redirection purposes
				System.out.format("OpenIdConsumer: id: %s, returnTo: %s, trustRoot %s\n", id, returnTo.toString(), trustRoot);
				StringBuilder s = new StringBuilder(OpenIdFilter.joid().getAuthUrl(id, returnTo.toString(), trustRoot));
				s.append("&openid.ns.sreg=http%3A%2F%2Fopenid.net%2Fextensions%2Fsreg%2F1.1&openid.sreg.optional=fullname%2Cemail&openid.sreg.required=nickname");
				System.out.format("%s\n", s.toString());
				response.sendRedirect(s.toString());
				return;
			} catch (OpenIdException e) {
				System.out.println(String.format("OpenIdConsumer: OpenIdException %s", e.toString()));
				// Something bad happened, don't know what it is but will redirect to index
				//HttpSession session = request.getSession();
				session.setAttribute("OpenIdException", e.toString());
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/openidfailed.jsp");
				response.sendRedirect(buff.toString());
				return;
			}
		} else {
			/* 
			  * Phase 2 of authenticating a OpenId URL when the OpenId provider
			  * redirects back to this page after confirming or denying a authentication
			  * request
			  */
			System.out.println(String.format("OpenIdConsumer: phase 2"));
			/*
			 * try to get a OpenId URL, if the request was refused then a session
			 * attribute will not be set so will return null otherwise it will return
			 * the OpenId URL indicating that it was authenticated
			 */
			String loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
			if( loggedInAs == null  && request.getParameter(OpenIdFilter.OPENID_ATTRIBUTE) != null) {
				request.getSession(true).setAttribute(OpenIdFilter.OPENID_IDENTITY, request.getParameter(OpenIdFilter.OPENID_IDENTITY));
				loggedInAs = OpenIdFilter.getCurrentUser(request.getSession());
			}
			if(loggedInAs != null) {
				//for(Object key: request.getParameterValues("")) {
					//System.out.format("%s: %s", key, request.getParameter((String) key));
				//}
				System.out.println(request.getMethod());
				
				// The OpenId provider authenticated this user
				// create a instance of UserManager
				System.out.println(String.format("OpenIdConsumer: loggedInAs %s", loggedInAs));
				UserManager manager = new UserManager();
				try {
					// get users info from the database and put it into the session attributes along with signedin
					User user = manager.getUserByOpenId(loggedInAs);
					//HttpSession session = request.getSession();
					session.setAttribute("user", user);
					session.setAttribute("signedin", Boolean.TRUE);
					// now redirect to welcome.jsp
					StringBuffer buff = new StringBuffer();
					buff.append(request.getContextPath());
					buff.append("/welcome.jsp");
					response.sendRedirect(buff.toString());
					return;
				} catch (InvaildUserNamePassword e) {
					// OpenId not in database so redirect to register
					//HttpSession session = request.getSession();
					System.out.println(String.format("OpenIdConsumer: InvalidUserNamePassword: %s", e.toString()));
					session.setAttribute("InvalidUserNamePassword", e.toString());
					StringBuffer buff = new StringBuffer();
					buff.append(request.getContextPath());
					buff.append("/oregistration.jsp");
					response.sendRedirect(buff.toString());
					return;
				} catch (SQLException e) {
					// TODO redirect to error page
					System.out.println(String.format("OpenIdConsumer: SQLException: %s", e.toString()));
				}
			} else {
				// Log in failed go back to index
				//HttpSession session = request.getSession();
				System.out.println(String.format("OpenIdConsumer: Not Authenticated"));
				session.setAttribute("Not Authenticated", "Not gonna happen");
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/openidfailed.jsp");
				response.sendRedirect(buff.toString());
				return;
			}
		}
	}
}