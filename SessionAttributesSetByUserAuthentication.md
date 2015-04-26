# Introduction #

The purpose of this Wiki is to inform the other members of the team what attributes have been set by the authentication process.


# Details #

When a user is logged in the authentication process sets the following attributes into the session:

  * "user" - a instance of User with data identifying the user including the following information
    1. username
    1. password if they aren't just using OpenId
    1. a set of OpenIds associated with this user, if they are using OpenId to authenticate themselves
    1. phone number
    1. email
    1. member since - the date they first registered
  * "signedin" - set to say this person using this session has been logged in

To check to see if the person using this session is logged in, use the following code.
```
if(session.getAttribute("signedin") != null) {
    //user is logged in
}
```

To retrieve the instance of User held in the attributes of this session, use the following code.
```
User user = (User)session.getAttribute("user");
```

Hope this helps