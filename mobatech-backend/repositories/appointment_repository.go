package repositories

import (
	"fmt"

	"context"

	"backend/models"

	"gorm.io/gorm"
)

type AppointmentRepository interface {
	FindAll(ctx context.Context, search string, filter string, userID uint, role string, limit, offset int) ([]models.Appointment, int64, error)
	FindByUserID(ctx context.Context, userID uint, limit, offset int) ([]models.Appointment, int64, error)
	FindByID(ctx context.Context, id uint) (*models.Appointment, error)
	Create(ctx context.Context, appointment *models.Appointment) error
	Update(ctx context.Context, appointment *models.Appointment) error
}

type appointmentRepository struct {
	db *gorm.DB
}

func NewAppointmentRepository(db *gorm.DB) AppointmentRepository {
	return &appointmentRepository{db}
}

func (r *appointmentRepository) FindAll(ctx context.Context, search string, filter string, userID uint, role string, limit, offset int) ([]models.Appointment, int64, error) {
	var appointments []models.Appointment
	var totalCount int64

	query := r.buildApptQuery(ctx, search, filter, userID, role)

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("appointmentRepository.FindAll: %w", err)
	}

	query = query.Preload("User").Preload("Doctor").Preload("Schedule").Order("appointments.created_at desc")
	if limit > 0 {
		query = query.Limit(limit)
	}
	if offset > 0 {
		query = query.Offset(offset)
	}

	if err := query.Find(&appointments).Error; err != nil {
		return nil, 0, fmt.Errorf("appointmentRepository.FindAll: %w", err)
	}
	return appointments, totalCount, nil
}

func (r *appointmentRepository) buildApptQuery(ctx context.Context, search, filter string, userID uint, role string) *gorm.DB {
	query := r.db.Model(&models.Appointment{}).
		Joins("LEFT JOIN users ON users.id = appointments.user_id").
		Joins("LEFT JOIN doctor_schedules ON doctor_schedules.id = appointments.doctor_schedule_id")

	if role == "doctor" {
		query = query.Where("appointments.doctor_id = (SELECT id FROM doctors WHERE user_id = ? LIMIT 1)", userID)
	}

	if search != "" {
		searchTerm := "%" + search + "%"
		query = query.Where("appointments.notes LIKE ? OR users.full_name LIKE ?", searchTerm, searchTerm)
	}
	if filter == "today" {
		query = query.Where("DATE(doctor_schedules.date) = CURDATE()")
	} else if filter == "tomorrow" {
		query = query.Where("DATE(doctor_schedules.date) = CURDATE() + INTERVAL 1 DAY")
	}
	return query
}

func (r *appointmentRepository) FindByUserID(ctx context.Context, userID uint, limit, offset int) ([]models.Appointment, int64, error) {
	var appointments []models.Appointment
	var totalCount int64

	query := r.db.Model(&models.Appointment{}).Where("user_id = ?", userID)

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("appointmentRepository.FindByUserID: %w", err)
	}

	query = query.Preload("Doctor").Preload("Schedule").Order("created_at desc")
	if limit > 0 {
		query = query.Limit(limit)
	}
	if offset > 0 {
		query = query.Offset(offset)
	}

	if err := query.Find(&appointments).Error; err != nil {
		return nil, 0, fmt.Errorf("appointmentRepository.FindByUserID: %w", err)
	}
	return appointments, totalCount, nil
}

func (r *appointmentRepository) FindByID(ctx context.Context, id uint) (*models.Appointment, error) {
	var appointment models.Appointment
	err := r.db.Preload("User").Preload("Doctor").Preload("Schedule").First(&appointment, id).Error
	if err != nil {
		return nil, fmt.Errorf("appointmentRepository.FindByID: %w", err)
	}
	return &appointment, nil
}

func (r *appointmentRepository) Create(ctx context.Context, appointment *models.Appointment) error {
	return r.db.Create(appointment).Error
}

func (r *appointmentRepository) Update(ctx context.Context, appointment *models.Appointment) error {
	return r.db.Omit("created_at").Save(appointment).Error
}
