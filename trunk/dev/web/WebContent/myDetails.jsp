<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.util.ArrayList,java.text.*,java.util.*, car.pool.email.*"%>

<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//user a container for the users information
	//temp placeholder variables
	User user = null;
	String openIDTableRow = "";
	String openIDTableForm = "";
	int socialScore = 0;

	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");

		//code to interact with db
		CarPoolStore cps = new CarPoolStoreImpl();
		int currentUser = user.getUserId();
		String nameOfUser = user.getUserName();
		socialScore = cps.getScore(currentUser);
		int dbID = user.getUserId();

		boolean userExist = false;
		ArrayList<Integer> rideIDs = new ArrayList<Integer>();
		
		//input openids to the table
		String entries = "";
		int idcount = 0;
		String lastid = "";
		for (String oid : user.getOpenIds()) {
			entries += "<option value=" + oid + ">" + oid + "</option>";
			lastid = oid;
			idcount++;
			
		}
		//System.out.println("idcount: "+idcount);
		if (idcount > 1) {
			if (entries != "") {
				openIDTableRow = "<tr> <td>OpenId to remove:</td> <td><select multiple='multiple' NAME='openid'>"
						+ entries + "</select></td> </tr>";
			}
			if (openIDTableRow != "") {
				openIDTableForm = "<br /><h3>Current OpenIds associated with your account:</h3><div class='Box' id='Box'><FORM action='"+response.encodeURL("removeopenid")+"'> <INPUT type='hidden' name='removeopenid' /> <TABLE class='updateDetails'>"
						+ openIDTableRow
						+ "<tr></TABLE> <br /><p>Click here to <INPUT type='submit' value='Detach OpenId'/></p></div><br /><br />";
			}
		} else if (idcount == 1) {
			//System.out.println("made form");
				openIDTableForm = "<br /><h3>Current OpenId associated with your account:</h3><div class='Box' id='Box'><TABLE class='updateDetails'><tr><td>OpenId: </td><td>"
						+ lastid
						+ "</td></tr></table></div><br /><br />";
		}

	} else {
		response.sendRedirect(request.getContextPath());
	}


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
	<HEAD>
		<TITLE>User Account Page</TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
		<script type="text/javascript" src="javascript/yav.js"></script>
		<script type="text/javascript" src="javascript/yav-config.js"></script>
		<script>
		var u_rules=new Array();
		u_rules[0]='email|required';
		u_rules[1]='email|email';
		u_rules[2]='phone|numeric';
		u_rules[3]='newPassword1:new password|equal|$newPassword2:confirmed password';

		var ad_rules=new Array();
		ad_rules[0]='openid|required';
		</script>
	</HEAD>
	<BODY onload="yav.init('updateDtls', u_rules); yav.init('addoid', ad_rules);">

	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<h2 class="title" id="title">Your Account</h2>
		<br />
		<br />
		<h2>Your user details appear below:</h2>
		<div class="Box" id="Box">
		<p>Your current social score is: <%=socialScore%></p>
		<br />
		<FORM id="updateDtls" name="updateDtls" onsubmit="return yav.performCheck('updateDtls', u_rules, 'inline');" action="<%=response.encodeURL("updateuser") %>" method="post">
			<INPUT type="hidden" name="updateDetails" value="yes">
			<TABLE> 
				<tr> <td>Username:</td> <td><%=user != null ? user.getUserName() : ""%></td> </tr> 
				<tr> <td>Email Address:</td> <td><INPUT TYPE="text" NAME="email" SIZE="25" value="<%=user != null ? user.getEmail() : ""%>">&nbsp;&nbsp;<span id=errorsDiv_email></span></td> </tr> 
				<tr> <td>Phone Number:</td> <td><INPUT TYPE="text" NAME="phone" SIZE="25" value="<%=user != null ? user.getPhoneNumber() : ""%>">&nbsp;&nbsp;<span id=errorsDiv_phone></span></td> </tr>
				<tr> <td><%if( OpenIdFilter.getCurrentUser(s) != null) {%>Add a <%}else{ %>Change <%} %>password?:</td><td> <input type="checkbox" name="changePassword" value="isChecked"/> </td> </tr>
				<%if( OpenIdFilter.getCurrentUser(s) == null) {%><tr> <td>Old Password:</td><td> <input type="password" name="oldpassword"/> &nbsp;&nbsp;<span id=errorsDiv_oldpassword></span></td> </tr><%} %>
				<tr> <td>New password:</td><td> <input type="password" name="newPassword1"/> &nbsp;&nbsp;<span id=errorsDiv_newPassword1></span></td> </tr>
				<tr> <td>Confirm new password:</td><td> <input type="password" name="newPassword2"/> &nbsp;&nbsp;<span id=errorsDiv_newPassword2></span></td> </tr>
			</TABLE>
			<br />
			<p>Click here to <INPUT TYPE="submit" NAME="confirmUpdate" VALUE="Update Details" SIZE="25"></p>
		</FORM>
		</div>
		<br /><br />
		<h2>Your OpenId:</h2>
		<div class="Box" id="Box">
		<%=openIDTableForm%>
		<h3>Attach an OpenId to your account:</h3>
		<div class="Box" id="Box">
		<FORM id="addoid" name="addoid" onsubmit="return yav.performCheck('addoid', ad_rules, 'inline');" action="<%=response.encodeURL("addopenid") %>" method="post">
			<INPUT type="hidden" name="addopenid"/>
			<p>Want to know more about OpenId? <a href="http://openid.net/" target = "_blank">Click here.</a></p><br /><br />
			<TABLE>
				<tr><td>OpenId to add:</td> <td><INPUT type="text" name="openid" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_openid></span></td></tr>
			</TABLE>
			<br />
			<p>Click here to <INPUT type="submit" value="Attach OpenId"/></p>
		</FORM>
		</div>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="<%=response.encodeURL("welcome.jsp") %>">Home</a> --</p>
	</DIV>

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>