<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.util.ArrayList,java.text.*,java.util.*, car.pool.email.*"%>

<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	//user a container for the users information
	//temp placeholder variables
	User user = null;
	String openIDTableRow = "";								//contains the row in the openid table
	String openIDTableForm = "";							//contains the open id form to be inserted into the page
	int socialScore = 0;									//the users social score

	if (s.getAttribute("signedin") != null) {											//if the user is signed in
		user = (User) s.getAttribute("user");											//get the users info

		//code to interact with db
		CarPoolStore cps = new CarPoolStoreImpl();
		int currentUser = user.getUserId();												//the current users id
		String nameOfUser = user.getUserName();											//the current users name
		socialScore = cps.getScore(currentUser);										//the users social score
		
		//input openids to the table
		String entries = "";
		int idcount = 0;
		String lastid = "";
		for (String oid : user.getOpenIds()) {
			entries += "<option value=" + oid + ">" + oid + "</option>";				//make the openid entries to add to the select box
			lastid = oid;
			idcount++;
			
		}
		//System.out.println("idcount: "+idcount);
		if (idcount > 1) {															//if they have more than one id
			if (entries != "") {													
				openIDTableRow = "<tr> <td>OpenId to remove:</td> <td><select multiple='multiple' name='openid'>"
						+ entries + "</select></td> </tr>";							//make the row to add in the table
			}
			if (openIDTableRow != "") {												//make the table to display on the page
				openIDTableForm = "<br /><h3>Current OpenIds associated with your account:</h3><div class='Box' id='Box'><form action='"+response.encodeURL("removeopenid")+"'> <input type='hidden' name='removeopenid' /> <table class='updateDetails'>"
						+ openIDTableRow
						+ "<tr></table> <br /><p>Click here to <input type='submit' value='Detach OpenId'/></p></div><br /><br />";
			}
		} else if (idcount == 1) {													//if they only have one openid then they cannot remove it
			//System.out.println("made form");
				openIDTableForm = "<br /><h3>Current OpenId associated with your account:</h3><div class='Box' id='Box'><table class='updateDetails'><tr><td>OpenId: </td><td>"
						+ lastid
						+ "</td></tr></table></div><br /><br />";
		}

	} else {
		response.sendRedirect(request.getContextPath());							//else redirect them to the login page
	}


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<title>User Account Page</title>
		<style type="text/css" media="screen">@import "TwoColumnLayout.css";</style>
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
	</head>
	<body onload="yav.init('updateDtls', u_rules); yav.init('addoid', ad_rules);">

	<%@ include file="heading.html" %>

	<div class="Content" id="Content">
		<h2 class="title" id="title">Your Account</h2>
		<br />
		<br />
		<h2>Your user details appear below:</h2>
		<div class="Box" id="Box">
		<p>Your current social score is: <%=socialScore%></p>
		<br />
		<form id="updateDtls" name="updateDtls" onsubmit="return yav.performCheck('updateDtls', u_rules, 'inline');" action="<%=response.encodeURL("updateuser") %>" method="post">
			<input type="hidden" name="updateDetails" value="yes">
			<table> 
				<tr> <td>Username:</td> <td><%=user != null ? user.getUserName() : ""%></td> </tr> 
				<tr> <td>Email Address:</td> <td><input type="text" name="email" SIZE="25" value="<%=user != null ? user.getEmail() : ""%>">&nbsp;&nbsp;<span id=errorsDiv_email></span></td> </tr> 
				<tr> <td>Phone Number:</td> <td><input type="text" name="phone" SIZE="25" value="<%=user != null ? user.getPhoneNumber() : ""%>">&nbsp;&nbsp;<span id=errorsDiv_phone></span></td> </tr>
				<tr> <td><%if( OpenIdFilter.getCurrentUser(s) != null) {%>Add a <%}else{ %>Change <%} %>password?:</td><td> <input type="checkbox" name="changePassword" value="isChecked"/> </td> </tr>
				<%if( OpenIdFilter.getCurrentUser(s) == null) {%><tr> <td>Old Password:</td><td> <input type="password" name="oldpassword"/> &nbsp;&nbsp;<span id=errorsDiv_oldpassword></span></td> </tr><%} %>
				<tr> <td>New password:</td><td> <input type="password" name="newPassword1"/> &nbsp;&nbsp;<span id=errorsDiv_newPassword1></span></td> </tr>
				<tr> <td>Confirm new password:</td><td> <input type="password" name="newPassword2"/> &nbsp;&nbsp;<span id=errorsDiv_newPassword2></span></td> </tr>
			</table>
			<br />
			<p>Click here to <input type="submit" name="confirmUpdate" VALUE="Update Details" SIZE="25"></p>
		</form>
		</div>
		<br /><br />
		<h2>Your OpenId:</h2>
		<div class="Box" id="Box">
		<%=openIDTableForm%>
		<h3>Attach an OpenId to your account:</h3>
		<div class="Box" id="Box">
		<form id="addoid" name="addoid" onsubmit="return yav.performCheck('addoid', ad_rules, 'inline');" action="<%=response.encodeURL("addopenid") %>" method="post">
			<input type="hidden" name="addopenid"/>
			<p>Want to know more about OpenId? <a href="http://openid.net/" target = "_blank">Click here.</a></p><br /><br />
			<table>
				<tr><td>OpenId to add:</td> <td><input type="text" name="openid" size="25"/>&nbsp;&nbsp;<span id=errorsDiv_openid></span></td></tr>
			</table>
			<br />
			<p>Click here to <input type="submit" value="Attach OpenId"/></p>
		</form>
		</div>
		</div>
		<br /> <br /> <br />
		<p>-- <a href="<%=response.encodeURL("welcome.jsp") %>">Home</a> --</p>
	</div>

	<%@ include file="leftMenu.jsp" %>

	</body>
</html>