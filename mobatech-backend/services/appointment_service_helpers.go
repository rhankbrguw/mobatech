package services

import (
	"backend/constants"
	"backend/models"
	"context"
	"fmt"
	"time"
)

func (s *appointmentService) reserveDoctorScheduleSlot(ctx context.Context, scheduleID uint) (*models.DoctorSchedule, error) {
	schedule, err := s.scheduleRepo.FindByID(ctx, scheduleID)
	if err != nil {
		return nil, fmt.Errorf("appointmentService.BookAppointment: %w", constants.ErrScheduleNotFound)
	}

	if !schedule.IsAvailable || schedule.Booked >= schedule.Quota {
		return nil, fmt.Errorf("appointmentService.BookAppointment: %w", constants.ErrScheduleFullOrNotAvail)
	}

	if s.checkScheduleExpired(ctx, schedule) {
		return nil, fmt.Errorf("appointmentService.BookAppointment: %w", constants.ErrScheduleExpired)
	}

	schedule.Booked += 1
	if err := s.scheduleRepo.Update(ctx, schedule); err != nil {
		return nil, fmt.Errorf("appointmentService.BookAppointment: %w", err)
	}
	return schedule, nil
}

func (s *appointmentService) checkScheduleExpired(ctx context.Context, schedule *models.DoctorSchedule) bool {
	now := time.Now()
	scheduleEndStr := fmt.Sprintf("%s %s", schedule.Date.Format("2006-01-02"), schedule.EndTime)
	var scheduleEnd time.Time
	var errParse error

	if len(schedule.EndTime) > 5 {
		scheduleEnd, errParse = time.ParseInLocation("2006-01-02 15:04:05", scheduleEndStr, time.Local)
	} else {
		scheduleEnd, errParse = time.ParseInLocation("2006-01-02 15:04", scheduleEndStr, time.Local)
	}
	return errParse == nil && now.After(scheduleEnd)
}

func (s *appointmentService) rollbackScheduleBooking(ctx context.Context, schedule *models.DoctorSchedule) error {
	schedule.Booked -= 1
	return s.scheduleRepo.Update(ctx, schedule)
}
