package seed

import (
	"backend/models"
	"fmt"
	"log"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func SeedAll(db *gorm.DB) error {
	log.Println("Seeding initial database data...")

	hashedPassword, err := bcrypt.GenerateFromPassword([]byte("Password123"), bcrypt.DefaultCost)
	if err != nil {
		return fmt.Errorf("seeder: failed to hash password: %w", err)
	}

	users := getDefaultUsers(string(hashedPassword))
	for _, user := range users {
		var existing models.User
		if err := db.Where("email = ?", user.Email).First(&existing).Error; err != nil {
			if err := db.Create(&user).Error; err != nil {
				return fmt.Errorf("seeder: failed to seed user %s: %w", user.Email, err)
			}
		}
	}

	polyclinics := getDefaultPolyclinics()
	for _, poly := range polyclinics {
		var existing models.Polyclinic
		if err := db.Where("name = ?", poly.Name).First(&existing).Error; err != nil {
			_ = db.Create(&poly)
		}
	}

	branches := getDefaultBranches()
	for _, branch := range branches {
		var existing models.Branch
		if err := db.Where("name = ?", branch.Name).First(&existing).Error; err != nil {
			_ = db.Create(&branch)
		}
	}

	cats, meds := getDefaultMedicines()
	catIDs := make(map[string]uint)
	for _, cat := range cats {
		var existing models.MedicineCategory
		if err := db.Where("name = ?", cat.Name).First(&existing).Error; err != nil {
			_ = db.Create(&cat)
			catIDs[cat.Name] = cat.ID
		} else {
			catIDs[cat.Name] = existing.ID
		}
	}
	for i, med := range meds {
		var existing models.Medicine
		if err := db.Where("name = ?", med.Name).First(&existing).Error; err != nil {
			if i == 0 {
				med.CategoryID = catIDs["Analgesik & Antipiretik"]
			} else if i == 1 {
				med.CategoryID = catIDs["Antibiotik"]
			} else {
				med.CategoryID = catIDs["Vitamin & Suplemen"]
			}
			_ = db.Create(&med)
		}
	}

	log.Println("Seeding completed successfully!")
	return nil
}
