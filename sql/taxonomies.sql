CREATE TABLE `taxonomies`
(
	`taxonomy_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`name`        VARCHAR(50) NOT NULL,
	`description` VARCHAR(75) NOT NULL,
	PRIMARY KEY (`taxonomy_id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
