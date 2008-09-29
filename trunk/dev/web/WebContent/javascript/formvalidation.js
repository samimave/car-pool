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
	
	if(!form.userName.value) {
		alert("Please enter a username")
		return false;
	}
	
	if(!form.email.value) {
		alert("please enter a email");
		return false;
	}
	
	if(form.password1.value != form.password2.value) {
		alert("Passwords must match");
		return false;
	}
	
	if(!form.password1.value || !form.password2.value) {
		alert("Please enter a password and verify it by entering it again in the second password input");
		return false;
	}
	
	return true;
}


function openidRegisterFormValidation(form) {
	if(!form.userName || !form.email || !form.phone) {
		alert("wrong form used, please inform webmaster");
		return false;
	}
	
	if(!form.userName.value) {
		alert("please enter a username");
		return false;
	}
	
	
	if(!form.email.value) {
		alert("please enter a email");
		return false;
	}
	
	return true;
}