CREATE TABLE `rules`
(
   `rule_id`     INT UNSIGNED NOT NULL AUTO_INCREMENT
                 COMMENT '自增主键',
   `name`        VARCHAR(50) NOT NULL
                 COMMENT '规则名称',
   `description` TINYTEXT NOT NULL
                 COMMENT '规则说明',
   `valid`       TINYINT UNSIGNED NOT NULL DEFAULT 1
                 COMMENT '是否有效',
   `mandatory`   TINYINT UNSIGNED NOT NULL DEFAULT 1
                 COMMENT '是否强制',
   PRIMARY KEY (`rule_id`)
)
ENGINE=InnoDB
COMMENT='审核规则配置，需要进一步细化'
DEFAULT CHARSET=utf8mb4;
