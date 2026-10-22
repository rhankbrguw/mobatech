package services

import (
	"context"
	"fmt"
	"log"
	"time"

	"backend/models"
	"backend/repositories"
)

type ScheduleService interface {
	GetUpcomingSchedules(ctx context.Context, limit int, offset int) ([]models.DoctorSchedule, int64, error)
	GetDoctorSchedules(ctx context.Context, doctorID uint) ([]models.DoctorSchedule, error)
	CreateSchedule(ctx context.Context, schedule *models.DoctorSchedule) error
	UpdateSchedule(ctx context.Context, id uint, input *models.DoctorSchedule) (*models.DoctorSchedule, error)
	DeleteSchedule(ctx context.Context, id uint) error
}

type scheduleService struct {
	scheduleRepo repositories.ScheduleRepository
	ragClient    RAGClient
}

func NewScheduleService(scheduleRepo repositories.ScheduleRepository, ragClient RAGClient) ScheduleService {
	if ragClient == nil {
		ragClient = NewRAGClient("", nil)
	}
	return &scheduleService{
		scheduleRepo: scheduleRepo,
		ragClient:    ragClient,
	}
}

func (s *scheduleService) GetUpcomingSchedules(ctx context.Context, limit int, offset int) ([]models.DoctorSchedule, int64, error) {
	return s.scheduleRepo.FindUpcomingSchedules(ctx, limit, offset)
}

func (s *scheduleService) triggerRAGSync(ctx context.Context) {
	if s.ragClient != nil {
		go func() {
			defer func() {
				if r := recover(); r != nil {
					log.Printf("Recovered from panic in scheduleService.triggerRAGSync: %v", r)
				}
			}()
			if err := s.ragClient.TriggerSync(context.Background()); err != nil {
				log.Printf("Warning: scheduleService failed to trigger RAG sync: %v", err)
			}
		}()
	}
}

func (s *scheduleService) GetDoctorSchedules(ctx context.Context, doctorID uint) ([]models.DoctorSchedule, error) {
	now := time.Now()
	today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	return s.scheduleRepo.FindByDoctorID(ctx, doctorID, today)
}

func (s *scheduleService) CreateSchedule(ctx context.Context, schedule *models.DoctorSchedule) error {
	schedule.IsAvailable = true
	schedule.Booked = 0
	err := s.scheduleRepo.Create(ctx, schedule)
	if err != nil {
		return fmt.Errorf("scheduleService.CreateSchedule: %w", err)
	}
	s.triggerRAGSync(ctx)
	return nil
}

func (s *scheduleService) UpdateSchedule(ctx context.Context, id uint, input *models.DoctorSchedule) (*models.DoctorSchedule, error) {
	schedule, err := s.scheduleRepo.FindByID(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("scheduleService.UpdateSchedule: %w", err)
	}

	if !input.Date.IsZero() {
		schedule.Date = input.Date
	}
	if input.StartTime != "" {
		schedule.StartTime = input.StartTime
	}
	if input.EndTime != "" {
		schedule.EndTime = input.EndTime
	}
	if input.Quota > 0 {
		schedule.Quota = input.Quota
	}

	err = s.scheduleRepo.Update(ctx, schedule)
	if err != nil {
		return nil, fmt.Errorf("scheduleService.UpdateSchedule: %w", err)
	}

	s.triggerRAGSync(ctx)
	return schedule, nil
}

func (s *scheduleService) DeleteSchedule(ctx context.Context, id uint) error {
	err := s.scheduleRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("scheduleService.DeleteSchedule: %w", err)
	}
	s.triggerRAGSync(ctx)
	return nil
}
