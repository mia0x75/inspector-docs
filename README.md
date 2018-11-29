## SQL查询审核系统

### 系统结构的初步设想：
![image](http://oi68.tinypic.com/1589zkx.jpg)

## 存储设计

### 系统角色说明：

| 系统角色  | 说明       | 权限                                   |
|:----------|:-----------|:---------------------------------------|
| guest     | 访客       | 只能留在登录页面                       |
| viewer    | 查询用户   | 只能提交查询语句                       |
| developer | 提交       | 可以查询，可以提交修改                 |
| reviewer  | 普通审核   | 只能审核DML工单，含有DDL的工单禁止审核 |
| dba       | 高级审核   | 可以审核所有工单                       |
| root      | 系统管理员 | 只能管理服务器、用户、权限、工单、设置 |


### 系统表说明（后续可能会统一增加前缀）：

| 表名                                       | 说明                                                                |
|:-------------------------------------------|:--------------------------------------------------------------------|
| [01. avatars](#表名avatars)                | 用户头像表                                                          |
| [02. comments](#表名comments)              | 审核意见建议表                                                      |
| [03. crons - 二期待完成](#表名crons)       | 预约任务表                                                          |
| [04. glossaries](#表名glossaries)          | 查找表                                                              |
| [05. instances](#表名instances)            | 服务器及登录信息，密码加密存储                                      |
| [06. options](#表名options)                | 系统选项，键值对                                                    |
| [07. plans - 二期待完成](#表名plans)       | 存储statements.sql对应的执行计划                                    |
| [08. queries](#表名queries)                | 用户的普通SELECT查询记录，单条执行，只记录执行的，审核不通过的忽略  |
| [09. relations](#表名relations)            | 记录系统多对多关系                                                  |
| [10. resources](#表名resources)            | 系统资源，与角色通过relations关联处理权限                           |
| [11. roles](#表名roles)                    | 系统角色                                                            |
| [12. rules](#表名rules)                    | 系统自动化审核规则表                                                |
| [13. statements - 待完成](#表名statements) | 存储tickets.content中分解的每一条语句                               |
| [14. statistics](#表名statistics)          | 统计信息，用于着陆页看板                                            |
| [15. tickets](#表名tickets)                | 工单列表                                                            |
| [16. users](#表名users)                    | 用户列表，密码bcrypt存储                                            |

### 表结构说明


#### 表名：avatars
* 用途描述：用户头像表
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| avatar_id     | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| url           | 否        | 无        |    | VARCHAR(75)       | 头像位置 |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
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
```


#### 表名：comments
* 用途描述：审核意见建议
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| comment_id    | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| content       | 否        | 无        |    | TINYTEXT          | 意见建议 |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `comments` (
    `comment_id` INT UNSIGNED
                 NOT NULL
                 AUTO_INCREMENT
                 COMMENT '自增主键',
    `content`    TINYTEXT
                 NOT NULL
                 COMMENT '意见建议',
    `version`    INT UNSIGNED
                 NOT NULL
                 COMMENT '版本',
    `update_at`  INT UNSIGNED
                 COMMENT '修改时间',
    `create_at`  INT UNSIGNED
                 NOT NULL
                 COMMENT '创建时间',
    PRIMARY KEY `pk_comments` (`comment_id`)
)
ENGINE = InnoDB
COMMENT = '审核意见表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：crons
* 用途描述：预约任务
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| cron_id       | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| schedule      | 否        | 无        |    | VARCHAR(50)       | -?       |
| prev          | 否        | 无        |    | DATETIME          | -?       |
| next          | 否        | 无        |    | DATETIME          | -?       |
| job           | 否        | 无        |    | VARCHAR(50)       | -?       |
| status        | 否        | 无        |    | CHAR(1)           | 执行状态 |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### status取值
| 取值          | 含义                |
|:--------------|:--------------------|
| C             | 已取消 - Cancelled  |
| D             | 已删除 - Deleted    |
| E             | 执行有错误 - Error  |
| F             | 已完成 - Finished   |
| P             | 待执行 - Pending    |
| R             | 执行中 - Running    |
| S             | 已中止 - Stopped?   |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `crons` (
    `cron_id`   INT UNSIGNED
                NOT NULL
                AUTO_INCREMENT
                COMMENT '自增主键',
    `status`    CHAR(1)
                NOT NULL
                COMMENT '执行状态',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_crons` (`cron_id`)
)
ENGINE = InnoDB
COMMENT = '调度表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：glossaries
* 用途描述：查找表
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| catalog       | 否        | 无        |    | VARCHAR(25)       | 分类目录 |
| iota          | 否        | 无        |    | TINYINT UNSIGNED  | 值枚举   |
| name          | 否        | 无        |    | VARCHAR(25)       | 值名称   |
| description   | 否        | 无        |    | VARCHAR(150)      | 值描述   |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
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
```

### 参考数据
```sql
INSERT INTO mm_glossaries(catalog, iota, name, description, version, create_at) VALUES 
('data-types',  1, 'bit',        'TypeBit',        1, UNIX_TIMESTAMP()),
('data-types',  2, 'boolean',    'TypeBoolean',    1, UNIX_TIMESTAMP()),
('data-types',  3, 'tinyint',    'TypeTiny',       1, UNIX_TIMESTAMP()),
('data-types',  4, 'smallint',   'TypeShort',      1, UNIX_TIMESTAMP()),
('data-types',  5, 'mediumint',  'TypeInt24',      1, UNIX_TIMESTAMP()),
('data-types',  6, 'int',        'TypeInt',        1, UNIX_TIMESTAMP()),
('data-types',  7, 'bigint',     'TypeBigInt',     1, UNIX_TIMESTAMP()),
('data-types',  8, 'decimal',    'TypeDecimal',    1, UNIX_TIMESTAMP()),
('data-types',  9, 'float',      'TypeFloat',      1, UNIX_TIMESTAMP()),
('data-types', 10, 'double',     'TypeDouble',     1, UNIX_TIMESTAMP()),
('data-types', 11, 'timestamp',  'TypeTimestamp',  1, UNIX_TIMESTAMP()),
('data-types', 12, 'data',       'TypeDate',       1, UNIX_TIMESTAMP()),
('data-types', 13, 'time',       'TypeTime',       1, UNIX_TIMESTAMP()),
('data-types', 14, 'datetime',   'TypeDatetime',   1, UNIX_TIMESTAMP()),
('data-types', 15, 'year',       'TypeYear',       1, UNIX_TIMESTAMP()),
('data-types', 16, 'char',       'TypeChar',       1, UNIX_TIMESTAMP()),
('data-types', 17, 'varchar',    'TypeVarchar',    1, UNIX_TIMESTAMP()),
('data-types', 18, 'json',       'TypeJSON',       1, UNIX_TIMESTAMP()),
('data-types', 19, 'enum',       'TypeEnum',       1, UNIX_TIMESTAMP()),
('data-types', 20, 'set',        'TypeSet',        1, UNIX_TIMESTAMP()),
('data-types', 21, 'binary',     'TypeBinary',     1, UNIX_TIMESTAMP()),
('data-types', 22, 'varbinary',  'TypeVarbinary',  1, UNIX_TIMESTAMP()),
('data-types', 23, 'tinyblob',   'TypeTinyBlob',   1, UNIX_TIMESTAMP()),
('data-types', 24, 'blob',       'TypeBlob',       1, UNIX_TIMESTAMP()),
('data-types', 25, 'mediumblob', 'TypeMediumBlob', 1, UNIX_TIMESTAMP()),
('data-types', 26, 'longblob',   'TypeLongBlob',   1, UNIX_TIMESTAMP()),
('data-types', 27, 'tinytext',   'TypeTinyText',   1, UNIX_TIMESTAMP()),
('data-types', 28, 'text',       'TypeText',       1, UNIX_TIMESTAMP()),
('data-types', 29, 'mediumtext', 'TypeMediumText', 1, UNIX_TIMESTAMP()),
('data-types', 30, 'longtext',   'TypeLongText',   1, UNIX_TIMESTAMP());

```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES 
('storage-engines',  1, 'InnoDB',    'The most widely used storage engine with transaction support',                                1, UNIX_TIMESTAMP()),
('storage-engines',  2, 'MyISAM',    'Non-transactional storage engine with good performance and small data footprint',             1, UNIX_TIMESTAMP()),
('storage-engines',  3, 'CSV',       'Works with files stored in CSV (comma-separated-values) format',                              1, UNIX_TIMESTAMP()),
('storage-engines',  4, 'Memory',    'Storage engine stored in memory rather than on disk',                                         1, UNIX_TIMESTAMP()),
('storage-engines',  5, 'Blackhole', 'Storage engine that accepts data without storing it',                                         1, UNIX_TIMESTAMP()),
('storage-engines',  6, 'TokuDB',    'For use in high-performance and write-intensive environments',                                1, UNIX_TIMESTAMP()),
('storage-engines',  7, 'RocksDB',   'An LSM database with a great compression ratio that is optimized for flash storage',          1, UNIX_TIMESTAMP()),
('storage-engines',  8, 'Archive',   'Stores data in compressed (gzip) format',                                                     1, UNIX_TIMESTAMP()),
('storage-engines',  9, 'Aria',      'The Aria storage engine is compiled-in by default and is considered as an upgrade to MyISAM', 1, UNIX_TIMESTAMP()),
('storage-engines', 10, 'Cassandra', 'A storage engine interface to Cassandra',                                                     1, UNIX_TIMESTAMP()),
('storage-engines', 11, 'Federated', 'Allows you to access tables in other MariaDB or MySQL servers',                               1, UNIX_TIMESTAMP());
```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES
('rules.group',  1, 'database-create',  '...', 1, UNIX_TIMESTAMP()),
('rules.group',  2, 'database-alter',   '...', 1, UNIX_TIMESTAMP()),
('rules.group',  3, 'database-drop',    '...', 1, UNIX_TIMESTAMP()),
('rules.group',  4, 'database-use',     '...', 1, UNIX_TIMESTAMP()),
('rules.group',  5, 'table-create',     '...', 1, UNIX_TIMESTAMP()),
('rules.group',  6, 'table-alter',      '...', 1, UNIX_TIMESTAMP()),
('rules.group',  7, 'table-drop',       '...', 1, UNIX_TIMESTAMP()),
('rules.group',  8, 'table-rename',     '...', 1, UNIX_TIMESTAMP()),
('rules.group',  9, 'table-truncate',   '...', 1, UNIX_TIMESTAMP()),
('rules.group', 10, 'table-lock',       '...', 1, UNIX_TIMESTAMP()),
('rules.group', 11, 'table-unlock',     '...', 1, UNIX_TIMESTAMP()),
('rules.group', 12, 'table-flush',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 13, 'process-list',     '...', 1, UNIX_TIMESTAMP()),
('rules.group', 14, 'process-kill',     '...', 1, UNIX_TIMESTAMP()),
('rules.group', 15, 'index-create',     '...', 1, UNIX_TIMESTAMP()),
('rules.group', 16, 'index-drop',       '...', 1, UNIX_TIMESTAMP()),
('rules.group', 17, 'index-alter',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 18, 'data-insert',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 19, 'data-update',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 20, 'data-delete',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 21, 'data-replace',     '...', 1, UNIX_TIMESTAMP()),
('rules.group', 22, 'data-select',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 23, 'view-create',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 24, 'view-alter',       '...', 1, UNIX_TIMESTAMP()),
('rules.group', 25, 'view-drop',        '...', 1, UNIX_TIMESTAMP()),
('rules.group', 26, 'event-create',     '...', 1, UNIX_TIMESTAMP()),
('rules.group', 27, 'event-alter',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 28, 'event-drop',       '...', 1, UNIX_TIMESTAMP()),
('rules.group', 29, 'procedure-create', '...', 1, UNIX_TIMESTAMP()),
('rules.group', 30, 'procedure-alter',  '...', 1, UNIX_TIMESTAMP()),
('rules.group', 31, 'procedure-drop',   '...', 1, UNIX_TIMESTAMP()),
('rules.group', 32, 'func-create',      '...', 1, UNIX_TIMESTAMP()),
('rules.group', 33, 'func-alter',       '...', 1, UNIX_TIMESTAMP()),
('rules.group', 34, 'func-drop',        '...', 1, UNIX_TIMESTAMP()),
('rules.group', 35, 'trigger-create',   '...', 1, UNIX_TIMESTAMP()),
('rules.group', 36, 'trigger-alter',    '...', 1, UNIX_TIMESTAMP()),
('rules.group', 37, 'trigger-drop',     '...', 1, UNIX_TIMESTAMP());
```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES
('instances.status',  0, 'closed',  'The instance is closed for some reason', 1, UNIX_TIMESTAMP()), # 机器主动下线，可能是服务器调整等各种原因
('instances.status',  1, 'running',   'The instance is running', 1, UNIX_TIMESTAMP()),              # 正常服务中
('instances.status',  1, 'suspected',   'The instance is suspected', 1, UNIX_TIMESTAMP())           # 可能是连接账号密码等问题
;
```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES
('users.status',  0, 'waiting-for-activation',  '...', 1, UNIX_TIMESTAMP()), # 等待激活
('users.status',  1, 'normal',   '...', 1, UNIX_TIMESTAMP()),                # 正常
('users.status',  2, 'closed',   '...', 1, UNIX_TIMESTAMP()),                # 主动关闭，可能是职位调整或离职等原因
;
```

```sql
INSERT INTO mm_glossaries (catalog, iota, name, description, version, create_at) VALUES
('charsets',  1, 'big5',     '', 1, UNIX_TIMESTAMP()),
('charsets',  2, 'dec8',     '', 1, UNIX_TIMESTAMP()),
('charsets',  3, 'cp850',    '', 1, UNIX_TIMESTAMP()),
('charsets',  4, 'hp8',      '', 1, UNIX_TIMESTAMP()),
('charsets',  5, 'koi8r',    '', 1, UNIX_TIMESTAMP()),
('charsets',  6, 'latin1',   '', 1, UNIX_TIMESTAMP()),
('charsets',  7, 'latin2',   '', 1, UNIX_TIMESTAMP()),
('charsets',  8, 'swe7',     '', 1, UNIX_TIMESTAMP()),
('charsets',  9, 'ascii',    '', 1, UNIX_TIMESTAMP()),
('charsets', 10, 'ujis',     '', 1, UNIX_TIMESTAMP()),
('charsets', 11, 'sjis',     '', 1, UNIX_TIMESTAMP()),
('charsets', 12, 'hebrew',   '', 1, UNIX_TIMESTAMP()),
('charsets', 13, 'tis620',   '', 1, UNIX_TIMESTAMP()),
('charsets', 14, 'euckr',    '', 1, UNIX_TIMESTAMP()),
('charsets', 15, 'koi8u',    '', 1, UNIX_TIMESTAMP()),
('charsets', 16, 'gb2312',   '', 1, UNIX_TIMESTAMP()),
('charsets', 17, 'greek',    '', 1, UNIX_TIMESTAMP()),
('charsets', 18, 'cp1250',   '', 1, UNIX_TIMESTAMP()),
('charsets', 19, 'gbk',      '', 1, UNIX_TIMESTAMP()),
('charsets', 20, 'latin5',   '', 1, UNIX_TIMESTAMP()),
('charsets', 21, 'armscii8', '', 1, UNIX_TIMESTAMP()),
('charsets', 22, 'utf8',     '', 1, UNIX_TIMESTAMP()),
('charsets', 23, 'ucs2',     '', 1, UNIX_TIMESTAMP()),
('charsets', 24, 'cp866',    '', 1, UNIX_TIMESTAMP()),
('charsets', 25, 'keybcs2',  '', 1, UNIX_TIMESTAMP()),
('charsets', 26, 'macce',    '', 1, UNIX_TIMESTAMP()),
('charsets', 27, 'macroman', '', 1, UNIX_TIMESTAMP()),
('charsets', 28, 'cp852',    '', 1, UNIX_TIMESTAMP()),
('charsets', 29, 'latin7',   '', 1, UNIX_TIMESTAMP()),
('charsets', 30, 'utf8mb4',  '', 1, UNIX_TIMESTAMP()),
('charsets', 31, 'cp1251',   '', 1, UNIX_TIMESTAMP()),
('charsets', 32, 'utf16',    '', 1, UNIX_TIMESTAMP()),
('charsets', 33, 'utf16le',  '', 1, UNIX_TIMESTAMP()),
('charsets', 34, 'cp1256',   '', 1, UNIX_TIMESTAMP()),
('charsets', 35, 'cp1257',   '', 1, UNIX_TIMESTAMP()),
('charsets', 36, 'utf32',    '', 1, UNIX_TIMESTAMP()),
('charsets', 37, 'binary',   '', 1, UNIX_TIMESTAMP()),
('charsets', 38, 'geostd8',  '', 1, UNIX_TIMESTAMP()),
('charsets', 39, 'cp932',    '', 1, UNIX_TIMESTAMP()),
('charsets', 40, 'eucjpms',  '', 1, UNIX_TIMESTAMP());
```

```sql
INSERT INTO mm_glossaries (catalog, iota, name, description, version, create_at) VALUES
('collations',   1, 'big5_chinese_ci',          '', 1, UNIX_TIMESTAMP()),
('collations',   2, 'latin2_czech_cs',          '', 1, UNIX_TIMESTAMP()),
('collations',   3, 'dec8_swedish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations',   4, 'cp850_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',   5, 'latin1_german1_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',   6, 'hp8_english_ci',           '', 1, UNIX_TIMESTAMP()),
('collations',   7, 'koi8r_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',   8, 'latin1_swedish_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',   9, 'latin2_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  10, 'swe7_swedish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations',  11, 'ascii_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  12, 'ujis_japanese_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  13, 'sjis_japanese_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  14, 'cp1251_bulgarian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations',  15, 'latin1_danish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  16, 'hebrew_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  18, 'tis620_thai_ci',           '', 1, UNIX_TIMESTAMP()),
('collations',  19, 'euckr_korean_ci',          '', 1, UNIX_TIMESTAMP()),
('collations',  20, 'latin7_estonian_cs',       '', 1, UNIX_TIMESTAMP()),
('collations',  21, 'latin2_hungarian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations',  22, 'koi8u_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  23, 'cp1251_ukrainian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations',  24, 'gb2312_chinese_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  25, 'greek_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  26, 'cp1250_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  27, 'latin2_croatian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations',  28, 'gbk_chinese_ci',           '', 1, UNIX_TIMESTAMP()),
('collations',  29, 'cp1257_lithuanian_ci',     '', 1, UNIX_TIMESTAMP()),
('collations',  30, 'latin5_turkish_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  31, 'latin1_german2_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  32, 'armscii8_general_ci',      '', 1, UNIX_TIMESTAMP()),
('collations',  33, 'utf8_general_ci',          '', 1, UNIX_TIMESTAMP()),
('collations',  34, 'cp1250_czech_cs',          '', 1, UNIX_TIMESTAMP()),
('collations',  35, 'ucs2_general_ci',          '', 1, UNIX_TIMESTAMP()),
('collations',  36, 'cp866_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  37, 'keybcs2_general_ci',       '', 1, UNIX_TIMESTAMP()),
('collations',  38, 'macce_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  39, 'macroman_general_ci',      '', 1, UNIX_TIMESTAMP()),
('collations',  40, 'cp852_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  41, 'latin7_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  42, 'latin7_general_cs',        '', 1, UNIX_TIMESTAMP()),
('collations',  43, 'macce_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  44, 'cp1250_croatian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations',  45, 'utf8mb4_general_ci',       '', 1, UNIX_TIMESTAMP()),
('collations',  46, 'utf8mb4_bin',              '', 1, UNIX_TIMESTAMP()),
('collations',  47, 'latin1_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  48, 'latin1_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  49, 'latin1_general_cs',        '', 1, UNIX_TIMESTAMP()),
('collations',  50, 'cp1251_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  51, 'cp1251_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  52, 'cp1251_general_cs',        '', 1, UNIX_TIMESTAMP()),
('collations',  53, 'macroman_bin',             '', 1, UNIX_TIMESTAMP()),
('collations',  54, 'utf16_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  55, 'utf16_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  56, 'utf16le_general_ci',       '', 1, UNIX_TIMESTAMP()),
('collations',  57, 'cp1256_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  58, 'cp1257_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  59, 'cp1257_general_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  60, 'utf32_general_ci',         '', 1, UNIX_TIMESTAMP()),
('collations',  61, 'utf32_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  62, 'utf16le_bin',              '', 1, UNIX_TIMESTAMP()),
('collations',  63, 'binary',                   '', 1, UNIX_TIMESTAMP()),
('collations',  64, 'armscii8_bin',             '', 1, UNIX_TIMESTAMP()),
('collations',  65, 'ascii_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  66, 'cp1250_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  67, 'cp1256_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  68, 'cp866_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  69, 'dec8_bin',                 '', 1, UNIX_TIMESTAMP()),
('collations',  70, 'greek_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  71, 'hebrew_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  72, 'hp8_bin',                  '', 1, UNIX_TIMESTAMP()),
('collations',  73, 'keybcs2_bin',              '', 1, UNIX_TIMESTAMP()),
('collations',  74, 'koi8r_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  75, 'koi8u_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  77, 'latin2_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  78, 'latin5_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  79, 'latin7_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  80, 'cp850_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  81, 'cp852_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  82, 'swe7_bin',                 '', 1, UNIX_TIMESTAMP()),
('collations',  83, 'utf8_bin',                 '', 1, UNIX_TIMESTAMP()),
('collations',  84, 'big5_bin',                 '', 1, UNIX_TIMESTAMP()),
('collations',  85, 'euckr_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  86, 'gb2312_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  87, 'gbk_bin',                  '', 1, UNIX_TIMESTAMP()),
('collations',  88, 'sjis_bin',                 '', 1, UNIX_TIMESTAMP()),
('collations',  89, 'tis620_bin',               '', 1, UNIX_TIMESTAMP()),
('collations',  90, 'ucs2_bin',                 '', 1, UNIX_TIMESTAMP()),
('collations',  91, 'ujis_bin',                 '', 1, UNIX_TIMESTAMP()),
('collations',  92, 'geostd8_general_ci',       '', 1, UNIX_TIMESTAMP()),
('collations',  93, 'geostd8_bin',              '', 1, UNIX_TIMESTAMP()),
('collations',  94, 'latin1_spanish_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  95, 'cp932_japanese_ci',        '', 1, UNIX_TIMESTAMP()),
('collations',  96, 'cp932_bin',                '', 1, UNIX_TIMESTAMP()),
('collations',  97, 'eucjpms_japanese_ci',      '', 1, UNIX_TIMESTAMP()),
('collations',  98, 'eucjpms_bin',              '', 1, UNIX_TIMESTAMP()),
('collations',  99, 'cp1250_polish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 101, 'utf16_unicode_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 102, 'utf16_icelandic_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 103, 'utf16_latvian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 104, 'utf16_romanian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 105, 'utf16_slovenian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 106, 'utf16_polish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 107, 'utf16_estonian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 108, 'utf16_spanish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 109, 'utf16_swedish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 110, 'utf16_turkish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 111, 'utf16_czech_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 112, 'utf16_danish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 113, 'utf16_lithuanian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 114, 'utf16_slovak_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 115, 'utf16_spanish2_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 116, 'utf16_roman_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 117, 'utf16_persian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 118, 'utf16_esperanto_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 119, 'utf16_hungarian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 120, 'utf16_sinhala_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 121, 'utf16_german2_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 122, 'utf16_croatian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 123, 'utf16_unicode_520_ci',     '', 1, UNIX_TIMESTAMP()),
('collations', 124, 'utf16_vietnamese_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 128, 'ucs2_unicode_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 129, 'ucs2_icelandic_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 130, 'ucs2_latvian_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 131, 'ucs2_romanian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 132, 'ucs2_slovenian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 133, 'ucs2_polish_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 134, 'ucs2_estonian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 135, 'ucs2_spanish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 136, 'ucs2_swedish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 137, 'ucs2_turkish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 138, 'ucs2_czech_ci',            '', 1, UNIX_TIMESTAMP()),
('collations', 139, 'ucs2_danish_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 140, 'ucs2_lithuanian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 141, 'ucs2_slovak_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 142, 'ucs2_spanish2_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 143, 'ucs2_roman_ci',            '', 1, UNIX_TIMESTAMP()),
('collations', 144, 'ucs2_persian_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 145, 'ucs2_esperanto_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 146, 'ucs2_hungarian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 147, 'ucs2_sinhala_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 148, 'ucs2_german2_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 149, 'ucs2_croatian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 150, 'ucs2_unicode_520_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 151, 'ucs2_vietnamese_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 159, 'ucs2_general_mysql500_ci', '', 1, UNIX_TIMESTAMP()),
('collations', 160, 'utf32_unicode_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 161, 'utf32_icelandic_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 162, 'utf32_latvian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 163, 'utf32_romanian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 164, 'utf32_slovenian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 165, 'utf32_polish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 166, 'utf32_estonian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 167, 'utf32_spanish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 168, 'utf32_swedish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 169, 'utf32_turkish_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 170, 'utf32_czech_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 171, 'utf32_danish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 172, 'utf32_lithuanian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 173, 'utf32_slovak_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 174, 'utf32_spanish2_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 175, 'utf32_roman_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 176, 'utf32_persian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 177, 'utf32_esperanto_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 178, 'utf32_hungarian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 179, 'utf32_sinhala_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 180, 'utf32_german2_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 181, 'utf32_croatian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 182, 'utf32_unicode_520_ci',     '', 1, UNIX_TIMESTAMP()),
('collations', 183, 'utf32_vietnamese_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 192, 'utf8_unicode_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 193, 'utf8_icelandic_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 194, 'utf8_latvian_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 195, 'utf8_romanian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 196, 'utf8_slovenian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 197, 'utf8_polish_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 198, 'utf8_estonian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 199, 'utf8_spanish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 200, 'utf8_swedish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 201, 'utf8_turkish_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 202, 'utf8_czech_ci',            '', 1, UNIX_TIMESTAMP()),
('collations', 203, 'utf8_danish_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 204, 'utf8_lithuanian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 205, 'utf8_slovak_ci',           '', 1, UNIX_TIMESTAMP()),
('collations', 206, 'utf8_spanish2_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 207, 'utf8_roman_ci',            '', 1, UNIX_TIMESTAMP()),
('collations', 208, 'utf8_persian_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 209, 'utf8_esperanto_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 210, 'utf8_hungarian_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 211, 'utf8_sinhala_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 212, 'utf8_german2_ci',          '', 1, UNIX_TIMESTAMP()),
('collations', 213, 'utf8_croatian_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 214, 'utf8_unicode_520_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 215, 'utf8_vietnamese_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 223, 'utf8_general_mysql500_ci', '', 1, UNIX_TIMESTAMP()),
('collations', 224, 'utf8mb4_unicode_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 225, 'utf8mb4_icelandic_ci',     '', 1, UNIX_TIMESTAMP()),
('collations', 226, 'utf8mb4_latvian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 227, 'utf8mb4_romanian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 228, 'utf8mb4_slovenian_ci',     '', 1, UNIX_TIMESTAMP()),
('collations', 229, 'utf8mb4_polish_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 230, 'utf8mb4_estonian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 231, 'utf8mb4_spanish_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 232, 'utf8mb4_swedish_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 233, 'utf8mb4_turkish_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 234, 'utf8mb4_czech_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 235, 'utf8mb4_danish_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 236, 'utf8mb4_lithuanian_ci',    '', 1, UNIX_TIMESTAMP()),
('collations', 237, 'utf8mb4_slovak_ci',        '', 1, UNIX_TIMESTAMP()),
('collations', 238, 'utf8mb4_spanish2_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 239, 'utf8mb4_roman_ci',         '', 1, UNIX_TIMESTAMP()),
('collations', 240, 'utf8mb4_persian_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 241, 'utf8mb4_esperanto_ci',     '', 1, UNIX_TIMESTAMP()),
('collations', 242, 'utf8mb4_hungarian_ci',     '', 1, UNIX_TIMESTAMP()),
('collations', 243, 'utf8mb4_sinhala_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 244, 'utf8mb4_german2_ci',       '', 1, UNIX_TIMESTAMP()),
('collations', 245, 'utf8mb4_croatian_ci',      '', 1, UNIX_TIMESTAMP()),
('collations', 246, 'utf8mb4_unicode_520_ci',   '', 1, UNIX_TIMESTAMP()),
('collations', 247, 'utf8mb4_vietnamese_ci',    '', 1, UNIX_TIMESTAMP())
;
```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES
('tickets.status',  0, 'pending',   '...', 1, UNIX_TIMESTAMP()), # 待处理
('tickets.status',  1, 'validated', '...', 1, UNIX_TIMESTAMP()), # 待处理
('tickets.status',  2, 'closed',    '...', 1, UNIX_TIMESTAMP())  # 待处理
;
```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES
('statements.type',  1, 'DDL', 'Data Definition Language, refers to the CREATE, ALTER and DROP statements', 1, UNIX_TIMESTAMP()),
('statements.type',  2, 'DML', 'Data Manipulation Language, refers to the INSERT, UPDATE and DELETE statements', 1, UNIX_TIMESTAMP()),
('statements.type',  3, 'DQL', 'Data Query Language, refers to the SELECT, SHOW and HELP statements', 1, UNIX_TIMESTAMP()),
('statements.type',  3, 'DCL', 'Data Control Language, refers to the GRANT and REVOKE statements', 1, UNIX_TIMESTAMP()),
('statements.type',  3, 'DTL', 'Data Transaction Language, refers to the START TRANSACTION, SAVEPOINT, COMMIT and ROLLBACK [TO SAVEPOINT] statements', 1, UNIX_TIMESTAMP())
;
```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES
('relations.type',  1, '...', '...', 1, UNIX_TIMESTAMP())
;
```

#### 表名：instances
* 用途描述：服务器及登录信息，用户和密码采用加密存储
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| instance_id   | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| host          | 否        | 无        |    | VARCHAR(150)      | 主机名称 |
| alias         | 否        | 无        |    | VARCHAR(75)       | 主机别名 |
| ip            | 否        | 无        |    | INT UNSIGNED      | 主机地址 |
| port          | 否        | 3306      |    | SMALLINT UNSIGNED | 端口     |
| user          | 否        | 无        |    | VARCHAR(50)       | 连接用户 |
| password      | 否        | 无        |    | VARBINARY(48)     | 密码     |
| status        | 否        | 1         |    | TINYINT UNSIGNED  | 状态     |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `instances` (
    `instance_id` INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `host`        VARCHAR(150)
                  NOT NULL
                  COMMENT '主机名称',
    `alias`       VARCHAR(75)
                  NOT NULL
                  COMMENT '主机别名',
    `ip`          INT UNSIGNED
                  NOT NULL
                  COMMENT '主机地址',
    `port`        INT UNSIGNED
                  NOT NULL
                  DEFAULT 3306
                  COMMENT '端口',
    `user`        VARCHAR(50)
                  NOT NULL
                  COMMENT '连接用户',
    `password`    VARBINARY(48)
                  NOT NULL
                  COMMENT '密码',
    `status`      TINYINT UNSIGNED
                  NOT NULL
                  DEFAULT 1
                  COMMENT '状态',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_instances` (`instance_id`),
    UNIQUE KEY `unique_1` (`host`, `port`),
    UNIQUE KEY `unique_2` (`ip`, `port`),
    UNIQUE KEY `unique_3` (`alias`)
)
ENGINE = InnoDB
COMMENT = '实例表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：options
* 用途描述：系统选项，建值对
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| option_id     | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| group         | 否        | 无        |    | VARCHAR(25)       | 配置分组 |
| name          | 否        | 无        |    | VARCHAR(50)       | 配置项   |
| value         | 否        | 无        |    | TINYTEXT          | 配置值   |
| description   | 否        | 无        |    | VARCHAR(75)       | 描述     |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 系统选项
* 邮件服务器配置，用于发送等待审核、审核不通过、执行成功、执行失败等信息
* 其他，陆续补充

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `options` (
    `option_id`   INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `group`       VARCHAR(25)
                  NOT NULL
                  COMMENT '配置分组',
    `name`        VARCHAR(50)
                  NOT NULL
                  COMMENT '配置项',
    `value`       TINYTEXT
                  NOT NULL
                  COMMENT '配置值',
    `description` VARCHAR(75)
                  NOT NULL
                  COMMENT '描述',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_options` (`option_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '配置表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```

### 参考数据
```sql
INSERT INTO `options` (`group`, `name`, `value`, `description`, `version`, `create_at`) VALUES
# 邮件
('smtp', 'smtp.enabled',    'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.host',       'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.port',       'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.user',       'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.password',   'true', '', 1, UNIX_TIMESTAMP()),
('smtp', 'smtp.encryption', 'none', '', 1, UNIX_TIMESTAMP()),

# 认证
('ldap', 'ldap.enabled',    'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.host',       'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.domain',     'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.type',       'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.user',       'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.password',   'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.sc',         'true', '', 1, UNIX_TIMESTAMP()),
('ldap', 'ldap.ou',         'true', '', 1, UNIX_TIMESTAMP())

;
```


#### 表名：plans
* 用途描述：执行计划表
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| statement_id  | 否        | 无        | PK | INT UNSIGNED      | 主键     |
| value         | 否        | 无        |    | TEXT              | 执行计划 |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `plans` (
    `statement_id` INT UNSIGNED
                   NOT NULL
                   COMMENT '主键',
    `value`        TEXT
                   NOT NULL
                   COMMENT '执行计划',
    `version`      INT UNSIGNED
                   NOT NULL
                   COMMENT '版本',
    `update_at`    INT UNSIGNED
                   COMMENT '修改时间',
    `create_at`    INT UNSIGNED
                   NOT NULL
                   COMMENT '创建时间',
    PRIMARY KEY `pk_plans` (`statement_id`)
)
ENGINE = InnoDB
COMMENT = '执行计划表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：queries
* 用途描述：历史查询表
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| query_id      | 否        | 无        | PK | INT UNSIGNED      | 主键     |
| sql           | 否        | 无        |    | TEXT              | 执行SQL  |
| plan          | 否        | 无        |    | TEXT              | 执行计划 |
| owner_id      | 否        | 无        |    | INT UNSIGNED      | 发起人   |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `queries` (
    `query_id`  INT UNSIGNED
                NOT NULL
                COMMENT '主键',
    `sql`       TEXT
                NOT NULL
                COMMENT '执行SQL',
    `plan`      TEXT
                NOT NULL
                COMMENT '执行计划',
    `owner_id`  INT UNSIGNED
                NOT NULL
                COMMENT '发起人',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_queries` (`query_id`),
    INDEX `index_1` (`owner_id`)
)
ENGINE = InnoDB
COMMENT = '查询表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：relations
* 用途描述：记录系统一对多和多对多关系
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| relation_id   | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| type          | 否        | 无        |    | INT UNSIGNED      | 分类标识 |
| ancestor_id   | 否        | 无        |    | INT UNSIGNED      | 先代     |
| descendant_id | 否        | 无        |    | INT UNSIGNED      | 后代     |
| description   | 否        | 无        |    | VARCHAR(75)       | 描述     |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `relations` (
    `relation_id`   INT UNSIGNED
                    NOT NULL
                    AUTO_INCREMENT
                    COMMENT '自增主键',
    `type`          INT UNSIGNED
                    NOT NULL
                    COMMENT '分类标识',
    `ancestor_id`   INT UNSIGNED
                    NOT NULL
                    COMMENT '先代',
    `descendant_id` INT UNSIGNED
                    NOT NULL
                    COMMENT '后代',
    `description`   VARCHAR(75)
                    NOT NULL
                    COMMENT '描述',
    `version`       INT UNSIGNED
                    NOT NULL
                    COMMENT '版本',
    `update_at`     INT UNSIGNED
                    COMMENT '修改时间',
    `create_at`     INT UNSIGNED
                    NOT NULL
                    COMMENT '创建时间',
    PRIMARY KEY `pk_relations` (`relation_id`),
    UNIQUE KEY `unique_1` (`type`, `ancestor_id`, `descendant_id`)
)
ENGINE = InnoDB
COMMENT = '关系表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


### 表名：resources
* 用途描述：系统资源
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键  | 类型              | 说明     |
|:--------------|:----------|:----------|:----|:------------------|:---------|
| resource_id   | 否        | 无        | PK  | INT UNSIGNED      | 自增主键 |
| url_pattern   | 否        | 无        | UNI | VARCHAR(100)      | 资源名称 |
| method        | 否        | 无        |     | VARCHAR(10)       | 请求方式 |
| version       | 否        | 无        |     | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |     | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |     | INT UNSIGNED      | 创建时间 |

#### method可能的值
| 取值      | 含义        |
|:----------|:------------|
| GET       | 查询        |
| POST      | 新增        |
| DELETE    | 删除        |
| PUT       | 更新        |
| PATCH     | 部分更新    |
| HEAD      | <无用>      |
| OPTIONS   | <无用>      |
| TRACE     | <无用>      |
| MOVE      | <无用>      |
| COPY      | <无用>      |
| LINK      | <无用>      |
| UNLINK    | <无用>      |
| CONNECT   | <无用>      |
| WRAPPED   | <无用>      |

### 初始数据
| 资源名称                   | 请方法 | 说明                                         |
|:---------------------------|:-------|:---------------------------------------------|
| \^\/index\.html$           | GET    | 首页，显示摘要信息                           |
| ---                        | ---    | ---                                          |
| \^\/register\.html$        | GET    | 注册页面                                     |
| \^\/register\.html$        | POST   | 提交注册信息                                 |
| ---                        | ---    | ---                                          |
| \^\/login\.html$           | GET    | 登录页面                                     |
| \^\/login\.html$           | POST   | 提交登录信息                                 |
| ---                        | ---    | ---                                          |
| \^\/forget-password\.html$ | GET    | 忘记密码页面                                 |
| \^\/forget-password\.html$ | POST   | 提交忘记密码信息                             |
| ---                        | ---    | ---                                          |
| \^\/reset-password\.html$  | GET    | 重置密码页面                                 |
| \^\/reset-password\.html$  | POST   | 提交新密码                                   |
| ---                        | ---    | ---                                          |
| \^\/queries\.html$         | GET    | 查询页面                                     |
| \^\/queries\.html$         | POST   | 提交查询请求，返回查询数据                   |
| ---                        | ---    | ---                                          |
| \^\/tickets\.html$         | GET    | 查看工单列表                                 |
| \^\/tickets\.html$         | POST   | 提交工单                                     |
| \^\/tickets-\d+\.html$     | GET    | 查看某一工单                                 |
| \^\/tickets-\d+\.html$     | PUT    | 修改某一工单                                 |
| \^\/tickets-\d+\.html$     | PATCH  | 调整某一工单，如关闭                         |
| ---                        | ---    | ---                                          |
| \^\/instances\.html$       | GET    | 查看服务器列表                               |
| \^\/instances\.html$       | POST   | 新增服务器                                   |
| \^\/instances\-\d+\.html$  | GET    | 查看/编辑服务器                              |
| \^\/instances\-\d+\.html$  | PUT    | 修改服务器                                   |
| \^\/instances\-\d+\.html$  | DELETE | 删除服务器，如有关联工单或查询，则不允许删除 |
| \^\/instances\-\d+\.html$  | PATCH  | 调整服务器                                   |
| ---                        | ---    | ---                                          |
| \^\/users\.html$           | GET    | 查看用户列表                                 |
| \^\/users\.html$           | POST   | 新增用户，管理员通过后台                     |
| \^\/users\-\d+\.html$      | GET    | 查看/编辑用户信息                            |
| \^\/users\-\d+\.html$      | PUT    | 修改用户信息                                 |
| \^\/users\-\d+\.html$      | PATCH  | 调整用户，如果离职用户的禁用                 |
| ---                        | ---    | ---                                          |
| \^\/options\.html$         | GET    | 查看配置项                                   |
| \^\/options\-\d+\.html$    | PATCH  | 调整配置项                                   |
| ---                        | ---    | ---                                          |
| \^\/roles\.html$           | GET    | 查看角色列表                                 |
| \^\/roles\-\d+\.html$      | GET    | 查看角色信息，包括权限                       |
| ---                        | ---    | ---                                          |
| \^\/resources\.html$       | GET    | 查看资源列表，只读                           |
| ---                        | ---    | ---                                          |
| \^\/crons\.html$           | GET    | 查看调度任务信息                             |
| \^\/crons-\d+\.html$       | PATCH  | 调整某一任务，比如取消                       |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `resources` (
    `resource_id` INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `url_pattern` VARCHAR(100)
                  NOT NULL
                  COMMENT '资源名称',
    `method`      VARCHAR(10)
                  NOT NULL
                  COMMENT '请求方式',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_resources` (`resource_id`),
    UNIQUE KEY `unique_1` (`url_pattern`, `method`)
)
ENGINE = InnoDB
COMMENT = '资源表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：roles
* 用途描述：系统角色，内置角色，不可更改
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键  | 类型              | 说明     |
|:--------------|:----------|:----------|:----|:------------------|:---------|
| role_id       | 否        | 无        | PK  | INT UNSIGNED      | 自增主键 |
| name          | 否        | 无        | UNI | VARCHAR(25)       | 角色名称 |
| description   | 否        | 无        |     | VARCHAR(75)       | 描述     |
| version       | 否        | 无        |     | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |     | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |     | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `roles` (
    `role_id`     INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `name`        VARCHAR(25)
                  NOT NULL
                  COMMENT '角色名称',
    `description` VARCHAR(75)
                  NOT NULL
                  COMMENT '描述',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_roles` (`role_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：rules
* 用途描述：审核规则配置，需要进一步细化
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明         |
|:--------------|:----------|:----------|:---|:------------------|:-------------|
| rule_id       | 否        | 无        | PK | INT UNSIGNED      | 自增主键     |
| group         | 否        | 无        |    | VARCHAR(25)       | 规则分组     |
| name          | 否        | 无        |    | VARCHAR(75)       | 规则名称     |
| description   | 否        | 无        |    | VARCHAR(75)       | 规则描述     |
| level         | 否        | 无        |    | TINYINT UNSIGNED  | 规则层级     |
| operator      | 否        | 无        |    | VARCHAR(10)       | 比较符       |
| values        | 否        | 无        |    | VARCHAR(150)      | 有效值       |
| bitwise       | 否        | 4         |    | TINYINT UNSIGNED  | 读写执行控制 |
| message       | 否        | 无        |    | VARCHAR(150)      | 错误提示     |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本         |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间     |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间     |

#### 全表缓存，所以group上不做索引
#### group的中文描述参考glossaries表，其catalog为rules.group
#### operator方便查看和理解，暂时不用
#### bitwise按位操作，目前取值4/5/6/7，参考Linux系统file permissions rwx的设计

#### level验证层级，分1级验证、2级验证和3级验证，有限顺序按先1级，再2级，最后3级
* 1级验证，任何一个规则不满足，即不再验证其他规则，报错退出
* 2级验证，基于抽象语法树的验证，可以通过协程的方式并行验证
* 3级验证，需要连接到工单指定的后段服务器进行联机验证

#### name可能的值
| 取值                                   | 含义                              |
|:---------------------------------------|:----------------------------------|
| update-without-where-clause            | UPDATE语句没有WHERE从句           |
| delete-without-where-clause            | DELETE语句没有WHERE从句           |
| insert-without-explicit-columns        | INSERT语句没有指定字段列表        |
| create-database-not-allowed            | CREATE DATABASE被禁止使用         |
| drop-database-not-allowed              | DROP DATABASE被禁止使用           |
| create-table-invalid-charset           | CREATE TABLE中表字符集无效        |
| create-table-invalid-collation         | CREATE TABLE中表排序规则无效      |
| create-table-invalid-name              | CREATE TABLE中表名无效            |
| create-table-duplicate-name            | CREATE TABLE中表名已存在          |
| create-table-invalid-column-charset    | CREATE TABLE中列字符集无效        |
| create-table-invalid-column-collation  | CREATE TABLE中列排序规则无效      |
| create-table-invalid-column-name       | CREATE TABLE中列名无效            |
| create-table-too-many-indices          | CREATE TABLE中定义了过多的索引    |
| create-table-too-many-columns          | CREATE TABLE中定义了过多的列      |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `rules` (
    `rule_id`     INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `group`       VARCHAR(25)
                  NOT NULL
                  COMMENT '规则名称',
    `name`        VARCHAR(75)
                  NOT NULL
                  COMMENT '规则名称',
    `description` VARCHAR(75)
                  NOT NULL
                  COMMENT '规则描述',
    `level`       TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '验证顺序',
    `operator`    VARCHAR(10)
                  NOT NULL
                  COMMENT '比较符',
    `values`      VARCHAR(150)
                  NOT NULL
                  COMMENT '有效值',
    `bitwise`     TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '是否可用',
    `message`     VARCHAR(150)
                  NOT NULL
                  COMMENT '错误提示',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_rules` (`rule_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '规则表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：statements
* 用途描述：分解用户输入的SQL为每一条单独的语句
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键  | 类型              | 说明     |
|:--------------|:----------|:----------|:----|:------------------|:---------|
| statement_id  | 否        | 无        | PK  | INT UNSIGNED      | 自增主键 |
| sql           | 否        | 无        |     | TEXT              | SQL      |
| type          | 否        | 1         |     | TINYINT UNSIGNED  | 类型     |
| status        | 否        | 0         |     | TINYINT UNSIGNED  | 验证结果 |
| ticket_id     | 否        | 无        |     | INT UNSIGNED      | 所属工单 |
| version       | 否        | 无        |     | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |     | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |     | INT UNSIGNED      | 创建时间 |

### status可能的值
| 取值  | 含义                         |
|:------|:-----------------------------|
| 0     | 待检查                       |
| 1     | 自动检测不通过               |
| 2     | 自动检测通过，等待人工审核   |
| 3     | 人工审核通过，正在执行       |
| 4     | 执行成功，工单关闭           |
| 5     | 人工审核不通过               |
| 6     | 人工审核通过，已预约执行     |
| 7     | 工单执行失败，请检查日志     |


### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `statements` (
    `statement_id` INT UNSIGNED
                   NOT NULL
                   AUTO_INCREMENT
                   COMMENT '自增主键',
    `sql`          TEXT
                   NOT NULL
                   COMMENT '单独语句',
    `type`         TINYINT UNSIGNED
                   NOT NULL
                   COMMENT '类型',
    `ticket_id`    INT UNSIGNED
                   NOT NULL
                   COMMENT '所属工单',
    `version`      INT UNSIGNED
                   NOT NULL
                   COMMENT '版本',
    `update_at`    INT UNSIGNED
                   COMMENT '修改时间',
    `create_at`    INT UNSIGNED
                   NOT NULL
                   COMMENT '创建时间',
    PRIMARY KEY `pk_statements` (`statement_id`),
    INDEX `index_1` (`ticket_id`)
)
ENGINE = InnoDB
COMMENT = '工单分解表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：statistics
* 用途描述：统计信息，用于着陆页看板，需要进一步细化
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键  | 类型              | 说明     |
|:--------------|:----------|:----------|:----|:------------------|:---------|
| statistic_id  | 否        | 无        | PK  | INT UNSIGNED      | 自增主键 |
| name          | 否        | 无        | UNI | VARCHAR(50)       | 统计项目 |
| description   | 否        | 无        |     | VARCHAR(75)       | 页面显示 |
| value         | 否        | 无        |     | INT UNSIGNED      | 统计计数 |
| enabled       | 否        | 1         |     | TINYINT UNSIGNED  | 是否可用 |
| version       | 否        | 无        |     | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |     | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |     | INT UNSIGNED      | 创建时间 |


* 考虑做成竖表，类似建值对，如用户查询次数/工单数量/审核通过/审核不过/审核次数等等。也就是统计信息的属主，类别，统计值。
* 后续可以考虑采用binlog解析->日志中继->发回给web服务器来准实时数据更新

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `statistics` (
    `statistic_id` INT UNSIGNED
                   NOT NULL
                   AUTO_INCREMENT
                   COMMENT '自增主键',
    `name`         VARCHAR(50)
                   NOT NULL
                   COMMENT '统计项目',
    `description`  VARCHAR(75)
                   NOT NULL
                   COMMENT '页面显示',
    `value`        INT UNSIGNED
                   NOT NULL
                   COMMENT '统计计数',
    `enabled`      TINYINT UNSIGNED
                   NOT NULL
                   COMMENT '是否可用',
    `version`      INT UNSIGNED
                   NOT NULL
                   COMMENT '版本',
    `update_at`    INT UNSIGNED
                   COMMENT '修改时间',
    `create_at`    INT UNSIGNED
                   NOT NULL
                   COMMENT '创建时间',
    PRIMARY KEY `pk_statistics` (`statistic_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '数据统计表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：tickets
* 用途描述：工单列表，有待进一步细化
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| ticket_id     | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| subject       | 否        | 无        |    | VARCHAR(50)       | 主题     |
| content       | 否        | 无        |    | TEXT              | 更新语句 |
| status        | 否        | 无        |    | TINYINT UNSIGNED  | 状态     |
| owner_id      | 否        | 无        |    | INT UNSIGNED      | 申请人   |
| instance_id   | 否        | 无        |    | INT UNSIGNED      | 目标群集 |
| reviewer_id   | 否        | 无        |    | INT UNSIGNED      | 审核人   |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### status可能的值
| 取值  | 含义                         |
|:------|:-----------------------------|
| 0     | 待检查                       |
| 1     | 自动检测不通过               |
| 2     | 自动检测通过，等待人工审核   |
| 3     | 人工审核通过，正在执行       |
| 4     | 执行成功，工单关闭           |
| 5     | 人工审核不通过               |
| 6     | 人工审核通过，已预约执行     |
| 7     | 工单执行失败，请检查日志     |

### 参考代码
```sql
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
    INDEX `index_1` (`owner_id`),
    INDEX `index_2` (`instance_id`),
    INDEX `index_3` (`reviewer_id`)
)
ENGINE = InnoDB
COMMENT = '工单表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


#### 表名：users
* 用途描述：用户列表，密码采用bcrypt，比如：$2a$10$YARNH/Rs3XDY/fdsE02T/OsGFN5fcZydPG.KQAhklup6TVLjaQg82
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| user_id       | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| email         | 否        | 无        |    | VARCHAR(75)       | 电子邮件 |
| password      | 否        | 无        |    | CHAR(60)          | 密码     |
| status        | 否        | 1         |    | TINYINT UNSIGNED  | 状态     |
| name          | 否        | 无        |    | VARCHAR(15)       | 真实名称 |
| avatar_id     | 否        | 1         |    | INT UNSIGNED      | 头像     |
| version       | 否        | 无        |    | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |    | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |    | INT UNSIGNED      | 创建时间 |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `users` (
    `user_id`   INT UNSIGNED
                NOT NULL
                AUTO_INCREMENT
                COMMENT '自增主键',
    `email`     VARCHAR(75)
                NOT NULL
                COMMENT '电子邮件',
    `password`  CHAR(60)
                NOT NULL
                COMMENT '密码',
    `status`    TINYINT UNSIGNED
                NOT NULL
                COMMENT '状态',
    `name`      VARCHAR(15)
                NOT NULL
                COMMENT '真实名称',
    `avatar_id` INT UNSIGNED
                NOT NULL
                COMMENT '头像',
    `version`   INT UNSIGNED
                NOT NULL
                COMMENT '版本',
    `update_at` INT UNSIGNED
                COMMENT '修改时间',
    `create_at` INT UNSIGNED
                NOT NULL
                COMMENT '创建时间',
    PRIMARY KEY `pk_users` (`user_id`),
    UNIQUE KEY `unique_1` (`email`)
)
ENGINE = InnoDB
COMMENT = '用户表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


### 外键（可选部分）
```sql
ALTER TABLE `users`
   ADD FOREIGN KEY `fk_users_1` (`avatar_id`)
      REFERENCES `avatars` (`avatar_id`)
         ON UPDATE CASCADE
         ON DELETE RESTRICT;

ALTER TABLE `tickets`
   ADD FOREIGN KEY `fk_tickets_1` (`owner_id`)
      REFERENCES `users` (`user_id`)
         ON UPDATE CASCADE
         ON DELETE RESTRICT;

ALTER TABLE `tickets`
   ADD FOREIGN KEY `fk_tickets_2` (`instance_id`)
      REFERENCES `instances` (`instance_id`)
         ON UPDATE CASCADE
         ON DELETE RESTRICT;

ALTER TABLE `tickets`
   ADD FOREIGN KEY `fk_tickets_3` (`reviewer_id`)
      REFERENCES `users` (`user_id`)
         ON UPDATE CASCADE
         ON DELETE RESTRICT;
         
ALTER TABLE `statements`
   ADD FOREIGN KEY `fk_statements_1` (`ticket_id`)
      REFERENCES `tickets` (`ticket_id`)
         ON UPDATE CASCADE
         ON DELETE RESTRICT;

ALTER TABLE `plans`
   ADD FOREIGN KEY `fk_plans_1` (`statement_id`)
      REFERENCES `statements` (`statement_id`)
         ON UPDATE CASCADE
         ON DELETE RESTRICT;

ALTER TABLE `queries`
   ADD FOREIGN KEY `fk_queries_1` (`owner_id`)
      REFERENCES `users` (`user_id`)
         ON UPDATE CASCADE
         ON DELETE RESTRICT;
```
