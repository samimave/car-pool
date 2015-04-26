# Introduction #

I will attempt to explain how to use the code I have created.  It's a work in progress and more detail will follow on the other methods in UserManager


# Details #
To get a current users details from the database
```
UserManager manager = new UserManager();
String openid = "http://user.someprovider.com";
User user = null;

try {    
    user = manager.getUserByOpenId(openid);
}catch( InvaildUserNamePassword iunpe ) {
    // there is probably no openid of that id in the database
} catch( IOException ioe ) {
    // a communication problem I think
} catch( SQLException sqle ) {
    // there is some problem with the sql statement whether
    // that be a database end problem or the sql was badly
    // written will be in the message string if you wish to print it.
}
```

To get infomation about the user the following methods maybe useful

```
// To get the username
String username = user.getUserName();

// email
String email = user.getEmail();
// phone number
String phone = user.getPhoneNumber();
// memeber since ie sighnup date
Calendar memberSince = user.getMemberSince();
// A set of the openids associated with this user
Set<String> openidSet = user.getOpenIds();
```
There are other methods, in User as well, but these are the only ones that actually return any useful data at the moment.

Now for getting users data using their username and password you do the following
```
UserManager manager = new UserManager();
String username = "testname";
String password = "password";

User user = null;

try {    
    user = manager.getUserByUsername(username, password);
}catch( InvaildUserNamePassword iunpe ) {
    // there is probably no openid of that id in the database
} catch( IOException ioe ) {
    // a communication problem I think
} catch( SQLException sqle ) {
    // there is some problem with the sql statement whether
    // that be a database end problem or the sql was badly
    // written will be in the message string if you wish to print it.
}

```

To attach a openid to a user do the following

```
UserManager manager = new UserManager();
// first get the unmodified user form the database
User user = null;
try {    
    user = manager.getUserByOpenId("http://user.someprovider.com");
}catch( InvaildUserNamePassword iunpe ) {
    // there is probably no openid of that id in the database
} catch( IOException ioe ) {
    // a communication problem I think
} catch( SQLException sqle ) {
    // there is some problem with the sql statement whether
    // that be a database end problem or the sql was badly
    // written will be in the message string if you wish to print it.
}

// the openid to attach
String openid = "http://user.someotherprovider.com";

try {
    // Attach the new openid to the user passing it as the first parameter, and the user
    // as the last parameter returning the newly modified user with the new openid
    // attached
    User userwithattachedopenid = manager.attachOpenId(openid, user);
} catch( IOException ioe ) {
    // a communication problem I think
} catch( SQLException sqle ) {
    // there is some problem with the sql statement whether
    // that be a database end problem or the sql was badly
    // written will be in the message string if you wish to print it.
}

```

To update a user with UserManager.

This does not support the changing of userName, and may never allow this. The same with userId.

```
//first you must have a valid user from the database in a instance of User
UserManager manager = new UserManager();
User user = null;
try {    
    user = manager.getUserByOpenId("http://user.someprovider.com");
}catch( InvaildUserNamePassword iunpe ) {
    // there is probably no openid of that id in the database
} catch( IOException ioe ) {
    // a communication problem I think
} catch( SQLException sqle ) {
    // there is some problem with the sql statement whether
    // that be a database end problem or the sql was badly
    // written will be in the message string if you wish to print it.
}
// change some details of the user
user.setEmail("somebody@somewhere.com");
user.setPhoneNumber("09 1234567");
User updatedUser = null;
try {
    // now update the user and return the result in updatedUser
    updatedUser = manager.updateUserDetails(user);
}catch( InvaildUserNamePassword iunpe ) {
    // there is probably no openid of that id in the database
} catch( IOException ioe ) {
    // a communication problem I think
} catch( SQLException sqle ) {
    // there is some problem with the sql statement whether
    // that be a database end problem or the sql was badly
    // written will be in the message string if you wish to print it.
}
```