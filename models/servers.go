package models

import (
	"time"
)

type Server struct {
	ServerId     uint      `gorm:"column:server_id;not null;type:int unsigned;primary_key;AUTO_INCREMENT"`
	Host         uint      `gorm:"column:host;not null;type:int unsigned;unique"`
	Port         uint16    `gorm:"column:port;not null;type:smallint unsigned"`
	User         string    `gorm:"column:user;not null;type:varchar(25);size:25"`
	Password     string    `gorm:"column:password;not null;type:varchar(75);size:75"`
	Status       uint8     `gorm:"column:status;not null;type:tinyint unsigned"`
	CreationDate time.Time `gorm:"column:creation_date;type:datetime;not null"`
}
