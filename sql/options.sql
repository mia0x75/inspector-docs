CREATE TABLE IF NOT EXISTS `options` (
    `option_id`   INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `group`       VARCHAR(25)
                  NOT NULL
                  COMMENT '配置分组',
    `name`        VARCHAR(50)
                  NOT NULL
                  COMMENT '配置项',
    `value`       TINYTEXT
                  NOT NULL
                  COMMENT '配置值',
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
    PRIMARY KEY `pk_options` (`option_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '配置表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

INSERT INTO `options` (`group`, `name`, `value`, `description`, `version`, `create_at`) VALUES
# 邮件
('smtp', 'smtp.enabled',    'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.host',       'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.port',       'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.user',       'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.password',   'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.encryption', 'none', '', 1, UNIX_TIMESTAMP()),

# 认证
('ldap', 'ldap.enabled',    'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.host',       'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.domain',     'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.type',       'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.user',       'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.password',   'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.sc',         'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.ou',         'true', '', 1, UNIX_TIMESTAMP())

;

