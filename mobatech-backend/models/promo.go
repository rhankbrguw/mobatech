package models
import "gorm.io/gorm"
type Promo struct {
	gorm.Model
	Title      string `json:"title"`
	Subtitle   string `json:"subtitle"`
	ThemeColor string `json:"themeColor"`
	IsActive   bool   `json:"is_active" gorm:"default:true"`
}
