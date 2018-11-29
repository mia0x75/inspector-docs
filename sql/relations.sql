CREATE TABLE IF NOT EXISTS `relations` (
    `relation_id`   INT UNSIGNED
                    NOT NULL
                    AUTO_INCREMENT
                    COMMENT '自增主键',
    `type`          INT UNSIGNED
                    NOT NULL
                    COMMENT '分类标识',
    `ancestor_id`   INT UNSIGNED
                    NOT NULL
                    COMMENT '先代',
    `descendant_id` INT UNSIGNED
                    NOT NULL
                    COMMENT '后代',
    `description`   VARCHAR(75)
                    NOT NULL
                    COMMENT '描述',
    `version`       INT UNSIGNED
                    NOT NULL
                    COMMENT '版本',
    `update_at`     INT UNSIGNED
                    COMMENT '修改时间',
    `create_at`     INT UNSIGNED
                    NOT NULL
                    COMMENT '创建时间',
    PRIMARY KEY `pk_relations` (`relation_id`),
    UNIQUE KEY `unique_1` (`type`, `ancestor_id`, `descendant_id`)
)
ENGINE = InnoDB
COMMENT = '关系表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

