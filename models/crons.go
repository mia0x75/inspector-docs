package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Crons struct {
	CronId   uint   `xorm:"cron_id notnull int pk autoincr"`                                    //
	Status   string `xorm:"status notnull char(1)" valid:"required,matches(^(C|D|E|F|P|R|S)$)"` //
	Version  int    `xorm:"version" json:"-"`                                                   //
	UpdateAt uint   `xorm:"update_at notnull int" valid:"uint32"`                               //
	CreateAt uint   `xorm:"create_at notnull int" valid:"required,uint32"`                      //
}

func (this *Crons) TableName() string {
	return "mm_crons"
}

func (this *Crons) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Crons) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Crons) AfterSet(colName string, _ xorm.Cell) {
}
