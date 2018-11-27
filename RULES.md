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
| 规则名称                        | 比较符 | 设定值 | 启用和动态  | 层级 | 分组         | 错误信息                              |
|---------------------------------|--------|--------|-------------|------|--------------|---------------------------------------|
| use-database-check              | eq     | true   | [4,_5_,6,7] | 3    | use-database | 要切换的数据库"%s"在实例"%s"上不存在。|


### create database
---
| 规则名称                                | 比较符 | 设定值             | 启用和配置  | 层级 | 分组            | 错误信息                                                                     |
|-----------------------------------------|--------|--------------------|-------------|------|-----------------|------------------------------------------------------------------------------|
| create-database-enabled                 | eq     | false              | [4,_5_,6,7] | 1    | create-database | 当前规则不允许创建数据库。                                                   |
| create-database-charsets                | in     | [utf8、utf8mb4]    | [4,5,6,_7_] | 2    | create-database | 新建库不允许使用字符集"%s"，请使用"%s"。                                     |
| create-database-collations              | in     | []                 | [4,5,6,_7_] | 2    | create-database | 新建库不允许使用排序规则"%s"，请使用"%s"。                                   |
| create-database-charset-collation-match | eq     | true               | [_5_]       | 2    | create-database | 新建库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。                 |
| create-database-name-regexp             | regexp | \^[a-z][a-z0-9_]*$ | [4,5,6,_7_] | 2    | create-database | 新建库使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-database-name-max-length         | lte    | 16                 | [4,5,6,_7_] | 2    | create-database | 新建库使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-database-exists                  | eq     | false              | [4,_5_,6,7] | 3    | create-database | 要新建的库"%s"在实例"%s"上已存在，不能新建重复库。                           |


### alter database
--- 
| 规则名称                               | 比较符 | 设定值 | 启用和配置 | 分组            | 层级 | 错误信息                                                     |
|----------------------------------------|--------|--------|------------|-----------------|------|--------------------------------------------------------------|
| alter-database-enabled                 | eq     | false  | [4,5,6,7]  | alter-database  | 1    | 当前规则不允许修改数据库。                                   |
| alter-database-charsets                | in     | []     | [4,5,6,7]  | alter-database  | 2    | 修改库不允许使用字符集"%s"，请使用"%s"。                     |
| alter-database-collations              | in     | []     | [4,5,6,7]  | alter-database  | 2    | 修改库不允许使用排序规则"%s"，请使用"%s"。                   |
| alter-database-charset-collation-match | eq     | true   | [5]        | alter-database  | 2    | 新建库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。 |
| alter-database-??                      | eq     | true   | [4,5,6,7]  | alter-database  | 3    | 要修改的库"%s"在实例"%s"上不存在，不能修改不存在的库。       |


### drop database
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组          | 错误信息                                               |
|---------------------------------|--------|--------|------------|------|---------------|--------------------------------------------------------|
| drop-database-enabled           |  eq    | false  | [4,5,6,7]  | 1    | drop-database | 当前规则不允许删除数据库。                             |
| drop-database目标库不存在       |  eq    | true   | [4,5,6,7]  | 2    | drop-database | 要删除的库"%s"在实例"%s"上不存在，不能删除不存在的库。 |


