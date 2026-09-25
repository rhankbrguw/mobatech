package models

import "gorm.io/gorm"

type Notification struct {
	gorm.Model
	UserID    *uint  `json:"user_id,omitempty" gorm:"index:idx_notif_user_read"`
	Role      string `json:"role" gorm:"default:'all';index:idx_notif_role"`
	Title     string `json:"title"`
	Message   string `json:"message" gorm:"type:text"`
	Type      string `json:"type" gorm:"default:'general'"`
	ActionURL string `json:"action_url"`
	IsRead    bool   `json:"is_read" gorm:"default:false;index:idx_notif_user_read"`
}
