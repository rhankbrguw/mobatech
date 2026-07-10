package repositories

import (
	"fmt"

	"context"

	"backend/models"

	"gorm.io/gorm"
)

type ReminderRepository interface {
	FindAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Reminder, int64, error)
	FindByUserID(ctx context.Context, userID uint) ([]models.Reminder, error)
	FindUnreadCountByUserID(ctx context.Context, userID uint) (int64, error)
	FindByID(ctx context.Context, id uint) (*models.Reminder, error)
	Create(ctx context.Context, reminder *models.Reminder) error
	Update(ctx context.Context, reminder *models.Reminder) error
	Delete(ctx context.Context, id uint) error
}

type reminderRepository struct {
	db *gorm.DB
}

func NewReminderRepository(db *gorm.DB) ReminderRepository {
	return &reminderRepository{db}
}

func (r *reminderRepository) FindAll(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Reminder, int64, error) {
	var reminders []models.Reminder
	var totalCount int64
	query := r.db.Model(&models.Reminder{}).Joins("LEFT JOIN users ON users.id = reminders.user_id")

	if search != "" {
		searchTerm := "%" + search + "%"
		query = query.Where("reminders.title LIKE ? OR users.full_name LIKE ?", searchTerm, searchTerm)
	}

	if filter != "" {
		query = query.Where("type = ?", filter)
	}

	err := query.Count(&totalCount).Error
	if err != nil {
		return nil, 0, fmt.Errorf("reminderRepository.FindAll: %w", err)
	}

	if err = query.Order("reminders.created_at desc").Limit(limit).Offset(offset).Find(&reminders).Error; err != nil {
		return nil, 0, fmt.Errorf("reminderRepository.FindAll: %w", err)
	}
	return reminders, totalCount, nil
}

func (r *reminderRepository) FindByUserID(ctx context.Context, userID uint) ([]models.Reminder, error) {
	var reminders []models.Reminder
	if err := r.db.Where("user_id = ?", userID).Order("reminder_date asc").Find(&reminders).Error; err != nil {
		return nil, fmt.Errorf("reminderRepository.FindByUserID: %w", err)
	}
	return reminders, nil
}

func (r *reminderRepository) FindUnreadCountByUserID(ctx context.Context, userID uint) (int64, error) {
	var count int64
	if err := r.db.Model(&models.Reminder{}).Where("user_id = ? AND is_read = ?", userID, false).Count(&count).Error; err != nil {
		return 0, fmt.Errorf("reminderRepository.FindUnreadCountByUserID: %w", err)
	}
	return count, nil
}

func (r *reminderRepository) FindByID(ctx context.Context, id uint) (*models.Reminder, error) {
	var reminder models.Reminder
	err := r.db.First(&reminder, id).Error
	if err != nil {
		return nil, fmt.Errorf("reminderRepository.FindByID: %w", err)
	}
	return &reminder, nil
}

func (r *reminderRepository) Create(ctx context.Context, reminder *models.Reminder) error {
	return r.db.Create(reminder).Error
}

func (r *reminderRepository) Update(ctx context.Context, reminder *models.Reminder) error {
	return r.db.Omit("created_at").Save(reminder).Error
}

func (r *reminderRepository) Delete(ctx context.Context, id uint) error {
	return r.db.Delete(&models.Reminder{}, id).Error
}
