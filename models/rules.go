package models

type Rule struct {
	RuleId      uint   `gorm:"column:rule_id;not null;type:int unsigned;primary_key;AUTO_INCREMENT"`
	Name        string `gorm:"column:name;not null;type:varchar(50);size:50"`
	Description string `gorm:"column:description;not null;type:tinytext;size:255"`
	Valid       uint8  `gorm:"column:valid;not null;type:tinyint unsigned"`
	Mandatory   uint8  `gorm:"column:mandatory;not null;type:tinyint unsigned"`
}
