CREATE TABLE `relations`
(
   `relation_id`   INT UNSIGNED NOT NULL AUTO_INCREMENT
                   COMMENT '自增主键',
   `taxonomy_id`   INT UNSIGNED NOT NULL
                   COMMENT '分类标识',
   `ancestor_id`   INT UNSIGNED NOT NULL
                   COMMENT '先代',
   `descendant_id` INT UNSIGNED NOT NULL
                   COMMENT '后代',
   `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
                   COMMENT '创建时间',
   PRIMARY KEY (`relation_id`)
)
ENGINE=InnoDB
COMMENT='记录系统一对多和多对多关系'
DEFAULT CHARSET=utf8mb4;
