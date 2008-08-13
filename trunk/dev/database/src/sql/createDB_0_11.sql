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
  `signUpDate` DATE NOT NULL ,
  `ridesGiven` INT NOT NULL DEFAULT 0 ,
  `ridesTaken` INT NOT NULL DEFAULT 0 ,
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
  PRIMARY KEY (`idRide`) ,
  CONSTRAINT `fk_Ride_User`
    FOREIGN KEY (`idUser` )
    REFERENCES `carpool`.`User` (`idUser` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX fk_Ride_User ON `carpool`.`Ride` (`idUser` ASC) ;


-- -----------------------------------------------------
-- Table `carpool`.`RideReport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`RideReport` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`RideReport` (
  `idRideReport` INT NOT NULL AUTO_INCREMENT ,
  `idRide` INT NOT NULL ,
  PRIMARY KEY (`idRideReport`) ,
  CONSTRAINT `fk_RideReport_Ride`
    FOREIGN KEY (`idRide` )
    REFERENCES `carpool`.`Ride` (`idRide` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE INDEX fk_RideReport_Ride ON `carpool`.`RideReport` (`idRide` ASC) ;


-- -----------------------------------------------------
-- Table `carpool`.`Matches`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `carpool`.`Matches` ;

CREATE  TABLE IF NOT EXISTS `carpool`.`Matches` (
  `idTrip` INT NOT NULL AUTO_INCREMENT ,
  `idRide` INT NOT NULL ,
  `idUser` INT NOT NULL ,
  `confirmed` BOOLEAN NOT NULL DEFAULT false ,
  PRIMARY KEY (`idTrip`) ,
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

CREATE INDEX idRide ON `carpool`.`Matches` (`idRide` ASC) ;

CREATE INDEX idUser ON `carpool`.`Matches` (`idUser` ASC) ;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
