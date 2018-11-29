# 审核规则

## 规则总揽
* 必须是一个语法正确的SQL
* 根据SQL类型找到对应分组中的所有规则
* 规则分3个层级，一次递进验证
    - 层级之间不可同时验证
    - 层级1可以没有，但如果有，只要有任意一条规则验证不通过，则验证过程结束，报错退出
    - 层级2为基于SQL本身的抽象语法树与规则的比对
    - 层级3为需要连接到对应的实例进行的规则验证
* 启用，只有启用的规则才进行验证，是否启用逻辑value & 1 >= 1
* 配置，部分规则可以动态配置，是否可配置逻辑value & 2 >= 2


## 规则索引
* [01. 切换数据库规则](#use-database)
* [02. 创建数据库规则](#create-database)
* [03. 修改数据库规则](#alter-database)
* [04. 删除数据库规则](#drop-database)
* [05. 创建表规则](#create-table)
* [06. 修改表规则](#alter-table)
* [07. 重命名表规则](#rename-table)
* [08. 删除表规则](#drop-table)
* [09. 创建索引规则](#create-index)
* [10. 删除索引规则](#drop-index)
* [11. 新增数据-INSERT/REPLACE规则](#drop-index)
* [12. 修改数据-UPDATE规则](#update-data)
* [13. 删除数据-DELETE规则](#delete-data)
* [14. 查询数据-SELECT规则](#select-data)


## 待办事项
* 所有规则Review（名称、比较符、设定值、说明、启用和动态、层级、分组、错误信息）
* 在启用和动态中增加默认值
* 把关键字是否可以为标识符，打散到每个规则分组里面
* 每条规则的启用和动态的默认值


### use database
| 规则名称                        | 规则说明                   | 比较符 | 设定值 | 启用和动态  | 层级 | 分组         | 错误信息                              |
|---------------------------------|----------------------------|--------|--------|-------------|------|--------------|---------------------------------------|
| use-database-enabled            | 是否允许切换数据库         | eq     | true   | [4,5,6,_7_] | 1    | use-database | 当前规则不允许切换数据库。            |
| use-database-exists             | 要切换的目标数据库是否存在 | eq     | true   | [4,_5_,6,7] | 3    | use-database | 要切换的数据库"%s"在实例"%s"上不存在。|


### create database
---
| 规则名称                                | 规则说明                 | 比较符 | 设定值             | 权限        | 层级 | 分组            | 错误信息                                                                     |
|-----------------------------------------|--------------------------|--------|--------------------|-------------|------|-----------------|------------------------------------------------------------------------------|
| create-database-enabled                 | 是否允许创建数据库       | eq     | false              | [4,_5_,6,7] | 1    | database-create | 当前规则不允许创建数据库。                                                   |
| create-database-charsets                | 创建数据库允许的字符集   | in     | [utf8、utf8mb4]    | [4,5,6,_7_] | 2    | database-create | 新建库不允许使用字符集"%s"，请使用"%s"。                                     |
| create-database-collations              | 创建数据库允许的校验规则 | eq     | []                 | [4,5,6,_7_] | 2    | database-create | 新建库不允许使用排序规则"%s"，请使用"%s"。                                   |
| create-database-charset-collation-match | 字符集与校验规则必须匹配 | eq     | true               | [_5_]       | 2    | database-create | 新建库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。                 |
| create-database-name-regexp             | 库名必须符合命名规范     | regexp | \^[a-z][a-z0-9_]*$ | [4,5,6,_7_] | 2    | database-create | 新建库使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-database-name-max-length         | 库名最大长度，可配置     | lte    | 16                 | [4,5,6,_7_] | 2    | database-create | 新建库使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-database-exists                  | 创建的数据库已经存在     | eq     | false              | [4,_5_,6,7] | 3    | database-create | 要新建的库"%s"在实例"%s"上已存在，不能新建重复库。                           |


### alter database
--- 
| 规则名称                               | 规则说明                             | 比较符 | 设定值 | 权限         | 层级 | 分组            | 错误信息                                                     |
|----------------------------------------|--------------------------------------|--------|--------|--------------|------|-----------------|--------------------------------------------------------------|
| alter-database-enabled                 | 是否允许你alter db                   | eq     | false  | [4,5,6,_7_]  | 1    | database-alter  | 当前规则不允许修改数据库。                                   |
| alter-database-charsets                | alter db 时允许的字符集              | eq     | []     | [4,5,6,_7_]  | 2    | database-alter  | 修改库不允许使用字符集"%s"，请使用"%s"。                     |
| alter-database-collations              | alter db 时允许的校验规则            | in     | []     | [4,5,6,_7_]  | 2    | database-alter  | 修改库不允许使用排序规则"%s"，请使用"%s"。                   |
| alter-database-charset-collation-match | 修改字符集时字符集必须与校验规则匹配 | eq     | true   | [_5_]        | 2    | database-alter  | 新建库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。 |
| alter-database-exists                  | 检查alter 的 db是否存在              | eq     | true   | [4,_5_,6,7]  | 3    | database-alter  | 要修改的库"%s"在实例"%s"上不存在，不能修改不存在的库。       |


### drop database
--- 
| 规则名称                               | 规则说明                             | 比较符 | 设定值 | 权限         | 层级 | 分组          | 错误信息                           |
|----------------------------------------|--------------------------------------|--------|--------|--------------|------|---------------|------------------------------------|
| drop-database-enabled                  | 是否允许drop db                      | eq     | false  | [4,_5_,6,7]  | 1    | database-drop | 当前规则不允许删除数据库。         |
| drop-database-does-not-exist           | drop db 时检查db是否存在             | eq     | true   | [4,_5_,6,7]  | 2    | database-drop | 要删除的库"%s"在实例"%s"中不存在。 |


### create table
--- 
| 规则名称                                       | 规则说明                       | 比较符 | 设定值            | 权限         | 层级 | 分组         | 错误信息                                                                       |
|------------------------------------------------|--------------------------------|--------|-------------------|--------------|------|--------------|--------------------------------------------------------------------------------|
| create-table-enabled                           | 是否允许建表                   | eq     | true              | [4,5,6,_7_]  | 1    | table-create | 当前规则允不许创建新表。                                                       |
| create-table-charsets                          | 建表允许的字符集               | in     | [utf8 utf8mb4]    | [4,5,6,_7_]  | 2    | table-create | 新建表不允许使用字符集"%s"，请使用"%s"。                                       |
| create-table-engines                           | 建表允许的存储引擎             | in     | [innodb tokudb]   | [4,5,6,_7_]  | 2    | table-create | 新建表不允许使用存储引擎"%s"，请使用"%s"。                                     |
| create-table-collations                        | 建表允许的校验规则             | in     | []                | [4,_5_,6,7]  | 2    | table-create | 新建表不允许使用排序规则"%s"，请使用"%s"。                                     |
| create-table-charset-collation-match           | 建表是校验规则与字符集必须匹配 | eq     | true              | [_5_]        | 2    | table-create | 新建表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。                   |
| create-table-regexp                            | 表名必须符合命名规范           | regexp | \^[_a-zA-Z_]+$    | [4,_5_,6,7]  | 2    | table-create | 新建表使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                   |
| create-table-uppercase                         | 表名是否允许大写               | eq     | false             | [4,_5_,6,7]  | 2    | table-create | 新建表使用的标识符"%s"含有大写字母不被规则允许。                               |
| create-table-name-max-length                   | 表名最大长度                   | lte    | 16                | [4,5,6,_7_]  | 2    | table-create | 新建表使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。   |
| create-table-hascomment                        | 表名必须有注释                 | eq     | true              | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"需要提供COMMENT。                                                    |
| create-table-cols-hascomment                   | 字段名必须有注释               | eq     | true              | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"的字段"%s"需要提供COMMENT。                                          |
| create-table-column-charsets                   | 字段允许的字符集               | in     | []                | [4,5,6,_7_]  | 2    | table-create | 新建表"%s"中的字段"%s"不允许使用字符集"%s"，请使用"%s"。                       |
| create-table-column-collations                 | 字段允许的校验规则             | in     | []                | [4,5,6,_7_]  | 2    | table-create | 新建表"%s"中的字段"%s"不允许使用排序规则"%s"，请使用"%s"。                     |
| create-table-charset-collation-match-on-column | 字段的字符集与校验规则必须匹配 | eq     | true              | [_5_]        | 2    | table-create | 新建表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。                   |
| create-table-column-type-disallowed            | 不允许的字段类型                 | not-in | [enum set bit]    | [4,5,6,_7_]  | 2    | table-create | 新建表"%s"中的字段"%s"中指定的字符集"%s"和排序规则"%s"不匹配，请参考官方文档。 |
| create-table-column-regexp                     | 字段名必须符合命名规范         | regexp | \^[_a-zA-Z_]+$    | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的字段使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。       |
| create-table-dupli-column-name                 | 字段名是否重复                 | eq     | true              | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的字段"%s"名称有重复。                                             |
| create-table-maxcolumns                        | 表允许的字段个数，可配置       | lte    | 64                | [4,5,6,_7_]  | 2    | table-create | 新建表"%s"中定义%d个字段，字段数量超过允许的阈值%d。请考虑拆分表。             |
| create-table-indices-key-not-name              | 索引必须命名                   | eq     | true              | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中有一个或多个索引没有提供索引名称。                                 |
| create-table-indices-name-uppcase              | 索引名是否允许大写             | regexp | \^[_a-zA-Z_]+$    | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的索引"%s"标识符中含有大写字母不被规则允许。                       |
| create-table-indices-key-regexp                | 索引名必须符合前缀规范         | regexp | \^index_%d+$      | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的索引"%s"标识符不满足正则表达式"%s"。                             |
| create-table-max-key-count                     | 表中最多可建多少个索引         | lte    | 5                 | [4,5,6,_7_]  | 2    | table-create | 新建表"%s"中定义了%d个索引，索引数量超过允许的阈值%d。                         |
| create-table-unique-keys-not-name              | 唯一索引必须命名               | eq     | true              | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中有一个或多个唯一索引没有提供索引名称。                             |
| create-table-unique-keys-regexp                | 唯一索引命名必须符合规范       | regexp | \^[_a-zA-Z_]+$    | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的唯一索引"%s"标识符中含有大写字母不被规则允许。                   |
| create-table-unique-keys-name_prefxi           | 唯一索引名前缀必须是unique     | regexp | \^unique_%d+$     | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的唯一索引"%s"标识符不满足正则表达式"%s"。                         |
| create-table-primary-key-not-name              | 主键是否显式命名               | eq     | true              | [4,5,_6_,7]  | 2    | table-create | 新建表"%s"中的主键没有提供名称。                                               |
| create-table-primary-key-regexp                | 主键名必须符合明明规范         | regexp | \^pk_             | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的主键"%s"标识符不满足正则表达式"%s"。                             |
| create-table-incfield-types                    | 自增字段的类型是否是允许的类型 | in     | [int bigint]      | [4,5,6,_7_]  | 2    | table-create | 新建表"%s"中的自增字段"%s"不允许使用"%s"类型，请使用"%s"。                     |
| create-table-incfield-ispk                     | 检查自增字段是否是主键         | eq     | true              | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的自增字段"%s"不是主键。                                           |
| create-table-notnull-default                   | 非空字段是否有默认值           | eq     | true              | [4,_5_,6,7]  | 2    | table-create | 新建表"%s"中的字段"%s"不允许为空，但没有指定默认值。                           |
| create-table-as-select-enable                  | 是否允许create table as select | eq     | false             | [4,_5_,6,7]  | 2    | table-create | 当前规则不允许使用CREATE TABLE AS SELECT FROM的方式创建表。                    |
| create-table-max-timestamp-count               | 允许多少个timestamp类型的字段  | lte    | 1                 | [4,5,6,_7_]  | 2    | table-create | 新建表"%s"中的定义了两个或者两个以上的TIMESTAMP类型字段，请改用DATETIME类型。  |
| create-table-fk-enabled                        | 是否允许外键                   | eq     | false             | [4,_5_,6,7]  | 3    | table-create | 新建表"%s"中定义了外键"%s"，规则不允许。                                       |
| create-table-fk-regexp                         | 外键名必须符合命名规范         | regexp | \^fk_[_a-z0-9]+ $ | [4,_5_,6,7]  | 3    | table-create | 新建表"%s"中定义外键"%s"名字不合法。                                           |
| create-table-db-exists                         | 建表时检查目标库是否存在       | eq     | true              | [4,_5_,6,7]  | 3    | table-create | 要新建的表"%s"在实例"%s"的数据库"%s"不存在。                                   |
| create-table-exists                            | 建表时检查表是否已经存在       | eq     | true              | [4,_5_,6,7]  | 3    | table-create | 要新建的表"%s"所在的库"%s"中已存在。                                           |


### alter table
--- 
| 规则名称                            | 规则说明                                    | 比较符 | 设定值 | 权限         | 层级 | 分组        | 错误信息                                                                          |
|-------------------------------------|---------------------------------------------|--------|--------|--------------|------|-------------|-----------------------------------------------------------------------------------|
| alter-table-enabled                 | 是否允许alter table                         | eq     | true   | [4,5,6,_7_]  | 1    | table-alter | 当前规则不允许修改表。                                                            |
| alter-table-charsets                | alter table 允许的字符集                    | in     | []     | [4,5,6,_7_]  | 2    | table-alter | 修改表不允许使用字符集"%s"，请使用"%s"。                                          |
| alter-table-collations              | alter table 允许的校验规则                  | in     | []     | [4,5,6,_7_]  | 2    | table-alter | 修改表不允许使用排序规则"%s"，请使用"%s"。                                        |
| alter-table-charset-collation-match | alter table 时字符集必须与校验规则匹配      | eq     | true   | [_5_]        | 2    | table-alter | 修改表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。                      |
| alter-table-engines                 | alter table 时允许的存储引擎                | in     | []     | [4,5,6,_7_]  | 2    | table-alter | 修改表不允许使用存储引擎"%s"，请使用"%s"。                                        |
| alter-table-merge                   | 合并同一个表的alter                         | eq     | true   | [4,_5_,6,7]  | 2    | table-alter | 对同一个表"%s"的多条修改语句需要合并成一条语句。                                  |
| alter-table-add-comment             | 添加字段时必须有注释                        | eq     | true   | [4,_5_,6,7]  | 2    | table-alter | 修改表"%s"新增字段"%s"时需要为字段提供COMMENT。                                   |
| alter-table-exists                  | alter 的表是否存在                          | eq     | true   | [4,_5_,6,7]  | 3    | table-alter | 要修改的表"%s"在实例"%s"的数据库"%s"中不存在。                                    |
| alter-table-add-col-check           | 添加的字段是否存在                          | eq     | true   | [4,_5_,6,7]  | 3    | table-alter | 要修改表"%s"新增的字段"%s"已存在。                                                |
| alter-table-drop-col-check          | 删除的字段是否存在                          | eq     | true   | [4,_5_,6,7]  | 3    | table-alter | 要修改表"%s"删除的字段"%s"不存在。                                                |
| alter-table-add-position-check      | 有after、before关键字时检查相关字段是否存在 | eq     | true   | [4,_5_,6,7]  | 3    | table-alter | 要修改表"%s"为新增的字段"%s"指定位置BEFORE、AFTER中的参照字段"%s"在源表中不存在。 |


### rename table
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值 | 权限         | 层级 | 分组         | 错误信息                                           |
|---------------------------------|----------------------------------|--------|--------|--------------|------|--------------|----------------------------------------------------|
| rename-table-enabled            | 是否允许rename table             | eq     | false  | [4,5,6,_7_]  | 1    | table-rename | 当前规则不允许重命名表。                           |
| rename-table-odb-exists         | rename table时检查源库是否存在   | eq     | true   | [4,_5_,6,7]  | 3    | table-rename | 要更名的表"%s"的源数据库"%s"在实例"%s"中不存在。   |
| rename-table-otable-exists      | rename table时检查源表是否存在   | eq     | true   | [4,_5_,6,7]  | 3    | table-rename | 要更名的表"%s"在实例"%s"的源数据库"%s"中不存在。   |
| rename-table-ddb-exists         | rename table时检查目标库是否存在 | eq     | true   | [4,_5_,6,7]  | 3    | table-rename | 要更名的表"%s"的目标数据库"%s"在实例"%s"中不存在。 |
| rename-table-dtable-exists      | rename table时检查目标表是否存在 | eq     | true   | [4,_5_,6,7]  | 3    | table-rename | 要更名的表"%s"在实例"%s"的目标数据库"%s"中已存在。 |
| rename-table-same               | 目标表跟源表是同一个表           | eq     | true   | [4,_5_,6,7]  | 3    | table-rename | 要更名的表"%s"和目标表"%s"相同。                   |


### drop table
--- 
| 规则名称                       | 规则说明                    | 比较符 | 设定值 | 权限         | 层级  | 分组       | 错误信息                                       |
|--------------------------------|-----------------------------|--------|--------|--------------|-------|------------|------------------------------------------------|
| drop-table-enabled             | 是否允许drop 表             | eq     | false  | [4,_5_,6,7]  | 1     | table-drop | 当前规则不允许删除表。                         |
| drop-table-db-exists           | drop 表时检查所在库是否存在 | eq     | true   | [4,_5_,6,7]  | 3     | table-drop | 要删除的表"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-table-exists              | drop 的表是否存在           | eq     | true   | [4,_5_,6,7]  | 3     | table-drop | 要删除的表"%s"在实例"%s"的数据库"%s"中不存在。 |


### create index
--- 
| 规则名称                       | 规则说明                       | 比较符 | 设定值        | 权限         | 层级 |  分组        | 错误信息                                           |
|--------------------------------|--------------------------------|--------|---------------|--------------|------|--------------|----------------------------------------------------|
| mulindex-max-cols              | 组合索引允许的最大列数         | lte    | 5             | [4,5,6,_7_]  | 2    | index-create | 索引"%s"中索引字段数量超过允许的阈值%d。           |
| foreign-key-enable             | 是否允许外键                   | eq     | false         | [4,5,6,_7_]  | 2    | index-create | 当前规则不允许使用外建。                           |
| index-name-prefix-idx          | 普通索引名是否index_开头       | regexp | \^index_%d+$  | [4,_5_,6,7]  | 2    | index-create | 新建表"%s"中的索引"%s"标识符不满足正则表达式"%s"。 |
| index-on-blob-enable           | 是否允许在blob类型字段上建索引 | eq     | false         | [4,_5_,6,7]  | 2    | index-create | 当前规则不允许在BLOB类型的字段上建立索引。         |
| index-on-text-enable           | 是否允许在text类型字段上建索引 | eq     | false         | [4,_5_,6,7]  | 2    | index-create | 当前规则不允许在TEXT类型的字段上建立索引。         |
| index-check-dupli-col          | 组合索引中是否有重复字段       | eq     | false         | [4,_5_,6,7]  | 2    | index-create | 索引"%s"中索引的字段有重复。                       |
| index-check-duplicate          | 索引名是否重复                 | eq     | false         | [4,_5_,6,7]  | 3    | index-create | 索引"%s"在表"%s"已经存在，请使用另外一个索引名称。 |
| index-add-table-exists         | 条件索引的表是否存在           | eq     | true          | [4,_5_,6,7]  | 3    | index-create | 索引"%s"依赖的目标库"%s"不存在。                   |
| index-add-db-exists            | 添加索引的表所属库是否存在     | eq     | true          | [4,_5_,6,7]  | 3    | index-create | 索引"%s"依赖的目标表"%s"不存在。                   |
| index-add-field-exists         | 添加索引的字段是否存在         | eq     | true          | [4,_5_,6,7]  | 3    | index-create | 索引"%s"中索引的字段"%s"在表"%s"中不存在。         |
| indexs-count                   | 最多能建多少个索引             | lte    | 5             | [4,5,6,_7_]  | 3    | index-create | 索引数量超过允许的阈值%d。                         |


### drop index
--- 
| 规则名称                        | 规则说明                     | 比较符 | 设定值        | 权限         | 层级 |  分组      | 错误信息                                                     |
|---------------------------------|------------------------------|--------|---------------|--------------|------|------------|--------------------------------------------------------------|
| drop-index-enabled              | 是否允许删除索引             | eq     | true          | [4,_5_,6,7]  | 1    | index-drop | 当前规则不允许删除索引。                                     |
| drop-index-not-exists           | 要删除的索引是否村子         | eq     | true          | [4,_5_,6,7]  | 1    | index-drop | 要删除的索引"%s"在表"%s"中不存在。                           |
| drop-index-table-exists         | 删除索引时，目标表是否存在   | eq     | true          | [4,_5_,6,7]  | 1    | index-drop | 要删除的索引"%s"关联的表"%s"在实例"%s"的数据库"%s"中不存在。 | 
| drop-index-db-exists            | 删除索引时，目标库是否存在   | eq     | true          | [4,_5_,6,7]  | 1    | index-drop | 要删除的索引"%s"关联的表"%s"的数据库"%s"在实例"%s"中不存在。 | 


### insert data
--- 
| 规则名称                                | 规则说明                          | 比较符 | 设定值 | 权限         | 层级 | 分组        | 错误信息                                                  |
|-----------------------------------------|-----------------------------------|--------|--------|--------------|------|-------------|-----------------------------------------------------------|
| insert-without-explicit-columns-enabled | 是否允许不指定字段的insert        | eq     | false  | [4,_5_,6,7]  | 2    | data-insert | 当前规则不允许执行没有显式提供字段列表的INSERT语句。      |
| insert-select-enabled                   | 是否允许insert                    | eq     | false  | [4,5,6,_7_]  | 2    | data-insert | 当前规则不允许执行INSERT ... SELECT ...语句。             |
| insert-merge                            | 是否合并同表的单条insert          | eq     | true   | [4,_5_,6,7]  | 2    | data-insert | 多条INSERT语句需要合并成单条语句。                        |
| insert-max-rows-limit                   | 单个insert 允许插入的最大行数     | lte    | 10000  | [4,5,6,_7_]  | 2    | data-insert | 一条INSERT语句不得操作超过%d条记录。                      |
| insert-kv-match                         | insert时 字段类型、值类型是否匹配 | eq     | true   | [4,_5_,6,7]  | 2    | data-insert | INSERT语句的字段数量和值数量不匹配。                      |
| insert-table-exists                     | 要插入的表是否存在                | eq     | true   | [4,_5_,6,7]  | 3    | data-insert | INSERT语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。  |
| insert-db-exists                        | 要插入的表所属库是否存在          | eq     | true   | [4,_5_,6,7]  | 3    | data-insert | INSERT语句中指定的库"%s"在实例"%s"中不存在。              |
| insert-field-exists                     | insert 指定的字段是否存在         | eq     | true   | [4,_5_,6,7]  | 3    | data-insert | INSERT语句中指定的字段"%s"在源表中不存在。                |
| insert-notnull-field-hasvalue           | insert 时非空字段是否有值         | eq     | true   | [4,_5_,6,7]  | 3    | data-insert | INSERT语句没有为非空字段"%s"提供值。                      |


### replace data
---
| 规则名称                                 | 规则说明                          | 比较符 | 设定值 | 权限         | 层级 | 分组         | 错误信息                                                  |
|------------------------------------------|-----------------------------------|--------|--------|--------------|------|--------------|-----------------------------------------------------------|
| replace-without-explicit-columns-enabled | 是否允许不指定字段的replac 语句   | eq     | false  | [4,_5_,6,7]  | 2    | data-replace | 当前规则不允许执行没有显式提供字段列表的REPLACE语句。     |
| replace-select-enable                    | 是否允许replace into select       | eq     | false  | [4,_5_,6,7]  | 2    | data-replace | 当前规则不允许执行REPLACE ... SELECT ...语句。            |
| replace-max-rows-limit                   | 单次replace允许的最大行数         | lte    | 10000  | [4,5,6,_7_]  | 2    | data-replace | 一条REPLACE语句不得操作超过%d条记录。                     |
| replace-kv-match                         | replace时字段类型、值类型是否匹配 | eq     | ture   | [4,_5_,6,7]  | 2    | data-replace | REPLACE语句的字段数量和值数量不匹配。                     |
| replace-db-exists                        | replace时检查db是否存在           | eq     | true   | [4,_5_,6,7]  | 3    | data-replace | REPLACE语句中指定的库"%s"在实例"%s"中不存在。             |
| replace-table-exists                     | replace into 的表是否存在         | eq     | true   | [4,_5_,6,7]  | 3    | data-replace | REPLACE语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。 |
| repalce-notnull-field-hasvalue           | replace时非空字段是否有值         | eq     | true   | [4,_5_,6,7]  | 3    | data-replace | REPLACE语句没有为非空字段"%s"提供值。                     |


### update data
--- 
| 规则名称                            | 规则说明                       | 比较符 | 设定值 | 权限         | 层级 | 分组        | 错误信息                                               |
|-------------------------------------|--------------------------------|--------|--------|--------------|------|-------------|--------------------------------------------------------|
| update-without-where-clause-enabled | 是否允许没有where条件的update  | eq     | false  | [4,_5_,6,7]  | 3    | data-update | 当前规则不允许执行没有WHERE从句的更新语句。            |
| update-db_exists                    | update的表所属库是否存在       | eq     | true   | [4,_5_,6,7]  | 3    | data-update | 更新语句中指定的库"%s"在实例"%s"中不存在。             |
| update-table_exists                 | update的表是否存在             | eq     | true   | [4,_5_,6,7]  | 3    | data-update | 更新语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。 |
| update-fields-exists                | update的字段是否存在           | eq     | true   | [4,_5_,6,7]  | 3    | data-update | 更新语句中待更新的字段"%s"不存在。                     |
| update-where-fields_exists          | where条件中的字段是否存在      | eq     | true   | [4,_5_,6,7]  | 3    | data-update | 更新语句中WHERE从句中的字段"%s"在源表中不存在。        |
| update-maxrows_limit                | 允许单次更新的最大行数         | lte    | 10000  | [4,5,6,_7_]  | 3    | data-update | 当前规则不允许一次更新%d条或以上记录。                 |


### delete data
--- 
| 规则名称                            | 规则说明                       | 比较符 | 设定值 | 权限         | 层级 | 分组        | 错误信息                                             |
|-------------------------------------|--------------------------------|--------|--------|--------------|------|-------------|------------------------------------------------------|
| delete-without-where-clause-enabled | 是否允许没有where条件的delete  | eq     | false  | [4,_5_,6,7]  | 2    | data-delete | 当前规则不允许执行没有WHERE从句的删除语句。          |
| delete-maxrows-limit                | 允许单次删除的最大行数         | lte    | 10000  | [4,5,6,_7_]  | 3    | data-delete | 当前规则不允许一次删除%d条或以上记录。               |
| delete-db-exists                    | delete的表所属库是否存在       | eq     | true   | [4,_5_,6,7]  | 3    | data-delete | 删除语句中指的库"%s"在实例"%s"中不存在。             |
| delete-table-exists                 | delete的表是否存在             | eq     | true   | [4,_5_,6,7]  | 3    | data-delete | 删除语句中指的表"%s"在实例"%s"的数据库"%s"中不存在。 |
| delete-where-field-exists           | where条件中的字段是否存在      | eq     | true   | [4,_5_,6,7]  | 3    | data-delete | 删除语句中WHERE从句中的字段"%s"在源表中不存在。      |


### select data
--- 
| 规则名称                        | 规则说明                           | 比较符 | 设定值 | 权限         | 层级 | 分组        | 错误信息                                                       |
|---------------------------------|------------------------------------|--------|--------|--------------|------|-------------|----------------------------------------------------------------|
| select-without-where-enables    | 是否允许没有where条件的select      | eq     | false  | [4,_5_,6,7]  | 2    | data-select | 当前规则不允许执行没有WHERE从句的查询语句。                    |
| select-without-limit-enables    | 是否允许没有limit现在的select      | eq     | false  | [4,5,6,_7_]  | 2    | data-select | 当前规则不允许执行没有LIMIT从句的查询语句。                    |
| select-star-enables             | 是否允许select *                   | eq     | false  | [4,5,6,_7_]  | 2    | data-select | 当前规则不允许执行SELECT *操作，需要显式指定需要查询的列。     |
| select-for-update-enable        | 是否允许select for update          | eq     | false  | [4,_5_,6,7]  | 2    | data-select | 当前规则不允许执行SELECT FOR UPDATE操作。                      |
| select-db-exists                | select 指定的数据库是否存在        | eq     | true   | [4,_5_,6,7]  | 3    | data-select | 查询语句中指的库"%s"在实例"%s"中不存在。                       |
| select-table-exists             | 要select的表是否存在               | eq     | true   | [4,_5_,6,7]  | 3    | data-select | 查询语句中指的表"%s"在实例"%s"的数据库"%s"中不存在。           |
| select-fields-exists            | select的字段是否存在               | eq     | true   | [4,_5_,6,7]  | 3    | data-select | 查询语句中指的字段"%s"在实例"%s"的数据库"%s"的表"%s"中不存在。 |
| select-blob-enabled             | 是否允许查找blob类型字段值         | eq     | true   | [4,_5_,6,7]  | 3    | data-select | 查询语句中指的字段"%s"是BLOB类型，当前规则不允许执行此类查询。 |


### view-create
--- 
| 规则名称                        | 规则说明                 | 比较符 | 设定值          | 权限         | 层级 | 分组           | 错误信息                                                                       |
|---------------------------------|--------------------------|--------|-----------------|--------------|------|----------------|--------------------------------------------------------------------------------|
| create-view-enable              | 是否允许创建视图         | eq     | false           | [4,_5_,6,7]  | 1    | view-create    | 当前规则不允许创建视图。                                                       |
| create-view-regexp              | 视图名必须符合命名规范   | regexp | \^[_a-zA-Z_]+$  | [4,_5_,6,7]  | 2    | view-create    | 新建视图使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-view-name_max_length     | 视图名最大长度           | lte    | 16              | [4,5,6,_7_]  | 2    | view-create    | 新建视图使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-view-db_exists           | 视图所属的db是否存在     | eq     | true            | [4,_5_,6,7]  | 3    | view-create    | 新建视图"%s"使用的库"%s"在实例"%s"中不存在。                                   |
| create-view-exists              | 视图是否已存在           | eq     | false           | [4,_5_,6,7]  | 3    | view-create    | 视图"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### view-alter
--- 
| 规则名称                        | 规则说明                     | 比较符 | 设定值 | 权限         | 层级 | 分组       | 错误信息                                         |
|---------------------------------|------------------------------|--------|--------|--------------|------|------------|--------------------------------------------------|
| alter-view-enable               | 是否允许修改视图             | eq     | false  | [4,_5_,6,7]  | 1    | view-alter | 当前规则不允许修改视图。                         |
| alter-view-db_exists            | 检查修改的视图所属库是否存在 | eq     | true   | [4,_5_,6,7]  | 3    | view-alter | 要修改的视图"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-view-exists               | 检查要修改的视图是否存在     | eq     | true   | [4,_5_,6,7]  | 3    | view-alter | 要修改的视图"%s"在实例"%s"的数据库"%s"中不存在。 |


### view-drop
--- 
| 规则名称                        | 规则说明                     | 比较符 | 设定值 | 权限         | 层级 | 分组      | 错误信息                                         |
|---------------------------------|------------------------------|--------|--------|--------------|------|-----------|--------------------------------------------------|
| drop-view-enable                | 是否允许删除视图             | eq     | false  | [4,_5_,6,7]  | 1    | view-drop | 当前规则不允许删除视图。                         |
| drop-view-db-exists             | 检查删除的视图所属库是否存在 | eq     | true   | [4,_5_,6,7]  | 3    | view-drop | 要删除的视图"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-view-exists                | 检查要删除的视图是否存在     | eq     | true   | [4,_5_,6,7]  | 3    | view-drop | 要删除的视图"%s"在实例"%s"的数据库"%s"中不存在。 |


### function-create
--- 
| 规则名称                        | 规则说明                     | 比较符 | 设定值         | 权限         | 层级 | 分组        | 错误信息                                                                       |
|---------------------------------|------------------------------|--------|----------------|--------------|------|-------------|--------------------------------------------------------------------------------|
| create-func-enable              | 是否允许创建函数             | eq     | false          | [4,5,6,_7_]  | 1    | func-create | 当前规则不允许修改函数。                                                       |
| create-func-name-regexp         | 函数名是否符合命名规范       | regexp | \^[_a-zA-Z_]+$ | [4,5,6,_7_]  | 2    | func-create | 新建函数使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-func-name-max-length     | 函数名最大长度               | lte    | 16             | [4,5,6,_7_]  | 2    | func-create | 新建函数使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-func-db-exists           | 函数所属库是否存在           | eq     | true           | [4,_5_,6,7]  | 3    | func-create | 新建函数"%s"所在的库"%s"在实例"%s"中不存在。                                   |
| create-func-exists              | 函数是否以及存在             | eq     | false          | [4,_5_,6,7]  | 3    | func-create | 函数"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### function-alter
--- 
| 规则名称                        | 规则说明                    | 比较符 | 设定值 | 权限         | 层级 | 分组       | 错误信息                                         |
|---------------------------------|-----------------------------|--------|--------|--------------|------|------------|--------------------------------------------------|
| alter-func-anble                | 是否允许修改函数            | eq     | false  | [4,5,6,_7_]  | 1    | func-alter | 当前规则不允许修改函数。                         |
| alter-func-db-exists            | 函数所属库是否存在          | eq     | true   | [4,_5_,6,7]  | 3    | func-alter | 要修改的函数"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-func-exists               | 函数是否存在                | eq     | false  | [4,_5_,6,7]  | 3    | func-alter | 要修改的函数"%s"在实例"%s"的数据库"%s"中不存在。 |


### function-drop
--- 
| 规则名称                        | 规则说明                    | 比较符 | 设定值 | 权限         | 层级 | 分组      | 错误信息                                         |
|---------------------------------|-----------------------------|--------|--------|--------------|------|-----------|--------------------------------------------------|
| drop-func-enable                | 是否允许删除函数            | eq     | false  | [4,5,6,_7_]  | 1    | func-drop | 当前规则不允许删除函数。                         |
| drop-func-db-exists             | 函数所属库是否存在          | eq     | true   | [4,_5_,6,7]  | 3    | func-drop | 要删除的函数"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-func-exists                | 要删除的函数是否存在        | eq     | true   | [4,_5_,6,7]  | 3    | func-drop | 要删除的函数"%s"在实例"%s"的数据库"%s"中不存在。 |


### trigger-create
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值         | 权限         | 层级 | 分组           | 错误信息                                                                         |
|---------------------------------|----------------------------------|--------|----------------|--------------|------|----------------|----------------------------------------------------------------------------------|
| create-trigger-enable           | 是否允许创建trigger              | eq     | false          | [4,5,6,_7_]  | 1    | trigger-create | 当前规则不允许创建触发器。                                                       |
| create-trigger-name-regexp      | trigger名是否符合命名规范        | regexp | \^[_a-zA-Z_]+$ | [4,_5_,6,7]  | 2    | trigger-create | 新建触发器使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-trigger-name-max-length  | trigger名最大长度                | lte    | 32             | [4,5,6,_7_]  | 2    | trigger-create | 新建触发器使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-trigger-db-exists        | trigger所属库是否存在            | lte    | true           | [4,_5_,6,7]  | 2    | trigger-create | 新建触发器使用的标识符"%s"使用的数据库"%s" 在实例"%s"种不存在。                  |
| create-trigger-exists           | trigger是否存在                  | eq     | false          | [4,_5_,6,7]  | 2    | trigger-create | 新建触发器使用的标识符"%s"在实例"%s"的数据库"%s"中已经存在。                     |

### trigger-alter
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值 | 权限         | 层级 | 分组          | 错误信息                                         |
|---------------------------------|----------------------------------|--------|--------|--------------|------|---------------|--------------------------------------------------|
| alter-trigger-enable            | 是否允许修改trigger              | eq     | false  | [4,5,6,_7_]  | 1    | trigger-alter | 当前规则不允许修改触发器。                       |
| alter-trigger-db-exists         | rigger所属库是否存在             | eq     | true   | [4,_5_,6,7]  | 3    | trigger-alter | 要修改的函数"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-trigger-exists            | trigger是否存在                  | eq     | false  | [4,_5_,6,7]  | 3    | trigger-alter | 要修改的函数"%s"在实例"%s"的数据库"%s"中不存在。 |

### trigger-drop
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值 | 权限         | 层级 | 分组         | 错误信息                                           |
|---------------------------------|----------------------------------|--------|--------|--------------|------|--------------|----------------------------------------------------|
| drop-trigger-enable             | 是否允许删除trigger              | eq     | false  | [4,5,6,_7_]  | 1    | trigger-drop | 当前规则不允许删除触发器。                         |
| drop-trigger-db-exists          | trigger所属库是否存在            | eq     | true   | [4,_5_,6,7]  | 3    | trigger-drop | 要修改的触发器"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-trigger-exists             | trigger是否存在                  | eq     | true   | [4,_5_,6,7]  | 3    | trigger-drop | 要修改的触发器"%s"在实例"%s"的数据库"%s"中不存在。 |

### event-create
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值         | 权限         | 层级 | 分组         | 错误信息                                                                       |
|---------------------------------|----------------------------------|--------|----------------|--------------|------|--------------|--------------------------------------------------------------------------------|
| create-event-enable             | 是否允许创建event                | eq     | false          | [4,5,6,_7_]  | 1    | event-create | 当前规则不允许创建事件。                                                       |
| create-event-name_regexp        | event名是否符合命名规范          | regexp | \^[_a-zA-Z_]+$ | [4,_5_,6,7]  | 2    | event-create | 新建事件使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-event-name-max-length    | event名允许的最大长度            | lte    | 16             | [4,5,6,_7_]  | 2    | event-create | 新建事件使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-event-db-exists          | event所属库是否存在              | eq     | true           | [4,_5_,6,7]  | 3    | event-create | 新建事件"%s"所在的库"%s"在实例"%s"中不存在。                                   |
| create-event-exists             | event是否存在                    | eq     | false          | [4,_5_,6,7]  | 3    | event-create | 事件"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### event-alter
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值 | 权限         | 层级 | 分组        | 错误信息                                         |
|---------------------------------|----------------------------------|--------|--------|--------------|------|-------------|--------------------------------------------------|
| alter-event-enable              | 是否允许修改event                | eq     | false  | [4,5,6,_7_]  | 1    | event-alter | 当前规则不允许修改事件。                         |
| alter-event-db-exists           | event所属库是否存在              | eq     | true   | [4,_5_,6,7]  | 3    | event-alter | 要修改的事件"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-event-exists              | event是否存在                    | eq     | true   | [4,_5_,6,7]  | 3    | event-alter | 要修改的事件"%s"在实例"%s"的数据库"%s"中不存在。 |


### event-drop
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值 | 权限         | 层级 | 分组       | 错误信息                                         |
|---------------------------------|----------------------------------|--------|--------|--------------|------|------------|--------------------------------------------------|
| drop-event-enable               | 是否允许删除event                | eq     | false  | [4,5,6,_7_]  | 1    | event-drop | 当前规则不允许删除事件。                         |
| drop-event-db-exists            | event所属库是否存在              | eq     | true   | [4,_5_,6,7]  | 3    | event-drop | 要删除的事件"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-event-exists               | event是否存在                    | eq     | true   | [4,_5_,6,7]  | 3    | event-drop | 要删除的事件"%s"在实例"%s"的数据库"%s"中不存在。 |


### procedure-create
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值         | 权限         | 层级 | 分组             | 错误信息                                                                           |
|---------------------------------|----------------------------------|--------|----------------|--------------|------|------------------|------------------------------------------------------------------------------------|
| create-procedure-enable         | 是否允许创建存储过程             | eq     | false          | [4,5,6,_7_]  | 1    | procedure-create | 当前规则不允许创建存储过程。                                                       |
| create-procedure-regexp         | 存储过程命名是否符合规范         | regexp | \^[_a-zA-Z_]+$ | [4,_5_,6,7]  | 2    | procedure-create | 新建存储过程使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-procedure-max-length     | 存储过程名允许的最大长度         | lte    | 32             | [4,_5_,6,7]  | 2    | procedure-create | 新建存储过程使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-procedure-db-exists      | 存储过程所属库是否存在           | eq     | true           | [4,_5_,6,7]  | 3    | procedure-create | 新建存储过程"%s"所在的库在实例"%s"中不存在。                                       |
| create-procedure-exists         | 存储过程是否存在                 | eq     | false          | [4,_5_,6,7]  | 3    | procedure-create | 存储过程"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### procedure-alter
--- 
| 规则名称                        | 规则说明                         | 比较符 | 设定值 | 权限        | 层级 | 分组            | 错误信息                                             |
|---------------------------------|----------------------------------|-------|--------|-------------|------|-----------------|------------------------------------------------------|
| alter-procedure-enable          | 是否允许修改存储过程             | eq     | false  | [4,5,6,_7_] | 1    | procedure-alter | 当前规则不允许修改存储过程。                         |
| alter-procedure-db-exist        | 存储过程所属库是否存在           | eq     | true   | [4,_5_,6,7] | 3    | procedure-alter | 要修改的存储过程"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-procedure-exits           | 存储过程是否存在                 | eq     | true   | [4,_5_,6,7] | 3    | procedure-alter | 要修改的存储过程"%s"在实例"%s"的数据库"%s"中不存在。 |


### procedure-drop
--- 
| 规则名称                      | 规则说明                            | 比较符 | 设定值 | 权限        | 层级 | 分组           | 错误信息                                             |
|-------------------------------|-------------------------------------|--------|--------|-------------|------|----------------|------------------------------------------------------|
| drop-procedure-enable         | 是否允许删除存储过程                | eq     | false  | [4,5,6,_7_] | 1    | procedure-drop | 当前规则不允许删除存储过程。                         |
| drop-procedure-db-exists      | 存储过程所属库是否存在              | eq     | true   | [4,_5_,6,7] | 3    | procedure-drop | 要删除的存储过程"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-procedure-exits          | 存储过程是否存在                    | eq     | true   | [4,_5_,6,7] | 3    | procedure-drop | 要删除的存储过程"%s"在实例"%s"的数据库"%s"中不存在。 |


### misc
--- 
| 规则名称                        | 规则说明                                   | 比较符 | 设定值 | 权限         | 层级 | 分组               | 错误信息                                                             |
|---------------------------------|--------------------------------------------|--------|--------|--------------|------|--------------------|----------------------------------------------------------------------|
| lock-table-enabled              | 是否允许lock table                         | eq     | false  | [4,_5_,6,7]  | 1    | no-allow-statement | 当前规则不允许执行LOCK TABLE命名。                                   |
| flush-table-enabled             | 是否允许flush table                        | eq     | false  | [4,_5_,6,7]  | 1    | no-allow-statement | 当前规则不允许执行FLUSH TABLE命令。                                  |
| truncate-table-enabled          | 是否允许truncat table                      | eq     | false  | [4,_5_,6,7]  | 1    | no-allow-statement | 当前规则不允许执行TRUNCATE TABLE命令。                               |
| purge-binlog-enabled            | 是否允许purge binary                       | eq     | false  | [4,_5_,6,7]  | 1    | no-allow-statement | 当前规则不允许执行PURGE BINARY LOGS命令。                            |
| purge-logs-enabled              | 是否允许purge log                          | eq     | false  | [4,_5_,6,7]  | 1    | no-allow-statement | 当前规则不允许执行PURGE LOGS命令。                                   |
| unlock-tables-enabled           | 是否允许unlock table                       | eq     | false  | [4,_5_,6,7]  | 1    | no-allow-statement | 当前规则不允许执行UNLOCK TABLES命令。                                |
| kill-enabled                    | 是否允许kill 线程                          | eq     | false  | [4,_5_,6,7]  | 1    | no-allow-statement | 当前规则不允许执行KILL命令。                                         |
| keyword-enable                  | 是否允许使用mysql 关键字                   | eq     | false  | [4,_5_,6,7]  | 1    | keyword            | 当前规则不允许使用保留关键字作为标识符。                             |
| mixed-ddl-dml                   | 同一个工单里是否允许同时存在ddl、dml 语句  | eq     | true   | [4,_5_,6,7]  | 1    | mixed-ddl-dml      | 当前规则不允许在一个工单中同时出现DML和DDL操作，请分开多个工单提交。 |

