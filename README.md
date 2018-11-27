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
| [09. relations](#表名relations)            | 记录系统一对多和多对多关系                                          |
| [10. resources](#表名resources)            | 系统资源，与角色通过relations关联处理权限                           |
| [11. roles](#表名roles)                    | 系统角色                                                            |
| [12. rules](#表名rules)                    | 系统自动化审核规则表                                                |
| [13. statements - 待完成](#表名statements) | 存储tickets.content中分解的每一条语句                               |
| [14. statistics](#表名statistics)          | 统计信息，用于着陆页看板                                            |
| [15. taxonomies](#表名taxonomies)          | 分类信息                                                            |
| [16. tickets](#表名tickets)                | 工单列表                                                            |
| [17. users](#表名users)                    | 用户列表，密码bcrypt存储                                            |

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
| description   | 否        | 无        |    | VARCHAR(100)      | 值描述   |
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
    `description` VARCHAR(100)
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
('instances.status',  0, 'closed',  'The instance is closed for some reason', 1, UNIX_TIMESTAMP()),
('instances.status',  1, 'running',   'The instance is running', 1, UNIX_TIMESTAMP());
```

```sql
INSERT INTO `mm_glossaries`(catalog, iota, name, description, version, create_at) VALUES
('users.status',  0, 'waiting-for-activation',  '...', 1, UNIX_TIMESTAMP()),
('users.status',  1, 'normal',   '...', 1, UNIX_TIMESTAMP()),
('users.status',  2, 'closed',   '...', 1, UNIX_TIMESTAMP());

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
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
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
| taxonomy_id   | 否        | 无        |    | INT UNSIGNED      | 分类标识 |
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
    `taxonomy_id`   INT UNSIGNED
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
    UNIQUE KEY `unique_1` (`taxonomy_id`, `ancestor_id`, `descendant_id`)
)
ENGINE = InnoDB
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
| description   | 否        | 无        |    | VARCHAR(75)       | 规则说明     |
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
                  COMMENT '规则说明',
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
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```


### 表名：taxonomies
* 用途描述：分类信息
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_general_ci

| 列名          | 允许空    | 默认值    | 键  | 类型              | 说明     |
|:--------------|:----------|:----------|:----|:------------------|:---------|
| taxonomy_id   | 否        | 无        | PK  | INT UNSIGNED      | 自增主键 |
| name          | 否        | 无        | UNI | VARCHAR(50)       | 分类名称 |
| description   | 是        | 无        |     | VARCHAR(75)       | 分类描述 |
| version       | 否        | 无        |     | INT UNSIGNED      | 版本     |
| update_at     | 是        | 无        |     | INT UNSIGNED      | 修改时间 |
| create_at     | 否        | 无        |     | INT UNSIGNED      | 创建时间 |

#### name可能的值
| 取值                     | 含义                         |
|:-------------------------|:-----------------------------|
| m-to-m:user-reviewer     | 用户与审核者的关系           |
| m-to-m:user-role         | 用户与角色多对多关系         |
| m-to-m:user-instance     | 用户与实例多对多关系         |
| o-to-m:ticket-comment    | 工单与审核意见一对多关系     |
| o-to-m:comment-comment   | 审核意见与回复一对多关系     |

### 参考代码
```sql
CREATE TABLE IF NOT EXISTS `taxonomies` (
    `taxonomy_id` INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `name`        VARCHAR(50)
                  NOT NULL
                  COMMENT '分类名称',
    `description` VARCHAR(75)
                  NOT NULL
                  COMMENT '分类描述',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_taxonomies` (`taxonomy_id`),
    UNIQUE KEY `unique_1` (`name`)
)
ENGINE = InnoDB
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
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;
```
