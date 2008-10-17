<%@page errorPage="errorPage.jsp" %>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,java.text.SimpleDateFormat,car.pool.user.*,java.util.*, car.pool.email.*" %>

<%
	HttpSession s = request.getSession(false);

	//force the user to login to view the page
	// a container for the users information
	User user = null;
	String from = "";
	String to = "";
	String strOutDt = "";
	if (s.getAttribute("signedin") != null) {													//if the user is logged in
		user = (User) s.getAttribute("user");													//get the info about the user

		//add ride information to database
		CarPoolStore cps = new CarPoolStoreImpl();
		int dbID = user.getUserId();//cps.getUserIdByURL(request.getParameter("user"));			//the users id

		//date formatting for use by db 
		//dd/MM/yyyy -> yyyy-MM-dd
		String strTmp = request.getParameter("depDate");
		Date dtTmp = new SimpleDateFormat("dd/MM/yyyy").parse(strTmp);					
		strOutDt = new SimpleDateFormat("yyyy-MM-dd").format(dtTmp);
		
		String coords = request.getParameter("fromCoord") + "/" + request.getParameter("toCoord");

		//Integer.parseInt(request.getParameter("streetTo"))
		int rideID = cps.addRide(dbID, Integer.parseInt(request									//add the specified ride to the database
				.getParameter("numSeats")), strOutDt, Integer
				.parseInt(request.getParameter("streetFrom")), Integer
				.parseInt(request.getParameter("streetTo")), Integer
				.parseInt(request.getParameter("houseFrom")), Integer.parseInt(request.getParameter("houseTo")), 0,
				request.getParameter("depTime"), EscapeSpecialChars.forHTML(request.getParameter("xtraInfo")), coords);
		//add social score
		cps.addScore(cps.getTripID(rideID, dbID), dbID, 5);

		//find the name of the origin and destination streets to show the user
		LocationList allLocs = cps.getLocations();
		while (allLocs.next()) {
			if (allLocs.getID() == Integer.parseInt(request.getParameter("streetFrom")))
				from = allLocs.getStreetName();
		}
		LocationList allLocs2 = cps.getLocations();
		while (allLocs2.next()) {
			if (allLocs2.getID() == Integer.parseInt(request.getParameter("streetTo")))
				to = allLocs2.getStreetName();
		}

		//send the user an email confirming their ride offer
		try {
			String message = "Thank you for adding a ride offer to our website. You can update any details of your ride by logging into our site and clicking Edit Details. There you shall find a list of the rides you have offered, the details of which you can edit at any point. This is also where you can withdraw your offer though please be aware that a social score penalty will be involved. When users register interest in your ride they will show up in the \"Riders awaiting approval\" table of your ride page. Depending on if you can pick them up from the location they requested and if you feel like you can trust them you can either confirm the rider for that ride or reject them. Please make sure you both discuss information like the sharing of petrol costs beforehand in order to avoid confusion on the day.";
			String address = user.getEmail();
			String subject = String.format("Car Pool Ride offer from %s %s to %s %s on the date of %s and time of %s", request.getParameter("houseFrom"), from, request.getParameter("houseTo"), to, strOutDt, request.getParameter("depTime"));
			Email email = new Email();
			email.setMessage(message);
			email.setSubject(subject);
			email.setToAddress(address);
			SMTP.send(email);
		} catch(SMTPException e ) {
			//just let it slide here, but print message to stdout
			System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
		}
	} else {
		response.sendRedirect(request.getContextPath());
	}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="car.pool.escapeSpecialChars.EscapeSpecialChars"%><HTML>
	<HEAD>
		<TITLE> Ride Successfully Offered! </TITLE>
		<STYLE type="text/css" media="screen">@import "TwoColumnLayout.css";</STYLE>
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

		<DIV class="Content" id="Content">
			<h2 class="title" id="title">Ride Successfully Offered</h2>
			<br /><br />
			<h2>Details:</h2>
			<div class="Box" id="Box">
			<p>Thank you for offering a ride from <%=from%>, to <%=to%>;  
			scheduled for <%=request.getParameter("depTime")%> <%=request.getParameter("depDate")%>. </p>
			<FORM action="<%=response.encodeURL("addRideEvent.jsp") %>" method="post" target="_blank">
            	<INPUT type="hidden" name="from" value="<%=request.getParameter("streetFrom")%>">
				<INPUT type="hidden" name="to" value="<%=request.getParameter("streetTo")%>">
				<INPUT type="hidden" name="time" value="<%=request.getParameter("depTime")%>">
				<INPUT type="hidden" name="length" value="<%=request.getParameter("tripLength")%>">
				<INPUT type="hidden" name="date" value="<%=strOutDt%>">
				<br />
				<p>Click here to <INPUT type="submit" value="Add to your Google Calendar" />
			</FORM>
			</div>
			<br /> <br /> <br />
			<p>-- <a href="<%=response.encodeURL("welcome.jsp") %>">Home</a> --</p>	
		</DIV>

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>
