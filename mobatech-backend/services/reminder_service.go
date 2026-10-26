package services

import (
	"fmt"

	"backend/constants"

	"context"

	"backend/models"
	"backend/repositories"
)

type ReminderService interface {
	GetAllReminders(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Reminder, int64, error)
	GetUserReminders(ctx context.Context, userID uint) ([]models.Reminder, error)
	GetUnreadCount(ctx context.Context, userID uint) (int64, error)
	CreateReminder(ctx context.Context, req *models.Reminder) (*models.Reminder, error)
	MarkAsRead(ctx context.Context, id uint, userID uint) error
	DeleteReminder(ctx context.Context, id uint) error
}

type reminderService struct {
	repo repositories.ReminderRepository
}

func NewReminderService(repo repositories.ReminderRepository) ReminderService {
	return &reminderService{repo}
}

func (s *reminderService) GetAllReminders(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Reminder, int64, error) {
	return s.repo.FindAll(ctx, search, filter, limit, offset)
}

func (s *reminderService) GetUserReminders(ctx context.Context, userID uint) ([]models.Reminder, error) {
	return s.repo.FindByUserID(ctx, userID)
}

func (s *reminderService) GetUnreadCount(ctx context.Context, userID uint) (int64, error) {
	return s.repo.FindUnreadCountByUserID(ctx, userID)
}

func (s *reminderService) CreateReminder(ctx context.Context, req *models.Reminder) (*models.Reminder, error) {
	err := s.repo.Create(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("reminderService.CreateReminder: %w", err)
	}
	return req, nil
}

func (s *reminderService) MarkAsRead(ctx context.Context, id uint, userID uint) error {
	reminder, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return fmt.Errorf("reminderService.MarkAsRead: %w", constants.ErrReminderNotFound)
	}

	if reminder.UserID != userID {
		return fmt.Errorf("reminderService.MarkAsRead: %w", constants.ErrUnauthorizedToUpdateRemind)
	}

	reminder.IsRead = true
	return s.repo.Update(ctx, reminder)
}

func (s *reminderService) DeleteReminder(ctx context.Context, id uint) error {
	_, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return fmt.Errorf("reminderService.DeleteReminder: %w", constants.ErrReminderNotFound)
	}
	return s.repo.Delete(ctx, id)
}
