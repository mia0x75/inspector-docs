package models

import (
	"fmt"
	"strconv"
	"time"

	"github.com/go-xorm/xorm"
	cache "github.com/patrickmn/go-cache"
)

var (
	caches *cache.Cache = cache.New(5*time.Minute, 10*time.Minute)
)

type Instances struct {
	InstanceId uint   `xorm:"instance_id notnull int pk autoincr"`                                                //
	Host       string `xorm:"host notnull varchar(150) unique(unique_1)" valid:"required,length(1|100),alphanum"` //
	Alias      string `xorm:"alias notnull varchar(75) unique(unique_3)" valid:"required,runelength(1|100)"`      //
	Ip         uint   `xorm:"ip notnull int unique(unique_2)" valid:"required,uint32"`                            //
	Port       uint16 `xorm:"port notnull smallint unique(unique_1) unique(unique_2)" valid:"required,port"`      //
	User       string `xorm:"user notnull varchar(50)" valid:"required,length(1|50),alphanum" json:"-"`           //
	Password   []byte `xorm:"password notnull varbinary(48)" valid:"required" json:"-"`                           // 双向加密
	Status     uint8  `xorm:"status notnull tinyint" valid:"required,matches(^[0-9]$)"`                           //
	Version    int    `xorm:"version" json:"-"`                                                                   //
	UpdateAt   uint   `xorm:"update_at notnull int" valid:"uint32"`                                               //
	CreateAt   uint   `xorm:"create_at notnull int" valid:"required,uint32"`                                      //
	Databases  map[string]*Database
	Engine     *xorm.Engine `json:"-"`
}

func (this *Instances) TableName() string {
	return "mm_instances"
}

func (this *Instances) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Instances) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Instances) AfterSet(colName string, _ xorm.Cell) {
}

func (this *Instances) GetDatabaseList() ([]*Database, error) {
	key := fmt.Sprintf("databases-on-instance-%d", this.InstanceId)
	if databases, found := caches.Get(key); found {
		if rs, ok := databases.([]*Database); ok {
			return rs, nil
		}
	}
	rs := make([]*Database, 0)
	this.Engine.Ping()
	rows, err := this.Engine.QueryString("SHOW DATABASES;")
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		if row["Database"] == "information_schema" || row["Database"] == "performance_schema" {
			continue
		}
		rs = append(rs, &Database{
			Name: row["Database"],
		})
	}
	caches.Set(key, rs, cache.NoExpiration)
	return rs, nil
}

type Database struct {
	Name   string            //
	Tables map[string]*Table //
}

func (this *Database) GetTableList(instance *Instances, database string) ([]*Table, error) {
	key := fmt.Sprintf("tables-on-database-%s-on-instance-%d", database, instance.InstanceId)
	if tables, found := caches.Get(key); found {
		if rs, ok := tables.([]*Table); ok {
			return rs, nil
		}
	}
	rs := make([]*Table, 0)
	instance.Engine.Ping()
	rows, err := instance.Engine.QueryString(fmt.Sprintf("SHOW FULL TABLES FROM `%s` WHERE TABLE_TYPE = 'BASE TABLE';", database))
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		rs = append(rs, &Table{
			Name: row[fmt.Sprintf("Tables_in_%s", database)],
			Type: row["Table_type"],
		})
	}
	caches.Set(key, rs, cache.NoExpiration)
	return rs, nil
}

type Table struct {
	Name      string             ``         //
	Type      string             `json:"-"` //
	Charset   string             ``         //
	Collation string             ``         //
	Columns   map[string]*Column ``         //
	Indices   map[string]*Index  ``         // __PK__ 默认主键
}

func (this *Table) GetColumnList(instance *Instances, database, table string) ([]*Column, error) {
	key := fmt.Sprintf("columns-on-table-%s.%s-on-instance-%d", database, table, instance.InstanceId)
	if columns, found := caches.Get(key); found {
		if rs, ok := columns.([]*Column); ok {
			return rs, nil
		}
	}
	rs := make([]*Column, 0)
	instance.Engine.Ping()
	rows, err := instance.Engine.QueryString(fmt.Sprintf("SHOW FULL COLUMNS FROM `%s` FROM `%s`;", table, database))
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		rs = append(rs, &Column{
			Field:      row["Field"],
			Type:       row["Type"],
			Collation:  row["Collation"],
			Null:       row["Null"],
			Key:        row["Key"],
			Default:    row["Default"],
			Extra:      row["Extra"],
			Privileges: row["Privileges"],
			Comment:    row["Comment"],
		})
	}
	caches.Set(key, rs, cache.NoExpiration)
	return rs, nil
}

func (this *Table) GetIndexList(instance *Instances, database, table string) ([]*Index, error) {
	key := fmt.Sprintf("indices-on-table-%s.%s-on-instance-%d", database, table, instance.InstanceId)
	if indices, found := caches.Get(key); found {
		if rs, ok := indices.([]*Index); ok {
			return rs, nil
		}
	}
	rs := make([]*Index, 0)
	instance.Engine.Ping()
	rows, err := instance.Engine.QueryString(fmt.Sprintf("SHOW INDEX FROM `%s` FROM `%s`;", table, database))
	if err != nil {
		return nil, err
	}
	for _, row := range rows {
		seqInIndex, _ := strconv.ParseUint(row["SeqInIndex"], 10, 32)
		cardinality, _ := strconv.ParseUint(row["Cardinality"], 10, 32)
		nonUnique, _ := strconv.ParseBool(row["NonUnique"])
		rs = append(rs, &Index{
			Table:        row["Table"],
			NonUnique:    nonUnique,
			KeyName:      row["KeyName"],
			SeqInIndex:   uint(seqInIndex),
			ColumnName:   row["ColumnName"],
			Collation:    row["Collation"],
			Cardinality:  uint(cardinality),
			SubPart:      row["SubPart"],
			Packed:       row["Packed"],
			Null:         row["Null"],
			IndexType:    row["IndexType"],
			Comment:      row["Comment"],
			IndexComment: row["IndexComment"],
		})
	}
	caches.Set(key, rs, cache.NoExpiration)
	return rs, nil
}

type Column struct {
	Field      string ``         //
	Type       string ``         //
	Charset    string ``         //
	Collation  string ``         //
	Null       string ``         //
	Key        string ``         //
	Default    string ``         //
	Extra      string ``         //
	Privileges string `json:"-"` //
	Comment    string ``         //
}

type Index struct {
	Table        string             ``         //
	NonUnique    bool               ``         //
	KeyName      string             ``         //
	SeqInIndex   uint               ``         //
	ColumnName   string             ``         //
	Collation    string             `json:"-"` //
	Cardinality  uint               `json:"-"` //
	SubPart      string             `json:"-"` //
	Packed       string             `json:"-"` //
	Null         string             ``         //
	IndexType    string             ``         //
	Comment      string             ``         //
	IndexComment string             ``         //
	Columns      map[string]*Column ``         //
}
