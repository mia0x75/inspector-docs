package models

import (
	"time"
)

type User struct {
	UserId       uint      `gorm:"column:user_id;not null;type:int unsigned;primary_key;auto_increment" valid:"required"`
	Login        string    `gorm:"column:login;not null;type:varchar(25);unique;size:25" valid:"required,length(3|25),alpha"`
	Password     []byte    `gorm:"column:password;not null;type:binary(48);size:48" valid:"required"` // SHA384
	Name         string    `gorm:"column:name;not null;type:varchar(25);size:25" valid:"required"`
	Email        string    `gorm:"column:email;not null;type:varchar(75);size:75" valid:"required,email"`
	Status       uint8     `gorm:"column:status;not null;type:tinyint unsigned" valid:"required"`
	Avator       string    `gorm:"column:avator;not null;type:varchar(75);size:75" valid:"required"`
	CreationDate time.Time `gorm:"column:creation_date;type:datetime;not null" valid:"required"`

	Tickets        []Ticket `gorm:"ForeignKey:user_id;AssociationForeignKey:user_id"`
	PendingTickets []Ticket `gorm:"ForeignKey:user_id;AssociationForeignKey:reviewer_id"`
}
