package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

type Tickets struct {
	TicketId   uint   `xorm:"ticket_id notnull int pk autoincr"`                             //
	Subject    string `xorm:"subject notnull varchar(50)" valid:"required,runelength(1|50)"` //
	Content    string `xorm:"content notnull text" valid:"required,runelength(1|65535)"`     //
	Status     uint8  `xorm:"status notnull int" valid:"required,matches(^([1-9]?[0-9])$)"`  // 状态 0-99
	OwnerId    uint   `xorm:"owner_id notnull int" valid:"required,uint32"`                  //
	InstanceId uint   `xorm:"instance_id notnull int" valid:"required,uint32"`               //
	ReviewerId uint   `xorm:"reviewer_id notnull int" valid:"required,uint32"`               //
	Version    int    `xorm:"version" json:"-"`                                              //
	UpdateAt   uint   `xorm:"update_at notnull int" valid:"uint32"`                          //
	CreateAt   uint   `xorm:"create_at notnull int" valid:"required,uint32"`                 //
}

func (this *Tickets) TableName() string {
	return "mm_tickets"
}

func (this *Tickets) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Tickets) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Tickets) AfterSet(colName string, _ xorm.Cell) {
}
