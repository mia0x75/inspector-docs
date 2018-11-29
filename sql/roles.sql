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


INSERT INTO `roles` (`name`, `description`, `version`, `create_at`) VALUES
('root',      '系统管理员',         1, UNIX_TIMESTAMP()),
('dba',       '高级审核',           1, UNIX_TIMESTAMP()),
('reviewer',  '普通审核',           1, UNIX_TIMESTAMP()),
('developer', '数据查询及工单提交', 1, UNIX_TIMESTAMP()),
('viewer',    '查询用户',           1, UNIX_TIMESTAMP()),
('guest',     '来宾账号',           1, UNIX_TIMESTAMP())
;
