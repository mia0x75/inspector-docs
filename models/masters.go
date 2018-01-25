package models

import (
	"time"
)

type Master struct {
	MasterId     uint      `gorm:"column:master_id;not null;type:int unsigned;primary_key;auto_increment"`
	Host         uint      `gorm:"column:host;not null;type:int unsigned;unique"`
	Port         uint16    `gorm:"column:port;not null;type:smallint unsigned"`
	User         []byte    `gorm:"column:user;not null;type:varbinary(48);size:48"`
	Password     []byte    `gorm:"column:password;not null;type:varbinary(48);size:48"`
	Status       uint8     `gorm:"column:status;not null;type:tinyint unsigned"`
	CreationDate time.Time `gorm:"column:creation_date;type:datetime;not null"`
	Slaves       []Slave   `gorm:"ForeignKey:master_id;AssociationForeignKey:master_id"`
}
