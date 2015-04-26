The aim of this project is to implement an online system to manage car pooling. Users can register for the service. To prevent spam, user registration is safeguarded, for instance by new users having to type in a code displayed in a blurred image, or by sending a confirmation email to users. To facilitate user registration, users can use existing OpenID compliant user accounts (such as blogger ids and yahoo email addresses). Users can add locations, these are points where cars stop to pick up/drop people. Optionally, locations can be associated with maps (google maps, trademe smaps etc). Users can offer rides, and users can browse rides offered by others and accept them. For instance:

John offers a ride for Wednesday 8:30 from Linton school to Massey, back starting at 16:30 from the ecology car park.
James accepts this and meets John at the car park.

Users can register a google calendar with the system. If they do, ride information will be copied automatically to their calendar. Users can then setup the calendar to send them notifications about the rides (like an SMS message or email ½ hour before).

Ride information is kept in a central database. For each user a “social score” is calculated (dream up your own formula) indicating whether the user actively contributes to the car pool or is only leeching.