### create table
--- 
| 规则名称                             | 比较符 | 设定值          | 启用和配置 | 层级 | 分组         | 错误信息                                                                       |
|--------------------------------------|--------|-----------------|------------|------|--------------|--------------------------------------------------------------------------------|
| create-table-enabled                 | eq     | true            | [4,5,6,7]  | 1    | create-table | 当前规则不允许创建新表。                                                       |
| create-table-charsets                | in     | [utf8 utf8mb4]  | [4,5,6,7]  | 2    | create-table | 新建表不允许使用字符集"%s"，请使用"%s"。                                       |
| create-table-engines                 | in     | [innodb tokudb] | [4,5,6,7]  | 2    | create-table | 新建表不允许使用存储引擎"%s"，请使用"%s"。                                     |
| create-table-collations              | in     | []              | [4,5,6,7]  | 2    | create-table | 新建表不允许使用排序规则"%s"，请使用"%s"。                                     |
| create-table-charset-collation-match | eq     | true            | [5]        | 2    | create-table | 新建表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。                   |
| create-table-??                      | regexp | \^[_a-zA-Z_]+$  | [4,5,6,7]  | 2    | create-table | 新建表使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                   |
| create-table-uppercase               | eq     | false           | [4,5,6,7]  | 2    | create-table | 新建表使用的标识符"%s"含有大写字母不被规则允许。                               |
| create-table-name-max-length         | lte    | 16              | [4,5,6,7]  | 2    | create-table | 新建表使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。   |
| create-table-hascomment              | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"需要提供COMMENT。                                                    |
| create-table-cols-hascomment         | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"的字段"%s"需要提供COMMENT。                                          |
| create-table-column-charsets         | in     | []              | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的字段"%s"不允许使用字符集"%s"，请使用"%s"。                       |
| create-table-column-collations       | in     | []              | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的字段"%s"不允许使用排序规则"%s"，请使用"%s"。                     |
| create-table-column-type             | not in | [enum set bit]  | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的字段"%s"中指定的字符集"%s"和排序规则"%s"不匹配，请参考官方文档。 |
| create-table-column-??               | regexp | \^[_a-zA-Z_]+$  | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的字段使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。       |
| create-table-dupli-column-??         | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的字段"%s"名称有重复。                                             |
| create-table-maxcolumns              | lte    | 64              | [4,5,6,7]  | 2    | create-table | 新建表"%s"中定义%d个字段，字段数量超过允许的阈值%d。请考虑拆分表。             |
| create-table-indices-??              | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"中有一个或多个索引没有提供索引名称。                                 |
| create-table-indices-??              | regexp | \^[_a-zA-Z_]+$  | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的索引"%s"标识符中含有大写字母不被规则允许。                       |
| create-table-indices-??              | regexp | \^index_%d+$    | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的索引"%s"标识符不满足正则表达式"%s"。                             |
| create-table-indices-??              | lte    | 5               | [4,5,6,7]  | 2    | create-table | 新建表"%s"中定义了%d个索引，索引数量超过允许的阈值%d。                         |
| create-table-unique-keys-??          | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"中有一个或多个唯一索引没有提供索引名称。                             |
| create-table-unique-keys-??          | regexp | \^[_a-zA-Z_]+$  | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的唯一索引"%s"标识符中含有大写字母不被规则允许。                   |
| create-table-unique-keys-??          | regexp | \^unique_%d+$   | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的唯一索引"%s"标识符不满足正则表达式"%s"。                         |
| create-table-primary-key-??          | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的主键没有提供名称。                                               |
| create-table-primary-key-??          | regexp | \^pk_           | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的主键"%s"标识符不满足正则表达式"%s"。                             |
| create-table-incfield-types          | in     | [int bigint]    | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的自增字段"%s"不允许使用"%s"类型，请使用"%s"。                     |
| create-table-incfield-ispk           | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的自增字段"%s"不是主键。                                           |
| create-table-notnull-default         | eq     | true            | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的字段"%s"不允许为空，但没有指定默认值。                           |
| create-table-as-select-enable        | eq     | false           | [4,5,6,7]  | 2    | create-table | 当前规则不允许使用CREATE TABLE AS SELECT FROM的方式创建表。                    |
| create-table-??                      | lte    | 5               | [4,5,6,7]  | 2    | create-table | 新建表"%s"中的定义了两个或者两个以上的TIMESTAMP类型字段，请改用DATETIME类型。  |
| create-table-??                      | eq     | true            | [4,5,6,7]  | 3    | create-table | 新建表"%s"在实例"%s"的数据库"%s"中已存在。                                     |


