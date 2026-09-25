package seed

import (
	"backend/models"
	"fmt"
	"log"
	"time"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

func hashPwd(pwd string) (string, error) {
	b, err := bcrypt.GenerateFromPassword([]byte(pwd), bcrypt.DefaultCost)
	return string(b), err
}

func hashPasswords(passwords map[string]string) (map[string]string, error) {
	hashedMap := make(map[string]string)
	for k, v := range passwords {
		h, err := hashPwd(v)
		if err != nil {
			return nil, fmt.Errorf("seeder: failed to hash password for %s: %w", k, err)
		}
		hashedMap[k] = h
	}
	return hashedMap, nil
}

func seedUsers(db *gorm.DB, hashedMap map[string]string) (map[string]uint, error) {
	users := getDefaultUsers(hashedMap)
	userIDs := make(map[string]uint)
	for _, user := range users {
		var existing models.User
		if err := db.Where("email = ?", user.Email).First(&existing).Error; err != nil {
			if err := db.Create(&user).Error; err != nil {
				return nil, fmt.Errorf("seeder: failed to seed user %s: %w", user.Email, err)
			}
			userIDs[user.Role] = user.ID
		} else {
			userIDs[user.Role] = existing.ID
		}
	}
	return userIDs, nil
}

func seedPolyclinics(db *gorm.DB) map[string]uint {
	polyclinics := getDefaultPolyclinics()
	polyIDs := make(map[string]uint)
	for _, poly := range polyclinics {
		var existing models.Polyclinic
		if err := db.Where("name = ?", poly.Name).First(&existing).Error; err != nil {
			_ = db.Create(&poly)
			polyIDs[poly.Name] = poly.ID
		} else {
			polyIDs[poly.Name] = existing.ID
		}
	}
	return polyIDs
}

func seedDoctor(db *gorm.DB, docUserID uint, polyIDs map[string]uint) {
	var existingDoc models.Doctor
	if err := db.Where("user_id = ?", docUserID).First(&existingDoc).Error; err != nil {
		polyID := polyIDs["Poli Jantung & Pembuluh Darah"]
		doc := models.Doctor{
			UserID:         &docUserID,
			PolyclinicID:   &polyID,
			Name:           "dr. Tirta Mandira Hudhi, M.B.A.",
			Specialization: "Spesialis Penyakit Dalam & Konsultan Preventif",
			ContactInfo:    "087884478634",
			Description:    "Dokter spesialis berpengalaman dalam edukasi kesehatan dan penanganan klinis preventif.",
			IsActive:       true,
		}
		if err := db.Create(&doc).Error; err == nil {
			seedDoctorSchedules(db, doc.ID)
		}
	}
}

func seedDoctorSchedules(db *gorm.DB, doctorID uint) {
	now := time.Now()
	scheds := []models.DoctorSchedule{
		{DoctorID: doctorID, Date: now, StartTime: "09:00", EndTime: "14:00", Quota: 20, Booked: 0, IsAvailable: true},
		{DoctorID: doctorID, Date: now.AddDate(0, 0, 1), StartTime: "09:00", EndTime: "14:00", Quota: 20, Booked: 0, IsAvailable: true},
	}
	for _, s := range scheds {
		_ = db.Create(&s)
	}
}

func seedBranches(db *gorm.DB) {
	for _, branch := range getDefaultBranches() {
		var existing models.Branch
		if err := db.Where("name = ?", branch.Name).First(&existing).Error; err != nil {
			_ = db.Create(&branch)
		}
	}
}

func seedMedicines(db *gorm.DB) {
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
	assignMedicineCategories(db, meds, catIDs)
}

func SeedAll(db *gorm.DB) error {
	log.Println("Seeding initial database data...")

	passwords := map[string]string{
		"admin": "Sawali123", "dokter": "Tirta123",
		"apoteker": "Fahmi123", "pasien": "Fahri123",
	}
	hashedMap, err := hashPasswords(passwords)
	if err != nil {
		return err
	}
	userIDs, err := seedUsers(db, hashedMap)
	if err != nil {
		return err
	}
	polyIDs := seedPolyclinics(db)
	if docUserID, ok := userIDs["doctor"]; ok {
		seedDoctor(db, docUserID, polyIDs)
	}
	seedBranches(db)
	seedMedicines(db)

	log.Println("Seeding completed successfully!")
	return nil
}
