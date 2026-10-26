package repositories

import (
	"context"
	"fmt"

	"backend/models"

	"gorm.io/gorm"
)

type NotificationRepository interface {
	Create(ctx context.Context, n *models.Notification) error
	FindAll(ctx context.Context, userID uint, role string, unreadOnly bool, limit, offset int) ([]models.Notification, int64, error)
	MarkAsRead(ctx context.Context, id uint, userID uint, role string) error
	MarkAllAsRead(ctx context.Context, userID uint, role string) error
	GetUnreadCount(ctx context.Context, userID uint, role string) (int64, error)
}

type notificationRepository struct {
	db *gorm.DB
}

func NewNotificationRepository(db *gorm.DB) NotificationRepository {
	return &notificationRepository{db}
}

func (r *notificationRepository) buildQuery(userID uint, role string) *gorm.DB {
	q := r.db.Model(&models.Notification{})
	if role == "admin" {
		return q.Where("user_id = ? OR (user_id IS NULL AND role IN ('all', 'admin'))", userID)
	}
	if role == "doctor" {
		return q.Where("(user_id = ?) OR (user_id IS NULL AND role IN ('all', 'doctor') AND type != 'appointment')", userID)
	}
	if role == "pharmacist" {
		return q.Where("(user_id = ?) OR (user_id IS NULL AND role IN ('all', 'pharmacist') AND type != 'prescription')", userID)
	}
	return q.Where("(user_id = ?) OR (user_id IS NULL AND role IN ('all', ?) AND type NOT IN ('appointment', 'prescription'))", userID, role)
}

func (r *notificationRepository) Create(ctx context.Context, n *models.Notification) error {
	if err := r.db.WithContext(ctx).Create(n).Error; err != nil {
		return fmt.Errorf("notificationRepository.Create: %w", err)
	}
	return nil
}

func (r *notificationRepository) FindAll(ctx context.Context, userID uint, role string, unreadOnly bool, limit, offset int) ([]models.Notification, int64, error) {
	var list []models.Notification
	var total int64

	q := r.buildQuery(userID, role)
	if unreadOnly {
		q = q.Where("is_read = ?", false)
	}
	if err := q.Count(&total).Error; err != nil {
		return nil, 0, fmt.Errorf("notificationRepository.FindAll: %w", err)
	}
	if limit > 0 {
		q = q.Limit(limit).Offset(offset)
	}
	if err := q.Order("created_at desc").Find(&list).Error; err != nil {
		return nil, 0, fmt.Errorf("notificationRepository.FindAll: %w", err)
	}
	return list, total, nil
}

func (r *notificationRepository) MarkAsRead(ctx context.Context, id uint, userID uint, role string) error {
	q := r.buildQuery(userID, role).Where("id = ?", id)
	return q.Update("is_read", true).Error
}

func (r *notificationRepository) MarkAllAsRead(ctx context.Context, userID uint, role string) error {
	q := r.buildQuery(userID, role).Where("is_read = ?", false)
	return q.Update("is_read", true).Error
}

func (r *notificationRepository) GetUnreadCount(ctx context.Context, userID uint, role string) (int64, error) {
	var count int64
	q := r.buildQuery(userID, role).Where("is_read = ?", false)
	err := q.Count(&count).Error
	return count, err
}
