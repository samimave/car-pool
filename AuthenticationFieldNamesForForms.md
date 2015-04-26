# Introduction #

The purpose of this Wiki is to inform the developers of what form field names are neccessary to be present so that the user canbe authenticated using what they typed into the form fields provided.


# Details #

  * OpenId log in form needs the following:
    * the action parameter of the form having a value of "openidlogin" and the method should be "post:, but "get" will work as well
    * a hidden field with the name of "openid\_signin"
    * a text input field with the name of "openid\_url"
> Everything else is optional, but only the above fields are needed.  The hidden field "openid\_signin" maybe dispensed with, as it seems unnecessary for the functionality of the OpenIdConsumer, it's just at the moment that is what it checks for and if not present will just redirect the user back to "index.jsp".

```
<form action="openidlogin" method="post">
  <input name="openid_signin" type="hidden" value="true"/>
  OpenId: <input name="openid_url" type="text"/>
  <input type="submit" value="Login"/>
</form>
```

  * Username and password form needs the following to work
    * the action parameter of the form having a value of "login" and the method should be "post:, but "get" will work as well however the password maybe vissible to others if "get" is used.
    * a hidden field with the name of "normal\_signin"
    * a text input field with the name of "username"
    * a password input field with the name of "userpass"
> Again everything else is optional, and only those fields above will be used for processing the log in.  The "normal\_signin" maybe dipensed with in the future, as it seems unnecessary for the funtionality of the NonOpenIdConsumer, but it's still necessary for it to work.

```
<form action="login" method="post">
  <input type="hidden" name="normal_signin" value="true"/>
  Username: <input type="text" name="username"/>
  Password: <input type="password" name="userpass"/>
  <input type="submit" value="Login"/>
</form>
```