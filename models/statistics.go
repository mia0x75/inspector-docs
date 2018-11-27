package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Statistics struct {
	StatId   uint   `xorm:"stat_id notnull int pk autoincr"`                                                  //
	Name     string `xorm:"name notnull varchar(50) unique(unique_1)" valid:"required,length(1|50),alphanum"` //
	Value    string `xorm:"value notnull tinytext" valid:"required,length(1|255),ascii"`                      //
	Version  int    `xorm:"version" json:"-"`                                                                 //
	UpdateAt uint   `xorm:"update_at notnull int" valid:"uint32"`                                             //
	CreateAt uint   `xorm:"create_at notnull int" valid:"required,uint32"`                                    //
}

func (this *Statistics) TableName() string {
	return "mm_statistics"
}

func (this *Statistics) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Statistics) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Statistics) AfterSet(colName string, _ xorm.Cell) {
}
