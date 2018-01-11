CREATE TABLE `servers` (
   `server_id`     INT UNSIGNED NOT NULL AUTO_INCREMENT
                   COMMENT '自增主键',
   `host`          INT UNSIGNED NOT NULL
                   COMMENT '主机地址',
   `port`          SMALLINT UNSIGNED NOT NULL
                   COMMENT '端口',
   `user`          VARCHAR(25) NOT NULL
                   COMMENT '连接用户',
   `password`      VARCHAR(75) NOT NULL
                   COMMENT '密码',
   `status`        TINYINT UNSIGNED NOT NULL DEFAULT 1
                   COMMENT '状态',
   `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
                   COMMENT '创建时间',
   PRIMARY KEY (`server_id`)
)
ENGINE=InnoDB
COMMENT='服务器及登录信息，用户和密码采用加密存储'
DEFAULT CHARSET=utf8mb4;
