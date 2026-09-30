package services

import (
	"backend/constants"
	"context"
	"fmt"
	"strings"

	"backend/models"
	"backend/repositories"
)

type AppointmentService interface {
	GetAllAppointments(ctx context.Context, search string, filter string, userID uint, role string, limit, offset int) ([]models.Appointment, int64, error)
	GetUserAppointments(ctx context.Context, userID uint, limit, offset int) ([]models.Appointment, int64, error)
	BookAppointment(ctx context.Context, userID uint, req *models.Appointment) (*models.Appointment, error)
	CancelAppointment(ctx context.Context, id uint, userID uint, role string, reason string) (*models.Appointment, error)
	ApproveAppointment(ctx context.Context, id uint) (*models.Appointment, error)
	CompleteAppointment(ctx context.Context, id uint) (*models.Appointment, error)
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

func validateCancellation(appointment *models.Appointment, userID uint, role string, reason string) error {
	if len(reason) < 5 {
		return fmt.Errorf("appointmentService.CancelAppointment: %w", constants.ErrCancellationReasonRequired)
	}
	isAdminOrDoc := role == "admin" || role == "doctor"
	if !isAdminOrDoc && appointment.UserID != userID {
		return fmt.Errorf("appointmentService.CancelAppointment: %w", constants.ErrUnauthorizedToCancelAppt)
	}
	if appointment.Status == "cancelled" || appointment.Status == "completed" {
		return fmt.Errorf("appointmentService.CancelAppointment: %w", constants.ErrCannotCancelCompleted)
	}
	return nil
}

func (s *appointmentService) decrementScheduleBooking(ctx context.Context, scheduleID uint) {
	schedule, err := s.scheduleRepo.FindByID(ctx, scheduleID)
	if err == nil && schedule.Booked > 0 {
		schedule.Booked -= 1
		_ = s.scheduleRepo.Update(ctx, schedule)
	}
}

func (s *appointmentService) CancelAppointment(ctx context.Context, id uint, userID uint, role string, reason string) (*models.Appointment, error) {
	reason = strings.TrimSpace(reason)
	appointment, err := s.appointmentRepo.FindByID(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("appointmentService.CancelAppointment: %w", constants.ErrAppointmentNotFound)
	}
	if err := validateCancellation(appointment, userID, role, reason); err != nil {
		return nil, err
	}
	appointment.Status = "cancelled"
	appointment.CancellationReason = reason
	if err := s.appointmentRepo.Update(ctx, appointment); err != nil {
		return nil, fmt.Errorf("appointmentService.CancelAppointment: %w", err)
	}
	s.decrementScheduleBooking(ctx, appointment.DoctorScheduleID)
	return appointment, nil
}

func (s *appointmentService) ApproveAppointment(ctx context.Context, id uint) (*models.Appointment, error) {
	appointment, err := s.appointmentRepo.FindByID(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("appointmentService.ApproveAppointment: %w", constants.ErrAppointmentNotFound)
	}

	if appointment.Status != "pending" {
		return nil, fmt.Errorf("appointmentService.ApproveAppointment: %w", constants.ErrCanOnlyApprovePending)
	}

	appointment.Status = "approved"
	if err := s.appointmentRepo.Update(ctx, appointment); err != nil {
		return nil, fmt.Errorf("appointmentService.ApproveAppointment: %w", err)
	}
	return appointment, nil
}

func (s *appointmentService) CompleteAppointment(ctx context.Context, id uint) (*models.Appointment, error) {
	appointment, err := s.appointmentRepo.FindByID(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("appointmentService.CompleteAppointment: %w", constants.ErrAppointmentNotFound)
	}

	if appointment.Status != "approved" {
		return nil, fmt.Errorf("appointmentService.CompleteAppointment: %w", constants.ErrCanOnlyCompleteApproved)
	}

	hasRecord, err := s.appointmentRepo.HasMedicalResult(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("appointmentService.CompleteAppointment: %w", err)
	}
	if !hasRecord {
		return nil, fmt.Errorf("appointmentService.CompleteAppointment: %w", constants.ErrMedicalRecordRequired)
	}

	appointment.Status = "completed"
	if err := s.appointmentRepo.Update(ctx, appointment); err != nil {
		return nil, fmt.Errorf("appointmentService.CompleteAppointment: %w", err)
	}
	return appointment, nil
}
