CREATE TABLE IF NOT EXISTS `resources` (
    `resource_id` INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `url_pattern` VARCHAR(100)
                  NOT NULL
                  COMMENT '资源名称',
    `method`      VARCHAR(10)
                  NOT NULL
                  COMMENT '请求方式',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_resources` (`resource_id`),
    UNIQUE KEY `unique_1` (`url_pattern`, `method`)
)
ENGINE = InnoDB
COMMENT = '资源表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

