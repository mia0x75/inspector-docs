package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Plans struct {
	StatementId uint   `xorm:"statement_id notnull int pk"`                                 //
	Value       string `xorm:"value notnull tinytext" valid:"required,length(1|255),ascii"` //
	Version     int    `xorm:"version" json:"-"`                                            //
	UpdateAt    uint   `xorm:"update_at notnull int" valid:"uint32"`                        //
	CreateAt    uint   `xorm:"create_at notnull int" valid:"required,uint32"`               //
}

func (this *Plans) TableName() string {
	return "mm_plans"
}

func (this *Plans) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Plans) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Plans) AfterSet(colName string, _ xorm.Cell) {
}
