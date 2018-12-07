CREATE TABLE IF NOT EXISTS `rules` (
    `name`        CHAR(10)
                  NOT NULL
                  COMMENT '规则名称（主键）',
    `group`       VARCHAR(25)
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
    `func`        VARCHAR(75)
                  NOT NULL
                  DEFAULT 'nil'
                  COMMENT '处理函数',
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
    PRIMARY KEY `pk_rules` (`name`)
)
ENGINE = InnoDB
COMMENT = '规则表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

### create database
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CDB-L1-001', '是否允许创建数据库',       'eq', 'false',                  5, 1, 'database-create', '当前规则不允许创建数据库。',                                                    1, UNIX_TIMESTAMP()),
('CDB-L2-001', '创建数据库允许的字符集',   'in', '[]',                     7, 2, 'database-create', '新建库不允许使用字符集"%s"，请使用"%s"。',                                      1, UNIX_TIMESTAMP()),
('CDB-L2-002', '创建数据库允许的校验规则', 'eq', 'true',                   7, 2, 'database-create', '新建库不允许使用排序规则"%s"，请使用"%s"。',                                    1, UNIX_TIMESTAMP()),
('CDB-L2-003', '字符集与校验规则必须匹配', 'eq', 'true',                   5, 2, 'database-create', '新建库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。',                  1, UNIX_TIMESTAMP()),
('CDB-L2-004', '库名必须符合命名规范',     'regexp', '\^[a-z][a-z0-9_]*$', 7, 2, 'database-create', '新建库使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',                  1, UNIX_TIMESTAMP()),
('CDB-L2-005', '库名最大长度，可配置',     'lte',    '16',                 7, 2, 'database-create', '新建库使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。',  1, UNIX_TIMESTAMP()),
('CDB-L3-001', '创建的数据库已经存在',     'eq',     'false',              5, 3, 'database-create', '要新建的库"%s"在实例"%s"上已存在，不能新建重复库。',                            1, UNIX_TIMESTAMP());

### modify database
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MDB-L1-001', '是否允许你alter db',                   'eq', 'false', 7, 1, 'database-alter', '当前规则不允许修改数据库。',                                   1, UNIX_TIMESTAMP()),
('MDB-L2-001', 'alter db 时允许的字符集',              'in', '[]',    7, 2, 'database-alter', '修改库不允许使用字符集"%s"，请使用"%s"。',                     1, UNIX_TIMESTAMP()),
('MDB-L2-002', 'alter db 时允许的校验规则',            'in', '[]',    7, 2, 'database-alter', '修改库不允许使用排序规则"%s"，请使用"%s"。',                   1, UNIX_TIMESTAMP()),
('MDB-L2-003', '修改字符集时字符集必须与校验规则匹配', 'eq', 'true',  5, 2, 'database-alter', '新建库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。', 1, UNIX_TIMESTAMP()),
('MDB-L3-001', '检查alter 的 db是否存在',              'eq', 'true',  5, 3, 'database-alter', '要修改的库"%s"在实例"%s"上不存在，不能修改不存在的库。',       1, UNIX_TIMESTAMP());

