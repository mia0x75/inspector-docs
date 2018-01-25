package models

import (
	"time"
)

type Slave struct {
	SlaveId      uint      `gorm:"column:slave_id;not null;type:int unsigned;primary_key;auto_increment"`
	MasterId     uint      `gorm:"column:master_id;not null;type:int unsigned"`
	Host         uint      `gorm:"column:host;not null;type:int unsigned;unique"`
	Port         uint16    `gorm:"column:port;not null;type:smallint unsigned"`
	User         string    `gorm:"column:user;not null;type:varbinary(48);size:48"`
	Password     string    `gorm:"column:password;not null;type:varbinary(48);size:48"`
	Status       uint8     `gorm:"column:status;not null;type:tinyint unsigned"`
	CreationDate time.Time `gorm:"column:creation_date;type:datetime;not null"`
}
