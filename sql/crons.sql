CREATE TABLE IF NOT EXISTS `crons` (
    `cron_id`   INT UNSIGNED
                NOT NULL
                AUTO_INCREMENT
                COMMENT '自增主键',
    `status`    CHAR(1)
                NOT NULL
                COMMENT '执行状态',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_crons` (`cron_id`)
)
ENGINE = InnoDB
COMMENT = '调度表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

