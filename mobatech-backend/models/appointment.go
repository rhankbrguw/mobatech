package models

import "gorm.io/gorm"

type Appointment struct {
	gorm.Model
	UserID           uint            `json:"user_id" gorm:"index"`
	User             *User           `json:"user,omitempty" gorm:"foreignKey:UserID"`
	DoctorID         uint            `json:"doctor_id" gorm:"index"`
	Doctor           *Doctor         `json:"doctor,omitempty" gorm:"foreignKey:DoctorID"`
	DoctorScheduleID uint            `json:"doctor_schedule_id" gorm:"index"`
	Schedule         *DoctorSchedule `json:"schedule,omitempty" gorm:"foreignKey:DoctorScheduleID"`
	Status             string          `json:"status" gorm:"default:'pending';index"` // pending, approved, cancelled, completed
	Notes              string          `json:"notes"`
	CancellationReason string          `json:"cancellation_reason,omitempty"`
	HasMedicalResult   bool            `json:"has_medical_result" gorm:"-"`
}
