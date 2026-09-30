package main

import (
	"backend/config"
	"backend/seed"
	"log"
)

func main() {
	config.ConnectDatabase()
	if err := seed.SeedAll(config.DB); err != nil {
		log.Fatalf("Failed to seed database: %v", err)
	}
	log.Println("Database reset and seeded successfully!")
}
