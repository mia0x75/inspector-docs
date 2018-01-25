CREATE TABLE `users`
(
   `user_id`       INT UNSIGNED NOT NULL AUTO_INCREMENT
                   COMMENT '自增主键',
   `login`         VARCHAR(25) NOT NULL
                   COMMENT '登录名称',
   `password`      BINARY(48) NOT NULL
                   COMMENT '密码',
   `status`        TINYINT UNSIGNED NOT NULL DEFAULT 1
                   COMMENT '状态',
   `name`          VARCHAR(25) NOT NULL
                   COMMENT '真实名称',
   `email`         VARCHAR(75) NOT NULL
                   COMMENT '电子邮件',
   `avator`        VARCHAR(75) NOT NULL
                   COMMENT '头像',
   `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
                   COMMENT '创建时间',
   PRIMARY KEY (`user_id`)
)
ENGINE=InnoDB
COMMENT='用户列表，密码采用哈希存储'
DEFAULT CHARSET=utf8mb4;
