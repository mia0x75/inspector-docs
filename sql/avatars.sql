CREATE TABLE IF NOT EXISTS `avatars` (
    `avatar_id` INT UNSIGNED
                NOT NULL
                AUTO_INCREMENT
                COMMENT '自增主键',
    `url`       VARCHAR(75)
                NOT NULL
                COMMENT '头像位置',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_avatars` (`avatar_id`),
    UNIQUE KEY `unique_1` (`url`)
)
ENGINE = InnoDB
COMMENT = '头像表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

INSERT INTO `avatars` (`url`, `version`, `create_at`) VALUES
('/assets/images/avatars/01.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/02.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/03.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/04.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/05.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/06.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/07.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/08.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/09.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/10.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/11.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/12.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/13.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/14.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/15.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/16.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/17.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/18.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/19.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/20.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/21.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/22.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/23.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/24.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/25.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/26.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/27.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/28.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/29.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/30.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/31.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/32.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/33.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/34.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/35.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/36.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/37.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/38.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/39.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/40.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/41.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/42.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/43.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/44.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/45.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/46.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/47.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/48.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/49.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/50.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/51.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/52.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/53.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/54.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/55.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/56.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/57.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/58.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/59.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/60.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/61.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/62.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/63.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/64.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/65.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/66.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/67.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/68.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/69.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/70.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/71.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/72.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/73.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/74.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/75.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/76.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/77.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/78.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/79.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/80.png', 1, UNIX_TIMESTAMP()),
('/assets/images/avatars/81.png', 1, UNIX_TIMESTAMP());

