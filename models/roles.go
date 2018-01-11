package models

type Role struct {
	RoleId      uint   `gorm:"column:role_id;not null;type:int unsigned;primary_key;AUTO_INCREMENT"`
	Name        string `gorm:"column:name;not null;type:varchar(50);size:50"`
	Description string `gorm:"column:description;not null;type:varchar(75);size:75"`
}
