<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter, org.verisign.joid.util.UrlUtils, org.verisign.joid.OpenIdException, car.pool.persistance.*, car.pool.user.User, car.pool.user.UserManager, car.pool.user.UserFactory, car.pool.persistance.exception.InvaildUserNamePassword" %>

<%
// a container for the users information
User user = null;
if(session.getAttribute("signedin") != null ) {
	user = (User)session.getAttribute("user");
}
//code to validate user's openID
	//phase one of authenticating a OpenId URL
	if (request.getParameter("signin") != null) {
		try {
			//The url that is going to be returned to after the OpenId has been verified or not
			StringBuffer returnTo = new StringBuffer(UrlUtils
					.getBaseUrl(request));
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
			String str = OpenIdFilter.joid().getAuthUrl(id,
					returnTo.toString(), trustRoot);
			response.sendRedirect(str);
		} catch (OpenIdException e) {
			StringBuffer buff = new StringBuffer();
			buff.append(request.getContextPath());
			buff.append("/index.jsp");

			response.sendRedirect(buff.toString());
		}
	} else if( request.getParameter("normal_signin") != null ) {
		String username = request.getParameter("username");
		String userpass = request.getParameter("userpass");
		UserManager manager = new UserManager();
		//User user = null;
		try {
			user = manager.getUserByUsername(username,userpass);
			session.setAttribute("user", user);
			//session.setAttribute("iduser", user.getUserId());
			//session.setAttribute("email", user.getEmail());
			//session.setAttribute("phone_number", user.getPhoneNumber());
			//session.setAttribute("membersince", user.getMemberSince());
			session.setAttribute("signedin", true);
		} catch(InvaildUserNamePassword iunpe ) {
			StringBuffer buff = new StringBuffer();
			buff.append(request.getContextPath());
			buff.append("/index.jsp");
			response.sendRedirect(buff.toString());
		}
	} else if( session.getAttribute("signedin") == null ) {
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
		if (loggedInAs == null
				&& request.getParameter(OpenIdFilter.OPENID_ATTRIBUTE) != null) {
			session.setAttribute(OpenIdFilter.OPENID_IDENTITY, request
					.getParameter(OpenIdFilter.OPENID_IDENTITY));
			loggedInAs = OpenIdFilter.getCurrentUser(request
					.getSession());
		}
		if (loggedInAs != null) {
			// The OpenId provider authenticated this user
			UserManager manager = new UserManager();
		
			try {
				user = manager.getUserByOpenId(loggedInAs);
				session.setAttribute("user", user);
				//session.setAttribute("iduser", user.getUserId());
				//session.setAttribute("email", user.getEmail());
				//session.setAttribute("phone_number", user.getPhoneNumber());
				//session.setAttribute("membersince", user.getMemberSince());
				session.setAttribute("signedin", true);
			} catch(InvaildUserNamePassword iunpe ) {
				StringBuffer buff = new StringBuffer();
				buff.append(request.getContextPath());
				buff.append("/register.jsp");
				response.sendRedirect(buff.toString());
			}
		} else {
			// the provider didn't authenticate so redirect to index.jsp
			StringBuffer buff = new StringBuffer();
			buff.append(request.getContextPath());
			buff.append("/index.jsp");
			response.sendRedirect(buff.toString());
		}
	}

//being nice to our users
String message = "";
if (request.getParameter("sThx") != null) {
	message += "<p> Thanks for signing up! </p>";
}

//code to allow interaction with db
CarPoolStore cps = new CarPoolStoreImpl();

//code to add user to the db
if (request.getParameter("newUser") != null) {
	cps.addUser((String)request.getParameter("openid_url"),(String)request.getParameter("userName"),(String)request.getParameter("email"),(String)request.getParameter("phone"));
}
%>

<HTML>
	<HEAD>
		<TITLE> Welcome to The Car Pool </TITLE>
		<STYLE type="text/css" media="screen">@import "3ColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="content">
		<h2 align="center">Welcome to The Car Pool
		<%if(session.getAttribute("signedin") != null ) {%>
			<%=user.getUserName()%><%//OpenIdFilter.getCurrentUser(request.getSession())%></h2>
		<%} %>
		<%=message %>
		<p>Eventually the person's upcoming rides will be displayed here.</p>
	</DIV>		

	<%@ include file="leftMenu.html" %>

	<%@ include file="rightMenu.jsp" %>

	</BODY>
</HTML>

