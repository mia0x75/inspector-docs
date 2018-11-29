CREATE TABLE IF NOT EXISTS `rules` (
    `rule_id`     INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `group`       VARCHAR(25)
                  NOT NULL
                  COMMENT '规则名称',
    `name`        VARCHAR(75)
                  NOT NULL
                  COMMENT '规则名称',
    `description` VARCHAR(75)
                  NOT NULL
                  COMMENT '规则描述',
    `level`       TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '验证顺序',
    `operator`    VARCHAR(10)
                  NOT NULL
                  COMMENT '比较符',
    `values`      VARCHAR(150)
                  NOT NULL
                  COMMENT '有效值',
    `bitwise`     TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '是否可用',
    `message`     VARCHAR(150)
                  NOT NULL
                  COMMENT '错误提示',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_rules` (`rule_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '规则表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

