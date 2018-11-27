package models

import (
	"time"

	"github.com/go-xorm/xorm"
)

//varchar(25) notnull unique 'usr_name'
type Users struct {
	UserId   uint   `xorm:"user_id notnull int pk autoincr"`                                                //
	Email    string `xorm:"email notnull varchar(75) unique(unique_1)" valid:"required,email,length(3|75)"` //
	Password string `xorm:"password notnull char(60)" valid:"required" json:"-"`                            //
	Status   uint8  `xorm:"status notnull tinyint" valid:"required,matches(^(0|1)$)"`                       // 0 - 禁用 | 1 - 有效
	Name     string `xorm:"name notnull varchar(25)" valid:"required,runelength(1|25)"`                     //
	AvatarId string `xorm:"avatar_id notnull int" valid:"required,uint32"`                                  //
	Version  int    `xorm:"version" json:"-"`                                                               //
	UpdateAt uint   `xorm:"update_at notnull int" valid:"uint32"`                                           //
	CreateAt uint   `xorm:"create_at notnull int" valid:"required,uint32"`                                  //
}

func (this *Users) TableName() string {
	return "mm_users"
}

func (this *Users) BeforeInsert() {
	this.CreateAt = uint(time.Now().Unix())
}

func (this *Users) BeforeUpdate() {
	this.UpdateAt = uint(time.Now().Unix())
}

func (this *Users) AfterSet(colName string, _ xorm.Cell) {
	switch colName {
	case "created_unix":
		// this.Created = time.Unix(this.CreatedUnix, 0).Local()
	case "updated_unix":
		// this.Updated = time.Unix(this.UpdatedUnix, 0).Local()
	}
}

func (this *Users) GetTickets() {

}

func (this *Users) GetMasters() {

}

func (this *Users) GetReviewers() {

}
