CREATE TABLE IF NOT EXISTS `glossaries` (
    `catalog`     VARCHAR(25)
                  NOT NULL
                  COMMENT '分类目录',
    `iota`        TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '值枚举',
    `name`        VARCHAR(50)
                  NOT NULL
                  COMMENT '值名称',
    `description` VARCHAR(150)
                  NOT NULL
                  COMMENT '值描述',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_glossaries` (`catalog`, `iota`)
)
ENGINE = InnoDB
COMMENT = '字典表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

