package controllers

import (
	"backend/models"
	"gorm.io/gorm"
)

func buildBranchQuery(db *gorm.DB, search, filter string) *gorm.DB {
	query := db.Model(&models.Branch{})
	if search != "" {
		searchTerm := "%" + search + "%"
		query = query.Where("name LIKE ? OR address LIKE ?", searchTerm, searchTerm)
	}

	if filter == "za" {
		query = query.Order("name DESC")
	} else if filter == "az" {
		query = query.Order("name ASC")
	} else {
		query = query.Order("id DESC")
	}
	return query
}
