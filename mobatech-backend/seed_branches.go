package main

import (
	"fmt"
	"log"

	"backend/models"

	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

func SeedBranches() {
	dsn := "root:@tcp(127.0.0.1:3306)/mobatech?charset=utf8mb4&parseTime=True&loc=Local"
	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed to connect database: %v", err)
	}

	branches := []models.Branch{
		{Name: "Hermina Kemayoran", Address: "Jl. H. Benyamin Sueb Blok B3 No.10, Kemayoran, Jakarta Pusat", Latitude: -6.1558, Longitude: 106.8521, ImageURL: "https://placehold.co/400x400/1E5E44/FFFFFF/png?text=Hermina+Kemayoran", GmapsLink: "https://maps.app.goo.gl/Kemayoran"},
		{Name: "Hermina Jatinegara", Address: "Jl. Raya Jatinegara Barat No. 126, Jakarta Timur", Latitude: -6.2238, Longitude: 106.8681, ImageURL: "https://placehold.co/400x400/1E5E44/FFFFFF/png?text=Hermina+Jatinegara", GmapsLink: "https://maps.app.goo.gl/Jatinegara"},
		{Name: "Hermina Podomoro", Address: "Jl. Danau Sunter Barat Blok A3, Sunter, Jakarta Utara", Latitude: -6.1432, Longitude: 106.8643, ImageURL: "https://placehold.co/400x400/1E5E44/FFFFFF/png?text=Hermina+Podomoro", GmapsLink: "https://maps.app.goo.gl/Podomoro"},
		{Name: "Hermina Daan Mogot", Address: "Jl. Kintamani Raya No. 2, Kalideres, Jakarta Barat", Latitude: -6.1404, Longitude: 106.7088, ImageURL: "https://placehold.co/400x400/1E5E44/FFFFFF/png?text=Hermina+Daan+Mogot", GmapsLink: "https://maps.app.goo.gl/DaanMogot"},
		{Name: "Hermina Bekasi", Address: "Jl. Kemakmuran No. 39, Margajaya, Bekasi Selatan", Latitude: -6.2443, Longitude: 106.9944, ImageURL: "https://placehold.co/400x400/1E5E44/FFFFFF/png?text=Hermina+Bekasi", GmapsLink: "https://maps.app.goo.gl/Bekasi"},
	}

	for i := range branches {
		var existing models.Branch
		if err := db.Where("name = ?", branches[i].Name).First(&existing).Error; err != nil {
			db.Create(&branches[i])
		} else {
			db.Model(&existing).Updates(map[string]interface{}{
				"image_url":  branches[i].ImageURL,
				"gmaps_link": branches[i].GmapsLink,
			})
		}
	}

	fmt.Println("Branches seeded successfully.")
}
