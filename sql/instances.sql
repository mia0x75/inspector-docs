CREATE TABLE IF NOT EXISTS `instances` (
    `instance_id` INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `host`        VARCHAR(150)
                  NOT NULL
                  COMMENT '主机名称',
    `alias`       VARCHAR(75)
                  NOT NULL
                  COMMENT '主机别名',
    `ip`          INT UNSIGNED
                  NOT NULL
                  COMMENT '主机地址',
    `port`        INT UNSIGNED
                  NOT NULL
                  DEFAULT 3306
                  COMMENT '端口',
    `user`        VARCHAR(50)
                  NOT NULL
                  COMMENT '连接用户',
    `password`    VARBINARY(48)
                  NOT NULL
                  COMMENT '密码',
    `status`      TINYINT UNSIGNED
                  NOT NULL
                  DEFAULT 1
                  COMMENT '状态',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_instances` (`instance_id`),
    UNIQUE KEY `unique_1` (`host`, `port`),
    UNIQUE KEY `unique_2` (`ip`, `port`),
    UNIQUE KEY `unique_3` (`alias`)
)
ENGINE = InnoDB
COMMENT = '实例表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

