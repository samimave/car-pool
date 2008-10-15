drop table if exists carpool.proxyaddress;

create table if not exists carpool.proxyaddress (
 ipaddress varchar(50) not null,
 port int not null,
 ptypes varchar(50) not null,
 primary key(ipaddress, port)
) ENGINE = InnoDB;

#drop table if exists carpool.proxyuser;

#create table if not exists carpool.proxyuser (
#  username varchar(40) not null,
#  password varchar(40) not null,
#  primary key(username)
#) ENGINE = InnoDB;