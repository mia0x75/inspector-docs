package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Queries struct {
	QueryId  uint   `xorm:"query_id notnull int pk autoincr"`                         //
	Sql      string `xorm:"sql notnull text" valid:"required,length(1|65535),ascii"`  //
	Plan     string `xorm:"plan notnull text" valid:"required,length(1|65535),ascii"` //
	OwnerId  string `xorm:"owner_id notnull int" valid:"required,uint32"`             //
	Version  int    `xorm:"version" json:"-"`                                         //
	UpdateAt uint   `xorm:"update_at notnull int" valid:"uint32"`                     //
	CreateAt uint   `xorm:"create_at notnull int" valid:"required,uint32"`            //
}

func (this *Queries) TableName() string {
	return "mm_queries"
}

func (this *Queries) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Queries) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Queries) AfterSet(colName string, _ xorm.Cell) {
}
