package repositories

import (
	"fmt"

	"context"

	"backend/models"

	"gorm.io/gorm"
)

type EmergencyRepository interface {
	Create(ctx context.Context, req *models.EmergencyRequest) error
	GetByID(ctx context.Context, id uint) (*models.EmergencyRequest, error)
	GetByUserID(ctx context.Context, userID uint) ([]models.EmergencyRequest, error)
	GetAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.EmergencyRequest, int64, error)
	UpdateStatus(ctx context.Context, id uint, status string) error
	UpdateTracking(ctx context.Context, id uint, ambulanceLat, ambulanceLng float64, estimatedMinutes int, status string) error
}

type emergencyRepository struct {
	db *gorm.DB
}

func NewEmergencyRepository(db *gorm.DB) EmergencyRepository {
	return &emergencyRepository{db}
}

func (r *emergencyRepository) Create(ctx context.Context, req *models.EmergencyRequest) error {
	return r.db.Create(req).Error
}

func (r *emergencyRepository) GetByID(ctx context.Context, id uint) (*models.EmergencyRequest, error) {
	var req models.EmergencyRequest
	if err := r.db.First(&req, id).Error; err != nil {
		return nil, fmt.Errorf("emergencyRepository.GetByID: %w", err)
	}
	return &req, nil
}

func (r *emergencyRepository) GetByUserID(ctx context.Context, userID uint) ([]models.EmergencyRequest, error) {
	var reqs []models.EmergencyRequest
	if err := r.db.Where("user_id = ?", userID).Order("created_at desc").Find(&reqs).Error; err != nil {
		return nil, fmt.Errorf("emergencyRepository.GetByUserID: %w", err)
	}
	return reqs, nil
}

func (r *emergencyRepository) GetAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.EmergencyRequest, int64, error) {
	var reqs []models.EmergencyRequest
	var totalCount int64
	query := r.db.Model(&models.EmergencyRequest{})

	if search != "" {
		searchTerm := "%" + search + "%"
		query = query.Where("patient_name LIKE ? OR location LIKE ?", searchTerm, searchTerm)
	}

	if filter != "" {
		query = query.Where("status = ?", filter)
	}

	err := query.Count(&totalCount).Error
	if err != nil {
		return nil, 0, fmt.Errorf("emergencyRepository.GetAll: %w", err)
	}

	if err = query.Order("created_at desc").Limit(limit).Offset(offset).Find(&reqs).Error; err != nil {
		return nil, 0, fmt.Errorf("emergencyRepository.GetAll: %w", err)
	}
	return reqs, totalCount, nil
}

func (r *emergencyRepository) UpdateStatus(ctx context.Context, id uint, status string) error {
	return r.db.Model(&models.EmergencyRequest{}).Where("id = ?", id).Update("status", status).Error
}

func (r *emergencyRepository) UpdateTracking(ctx context.Context, id uint, ambulanceLat, ambulanceLng float64, estimatedMinutes int, status string) error {
	return r.db.Model(&models.EmergencyRequest{}).Where("id = ?", id).Updates(map[string]interface{}{
		"ambulance_lat":     ambulanceLat,
		"ambulance_lng":     ambulanceLng,
		"estimated_minutes": estimatedMinutes,
		"status":            status,
	}).Error
}
