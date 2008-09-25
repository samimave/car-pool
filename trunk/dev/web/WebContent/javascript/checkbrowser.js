function checkCookiesEnabled() {
	var cookieEnabled = (navigator.cookieEnabled)? true : false;

	//if does not have navigator.cookiesEnabled (must be a old browser)
	if (typeof navigator.cookieEnabled=="undefined" && !cookieEnabled){ 
		document.cookie="testcookie";
		cookieEnabled=(document.cookie.indexOf("testcookie")!=-1)? true : false;
	}
	
	return cookieEnabled;
}


function getCookiesDisabledMessage() {
	return "<h3>Cookies Disabled</h3><p><strong>Your browser has disabled cookies.  To log in to this site you need to enable cookies.</strong></p>";
}

function runBrowserTests() {
	if(!checkCookiesEnabled()) {
		document.writeln(getCookiesDisabledMessage());
	}
}

function formCookieCheck() {
	if(!checkCookiesEnabled()) {
		alert("Cookies must be enabled to log in")
		return false;
	}
	
	return true;
}