### alter table
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组        | 错误信息                                                                  |
|---------------------------------|--------|--------|------------|------|-------------|---------------------------------------------------------------------------|
| alter-table-enabled             | eq     | true   | [4,5,6,7]  | 1    | alter-table | 当前规则不允许修改表。                                                    |
| alter-table-charsets            | in     | []     | [4,5,6,7]  | 2    | alter-table | 修改表不允许使用字符集"%s"，请使用"%s"。                                  |
| alter-table-collations          | in     | []     | [4,5,6,7]  | 2    | alter-table | 修改表不允许使用排序规则"%s"，请使用"%s"。                                |
| alter-table-engines             | in     | []     | [4,5,6,7]  | 2    | alter-table | 修改表不允许使用存储引擎"%s"，请使用"%s"。                                |
| alter-table-merge               | eq     | true   | [4,5,6,7]  | 2    | alter-table | 对同一个表"%s"的多条修改语句需要合并成一条语句。                          |
| alter-table-add-check-comment   | eq     | true   | [4,5,6,7]  | 2    | alter-table | 修改表"%s"新增字段"%s"时需要为字段提供COMMENT。                           |
| alter-table-check-exists        | eq     | true   | [4,5,6,7]  | 3    | alter-table | 要修改的表"%s"在实例"%s"的数据库"%s"中不存在。                            |
| alter-table-add-col-check       | eq     | true   | [4,5,6,7]  | 3    | alter-table | 要修改表"%s"新增的字段"%s"已存在。                                        |
| alter-table-drop-col-check      | eq     | true   | [4,5,6,7]  | 3    | alter-table | 要修改表"%s"删除的字段"%s"不存在。                                        |
| alter-table-add-position-check  | eq     | true   | [4,5,6,7]  | 3    | alter-table | 要修改表"%s"为新增的字段"%s"指定位置BEFORE、AFTER中的参照字段"%s"不存在。 |


### rename table
--- 
| 规则名称                         | 比较符 | 设定值 | 启用和配置 | 层级 | 分组         | 错误信息                                           |
|----------------------------------|--------|--------|------------|------|--------------|----------------------------------------------------|
| rename-table-enabled             |  eq    | true   | [4,5,6,7]  | 1    | rename-table | 当前规则不允许重命名表。                           |
| rename-table-check-odb-exists    |  eq    | true   | [4,5,6,7]  | 3    | rename-table | 要更名的表"%s"的源数据库"%s"在实例"%s"中不存在。   |
| rename-table-check-otable-exists |  eq    | true   | [4,5,6,7]  | 3    | rename-table | 要更名的表"%s"在实例"%s"的源数据库"%s"中不存在。   |
| rename-table-check-ddb-exists    |  eq    | true   | [4,5,6,7]  | 3    | rename-table | 要更名的表"%s"的目标数据库"%s"在实例"%s"中不存在。 |
| rename-table-check-dtable-exists |  eq    | true   | [4,5,6,7]  | 3    | rename-table | 要更名的表"%s"在实例"%s"的目标数据库"%s"中已存在。 |
| rename-table-check-same          |  eq    | true   | [4,5,6,7]  | 3    | rename-table | 要更名的表"%s"和目标表"%s"相同。                   |


### drop table
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级  | 分组       | 错误信息                                       |
|---------------------------------|--------|--------|------------|-------|------------|------------------------------------------------|
| drop-table-enabled              |   eq   | true   | [4,5,6,7]  | 1     | table-drop | 当前规则不允许删除表。                         |
| drop-table-??                   | eq     | false  | [4,5,6,7]  | 3     | table-drop | 要删除的表"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-table-??                   | eq     | false  | [4,5,6,7]  | 3     | table-drop | 要删除的表"%s"在实例"%s"的数据库"%s"中不存在。 |


