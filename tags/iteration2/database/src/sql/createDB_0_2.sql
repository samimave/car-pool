drop database carpool;

CREATE DATABASE carpool;
USE `carpool`;

-- -----------------------------------------------------
-- Table `carpool`.`User`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `carpool`.`User` (
  `idUser` INT NOT NULL AUTO_INCREMENT ,
  `userName` VARCHAR(45) NOT NULL ,
  `userPasswordHash` VARCHAR(150) NOT NULL ,
  `email` VARCHAR(255) NOT NULL ,
  `mobile_number` VARCHAR(45) NOT NULL ,
  `signUpDate` DATE NOT NULL ,
  PRIMARY KEY (`idUser`),
  UNIQUE KEY (`userName`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`Ride`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `carpool`.`Ride` (
  `idRide` INT NOT NULL AUTO_INCREMENT ,
  `idUser` INT NOT NULL ,
  `availableSeats` INT NOT NULL ,
  `rideStartLocation` MEDIUMTEXT NOT NULL ,
  `rideStopLocation` MEDIUMTEXT NOT NULL ,
  `rideDate` DATE NOT NULL ,
  PRIMARY KEY (`idRide`) ,
  INDEX fk_Ride_User (`idUser` ASC) ,
  CONSTRAINT `fk_Ride_User`
    FOREIGN KEY (`idUser` )
    REFERENCES `carpool`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`Matches`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `carpool`.`Matches` (
  `idTrip` INT NOT NULL AUTO_INCREMENT ,
  `idRide` INT NOT NULL ,
  `idUser` INT NOT NULL ,
  `confirmed` BOOLEAN NOT NULL DEFAULT false ,
  `seatNum` INT NOT NULL ,
  PRIMARY KEY (`idTrip`) ,
  UNIQUE KEY (`idRide`, `seatNum`),
  INDEX idUser (`idUser` ASC) ,
  CONSTRAINT `idRide`
    FOREIGN KEY (`idRide` )
    REFERENCES `carpool`.`Ride` (`idRide` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idUser`
    FOREIGN KEY (`idUser` )
    REFERENCES `carpool`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`user_openids`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `carpool`.`user_openids` (
  `openid_url` VARCHAR(255) NOT NULL ,
  `idUser` INT NOT NULL ,
  PRIMARY KEY (`openid_url`) ,
  INDEX idUser (`idUser` ASC) ,
  CONSTRAINT `openidUser`
    FOREIGN KEY (`idUser` )
    REFERENCES `carpool`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`RideComment`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `carpool`.`RideComment` (
  `idRideComment` INT NOT NULL AUTO_INCREMENT ,
  `idTrip` INT NOT NULL ,
  `comment` TEXT NOT NULL ,
  `rating` INT NOT NULL ,
  PRIMARY KEY (`idRideComment`) ,
  INDEX idTrip (`idTrip` ASC) ,
  CONSTRAINT `idTrip`
    FOREIGN KEY (`idTrip` )
    REFERENCES `carpool`.`Matches` (`idTrip` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;
