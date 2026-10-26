package services

import (
	"context"
	"fmt"

	"backend/models"
	"backend/repositories"

	"gorm.io/gorm"
)

type NotificationService interface {
	CreateAndBroadcast(ctx context.Context, n *models.Notification) error
	GetNotifications(ctx context.Context, userID uint, role string, unreadOnly bool, limit, offset int) ([]models.Notification, int64, error)
	MarkAsRead(ctx context.Context, id uint, userID uint, role string) error
	MarkAllAsRead(ctx context.Context, userID uint, role string) error
	GetUnreadCount(ctx context.Context, userID uint, role string) (int64, error)
}

type notificationService struct {
	repo repositories.NotificationRepository
	hub  NotificationHub
}

func NewNotificationService(repo repositories.NotificationRepository, hub NotificationHub) NotificationService {
	return &notificationService{repo: repo, hub: hub}
}

func (s *notificationService) CreateAndBroadcast(ctx context.Context, n *models.Notification) error {
	if err := s.repo.Create(ctx, n); err != nil {
		return fmt.Errorf("notificationService.CreateAndBroadcast: %w", err)
	}
	s.hub.Broadcast(n)
	return nil
}

func (s *notificationService) GetNotifications(ctx context.Context, userID uint, role string, unreadOnly bool, limit, offset int) ([]models.Notification, int64, error) {
	return s.repo.FindAll(ctx, userID, role, unreadOnly, limit, offset)
}

func (s *notificationService) MarkAsRead(ctx context.Context, id uint, userID uint, role string) error {
	return s.repo.MarkAsRead(ctx, id, userID, role)
}

func (s *notificationService) MarkAllAsRead(ctx context.Context, userID uint, role string) error {
	return s.repo.MarkAllAsRead(ctx, userID, role)
}

func (s *notificationService) GetUnreadCount(ctx context.Context, userID uint, role string) (int64, error) {
	return s.repo.GetUnreadCount(ctx, userID, role)
}

func BroadcastEvent(db *gorm.DB, n *models.Notification) {
	if db != nil {
		_ = db.Create(n).Error
	}
	GetNotificationHub().Broadcast(n)
}