### create index
--- 
| 规则名称                        | 比较符 | 设定值        | 规则说明                    | 启用和配置 | 层级 |  分组            | 错误信息 |
|---------------------------------|--------|---------------|-----------------------------|------------|------|------------------|----------|
| mulindex-max-cols               | lte    | 5             | 联合索引最大列数， 可配置   | [4,5,6,7]  | 2    | index-create     |
| foreign-key-enable              | eq     | false         | 不允许外键                  | [4,5,6,7]  | 2    | index-create     |
| index-name-prefix-idx           | regexp | \^index_%d+$  | 普通索引名以index开头       | [4,5,6,7]  | 2    | index-create     |
| index-on-blob-enable            | eq     | true          | 不允许在blob字段上建立索引  | [4,5,6,7]  | 2    | index-create     |
| index-on-text-enable            | eq     | true          | 不允许在text字段上建立索引  | [4,5,6,7]  | 2    | index-create     |
| index-check-dupli-col           | eq     | true          | 检查索引列是否重复          | [4,5,6,7]  | 2    | index-create     |
| index-check-duplicate           | eq     | true          | 检查索引是否重名            | [4,5,6,7]  | 3    | index-create     |
| index-add-check-table-exists    | eq     | true          | 检查库是否存在              | [4,5,6,7]  | 3    | index-create     |
| index-add-check-db-exists       | eq     | true          | 检查表是否存在              | [4,5,6,7]  | 3    | index-create     |
| index-add-check-field-exists    | eq     | true          | 检查列是否存在              | [4,5,6,7]  | 3    | index-create     |
| indexs-count                    | lte    | 5             | 每个表最多5个索引，可配置   | [4,5,6,7]  | 3    | index-create     |


### drop index
--- 
| 规则名称                        | 比较符 | 设定值        | 启用和配置 | 层级 |  分组            | 错误信息                 |
|---------------------------------|--------|---------------|------------|------|------------------|--------------------------|
| drop-index-enabled              |   eq   | true          | [4,5,6,7]  | 1    | drop-index       | 当前规则不允许删除索引。 |
| drop-index-??                   |   eq   | true          | [4,5,6,7]  | 1    | drop-index       | 

* index不存在 ?
* 表不存在 ?
* 其他 ?

### insert、replace into
--- 
| 规则名称                                 | 比较符 | 设定值 | 启用和配置 | 层级 | 分组        | 错误信息                                                  |
|------------------------------------------|--------|--------|------------|------|-------------|-----------------------------------------------------------|
| insert-without-explicit-columns-enabled  | eq     | true   | [4,5,6,7]  | 2    | insert-data | 当前规则不允许执行没有显式提供字段列表的INSERT语句。      |
| insert-select-enabled                    | eq     | true   | [4,5,6,7]  | 2    | insert-data | 当前规则不允许执行INSERT ... SELECT ...语句。             |
| replace-without-explicit-columns-enabled | eq     | true   | [4,5,6,7]  | 2    | insert-data | 当前规则不允许执行没有显式提供字段列表的REPLACE语句。     |
| replace-select-enable                    | eq     | false  | [4,5,6,7]  | 2    | insert-data | 当前规则不允许执行REPLACE ... SELECT ...语句。            |
| insert-merge                             | eq     | true   | [4,5,6,7]  | 2    | insert-data | 多条INSERT语句需要合并成单条语句。                        |
| insert-max-rows-limit                    | eq     | 10000  | [4,5,6,7]  | 2    | insert-data | 一条INSERT语句不得操作超过%d条记录。                      |
| replace-max-rows-limit                   | eq     | 10000  | [4,5,6,7]  | 2    | insert-data | 一条REPLACE语句不得操作超过%d条记录。                     |
| insert-check-kv-match                    | eq     | true   | [4,5,6,7]  | 2    | insert-data | INSERT语句的字段数量和值数量不匹配。                      |
| replace-check-kv-match                   | eq     | ture   | [4,5,6,7]  | 2    | insert-data | REPLACE语句的字段数量和值数量不匹配。                     |
| insert-check-table-exists                | eq     | true   | [4,5,6,7]  | 3    | insert-data | INSERT语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。  |
| insert-check-db-exists                   | eq     | true   | [4,5,6,7]  | 3    | insert-data | INSERT语句中指定的库"%s"在实例"%s"中不存在。              |
| insert-check-field-exists                | eq     | true   | [4,5,6,7]  | 3    | insert-data | INSERT语句中指定的字段"%s"不存在。                        |
| insert-notnull-field-hasvalue            | eq     | true   | [4,5,6,7]  | 3    | insert-data | INSERT语句没有为非空字段"%s"提供值。                      |
| replace-check-db-exists                  | eq     | true   | [4,5,6,7]  | 3    | insert-data | REPLACE语句中指定的库"%s"在实例"%s"中不存在。             |
| replace-check-table-exists               | eq     | true   | [4,5,6,7]  | 3    | insert-data | REPLACE语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。 |
| repalce-notnull-field-hasvalue           | eq     | true   | [4,5,6,7]  | 3    | insert-data | REPLACE语句没有为非空字段"%s"提供值。                     |


