package constants

import "errors"

var (
	ErrAppointmentNotFound        = errors.New("appointment not found")
	ErrCannotCancelCompleted      = errors.New("cannot cancel an already cancelled or completed appointment")
	ErrCanOnlyApprovePending      = errors.New("can only approve pending appointments")
	ErrCanOnlyCompleteApproved    = errors.New("can only complete approved appointments")
	ErrInvalidEmailOrPassword     = errors.New("invalid email or password")
	ErrJWTSecretNotConfigured     = errors.New("JWT_SECRET is not configured on the server")
	ErrMedicalResultNotFound      = errors.New("medical result not found")
	ErrOrderMustHaveItems         = errors.New("order must have at least one item")
	ErrQuantityMustBeGreaterThan0 = errors.New("quantity must be greater than zero")
	ErrReminderNotFound           = errors.New("reminder not found")
	ErrScheduleExpired            = errors.New("schedule has already expired")
	ErrScheduleFullOrNotAvail     = errors.New("schedule is full or not available")
	ErrScheduleNotFound           = errors.New("schedule not found")
	ErrCannotDeletePolyclinic     = errors.New("tidak bisa menghapus poliklinik karena masih ada dokter yang terdaftar di dalamnya, pindahkan dokternya terlebih dahulu")
	ErrUnauthorizedToCancelAppt   = errors.New("unauthorized to cancel this appointment")
	ErrUnauthorizedToDeletePresc  = errors.New("unauthorized to delete this prescription")
	ErrUnauthorizedToUpdateRemind = errors.New("unauthorized to update this reminder")
	ErrUserNotFound               = errors.New("user not found")
)
