CREATE TABLE IF NOT EXISTS `statements` (
    `statement_id` INT UNSIGNED
                   NOT NULL
                   AUTO_INCREMENT
                   COMMENT '自增主键',
    `sql`          TEXT
                   NOT NULL
                   COMMENT '单独语句',
    `type`         TINYINT UNSIGNED
                   NOT NULL
                   COMMENT '类型',
    `ticket_id`    INT UNSIGNED
                   NOT NULL
                   COMMENT '所属工单',
    `version`      INT UNSIGNED
                   NOT NULL
                   COMMENT '版本',
    `update_at`    INT UNSIGNED
                   COMMENT '修改时间',
    `create_at`    INT UNSIGNED
                   NOT NULL
                   COMMENT '创建时间',
    PRIMARY KEY `pk_statements` (`statement_id`),
    INDEX `index_1` (`ticket_id`)
)
ENGINE = InnoDB
COMMENT = '工单分解表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

