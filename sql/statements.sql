CREATE TABLE IF NOT EXISTS `statements` (
    `ticket_id` INT UNSIGNED
                NOT NULL
                COMMENT '所属工单',
    `sequence`  SMALLINT UNSIGNED
                NOT NULL
                COMMENT '序号',
    `sql`       TEXT
                NOT NULL
                COMMENT '单独语句',
    `type`      TINYINT UNSIGNED
                NOT NULL
                COMMENT '类型',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_statements` (`ticket_id`, `sequence`)
)
ENGINE = InnoDB
COMMENT = '工单分解表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

