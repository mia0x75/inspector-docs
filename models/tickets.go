package models

import (
	"time"
)

type Ticket struct {
	TicketId     uint      `gorm:"column:ticket_id;not null;type:int unsigned;primary_key;auto_increment"`
	MasterId     uint      `gorm:"column:master_id;not null;type:int unsigned"`
	Subject      string    `gorm:"column:subject;not null;type:varchar(50);size:50"`
	Content      string    `gorm:"column:content;not null;type:text;size:65535"`
	UserId       uint      `gorm:"column:user_id;not null;type:int unsigned"`
	ReviewerId   uint      `gorm:"column:reviewer_id;not null;type:int unsigned"`
	Status       uint8     `gorm:"column:status;not null;type:int unsigned"`
	CreationDate time.Time `gorm:"column:creation_date;type:datetime;not null"`
}
