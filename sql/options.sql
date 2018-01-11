CREATE TABLE `options`
(
   `option_id` INT UNSIGNED NOT NULL AUTO_INCREMENT
               COMMENT '自增主键',
   `name`      VARCHAR(50) NOT NULL
               COMMENT '配置项',
   `value`     TINYTEXT NOT NULL
               COMMENT '配置值',
   PRIMARY KEY (`option_id`)
)
ENGINE=InnoDB
COMMENT='系统选项，建值对'
DEFAULT CHARSET=utf8mb4;