### update data
--- 
| 规则名称                            | 比较符 | 设定值 | 启用和配置 | 层级 | 分组        | 错误信息                                               |
|-------------------------------------|--------|--------|------------|------|-------------|--------------------------------------------------------|
| update-without-where-clause-enabled | eq     | false  | [4,5,6,7]  | 3    | update-data | 当前规则不允许执行没有WHERE从句的更新语句。            |
| update-check-db_exist               | eq     | true   | [4,5,6,7]  | 3    | update-data | 更新语句中指定的库"%s"在实例"%s"中不存在。             |
| update-check-table_exist            | eq     | true   | [4,5,6,7]  | 3    | update-data | 更新语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。 |
| update-check-fields-exists          | eq     | true   | [4,5,6,7]  | 3    | update-data | 更新语句中待更新的字段"%s"不存在。                     |
| update-check-where-fields_exists    | eq     | true   | [4,5,6,7]  | 3    | update-data | 更新语句中WHERE从句中的字段"%s"不存在。                |
| update-maxrows_limit                | eq     | 10000  | [4,5,6,7]  | 3    | update-data | 当前规则不允许一次更新%d条或以上记录。                 |


### delete data
--- 
| 规则名称                            | 比较符 | 设定值 | 启用和配置 | 层级 | 分组        | 错误信息                                             |
|-------------------------------------|--------|--------|------------|------|-------------|------------------------------------------------------|
| delete-without-where-clause-enabled | eq     | false  | [4,5,6,7]  | 2    | delete-data | 当前规则不允许执行没有WHERE从句的删除语句。          |
| delete-maxrows-limit                | eq     | 10000  | [4,5,6,7]  | 3    | delete-data | 当前规则不允许一次删除%d条或以上记录。               |
| delete-check-db-exists              | eq     | true   | [4,5,6,7]  | 3    | delete-data | 删除语句中指的库"%s"在实例"%s"中不存在。             |
| delete-check-table-exists           | eq     | true   | [4,5,6,7]  | 3    | delete-data | 删除语句中指的表"%s"在实例"%s"的数据库"%s"中不存在。 |
| delete-check-where-field-exists     | eq     | true   | [4,5,6,7]  | 3    | delete-data | 删除语句中WHERE从句中的字段"%s"不存在。              |


