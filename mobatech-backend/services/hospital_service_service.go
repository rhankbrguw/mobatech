package services

import (
	"fmt"

	"context"

	"backend/models"
	"backend/repositories"
	"backend/utils"
)

type HospitalServiceService interface {
	GetAll(ctx context.Context, search string, filter string) ([]models.HospitalService, error)
	GetByID(ctx context.Context, id uint) (*models.HospitalService, error)
	Create(ctx context.Context, service *models.HospitalService) error
	Update(ctx context.Context, service *models.HospitalService) error
	Delete(ctx context.Context, id uint) error
}

type hospitalServiceService struct {
	repo repositories.HospitalServiceRepository
}

func NewHospitalServiceService(repo repositories.HospitalServiceRepository) HospitalServiceService {
	return &hospitalServiceService{repo}
}

func (s *hospitalServiceService) GetAll(ctx context.Context, search string, filter string) ([]models.HospitalService, error) {
	return s.repo.GetAll(ctx, search, filter)
}

func (s *hospitalServiceService) GetByID(ctx context.Context, id uint) (*models.HospitalService, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *hospitalServiceService) Create(ctx context.Context, service *models.HospitalService) error {
	err := s.repo.Create(ctx, service)
	if err != nil {
		return fmt.Errorf("hospitalServiceService.Create: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}

func (s *hospitalServiceService) Update(ctx context.Context, service *models.HospitalService) error {
	err := s.repo.Update(ctx, service)
	if err != nil {
		return fmt.Errorf("hospitalServiceService.Update: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}

func (s *hospitalServiceService) Delete(ctx context.Context, id uint) error {
	err := s.repo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("hospitalServiceService.Delete: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}
