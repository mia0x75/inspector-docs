package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Statements struct {
	StatementId uint   `xorm:"statement_id notnull int pk autoincr"`                       //
	Sql         string `xorm:"sql notnull text" valid:"required,length(1|65535),ascii"`    //
	Type        uint8  `xorm:"type notnull int" valid:"required,matches(^([1-9]?[0-9])$)"` // 类型 0-99
	TicketId    string `xorm:"ticket_id notnull int" valid:"required,uint32"`              //
	Version     int    `xorm:"version" json:"-"`                                           //
	UpdateAt    uint   `xorm:"update_at notnull int" valid:"uint32"`                       //
	CreateAt    uint   `xorm:"create_at notnull int" valid:"required,uint32"`              //
}

func (this *Statements) TableName() string {
	return "mm_statements"
}

func (this *Statements) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Statements) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Statements) AfterSet(colName string, _ xorm.Cell) {
}
