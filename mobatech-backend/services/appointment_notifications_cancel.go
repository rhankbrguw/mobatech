package services

import (
	"backend/models"
	"fmt"

	"gorm.io/gorm"
)

func notifyStaffCancelledByPatient(db *gorm.DB, docUserID *uint, patient, doctor, reason string) {
	if docUserID != nil && *docUserID > 0 {
		BroadcastEvent(db, &models.Notification{
			UserID:    docUserID,
			Role:      "doctor",
			Title:     "Janji Temu Dibatalkan Pasien",
			Message:   fmt.Sprintf("Pasien %s membatalkan janji temu. Alasan: %s", patient, reason),
			Type:      "appointment",
			ActionURL: "/dashboard/appointments",
		})
	}
	BroadcastEvent(db, &models.Notification{
		Role:      "admin",
		Title:     "Janji Temu Dibatalkan Pasien",
		Message:   fmt.Sprintf("Pasien %s membatalkan janji temu dengan %s. Alasan: %s", patient, doctor, reason),
		Type:      "appointment",
		ActionURL: "/dashboard/appointments",
	})
}

func NotifyAppointmentCancelled(db *gorm.DB, appt *models.Appointment, cancelledByRole string, reason string) {
	patientName := getPatientName(appt)
	doctorName := getDoctorName(appt)

	if cancelledByRole == "patient" {
		notifyStaffCancelledByPatient(db, getDoctorUserID(db, appt), patientName, doctorName, reason)
		return
	}

	BroadcastEvent(db, &models.Notification{
		UserID:    &appt.UserID,
		Role:      "patient",
		Title:     "Janji Temu Dibatalkan",
		Message:   fmt.Sprintf("Janji temu Anda dengan %s dibatalkan. Alasan: %s", doctorName, reason),
		Type:      "appointment",
		ActionURL: "/appointments",
	})
}

func NotifyAppointmentCompleted(db *gorm.DB, appt *models.Appointment) {
	doctorName := getDoctorName(appt)
	BroadcastEvent(db, &models.Notification{
		UserID:    &appt.UserID,
		Role:      "patient",
		Title:     "Sesi Konsultasi Selesai",
		Message:   fmt.Sprintf("Sesi konsultasi Anda dengan %s telah selesai. Rekam medis telah diterbitkan.", doctorName),
		Type:      "appointment",
		ActionURL: "/medical-records",
	})
}
