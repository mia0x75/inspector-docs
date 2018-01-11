## SQL查询审核系统

### 系统结构的初步设想：
![image](http://oi64.tinypic.com/t0k9pv.jpg)

### 系统角色说明：

| 系统角色          | 说明       | 权限                                   |
|:------------------|:-----------|:---------------------------------------|
| guest             | 访客       | 只能留在登录页面                       |
| viewer            | 查询用户   | 只能提交查询语句                       |
| creator           | 提交       | 可以查询，可以提交修改                 |
| dml reviewer      | 普通审核   | 只能审核DML工单，含有DDL的工单禁止审核 |
| advanced reviewer | 高级审核   | 可以审核所有工单                       |
| administrator     | 系统管理员 | 只能管理服务器、用户、权限、工单、设置 |


### 系统表说明（后续可能会统一增加前缀）：

| 表名       | 说明                                     |
|:-----------|:-----------------------------------------|
| servers    | 服务器及登录信息，用户和密码采用加密存储 |
| users      | 用户列表，密码采用哈希存储               |
| tickets    | 工单列表                                 |
| options    | 系统选项，建值对                         |
| rules      | 系统自动化审核规则表                     |
| roles      | 系统角色                                 |
| taxonomies | 分类信息                                 |
| relations  | 记录系统一对多和多对多关系               |
| slaves     | 从库信息                                 |
| stats      | 统计信息，用于着陆页看板                 |

### 表结构说明

#### 表名：servers
* 用途描述：服务器及登录信息，用户和密码采用加密存储
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| server_id     | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| host          | 否        | 无        |    | INT UNSIGNED      | 主机地址 |
| port          | 否        | 3306      |    | SMALLINT UNSIGNED | 端口     |
| user          | 否        | review    |    | VARCHAR(15)       | 连接用户 |
| password      | 否        | 无        |    | VARCHAR(100)      | 密码     |
| status        | 否        | 1         |    | TINYINT UNSIGNED  | 状态     |
| creation_date | 否        | NOW()     |    | DATETIME          | 创建时间 |

#### 表名：slaves
* 用途描述：从库服务器及登录信息，仅支持一级主从关系，如果配置有从库，那么查询发送到从库执行，同时考虑集成gh-ost工具
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| slave_id      | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| server_id     | 否        | 无        |    | INT UNSIGNED      | 对应主库 |
| host          | 否        | 无        |    | INT UNSIGNED      | 主机地址 |
| port          | 否        | 3306      |    | SMALLINT UNSIGNED | 端口     |
| user          | 否        | review    |    | VARCHAR(15)       | 连接用户 |
| password      | 否        | 无        |    | VARCHAR(100)      | 密码     |
| status        | 否        | 1         |    | TINYINT UNSIGNED  | 状态     |
| creation_date | 否        | NOW()     |    | DATETIME          | 创建时间 |

#### 表名：users
* 用途描述：用户列表，密码采用哈希存储
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| user_id       | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| login         | 否        | 无        |    | VARCHAR(25)       | 登录名称 |
| password      | 否        | 无        |    | CHAR(64)          | 密码     |
| status        | 否        | 1         |    | TINYINT UNSIGNED  | 状态     |
| name          | 否        | 无        |    | VARCHAR(25)       | 真实名称 |
| email         | 否        | 无        |    | VARCHAR(75)       | 电子邮件 |
| avator        | 否        | 无        |    | VARCHAR(75)       | 头像     |
| creation_date | 否        | NOW()     |    | DATETIME          | 创建时间 |

#### 表名：tickets
* 用途描述：工单列表，有待进一步细化
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名        | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:------------|:----------|:----------|:---|:------------------|:---------|
| ticket_id   | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| server_id   | 否        | 无        |    | INT UNSIGNED      | 目标机器 |
| subject     | 否        | 无        |    | VARCHAR(50)       | 主题     |
| content     | 否        | 无        |    | TEXT              | 更新语句 |
| user_id     | 否        | 无        |    | INT UNSIGNED      | 提交人   |
| reviewer_id | 否        | 无        |    | INT UNSIGNED      | 审核人   |
| status      | 否        | 无        |    | TINYINT UNSIGNED  | 状态     |

#### 表名：options
* 用途描述：系统选项，建值对
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名      | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:----------|:----------|:----------|:---|:------------------|:---------|
| option_id | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| name      | 否        | 无        |    | VARCHAR(50)       | 配置项   |
| value     | 否        | 无        |    | TINYTEXT          | 配置值   |

#### 表名：rules
* 用途描述：审核规则配置，需要进一步细化
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名        | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:------------|:----------|:----------|:---|:------------------|:---------|
| option_id   | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| name        | 否        | 无        |    | VARCHAR(50)       | 规则名称 |
| description | 否        | 无        |    | TINYTEXT          | 规则说明 |
| valid       | 否        | 1         |    | TINYINT UNSIGNED  | 是否有效 |
| mandatory   | 否        | 无        |    | TINYINT UNSIGNED  | 是否强制 |

#### 表名：roles
* 用途描述：系统角色，内置角色，不可更改
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名        | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:------------|:----------|:----------|:---|:------------------|:---------|
| role_id     | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| name        | 否        | 无        |    | VARCHAR(25)       | 角色名称 |
| description | 是        | 无        |    | VARCHAR(75)       | 描述     |

#### 表名：relations
* 用途描述：记录系统一对多和多对多关系
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名          | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------------|:----------|:----------|:---|:------------------|:---------|
| relation_id   | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| taxonomy_id   | 否        | 无        |    | INT UNSIGNED      | 分类标识 |
| ancestor_id   | 否        | 无        |    | INT UNSIGNED      | 先代     |
| descendant_id | 否        | 无        |    | INT UNSIGNED      | 后代     |
| creation_date | 否        | NOW()     |    | DATETIME          | 创建时间 |

### 表名：taxonomies
* 用途描述：分类信息
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名        | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:------------|:----------|:----------|:---|:------------------|:---------|
| taxonomy_id | 否        | 无        | PK | INT UNSIGNED      | 自增主键 |
| name        | 否        | 无        |    | VARCHAR(25)       | 分类名称 |
| description | 是        | 无        |    | VARCHAR(75)       | 分类描述 |

#### 表名：stats
* 用途描述：统计信息，用于着陆页看板，需要进一步细化
* 存储引擎：InnoDB
* 字符集：　utf8mb4
* 排序规则：utf8mb4_unicode_ci

| 列名    | 允许空    | 默认值    | 键 | 类型              | 说明     |
|:--------|:----------|:----------|:---|:------------------|:---------|
| stat_id | 否        | 无        | PK | INT UNSIGNED      |          |

* 考虑做成竖表，类似建值对，如用户查询次数/工单数量/审核通过/审核不过/审核次数等等。也就是统计信息的属主，类别，统计值。
* 考虑采用binlog解析->日志中继->发回给web服务器来准实时数据更新

