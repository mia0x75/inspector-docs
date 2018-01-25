package models

type Taxonomy struct {
	TaxonomyId  uint   `gorm:"column:taxonomy_id;not null;type:int unsigned;primary_key;auto_increment"`
	Name        string `gorm:"column:name;not null;type:varchar(50);size:50"`
	Description string `gorm:"column:description;not null;type:varchar(75);size:75"`
}
