CREATE TABLE IF NOT EXISTS `users` (
    `user_id`   INT UNSIGNED
                NOT NULL
                AUTO_INCREMENT
                COMMENT '自增主键',
    `email`     VARCHAR(75)
                NOT NULL
                COMMENT '电子邮件',
    `password`  CHAR(60)
                NOT NULL
                COMMENT '密码',
    `status`    TINYINT UNSIGNED
                NOT NULL
                COMMENT '状态',
    `name`      VARCHAR(15)
                NOT NULL
                COMMENT '真实名称',
    `avatar_id` INT UNSIGNED
                NOT NULL
                COMMENT '头像',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_users` (`user_id`),
    UNIQUE KEY `unique_1` (`email`)
)
ENGINE = InnoDB
COMMENT = '用户表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;


INSERT INTO `mm_users` (`email`, `password`, `status`, `name`, `avatar_id`, `version`, `create_at`) VALUES
('root@localhost', '$2a$10$YARNH/Rs3XDY/fdsE02T/OsGFN5fcZydPG.KQAhklup6TVLjaQg82', 1, 'root', 1, 1, UNIX_TIMESTAMP())
;