### select data
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组        | 错误信息                                                       |
|---------------------------------|--------|--------|------------|------|-------------|----------------------------------------------------------------|
| select-without-where-enables    | eq     | false  | [4,5,6,7]  | 2    | select-data | 当前规则不允许执行没有WHERE从句的查询语句。                    |
| select-without-limit-enables    | eq     | false  | [4,5,6,7]  | 2    | select-data | 当前规则不允许执行没有LIMIT从句的查询语句。                    |
| select-all-enables              | eq     | false  | [4,5,6,7]  | 2    | select-data | 当前规则不允许执行SELECT *操作，需要显式指定需要查询的列。     |
| select-for-update-enable        | eq     | false  | [4,5,6,7]  | 2    | select-data | 当前规则不允许执行SELECT FOR UPDATE操作。                      |
| select-check-db-exists          | eq     | true   | [4,5,6,7]  | 3    | select-data | 查询语句中指的库"%s"在实例"%s"中不存在。                       |
| select-check-table-exists       | eq     | true   | [4,5,6,7]  | 3    | select-data | 查询语句中指的表"%s"在实例"%s"的数据库"%s"中不存在。           |
| select-check-fields-exists      | eq     | true   | [4,5,6,7]  | 3    | select-data | 查询语句中指的字段"%s"在实例"%s"的数据库"%s"的表"%s"中不存在。 |


### view-create
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组           | 错误信息                                                                       |
|---------------------------------|--------|--------|------------|------|----------------|--------------------------------------------------------------------------------|
| create-view-enable              | eq     | false  | [4,5,6,7]  | 1    | view-create    | 当前规则不允许创建视图。                                                       |
| create-view-??                  | regexp | ...    | [4,5,6,7]  | 2    | view-create    | 新建视图使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-view-??                  | lte    | ...    | [4,5,6,7]  | 2    | view-create    | 新建视图使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-view-??                  | eq     | false  | [4,5,6,7]  | 3    | view-create    | 新建视图"%s"使用的库"%s"在实例"%s"中不存在。                                   |
| create-view-??                  | eq     | false  | [4,5,6,7]  | 3    | view-create    | 视图"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### view-alter
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组       | 错误信息                                         |
|---------------------------------|--------|--------|------------|------|------------|--------------------------------------------------|
| alter-view-enable               | eq     | false  | [4,5,6,7]  | 1    | view-alter | 当前规则不允许修改视图。                         |
| alter-view-??                   | eq     | false  | [4,5,6,7]  | 3    | view-alter | 要修改的视图"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-view-??                   | eq     | false  | [4,5,6,7]  | 3    | view-alter | 要修改的视图"%s"在实例"%s"的数据库"%s"中不存在。 |


### view-drop
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组      | 错误信息                                         |
|---------------------------------|--------|--------|------------|------|-----------|--------------------------------------------------|
| drop-view-enable                | eq     | false  | [4,5,6,7]  | 1    | view-drop | 当前规则不允许删除视图。                         |
| drop-view-??                    | eq     | false  | [4,5,6,7]  | 3    | view-drop | 要删除的视图"%s"所在的库"%s"在实例"%s"中不存在。 |
| drop-view-??                    | eq     | false  | [4,5,6,7]  | 3    | view-drop | 要删除的视图"%s"在实例"%s"的数据库"%s"中不存在。 |


### function-create
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组        | 错误信息                                                                       |
|---------------------------------|--------|--------|------------|------|-------------|--------------------------------------------------------------------------------|
| create-func-enable              | eq     | false  | [4,5,6,7]  | 1    | func-create | 当前规则不允许修改函数。                                                       |
| create-func-??                  | regexp | ...    | [4,5,6,7]  | 2    | func-create | 新建函数使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-func-??                  | lte    | ...    | [4,5,6,7]  | 2    | func-create | 新建函数使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-func-??                  | eq     | false  | [4,5,6,7]  | 3    | func-create | 新建函数"%s"所在的库"%s"在实例"%s"中不存在。                                   |
| create-func-??                  | eq     | false  | [4,5,6,7]  | 3    | func-create | 函数"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### function-alter
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组       | 错误信息                                         |
|---------------------------------|--------|--------|------------|------|------------|--------------------------------------------------|
| alter-func-anble                | eq     | false  | [4,5,6,7]  | 1    | func-alter | 当前规则不允许修改函数。                         |
| alter-func-??                   | eq     | false  | [4,5,6,7]  | 3    | func-alter | 要修改的函数"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-func-??                   | eq     | false  | [4,5,6,7]  | 3    | func-alter | 要修改的函数"%s"在实例"%s"的数据库"%s"中不存在。 |


