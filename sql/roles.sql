CREATE TABLE IF NOT EXISTS `roles` (
    `role_id`     INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `name`        VARCHAR(25)
                  NOT NULL
                  COMMENT '角色名称',
    `description` VARCHAR(75)
                  NOT NULL
                  COMMENT '描述',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_roles` (`role_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '角色表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

