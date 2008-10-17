SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `carpool` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `carpool`;

-- -----------------------------------------------------
-- Table `carpool`.`User`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`User` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`User` (
  `idUser` INT NOT NULL AUTO_INCREMENT ,
  `userName` VARCHAR(45) NOT NULL ,
  `userPasswordHash` VARCHAR(150) NOT NULL ,
  `email` VARCHAR(255) NOT NULL ,
  `mobile_number` VARCHAR(45) NOT NULL ,
  `signUpDate` DATE NOT NULL ,
  PRIMARY KEY (`idUser`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`Ride`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`Ride` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`Ride` (
  `idRide` INT NOT NULL AUTO_INCREMENT ,
  `idUser` INT NOT NULL ,
  `availableSeats` INT NOT NULL ,
  `rideStartLocation` MEDIUMTEXT NOT NULL ,
  `rideStopLocation` MEDIUMTEXT NOT NULL ,
  `rideDate` DATE NOT NULL ,
  `rideTime` MEDIUMTEXT NOT NULL,
  `rideReoccur` INT NOT NULL ,
  `rideComment` MEDIUMTEXT NOT NULL ,
  PRIMARY KEY (`idRide`) ,
  INDEX fk_Ride_User (`idUser` ASC) ,
  CONSTRAINT `fk_Ride_User`
    FOREIGN KEY (`idUser` )
    REFERENCES `carpool`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`regions`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`regions` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`regions` (
  `idRegions` INT NOT NULL AUTO_INCREMENT ,
  `name` TEXT NOT NULL ,
  PRIMARY KEY (`idRegions`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`locations`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`locations` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`locations` (
  `idLocations` INT NOT NULL AUTO_INCREMENT ,
  `idRegion` INT NOT NULL ,
  `street` TEXT NOT NULL ,
  PRIMARY KEY (`idLocations`) ,
  INDEX idRegion (`idRegion` ASC) ,
  CONSTRAINT `idRegion`
    FOREIGN KEY (`idRegion` )
    REFERENCES `carpool`.`regions` (`idRegions` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`Matches`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`Matches` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`Matches` (
  `idTrip` INT NOT NULL AUTO_INCREMENT ,
  `idRide` INT NOT NULL ,
  `idUser` INT NOT NULL ,
  `confirmed` BOOLEAN NOT NULL DEFAULT false ,
  `seatNum` INT NOT NULL ,
  `idLocation` INT NOT NULL ,
  `streetNumber` TEXT NULL ,
  PRIMARY KEY (`idTrip`) ,
  INDEX idRide (`idRide` ASC) ,
  INDEX idUser (`idUser` ASC) ,
  INDEX idLocation (`idLocation` ASC) ,
  CONSTRAINT `idRidefk`
    FOREIGN KEY (`idRide` )
    REFERENCES `carpool`.`Ride` (`idRide` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idUserfk`
    FOREIGN KEY (`idUser` )
    REFERENCES `carpool`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `idLocationfk`
    FOREIGN KEY (`idLocation` )
    REFERENCES `carpool`.`locations` (`idLocations` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`user_openids`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`user_openids` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`user_openids` (
  `openid_url` VARCHAR(255) NOT NULL ,
  `idUser` INT NOT NULL ,
  PRIMARY KEY (`openid_url`) ,
  INDEX idUser (`idUser` ASC) ,
  CONSTRAINT `idUserfkfk`
    FOREIGN KEY (`idUser` )
    REFERENCES `carpool`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`RideComment`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`RideComment` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`RideComment` (
  `idRideComment` INT NOT NULL AUTO_INCREMENT ,
  `idTrip` INT NOT NULL ,
  `comment` TEXT NOT NULL ,
  `rating` INT NOT NULL ,
  PRIMARY KEY (`idRideComment`) ,
  INDEX idTrip (`idTrip` ASC) ,
  CONSTRAINT `idTripfk`
    FOREIGN KEY (`idTrip` )
    REFERENCES `carpool`.`Matches` (`idTrip` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `carpool`.`Comments`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`Comments` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`Comments` (
  `idComment` INT NOT NULL AUTO_INCREMENT ,
  `idUser` INT NOT NULL ,
  `idTrip` INT NOT NULL ,
  `comment` TEXT NOT NULL ,
  `comm_time` TIMESTAMP ,
  PRIMARY KEY (`idComment`) ,
  INDEX idUser (`idUser` ASC) ,
  CONSTRAINT `idUserfkfkfk` FOREIGN KEY (`idUser` ) REFERENCES `carpool`.`User` (`idUser` ) ON DELETE NO ACTION ON UPDATE NO ACTION
--  ,CONSTRAINT `idTripfkfk` FOREIGN KEY (`idTrip` ) REFERENCES `carpool`.`Matches` (`idTrip` ) ON DELETE NO ACTION ON UPDATE NO ACTION
)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
