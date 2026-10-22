package repositories

import (
	"context"
	"fmt"
	"time"

	"backend/models"
	"backend/utils"

	"golang.org/x/crypto/bcrypt"
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
	if limit > 0 { query = query.Limit(limit) }
	if offset > 0 { query = query.Offset(offset) }
	if err := query.Find(&doctors).Error; err != nil {
		return nil, 0, fmt.Errorf("doctorRepository.FindAll: %w", err)
	}
	r.populateAvailability(ctx, doctors)
	return doctors, totalCount, nil
}

func (r *doctorRepository) buildFindAllQuery(ctx context.Context, search, filter, specialization string, polyclinicID uint) *gorm.DB {
	query := r.db.Model(&models.Doctor{}).Where("doctors.is_active = ?", true)
	if search != "" {
		query = query.Where("doctors.name LIKE ?", "%"+utils.EscapeLike(search)+"%")
	}
	if filter != "" {
		query = query.Joins("LEFT JOIN polyclinics ON polyclinics.id = doctors.polyclinic_id").Where("polyclinics.name LIKE ?", "%"+utils.EscapeLike(filter)+"%")
	}
	if specialization != "" {
		query = query.Where("specialization = ?", specialization)
	}
	if polyclinicID > 0 {
		query = query.Where("polyclinic_id = ?", polyclinicID)
	}
	return query
}

func (r *doctorRepository) isAvailableToday(doctorID uint) bool {
	var count int64
	curr := time.Now().Format("15:04")
	r.db.Model(&models.DoctorSchedule{}).
		Where("doctor_id = ? AND DATE(date) = CURDATE() AND is_available = ? AND start_time <= ? AND end_time >= ?", doctorID, true, curr, curr).
		Count(&count)
	return count > 0
}

func (r *doctorRepository) populateAvailability(ctx context.Context, doctors []models.Doctor) {
	for i, doc := range doctors {
		doctors[i].IsAvailableToday = r.isAvailableToday(doc.ID)
		if doc.Polyclinic != nil {
			doctors[i].PolyclinicName = doc.Polyclinic.Name
		}
	}
}

func (r *doctorRepository) FindByID(ctx context.Context, id uint) (*models.Doctor, error) {
	var doctor models.Doctor
	if err := r.db.Preload("Polyclinic").First(&doctor, id).Error; err != nil {
		return nil, fmt.Errorf("doctorRepository.FindByID: %w", err)
	}
	doctor.IsAvailableToday = r.isAvailableToday(doctor.ID)
	if doctor.Polyclinic != nil {
		doctor.PolyclinicName = doctor.Polyclinic.Name
	}
	return &doctor, nil
}

func (r *doctorRepository) Create(ctx context.Context, doctor *models.Doctor) error {
	if doctor.Email != "" {
		return r.db.Transaction(func(tx *gorm.DB) error {
			pwd := doctor.Password
			if pwd == "" {
				pwd = "Hermina123!"
			}
			hash, _ := bcrypt.GenerateFromPassword([]byte(pwd), bcrypt.DefaultCost)
			user := models.User{
				FullName:    doctor.Name,
				Email:       doctor.Email,
				PhoneNumber: doctor.ContactInfo,
				ImageURL:    doctor.ImageURL,
				Role:        "doctor",
				Password:    string(hash),
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
	doctor.Polyclinic = nil
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Omit("created_at").Save(doctor).Error; err != nil {
			return err
		}
		if doctor.UserID != nil && *doctor.UserID > 0 {
			u := map[string]interface{}{}
			if doctor.Name != "" { u["full_name"] = doctor.Name }
			if doctor.ImageURL != "" { u["image_url"] = doctor.ImageURL }
			if doctor.ContactInfo != "" { u["phone_number"] = doctor.ContactInfo }
			if len(u) > 0 {
				return tx.Model(&models.User{}).Where("id = ?", *doctor.UserID).Updates(u).Error
			}
		}
		return nil
	})
}

func (r *doctorRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Model(&models.Doctor{}).Where("id = ?", id).Update("is_active", false).Error
}
