package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Relations struct {
	RelationId   uint   `xorm:"relation_id notnull int pk autoincr"`                                //
	TaxonomyId   uint   `xorm:"taxonomy_id notnull int unique(unique_1)" valid:"required,uint32"`   //
	AncestorId   uint   `xorm:"ancestor_id notnull int unique(unique_1)" valid:"required,uint32"`   //
	DescendantId uint   `xorm:"descendant_id notnull int unique(unique_1)" valid:"required,uint32"` //
	Description  string `xorm:"description notnull varchar(75)" valid:"required，runelength(1|75)"`  // 默认 冗余 Taxonomy.Name
	Version      int    `xorm:"version" json:"-"`                                                   //
	UpdateAt     uint   `xorm:"update_at notnull int" valid:"uint32"`                               //
	CreateAt     uint   `xorm:"create_at notnull int" valid:"required,uint32"`                      //
}

func (this *Relations) TableName() string {
	return "mm_relations"
}

func (this *Relations) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Relations) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Relations) AfterSet(colName string, _ xorm.Cell) {
}
