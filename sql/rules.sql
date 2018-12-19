CREATE TABLE IF NOT EXISTS `rules` (
    `rule_id`     INT UNSIGNED
                  NOT NULL
                  AUTO_INCREMENT
                  COMMENT '自增主键',
    `name`        CHAR(10)
                  NOT NULL
                  COMMENT '规则名称',
    `group`       VARCHAR(25)
                  NOT NULL
                  COMMENT '规则名称',
    `description` VARCHAR(75)
                  NOT NULL
                  COMMENT '规则描述',
    `level`       TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '验证顺序',
    `severity`    TINYINT UNSIGNED
                  NOT NULL
                  COMMENT '严重级别',
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
    `element`     VARCHAR(15)
                  NOT NULL
                  DEFAULT '-'
                  COMMENT '展现组件类型',
    `version`     INT UNSIGNED
                  NOT NULL
                  COMMENT '版本',
    `update_at`   INT UNSIGNED
                  COMMENT '修改时间',
    `create_at`   INT UNSIGNED
                  NOT NULL
                  COMMENT '创建时间',
    PRIMARY KEY `pk_rules` (`rule_id`),
    UNIQUE `unique_1` (`name`)
)
ENGINE = InnoDB
COMMENT = '规则表'
DEFAULT CHARSET = utf8mb4
DEFAULT COLLATE = utf8mb4_general_ci;