### function-drop
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组      | 错误信息                                           |
|---------------------------------|--------|--------|------------|------|-----------|----------------------------------------------------|
| drop-func-enable                | eq     | false  | [4,5,6,7]  | 1    | func-drop | 当前规则不允许删除函数。                           |
| drop-func-??                    | eq     | false  | [4,5,6,7]  | 3    | func-drop | 要删除的函数"%s"所在的库"%s"在实例"%s"中不存在。   |
| drop-func-??                    | eq     | false  | [4,5,6,7]  | 3    | func-drop | 要删除的函数"%s"在实例"%s"的数据库"%s"中不存在。。 |


### trigger-create
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组           | 错误信息                                                                         |
|---------------------------------|--------|--------|------------|------|----------------|----------------------------------------------------------------------------------|
| create-trigger-enable           | eq     | false  | [4,5,6,7]  | 1    | trigger-create | 当前规则不允许创建触发器。                                                       |
| create-trigger-??               | regexp | ...    | [4,5,6,7]  | 2    | trigger-create | 新建触发器使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-trigger-??               | lte    | ...    | [4,5,6,7]  | 2    | trigger-create | 新建触发器使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |


### trigger-alter
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组          | 错误信息                   |
|---------------------------------|--------|--------|------------|------|---------------|----------------------------|
| alter-trigger-enable            | eq     | false  | [4,5,6,7]  | 1    | trigger-alter | 当前规则不允许修改触发器。 |


### trigger-drop
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组         | 错误信息                   |
|---------------------------------|--------|--------|------------|------|--------------|----------------------------|
| drop-trigger-enable             | eq     | false  | [4,5,6,7]  | 1    | trigger-drop | 当前规则不允许删除触发器。 |


### event-create
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组         | 错误信息                                                                       |
|---------------------------------|--------|--------|------------|------|--------------|--------------------------------------------------------------------------------|
| create-event-enable             | eq     | false  | [4,5,6,7]  | 1    | event-create | 当前规则不允许创建事件。                                                       |
| create-event-??                 | regexp | ...    | [4,5,6,7]  | 2    | event-create | 新建事件使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-event-??                 | lte    | ...    | [4,5,6,7]  | 2    | event-create | 新建事件使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-event-??                 | eq     | false  | [4,5,6,7]  | 3    | event-create | 新建事件"%s"所在的库"%s"在实例"%s"中不存在。                                   |
| create-event-??                 | eq     | false  | [4,5,6,7]  | 3    | event-create | 事件"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### event-alter
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组        | 错误信息                                         |
|---------------------------------|--------|--------|------------|------|-------------|--------------------------------------------------|
| alter-event-enable              | eq     | false  | [4,5,6,7]  | 1    | event-alter | 当前规则不允许修改事件。                         |
| alter-event-??                  | eq     | false  | [4,5,6,7]  | 3    | event-alter | 要修改的事件"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-event-??                  | eq     | false  | [4,5,6,7]  | 3    | event-alter | 要修改的事件"%s"在实例"%s"的数据库"%s"中不存在。 |


### event-drop
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组       | 错误信息                                           |
|---------------------------------|--------|--------|------------|------|------------|----------------------------------------------------|
| drop-event-enable               | eq     | false  | [4,5,6,7]  | 1    | event-drop | 当前规则不允许删除事件。                           |
| drop-event-??                   | eq     | false  | [4,5,6,7]  | 3    | event-drop | 要删除的事件"%s"所在的库"%s"在实例"%s"中不存在。   |
| drop-event-??                   | eq     | false  | [4,5,6,7]  | 3    | event-drop | 要删除的事件"%s"在实例"%s"的数据库"%s"中不存在。。 |


