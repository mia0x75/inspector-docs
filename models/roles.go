package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Roles struct {
	RoleId      uint   `xorm:"role_id notnull int pk autoincr"`                                             //
	Name        string `xorm:"name notnull varchar(50) unique(unique_1)" valid:"required,runelength(1|50)"` //
	Description string `xorm:"description notnull varchar(75)" valid:"required,runelength(1|75)"`           //
	Version     int    `xorm:"version" json:"-"`                                                            //
	UpdateAt    uint   `xorm:"update_at notnull int" valid:"uint32"`                                        //
	CreateAt    uint   `xorm:"create_at notnull int" valid:"required,uint32"`                               //
}

func (this *Roles) TableName() string {
	return "mm_roles"
}

func (this *Roles) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Roles) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Roles) AfterSet(colName string, _ xorm.Cell) {
}
