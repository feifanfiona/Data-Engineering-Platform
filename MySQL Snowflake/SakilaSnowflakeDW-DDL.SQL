/***********************************************
**                MSc ANALYTICS 
**     DATA ENGINEERING PLATFORMS (MSCA 31012)
** File:   Sakila Snowflake DDL - Assignment 3
** Desc:   Creating the Sakila Snowflake Dimensional model
** Auth:   Shreenidhi Bharadwaj
** Date:   02/24/2019
** ALL RIGHTS RESERVED | DO NOT DISTRIBUTE
************************************************/

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema sakila_snowflake
-- -----------------------------------------------------

CREATE SCHEMA IF NOT EXISTS `sakila_snowflake` DEFAULT CHARACTER SET latin1 ;
USE `sakila_snowflake` ;

-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_actor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_actor` (
  `actor_key` INT(10) NOT NULL AUTO_INCREMENT,
  `actor_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `actor_id` INT(10) NOT NULL,
  `actor_last_name` VARCHAR(45) NOT NULL,
  `actor_first_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`actor_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_actor_last_update` ON `sakila_snowflake`.`dim_actor` (`actor_last_update` ASC);


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_location_country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_location_country` (
  `location_country_key` INT(10) NOT NULL AUTO_INCREMENT,
  `location_country_id` SMALLINT(10) NOT NULL,
  `location_country_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `location_country_name` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`location_country_key`))
ENGINE = InnoDB
AUTO_INCREMENT = 110
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_location_city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_location_city` (
  `location_city_key` INT(10) NOT NULL AUTO_INCREMENT,
  `location_country_key` INT(10) NOT NULL,
  `location_city_name` VARCHAR(50) NOT NULL,
  `location_city_id` SMALLINT(10) NOT NULL,
  `location_city_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`location_city_key`),
  CONSTRAINT `dim_location_country_dim_location_city_fk`
    FOREIGN KEY (`location_country_key`)
    REFERENCES `sakila_snowflake`.`dim_location_country` (`location_country_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 601
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_location_country_dim_location_city_fk` ON `sakila_snowflake`.`dim_location_city` (`location_country_key` ASC);


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_location_address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_location_address` (
  `location_address_key` INT(10) NOT NULL AUTO_INCREMENT,
  `location_city_key` INT(10) NOT NULL,
  `location_address_id` INT(10) NOT NULL,
  `location_address_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `location_address` VARCHAR(64) NOT NULL,
  `location_address_postal_code` VARCHAR(10) NULL DEFAULT NULL,
  PRIMARY KEY (`location_address_key`),
  CONSTRAINT `dim_location_city_dim_location_address_fk`
    FOREIGN KEY (`location_city_key`)
    REFERENCES `sakila_snowflake`.`dim_location_city` (`location_city_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
AUTO_INCREMENT = 604
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_location_city_dim_location_address_fk` ON `sakila_snowflake`.`dim_location_address` (`location_city_key` ASC);


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_customer` (
  `customer_key` INT(8) NOT NULL AUTO_INCREMENT,
  `location_address_key` INT(10) NOT NULL,
  `customer_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customer_id` INT(8) NULL DEFAULT NULL,
  `customer_first_name` VARCHAR(45) NULL DEFAULT NULL,
  `customer_last_name` VARCHAR(45) NULL DEFAULT NULL,
  `customer_email` VARCHAR(50) NULL DEFAULT NULL,
  `customer_active` CHAR(3) NULL DEFAULT NULL,
  `customer_created` DATE NULL DEFAULT NULL,
  `customer_version_number` SMALLINT(5) NULL DEFAULT NULL,
  `customer_valid_from` DATE NULL DEFAULT NULL,
  `customer_valid_through` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`customer_key`),
  CONSTRAINT `dim_location_address_dim_customer_fk`
    FOREIGN KEY (`location_address_key`)
    REFERENCES `sakila_snowflake`.`dim_location_address` (`location_address_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `customer_id` USING BTREE ON `sakila_snowflake`.`dim_customer` (`customer_id` ASC);
CREATE INDEX `dim_customer_last_update` ON `sakila_snowflake`.`dim_customer` (`customer_last_update` ASC);
CREATE INDEX `dim_location_address_dim_customer_fk` ON `sakila_snowflake`.`dim_customer` (`location_address_key` ASC);


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_film` (
  `film_key` INT(8) NOT NULL AUTO_INCREMENT,
  `film_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `film_id` INT(10) NOT NULL,
  `film_title` VARCHAR(64) NOT NULL,
  `film_description` TEXT DEFAULT NULL,
  `film_release_year` SMALLINT(5) DEFAULT NULL,
  `film_language` VARCHAR(20) NOT NULL,
  `film_rental_duration` TINYINT(3) NULL DEFAULT NULL,
  `film_rental_rate` DECIMAL(4,2) NULL DEFAULT NULL,
  `film_duration` INT(8) NULL DEFAULT NULL,
  `film_replacement_cost` DECIMAL(5,2) NULL DEFAULT NULL,
  `film_rating_code` CHAR(5) NULL DEFAULT NULL,
  `film_rating_text` VARCHAR(255) NULL DEFAULT NULL,
  `film_has_trailers` CHAR(4) NULL DEFAULT NULL,
  `film_has_commentaries` CHAR(4) NULL DEFAULT NULL,
  `film_has_deleted_scenes` CHAR(4) NULL DEFAULT NULL,
  `film_has_behind_the_scenes` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_action` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_animation` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_children` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_classics` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_comedy` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_documentary` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_drama` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_family` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_foreign` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_games` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_horror` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_music` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_new` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_scifi` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_sports` CHAR(4) NULL DEFAULT NULL,
  `film_in_category_travel` CHAR(4) NULL DEFAULT NULL,
  PRIMARY KEY (`film_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_film_last_update` ON `sakila_snowflake`.`dim_film` (`film_last_update` ASC);


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_film_actor_bridge`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_film_actor_bridge` (
  `film_key` INT(8) NOT NULL,
  `actor_key` INT(10) NOT NULL,
  `actor_weighing_factor` DECIMAL(3,2) DEFAULT NULL,
  PRIMARY KEY (`film_key`, `actor_key`),
  CONSTRAINT `dim_actor_dim_film_actor_bridge_fk`
    FOREIGN KEY (`actor_key`)
    REFERENCES `sakila_snowflake`.`dim_actor` (`actor_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `dim_film_dim_film_actor_bridge_fk`
    FOREIGN KEY (`film_key`)
    REFERENCES `sakila_snowflake`.`dim_film` (`film_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_actor_dim_film_actor_bridge_fk` ON `sakila_snowflake`.`dim_film_actor_bridge` (`actor_key` ASC);


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_staff` (
  `staff_key` INT(8) NOT NULL AUTO_INCREMENT,
  `staff_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `staff_id` INT(8) NULL DEFAULT NULL,
  `staff_first_name` VARCHAR(45) NULL DEFAULT NULL,
  `staff_last_name` VARCHAR(45) NULL DEFAULT NULL,
  `staff_store_id` INT(8) NULL DEFAULT NULL,
  `staff_version_number` SMALLINT(5) NULL DEFAULT NULL,
  `staff_valid_from` DATE NULL DEFAULT NULL,
  `staff_valid_through` DATE NULL DEFAULT NULL,
  `staff_active` CHAR(3) NULL DEFAULT NULL,
  PRIMARY KEY (`staff_key`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `dim_staff_last_update` ON `sakila_snowflake`.`dim_staff` (`staff_last_update` ASC);


-- -----------------------------------------------------
-- Table `sakila_snowflake`.`dim_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_store` (
  `store_key` INT(8) NOT NULL AUTO_INCREMENT,
  `location_address_key` INT(10) NOT NULL,
  `store_last_update` TIME NOT NULL,
  `store_id` INT(8) NULL DEFAULT NULL,
  `store_manager_staff_id` INT(8) NULL DEFAULT NULL,
  `store_manager_first_name` VARCHAR(45) NULL DEFAULT NULL,
  `store_manager_last_name` VARCHAR(45) NULL DEFAULT NULL,
  `store_version_number` SMALLINT(5) NULL DEFAULT NULL,
  `store_valid_from` DATE NULL DEFAULT NULL,
  `store_valid_through` DATE NULL DEFAULT NULL,
  PRIMARY KEY (`store_key`),
  CONSTRAINT `dim_location_address_dim_store_fk`
    FOREIGN KEY (`location_address_key`)
    REFERENCES `sakila_snowflake`.`dim_location_address` (`location_address_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

CREATE INDEX `store_id` USING BTREE ON `sakila_snowflake`.`dim_store` (`store_id` ASC);
CREATE INDEX `dim_store_last_update` ON `sakila_snowflake`.`dim_store` (`store_last_update` ASC);
CREATE INDEX `dim_location_address_dim_store_fk` ON `sakila_snowflake`.`dim_store` (`location_address_key` ASC);

CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`dim_date` (
  `date_Id` BIGINT(20) NOT NULL,
  `date` DATE NOT NULL,
  `timestamp` BIGINT(20) NULL DEFAULT NULL,
  `weekend` CHAR(10) NOT NULL DEFAULT 'Weekday',
  `day_of_week` CHAR(10) NULL DEFAULT NULL,
  `month` CHAR(10) NULL DEFAULT NULL,
  `month_day` INT(11) NULL DEFAULT NULL,
  `year` INT(11) NULL DEFAULT NULL,
  `week_starting_monday` CHAR(2) NULL DEFAULT NULL,
  PRIMARY KEY (`date_Id`),
  UNIQUE INDEX `date` (`date` ASC),
  INDEX `year_week` (`year` ASC, `week_starting_monday` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `sakila_snowflake`.`numbers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`numbers` (
  `number` BIGINT(20) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `sakila_snowflake`.`numbers_small`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`numbers_small` (
  `number` INT(11) NULL DEFAULT NULL)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



#Create table 'Fact_rental'
-- -----------------------------------------------------
-- Table `sakila_snowflake`.`fact_rental`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_snowflake`.`fact_rental` (
  `rental_id` INT(10) NOT NULL AUTO_INCREMENT,
  `rental_last_update` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `customer_key` INT(8) NOT NULL,
  `staff_key` INT(8) NOT NULL,
  `film_key` INT(8) NOT NULL,
  `store_key` INT(8) NOT NULL,
  `rental_date_key` BIGINT(20) NULL DEFAULT NULL,
  `return_date_key` BIGINT(20) NULL DEFAULT NULL,
  `count_returns` INT(10),
  `count_rentals` INT(8),
  `rental_duration` INT(10),
  `dollar_amount` float,
  
  PRIMARY KEY (`rental_id`),
  
	#constraint `fk_fact_cust`
    FOREIGN KEY (`customer_key`)
    REFERENCES `sakila_snowflake`.`dim_customer` (`customer_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
    #constraint `fk_fact_staff`
    FOREIGN KEY (`staff_key`)
    REFERENCES `sakila_snowflake`.`dim_staff` (`staff_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
    #constraint `fk_fact_film`
    FOREIGN KEY (`film_key`)
    REFERENCES `sakila_snowflake`.`dim_film` (`film_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
    #constraint `fk_fact_store`
    FOREIGN KEY (`store_key`)
    REFERENCES `sakila_snowflake`.`dim_store` (`store_key`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
    
    #constraint `fk_fact_date`
    FOREIGN KEY (`rental_date_key`)
    REFERENCES `sakila_snowflake`.`dim_date` (`date_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
    
    )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

-- -----------------------------------------------------
-- Table `sakila_snowflake`.`fact_rental`
-- Write Fact table fact_rental DDL script here
-- -----------------------------------------------------

CREATE INDEX `dim_store_fact_rental_fk` ON `sakila_snowflake`.`fact_rental` (`store_key` ASC);
CREATE INDEX `dim_staff_fact_rental_fk` ON `sakila_snowflake`.`fact_rental` (`staff_key` ASC);
CREATE INDEX `dim_film_fact_rental_fk` ON `sakila_snowflake`.`fact_rental` (`film_key` ASC);
CREATE INDEX `dim_customer_fact_rental_fk` ON `sakila_snowflake`.`fact_rental` (`customer_key` ASC);


#CREATE INDEX `dim_location_city_dim_location_address_fk` ON `sakila_snowflake`.`fact_rental` (`rental_id` ASC);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;