### procedure-create
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组             | 错误信息                                                                           |
|---------------------------------|--------|--------|------------|------|------------------|------------------------------------------------------------------------------------|
| create-procedure-enable         | eq     | false  | [4,5,6,7]  | 1    | procedure-create | 当前规则不允许创建存储过程。                                                       |
| create-procedure-??             | regexp | ...    | [4,5,6,7]  | 2    | procedure-create | 新建存储过程使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。                 |
| create-procedure-??             | lte    | ...    | [4,5,6,7]  | 2    | procedure-create | 新建存储过程使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。 |
| create-procedure-??             | eq     | false  | [4,5,6,7]  | 3    | procedure-create | 新建存储过程"%s"所在的库在实例"%s"中不存在。                                       |
| create-procedure-??             | eq     | false  | [4,5,6,7]  | 3    | procedure-create | 存储过程"%s"在实例"%s"的数据库"%s"中已存在。                                       |


### procedure-alter
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组            | 错误信息                                             |
|---------------------------------|--------|--------|------------|------|-----------------|------------------------------------------------------|
| alter-procedure-enable          | eq     | false  | [4,5,6,7]  | 1    | procedure-alter | 当前规则不允许修改存储过程。                         |
| alter-procedure-??              | eq     | false  | [4,5,6,7]  | 3    | procedure-alter | 要修改的存储过程"%s"所在的库"%s"在实例"%s"中不存在。 |
| alter-procedure-??              | eq     | false  | [4,5,6,7]  | 3    | procedure-alter | 要修改的存储过程"%s"在实例"%s"的数据库"%s"中不存在。 |


### procedure-drop
--- 
| 规则名称                      | 比较符 | 设定值 | 启用和配置 | 层级 | 分组           | 错误信息                                               |
|-------------------------------|--------|--------|------------|------|----------------|--------------------------------------------------------|
| drop-procedure-enable         | eq     | false  | [4,5,6,7]  | 1    | procedure-drop | 当前规则不允许删除存储过程。                           |
| drop-procedure-??             | eq     | false  | [4,5,6,7]  | 3    | procedure-drop | 要删除的存储过程"%s"所在的库"%s"在实例"%s"中不存在。   |
| drop-procedure-??             | eq     | false  | [4,5,6,7]  | 3    | procedure-drop | 要删除的存储过程"%s"在实例"%s"的数据库"%s"中不存在。。 |


### lock 、truncat 、flush
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组               | 错误信息                                  |
|---------------------------------|--------|--------|------------|------|--------------------|-------------------------------------------|
| lock-table-enabled              | eq     | true   | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行LOCK TABLE命名。        |
| flush-table-enabled             | eq     | true   | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行FLUSH TABLE命令。       |
| truncate-table-enabled          | eq     | true   | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行TRUNCATE TABLE命令。    |
| purge-binlog-enabled            | eq     | true   | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行PURGE BINARY LOGS命令。 |
| purge-logs-enabled              | eq     | true   | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行PURGE LOGS命令。        |
| unlock-tables-enabled           | eq     | true   | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行UNLOCK TABLES命令。     |
| kill-enabled                    | eq     | true   | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行KILL命令。              |
| not-allowed-statment            | in     | []     | [4,5,6,7]  | 1    | no-allow-statement | 当前规则不允许执行"%s"命令。              |


### 关键字
--- 
| 规则名称                        | 比较符 | 设定值 | 启用和配置 | 层级 | 分组          | 错误信息                                                             |
|---------------------------------|--------|--------|------------|------|---------------|----------------------------------------------------------------------|
| keyword-enable                  | eq     | false  | [4,5,6,7]  | 1    | keyword       | 当前规则不允许使用保留关键字作为标识符。                             |
| mixed-ddl-dml                   | eq     | true   | [4,5,6,7]  | 1    | mixed-ddl-dml | 当前规则不允许在一个工单中同时出现DML和DDL操作，请分开多个工单提交。 |
