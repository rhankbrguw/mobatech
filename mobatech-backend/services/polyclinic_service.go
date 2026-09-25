package services

import (
	"fmt"

	"backend/constants"

	"context"

	"backend/models"
	"backend/repositories"
	"backend/utils"
)

type PolyclinicService interface {
	GetAllPolyclinics(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Polyclinic, int64, error)
	GetPolyclinicByID(ctx context.Context, id uint) (*models.Polyclinic, error)
	CreatePolyclinic(ctx context.Context, polyclinic *models.Polyclinic) error
	UpdatePolyclinic(ctx context.Context, polyclinic *models.Polyclinic) error
	DeletePolyclinic(ctx context.Context, id uint) error

	GetSchedules(ctx context.Context, polyclinicID uint) ([]models.PolyclinicSchedule, error)
	CreateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error
	UpdateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error
	DeleteSchedule(ctx context.Context, id uint) error
}

type polyclinicService struct {
	repo repositories.PolyclinicRepository
}

func NewPolyclinicService(repo repositories.PolyclinicRepository) PolyclinicService {
	return &polyclinicService{repo}
}

func (s *polyclinicService) GetAllPolyclinics(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Polyclinic, int64, error) {
	return s.repo.FindAll(ctx, search, filter, limit, offset)
}

func (s *polyclinicService) GetPolyclinicByID(ctx context.Context, id uint) (*models.Polyclinic, error) {
	return s.repo.FindByID(ctx, id)
}

func (s *polyclinicService) CreatePolyclinic(ctx context.Context, polyclinic *models.Polyclinic) error {
	err := s.repo.Create(ctx, polyclinic)
	if err != nil {
		return fmt.Errorf("polyclinicService.CreatePolyclinic: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}

func (s *polyclinicService) UpdatePolyclinic(ctx context.Context, polyclinic *models.Polyclinic) error {
	err := s.repo.Update(ctx, polyclinic)
	if err != nil {
		return fmt.Errorf("polyclinicService.UpdatePolyclinic: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}

func (s *polyclinicService) DeletePolyclinic(ctx context.Context, id uint) error {
	polyclinic, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return fmt.Errorf("polyclinicService.DeletePolyclinic: %w", err)
	}

	if len(polyclinic.Doctors) > 0 {
		return fmt.Errorf("polyclinicService.DeletePolyclinic: %w", constants.ErrCannotDeletePolyclinic)
	}

	err = s.repo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("polyclinicService.DeletePolyclinic: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}

func (s *polyclinicService) GetSchedules(ctx context.Context, polyclinicID uint) ([]models.PolyclinicSchedule, error) {
	return s.repo.FindSchedulesByPolyclinic(ctx, polyclinicID)
}

func (s *polyclinicService) CreateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error {
	err := s.repo.CreateSchedule(ctx, schedule)
	if err != nil {
		return fmt.Errorf("polyclinicService.CreateSchedule: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}

func (s *polyclinicService) UpdateSchedule(ctx context.Context, schedule *models.PolyclinicSchedule) error {
	err := s.repo.UpdateSchedule(ctx, schedule)
	if err != nil {
		return fmt.Errorf("polyclinicService.UpdateSchedule: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}

func (s *polyclinicService) DeleteSchedule(ctx context.Context, id uint) error {
	err := s.repo.DeleteSchedule(ctx, id)
	if err != nil {
		return fmt.Errorf("polyclinicService.DeleteSchedule: %w", err)
	}
	utils.TriggerAsyncRAGSync()
	return nil
}
