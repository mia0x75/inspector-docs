package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Rules struct {
	RuleId      uint   `xorm:"rule_id notnull int pk autoincr"`                                    //
	Group       string `xorm:"group notnull varchar(25)" valid:"required,length(1|25),alphanum"`   //
	Name        string `xorm:"name notnull varchar(50)" valid:"required,length(1|50),alphanum"`    //
	Description string `xorm:"description notnull tinytext" valid:"required,runelength(1|255)"`    //
	Level       uint8  `xorm:"level notnull tinyint" valid:"required,matches(^(1|2|3)$)"`          //
	Operator    string `xorm:"operator notnull varchar(5)" valid:"required,length(1|10),alphanum"` //
	Values      string `xorm:"values notnull varchar(150)" valid:"required,length(1|150)"`         //
	Bitwise     uint8  `xorm:"bitwise notnull tinyint" valid:"required,uint8"`                     //
	Message     string `xorm:"message notnull varchar(150)" valid:"required,length(1|150)"`        //
	Version     int    `xorm:"version" json:"-"`                                                   //
	UpdateAt    uint   `xorm:"update_at notnull int" valid:"uint32"`                               //
	CreateAt    uint   `xorm:"create_at notnull int" valid:"required,uint32"`                      //
}

/*
update-without-limit-clause
delete-without-limit-clause
insert-without-explicit-columns
create-database-not-allowed
drop-database-not-allowed
invalid-table-charset
invalid-table-collation
invalid-table-name
invalid-column-charset
invalid-column-collation
invalid-column-name
too-many-indices-defined
too-many-columns-defined
too-many-columns-indexed
*/

func (this *Rules) TableName() string {
	return "mm_rules"
}

func (this *Rules) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Rules) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Rules) AfterSet(colName string, _ xorm.Cell) {
}
