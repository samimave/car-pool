package car.pool.user.authentication.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
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

import car.pool.persistance.exception.InvaildUserNamePassword;
import car.pool.user.User;
import car.pool.user.UserManager;


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
		doPost(request, response);
	}  	
	
	/* (non-Java-doc)
	 * @see javax.servlet.http.HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//phase one of authenticating a OpenId URL
		if(request.getParameter("openid_signin") != null) {
			try {
				HttpSession session = request.getSession();
				if(session.isNew() != true) {
					//session.invalidate();
					//HttpSession nsession = request.getSession(true);
					
				}
				//The url that is going to be returned to after the OpenId has been verified or not
				StringBuffer returnTo = new StringBuffer(UrlUtils.getBaseUrl(request));
				returnTo.append("/");
				returnTo.append(request.getServletPath());
				//The actual OpenId the user supplied in the previous pages login form
				String id = request.getParameter("openid_url");
				//part of the normalisation of the OpenId making sure it starts with http
				if (!id.startsWith("http:")) {
					id = "http://" + id;
				}
				//The web site url that you want the OpenId provider to trust
				String trustRoot = UrlUtils.getBaseUrl(request);
				//The url plus query string is created here for redirection purposes
				String s = OpenIdFilter.joid().getAuthUrl(id, returnTo.toString(), trustRoot);
				response.sendRedirect(s);
			} catch (OpenIdException e) {
				// Something bad happened, don't know what it is but will redirect to index
				HttpSession session = request.getSession();
				session.setAttribute("OpenIdException", e.toString());
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/openidfailed.jsp");
				response.sendRedirect(buff.toString());
			}
		} else {
			/* 
			  * Phase 2 of authenticating a OpenId URL when the OpenId provider
			  * redirects back to this page after confirming or denying a authentication
			  * request
			  */
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
				// The OpenId provider authenticated this user
				// create a instance of UserManager
				UserManager manager = new UserManager();
				try {
					// get users info from the database and put it into the session attributes along with signedin
					User user = manager.getUserByOpenId(loggedInAs);
					HttpSession session = request.getSession();
					session.setAttribute("user", user);
					session.setAttribute("signedin", Boolean.TRUE);
					// now redirect to welcome.jsp
					StringBuffer buff = new StringBuffer();
					buff.append(request.getContextPath());
					buff.append("/welcome.jsp");
					response.sendRedirect(buff.toString());
				} catch (InvaildUserNamePassword e) {
					// OpenId not in database so redirect to register
					HttpSession session = request.getSession();
					session.setAttribute("InvalidUserNamePassword", e.toString());
					StringBuffer buff = new StringBuffer();
					buff.append(request.getContextPath());
					buff.append("/register.jsp");
					response.sendRedirect(buff.toString());
				} catch (SQLException e) {
					// TODO redirect to error page
				}
			} else {
				// Log in failed go back to index
				HttpSession session = request.getSession();
				session.setAttribute("Not Authenticated", "Not gonna happen");
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/openidfailed.jsp");
				response.sendRedirect(buff.toString());
			}
		}
	}
}