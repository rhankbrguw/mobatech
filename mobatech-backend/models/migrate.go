package models

import "gorm.io/gorm"

func RunAutoMigrate(db *gorm.DB) error {
	return db.AutoMigrate(
		&User{},
		&FamilyMember{},
		&ChatSession{},
		&ChatMessage{},
		&HospitalService{},
		&EmergencyRequest{},
		&MedicineCategory{},
		&Medicine{},
		&Prescription{},
		&PrescriptionItem{},
		&PharmacyOrder{},
		&PharmacyOrderItem{},
		&Cart{},
		&CartItem{},
		&Doctor{},
		&DoctorSchedule{},
		&Appointment{},
		&Polyclinic{},
		&PolyclinicSchedule{},
		&MedicalResult{},
		&Reminder{},
		&Branch{},
		&Promo{},
	)
}
