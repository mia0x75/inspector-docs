CREATE TABLE IF NOT EXISTS `comments` (
    `comment_id` INT UNSIGNED
                 NOT NULL
                 AUTO_INCREMENT
                 COMMENT '自增主键',
    `content`    TINYTEXT
                 NOT NULL
                 COMMENT '意见建议',
    `version`    INT UNSIGNED
                 NOT NULL
                 COMMENT '版本',
    `update_at`  INT UNSIGNED
                 COMMENT '修改时间',
    `create_at`  INT UNSIGNED
                 NOT NULL
                 COMMENT '创建时间',
    PRIMARY KEY `pk_comments` (`comment_id`)
)
ENGINE = InnoDB
COMMENT = '审核意见表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

