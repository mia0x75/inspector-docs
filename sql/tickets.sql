CREATE TABLE IF NOT EXISTS `tickets` (
    `ticket_id`   INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `subject`     VARCHAR(50)
                  NOT NULL
                  COMMENT '主题',
    `content`     VARCHAR(100)
                  NOT NULL
                  COMMENT '更新语句',
    `status`      TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '状态',
    `owner_id`    INT UNSIGNED
                  NOT NULL
                  COMMENT '申请人',
    `instance_id` INT UNSIGNED
                  NOT NULL
                  COMMENT '目标群集',
    `reviewer_id` INT UNSIGNED
                  NOT NULL
                  COMMENT '审核人',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_tickets` (`ticket_id`),
    KEY `index_1` (`owner_id`),
    KEY `index_2` (`instance_id`),
    KEY `index_3` (`reviewer_id`)
)
ENGINE = InnoDB
COMMENT = '工单表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

