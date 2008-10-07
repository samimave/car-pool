
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.util.*,java.text.SimpleDateFormat" %>

<%
	HttpSession s = request.getSession(false);

	String delConf = "";
	String updateSeatConf = "";
	String updateTimeConf = "";
	String updateStartS = "";
	String updateEndS = "";
	String updateDateConf = "";
	String updateUserConf = "";

	User user = null;
	//force the user to login to view the page
	if (s.getAttribute("signedin") != null) {
		user = (User) s.getAttribute("user");
		int dbID = user.getUserId();
		//code to interact with db
		CarPoolStore cps = new CarPoolStoreImpl();

		//if you have been redirected here from deleting a ride print useful info
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("remRide") != null) {
			boolean yes = cps.removeRide(Integer.parseInt(request
					.getParameter("rideSelect")));
			delConf = "<p>"
					+ "You have successfully deleted the ride you wanted to"
					+ yes+"</p>";
		}

		//if you have been redirected here from editing a ride print useful info
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("numSeats") != null) {
			int seat = Integer.parseInt(request
					.getParameter("numSeats"));
			seat++;
			cps.updateSeats(Integer.parseInt(request
					.getParameter("rideSelect")), seat);
			updateSeatConf = "<p>"
					+ "You have successfully updated the ride you wanted to"
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("Rtime") != null) {
			cps.updateStartTime(Integer.parseInt(request
					.getParameter("rideSelect")), request
					.getParameter("Rtime"));
			updateTimeConf = "<p>"
					+ "You have successfully updated the ride you wanted to"
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("startFromHN") != null
				&& request.getParameter("startFrom") != null) {
			cps.updateStartLoc(Integer.parseInt(request
					.getParameter("rideSelect")), Integer
					.parseInt(request.getParameter("startFromHN")),Integer
					.parseInt(request.getParameter("startFrom")),dbID);
			updateStartS = "<p>"
					+ "You have successfully updated the ride you wanted to"
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("endToHN") != null
				&& request.getParameter("endTo") != null) {
			cps.updateEndLoc(Integer.parseInt(request
					.getParameter("rideSelect")), Integer
					.parseInt(request.getParameter("endToHN")),Integer
					.parseInt(request.getParameter("endTo")),dbID);
			updateEndS = "<p>"
					+ "You have successfully updated the ride you wanted to"
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("Rdate") != null) {
			String strTmp = request.getParameter("Rdate");
			Date dtTmp = new SimpleDateFormat("dd/MM/yyyy")
					.parse(strTmp);
			String strOutDt = new SimpleDateFormat("yyyy-MM-dd")
					.format(dtTmp);
			//Integer.parseInt(request.getParameter("Rseats"))
			cps.updateStartDate(Integer.parseInt(request
					.getParameter("rideSelect")), strOutDt);
			updateSeatConf = "<p>"
					+ "You have successfully updated the ride you wanted to"
					+ "</p>";
		}

		//if you have been redirected here from accepting a user print useful info
		//IF YOU ACCEPTED OR REJECTED A USER UPDATE DATABASE
		if (request.getParameter("confirmUser") != null) {
			cps.acceptUser(Integer.parseInt(request
					.getParameter("confirmUserID")), Integer
					.parseInt(request.getParameter("confirmForRide")),
					1);
			cps.addScore(cps.getTripID(Integer.parseInt(request
					.getParameter("confirmForRide")), dbID), dbID, 3);
			updateUserConf = "<p>"
					+ "You have accepted the user you wanted to"
					+ "</p>";
		}
		if (request.getParameter("rejectUser") != null) {
			cps.removeRide(Integer.parseInt(request
					.getParameter("confirmUserID")), Integer
					.parseInt(request.getParameter("confirmForRide")));
			updateUserConf = "<p>"
					+ "You have removed the user you wanted to"
					+ "</p>";
		}

		//if you have been redirected here from withdraw the user from ride print useful info
		//IF YOU WITHDRAW YOURSELF FROM THE RIDE YOU HAVE TAKEN OR THE RIDE YOU HAVE REQUESTED UPDATE DATABASE
		if (request.getParameter("withdrawConfirmedRide") != null) {
			cps.removeRide(Integer.parseInt(request
					.getParameter("withdrawUserID")), Integer
					.parseInt(request.getParameter("withdrawRideID")));
			updateUserConf = "<p>"
					+ "You have withdraw from the ride you wanted to"
					+ "</p>";
		}
		if (request.getParameter("withdrawNotConfirmedRide") != null) {
			cps.removeRide(Integer.parseInt(request
					.getParameter("withdrawUserID")), Integer
					.parseInt(request.getParameter("withdrawRideID")));
			updateUserConf = "<p>"
					+ "You have withdraw from the ride you wanted to"
					+ "</p>";
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
	</HEAD>
	<BODY>

	<%@ include file="heading.html" %>

	<DIV class="Content" id="Content">
		<%=delConf%>
		<%=updateSeatConf%>
		<%=updateTimeConf%>
		<%=updateStartS%>
		<%=updateEndS%>
		<%=updateDateConf%>
		<%=updateUserConf%>
	<p>-- <a href="myDetails.jsp">Back to Account page</a> --</p>	
	</DIV>

	<%@ include file="leftMenu.html" %>

	</BODY>
</HTML>