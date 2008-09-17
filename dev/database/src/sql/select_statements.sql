
--select user with rides--
select r.idRide, u.userName, r.rideDate, r.rideStartLocation, r.rideStopLocation, a.availableSeats
FROM User as u, Ride as r
WHERE u.idUser = r.idUser;

--select user with matches--
select r.idRide, u.userName, r.rideDate, r.rideStartLocation, r.rideStopLocation, r.availableSeats
FROM User as u, Ride as r, Matches as m
WHERE u.idUser = m.idUser
AND u.idUser != r.idUser
AND r.idRide = m.idRide;

--select user with carpooles-- (those riding with him/her/it)
select u.userName, um.userName
FROM User as u, Ride as r, Matches as m, User as um
WHERE u.idUser = r.idUser
AND m.idRide = r.idRide
AND um.idUser = m.idUser;

--select ride with available seats--
Select r.idRide, (r.availableSeats - Count(*)) as availableSeats
FROM
	(SELECT r.idRide, u.userName, r.availableSeats
	FROM User as u, Ride as r, Matches as m
	WHERE u.idUser = m.idUser
	AND m.idRide = r.idRide) as r
GROUP BY r.idRide;

--ride with available seats with details--
Select *
FROM
	(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideStartLocation, r.rideStopLocation
	FROM
		(SELECT r.idRide, r.idUser, r.rideDate, r.rideStartLocation, r.rideStopLocation, r.availableSeats
		FROM User as u, Ride as r, Matches as m
		WHERE u.idUser = m.idUser
		AND m.idRide = r.idRide) as r,
	User as u
	WHERE u.idUser = r.idUser
GROUP BY r.idRide) as t
WHERE t.availableSeats > 0;

--SEARCH ride with available seats with details--
SELECT * 
FROM (
	SELECT *
	FROM
		(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideStartLocation, r.rideStopLocation
		FROM
			(SELECT r.idRide, r.idUser, r.rideDate, r.rideStartLocation, r.rideStopLocation, r.availableSeats
			FROM User as u, Ride as r, Matches as m
			WHERE u.idUser = m.idUser
			AND m.idRide = r.idRide) as r,
		User as u
		WHERE u.idUser = r.idUser
	GROUP BY r.idRide) as t
	WHERE t.availableSeats > 0
) as a
WHERE a.username LIKE "%user%name%";

--SEARCH ride with location names--
SELECT * 
FROM (
	SELECT *
	FROM
		(Select r.idRide, u.idUser, u.username,(r.availableSeats - Count(*)) as availableSeats, r.rideDate, r.rideStartLocation, r.rideStopLocation
		FROM
			(SELECT r.idRide, r.idUser, r.rideDate, l.street as rideStartLocation, ll.street as rideStopLocation, r.availableSeats
			FROM User as u, Ride as r, Matches as m, locations as l, locations as ll
			WHERE u.idUser = m.idUser
			AND l.idLocations = r.rideStartLocation
			AND ll.idLocations = r.rideStopLocation
			AND m.idRide = r.idRide) as r,
		User as u
		WHERE u.idUser = r.idUser
		GROUP BY r.idRide) as t
	WHERE t.availableSeats > 0
) as a
WHERE a.username LIKE "%user%name%";

--search locations--

Select idLocations, street
FROM locations
WHERE street LIKE "smi%";
