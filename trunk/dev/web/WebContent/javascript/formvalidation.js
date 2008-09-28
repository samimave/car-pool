function  normalLoginInputValidation(form) {
	if(!form.username || !form.userpass || !form.normal_signin) {
		alert('wrong form used, please inform webmaster');
		return false;
	}
	
	if(!form.username.value) {
		alert('Please enter a username');
		return false;
	}
	
	if(!form.userpass.value) {
		alert('Please enter a password');
		return false;
	}
	
	return true;
}

function openidLoginInputValidation(form) {
	if(!form.openid_url || !form.openid_signin) {
		alert('wrong form used, please inform webmaster');
		return false;
	}
	
	if(!form.openid_url.value) {
		alert("Please enter a valid OpenId URL");
		return false;
	}
	
	return true;
}


function normalRegisterFormValidation(form) {
	if(!form.userName || !form.password1 || !form.password2 || !form.email || !form.phone ) {
		alert('wrong form used, please inform webmaster');
		return false;
	}
	
	return true;
}


function openidRegisterFormValidation(form) {
	
	return true;
}