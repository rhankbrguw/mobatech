package repositories

import (
	"fmt"

	"context"

	"backend/models"
	"backend/utils"

	"gorm.io/gorm"
)

type HospitalServiceRepository interface {
	GetAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.HospitalService, int64, error)
	GetByID(ctx context.Context, id uint) (*models.HospitalService, error)
	Create(ctx context.Context, service *models.HospitalService) error
	Update(ctx context.Context, service *models.HospitalService) error
	Delete(ctx context.Context, id uint) error
}

type hospitalServiceRepository struct {
	db *gorm.DB
}

func NewHospitalServiceRepository(db *gorm.DB) HospitalServiceRepository {
	return &hospitalServiceRepository{db}
}

func (r *hospitalServiceRepository) GetAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.HospitalService, int64, error) {
	var services []models.HospitalService
	var totalCount int64
	query := r.db.Model(&models.HospitalService{})
	if search != "" {
		searchTerm := "%" + utils.EscapeLike(search) + "%"
		query = query.Where("name LIKE ? OR address LIKE ?", searchTerm, searchTerm)
	}
	if filter == "az" {
		query = query.Order("name asc")
	} else if filter == "za" {
		query = query.Order("name desc")
	}

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("hospitalServiceRepository.GetAll: %w", err)
	}

	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}

	if err := query.Find(&services).Error; err != nil {
		return nil, 0, fmt.Errorf("hospitalServiceRepository.GetAll: %w", err)
	}
	return services, totalCount, nil
}

func (r *hospitalServiceRepository) GetByID(ctx context.Context, id uint) (*models.HospitalService, error) {
	var service models.HospitalService
	if err := r.db.First(&service, id).Error; err != nil {
		return nil, fmt.Errorf("hospitalServiceRepository.GetByID: %w", err)
	}
	return &service, nil
}

func (r *hospitalServiceRepository) Create(ctx context.Context, service *models.HospitalService) error {
	return r.db.Create(service).Error
}

func (r *hospitalServiceRepository) Update(ctx context.Context, service *models.HospitalService) error {
	return r.db.Omit("created_at").Save(service).Error
}

func (r *hospitalServiceRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Delete(&models.HospitalService{}, id).Error
}
