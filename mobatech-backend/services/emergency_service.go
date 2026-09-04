package services

import (
	"context"

	"backend/models"
	"backend/repositories"
)

type EmergencyService interface {
	CreateRequest(ctx context.Context, req *models.EmergencyRequest) error
	GetByID(ctx context.Context, id uint) (*models.EmergencyRequest, error)
	GetHistoryByUser(ctx context.Context, userID uint) ([]models.EmergencyRequest, error)
	GetAllRequests(ctx context.Context, search string, filter string, limit int, offset int) ([]models.EmergencyRequest, int64, error)
	UpdateStatus(ctx context.Context, id uint, status string) error
	UpdateTracking(ctx context.Context, id uint, ambulanceLat, ambulanceLng float64, estimatedMinutes int, status string) error
}

type emergencyService struct {
	repo repositories.EmergencyRepository
}

func NewEmergencyService(repo repositories.EmergencyRepository) EmergencyService {
	return &emergencyService{repo}
}

func (s *emergencyService) CreateRequest(ctx context.Context, req *models.EmergencyRequest) error {
	req.Status = "Pending"
	return s.repo.Create(ctx, req)
}

func (s *emergencyService) GetByID(ctx context.Context, id uint) (*models.EmergencyRequest, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *emergencyService) GetHistoryByUser(ctx context.Context, userID uint) ([]models.EmergencyRequest, error) {
	return s.repo.GetByUserID(ctx, userID)
}

func (s *emergencyService) GetAllRequests(ctx context.Context, search string, filter string, limit int, offset int) ([]models.EmergencyRequest, int64, error) {
	return s.repo.GetAll(ctx, search, filter, limit, offset)
}

func (s *emergencyService) UpdateStatus(ctx context.Context, id uint, status string) error {
	return s.repo.UpdateStatus(ctx, id, status)
}

func (s *emergencyService) UpdateTracking(ctx context.Context, id uint, ambulanceLat, ambulanceLng float64, estimatedMinutes int, status string) error {
	return s.repo.UpdateTracking(ctx, id, ambulanceLat, ambulanceLng, estimatedMinutes, status)
}
