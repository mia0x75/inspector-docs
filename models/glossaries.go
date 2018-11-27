package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Glossaries struct {
	Catalog     string `xorm:"catalog notnull varchar(25) pk" valid:"required,runelength(1|25)"`    //
	Iota        uint   `xorm:"iota notnull tinyint pk" valid:"required,uint8"`                      //
	Name        string `xorm:"name notnull varchar(50)" valid:"required,runelength(1|50)"`          //
	Description string `xorm:"description notnull varchar(100)" valid:"required,runelength(1|100)"` //
	Version     int    `xorm:"version" json:"-"`                                                    //
	UpdateAt    uint   `xorm:"update_at notnull int" valid:"uint32"`                                //
	CreateAt    uint   `xorm:"create_at notnull int" valid:"required,uint32"`                       //
}

func (this *Glossaries) TableName() string {
	return "mm_glossaries"
}

func (this *Glossaries) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Glossaries) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Glossaries) AfterSet(colName string, _ xorm.Cell) {
}
