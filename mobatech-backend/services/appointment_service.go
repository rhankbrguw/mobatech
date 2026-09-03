package services

import (
	"backend/constants"

	"context"

	"backend/models"
	"backend/repositories"
	"fmt"
)

type AppointmentService interface {
	GetAllAppointments(ctx context.Context, search string, filter string, userID uint, role string, limit, offset int) ([]models.Appointment, int64, error)
	GetUserAppointments(ctx context.Context, userID uint, limit, offset int) ([]models.Appointment, int64, error)
	BookAppointment(ctx context.Context, userID uint, req *models.Appointment) (*models.Appointment, error)
	CancelAppointment(ctx context.Context, id uint, userID uint, isAdmin bool) error
	ApproveAppointment(ctx context.Context, id uint) error
	CompleteAppointment(ctx context.Context, id uint) error
}

type appointmentService struct {
	appointmentRepo repositories.AppointmentRepository
	scheduleRepo    repositories.ScheduleRepository
}

func NewAppointmentService(appointmentRepo repositories.AppointmentRepository, scheduleRepo repositories.ScheduleRepository) AppointmentService {
	return &appointmentService{appointmentRepo, scheduleRepo}
}

func (s *appointmentService) GetAllAppointments(ctx context.Context, search string, filter string, userID uint, role string, limit, offset int) ([]models.Appointment, int64, error) {
	return s.appointmentRepo.FindAll(ctx, search, filter, userID, role, limit, offset)
}

func (s *appointmentService) GetUserAppointments(ctx context.Context, userID uint, limit, offset int) ([]models.Appointment, int64, error) {
	return s.appointmentRepo.FindByUserID(ctx, userID, limit, offset)
}

func (s *appointmentService) BookAppointment(ctx context.Context, userID uint, req *models.Appointment) (*models.Appointment, error) {
	schedule, err := s.reserveDoctorScheduleSlot(ctx, req.DoctorScheduleID)
	if err != nil {
		return nil, err
	}

	req.DoctorID = schedule.DoctorID
	req.UserID = userID
	req.Status = "pending"

	if err := s.appointmentRepo.Create(ctx, req); err != nil {
		if rollbackErr := s.rollbackScheduleBooking(ctx, schedule); rollbackErr != nil {
			return nil, fmt.Errorf("appointmentService.BookAppointment: create error (%w) and rollback error (%w)", err, rollbackErr)
		}
		return nil, fmt.Errorf("appointmentService.BookAppointment: %w", err)
	}
	return s.appointmentRepo.FindByID(ctx, req.ID)
}

func (s *appointmentService) CancelAppointment(ctx context.Context, id uint, userID uint, isAdmin bool) error {
	appointment, err := s.appointmentRepo.FindByID(ctx, id)
	if err != nil {
		return fmt.Errorf("appointmentService.CancelAppointment: %w", constants.ErrAppointmentNotFound)
	}

	if !isAdmin && appointment.UserID != userID {
		return fmt.Errorf("appointmentService.CancelAppointment: %w", constants.ErrUnauthorizedToCancelAppt)
	}

	if appointment.Status == "cancelled" || appointment.Status == "completed" {
		return fmt.Errorf("appointmentService.CancelAppointment: %w", constants.ErrCannotCancelCompleted)
	}

	appointment.Status = "cancelled"
	if err := s.appointmentRepo.Update(ctx, appointment); err != nil {
		return fmt.Errorf("appointmentService.CancelAppointment: %w", err)
	}

	schedule, err := s.scheduleRepo.FindByID(ctx, appointment.DoctorScheduleID)
	if err == nil && schedule.Booked > 0 {
		schedule.Booked -= 1
		if updateErr := s.scheduleRepo.Update(ctx, schedule); updateErr != nil {
			return fmt.Errorf("appointmentService.CancelAppointment: schedule update failed: %w", updateErr)
		}
	}
	return nil
}

func (s *appointmentService) ApproveAppointment(ctx context.Context, id uint) error {
	appointment, err := s.appointmentRepo.FindByID(ctx, id)
	if err != nil {
		return fmt.Errorf("appointmentService.ApproveAppointment: %w", constants.ErrAppointmentNotFound)
	}

	if appointment.Status != "pending" {
		return fmt.Errorf("appointmentService.ApproveAppointment: %w", constants.ErrCanOnlyApprovePending)
	}

	appointment.Status = "approved"
	return s.appointmentRepo.Update(ctx, appointment)
}

func (s *appointmentService) CompleteAppointment(ctx context.Context, id uint) error {
	appointment, err := s.appointmentRepo.FindByID(ctx, id)
	if err != nil {
		return fmt.Errorf("appointmentService.CompleteAppointment: %w", constants.ErrAppointmentNotFound)
	}

	if appointment.Status != "approved" {
		return fmt.Errorf("appointmentService.CompleteAppointment: %w", constants.ErrCanOnlyCompleteApproved)
	}

	appointment.Status = "completed"
	return s.appointmentRepo.Update(ctx, appointment)
}
