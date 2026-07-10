package services

import (
	"fmt"

	"backend/constants"

	"context"

	"backend/models"
	"backend/repositories"
)

type MedicalResultService interface {
	GetAllMedicalResults(ctx context.Context, search string, filter string, userID uint, role string, limit int, offset int) ([]models.MedicalResult, int64, error)
	GetUserMedicalResults(ctx context.Context, userID uint) ([]models.MedicalResult, error)
	GetMedicalResultByID(ctx context.Context, id uint) (*models.MedicalResult, error)
	CreateMedicalResult(ctx context.Context, req *models.MedicalResult) (*models.MedicalResult, error)
	UpdateMedicalResult(ctx context.Context, req *models.MedicalResult) (*models.MedicalResult, error)
	DeleteMedicalResult(ctx context.Context, id uint) error
}

type medicalResultService struct {
	repo repositories.MedicalResultRepository
}

func NewMedicalResultService(repo repositories.MedicalResultRepository) MedicalResultService {
	return &medicalResultService{repo}
}

func (s *medicalResultService) GetAllMedicalResults(ctx context.Context, search string, filter string, userID uint, role string, limit int, offset int) ([]models.MedicalResult, int64, error) {
	return s.repo.FindAll(ctx, search, filter, userID, role, limit, offset)
}

func (s *medicalResultService) GetUserMedicalResults(ctx context.Context, userID uint) ([]models.MedicalResult, error) {
	return s.repo.FindByUserID(ctx, userID)
}

func (s *medicalResultService) GetMedicalResultByID(ctx context.Context, id uint) (*models.MedicalResult, error) {
	return s.repo.FindByID(ctx, id)
}

func (s *medicalResultService) CreateMedicalResult(ctx context.Context, req *models.MedicalResult) (*models.MedicalResult, error) {
	err := s.repo.Create(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("medicalResultService.CreateMedicalResult: %w", err)
	}
	return req, nil
}

func (s *medicalResultService) UpdateMedicalResult(ctx context.Context, req *models.MedicalResult) (*models.MedicalResult, error) {
	_, err := s.repo.FindByID(ctx, req.ID)
	if err != nil {
		return nil, fmt.Errorf("medicalResultService.UpdateMedicalResult: %w", constants.ErrMedicalResultNotFound)
	}

	err = s.repo.Update(ctx, req)
	if err != nil {
		return nil, fmt.Errorf("medicalResultService.UpdateMedicalResult: %w", err)
	}
	return req, nil
}

func (s *medicalResultService) DeleteMedicalResult(ctx context.Context, id uint) error {
	_, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return fmt.Errorf("medicalResultService.DeleteMedicalResult: %w", constants.ErrMedicalResultNotFound)
	}
	return s.repo.Delete(ctx, id)
}
