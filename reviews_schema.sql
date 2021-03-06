-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema reviews_schema
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema reviews_schema
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `reviews_schema` DEFAULT CHARACTER SET utf8 ;
USE `reviews_schema` ;

-- -----------------------------------------------------
-- Table `reviews_schema`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reviews_schema`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(256) NULL,
  `last_name` VARCHAR(256) NULL,
  `email` VARCHAR(256) NULL,
  `password` VARCHAR(256) NULL,
  `created_at` DATETIME NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reviews_schema`.`reviews`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reviews_schema`.`reviews` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(256) NULL,
  `content` MEDIUMTEXT NULL,
  `created_at` DATETIME NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  `user_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_reviews_users_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_reviews_users`
    FOREIGN KEY (`user_id`)
    REFERENCES `reviews_schema`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `reviews_schema`.`favorites`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `reviews_schema`.`favorites` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `review_id` INT NOT NULL,
  `created_at` DATETIME NULL DEFAULT NOW(),
  `updated_at` DATETIME NULL DEFAULT NOW() ON UPDATE NOW(),
  PRIMARY KEY (`id`, `user_id`, `review_id`),
  INDEX `fk_users_has_reviews_reviews1_idx` (`review_id` ASC) VISIBLE,
  INDEX `fk_users_has_reviews_users1_idx` (`user_id` ASC) VISIBLE,
  CONSTRAINT `fk_users_has_reviews_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `reviews_schema`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_has_reviews_reviews1`
    FOREIGN KEY (`review_id`)
    REFERENCES `reviews_schema`.`reviews` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
