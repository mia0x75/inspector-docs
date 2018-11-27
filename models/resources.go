package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Resources struct {
	ResourceId uint   `xorm:"resource_id notnull int pk autoincr"`                                                                   //
	UrlPattern string `xorm:"url_pattern notnull varchar(100) unique(unique_1)" valid:"required,length(1|100)"`                      //
	Method     string `xorm:"method notnull varchar(10) unique(unique_1)" valid:"required,matches(^(:?GET|POST|DELETE|PUT|PATCH)$)"` //
	Version    int    `xorm:"version" json:"-"`                                                                                      //
	UpdateAt   uint   `xorm:"update_at notnull int" valid:"uint32"`                                                                  //
	CreateAt   uint   `xorm:"create_at notnull int" valid:"required,uint32"`                                                         //
}

func (this *Resources) TableName() string {
	return "mm_resources"
}

func (this *Resources) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Resources) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Resources) AfterSet(colName string, _ xorm.Cell) {
}
