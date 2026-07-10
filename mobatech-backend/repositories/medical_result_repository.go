package repositories

import (
	"fmt"

	"context"

	"backend/constants"
	"backend/models"

	"gorm.io/gorm"
)

type MedicalResultRepository interface {
	FindAll(ctx context.Context, search string, filter string, userID uint, role string, limit int, offset int) ([]models.MedicalResult, int64, error)
	FindByUserID(ctx context.Context, userID uint) ([]models.MedicalResult, error)
	FindByID(ctx context.Context, id uint) (*models.MedicalResult, error)
	Create(ctx context.Context, medicalResult *models.MedicalResult) error
	Update(ctx context.Context, medicalResult *models.MedicalResult) error
	Delete(ctx context.Context, id uint) error
}

type medicalResultRepository struct {
	db *gorm.DB
}

func NewMedicalResultRepository(db *gorm.DB) MedicalResultRepository {
	return &medicalResultRepository{db}
}

func (r *medicalResultRepository) applyFilters(query *gorm.DB, search, filter, role string, userID uint) *gorm.DB {
	if role == constants.RoleDoctor {
		query = query.Where("medical_results.appointment_id IN (SELECT id FROM appointments WHERE doctor_id = (SELECT id FROM doctors WHERE user_id = ? LIMIT 1))", userID)
	}
	if search != "" {
		t := "%" + search + "%"
		query = query.Where("medical_results.test_name LIKE ? OR users.full_name LIKE ? OR medical_results.notes LIKE ?", t, t, t)
	}
	if filter == "newest" {
		return query.Order("medical_results.result_date desc")
	} else if filter == "oldest" {
		return query.Order("medical_results.result_date asc")
	}
	return query.Order("medical_results.created_at desc")
}

func (r *medicalResultRepository) FindAll(ctx context.Context, search string, filter string, userID uint, role string, limit int, offset int) ([]models.MedicalResult, int64, error) {
	var results []models.MedicalResult
	var count int64
	query := r.db.Model(&models.MedicalResult{}).Joins("LEFT JOIN users ON users.id = medical_results.user_id")

	query = r.applyFilters(query, search, filter, role, userID)

	if err := query.Count(&count).Error; err != nil {
		return nil, 0, fmt.Errorf("medicalResultRepository.FindAll: %w", err)
	}

	if err := query.Preload("Appointment").Limit(limit).Offset(offset).Find(&results).Error; err != nil {
		return nil, 0, fmt.Errorf("medicalResultRepository.FindAll: %w", err)
	}
	return results, count, nil
}

func (r *medicalResultRepository) FindByUserID(ctx context.Context, userID uint) ([]models.MedicalResult, error) {
	var results []models.MedicalResult
	if err := r.db.Where("user_id = ?", userID).Order("created_at desc").Find(&results).Error; err != nil {
		return nil, fmt.Errorf("medicalResultRepository.FindByUserID: %w", err)
	}
	return results, nil
}

func (r *medicalResultRepository) FindByID(ctx context.Context, id uint) (*models.MedicalResult, error) {
	var result models.MedicalResult
	err := r.db.First(&result, id).Error
	if err != nil {
		return nil, fmt.Errorf("medicalResultRepository.FindByID: %w", err)
	}
	return &result, nil
}

func (r *medicalResultRepository) Create(ctx context.Context, medicalResult *models.MedicalResult) error {
	return r.db.Create(medicalResult).Error
}

func (r *medicalResultRepository) Update(ctx context.Context, medicalResult *models.MedicalResult) error {
	return r.db.Omit("created_at").Save(medicalResult).Error
}

func (r *medicalResultRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Delete(&models.MedicalResult{}, id).Error
}
