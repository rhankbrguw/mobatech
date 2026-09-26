package services

import (
	"backend/models"
	"fmt"

	"gorm.io/gorm"
)

func getPatientName(appt *models.Appointment) string {
	if appt.User != nil && appt.User.FullName != "" {
		return appt.User.FullName
	}
	return fmt.Sprintf("Pasien #%d", appt.UserID)
}

func getDoctorName(appt *models.Appointment) string {
	if appt.Doctor != nil && appt.Doctor.Name != "" {
		return appt.Doctor.Name
	}
	return "Dokter"
}

func getDoctorUserID(db *gorm.DB, appt *models.Appointment) *uint {
	if appt.Doctor != nil && appt.Doctor.UserID != nil && *appt.Doctor.UserID > 0 {
		return appt.Doctor.UserID
	}
	if db != nil && appt.DoctorID > 0 {
		var doc models.Doctor
		if err := db.Select("id, user_id").First(&doc, appt.DoctorID).Error; err == nil && doc.UserID != nil {
			return doc.UserID
		}
	}
	return nil
}

func notifyDoctorBooked(db *gorm.DB, docUserID *uint, patient, doctor string) {
	if docUserID == nil || *docUserID == 0 {
		return
	}
	BroadcastEvent(db, &models.Notification{
		UserID:    docUserID,
		Role:      "doctor",
		Title:     "Janji Temu Pasien Baru",
		Message:   fmt.Sprintf("Pasien %s telah memesan jadwal konsultasi bersama %s.", patient, doctor),
		Type:      "appointment",
		ActionURL: "/dashboard/appointments",
	})
}

func notifyAdminBooked(db *gorm.DB, patient, doctor string) {
	BroadcastEvent(db, &models.Notification{
		Role:      "admin",
		Title:     "Janji Temu Baru Terdaftar",
		Message:   fmt.Sprintf("Pasien %s mendaftar janji temu dengan %s.", patient, doctor),
		Type:      "appointment",
		ActionURL: "/dashboard/appointments",
	})
}

func NotifyAppointmentBooked(db *gorm.DB, appt *models.Appointment) {
	patientName := getPatientName(appt)
	doctorName := getDoctorName(appt)
	docUserID := getDoctorUserID(db, appt)

	notifyDoctorBooked(db, docUserID, patientName, doctorName)
	notifyAdminBooked(db, patientName, doctorName)

	BroadcastEvent(db, &models.Notification{
		UserID:    &appt.UserID,
		Role:      "patient",
		Title:     "Konfirmasi Janji Temu",
		Message:   fmt.Sprintf("Janji temu dengan %s berhasil didaftarkan. Menunggu konfirmasi klinik.", doctorName),
		Type:      "appointment",
		ActionURL: "/appointments",
	})
}

func NotifyAppointmentApproved(db *gorm.DB, appt *models.Appointment) {
	patientName := getPatientName(appt)
	doctorName := getDoctorName(appt)
	docUserID := getDoctorUserID(db, appt)

	BroadcastEvent(db, &models.Notification{
		UserID:    &appt.UserID,
		Role:      "patient",
		Title:     "Janji Temu Disetujui",
		Message:   fmt.Sprintf("Janji temu Anda bersama %s telah disetujui.", doctorName),
		Type:      "appointment",
		ActionURL: "/appointments",
	})

	if docUserID != nil && *docUserID > 0 {
		BroadcastEvent(db, &models.Notification{
			UserID:    docUserID,
			Role:      "doctor",
			Title:     "Jadwal Konsultasi Dikonfirmasi",
			Message:   fmt.Sprintf("Jadwal konsultasi bersama pasien %s telah dikonfirmasi.", patientName),
			Type:      "appointment",
			ActionURL: "/dashboard/appointments",
		})
	}
}
