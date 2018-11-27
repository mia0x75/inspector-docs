package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Comments struct {
	CommentId uint   `xorm:"comment_id notnull int pk autoincr"`                      //
	Content   string `xorm:"content notnull tinytext" valid:"required,length(1|255)"` //
	Version   int    `xorm:"version" json:"-"`                                        //
	UpdateAt  uint   `xorm:"update_at notnull int" valid:"uint32"`                    //
	CreateAt  uint   `xorm:"create_at notnull int" valid:"required,uint32"`           //
}

func (this *Comments) TableName() string {
	return "mm_comments"
}

func (this *Comments) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Comments) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Comments) AfterSet(colName string, _ xorm.Cell) {
}
