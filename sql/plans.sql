CREATE TABLE IF NOT EXISTS `plans` (
    `statement_id` INT UNSIGNED
                   NOT NULL
                   COMMENT '主键',
    `value`        TEXT
                   NOT NULL
                   COMMENT '执行计划',
    `version`      INT UNSIGNED
                   NOT NULL
                   COMMENT '版本',
    `update_at`    INT UNSIGNED
                   COMMENT '修改时间',
    `create_at`    INT UNSIGNED
                   NOT NULL
                   COMMENT '创建时间',
    PRIMARY KEY `pk_plans` (`statement_id`)
)
ENGINE = InnoDB
COMMENT = '执行计划表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

