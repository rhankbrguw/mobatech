package models

import "gorm.io/gorm"

type Branch struct {
	gorm.Model
	Name      string  `json:"name"`
	Address   string  `json:"address"`
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
	ImageURL  string  `json:"image_url"`
	GmapsLink string  `json:"gmaps_link"`
}
