CREATE TABLE `options`
(
	`option_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name`      VARCHAR(50) NOT NULL,
	`value`     TINYTEXT NOT NULL,
	PRIMARY KEY (`option_id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;