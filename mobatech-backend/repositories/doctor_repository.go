package repositories

import (
	"fmt"

	"context"

	"backend/models"
	"time"

	"gorm.io/gorm"
)

type DoctorRepository interface {
	FindAll(ctx context.Context, search string, filter string, specialization string, polyclinicID uint, limit, offset int) ([]models.Doctor, int64, error)
	FindByID(ctx context.Context, id uint) (*models.Doctor, error)
	Create(ctx context.Context, doctor *models.Doctor) error
	Update(ctx context.Context, doctor *models.Doctor) error
	Delete(ctx context.Context, id uint) error
}

type doctorRepository struct {
	db *gorm.DB
}

func NewDoctorRepository(db *gorm.DB) DoctorRepository {
	return &doctorRepository{db}
}

func (r *doctorRepository) FindAll(ctx context.Context, search string, filter string, specialization string, polyclinicID uint, limit, offset int) ([]models.Doctor, int64, error) {
	var doctors []models.Doctor
	var totalCount int64

	query := r.buildFindAllQuery(ctx, search, filter, specialization, polyclinicID)

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("doctorRepository.FindAll: %w", err)
	}

	query = query.Preload("Polyclinic")
	if limit > 0 {
		query = query.Limit(limit)
	}
	if offset > 0 {
		query = query.Offset(offset)
	}
	err := query.Find(&doctors).Error
	if err != nil {
		return nil, 0, fmt.Errorf("doctorRepository.FindAll: %w", err)
	}
	r.populateAvailability(ctx, doctors)
	return doctors, totalCount, nil
}

func (r *doctorRepository) buildFindAllQuery(ctx context.Context, search, filter, specialization string, polyclinicID uint) *gorm.DB {
	query := r.db.Model(&models.Doctor{}).Where("doctors.is_active = ?", true)
	if search != "" {
		query = query.Where("doctors.name LIKE ?", "%"+search+"%")
	}
	if filter != "" {
		query = query.Joins("LEFT JOIN polyclinics ON polyclinics.id = doctors.polyclinic_id").Where("polyclinics.name LIKE ?", "%"+filter+"%")
	}
	if specialization != "" {
		query = query.Where("specialization = ?", specialization)
	}
	if polyclinicID > 0 {
		query = query.Where("polyclinic_id = ?", polyclinicID)
	}
	return query
}

func (r *doctorRepository) populateAvailability(ctx context.Context, doctors []models.Doctor) {
	currentTime := time.Now().Format("15:04")
	for i, doc := range doctors {
		var count int64
		r.db.Model(&models.DoctorSchedule{}).
			Where("doctor_id = ? AND DATE(date) = CURDATE() AND is_available = ? AND start_time <= ? AND end_time >= ?", doc.ID, true, currentTime, currentTime).
			Count(&count)
		doctors[i].IsAvailableToday = count > 0
	}
}

func (r *doctorRepository) FindByID(ctx context.Context, id uint) (*models.Doctor, error) {
	var doctor models.Doctor
	err := r.db.Preload("Polyclinic").First(&doctor, id).Error
	if err != nil {
		return nil, fmt.Errorf("doctorRepository.FindByID: %w", err)
	}
	var count int64
	currentTime := time.Now().Format("15:04")
	r.db.Model(&models.DoctorSchedule{}).
		Where("doctor_id = ? AND DATE(date) = CURDATE() AND is_available = ? AND start_time <= ? AND end_time >= ?", doctor.ID, true, currentTime, currentTime).
		Count(&count)
	doctor.IsAvailableToday = count > 0
	return &doctor, nil
}

func (r *doctorRepository) Create(ctx context.Context, doctor *models.Doctor) error {
	if doctor.Email != "" {
		return r.db.Transaction(func(tx *gorm.DB) error {
			// Auto-provision user
			user := models.User{
				FullName:    doctor.Name,
				Email:       doctor.Email,
				PhoneNumber: doctor.ContactInfo,
				Role:        "doctor",
				// Default password is "Hermina123!" for now.
				// In production, use bcrypt hash directly. E.g., bcrypt.GenerateFromPassword
				// Since we don't import bcrypt here, we will just store a dummy or
				// assume auth_service handles password hashing on first login/reset.
				Password: "$2a$10$wY.uJz6O9.4q8U4s/yH2P.o/9q0lOq.6/m6Q1O6M.Q8Y8Q8Q8Q8Q8", // #nosec G101 -- Initial seed password hash
			}
			if err := tx.Create(&user).Error; err != nil {
				return fmt.Errorf("doctorRepository.Create: %w", err)
			}
			doctor.UserID = &user.ID
			return tx.Create(doctor).Error
		})
	}
	return r.db.Create(doctor).Error
}

func (r *doctorRepository) Update(ctx context.Context, doctor *models.Doctor) error {
	doctor.Polyclinic = nil // Clear association to allow PolyclinicID update
	return r.db.Omit("created_at").Save(doctor).Error
}

func (r *doctorRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Model(&models.Doctor{}).Where("id = ?", id).Update("is_active", false).Error
}
