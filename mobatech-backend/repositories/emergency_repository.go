package repositories

import (
	"backend/models"

	"gorm.io/gorm"
)

type EmergencyRepository interface {
	Create(req *models.EmergencyRequest) error
	GetByID(id uint) (*models.EmergencyRequest, error)
	GetByUserID(userID uint) ([]models.EmergencyRequest, error)
	GetAll(search string, filter string, limit int, offset int) ([]models.EmergencyRequest, int64, error)
	UpdateStatus(id uint, status string) error
	UpdateTracking(id uint, ambulanceLat, ambulanceLng float64, estimatedMinutes int, status string) error
}

type emergencyRepository struct {
	db *gorm.DB
}

func NewEmergencyRepository(db *gorm.DB) EmergencyRepository {
	return &emergencyRepository{db}
}

func (r *emergencyRepository) Create(req *models.EmergencyRequest) error {
	return r.db.Create(req).Error
}

func (r *emergencyRepository) GetByID(id uint) (*models.EmergencyRequest, error) {
	var req models.EmergencyRequest
	err := r.db.First(&req, id).Error
	return &req, err
}

func (r *emergencyRepository) GetByUserID(userID uint) ([]models.EmergencyRequest, error) {
	var reqs []models.EmergencyRequest
	err := r.db.Where("user_id = ?", userID).Order("created_at desc").Find(&reqs).Error
	return reqs, err
}

func (r *emergencyRepository) GetAll(search string, filter string, limit int, offset int) ([]models.EmergencyRequest, int64, error) {
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
		return nil, 0, err
	}

	err = query.Order("created_at desc").Limit(limit).Offset(offset).Find(&reqs).Error
	return reqs, totalCount, err
}

func (r *emergencyRepository) UpdateStatus(id uint, status string) error {
	return r.db.Model(&models.EmergencyRequest{}).Where("id = ?", id).Update("status", status).Error
}

func (r *emergencyRepository) UpdateTracking(id uint, ambulanceLat, ambulanceLng float64, estimatedMinutes int, status string) error {
	return r.db.Model(&models.EmergencyRequest{}).Where("id = ?", id).Updates(map[string]interface{}{
		"ambulance_lat":     ambulanceLat,
		"ambulance_lng":     ambulanceLng,
		"estimated_minutes": estimatedMinutes,
		"status":            status,
	}).Error
}
