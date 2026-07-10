package services

import (
	"fmt"

	"context"

	"backend/models"
	"backend/repositories"
	"bytes"
	"net/http"
	"time"
)

type ScheduleService interface {
	GetUpcomingSchedules(ctx context.Context, limit int) ([]models.DoctorSchedule, error)
	GetDoctorSchedules(ctx context.Context, doctorID uint) ([]models.DoctorSchedule, error)
	CreateSchedule(ctx context.Context, schedule *models.DoctorSchedule) error
	UpdateSchedule(ctx context.Context, id uint, input *models.DoctorSchedule) (*models.DoctorSchedule, error)
	DeleteSchedule(ctx context.Context, id uint) error
}

type scheduleService struct {
	scheduleRepo repositories.ScheduleRepository
}

func NewScheduleService(scheduleRepo repositories.ScheduleRepository) ScheduleService {
	return &scheduleService{scheduleRepo}
}

func (s *scheduleService) GetUpcomingSchedules(ctx context.Context, limit int) ([]models.DoctorSchedule, error) {
	return s.scheduleRepo.FindUpcomingSchedules(ctx, limit)
}

func triggerRAGSync() {
	go func() {
		url := "http://localhost:8000/api/rag/sync"
		resp, err := http.Post(url, "application/json", bytes.NewBuffer([]byte("{}")))
		if err == nil {
			resp.Body.Close()
		}
	}()
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
	if err == nil {
		triggerRAGSync()
	}
	return fmt.Errorf("scheduleService.CreateSchedule: %w", err)
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

	triggerRAGSync()
	return schedule, nil
}

func (s *scheduleService) DeleteSchedule(ctx context.Context, id uint) error {
	err := s.scheduleRepo.Delete(ctx, id)
	if err == nil {
		triggerRAGSync()
	}
	return fmt.Errorf("scheduleService.DeleteSchedule: %w", err)
}
