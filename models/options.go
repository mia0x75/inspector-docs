package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Options struct {
	OptionId    uint   `xorm:"option_id notnull int pk autoincr"`                                      //
	Name        string `xorm:"name notnull varchar(50) unique" valid:"required,length(1|50),alphanum"` //
	Value       string `xorm:"value notnull tinytext" valid:"required,length(1|255),ascii"`            //
	Description string `xorm:"description notnull varchar(75)" valid:"required,runelength(1|75)"`      //
	Version     int    `xorm:"version" json:"-"`                                                       //
	UpdateAt    uint   `xorm:"update_at notnull int" valid:"uint32"`                                   //
	CreateAt    uint   `xorm:"create_at notnull int" valid:"required,uint32"`                          //
}

func (this *Options) TableName() string {
	return "mm_options"
}

func (this *Options) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Options) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Options) AfterSet(colName string, _ xorm.Cell) {
}
