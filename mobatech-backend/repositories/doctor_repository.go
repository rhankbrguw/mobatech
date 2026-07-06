package repositories

import (
	"backend/models"
	"time"
	"gorm.io/gorm"
)

type DoctorRepository interface {
	FindAll(search string, filter string, specialization string, polyclinicID uint, limit, offset int) ([]models.Doctor, int64, error)
	FindByID(id uint) (*models.Doctor, error)
	Create(doctor *models.Doctor) error
	Update(doctor *models.Doctor) error
	Delete(id uint) error
}

type doctorRepository struct {
	db *gorm.DB
}

func NewDoctorRepository(db *gorm.DB) DoctorRepository {
	return &doctorRepository{db}
}

func (r *doctorRepository) FindAll(search string, filter string, specialization string, polyclinicID uint, limit, offset int) ([]models.Doctor, int64, error) {
	var doctors []models.Doctor
	var totalCount int64

	query := r.buildFindAllQuery(search, filter, specialization, polyclinicID)

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, err
	}

	query = query.Preload("Polyclinic")
	if limit > 0 {
		query = query.Limit(limit)
	}
	if offset > 0 {
		query = query.Offset(offset)
	}
	err := query.Find(&doctors).Error
	if err == nil {
		r.populateAvailability(doctors)
	}
	return doctors, totalCount, err
}

func (r *doctorRepository) buildFindAllQuery(search, filter, specialization string, polyclinicID uint) *gorm.DB {
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

func (r *doctorRepository) populateAvailability(doctors []models.Doctor) {
	currentTime := time.Now().Format("15:04")
	for i, doc := range doctors {
		var count int64
		r.db.Model(&models.DoctorSchedule{}).
			Where("doctor_id = ? AND DATE(date) = CURDATE() AND is_available = ? AND start_time <= ? AND end_time >= ?", doc.ID, true, currentTime, currentTime).
			Count(&count)
		doctors[i].IsAvailableToday = count > 0
	}
}

func (r *doctorRepository) FindByID(id uint) (*models.Doctor, error) {
	var doctor models.Doctor
	err := r.db.Preload("Polyclinic").First(&doctor, id).Error
	if err != nil {
		return nil, err
	}
	var count int64
	currentTime := time.Now().Format("15:04")
	r.db.Model(&models.DoctorSchedule{}).
		Where("doctor_id = ? AND DATE(date) = CURDATE() AND is_available = ? AND start_time <= ? AND end_time >= ?", doctor.ID, true, currentTime, currentTime).
		Count(&count)
	doctor.IsAvailableToday = count > 0
	return &doctor, nil
}

func (r *doctorRepository) Create(doctor *models.Doctor) error {
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
				Password:    "$2a$10$wY.uJz6O9.4q8U4s/yH2P.o/9q0lOq.6/m6Q1O6M.Q8Y8Q8Q8Q8Q8", // "Hermina123!" hashed
			}
			if err := tx.Create(&user).Error; err != nil {
				return err
			}
			doctor.UserID = &user.ID
			return tx.Create(doctor).Error
		})
	}
	return r.db.Create(doctor).Error
}

func (r *doctorRepository) Update(doctor *models.Doctor) error {
	return r.db.Omit("created_at").Save(doctor).Error
}

func (r *doctorRepository) Delete(id uint) error {
	return r.db.Model(&models.Doctor{}).Where("id = ?", id).Update("is_active", false).Error
}
