CREATE TABLE IF NOT EXISTS `statistics` (
    `statistic_id` INT UNSIGNED
                   NOT NULL
                   AUTO_INCREMENT
                   COMMENT '自增主键',
    `name`         VARCHAR(50)
                   NOT NULL
                   COMMENT '统计项目',
    `description`  VARCHAR(75)
                   NOT NULL
                   COMMENT '页面显示',
    `value`        INT UNSIGNED
                   NOT NULL
                   COMMENT '统计计数',
    `enabled`      TINYINT UNSIGNED
                   NOT NULL
                   COMMENT '是否可用',
    `version`      INT UNSIGNED
                   NOT NULL
                   COMMENT '版本',
    `update_at`    INT UNSIGNED
                   COMMENT '修改时间',
    `create_at`    INT UNSIGNED
                   NOT NULL
                   COMMENT '创建时间',
    PRIMARY KEY `pk_statistics` (`statistic_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '统计表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

