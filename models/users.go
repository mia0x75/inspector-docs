package models

import (
	"time"
)

type User struct {
	UserId       uint      `gorm:"column:user_id;not null;type:int unsigned;primary_key;AUTO_INCREMENT"`
	Login        string    `gorm:"column:login;not null;type:varchar(25);unique;size:25"`
	Password     string    `gorm:"column:password;not null;type:char(64);size:64"`
	Name         string    `gorm:"column:name;not null;type:varchar(25);size:25"`
	Email        string    `gorm:"column:email;not null;type:varchar(75);size:75"`
	Status       uint8     `gorm:"column:status;not null;type:tinyint unsigned"`
	Avator       string    `gorm:"column:avator;not null;type:varchar(75);size:75"`
	CreationDate time.Time `gorm:"column:creation_date;type:datetime;not null"`
}
