package models

type Option struct {
	OptionId uint   `gorm:"column:option_id;not null;type:int unsigned;primary_key;AUTO_INCREMENT"`
	Name     string `gorm:"column:name;not null;type:varchar(50);size:50"`
	Value    string `gorm:"column:value;not null;type:tinytext;size:255"`
}
