package services

import (
	"context"
	"errors"
	"testing"
	"time"

	"backend/constants"
	"backend/models"
)

type mockApptRepo struct {
	appt             *models.Appointment
	hasMedicalResult bool
	updatedAppt      *models.Appointment
}

func (m *mockApptRepo) FindAll(ctx context.Context, search, filter string, userID uint, role string, limit, offset int) ([]models.Appointment, int64, error) {
	return nil, 0, nil
}
func (m *mockApptRepo) FindByUserID(ctx context.Context, userID uint, limit, offset int) ([]models.Appointment, int64, error) {
	return nil, 0, nil
}
func (m *mockApptRepo) FindByID(ctx context.Context, id uint) (*models.Appointment, error) {
	if m.appt == nil {
		return nil, errors.New("not found")
	}
	return m.appt, nil
}
func (m *mockApptRepo) Create(ctx context.Context, appt *models.Appointment) error {
	return nil
}
func (m *mockApptRepo) Update(ctx context.Context, appt *models.Appointment) error {
	m.updatedAppt = appt
	return nil
}
func (m *mockApptRepo) HasMedicalResult(ctx context.Context, id uint) (bool, error) {
	return m.hasMedicalResult, nil
}

type mockScheduleRepo struct {
	schedule *models.DoctorSchedule
}

func (m *mockScheduleRepo) FindByID(ctx context.Context, id uint) (*models.DoctorSchedule, error) {
	if m.schedule == nil {
		return nil, errors.New("not found")
	}
	return m.schedule, nil
}
func (m *mockScheduleRepo) FindUpcomingSchedules(ctx context.Context, limit int, offset int) ([]models.DoctorSchedule, int64, error) {
	return nil, 0, nil
}
func (m *mockScheduleRepo) FindByDoctorID(ctx context.Context, doctorID uint, fromDate time.Time) ([]models.DoctorSchedule, error) {
	return nil, nil
}
func (m *mockScheduleRepo) Create(ctx context.Context, s *models.DoctorSchedule) error { return nil }
func (m *mockScheduleRepo) Update(ctx context.Context, s *models.DoctorSchedule) error {
	m.schedule = s
	return nil
}
func (m *mockScheduleRepo) Delete(ctx context.Context, id uint) error { return nil }

func TestCompleteAppointment_RequiresMedicalResult(t *testing.T) {
	repo := &mockApptRepo{
		appt:             &models.Appointment{Status: "approved"},
		hasMedicalResult: false,
	}
	schRepo := &mockScheduleRepo{}
	svc := NewAppointmentService(repo, schRepo)

	err := func() error {
		_, err := svc.CompleteAppointment(context.Background(), 1)
		return err
	}()

	if !errors.Is(err, constants.ErrMedicalRecordRequired) {
		t.Fatalf("Expected ErrMedicalRecordRequired, got: %v", err)
	}
}

func TestCompleteAppointment_SuccessWithMedicalResult(t *testing.T) {
	repo := &mockApptRepo{
		appt:             &models.Appointment{Status: "approved"},
		hasMedicalResult: true,
	}
	schRepo := &mockScheduleRepo{}
	svc := NewAppointmentService(repo, schRepo)

	appt, err := svc.CompleteAppointment(context.Background(), 1)
	if err != nil {
		t.Fatalf("Expected success, got: %v", err)
	}
	if appt.Status != "completed" {
		t.Fatalf("Expected status 'completed', got: %s", appt.Status)
	}
}

func TestCancelAppointment_RequiresReasonMin5Chars(t *testing.T) {
	repo := &mockApptRepo{
		appt: &models.Appointment{Status: "pending", UserID: 10},
	}
	schRepo := &mockScheduleRepo{}
	svc := NewAppointmentService(repo, schRepo)

	_, err := svc.CancelAppointment(context.Background(), 1, 10, "patient", "nope")
	if !errors.Is(err, constants.ErrCancellationReasonRequired) {
		t.Fatalf("Expected ErrCancellationReasonRequired for short reason, got: %v", err)
	}

	appt, err := svc.CancelAppointment(context.Background(), 1, 10, "patient", "Jadwal mendadak bentrok dengan rapat")
	if err != nil {
		t.Fatalf("Expected cancel success with valid reason, got: %v", err)
	}
	if appt.Status != "cancelled" || appt.CancellationReason != "Jadwal mendadak bentrok dengan rapat" {
		t.Fatalf("Expected cancelled status and reason saved, got: %v", appt)
	}
}
