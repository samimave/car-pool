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
    request.onreadystatechange = callback;
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
    request.onreadystatechange = callback;
    request.send( null );
}

function callback() {
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