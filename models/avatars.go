package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Avatars struct {
	AvatarId uint   `xorm:"avatar_id notnull int pk autoincr"`                  //
	Url      string `xorm:"url notnull tinytext" valid:"required,length(1|75)"` //
	Version  int    `xorm:"version" json:"-"`                                   //
	UpdateAt uint   `xorm:"update_at notnull int" valid:"uint32"`               //
	CreateAt uint   `xorm:"create_at notnull int" valid:"required,uint32"`      //
}

func (this *Avatars) TableName() string {
	return "mm_avatars"
}

func (this *Avatars) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Avatars) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Avatars) AfterSet(colName string, _ xorm.Cell) {
}
