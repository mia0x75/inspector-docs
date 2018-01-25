CREATE TABLE `tickets`
(
   `ticket_id`     INT UNSIGNED NOT NULL AUTO_INCREMENT
                   COMMENT '自增主键',
   `master_id`     INT UNSIGNED NOT NULL
                   COMMENT '目标机器',
   `subject`       VARCHAR(50) NOT NULL
                   COMMENT '主题',
   `content`       TEXT NOT NULL
                   COMMENT '更新语句',
   `user_id`       INT UNSIGNED NOT NULL
                   COMMENT '提交人',
   `reviewer_id`   INT UNSIGNED NOT NULL
                   COMMENT '审核人',
   `status`        TINYINT UNSIGNED NOT NULL
                   COMMENT '状态',
   `creation_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP()
                   COMMENT '创建时间',
   PRIMARY KEY (`ticket_id`)
)
ENGINE=InnoDB
COMMENT='工单列表，有待进一步细化'
DEFAULT CHARSET=utf8mb4;
