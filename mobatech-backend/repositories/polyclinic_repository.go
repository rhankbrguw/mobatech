package repositories

import (
	"fmt"

	"context"

	"backend/models"

	"gorm.io/gorm"
)

type PolyclinicRepository interface {
	FindAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Polyclinic, int64, error)
	FindByID(ctx context.Context, id uint) (*models.Polyclinic, error)
	Create(ctx context.Context, polyclinic *models.Polyclinic) error
	Update(ctx context.Context, polyclinic *models.Polyclinic) error
	Delete(ctx context.Context, id uint) error

	FindSchedulesByPolyclinic(ctx context.Context, polyclinicID uint) ([]models.PolyclinicSchedule, error)
	CreateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error
	UpdateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error
	DeleteSchedule(ctx context.Context, id uint) error
}

type polyclinicRepository struct {
	db *gorm.DB
}

func NewPolyclinicRepository(db *gorm.DB) PolyclinicRepository {
	return &polyclinicRepository{db}
}

func (r *polyclinicRepository) FindAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Polyclinic, int64, error) {
	var polyclinics []models.Polyclinic
	var totalCount int64
	query := r.db.Model(&models.Polyclinic{})

	if search != "" {
		searchTerm := "%" + search + "%"
		query = query.Where("name LIKE ?", searchTerm)
	}
	if filter == "active" {
		query = query.Where("is_active = ?", true)
	} else if filter == "inactive" {
		query = query.Where("is_active = ?", false)
	}

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("polyclinicRepository.FindAll: %w", err)
	}

	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}

	if err := query.Preload("Schedules").Preload("Doctors").Find(&polyclinics).Error; err != nil {
		return nil, 0, fmt.Errorf("polyclinicRepository.FindAll: %w", err)
	}
	return polyclinics, totalCount, nil
}

func (r *polyclinicRepository) FindByID(ctx context.Context, id uint) (*models.Polyclinic, error) {
	var polyclinic models.Polyclinic
	if err := r.db.Preload("Schedules").Preload("Doctors").First(&polyclinic, id).Error; err != nil {
		return nil, fmt.Errorf("polyclinicRepository.FindByID: %w", err)
	}
	return &polyclinic, nil
}

func (r *polyclinicRepository) Create(ctx context.Context, polyclinic *models.Polyclinic) error {
	return r.db.Create(polyclinic).Error
}

func (r *polyclinicRepository) Update(ctx context.Context, polyclinic *models.Polyclinic) error {
	return r.db.Omit("created_at").Save(polyclinic).Error
}

func (r *polyclinicRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Delete(&models.Polyclinic{}, id).Error
}

func (r *polyclinicRepository) FindSchedulesByPolyclinic(ctx context.Context, polyclinicID uint) ([]models.PolyclinicSchedule, error) {
	var schedules []models.PolyclinicSchedule
	if err := r.db.Where("polyclinic_id = ?", polyclinicID).Find(&schedules).Error; err != nil {
		return nil, fmt.Errorf("polyclinicRepository.FindSchedulesByPolyclinic: %w", err)
	}
	return schedules, nil
}

func (r *polyclinicRepository) CreateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error {
	return r.db.Create(schedule).Error
}

func (r *polyclinicRepository) UpdateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error {
	return r.db.Omit("created_at").Save(schedule).Error
}

func (r *polyclinicRepository) DeleteSchedule(ctx context.Context, id uint) error {
	return r.db.Delete(&models.PolyclinicSchedule{}, id).Error
}
