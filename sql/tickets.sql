CREATE TABLE `tickets`
(
	`ticket_id`     INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`server_id`     INT UNSIGNED NOT NULL,
	`subject`       VARCHAR(50) NOT NULL,
	`content`       TEXT NOT NULL,
	`user_id`       INT UNSIGNED NOT NULL,
	`reviewer_id`   INT UNSIGNED NOT NULL,
	`status`        TINYINT UNSIGNED NOT NULL,
	`creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP(),
	PRIMARY KEY (`ticket_id`)
)
ENGINE=InnoDB
DEFAULT CHARSET=utf8mb4;
