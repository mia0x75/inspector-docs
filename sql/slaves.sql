CREATE TABLE `slaves`
(
   `slave_id`      INT UNSIGNED NOT NULL AUTO_INCREMENT
                   COMMENT '自增主键',
   `server_id`     INT UNSIGNED NOT NULL
                   COMMENT '对应主库',
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
   PRIMARY KEY (`slave_id`)
)
ENGINE=InnoDB
COMMENT='从库服务器及登录信息，仅支持一级主从关系，如果配置有从库，那么查询发送到从库执行，同时考虑集成gh-ost工具'
DEFAULT CHARSET=utf8mb4;
