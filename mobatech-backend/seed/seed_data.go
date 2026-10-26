package seed

import (
	"backend/constants"
	"backend/models"

	"gorm.io/gorm"
)

func getDefaultUsers(passwords map[string]string) []models.User {
	return []models.User{
		{
			FullName:    "Sawali Wahyu",
			Email:       "sawaliwahyu@herminahospitals.com",
			PhoneNumber: "083878005536",
			Password:    passwords["admin"],
			Role:        constants.RoleAdmin,
		},
		{
			FullName:    "dr. Tirta Mandira Hudhi, M.B.A.",
			Email:       "doktertirta@herminahospitals.com",
			PhoneNumber: "087884478634",
			Password:    passwords["dokter"],
			Role:        constants.RoleDoctor,
		},
		{
			FullName:    "Fahmi Prisma Putra Dani, S.Farm",
			Email:       "apotekerfahmi@herminahospitals.com",
			PhoneNumber: "081234567892",
			Password:    passwords["apoteker"],
			Role:        constants.RolePharmacist,
		},
		{
			FullName:    "Fahri Arkan",
			Email:       "fahrizulfadli@gmail.com",
			PhoneNumber: "081234567893",
			Password:    passwords["pasien"],
			Role:        constants.RolePatient,
			BloodType:   "O",
			Height:      168,
			Weight:      70,
		},
	}
}

func getDefaultPolyclinics() []models.Polyclinic {
	return []models.Polyclinic{
		{Name: "Poli Jantung & Pembuluh Darah", Description: "Layanan spesialis jantung, EKG, dan konsultasi kardiovaskular.", IsActive: true},
		{Name: "Poli Anak (Pediatri)", Description: "Layanan kesehatan bayi, anak, dan imunisasi berkala.", IsActive: true},
		{Name: "Poli Penyakit Dalam", Description: "Diagnosis dan perawatan penyakit organ dalam komprehensif.", IsActive: true},
		{Name: "Poli Gigi & Mulut", Description: "Perawatan gigi umum, scaling, ortodonti, dan bedah mulut.", IsActive: true},
	}
}

func getDefaultBranches() []models.Branch {
	return []models.Branch{
		{Name: "RS Hermina Kemayoran", Address: "Jl. Selangit B-10 Kav. 4, Kemayoran, Jakarta Pusat", Latitude: -6.1554, Longitude: 106.8488, GmapsLink: "https://maps.app.goo.gl/hermina-kemayoran"},
		{Name: "RS Hermina Jatinegara", Address: "Jl. Raya Jatinegara Barat No. 126, Jakarta Timur", Latitude: -6.2163, Longitude: 106.8654, GmapsLink: "https://maps.app.goo.gl/hermina-jatinegara"},
		{Name: "RS Hermina Depok", Address: "Jl. Siliwangi No. 50, Pancoran Mas, Depok", Latitude: -6.4025, Longitude: 106.8288, GmapsLink: "https://maps.app.goo.gl/hermina-depok"},
	}
}

func getDefaultMedicines() ([]models.MedicineCategory, []models.Medicine) {
	cats := []models.MedicineCategory{
		{Name: "Analgesik & Antipiretik", Description: "Obat pereda nyeri dan penurun panas."},
		{Name: "Antibiotik", Description: "Obat untuk mengatasi infeksi bakteri."},
		{Name: "Vitamin & Suplemen", Description: "Suplemen pendukung daya tahan tubuh."},
	}
	meds := []models.Medicine{
		{Name: "Paracetamol 500mg", GenericName: "Paracetamol", Price: 15000, Stock: 100, RequiresPrescription: false, Description: "Meredakan demam dan nyeri ringan."},
		{Name: "Amoxicillin 500mg", GenericName: "Amoxicillin", Price: 35000, Stock: 50, RequiresPrescription: true, Description: "Antibiotik untuk infeksi bakteri."},
		{Name: "Vitamin C 1000mg", GenericName: "Ascorbic Acid", Price: 45000, Stock: 80, RequiresPrescription: false, Description: "Menjaga daya tahan tubuh."},
	}
	return cats, meds
}

func assignMedicineCategories(db *gorm.DB, meds []models.Medicine, catIDs map[string]uint) {
	categoryMap := []string{"Analgesik & Antipiretik", "Antibiotik", "Vitamin & Suplemen"}
	for i, med := range meds {
		var existing models.Medicine
		if err := db.Where("name = ?", med.Name).First(&existing).Error; err != nil {
			catIdx := i
			if catIdx >= len(categoryMap) {
				catIdx = len(categoryMap) - 1
			}
			med.CategoryID = catIDs[categoryMap[catIdx]]
			_ = db.Create(&med)
		}
	}
}
