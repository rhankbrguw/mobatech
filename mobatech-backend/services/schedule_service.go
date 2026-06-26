package services

import (
	"backend/models"
	"backend/repositories"
	"bytes"
	"net/http"
	"time"
)

type ScheduleService interface {
	GetUpcomingSchedules(limit int) ([]models.DoctorSchedule, error)
	GetDoctorSchedules(doctorID uint) ([]models.DoctorSchedule, error)
	CreateSchedule(schedule *models.DoctorSchedule) error
	UpdateSchedule(id uint, input *models.DoctorSchedule) (*models.DoctorSchedule, error)
	DeleteSchedule(id uint) error
}

type scheduleService struct {
	scheduleRepo repositories.ScheduleRepository
}

func NewScheduleService(scheduleRepo repositories.ScheduleRepository) ScheduleService {
	return &scheduleService{scheduleRepo}
}

func (s *scheduleService) GetUpcomingSchedules(limit int) ([]models.DoctorSchedule, error) {
	return s.scheduleRepo.FindUpcomingSchedules(limit)
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

func (s *scheduleService) GetDoctorSchedules(doctorID uint) ([]models.DoctorSchedule, error) {
	now := time.Now()
	today := time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
	return s.scheduleRepo.FindByDoctorID(doctorID, today)
}

func (s *scheduleService) CreateSchedule(schedule *models.DoctorSchedule) error {
	schedule.IsAvailable = true
	schedule.Booked = 0
	err := s.scheduleRepo.Create(schedule)
	if err == nil {
		triggerRAGSync()
	}
	return err
}

func (s *scheduleService) UpdateSchedule(id uint, input *models.DoctorSchedule) (*models.DoctorSchedule, error) {
	schedule, err := s.scheduleRepo.FindByID(id)
	if err != nil {
		return nil, err
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

	err = s.scheduleRepo.Update(schedule)
	if err != nil {
		return nil, err
	}

	triggerRAGSync()
	return schedule, nil
}

func (s *scheduleService) DeleteSchedule(id uint) error {
	err := s.scheduleRepo.Delete(id)
	if err == nil {
		triggerRAGSync()
	}
	return err
}
