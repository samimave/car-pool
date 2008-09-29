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
            	output.innerHTML = " Username is not available";
            } else {
            	output.innerHTML = " :" + request.responseText;
            }
        }
    }
}