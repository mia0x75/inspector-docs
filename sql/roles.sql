CREATE TABLE `roles`
(
   `role_id`     INT UNSIGNED NOT NULL AUTO_INCREMENT
                 COMMENT '自增主键',
   `name`        VARCHAR(50) NOT NULL
                 COMMENT '角色名称',
   `description` VARCHAR(75) NOT NULL
                 COMMENT '描述',
   PRIMARY KEY (`role_id`)
)
ENGINE=InnoDB
COMMENT='系统角色，内置角色，不可更改'
DEFAULT CHARSET=utf8mb4;