### create database
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('CDB-L1-001', 'database-create', 1, 1, 'none', 'none',   'none',               5, 'DatabaseCreateEnabled',                       1, UNIX_TIMESTAMP(), '是否允许建库',                   '不允许创建数据库。'),
('CDB-L2-001', 'database-create', 2, 1, '',     'in',     '[]',                 7, 'DatabaseCreateAvailableCharsets',             1, UNIX_TIMESTAMP(), '建库允许的字符集',               '建库不允许使用字符集"%s"，请使用"%s"。'),
('CDB-L2-002', 'database-create', 2, 1, '',     'eq',     'true',               7, 'DatabaseCreateAvailableCollates',             1, UNIX_TIMESTAMP(), '建库允许的排序规则',             '建库不允许使用排序规则"%s"，请使用"%s"。'),
('CDB-L2-003', 'database-create', 2, 1, '',     'eq',     'true',               5, 'DatabaseCreateCharsetCollateMatch',           1, UNIX_TIMESTAMP(), '建库的字符集与排序规则必须匹配', '建库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。'),
('CDB-L2-004', 'database-create', 2, 1, '',     'regexp', '\^[a-z][a-z0-9_]*$', 7, 'DatabaseCreateDatabaseNameQualified',         1, UNIX_TIMESTAMP(), '库名标识符规则',                 '库名"%s"需要满足正则"%s"。'),
('CDB-L2-005', 'database-create', 2, 1, '',     'eq',     'true',               7, 'DatabaseCreateDatabaseNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '库名大小写规则',                 '库名"%s"中含有大写字母。'),
('CDB-L2-006', 'database-create', 2, 1, '',     'lte',    '16',                 7, 'DatabaseCreateDatabaseNameMaxLength',         1, UNIX_TIMESTAMP(), '库名长度规则',                   '库名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CDB-L3-001', 'database-create', 3, 1, '',     'eq',     'false',              5, 'DatabaseCreateTargetDatabaseExists',          1, UNIX_TIMESTAMP(), '目标库已存在',                   '目标库"%s"已存在。');

### modify database
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MDB-L1-001', 'database-alter', 1, 1, 'none', 'eq', 'false', 7, 'DatabaseAlterEnabled',              1, UNIX_TIMESTAMP(), '是否允许改库',                   '不允许修改数据库。'),
('MDB-L2-001', 'database-alter', 2, 1, '',     'in', '[]',    7, 'DatabaseAlterAvailableCharsets',    1, UNIX_TIMESTAMP(), '改库允许的字符集',               '改库不允许使用字符集"%s"，请使用"%s"。'),
('MDB-L2-002', 'database-alter', 2, 1, '',     'in', '[]',    7, 'DatabaseAlterAvailableCollates',    1, UNIX_TIMESTAMP(), '改库允许的排序规则',             '改库不允许使用排序规则"%s"，请使用"%s"。'),
('MDB-L2-003', 'database-alter', 2, 1, '',     'eq', 'true',  5, 'DatabaseAlterCharsetCollateMatch',  1, UNIX_TIMESTAMP(), '改库的字符集与排序规则必须匹配', '改库使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。'),
('MDB-L3-001', 'database-alter', 3, 1, '',     'eq', 'true',  5, 'DatabaseAlterTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库不存在',                   '目标库"%s"不存在。');

### drop database
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DDB-L1-001', 'database-drop', 1, 1, 'none', 'eq', 'false', 5, 'DatabaseDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删库', '不允许删除数据库。'),
('DDB-L3-001', 'database-drop', 3, 1, '',     'eq', 'true',  5, 'DatabaseDropTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库不存在', '目标库"%s"不存在。');

### create table
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
# 表
('CTB-L1-001', 'table-create', 1, 1, 'none', 'eq',     'true',              7, 'TableCreateEnabled',                          1, UNIX_TIMESTAMP(), '是否允许建表',                   '允不许创建新表。'),
('CTB-L2-001', 'table-create', 2, 1, '',     'in',     '[]',                7, 'TableCreateAvailableCharsets',                1, UNIX_TIMESTAMP(), '建表允许的字符集',               '建表不允许使用字符集"%s"，请使用"%s"。'),
('CTB-L2-002', 'table-create', 2, 1, '',     'in',     '[]',                5, 'TableCreateAvailableCollates',                1, UNIX_TIMESTAMP(), '建表允许的排序规则',             '建表不允许使用排序规则"%s"，请使用"%s"。'),
('CTB-L2-003', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreateTableCharsetCollateMatch',         1, UNIX_TIMESTAMP(), '建表是校验规则与字符集必须匹配', '建表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。'),
('CTB-L2-004', 'table-create', 2, 1, '',     'in',     '[]',                7, 'TableCreateAvailableEngines',                 1, UNIX_TIMESTAMP(), '建表允许的存储引擎',             '建表不允许使用存储引擎"%s"，请使用"%s"。'),
('CTB-L2-005', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    5, 'TableCreateTableNameQualified',               1, UNIX_TIMESTAMP(), '表名必须符合命名规范',           '表名"%s"需要满足正则"%s"。'),
('CTB-L2-006', 'table-create', 2, 1, '',     'eq',     'false',             5, 'TableCreateTableNameLowerCaseRequired',       1, UNIX_TIMESTAMP(), '表名是否允许大写',               '表名"%s"含有大写字母。'),
('CTB-L2-007', 'table-create', 2, 1, '',     'lte',    '16',                7, 'TableCreateTableNameMaxLength',               1, UNIX_TIMESTAMP(), '表名最大长度',                   '表名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CTB-L2-008', 'table-create', 2, 1, '',     'eq',     'true',              7, 'TableCreateTableCommentRequired',             1, UNIX_TIMESTAMP(), '表必须有注释',                   '需要为表"%s"需要提供COMMENT注解。'),
('CTB-L2-009', 'table-create', 2, 1, '',     'eq',     'false',             5, 'TableCreateFromSelectEnabled',                1, UNIX_TIMESTAMP(), '是否允许查询语句建表',           '不允许使用CREATE TABLE AS SELECT的方式建表。'),
# 列
('CTB-L2-010', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    5, 'TableCreateColumnNameQualified',              1, UNIX_TIMESTAMP(), '列名必须符合命名规范',           '列名"%s"需要满足正则"%s"。'),
('CTB-L2-011', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    7, 'TableCreateColumnNameLowerCaseRequired',      1, UNIX_TIMESTAMP(), '列名是否允许大写',               '列名"%s"中含有大写字母。'),
('CTB-L2-012', 'table-create', 2, 1, '',     'lte',    '25',                7, 'TableCreateColumnNameMaxLength',              1, UNIX_TIMESTAMP(), '列名最大长度',                   '列名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CTB-L2-013', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreateColumnNameDuplicate',              1, UNIX_TIMESTAMP(), '列名是否重复',                   '表"%s"中的定义了重复的列"%s"。'),
('CTB-L2-014', 'table-create', 2, 2, '',     'lte',    '25',                7, 'TableCreateColumnCountLimit',                 1, UNIX_TIMESTAMP(), '表允许的最大列数',               '表"%s"中定义%d个列，数量超出了规则允许的上限%d，请考虑拆分表。'),
('CTB-L2-015', 'table-create', 2, 1, '',     'not-in', '[]',                7, 'TableCreateColumnUnwantedTypes',              1, UNIX_TIMESTAMP(), '列允许的数据类型',               '列"%s"使用了不期望的数据类型"%s"，请避免使用"%"数据类型。'),
('CTB-L2-016', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreateColumnCommentRequired',            1, UNIX_TIMESTAMP(), '列必须有注释',                   '列"%s"需要提供COMMENT注解。'),
('CTB-L2-017', 'table-create', 2, 1, '',     'in',     '[]',                7, 'TableCreateColumnAvailableCharsets',          1, UNIX_TIMESTAMP(), '列允许的字符集',                 '列"%s"不允许使用字符集"%s"，请使用"%s"。'),
('CTB-L2-018', 'table-create', 2, 1, '',     'in',     '[]',                7, 'TableCreateColumnAvailableCollates',          1, UNIX_TIMESTAMP(), '列允许的排序规则',               '列"%s"不允许使用排序规则"%s"，请使用"%s"。'),
('CTB-L2-019', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreateColumnCharsetCollateMatch',        1, UNIX_TIMESTAMP(), '列的字符集与排序规则必须匹配',   '列"%s"使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。'),
('CTB-L2-020', 'table-create', 2, 2, '',     'eq',     'true',              5, 'TableCreateColumnNotNullWithDefaultRequired', 1, UNIX_TIMESTAMP(), '非空列是否有默认值',             '列"%s"不允许为空，但没有指定默认值。'),
('CTB-L2-021', 'table-create', 2, 1, '',     'in',     '[]',                7, 'TableCreateColumnAutoIncAvailableTypes',      1, UNIX_TIMESTAMP(), '自增列允许的数据类型',           '自增列"%s"不允许使用"%s"类型，请使用"%s"。'),
('CTB-L2-022', 'table-create', 2, 2, '',     'eq',     'true',              7, 'TableCreateColumnAutoIncIsUnsigned',          1, UNIX_TIMESTAMP(), '自增列必须是无符号',             '自增列"%s"推荐使用无符号的整数。'),
('CTB-L2-023', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreateColumnAutoIncMustPrimaryKey',      1, UNIX_TIMESTAMP(), '自增列必须是主键',               '自增列"%s"不是主键。'),
('CTB-L2-024', 'table-create', 2, 1, '',     'eq',     'true',              7, 'TableCreateTimestampColumnCountLimit',        1, UNIX_TIMESTAMP(), '仅允许一个时间戳类型的列',       '表"%s"中的定义了多个时间戳列，请改用DATETIME类型。'),
# 索引
('CTB-L2-025', 'table-create', 2, 2, '',     'lte',    '3',                 7, 'TableCreateIndexMaxColumnLimit',              1, UNIX_TIMESTAMP(), '单一索引最大列数',               '索引"%s"索引的列数超出了规则允许的上限，请控制在%d个列以内。'),
# 主键
('CTB-L2-026', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreatePrimaryKeyRequired',               1, UNIX_TIMESTAMP(), '必须有主键',                     '没有为主键指定名称。'),
('CTB-L2-027', 'table-create', 2, 2, '',     'eq',     'true',              6, 'TableCreatePrimaryKeyNameExplicit',           1, UNIX_TIMESTAMP(), '主键是否显式命名',               '主键没有提供名称。'),
('CTB-L2-028', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    7, 'TableCreatePrimaryKeyNameQualified',          1, UNIX_TIMESTAMP(), '主键名标识符规则',               '主键名"%s"需要满足正则"%s"。'),
('CTB-L2-029', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    7, 'TableCreatePrimryKeyLowerCaseRequired',       1, UNIX_TIMESTAMP(), '主键名大小写规则',               '主键名"%s"含有大写字母。'),
('CTB-L2-030', 'table-create', 2, 1, '',     'lte',    '25',                7, 'TableCreatePrimryKeyMaxLength',               1, UNIX_TIMESTAMP(), '主键名长度规则',                 '主键名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CTB-L2-031', 'table-create', 2, 2, '',     'regexp', '\^pk_',             7, 'TableCreatePrimryKeyPrefixRequired',          1, UNIX_TIMESTAMP(), '主键名前缀规则',                 '主键名"%s"需要满足前缀正则"%s"。'),
# 索引
('CTB-L2-032', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreateIndexNameExplicit',                1, UNIX_TIMESTAMP(), '索引必须命名',                   '一个或多个索引没有提供索引名称。'),
('CTB-L2-033', 'table-create', 2, 1, '',     'regexp', '\^index_%d+$',      5, 'TableCreateIndexNameQualified',               1, UNIX_TIMESTAMP(), '索引名标识符规则',               '索引名"%s"需要满足正则"%s"。'),
('CTB-L2-034', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    5, 'TableCreateIndexNameLowerCaseRequired',       1, UNIX_TIMESTAMP(), '索引名大小写规则',               '索引名"%s"含有大写字母。'),
('CTB-L2-035', 'table-create', 2, 1, '',     'lte',    '25',                7, 'TableCreateIndexNameMaxLength',               1, UNIX_TIMESTAMP(), '索引名长度规则',                 '索引名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CTB-L2-036', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    5, 'TableCreateIndexNamePrefixRequired',          1, UNIX_TIMESTAMP(), '索引名前缀规则',                 '索引名"%s"需要满足前缀正则"%s"。'),
# 唯一索引
('CTB-L2-037', 'table-create', 2, 1, '',     'eq',     'true',              5, 'TableCreateUniqueNameExplicit',               1, UNIX_TIMESTAMP(), '唯一索引必须命名',               '一个或多个唯一索引没有提供索引名称。'),
('CTB-L2-038', 'table-create', 2, 1, '',     'regexp', '\^index_%d+$',      5, 'TableCreateUniqueNameQualified',              1, UNIX_TIMESTAMP(), '唯一索引索名标识符规则',         '唯一索引"%s"需要满足正则"%s"。'),
('CTB-L2-039', 'table-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$',    5, 'TableCreateUniqueNameLowerCaseRequired',      1, UNIX_TIMESTAMP(), '唯一索引名大小写规则',           '唯一索引"%s"含有大写字母。'),
('CTB-L2-040', 'table-create', 2, 1, '',     'lte',    '25',                7, 'TableCreateUniqueNameMaxLength',              1, UNIX_TIMESTAMP(), '唯一索引名长度规则',             '唯一索引"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CTB-L2-041', 'table-create', 2, 1, '',     'regexp', '\^unique_%d+$',     5, 'TableCreateUniqueNamePrefixRequired',         1, UNIX_TIMESTAMP(), '唯一索引名前缀规则',             '唯一索引"%s"需要满足前缀正则"%s"。'),
# 外键
('CTB-L2-042', 'table-create', 2, 1, '',     'eq',     'false',             5, 'TableCreateForeignKeyEnabled',                1, UNIX_TIMESTAMP(), '是否允许外键',                   '不允许使用外键。'),
('CTB-L2-043', 'table-create', 2, 1, '',     'eq',     'false',             5, 'TableCreateForeignKeyNameExplicit',           1, UNIX_TIMESTAMP(), '外键是否显式命名',               '没有为外键指定名称。'),
('CTB-L2-044', 'table-create', 2, 1, '',     'regexp', '\^fk_[_a-z0-9]+ $', 5, 'TableCreateForeignKeyNameQualified',          1, UNIX_TIMESTAMP(), '外键名标识符规则',               '外键名"%s"需要满足正则"%s"。'),
('CTB-L2-045', 'table-create', 2, 1, '',     'regexp', '\^fk_[_a-z0-9]+ $', 5, 'TableCreateForeignKeyNameLowerCaseRequired',  1, UNIX_TIMESTAMP(), '外键名大小写规则',               '外键名"%s"含有大写字母。'),
('CTB-L2-046', 'table-create', 2, 1, '',     'lte',    '25',                5, 'TableCreateForeignKeyNameMaxLength',          1, UNIX_TIMESTAMP(), '外键名长度规则',                 '外键名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CTB-L2-047', 'table-create', 2, 1, '',     'regexp', '\^fk_[_a-z0-9]+ $', 5, 'TableCreateForeignKeyNamePrefixRequired',     1, UNIX_TIMESTAMP(), '外键名前缀规则',                 '外键名"%s"需要满足前缀正则"%s"。'),
# 索引数
('CTB-L2-048', 'table-create', 2, 2, '',     'lte',    '5',                 7, 'TableCreateIndexCountLimit',                  1, UNIX_TIMESTAMP(), '表中最多可建多少个索引',         '表"%s"中定义了%d个索引，数量超过允许的阈值%d。'),

('CTB-L3-001', 'table-create', 3, 1, '',     'eq',     'true',              5, 'TableCreateTargetDatabaseExists',             1, UNIX_TIMESTAMP(), '目标库是否存在',                 '目标表"%s"的库不存在。'),
('CTB-L3-002', 'table-create', 3, 1, '',     'eq',     'true',              5, 'TableCreateTargetTableExists',                1, UNIX_TIMESTAMP(), '目标表是否存在',                 '目标表"%s"在库"%s"已存在。');

### modify table
# ADD COLUMN (列名/数据类型/注释/字符集/排序规则/非空列默认值/目标列是否存在/时间戳数量)
# DROP COLUMN(目标列是否存在)
# MODIFY COLUMN(列名/数据类型/注释/字符集/排序规则/非空列默认值/目标列是否存在/时间戳数量)
# CHANGE COLUMN(列名/数据类型/注释/字符集/排序规则/非空列默认值/目标列是否存在/时间戳数量)
# ENABLE/DISABLE KEYS
# ADD CONSTRAINT(名称/目标是否存在)TableAlterAddTargetConstraintExists
# ADD FULLTEXT(名称/目标是否存在)TableAlterAddTargetFullTextExists
# ADD KEY/INDEX(名称/目标是否存在) TableAlterAddTargetIndexExists
# ENGINE(存储引擎) TableAlterAvailableEngines
# CHARSET(字符集)  TableAlterAvailableCharsets
# COLLATE(排序规则) TableAlterAvailableCollates
# RENAME(改名)TableAlterRenameTargetTableExists
# CONVERT TO CHARACTER SET(字符集) TableAlterAvailableCharsets
# DROP PRIMARY KEY(目标) TableAlterDropTargetPrimaryKeyExists
# DROP {INDEX|KEY}(目标) TableAlterDropTargetIndexExists
# DROP FOREIGN KEY(目标)TableAlterDropTargetForeignKeyExists
# DROP CONSTRAINT(目标) TableAlterDropTargetConstraitExists
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MTB-L1-001', 'table-alter', 1, 1, 'none', 'eq', 'true', 7, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '是否允许修改表',               '不允许修改表。'),
('MTB-L2-001', 'table-alter', 2, 1, '',     'in', '[]',   7, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '改表允许的字符集',             '修改表不允许使用字符集"%s"，请使用"%s"。'),
('MTB-L2-002', 'table-alter', 2, 1, '',     'in', '[]',   7, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '改表允许的校验规则',           '修改表不允许使用排序规则"%s"，请使用"%s"。'),
('MTB-L2-003', 'table-alter', 2, 1, '',     'eq', 'true', 5, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '表的字符集与排序规则必须匹配', '修改表使用的字符集"%s"和排序规则"%s"不匹配，请查阅官方文档。'),
('MTB-L2-004', 'table-alter', 2, 1, '',     'in', '[]',   7, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '改表允许的存储引擎',           '修改表不允许使用存储引擎"%s"，请使用"%s"。'),
('MTB-L2-005', 'table-alter', 2, 1, '',     'eq', 'true', 5, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '合并改表语句',                 '对同一个表"%s"的多条修改语句需要合并成一条语句。'),
('MTB-L2-006', 'table-alter', 2, 1, '',     'eq', 'true', 5, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '添加列时必须有注释',           '修改表"%s"新增列"%s"时需要为列提供COMMENT。'),
('MTB-L3-001', 'table-alter', 3, 1, '',     'eq', 'true', 5, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '目标表是否存在',               '要修改的表"%s"在实例"%s"的数据库"%s"中不存在。'),
('MTB-L3-002', 'table-alter', 3, 1, '',     'eq', 'true', 5, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '目标列是否存在',               '要修改表"%s"新增的列"%s"已存在。'),
('MTB-L3-003', 'table-alter', 3, 1, '',     'eq', 'true', 5, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '删除的列是否存在',             '要修改表"%s"删除的列"%s"不存在。'),
('MTB-L3-004', 'table-alter', 3, 1, '',     'eq', 'true', 5, 'TableAlterEnabled', 1, UNIX_TIMESTAMP(), '加列时相对位置列是否存在',     '要修改表"%s"为新增的列"%s"指定位置BEFORE、AFTER中的参照列"%s"在源表中不存在。');

### rename table
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('RTB-L1-001', 'table-rename', 1, 1, 'none', 'eq',     'false',          7, 'TableRenameEnabled',                          1, UNIX_TIMESTAMP(), '是否允许重命名表',       '不允许重命名表。'),
('RTB-L2-001', 'table-rename', 3, 1, '',     'eq',     'true',           5, 'TableRenameTablesIdentical',                  1, UNIX_TIMESTAMP(), '目标表跟源表是同一个表', '源表"%s"和目标表"%s"相同。'),
('RTB-L2-002', 'table-rename', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'TableRenameTargetTableNameQualified',         1, UNIX_TIMESTAMP(), '目标表名标识符规则',     '目标表名"%s"需要满足正则"%s"。'),
('RTB-L2-003', 'table-rename', 2, 1, '',     'eq',     'false',          5, 'TableRenameTargetTableNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '目标表名大小写规则',     '目标表名"%s"含有大写字母。'),
('RTB-L2-004', 'table-rename', 2, 1, '',     'lte',    '16',             7, 'TableRenameTargetTableNameMaxLength',         1, UNIX_TIMESTAMP(), '目标表名长度规则',       '目标表名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('RTB-L3-001', 'table-rename', 3, 1, '',     'eq',     'true',           5, 'TableRenameSourceTableExists',                1, UNIX_TIMESTAMP(), '源库是否存在',           '源表"%s"的库"%s"不存在。'),
('RTB-L3-002', 'table-rename', 3, 1, '',     'eq',     'true',           5, 'TableRenameSourceDatabaseExists',             1, UNIX_TIMESTAMP(), '源表是否存在',           '源表"%s"在库"%s"中不存在。'),
('RTB-L3-003', 'table-rename', 3, 1, '',     'eq',     'true',           5, 'TableRenameTargetTableExists',                1, UNIX_TIMESTAMP(), '目标库是否存在',         '目标表"%s"的库"%s"不存在。'),
('RTB-L3-004', 'table-rename', 3, 1, '',     'eq',     'true',           5, 'TableRenameTargetDatabaseExists',             1, UNIX_TIMESTAMP(), '目标表是否存在',         '目标表"%s"在库"%s"中已存在。');

### drop table
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DTB-L1-001', 'table-drop', 1, 1, 'none', 'eq', 'false', 5, 'TableDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删除表', '不允许删除表。'),
('DTB-L3-001', 'table-drop', 3, 1, '',     'eq', 'true',  5, 'TableDropSourceDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在', '目标表"%s"的库"%s"中不存在。'),
('DTB-L3-002', 'table-drop', 3, 1, '',     'eq', 'true',  5, 'TableDropSourceTableExists',    1, UNIX_TIMESTAMP(), '目标表是否存在', '目标表"%s"在库"%s"中不存在。');

### create index
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('CIX-L2-001', 'index-create', 2, 2, '',     'lte',    '5',            7, 'IndexCreateIndexMaxColumnLimit',        1, UNIX_TIMESTAMP(), '组合索引允许的最大列数',        '索引"%s"中索引列数量超过允许的阈值%d。'),
('CIX-L2-002', 'index-create', 2, 1, '',     'regexp', '\^index_%d+$', 5, 'IndexCreateIndexNameQualified',         1, UNIX_TIMESTAMP(), '索引名标识符规则',              '索引名"%s"需要满足正则"%s"。'),
('CIX-L2-003', 'index-create', 2, 1, '',     'regexp', '\^index_%d+$', 5, 'IndexCreateIndexNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '索引名大小写规则',              '索引名"%s"含有大写字母。'),
('CIX-L2-004', 'index-create', 2, 1, '',     'lte',    '25',           5, 'IndexCreateIndexNameMaxLength',         1, UNIX_TIMESTAMP(), '索引名长度规则',                '索引名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CIX-L2-005', 'index-create', 2, 1, '',     'regexp', '\^index_%d+$', 5, 'IndexCreateIndexNamePrefixRequired',    1, UNIX_TIMESTAMP(), '索引名前缀规则',                '索引名"%s"需要满足前缀正则"%s"。'),
('CIX-L2-006', 'index-create', 2, 1, '',     'eq',     'false',        5, 'IndexCreateDuplicateIndexColumn',       1, UNIX_TIMESTAMP(), '组合索引中是否有重复列',        '索引"%s"中索引了重复的列。'),
('CIX-L2-007', 'index-create', 2, 1, '',     'eq',     'false',        7, 'IndexCreateForeignKeyEnabled',          1, UNIX_TIMESTAMP(), '是否允许外键',                  '不允许使用外建。'),
('CIX-L3-001', 'index-create', 3, 1, '',     'eq',     'true',         5, 'IndexCreateTargetDatabaseExists',       1, UNIX_TIMESTAMP(), '添加索引的表所属库是否存在',    '索引"%s"依赖的目标表"%s"在库"%s"中不存在。'),
('CIX-L3-002', 'index-create', 3, 1, '',     'eq',     'true',         5, 'IndexCreateTargetTableExists',          1, UNIX_TIMESTAMP(), '条件索引的表是否存在',          '索引"%s"依赖的目标库"%s"不存在。'),
('CIX-L3-003', 'index-create', 3, 1, '',     'eq',     'true',         5, 'IndexCreateTargetColumnExists',         1, UNIX_TIMESTAMP(), '添加索引的列是否存在',          '索引"%s"中索引的列"%s"在表"%s"中不存在。'),
('CIX-L3-004', 'index-create', 3, 1, '',     'eq',     'false',        5, 'IndexCreateTargetIndexExists',          1, UNIX_TIMESTAMP(), '索引内容是否重复',              '索引"%s"在已有索引"%s"相同或者存在覆盖关系。'),
('CIX-L3-005', 'index-create', 3, 1, '',     'eq',     'false',        5, 'IndexCreateTargetNameExists',           1, UNIX_TIMESTAMP(), '索引名是否重复',                '索引名"%s"在表"%s"已经存在，请使用另外一个索引名称。'),
('CIX-L3-006', 'index-create', 3, 1, '',     'lte',    '5',            7, 'IndexCreateIndexCountLimit',            1, UNIX_TIMESTAMP(), '最多能建多少个索引',            '索引数量超过允许的阈值%d。'),
('CIX-L3-007', 'index-create', 2, 1, '',     'eq',     'false',        5, 'IndexCreateIndexBlobColumnEnabled',     1, UNIX_TIMESTAMP(), '是否允许在BLOB/TEXT列上建索引', '当前规则不允许在BLOB/TEXT类型的列上建立索引。');

### remove index
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('RIX-L1-001', 'index-drop', 1, 1, 'none', 'eq', 'true', 5, 'IndexDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删除索引', '不允许删除索引。'),
('RIX-L3-001', 'index-drop', 1, 1, '',     'eq', 'true', 5, 'IndexDropTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',   '目标索引"%s"关联的表"%s"的库"%s"不存在。'),
('RIX-L3-002', 'index-drop', 1, 1, '',     'eq', 'true', 5, 'IndexDropTargetTableExists',    1, UNIX_TIMESTAMP(), '目标表是否存在',   '目标索引"%s"关联的表"%s"在库"%s"中不存在。'), 
('RIX-L3-003', 'index-drop', 1, 1, '',     'eq', 'true', 5, 'IndexDropTargetIndexExists',    1, UNIX_TIMESTAMP(), '目标索引是否存在', '目标索引"%s"在表"%s"中不存在。');

### insert data
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('INS-L2-001', 'data-insert', 2, 1, '',     'eq', 'false', 5, 'InsertExplicitColumnRequired',        1, UNIX_TIMESTAMP(), '是否要求显式列申明',       '不允许执行没有显式提供列列表的INSERT语句。'),
('INS-L2-002', 'data-insert', 2, 2, '',     'eq', 'false', 7, 'InsertUsingSelectEnabled',            1, UNIX_TIMESTAMP(), '是否允许INSERT...SELECT',  '不允许执行INSERT ... SELECT ...语句。'),
('INS-L2-003', 'data-insert', 2, 1, '',     'eq', 'true',  5, 'InsertMergeRequired',                 1, UNIX_TIMESTAMP(), '是否合并INSERT',           '多条插入语句需要合并成单条语句。'),
('INS-L2-004', 'data-insert', 2, 2, '',     'eq', '10000', 7, 'InsertRowsLimit',                     1, UNIX_TIMESTAMP(), '单语句允许操作的最大行数', '单条插入语句不得操作超过%d条记录。'),
('INS-L2-005', 'data-insert', 2, 1, '',     'eq', 'true',  5, 'InsertColumnValueMatch',              1, UNIX_TIMESTAMP(), '列类型、值是否匹配',       '插入语句的列数量和值数量不匹配。'),
('INS-L3-001', 'data-insert', 3, 1, '',     'eq', 'true',  5, 'InsertTargetDatabaseExists',          1, UNIX_TIMESTAMP(), '目标库是否存在',           '插入语句中指定的库"%s"不存在。'),
('INS-L3-002', 'data-insert', 3, 1, '',     'eq', 'true',  5, 'InsertTargetTableExists',             1, UNIX_TIMESTAMP(), '目标表是否存在',           '插入语句中指定的表"%s"在库"%s"中不存在。'),
('INS-L3-003', 'data-insert', 3, 1, '',     'eq', 'true',  5, 'InsertTargetColumnExists',            1, UNIX_TIMESTAMP(), '目标列是否存在',           '插入语句中指定的列"%s"在表"%s"中不存在。'),
('INS-L3-004', 'data-insert', 3, 1, '',     'eq', 'true',  5, 'InsertValueForNotNullColumnRequired', 1, UNIX_TIMESTAMP(), '非空列是否有值',           '插入语句没有为非空列"%s"提供值。');

### replace data
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('RPL-L2-001', 'data-replace', 2, 1, 'none', 'eq',  'false', 5, 'ReplaceExplicitColumnRequired',        1, UNIX_TIMESTAMP(), '是否要求显式列申明',       '不允许执行没有显式提供列列表的REPLACE语句。'),
('RPL-L2-002', 'data-replace', 2, 2, '',     'eq',  'false', 5, 'ReplaceUsingSelectEnabled',            1, UNIX_TIMESTAMP(), '是否允许REPLACE...SELECT', '不允许执行REPLACE ... SELECT ...语句。'),
('RPL-L2-003', 'data-replace', 2, 1, '',     'lte', '1000',  7, 'ReplaceMergeRequired',                 1, UNIX_TIMESTAMP(), '是否合并REPLACE',          '多条替换语句需要合并成单条语句。'),
('RPL-L2-004', 'data-replace', 2, 2, '',     'lte', '1000',  7, 'ReplaceRowsLimit',                     1, UNIX_TIMESTAMP(), '单语句允许操作的最大行数', '单条替换语句不得操作超过%d条记录。'),
('RPL-L2-005', 'data-replace', 2, 1, '',     'eq',  'ture',  5, 'ReplaceColumnValueMatch',              1, UNIX_TIMESTAMP(), '列类型、值是否匹配',       '替换语句的列数量和值数量不匹配。'),
('RPL-L3-001', 'data-replace', 3, 1, '',     'eq',  'true',  5, 'ReplaceTargetDatabaseExists',          1, UNIX_TIMESTAMP(), '目标库是否存在',           '替换语句中指定的库"%s"不存在。'),
('RPL-L3-002', 'data-replace', 3, 1, '',     'eq',  'true',  5, 'ReplaceTargetTableExists',             1, UNIX_TIMESTAMP(), '目标表是否存在',           '替换语句中指定的表"%s"在库"%s"中不存在。'),
('RPL-L3-003', 'data-replace', 3, 1, '',     'eq',  'true',  5, 'ReplaceTargetColumnExists',            1, UNIX_TIMESTAMP(), '目标列是否存在',           '替换语句中指定的列"%s"在表"%s"中不存在。'),
('RPL-L3-004', 'data-replace', 3, 1, '',     'eq',  'true',  5, 'ReplaceValueForNotNullColumnRequired', 1, UNIX_TIMESTAMP(), '非空列是否有值',           '替换语句没有为非空列"%s"提供值。');

### update data
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('UPD-L2-001', 'data-update', 3, 1, 'none', 'eq',  'false', 5, 'UpdateWithoutWhereEnabled',  1, UNIX_TIMESTAMP(), '是否允许没有WHERE的更新', '不允许执行没有WHERE从句的更新语句。'),
('UPD-L3-001', 'data-update', 3, 1, '',     'eq',  'true',  5, 'UpdateTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',          '更新语句中指定的库"%s"不存在。'),
('UPD-L3-002', 'data-update', 3, 1, '',     'eq',  'true',  5, 'UpdateTargetTableExists',    1, UNIX_TIMESTAMP(), '目标表是否存在',          '更新语句中指定的表"%s"在库"%s"中不存在。'),
('UPD-L3-003', 'data-update', 3, 1, '',     'eq',  'true',  5, 'UpdateTargetColumnExists',   1, UNIX_TIMESTAMP(), '目标列是否存在',          '更新语句中待更新的列"%s"不存在。'),
('UPD-L3-004', 'data-update', 3, 1, '',     'eq',  'true',  5, 'UpdateFilterColumnExists',   1, UNIX_TIMESTAMP(), '条件过滤列是否存在',      '更新语句中条件过滤列"%s"在表"%s"中不存在。'),
('UPD-L3-005', 'data-update', 3, 2, '',     'lte', '1000',  7, 'UpdateRowsLimit',            1, UNIX_TIMESTAMP(), '允许单次更新的最大行数',  '单条更新语句不得操作超过%d条记录。');

### delete data
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DEL-L2-001', 'data-delete', 2, 1, 'none', 'eq',  'false', 5, 'DeleteWithoutWhereEnabled',  1, UNIX_TIMESTAMP(), '是否允许没有WHERE的删除', '不允许执行没有WHERE从句的删除语句。'),
('DEL-L3-001', 'data-delete', 3, 2, '',     'lte', '1000',  7, 'DeleteRowsLimit',            1, UNIX_TIMESTAMP(), '单次删除的最大行数',      '单条删除语句不得操作超过%d条记录。'),
('DEL-L3-002', 'data-delete', 3, 1, '',     'eq',  'true',  5, 'DeleteTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',          '删除语句中指的库"%s"不存在。'),
('DEL-L3-003', 'data-delete', 3, 1, '',     'eq',  'true',  5, 'DeleteTargetTableExists',    1, UNIX_TIMESTAMP(), '目标表是否存在',          '删除语句中指的表"%s"在库"%s"中不存在。'),
('DEL-L3-004', 'data-delete', 3, 1, '',     'eq',  'true',  5, 'DeleteFilterColumnExists',   1, UNIX_TIMESTAMP(), '条件过滤列是否存在',      '删除语句中条件过滤列"%s"在表"%s"中不存在。');

### select data
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('SEL-L2-001', 'data-select', 2, 1, 'none', 'eq', 'false', 5, 'SelectWithoutWhereEnabled',  1, UNIX_TIMESTAMP(), '是否允许没有WHERE的查询',   '不允许执行没有WHERE从句的查询语句。'),
('SEL-L2-002', 'data-select', 2, 1, '',     'eq', 'false', 7, 'SelectWithoutLimitEnabled',  1, UNIX_TIMESTAMP(), '是否允许没有LIMIT的查询',   '不允许执行没有LIMIT从句的查询语句。'),
('SEL-L2-003', 'data-select', 2, 2, '',     'eq', 'false', 7, 'SelectStarEnabled',          1, UNIX_TIMESTAMP(), '是否允许SELECT STAR',       '不允许执行SELECT *操作，需要显式指定需要查询的列。'),
('SEL-L2-004', 'data-select', 2, 1, '',     'eq', 'false', 5, 'SelectForUpdateEnabled',     1, UNIX_TIMESTAMP(), '是否允许SELECT FOR UPDATE', '不允许执行SELECT FOR UPDATE操作。'),
('SEL-L3-001', 'data-select', 3, 1, '',     'eq', 'true',  5, 'SelectTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标数据库是否存在',        '查询语句中指的库"%s"不存在。'),
('SEL-L3-002', 'data-select', 3, 1, '',     'eq', 'true',  5, 'SelectTargetTableExists',    1, UNIX_TIMESTAMP(), '目标表是否存在',            '查询语句中指的表"%s"在库"%s"中不存在。'),
('SEL-L3-003', 'data-select', 3, 1, '',     'eq', 'true',  5, 'SelectTargetColumnExists',   1, UNIX_TIMESTAMP(), '目标列是否存在',            '查询语句中指的列"%s"在表"%s"中不存在。'),
('SEL-L3-004', 'data-select', 3, 2, '',     'eq', 'true',  5, 'SelectBlobOrTextEnabled',    1, UNIX_TIMESTAMP(), '是否允许返回BLOB/TEXT列',   '查询语句中指的列"%s"是BLOB/TEXT类型。'),
('SEL-L3-005', 'data-select', 3, 1, '',     'eq', 'true',  5, 'SelectFilterColumnExists',   1, UNIX_TIMESTAMP(), '条件过滤列是否存在',        '查询语句中条件过滤列"%s"在表"%s"中不存在。');

### view-create
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('CVW-L1-001', 'view-create', 1, 1, 'none', 'eq',     'false',            5, 'ViewCreateEnabled',                   1, UNIX_TIMESTAMP(), '是否允许创建视图', '不允许创建视图。'),
('CVW-L2-001', 'view-create', 2, 1, '',     'regexp', '^[_a-zA-Z_]+$',    5, 'ViewCreateViewNameQualified',         1, UNIX_TIMESTAMP(), '视图名标识符规则', '视图名"%s"需要满足正则"%s"。'),
('CVW-L2-002', 'view-create', 2, 1, '',     'regexp', '^[_a-zA-Z_]+$',    5, 'ViewCreateViewNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '视图名大小写规则', '视图名"%s"含有大写字母。'),
('CVW-L2-003', 'view-create', 2, 1, '',     'lte',    '16',               7, 'ViewCreateViewNameMaxLength',         1, UNIX_TIMESTAMP(), '视图名长度规则',   '视图名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CVW-L2-004', 'view-create', 2, 1, '',     'regexp', '^vw_[_a-zA-Z_]+$', 7, 'ViewCreateViewNamePrefixRequired',    1, UNIX_TIMESTAMP(), '视图名前缀规则',   '视图名"%s"需要满足前缀正则"%s"。'),
('CVW-L3-001', 'view-create', 3, 1, '',     'eq',     'true',             5, 'ViewCreateTargetDatabaseExists',      1, UNIX_TIMESTAMP(), '目标库是否存在',   '视图"%s"指定的库"%s"不存在。'),
('CVW-L3-002', 'view-create', 3, 1, '',     'eq',     'false',            5, 'ViewCreateTargetViewExists',          1, UNIX_TIMESTAMP(), '目标视图是否存在', '视图"%s"在库"%s"中已存在。');

### view-alter
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MVW-L1-001', 'view-alter', 1, 1, 'none', 'eq', 'false', 5, 'ViewAlterEnabled',              1, UNIX_TIMESTAMP(), '是否允许修改视图', '不允许修改视图。'),
('MVW-L3-001', 'view-alter', 3, 1, '',     'eq', 'true',  5, 'ViewAlterTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',   '目标视图"%s"所在的库"%s"不存在。'),
('MVW-L3-002', 'view-alter', 3, 1, '',     'eq', 'true',  5, 'ViewAlterTargetViewExists',     1, UNIX_TIMESTAMP(), '目标视图是否存在', '目标视图"%s"在库"%s"中不存在。');

### drop view
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DVW-L1-001', 'view-drop', 1, 1, 'none', 'eq', 'false', 5, 'ViewDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删除视图', '不允许删除视图。'),
('DVW-L3-001', 'view-drop', 3, 1, '',     'eq', 'true',  5, 'ViewDropTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',   '目标视图"%s"所在的库"%s"不存在。'),
('DVW-L3-002', 'view-drop', 3, 1, '',     'eq', 'true',  5, 'ViewDropTargetViewExists',     1, UNIX_TIMESTAMP(), '目标视图是否存在', '目标视图"%s"在库"%s"中不存在。');

### function-create
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('CFU-L1-001', 'func-create', 1, 1, 'none', 'eq',     'false',          7, 'FuncCreateEnabled',                   1, UNIX_TIMESTAMP(), '是否允许创建函数', '不允许修改函数。'),
('CFU-L2-001', 'func-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 7, 'FuncCreateFuncNameQuilified',         1, UNIX_TIMESTAMP(), '函数名标识符规则', '函数名"%s"需要满足正则"%s"。'),
('CFU-L2-002', 'func-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 7, 'FuncCreateFuncNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '函数名大小写规则', '函数名"%s"含有大写字母。'),
('CFU-L2-003', 'func-create', 2, 1, '',     'lte',    '16',             7, 'FuncCreateFuncNameMaxLength',         1, UNIX_TIMESTAMP(), '函数名长度规则',   '函数名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CFU-L2-004', 'func-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 7, 'FuncCreateFuncNamePrefixRequired',    1, UNIX_TIMESTAMP(), '函数名前缀规则',   '函数名"%s"需要满足前缀正则"%s"。'),
('CFU-L3-001', 'func-create', 3, 1, '',     'eq',     'true',           5, 'FuncCreateTargetDatabaseExists',      1, UNIX_TIMESTAMP(), '目标库是否存在',   '函数"%s"指定的库"%s"不存在。'),
('CFU-L3-002', 'func-create', 3, 1, '',     'eq',     'false',          5, 'FuncCreateTargetFuncExists',          1, UNIX_TIMESTAMP(), '目标函数是否存在', '函数"%s"在库"%s"中已存在。');

### function-alter
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MFU-L1-001', 'func-alter', 1, 1, 'none', 'eq', 'false', 7, 'FuncAlterEnabled',              1, UNIX_TIMESTAMP(), '是否允许修改函数', '不允许修改函数。'),
('MFU-L3-001', 'func-alter', 3, 1, '',     'eq', 'true',  5, 'FuncAlterTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',   '目标函数"%s"所在的库"%s"不存在。'),
('MFU-L3-002', 'func-alter', 3, 1, '',     'eq', 'true',  5, 'FuncAlterTargetFuncExists',     1, UNIX_TIMESTAMP(), '目标函数是否存在', '目标函数"%s"在库"%s"中不存在。');

### function-drop
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DFU-L1-001', 'func-drop', 1, 1, 'none', 'eq', 'false', 7, 'FuncDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删除函数', '不允许删除函数。'),
('DFU-L3-001', 'func-drop', 3, 1, '',     'eq', 'true',  5, 'FuncDropTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',   '目标函数"%s"所在的库"%s"不存在。'),
('DFU-L3-002', 'func-drop', 3, 1, '',     'eq', 'true',  5, 'FuncDropTargetFuncExists',     1, UNIX_TIMESTAMP(), '目标函数是否存在', '目标函数"%s"在库"%s"中不存在。');

### trigger-create
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('CTG-L1-001', 'trigger-create', 1, 1, 'none', 'eq',     'false',          7, 'TriggerCreateEnabled',                      1, UNIX_TIMESTAMP(), '是否允许创建触发器', '不允许创建触发器。'),
('CTG-L2-001', 'trigger-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'TriggerCreateTriggerNameQualified',         1, UNIX_TIMESTAMP(), '触发器名标识符规则', '触发器名"%s"需要满足正则"%s"。'),
('CTG-L2-002', 'trigger-create', 2, 1, '',     'lte',    '32',             7, 'TriggerCreateTriggerNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '触发器名大小写规则', '触发器名"%s"含有大写字母。'),
('CTG-L2-003', 'trigger-create', 2, 1, '',     'lte',    '32',             7, 'TriggerCreateTriggerNameMaxLength',         1, UNIX_TIMESTAMP(), '触发器名长度规则',   '触发器名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CTG-L2-004', 'trigger-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'TriggerCreateTriggerPrefixRequired',        1, UNIX_TIMESTAMP(), '触发器名前缀规则',   '触发器名"%s"需要满足前缀正则"%s"。'),
('CTG-L3-001', 'trigger-create', 2, 1, '',     'eq',     'true',           5, 'TriggerCreateTargetDatabaseExists',         1, UNIX_TIMESTAMP(), '目标库是否存在',     '触发器"%s"指定的库"%s"不存在。'),
('CTG-L3-002', 'trigger-create', 2, 1, '',     'eq',     'false',          5, 'TriggerCreateTargetTableExists',            1, UNIX_TIMESTAMP(), '目标表是否存在',     '触发器"%s"指定的表"%s"不存在。'),
('CTG-L3-003', 'trigger-create', 2, 1, '',     'eq',     'false',          5, 'TriggerCreateTargetTriggerExists',          1, UNIX_TIMESTAMP(), '目标触发器是否存在', '触发器"%s"在表"%s"中已经存在。');

### trigger-alter
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MTG-L1-001', 'trigger-alter', 1, 1, 'none', 'eq', 'false', 7, 'TriggerAlterEnabled',              1, UNIX_TIMESTAMP(), '是否允许修改触发器', '不允许修改触发器。'),
('MTG-L3-001', 'trigger-alter', 3, 1, '',     'eq', 'true',  5, 'TriggerAlterTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',     '目标触发器"%s"所在的库"%s"不存在。'),
('MTG-L3-002', 'trigger-alter', 3, 1, '',     'eq', 'true',  5, 'TriggerAlterTargetTableExists',    1, UNIX_TIMESTAMP(), '目标表是否存在',     '目标触发器"%s"所在的表"%s"不存在。'),
('MTG-L3-003', 'trigger-alter', 3, 1, '',     'eq', 'true',  5, 'TriggerAlterTargetTriggerExists',  1, UNIX_TIMESTAMP(), '目标触发器是否存在', '目标触发器"%s"在表"%s"中不存在。');

### trigger-drop
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DTG-L1-001', 'trigger-drop', 1, 1, 'none', 'eq', 'false', 7, 'TriggerDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删除触发器', '不允许删除触发器。'),
('DTG-L3-001', 'trigger-drop', 3, 1, '',     'eq', 'true',  5, 'TriggerDropTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',     '目标触发器"%s"所在的库"%s"不存在。'),
('DTG-L3-002', 'trigger-drop', 3, 1, '',     'eq', 'true',  5, 'TriggerDropTargetTableExists',    1, UNIX_TIMESTAMP(), '目标表是否存在',     '目标触发器"%s"所在的表"%s"不存在。'),
('DTG-L3-002', 'trigger-drop', 3, 1, '',     'eq', 'true',  5, 'TriggerDropTargetTriggerExists',  1, UNIX_TIMESTAMP(), '目标触发器是否存在', '目标触发器"%s"在表"%s"中不存在。');

### event-create
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('CEV-L1-001', 'event-create', 1, 1, 'none', 'eq',     'false',          7, 'EventCreateEnabled',                    1, UNIX_TIMESTAMP(), '是否允许创建事件', '不允许创建事件。'),
('CEV-L2-001', 'event-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'EventCreateEventNameQualified',         1, UNIX_TIMESTAMP(), '事件名标识符规则', '事件名"%s"需要满足正则"%s"。'),
('CEV-L2-002', 'event-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'EventCreateEventNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '事件名大小写规则', '事件名"%s"含有大写字母。'),
('CEV-L2-003', 'event-create', 2, 1, '',     'lte',    '16',             7, 'EventCreateEventNameMaxLength',         1, UNIX_TIMESTAMP(), '事件名长度规则',   '事件名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CEV-L2-004', 'event-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'EventCreateEventNamePrefixRequired',    1, UNIX_TIMESTAMP(), '事件名前缀规则',   '事件名"%s"需要满足前缀正则"%s"。'),
('CEV-L3-001', 'event-create', 3, 1, '',     'eq',     'true',           5, 'EventCreateTargetDatabaseExists',       1, UNIX_TIMESTAMP(), '目标库是否存在',   '事件"%s"所在的库"%s"不存在。'),
('CEV-L3-002', 'event-create', 3, 1, '',     'eq',     'false',          5, 'EventCreateTargetEventExists',          1, UNIX_TIMESTAMP(), '目标事件是否存在', '事件"%s"在库"%s"中已存在。');
                         
### event-alter
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MEV-L1-001', 'event-alter', 1, 1, 'none', 'eq', 'false', 7, 'EventAlterEnabled',              1, UNIX_TIMESTAMP(), '是否允许修改事件', '不允许修改事件。'),
('MEV-L3-001', 'event-alter', 3, 1, '',     'eq', 'true',  5, 'EventAlterTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',   '目标事件"%s"所在的库"%s"不存在。'),
('MEV-L3-002', 'event-alter', 3, 1, '',     'eq', 'true',  5, 'EventAlterTargetEventExists',    1, UNIX_TIMESTAMP(), '目标事件是否存在', '目标事件"%s"在库"%s"中不存在。');

### event-drop
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DEV-L1-001', 'event-drop', 1, 1, 'none', 'eq', 'false', 7, 'EventDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删除事件', '不允许删除事件。'),
('DEV-L3-001', 'event-drop', 3, 1, '',     'eq', 'true',  5, 'EventDropTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',   '目标事件"%s"所在的库"%s"中不存在。'),
('DEV-L3-002', 'event-drop', 3, 1, '',     'eq', 'true',  5, 'EventDropTargetEventExists',    1, UNIX_TIMESTAMP(), '目标事件是否存在', '目标事件"%s"在库"%s"中不存在。');

### procedure-create
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('CSP-L1-001', 'procedure-create', 1, 1, 'none', 'eq',     'false',          7, 'ProcCreateEnabled',                   1, UNIX_TIMESTAMP(), '是否允许创建存储过程', '不允许创建存储过程。'),
('CSP-L2-001', 'procedure-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'ProcCreateProcNameQualified',         1, UNIX_TIMESTAMP(), '存储过程名标识符规则', '存储过程名"%s"需要满足正则"%s"。'),
('CSP-L2-002', 'procedure-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'ProcCreateProcNameLowerCaseRequired', 1, UNIX_TIMESTAMP(), '存储过程名大小写规则', '存储过程名"%s"含有大写字母。'),
('CSP-L2-003', 'procedure-create', 2, 1, '',     'lte',    '32',             5, 'ProcCreateProcNameMaxLength',         1, UNIX_TIMESTAMP(), '存储过程名长度规则',   '存储过程名"%s"的长度超出了规则允许的上限，请控制在%d个字符以内。'),
('CSP-L2-004', 'procedure-create', 2, 1, '',     'regexp', '\^[_a-zA-Z_]+$', 5, 'ProcCreateProcNamePrefixRequired',    1, UNIX_TIMESTAMP(), '存储过程名前缀规则',   '存储过程名"%s"需要满足前缀正则"%s"。'),
('CSP-L3-001', 'procedure-create', 3, 1, '',     'eq',     'true',           5, 'ProcCreateTargetDatabaseExists',      1, UNIX_TIMESTAMP(), '目标库是否存在',       '存储过程"%s"所在的库不存在。'),
('CSP-L3-002', 'procedure-create', 3, 1, '',     'eq',     'false',          5, 'ProcCreateTargetProcExists',          1, UNIX_TIMESTAMP(), '目标存储过程是否存在', '存储过程"%s"在库"%s"中已存在。');

### procedure-alter
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MSP-L1-001', 'procedure-alter', 1, 1, 'none', 'eq', 'false', 7, 'ProcAlterEnabled',              1, UNIX_TIMESTAMP(), '是否允许修改存储过程', '不允许修改存储过程。'),
('MSP-L3-001', 'procedure-alter', 3, 1, '',     'eq', 'true',  5, 'ProcAlterTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',       '目标存储过程"%s"所在的库"%s"不存在。'),
('MSP-L3-002', 'procedure-alter', 3, 1, '',     'eq', 'true',  5, 'ProcAlterTargetProcExists',     1, UNIX_TIMESTAMP(), '目标存储过程是否存在', '目标存储过程"%s"在库"%s"中不存在。');

### procedure-drop
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('DSP-L1-001', 'procedure-drop', 1, 1, 'none', 'eq', 'false', 7, 'ProcDropEnabled',              1, UNIX_TIMESTAMP(), '是否允许删除存储过程', '不允许删除存储过程。'),
('DSP-L3-001', 'procedure-drop', 3, 1, '',     'eq', 'true',  5, 'ProcDropTargetDatabaseExists', 1, UNIX_TIMESTAMP(), '目标库是否存在',       '目标存储过程"%s"所在的库"%s"不存在。'),
('DSP-L3-002', 'procedure-drop', 3, 1, '',     'eq', 'true',  5, 'ProcDropTargetProcExists',     1, UNIX_TIMESTAMP(), '目标存储过程是否存在', '目标存储过程"%s"在库"%s"中不存在。');

### misc
INSERT INTO `rules`(`name`, `group`, `level`, `severity`, `element`, `operator`, `values`, `bitwise`, `func`, `version`, `create_at`, `description`, `message`) VALUES
('MSC-L1-001', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'LockTableEnabled',       1, UNIX_TIMESTAMP(), '是否允许LOCK TABLE',         '不允许执行LOCK TABLE命名。'),
('MSC-L1-002', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'FlushTableEnabled',      1, UNIX_TIMESTAMP(), '是否允许FLUSH TABLE',        '不允许执行FLUSH TABLE命令。'),
('MSC-L1-003', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'TruncateTableEnabled',   1, UNIX_TIMESTAMP(), '是否允许TRUNCATE TABLE',     '不允许执行TRUNCATE TABLE命令。'),
('MSC-L1-004', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'PurgeBinaryLogsEnabled', 1, UNIX_TIMESTAMP(), '是否允许PURGE BINARY',       '不允许执行PURGE BINARY LOGS命令。'),
('MSC-L1-005', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'PurgeLogsEnabled',       1, UNIX_TIMESTAMP(), '是否允许PURGE LOG',          '不允许执行PURGE LOGS命令。'),
('MSC-L1-006', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'UnlockTableEnabled',     1, UNIX_TIMESTAMP(), '是否允许UNLOCK TABLE',       '不允许执行UNLOCK TABLES命令。'),
('MSC-L1-007', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'KillEnabled',            1, UNIX_TIMESTAMP(), '是否允许KILL线程',           '不允许执行KILL命令。'),
('MSC-L1-008', 'miscellaneous', 1, 1, 'none', 'eq', 'false', 5, 'KeywordEnabled',         1, UNIX_TIMESTAMP(), '是否允许使用关键字',         '不允许使用保留关键字作为标识符。'),
('MSC-L0-001', 'miscellaneous', 1, 1, 'none', 'eq', 'true',  5, 'MixedStatementEnabled',  1, UNIX_TIMESTAMP(), '是否允许同时出现DDL、DML',   '不允许在一个工单中同时出现DML和DDL操作，请分开多个工单提交。');

