<%@page errorPage="errorPage.jsp"%>
<%@page contentType="text/html; charset=ISO-8859-1" %>
<%@page import="java.sql.*, car.pool.persistance.exception.*, java.io.*,org.verisign.joid.consumer.OpenIdFilter,car.pool.persistance.*,car.pool.user.*,java.util.*,java.text.SimpleDateFormat, car.pool.email.*" %>

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
			// this is the easy part
			Integer rideId = Integer.parseInt(request.getParameter("rideSelect"));
			RideListing listing = cps.getRideListing();
			while(listing.next()) {
				if(listing.getRideID() == rideId.intValue()) {
					break;
				} else {
					continue;
				}
			}
			try {
				//now to find a list of all the users that have takenthe ride, which is the hard part, as I don't know how to do it other than using sql
				RideUserStack stack = new RideUserStack(listing.getRideID());
				while(stack.size() > 0) {
					User rideUser = stack.pop();
					String message = String.format("Hello %s\nUnfortunately the ride from %s %s to %s %s on %s at %s has been cancelled because the driver has withdrawn the ride.", rideUser.getUserName(), listing.getStreetStart(), listing.getStartLocation(), listing.getStreetEnd(), listing.getEndLocation(), new SimpleDateFormat("dd/MM/yyyy").format(listing.getRideDate()), listing.getTime());
					String address = rideUser.getEmail();
					String subject = "Car Pool: Ride cancelled";
					Email email = new Email();
					email.setMessage(message);
					email.setSubject(subject);
					email.setToAddress(address);
					SMTP.send(email);
				}
			} catch( IOException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SQLException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( InvaildUserNamePassword e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SMTPException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			}
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

		
		if (request.getParameter("rideSelect") != null		//if you have been redirected here from editing a ride print useful info
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
			cps.updateGeoLocationStart(Integer.parseInt(request
					.getParameter("rideSelect")), request.getParameter("fromCoord"));
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
			cps.updateGeoLocationEnd(Integer.parseInt(request
					.getParameter("rideSelect")), request.getParameter("toCoord"));
			updateEndS = "<p>"
					+ "You have successfully updated the ride you wanted to"
					+ "</p>";
		}

		//if you have been redirected here from editing a ride print useful info && request.getParameter("Rseats") != null
		if (request.getParameter("rideSelect") != null
				&& request.getParameter("Rdate") != null) {
			String strTmp = request.getParameter("Rdate");
			java.util.Date dtTmp = new SimpleDateFormat("dd/MM/yyyy")
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

		// the user has finished editing the ride now send email to all affected users
		if(request.getParameter("rideSelect") != null ) {
			// this is the easy part
			Integer rideId = Integer.parseInt(request.getParameter("rideSelect"));
			RideListing listing = cps.getRideListing();
			while(listing.next()) {
				if(listing.getRideID() == rideId.intValue()) {
					break;
				} else {
					continue;
				}
			}
			try {
				//now to find a list of all the users that have takenthe ride, which is the hard part, as I don't know how to do it other than using sql
				RideUserStack stack = new RideUserStack(listing.getRideID());
				while(stack.size() > 0) {
					User rideUser = stack.pop();
					String message = String.format("Hello %s\nThe details of a ride that you were taking part in have been updated by the driver. The following are the updated details: [from: %s %s, to: %s %s, on: %s, at: %s]", rideUser.getUserName(), listing.getStreetStart(), listing.getStartLocation(), listing.getStreetEnd(), listing.getEndLocation(), new SimpleDateFormat("dd/MM/yyyy").format(listing.getRideDate()), listing.getTime());
					String address = rideUser.getEmail();
					String subject = "Car Pool: Ride details changed";
					Email email = new Email();
					email.setMessage(message);
					email.setSubject(subject);
					email.setToAddress(address);
					SMTP.send(email);
				}
			} catch( IOException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SQLException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( InvaildUserNamePassword e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SMTPException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			}
			
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
			try {
				Integer rideId = Integer.parseInt(request.getParameter("confirmForRide"));
				RideListing listing = cps.getRideListing();
				while(listing.next()) {
					if(listing.getRideID() == rideId.intValue()) {
						break;
					} else {
						continue;
					}
				}
				User acceptedUser = new UserManager().getUserByUserId(Integer.parseInt(request.getParameter("confirmUserID")));
				String message = String.format("Good news! %s has confirmed you for the ride from %s %s to %s %s on %s at %s. You may access the details of this ride from the Edit Details page once you log into our site. If you can not make it on the day of the ride you can click on	Withdraw from Ride and the driver will be informed that you will no longer be participating in their ride.", acceptedUser.getUserName(), listing.getStreetStart(), listing.getStartLocation(), listing.getStreetEnd(), listing.getEndLocation(), new SimpleDateFormat("dd/MM/yyyy").format(listing.getRideDate()), listing.getTime());
				String address = acceptedUser.getEmail();
				String subject = "Car Pool: Ride acceptance";
				Email email = new Email();
				email.setMessage(message);
				email.setSubject(subject);
				email.setToAddress(address);
				SMTP.send(email);
			} catch( IOException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SQLException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( InvaildUserNamePassword e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SMTPException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			}
		}
		
		//if you have been redirected here from accepting a user print useful info
		//IF YOU ACCEPTED OR REJECTED A USER UPDATE DATABASE
		if (request.getParameter("rejectUser") != null) {
			cps.removeRide(Integer.parseInt(request
					.getParameter("confirmUserID")), Integer
					.parseInt(request.getParameter("confirmForRide")));
			updateUserConf = "<p>"
					+ "You have removed the user you wanted to"
					+ "</p>";
			try {
				Integer rideId = Integer.parseInt(request.getParameter("confirmForRide"));
				RideListing listing = cps.getRideListing();
				while(listing.next()) {
					if(listing.getRideID() == rideId.intValue()) {
						break;
					} else {
						continue;
					}
				}
				User acceptedUser = new UserManager().getUserByUserId(Integer.parseInt(request.getParameter("confirmUserID")));
				String message = String.format("Unfortunately %s you have not been accepted for the ride from %s %s to %s %s on %s %s. This is most likely because the driver is unable to pick you up from the location you requested.", acceptedUser.getUserName(), listing.getStreetStart(), listing.getStartLocation(), listing.getStreetEnd(), listing.getEndLocation(), new SimpleDateFormat("dd/MM/yyyy").format(listing.getRideDate()), listing.getTime());
				String address = acceptedUser.getEmail();
				String subject = "Car Pool: Ride rejection";
				Email email = new Email();
				email.setMessage(message);
				email.setSubject(subject);
				email.setToAddress(address);
				SMTP.send(email);
			} catch( IOException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SQLException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( InvaildUserNamePassword e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SMTPException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			}
		}

		//if you have been redirected here from withdraw the user from ride print useful info
		//IF YOU WITHDRAW YOURSELF FROM THE RIDE YOU HAVE TAKEN OR THE RIDE YOU HAVE REQUESTED UPDATE DATABASE
		if (request.getParameter("withdrawConfirmedRide") != null) {
			cps.removeRide(Integer.parseInt(request.getParameter("withdrawUserID")), Integer.parseInt(request.getParameter("withdrawRideID")));
			updateUserConf = "<p>" + "You have withdraw from the ride you wanted to" + "</p>";
			try {
				Integer rideId = Integer.parseInt(request.getParameter("withdrawRideID"));
				RideListing listing = cps.getRideListing();
				while(listing.next()) {
					if(listing.getRideID() == rideId.intValue()) {
						break;
					} else {
						continue;
					}
				}
				User rideUser = new UserManager().getUserByUserId(listing.getUserID());
				User withdrawUser = new UserManager().getUserByUserId(Integer.parseInt(request.getParameter("withdrawUserID")));
				String message = String.format("Unfotunately, %s has decided to withdraw from your ride from %s %s to %s %s on %s at %s.", withdrawUser.getUserName(), listing.getStreetStart(), listing.getStartLocation(), listing.getStreetEnd(), listing.getEndLocation(), new SimpleDateFormat("dd/MM/yyyy").format(listing.getRideDate()), listing.getTime());
				String address = rideUser.getEmail();
				String subject = "Car Pool: Ride withdraw";
				Email email = new Email();
				email.setMessage(message);
				email.setSubject(subject);
				email.setToAddress(address);
				SMTP.send(email);
			} catch( IOException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SQLException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( InvaildUserNamePassword e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			} catch( SMTPException e ) {
				//just let it slide here, but print message to stdout
				System.out.format("SMTP failed to send.  Error is:\n%s", e.getMessage());
			}
		}

		if (request.getParameter("withdrawNotConfirmedRide") != null) {
			cps.removeRide(Integer.parseInt(request.getParameter("withdrawUserID")), Integer.parseInt(request.getParameter("withdrawRideID")));
			updateUserConf = "<p>" + "You have withdraw from the ride you wanted to" + "</p>";
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
		<% response.sendRedirect(request.getParameter("reDirURL"));%>
	<p>-- <a href="<%=response.encodeURL("myRideDetails.jsp") %>">Back to Account page</a> --</p>	
	</DIV>

	<%@ include file="leftMenu.jsp" %>

	</BODY>
</HTML>