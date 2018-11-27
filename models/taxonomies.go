package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Taxonomies struct {
	TaxonomyId  uint   `xorm:"taxonomy_id notnull int pk autoincr"`                                         //
	Name        string `xorm:"name notnull varchar(50) unique(unique_1)" valid:"required,runelength(1|50)"` //
	Description string `xorm:"description notnull varchar(75)" valid:"required,runelength(1|75)"`           //
	Version     int    `xorm:"version" json:"-"`                                                            //
	UpdateAt    uint   `xorm:"update_at notnull int" valid:"uint32"`                                        //
	CreateAt    uint   `xorm:"create_at notnull int" valid:"required,uint32"`                               //
}

/*
m-to-m:user-reviewer
m-to-m:user-role
m-to-m:user-instance
o-to-m:ticket-comment
o-to-m:comment-comment
*/

func (this *Taxonomies) TableName() string {
	return "mm_taxonomies"
}

func (this *Taxonomies) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Taxonomies) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Taxonomies) AfterSet(colName string, _ xorm.Cell) {
}
