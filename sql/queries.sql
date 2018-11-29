CREATE TABLE IF NOT EXISTS `queries` (
    `query_id`  INT UNSIGNED
                NOT NULL
                COMMENT '主键',
    `sql`       TEXT
                NOT NULL
                COMMENT '执行SQL',
    `plan`      TEXT
                NOT NULL
                COMMENT '执行计划',
    `owner_id`  INT UNSIGNED
                NOT NULL
                COMMENT '发起人',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_queries` (`query_id`),
    INDEX `index_1` (`owner_id`)
)
ENGINE = InnoDB
COMMENT = '查询表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

