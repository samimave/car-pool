Check out "trunk/dev/web/" as a dynamic website named "Car Pool Project" in Eclipse 3.4.0

Check out "trunk/dev/database" as a Java project


## Car Pool Project ##

Right click on "Car Pool Project" -> build path -> configure build path..

Under "Projects" Tab added "database" project
Under "Source" Tab make sure "Car Pool Project/src" is in the list.  Add if not.

Under Libraries Tab click add Library -> Junit -> JUnit 4 -> Finish

Click on "Java EE Module Dependencies" on the left menu,
Tick "database".

## Database Project ##

Right click on "Car Pool Project" -> build path -> configure build path..
Under Libraries Tab click add Library -> Junit -> JUnit 3 -> Finish

Under "Source" Tab make sure "database/src" is in the list.  Add if not.

Right click on "lib/mysql-connector-java-5.1.6.jar" -> build path -> add to build path.  Note you have to be in Java Persective to do this.

## Finally ##
Menu Bar -> Project -> Clean.. -> OK (clean all projects).

That should get ride of all the errors that are currently showing.

Assuming you have installed mySQL log in as root or another user. Copy the contents of createDB\_0\_32 from trunk/dev/database/src/sql into the mySQL command line and this should create most of the tables, Then copy the contents of create-proxy-tables.sql then insert\_proxy\_data.sql then email.sql and finally smtp.sql to create and populate certain tables.

Now right-click index.jsp and select Run On Server. The webpage should run for you on your local host.

mySQL Connection -
It is essential to ensure that the user and password you used to log into mySQL is the same as what is in the data.properties file in trunk/dev/database. Change it if it isn’t.

Google Keys -
Also if the google map is not displaying for you it is likely because you do not have the correct Google Key. In the following pages:
addARide, displayResultsMaps, displayRouteMap, displayRouteMap2, myRideEdit and searchRides in the comments the local key and massey key have been specified. If you are running the site on your own machine change all the google keys to the local host one:
localhost key - ABQIAAAA7rDxBnSa8ztdEea-bXHUqRRKOMZEnoyerBNNN7XbrW5T80f1pxRxpg7l2VcFxiQk2L5RouYsGk3NqQ
The massey key for the site (http://seat-projects1:8080/Car_Pool_Project/) is
ABQIAAAAwEEggV\_Hd8onlfSgA\_kgZBTz-RVM6WN\_1Yrxj3B45o6dXx3SPxRBd9zQMOS18U6DzRdS0kg6JbFdlA

To get a Google Key for your own site do the following -
1) Go to this google web site http://code.google.com/apis/base/signup.html
2) Enter your address in the http:// box.
3) Click sign me up