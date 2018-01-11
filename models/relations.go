package models

import (
	"time"
)

type Relation struct {
	RelationId   uint      `gorm:"column:relation_id;not null;type:int unsigned;primary_key;AUTO_INCREMENT"`
	TaxonomyId   uint      `gorm:"column:taxonomy_id;not null;type:int unsigned"`
	AncestorId   uint      `gorm:"column:ancestor_id;not null;type:int unsigned"`
	DescendantId uint      `gorm:"column:descendant_id;not null;type:int unsigned"`
	CreationDate time.Time `gorm:"column:creation_date;type:datetime;not null"`
}
