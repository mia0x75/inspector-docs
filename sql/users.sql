CREATE TABLE `users`
(
	`user_id`       INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`login`         VARCHAR(25) NOT NULL,
	`password`      CHAR(64) NOT NULL,
	`status`        TINYINT UNSIGNED NOT NULL DEFAULT 1,
	`name`          VARCHAR(25) NOT NULL,
	`email`         VARCHAR(75) NOT NULL,
	`avator`        VARCHAR(75) NOT NULL,
	`creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (`user_id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
