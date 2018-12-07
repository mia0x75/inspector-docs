CREATE TABLE `tasks`
(
   `task_id`       INT UNSIGNED NOT NULL AUTO_INCREMENT
                   COMMENT '自增主键',
   `name`          VARCHAR(25) NOT NULL
                   COMMENT '名称',
   `params`        VARCHAR(64) NOT NULL
                   COMMENT '参数',
   `enabled`       TINYINT,
   `duration`      INT UNSIGNED NOT NULL DEFAULT 1
                   COMMENT '',
   `last_run`      VARCHAR(25) NOT NULL
                   COMMENT '真实名称',
   `next_run`      VARCHAR(75) NOT NULL
                   COMMENT '电子邮件',
   `recurring`     TINYINT UNSIGNED NOT NULL
                   COMMENT '头像',
   `hash`          CHAR(32) NOT NULL DEFAULT
                   COMMENT '创建时间',
   PRIMARY KEY (`task_id`)
)
ENGINE=InnoDB
COMMENT='任务信息'
DEFAULT CHARSET=utf8mb4;

CREATE TABLE `schedules`
(
   `schedule_id`
   `task_id`

)
ENGINE=InnoDB
COMMENT='计划排期'
DEFAULT CHARSET=utf8mb4;

CREATE TABLE `efforts`
(
   `effort_id`
   `schedule_id`
   `status`
   `run_at`
   `exit_at`
   `
)
ENGINE=InnoDB
COMMENT='执行结果'
DEFAULT CHARSET=utf8mb4;

# Hourly m99
# Daily H99m99
# Weekly Weekday W9
# Monthly DayOfMonth M99D99
# Annually M99D9
