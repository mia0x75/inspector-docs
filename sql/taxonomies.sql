CREATE TABLE `taxonomies`
(
   `taxonomy_id` INT UNSIGNED NOT NULL AUTO_INCREMENT
                 COMMENT '自增主键',
   `name`        VARCHAR(50) NOT NULL
                 COMMENT '分类名称',
   `description` VARCHAR(75) NOT NULL
                 COMMENT '分类描述',
   PRIMARY KEY (`taxonomy_id`)
)
ENGINE=InnoDB
COMMENT='分类信息'
DEFAULT CHARSET=utf8mb4;
