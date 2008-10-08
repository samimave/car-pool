var request = false;
var xpathdebug = false;
try {
        request = new XMLHttpRequest();
} catch (trymicrosoft) {
        try {
        request = new ActiveXObject("Msxml2.XMLHTTP");
        } catch (othermicrosoft) {
            try {
                request = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (failed) {
                request = false;
            }  
        }
}

if (!request)
        alert("Error initializing XMLHttpRequest!");

//var response = null;

function isUserNameAvailable() {
	var username = document.getElementById("register").userName.value;
	var url = "checknameavailable?username="+username;
    request.open("GET", url, false);
    request.onreadystatechange = usernamecallback;
    request.send( null );
    var response = request.responseText;
    if(response == "true") {
    	return true;
    }
    alert("username has already been taken, please use another")
    return false;
}

function checkUserNameAvailable() {
	var username = document.getElementById("register").userName.value;
	var url = "checknameavailable?username="+username;
    request.open("GET", url, true);
    request.onreadystatechange = usernamecallback;
    request.send( null );
}

function usernamecallback() {
    if (request.readyState == 4) {
        if (request.status == 200) {
            var output = document.getElementById("availableoutput");
            var response = request.responseText;
            if(response == "true") {
            	output.innerHTML = " Username is available";
            } else if(response == "false"){
            	output.innerHTML = " Username is not available so choose another please";
            } else {
            	output.innerHTML = " :" + response;
            }
        }
    }
}

function setupemail(form) {
	var authenticate = form.authenticate.checked ? "on" : "off";
	var username = form.username.value;
	var password = form.password.value;
	var replyTo = form.replyTo.value;
	var smtpURL = form.smtpURL.value;
	var port = form.port.value;
	var useTLS = form.useTLS.checked ? "on" : "off";
	
	var url = "setupemail";
	var contentType = "application/x-www-form-urlencoded; charset=UTF-8";
	var query = "emailconfig=yes&authenticate=" + authenticate + "&username=" + username + "&password=" + password + "&replyTo=" + replyTo + "&smtpURL=" + smtpURL + "&port=" + port + "&useTLS=" + useTLS;
	request.open("POST", url, false);
	request.setRequestHeader("Content-Type", contentType);
	request.send(query);
	var response = request.responseText;
    if(response == "true") {
    	alert("You have successfully updated the Email and SMTP tables");
    } else {
    	alert("You failed to update the Email and SMTP tables");
    }
    
	return false;
}


function setupproxy(button) {
	alert(button.form.name)
	var ipaddress = button.form.ipaddress.value;
	var port = button.form.port.value;
	var ptypes = button.form.ptypes.value;
	
	var url = "setupproxy";
	var contentType = "application/x-www-form-urlencoded; charset=UTF-8";
	var query = "proxysetup=yes&ipaddress=" + ipaddress + "&port=" + port + "&ptypes=" + ptypes;
	request.open("POST", url, false);
	request.setRequestHeader("Content-Type", contentType);
	request.send(query);
	var response = request.responseText;
    if(response == "true") {
    	alert("You have successfully updated the Proxy Address table");
    } else {
    	alert("You failed to update the Proxy Address table");
    }
    
	return false;
}

function deleteproxy(button) {
	var ipaddress = button.form.ipaddress.value;
	var port = button.form.port.value;
	var ptypes = button.form.ptypes.value;
	
	var url = "setupproxy";
	var contentType = "application/x-www-form-urlencoded; charset=UTF-8";
	var query = "proxydelete=yes&ipaddress=" + ipaddress + "&port=" + port + "&ptypes=" + ptypes;
	request.open("POST", url, false);
	request.setRequestHeader("Content-Type", contentType);
	request.send(query);
	var response = request.responseText;
    if(response == "true") {
    	alert("You have successfully deleted a row in the Proxy Address table");
    } else {
    	alert("You failed to deleted a row in the Proxy Address table");
    }
    
	return false;
}
