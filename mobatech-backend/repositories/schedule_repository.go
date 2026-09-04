package repositories

import (
	"fmt"

	"context"

	"backend/models"
	"time"

	"gorm.io/gorm"
)

type ScheduleRepository interface {
	FindUpcomingSchedules(ctx context.Context, limit int, offset int) ([]models.DoctorSchedule, int64, error)
	FindByDoctorID(ctx context.Context, doctorID uint, fromDate time.Time) ([]models.DoctorSchedule, error)
	FindByID(ctx context.Context, id uint) (*models.DoctorSchedule, error)
	Create(ctx context.Context, schedule *models.DoctorSchedule) error
	Update(ctx context.Context, schedule *models.DoctorSchedule) error
	Delete(ctx context.Context, id uint) error
}

type scheduleRepository struct {
	db *gorm.DB
}

func NewScheduleRepository(db *gorm.DB) ScheduleRepository {
	return &scheduleRepository{db}
}

func (r *scheduleRepository) FindUpcomingSchedules(ctx context.Context, limit int, offset int) ([]models.DoctorSchedule, int64, error) {
	var schedules []models.DoctorSchedule
	var totalCount int64
	now := time.Now()
	today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	query := r.db.Model(&models.DoctorSchedule{}).
		Where("date >= ? AND is_available = ?", today, true)

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("scheduleRepository.FindUpcomingSchedules: %w", err)
	}

	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}

	err := query.Preload("Doctor").
		Order("date asc, start_time asc").
		Find(&schedules).Error
	if err != nil {
		return nil, 0, fmt.Errorf("scheduleRepository.FindUpcomingSchedules: %w", err)
	}
	return schedules, totalCount, nil
}

func (r *scheduleRepository) FindByDoctorID(ctx context.Context, doctorID uint, fromDate time.Time) ([]models.DoctorSchedule, error) {
	var schedules []models.DoctorSchedule
	err := r.db.Preload("Doctor").
		Where("doctor_id = ? AND date >= ? AND is_available = ?", doctorID, fromDate, true).
		Order("date asc, start_time asc").
		Find(&schedules).Error
	if err != nil {
		return nil, fmt.Errorf("scheduleRepository.FindByDoctorID: %w", err)
	}
	return schedules, nil
}

func (r *scheduleRepository) FindByID(ctx context.Context, id uint) (*models.DoctorSchedule, error) {
	var schedule models.DoctorSchedule
	err := r.db.Preload("Doctor").First(&schedule, id).Error
	if err != nil {
		return nil, fmt.Errorf("scheduleRepository.FindByID: %w", err)
	}
	return &schedule, nil
}

func (r *scheduleRepository) Create(ctx context.Context, schedule *models.DoctorSchedule) error {
	return r.db.Create(schedule).Error
}

func (r *scheduleRepository) Update(ctx context.Context, schedule *models.DoctorSchedule) error {
	return r.db.Omit("created_at").Save(schedule).Error
}

func (r *scheduleRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Model(&models.DoctorSchedule{}).Where("id = ?", id).Update("is_available", false).Error
}