### remove database
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RDB-L1-001', '是否允许drop db',          'eq', 'false', 5, 1, 'database-drop', '当前规则不允许删除数据库。',         1, UNIX_TIMESTAMP()),
('RDB-L3-001', 'drop db 时检查db是否存在', 'eq', 'true',  5, 3, 'database-drop', '要删除的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP());

### create table
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CTB-L1-001', '是否允许建表',                   'eq',     'true',              7, 1, 'table-create', '当前规则允不许创建新表。',                                                       1, UNIX_TIMESTAMP()),
('CTB-L2-001', '建表允许的字符集',               'in',     '[]',                7, 2, 'table-create', '新建表不允许使用字符集"%s"，请使用"%s"。',                                       1, UNIX_TIMESTAMP()),
('CTB-L2-002', '建表允许的存储引擎',             'in',     '[]',                7, 2, 'table-create', '新建表不允许使用存储引擎"%s"，请使用"%s"。',                                     1, UNIX_TIMESTAMP()),
('CTB-L2-003', '建表允许的校验规则',             'in',     '[]',                5, 2, 'table-create', '新建表不允许使用排序规则"%s"，请使用"%s"。',                                     1, UNIX_TIMESTAMP()),
('CTB-L2-004', '建表是校验规则与字符集必须匹配', 'eq',     'true',              5, 2, 'table-create', '新建表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。',                   1, UNIX_TIMESTAMP()),
('CTB-L2-005', '表名必须符合命名规范',           'regexp', '\^[_a-zA-Z_]+$',    5, 2, 'table-create', '新建表使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',                   1, UNIX_TIMESTAMP()),
('CTB-L2-006', '表名是否允许大写',               'eq',     'false',             5, 2, 'table-create', '新建表使用的标识符"%s"含有大写字母不被规则允许。',                               1, UNIX_TIMESTAMP()),
('CTB-L2-007', '表名最大长度',                   'lte',    '16',                7, 2, 'table-create', '新建表使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。',   1, UNIX_TIMESTAMP()),
('CTB-L2-008', '表名必须有注释',                 'eq',     'true',              5, 2, 'table-create', '新建表"%s"需要提供COMMENT。',                                                    1, UNIX_TIMESTAMP()),
('CTB-L2-009', '字段名必须有注释',               'eq',     'true',              5, 2, 'table-create', '新建表"%s"的字段"%s"需要提供COMMENT。',                                          1, UNIX_TIMESTAMP()),
('CTB-L2-010', '字段允许的字符集',               'in',     '[]',                7, 2, 'table-create', '新建表"%s"中的字段"%s"不允许使用字符集"%s"，请使用"%s"。',                       1, UNIX_TIMESTAMP()),
('CTB-L2-011', '字段允许的校验规则',             'in',     '[]',                7, 2, 'table-create', '新建表"%s"中的字段"%s"不允许使用排序规则"%s"，请使用"%s"。',                     1, UNIX_TIMESTAMP()),
('CTB-L2-012', '字段的字符集与校验规则必须匹配', 'eq',     'true',              5, 2, 'table-create', '新建表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。',                   1, UNIX_TIMESTAMP()),
('CTB-L2-013', '允许的字段类型',                 'not-in', '[]',                7, 2, 'table-create', '新建表"%s"中的字段"%s"中指定的字符集"%s"和排序规则"%s"不匹配，请参考官方文档。', 1, UNIX_TIMESTAMP()),
('CTB-L2-014', '字段名必须符合命名规范',         'regexp', '\^[_a-zA-Z_]+$',    5, 2, 'table-create', '新建表"%s"中的字段使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',       1, UNIX_TIMESTAMP()),
('CTB-L2-015', '字段名是否重复',                 'eq',     'true',              5, 2, 'table-create', '新建表"%s"中的字段"%s"名称有重复。',                                             1, UNIX_TIMESTAMP()),
('CTB-L2-016', '表允许的字段个数，可配置',       'lte',    '64',                7, 2, 'table-create', '新建表"%s"中定义%d个字段，字段数量超过允许的阈值%d。请考虑拆分表。',             1, UNIX_TIMESTAMP()),
('CTB-L2-017', '索引必须命名',                   'eq',     'true',              5, 2, 'table-create', '新建表"%s"中有一个或多个索引没有提供索引名称。',                                 1, UNIX_TIMESTAMP()),
('CTB-L2-018', '索引名是否允许大写',             'regexp', '\^[_a-zA-Z_]+$',    5, 2, 'table-create', '新建表"%s"中的索引"%s"标识符中含有大写字母不被规则允许。',                       1, UNIX_TIMESTAMP()),
('CTB-L2-019', '索引名必须符合命名规范',         'regexp', '\^index_%d+$',      5, 2, 'table-create', '新建表"%s"中的索引"%s"标识符不满足正则表达式"%s"。',                             1, UNIX_TIMESTAMP()),
('CTB-L2-020', '表中最多可建多少个索引',         'lte',    '5',                 7, 2, 'table-create', '新建表"%s"中定义了%d个索引，索引数量超过允许的阈值%d。',                         1, UNIX_TIMESTAMP()),
('CTB-L2-021', '唯一索引必须命名',               'eq',     'true',              5, 2, 'table-create', '新建表"%s"中有一个或多个唯一索引没有提供索引名称。',                             1, UNIX_TIMESTAMP()),
('CTB-L2-022', '唯一索引命名必须符合规范',       'regexp', '\^[_a-zA-Z_]+$',    5, 2, 'table-create', '新建表"%s"中的唯一索引"%s"标识符中含有大写字母不被规则允许。',                   1, UNIX_TIMESTAMP()),
('CTB-L2-023', '唯一索引名前缀必须是unique',     'regexp', '\^unique_%d+$',     5, 2, 'table-create', '新建表"%s"中的唯一索引"%s"标识符不满足正则表达式"%s"。',                         1, UNIX_TIMESTAMP()),
('CTB-L2-024', '主键是否显式命名',               'eq',     'true',              6, 2, 'table-create', '新建表"%s"中的主键没有提供名称。',                                               1, UNIX_TIMESTAMP()),
('CTB-L2-025', '主键名必须符合明明规范',         'regexp', '\^pk_',             5, 2, 'table-create', '新建表"%s"中的主键"%s"标识符不满足正则表达式"%s"。',                             1, UNIX_TIMESTAMP()),
('CTB-L2-026', '自增字段的类型是否是允许的类型', 'in',     '[]',                7, 2, 'table-create', '新建表"%s"中的自增字段"%s"不允许使用"%s"类型，请使用"%s"。',                     1, UNIX_TIMESTAMP()),
('CTB-L2-027', '检查自增字段是否是主键',         'eq',     'true',              5, 2, 'table-create', '新建表"%s"中的自增字段"%s"不是主键。',                                           1, UNIX_TIMESTAMP()),
('CTB-L2-028', '非空字段是否有默认值',           'eq',     'true',              5, 2, 'table-create', '新建表"%s"中的字段"%s"不允许为空，但没有指定默认值。',                           1, UNIX_TIMESTAMP()),
('CTB-L2-029', '是否允许create table as select', 'eq',     'false',             5, 2, 'table-create', '当前规则不允许使用CREATE TABLE AS SELECT FROM的方式创建表。',                    1, UNIX_TIMESTAMP()),
('CTB-L2-030', '允许多少个timestamp类型的字段',  'lte',    '1',                 7, 2, 'table-create', '新建表"%s"中的定义了两个或者两个以上的TIMESTAMP类型字段，请改用DATETIME类型。',  1, UNIX_TIMESTAMP()),
('CTB-L3-001', '是否允许外键',                   'eq',     'false',             5, 3, 'table-create', '新建表"%s"中定义了外键"%s"，规则不允许。',                                       1, UNIX_TIMESTAMP()),
('CTB-L3-002', '外键名必须符合命名规范',         'regexp', '\^fk_[_a-z0-9]+ $', 5, 3, 'table-create', '新建表"%s"中定义外键"%s"名字不合法。',                                           1, UNIX_TIMESTAMP()),
('CTB-L3-003', '建表时检查目标库是否存在',       'eq',     'true',              5, 3, 'table-create', '要新建的表"%s"在实例"%s"的数据库"%s"不存在。',                                   1, UNIX_TIMESTAMP()),
('CTB-L3-004', '建表时检查表是否已经存在',       'eq',     'true',              5, 3, 'table-create', '要新建的表"%s"所在的库"%s"中已存在。',                                           1, UNIX_TIMESTAMP());

### modify table
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MTB-L1-001', '是否允许alter table',                         'eq', 'true', 7, 1, 'table-alter', '当前规则不允许修改表。',                                                            1, UNIX_TIMESTAMP()),
('MTB-L2-001', 'alter table 允许的字符集',                    'in', '[]',   7, 2, 'table-alter', '修改表不允许使用字符集"%s"，请使用"%s"。',                                          1, UNIX_TIMESTAMP()),
('MTB-L2-002', 'alter table 允许的校验规则',                  'in', '[]',   7, 2, 'table-alter', '修改表不允许使用排序规则"%s"，请使用"%s"。',                                        1, UNIX_TIMESTAMP()),
('MTB-L2-003', 'alter table 时字符集必须与校验规则匹配',      'eq', 'true', 5, 2, 'table-alter', '修改表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。',                      1, UNIX_TIMESTAMP()),
('MTB-L2-004', 'alter table 时允许的存储引擎',                'in', '[]',   7, 2, 'table-alter', '修改表不允许使用存储引擎"%s"，请使用"%s"。',                                        1, UNIX_TIMESTAMP()),
('MTB-L2-005', '合并同一个表的alter',                         'eq', 'true', 5, 2, 'table-alter', '对同一个表"%s"的多条修改语句需要合并成一条语句。',                                  1, UNIX_TIMESTAMP()),
('MTB-L2-006', '添加字段时必须有注释',                        'eq', 'true', 5, 2, 'table-alter', '修改表"%s"新增字段"%s"时需要为字段提供COMMENT。',                                   1, UNIX_TIMESTAMP()),
('MTB-L3-001', 'alter 的表是否存在',                          'eq', 'true', 5, 3, 'table-alter', '要修改的表"%s"在实例"%s"的数据库"%s"中不存在。',                                    1, UNIX_TIMESTAMP()),
('MTB-L3-002', '添加的字段是否存在',                          'eq', 'true', 5, 3, 'table-alter', '要修改表"%s"新增的字段"%s"已存在。',                                                1, UNIX_TIMESTAMP()),
('MTB-L3-003', '删除的字段是否存在',                          'eq', 'true', 5, 3, 'table-alter', '要修改表"%s"删除的字段"%s"不存在。',                                                1, UNIX_TIMESTAMP()),
('MTB-L3-004', '有after、before关键字时检查相关字段是否存在', 'eq', 'true', 5, 3, 'table-alter', '要修改表"%s"为新增的字段"%s"指定位置BEFORE、AFTER中的参照字段"%s"在源表中不存在。', 1, UNIX_TIMESTAMP());

### rename table
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RTB-L1-001', '是否允许rename table',             'eq', 'false', 7, 1, 'table-rename', '当前规则不允许重命名表。',                           1, UNIX_TIMESTAMP()),
('RTB-L3-001', 'rename table时检查源库是否存在',   'eq', 'true',  5, 3, 'table-rename', '要更名的表"%s"的源数据库"%s"在实例"%s"中不存在。',   1, UNIX_TIMESTAMP()),
('RTB-L3-002', 'rename table时检查源表是否存在',   'eq', 'true',  5, 3, 'table-rename', '要更名的表"%s"在实例"%s"的源数据库"%s"中不存在。',   1, UNIX_TIMESTAMP()),
('RTB-L3-002', 'rename table时检查目标库是否存在', 'eq', 'true',  5, 3, 'table-rename', '要更名的表"%s"的目标数据库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('RTB-L3-002', 'rename table时检查目标表是否存在', 'eq', 'true',  5, 3, 'table-rename', '要更名的表"%s"在实例"%s"的目标数据库"%s"中已存在。', 1, UNIX_TIMESTAMP()),
('RTB-L3-002', '目标表跟源表是同一个表',           'eq', 'true',  5, 3, 'table-rename', '要更名的表"%s"和目标表"%s"相同。',                   1, UNIX_TIMESTAMP());

### remove table
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RTB-L1-001', '是否允许drop 表',             'eq', 'false', 5, 1, 'table-drop', '当前规则不允许删除表。',                         1, UNIX_TIMESTAMP()),
('RTB-L3-001', 'drop 表时检查所在库是否存在', 'eq', 'true',  5, 3, 'table-drop', '要删除的表"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('RTB-L3-002', 'drop 的表是否存在',           'eq', 'true',  5, 3, 'table-drop', '要删除的表"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### create index
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CIX-L2-001', '组合索引允许的最大列数',         'lte',    '5',            7, 2, 'index-create', '索引"%s"中索引字段数量超过允许的阈值%d。',           1, UNIX_TIMESTAMP()),
('CIX-L2-002', '普通索引名是否index_开头',       'regexp', '\^index_%d+$', 5, 2, 'index-create', '新建表"%s"中的索引"%s"标识符不满足正则表达式"%s"。', 1, UNIX_TIMESTAMP()),
('CIX-L2-003', '组合索引中是否有重复字段',       'eq',     'false',        5, 2, 'index-create', '索引"%s"中索引的字段有重复。',                       1, UNIX_TIMESTAMP()),
('CIX-L2-004', '是否允许外键',                   'eq',     'false',        7, 2, 'index-create', '当前规则不允许使用外建。',                           1, UNIX_TIMESTAMP()),
('CIX-L3-001', '索引名是否重复',                 'eq',     'false',        5, 3, 'index-create', '索引"%s"在表"%s"已经存在，请使用另外一个索引名称。', 1, UNIX_TIMESTAMP()),
('CIX-L3-002', '条件索引的表是否存在',           'eq',     'true',         5, 3, 'index-create', '索引"%s"依赖的目标库"%s"不存在。',                   1, UNIX_TIMESTAMP()),
('CIX-L3-003', '添加索引的表所属库是否存在',     'eq',     'true',         5, 3, 'index-create', '索引"%s"依赖的目标表"%s"不存在。',                   1, UNIX_TIMESTAMP()),
('CIX-L3-004', '添加索引的字段是否存在',         'eq',     'true',         5, 3, 'index-create', '索引"%s"中索引的字段"%s"在表"%s"中不存在。',         1, UNIX_TIMESTAMP()),
('CIX-L3-005', '最多能建多少个索引',             'lte',    '5',            7, 3, 'index-create', '索引数量超过允许的阈值%d。',                         1, UNIX_TIMESTAMP()),
('CIX-L3-006', '是否允许在blob类型字段上建索引', 'eq',     'false',        5, 2, 'index-create', '当前规则不允许在BLOB类型的字段上建立索引。',         1, UNIX_TIMESTAMP()),
('CIX-L3-007', '是否允许在text类型字段上建索引', 'eq',     'false',        5, 2, 'index-create', '当前规则不允许在TEXT类型的字段上建立索引。',         1, UNIX_TIMESTAMP());

### remove index
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RIX-L1-001', '是否允许删除索引',           'eq', 'true', 5, 1, 'index-drop', '当前规则不允许删除索引。',                                     1, UNIX_TIMESTAMP()),
('RIX-L3-001', '要删除的索引是否村子',       'eq', 'true', 5, 1, 'index-drop', '要删除的索引"%s"在表"%s"中不存在。',                           1, UNIX_TIMESTAMP()),
('RIX-L3-002', '删除索引时，目标表是否存在', 'eq', 'true', 5, 1, 'index-drop', '要删除的索引"%s"关联的表"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP()), 
('RIX-L3-003', '删除索引时，目标库是否存在', 'eq', 'true', 5, 1, 'index-drop', '要删除的索引"%s"关联的表"%s"的数据库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()); 

### insert data
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('INS-L2-001', '是否允许不指定字段的insert',        'eq', 'false', 5, 2, 'data-insert', '当前规则不允许执行没有显式提供字段列表的INSERT语句。',     1, UNIX_TIMESTAMP()),
('INS-L2-002', '是否允许insert',                    'eq', 'false', 7, 2, 'data-insert', '当前规则不允许执行INSERT ... SELECT ...语句。',            1, UNIX_TIMESTAMP()),
('INS-L2-003', '是否合并同表的单条insert',          'eq', 'true',  5, 2, 'data-insert', '多条INSERT语句需要合并成单条语句。',                       1, UNIX_TIMESTAMP()),
('INS-L2-004', '单个insert 允许插入的最大行数',     'eq', '10000', 7, 2, 'data-insert', '一条INSERT语句不得操作超过%d条记录。',                     1, UNIX_TIMESTAMP()),
('INS-L2-005', 'insert时 字段类型、值类型是否匹配', 'eq', 'true',  5, 2, 'data-insert', 'INSERT语句的字段数量和值数量不匹配。',                     1, UNIX_TIMESTAMP()),
('INS-L3-001', '要插入的表是否存在',                'eq', 'true',  5, 3, 'data-insert', 'INSERT语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('INS-L3-002', '要插入的表所属库是否存在',          'eq', 'true',  5, 3, 'data-insert', 'INSERT语句中指定的库"%s"在实例"%s"中不存在。',             1, UNIX_TIMESTAMP()),
('INS-L3-003', 'insert 指定的字段是否存在',         'eq', 'true',  5, 3, 'data-insert', 'INSERT语句中指定的字段"%s"在源表中不存在。',               1, UNIX_TIMESTAMP()),
('INS-L3-004', 'insert 时非空字段是否有值',         'eq', 'true',  5, 3, 'data-insert', 'INSERT语句没有为非空字段"%s"提供值。',                     1, UNIX_TIMESTAMP());

### replace data
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RPL-L2-001', '是否允许不指定字段的replac 语句',   'eq',  'false', 5, 2, 'data-replace', '当前规则不允许执行没有显式提供字段列表的REPLACE语句。',     1, UNIX_TIMESTAMP()),
('RPL-L2-002', '是否允许replace into select',       'eq',  'false', 5, 2, 'data-replace', '当前规则不允许执行REPLACE ... SELECT ...语句。',            1, UNIX_TIMESTAMP()),
('RPL-L2-003', '单次replace允许的最大行数',         'lte', '10000', 7, 2, 'data-replace', '一条REPLACE语句不得操作超过%d条记录。',                     1, UNIX_TIMESTAMP()),
('RPL-L2-004', 'replace时字段类型、值类型是否匹配', 'eq',  'ture',  5, 2, 'data-replace', 'REPLACE语句的字段数量和值数量不匹配。',                     1, UNIX_TIMESTAMP()),
('RPL-L3-001', 'replace时检查db是否存在',           'eq',  'true',  5, 3, 'data-replace', 'REPLACE语句中指定的库"%s"在实例"%s"中不存在。',             1, UNIX_TIMESTAMP()),
('RPL-L3-002', 'replace into 的表是否存在',         'eq',  'true',  5, 3, 'data-replace', 'REPLACE语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('RPL-L3-003', 'replace时非空字段是否有值',         'eq',  'true',  5, 3, 'data-replace', 'REPLACE语句没有为非空字段"%s"提供值。',                     1, UNIX_TIMESTAMP());

### update data
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('UPD-L2-001', '是否允许没有where条件的update', 'eq',  'false', 5, 3, 'data-update', '当前规则不允许执行没有WHERE从句的更新语句。',            1, UNIX_TIMESTAMP()),
('UPD-L3-001', 'update的表所属库是否存在',      'eq',  'true',  5, 3, 'data-update', '更新语句中指定的库"%s"在实例"%s"中不存在。',             1, UNIX_TIMESTAMP()),
('UPD-L3-002', 'update的表是否存在',            'eq',  'true',  5, 3, 'data-update', '更新语句中指定的表"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('UPD-L3-003', 'update的字段是否存在',          'eq',  'true',  5, 3, 'data-update', '更新语句中待更新的字段"%s"不存在。',                     1, UNIX_TIMESTAMP()),
('UPD-L3-004', 'where条件中的字段是否存在',     'eq',  'true',  5, 3, 'data-update', '更新语句中WHERE从句中的字段"%s"在源表中不存在。',        1, UNIX_TIMESTAMP()),
('UPD-L3-005', '允许单次更新的最大行数',        'lte', '10000', 7, 3, 'data-update', '当前规则不允许一次更新%d条或以上记录。',                 1, UNIX_TIMESTAMP());

### delete data
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('DEL-L2-001', '是否允许没有where条件的delete', 'eq',  'false', 5, 2, 'data-delete', '当前规则不允许执行没有WHERE从句的删除语句。',          1, UNIX_TIMESTAMP()),
('DEL-L3-001', '允许单次删除的最大行数',        'lte', '10000', 7, 3, 'data-delete', '当前规则不允许一次删除%d条或以上记录。',               1, UNIX_TIMESTAMP()),
('DEL-L3-002', 'delete的表所属库是否存在',      'eq',  'true',  5, 3, 'data-delete', '删除语句中指的库"%s"在实例"%s"中不存在。',             1, UNIX_TIMESTAMP()),
('DEL-L3-003', 'delete的表是否存在',            'eq',  'true',  5, 3, 'data-delete', '删除语句中指的表"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('DEL-L3-004', 'where条件中的字段是否存在',     'eq',  'true',  5, 3, 'data-delete', '删除语句中WHERE从句中的字段"%s"在源表中不存在。',      1, UNIX_TIMESTAMP());

### select data
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('SEL-L2-001', '是否允许没有where条件的select', 'eq', 'false', 5, 2, 'data-select', '当前规则不允许执行没有WHERE从句的查询语句。',                    1, UNIX_TIMESTAMP()),
('SEL-L2-002', '是否允许没有limit现在的select', 'eq', 'false', 7, 2, 'data-select', '当前规则不允许执行没有LIMIT从句的查询语句。',                    1, UNIX_TIMESTAMP()),
('SEL-L2-003', '是否允许select *',              'eq', 'false', 7, 2, 'data-select', '当前规则不允许执行SELECT *操作，需要显式指定需要查询的列。',     1, UNIX_TIMESTAMP()),
('SEL-L2-004', '是否允许select for update',     'eq', 'false', 5, 2, 'data-select', '当前规则不允许执行SELECT FOR UPDATE操作。',                      1, UNIX_TIMESTAMP()),
('SEL-L3-001', 'select 指定的数据库是否存在',   'eq', 'true',  5, 3, 'data-select', '查询语句中指的库"%s"在实例"%s"中不存在。',                       1, UNIX_TIMESTAMP()),
('SEL-L3-002', '要select的表是否存在',          'eq', 'true',  5, 3, 'data-select', '查询语句中指的表"%s"在实例"%s"的数据库"%s"中不存在。',           1, UNIX_TIMESTAMP()),
('SEL-L3-003', 'select的字段是否存在',          'eq', 'true',  5, 3, 'data-select', '查询语句中指的字段"%s"在实例"%s"的数据库"%s"的表"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('SEL-L3-004', '是否允许查找blob类型字段值',    'eq', 'true',  5, 3, 'data-select', '查询语句中指的字段"%s"是BLOB类型，当前规则不允许执行此类查询。', 1, UNIX_TIMESTAMP());

### view-create
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CVW-L1-001', '是否允许创建视图',       'eq',     'false',          5, 1, 'view-create', '当前规则不允许创建视图。',                                                       1, UNIX_TIMESTAMP()),
('CVW-L2-001', '视图名必须符合命名规范', 'regexp', '\^[_a-zA-Z_]+$', 5, 2, 'view-create', '新建视图使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',                 1, UNIX_TIMESTAMP()),
('CVW-L2-002', '视图名最大长度',         'lte',    '16',             7, 2, 'view-create', '新建视图使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。', 1, UNIX_TIMESTAMP()),
('CVW-L3-001', '视图所属的db是否存在',   'eq',     'true',           5, 3, 'view-create', '新建视图"%s"使用的库"%s"在实例"%s"中不存在。',                                   1, UNIX_TIMESTAMP()),
('CVW-L3-002', '视图是否已存在',         'eq',     'false',          5, 3, 'view-create', '视图"%s"在实例"%s"的数据库"%s"中已存在。',                                       1, UNIX_TIMESTAMP());

### view-alter
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MVW-L1-001', '是否允许修改视图',             'eq', 'false', 5, 1, 'view-alter', '当前规则不允许修改视图。',                         1, UNIX_TIMESTAMP()),
('MVW-L3-001', '检查修改的视图所属库是否存在', 'eq', 'true',  5, 3, 'view-alter', '要修改的视图"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('MVW-L3-002', '检查要修改的视图是否存在',     'eq', 'true',  5, 3, 'view-alter', '要修改的视图"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### view-drop
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RVW-L1-001', '是否允许删除视图',             'eq', 'false', 5, 1, 'view-drop', '当前规则不允许删除视图。',                         1, UNIX_TIMESTAMP()),
('RVW-L3-001', '检查删除的视图所属库是否存在', 'eq', 'true',  5, 3, 'view-drop', '要删除的视图"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('RVW-L3-002', '检查要删除的视图是否存在',     'eq', 'true',  5, 3, 'view-drop', '要删除的视图"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### function-create
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CFU-L1-001', '是否允许创建函数',       'eq',     'false',          7, 1, 'func-create', '当前规则不允许修改函数。',                                                       1, UNIX_TIMESTAMP()),
('CFU-L2-001', '函数名是否符合命名规范', 'regexp', '\^[_a-zA-Z_]+$', 7, 2, 'func-create', '新建函数使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',                 1, UNIX_TIMESTAMP()),
('CFU-L2-002', '函数名最大长度',         'lte',    '16',             7, 2, 'func-create', '新建函数使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。', 1, UNIX_TIMESTAMP()),
('CFU-L3-001', '函数所属库是否存在',     'eq',     'true',           5, 3, 'func-create', '新建函数"%s"所在的库"%s"在实例"%s"中不存在。',                                   1, UNIX_TIMESTAMP()),
('CFU-L3-002', '函数是否以及存在',       'eq',     'false',          5, 3, 'func-create', '函数"%s"在实例"%s"的数据库"%s"中已存在。',                                       1, UNIX_TIMESTAMP());

### function-alter
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MFU-L1-001', '是否允许修改函数',   'eq', 'false', 7, 1, 'func-alter', '当前规则不允许修改函数。',                         1, UNIX_TIMESTAMP()),
('MFU-L3-001', '函数所属库是否存在', 'eq', 'true',  5, 3, 'func-alter', '要修改的函数"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('MFU-L3-002', '函数是否存在',       'eq', 'false', 5, 3, 'func-alter', '要修改的函数"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### function-drop
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RFU-L1-001', '是否允许删除函数',     'eq', 'false', 7, 1, 'func-drop', '当前规则不允许删除函数。',                         1, UNIX_TIMESTAMP()),
('RFU-L3-001', '函数所属库是否存在',   'eq', 'true',  5, 3, 'func-drop', '要删除的函数"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('RFU-L3-002', '要删除的函数是否存在', 'eq', 'true',  5, 3, 'func-drop', '要删除的函数"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### trigger-create
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CTG-L1-001', '是否允许创建触发器',       'eq',     'false',          7, 1, 'trigger-create', '当前规则不允许创建触发器。',                                                       1, UNIX_TIMESTAMP()),
('CTG-L2-001', '触发器名是否符合命名规范', 'regexp', '\^[_a-zA-Z_]+$', 5, 2, 'trigger-create', '新建触发器使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',                 1, UNIX_TIMESTAMP()),
('CTG-L2-002', '触发器名最大长度',         'lte',    '32',             7, 2, 'trigger-create', '新建触发器使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。', 1, UNIX_TIMESTAMP()),
('CTG-L3-001', '触发器所属库是否存在',     'eq',     'true',           5, 2, 'trigger-create', '新建触发器使用的标识符"%s"使用的数据库"%s" 在实例"%s"种不存在。',                  1, UNIX_TIMESTAMP()),
('CTG-L3-002', '触发器是否存在',           'eq',     'false',          5, 2, 'trigger-create', '新建触发器使用的标识符"%s"在实例"%s"的数据库"%s"中已经存在。',                     1, UNIX_TIMESTAMP());

### trigger-alter
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MTG-L1-001', '是否允许修改触发器',  'eq', 'false', 7, 1, 'trigger-alter', '当前规则不允许修改触发器。',                       1, UNIX_TIMESTAMP()),
('MTG-L3-001', '触发器所属库是否存在', 'eq', 'true',  5, 3, 'trigger-alter', '要修改的函数"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('MTG-L3-002', '触发器是否存在',      'eq', 'false', 5, 3, 'trigger-alter', '要修改的函数"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### trigger-drop
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RTG-L1-001', '是否允许删除触发器',   'eq', 'false', 7, 1, 'trigger-drop', '当前规则不允许删除触发器。',                         1, UNIX_TIMESTAMP()),
('RTG-L3-001', '触发器所属库是否存在', 'eq', 'true',  5, 3, 'trigger-drop', '要修改的触发器"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('RTG-L3-002', '触发器是否存在',       'eq', 'true',  5, 3, 'trigger-drop', '要修改的触发器"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### event-create
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CEV-L1-001', '是否允许创建event',       'eq',     'false',          7, 1, 'event-create', '当前规则不允许创建事件。',                                                       1, UNIX_TIMESTAMP()),
('CEV-L2-001', 'event名是否符合命名规范', 'regexp', '\^[_a-zA-Z_]+$', 5, 2, 'event-create', '新建事件使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',                 1, UNIX_TIMESTAMP()),
('CEV-L2-002', 'event名允许的最大长度',   'lte',    '16',             7, 2, 'event-create', '新建事件使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。', 1, UNIX_TIMESTAMP()),
('CEV-L3-001', 'event所属库是否存在',     'eq',     'true',           5, 3, 'event-create', '新建事件"%s"所在的库"%s"在实例"%s"中不存在。',                                   1, UNIX_TIMESTAMP()),
('CEV-L3-002', 'event是否存在',           'eq',     'false',          5, 3, 'event-create', '事件"%s"在实例"%s"的数据库"%s"中已存在。',                                       1, UNIX_TIMESTAMP());
                         
### event-alter
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MEV-L1-001', '是否允许修改event',   'eq', 'false', 7, 1, 'event-alter', '当前规则不允许修改事件。',                         1, UNIX_TIMESTAMP()),
('MEV-L3-001', 'event所属库是否存在', 'eq', 'true',  5, 3, 'event-alter', '要修改的事件"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('MEV-L3-002', 'event是否存在',       'eq', 'true',  5, 3, 'event-alter', '要修改的事件"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### event-drop
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('REV-L1-001', '是否允许删除event',   'eq', 'false', 7, 1, 'event-drop', '当前规则不允许删除事件。',                         1, UNIX_TIMESTAMP()),
('REV-L3-001', 'event所属库是否存在', 'eq', 'true',  5, 3, 'event-drop', '要删除的事件"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('REV-L3-002', 'event是否存在',       'eq', 'true',  5, 3, 'event-drop', '要删除的事件"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### procedure-create
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('CSP-L1-001', '是否允许创建存储过程',     'eq',     'false',          7, 1, 'procedure-create', '当前规则不允许创建存储过程。',                                                       1, UNIX_TIMESTAMP()),
('CSP-L2-001', '存储过程命名是否符合规范', 'regexp', '\^[_a-zA-Z_]+$', 5, 2, 'procedure-create', '新建存储过程使用的标识符"%s"不被规则允许，标识符需要满足正则"%s"。',                 1, UNIX_TIMESTAMP()),
('CSP-L2-002', '存储过程名允许的最大长度', 'lte',    '32',             5, 2, 'procedure-create', '新建存储过程使用的标识符"%s"超过了规则允许的最长字符数限制，标识符最长不可超过%d。', 1, UNIX_TIMESTAMP()),
('CSP-L3-001', '存储过程所属库是否存在',   'eq',     'true',           5, 3, 'procedure-create', '新建存储过程"%s"所在的库在实例"%s"中不存在。',                                       1, UNIX_TIMESTAMP()),
('CSP-L3-002', '存储过程是否存在',         'eq',     'false',          5, 3, 'procedure-create', '存储过程"%s"在实例"%s"的数据库"%s"中已存在。',                                       1, UNIX_TIMESTAMP());

### procedure-alter
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MSP-L1-001', '是否允许修改存储过程',   'eq', 'false', 7, 1, 'procedure-alter', '当前规则不允许修改存储过程。',                         1, UNIX_TIMESTAMP()),
('MSP-L3-001', '存储过程所属库是否存在', 'eq', 'true',  5, 3, 'procedure-alter', '要修改的存储过程"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('MSP-L3-002', '存储过程是否存在',       'eq', 'true',  5, 3, 'procedure-alter', '要修改的存储过程"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### procedure-drop
INSERT INTO `rules`(`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('RSP-L1-001', '是否允许删除存储过程',   'eq', 'false', 7, 1, 'procedure-drop', '当前规则不允许删除存储过程。',                         1, UNIX_TIMESTAMP()),
('RSP-L3-001', '存储过程所属库是否存在', 'eq', 'true',  5, 3, 'procedure-drop', '要删除的存储过程"%s"所在的库"%s"在实例"%s"中不存在。', 1, UNIX_TIMESTAMP()),
('RSP-L3-002', '存储过程是否存在',       'eq', 'true',  5, 3, 'procedure-drop', '要删除的存储过程"%s"在实例"%s"的数据库"%s"中不存在。', 1, UNIX_TIMESTAMP());

### misc
INSERT INTO `rules` (`name`, `description`, `operator`, `values`, `bitwise`, `level`, `group`, `message`, `version`, `create_at`) VALUES
('MSC-L1-001', '是否允许lock table',                        'eq', 'true',  5, 1, 'no-allow-statement', '当前规则不允许执行LOCK TABLE命名。',                                   1, UNIX_TIMESTAMP()),
('MSC-L1-002', '是否允许flush table',                       'eq', 'true',  5, 1, 'no-allow-statement', '当前规则不允许执行FLUSH TABLE命令。',                                  1, UNIX_TIMESTAMP()),
('MSC-L1-003', '是否允许truncat table',                     'eq', 'true',  5, 1, 'no-allow-statement', '当前规则不允许执行TRUNCATE TABLE命令。',                               1, UNIX_TIMESTAMP()),
('MSC-L1-004', '是否允许purge binary',                      'eq', 'true',  5, 1, 'no-allow-statement', '当前规则不允许执行PURGE BINARY LOGS命令。',                            1, UNIX_TIMESTAMP()),
('MSC-L1-005', '是否允许purge log',                         'eq', 'true',  5, 1, 'no-allow-statement', '当前规则不允许执行PURGE LOGS命令。',                                   1, UNIX_TIMESTAMP()),
('MSC-L1-006', '是否允许unlock table',                      'eq', 'true',  5, 1, 'no-allow-statement', '当前规则不允许执行UNLOCK TABLES命令。',                                1, UNIX_TIMESTAMP()),
('MSC-L1-007', '是否允许kill 线程',                         'eq', 'true',  5, 1, 'no-allow-statement', '当前规则不允许执行KILL命令。',                                         1, UNIX_TIMESTAMP()),
('MSC-L1-008', '是否允许使用mysql 关键字',                  'eq', 'false', 5, 1, 'keyword',            '当前规则不允许使用保留关键字作为标识符。',                             1, UNIX_TIMESTAMP()),
('MSC-L0-001', '同一个工单里是否允许同时存在ddl、dml 语句', 'eq', 'true',  5, 1, 'mixed-ddl-dml',      '当前规则不允许在一个工单中同时出现DML和DDL操作，请分开多个工单提交。', 1, UNIX_TIMESTAMP());

