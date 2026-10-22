package services

import (
	"backend/models"
	"testing"
)

func TestNotificationWorkflow_Doctor_BookingAndCancel(t *testing.T) {
	hub := &notificationHub{}
	docUserID := uint(2)
	docClient := &NotificationClient{UserID: docUserID, Role: "doctor"}
	otherDocClient := &NotificationClient{UserID: 99, Role: "doctor"}

	bookedNotif := &models.Notification{
		UserID:    &docUserID,
		Role:      "doctor",
		Title:     "Janji Temu Pasien Baru",
		Message:   "Pasien Budi telah memesan jadwal konsultasi.",
		Type:      "appointment",
		ActionURL: "/dashboard/appointments",
	}

	if !hub.shouldSend(docClient, bookedNotif) {
		t.Errorf("doctor should receive appointment booked notification")
	}
	if hub.shouldSend(otherDocClient, bookedNotif) {
		t.Errorf("other doctor must not receive this doctor's appointment notification")
	}

	cancelNotif := &models.Notification{
		UserID:    &docUserID,
		Role:      "doctor",
		Title:     "Janji Temu Dibatalkan Pasien",
		Message:   "Pasien Budi membatalkan janji temu. Alasan: Ada kendala mendadak",
		Type:      "appointment",
		ActionURL: "/dashboard/appointments",
	}

	if !hub.shouldSend(docClient, cancelNotif) {
		t.Errorf("doctor should receive appointment cancelled notification")
	}
}

func TestNotificationWorkflow_Patient_ApprovalAndCancel(t *testing.T) {
	hub := &notificationHub{}
	patientID := uint(10)
	patientClient := &NotificationClient{UserID: patientID, Role: "patient"}
	otherPatientClient := &NotificationClient{UserID: 88, Role: "patient"}

	approvedNotif := &models.Notification{
		UserID:    &patientID,
		Role:      "patient",
		Title:     "Janji Temu Disetujui",
		Message:   "Janji temu Anda bersama dr. Tirta telah disetujui.",
		Type:      "appointment",
		ActionURL: "/appointments",
	}

	if !hub.shouldSend(patientClient, approvedNotif) {
		t.Errorf("patient should receive appointment approved notification")
	}
	if hub.shouldSend(otherPatientClient, approvedNotif) {
		t.Errorf("other patient must not receive approval notification")
	}

	cancelNotif := &models.Notification{
		UserID:    &patientID,
		Role:      "patient",
		Title:     "Janji Temu Dibatalkan",
		Message:   "Janji temu Anda dibatalkan. Alasan: Dokter sedang operasi",
		Type:      "appointment",
		ActionURL: "/appointments",
	}

	if !hub.shouldSend(patientClient, cancelNotif) {
		t.Errorf("patient should receive appointment cancelled notification")
	}
}

func TestNotificationWorkflow_Patient_ConsultationCompleteAndMedicineReady(t *testing.T) {
	hub := &notificationHub{}
	patientID := uint(10)
	patientClient := &NotificationClient{UserID: patientID, Role: "patient"}

	completedNotif := &models.Notification{
		UserID:    &patientID,
		Role:      "patient",
		Title:     "Sesi Konsultasi Selesai",
		Message:   "Rekam medis telah diterbitkan.",
		Type:      "appointment",
		ActionURL: "/medical-records",
	}
	if !hub.shouldSend(patientClient, completedNotif) {
		t.Errorf("patient should receive consultation completed notification")
	}

	medicineReadyNotif := &models.Notification{
		UserID:    &patientID,
		Role:      "patient",
		Title:     "Pesanan Obat: Ready",
		Message:   "Pesanan obat Anda telah selesai diracik oleh apoteker dan siap diambil/dikirim.",
		Type:      "order",
		ActionURL: "/orders",
	}
	if !hub.shouldSend(patientClient, medicineReadyNotif) {
		t.Errorf("patient should receive medicine ready notification")
	}
}

func TestNotificationWorkflow_PharmacistAndAdmin(t *testing.T) {
	hub := &notificationHub{}
	pharmacistClient := &NotificationClient{UserID: 3, Role: "pharmacist"}
	adminClient := &NotificationClient{UserID: 1, Role: "admin"}

	eResepNotif := &models.Notification{
		Role:      "pharmacist",
		Title:     "E-Resep Baru Diterbitkan",
		Message:   "Dokter telah menerbitkan E-Resep baru untuk pasien.",
		Type:      "prescription",
		ActionURL: "/dashboard/prescriptions",
	}
	if !hub.shouldSend(pharmacistClient, eResepNotif) {
		t.Errorf("pharmacist should receive new e-resep notification")
	}

	emergencyNotif := &models.Notification{
		Role:      "admin",
		Title:     "Panggilan Darurat Baru",
		Message:   "Permintaan ambulans darurat baru telah diterima.",
		Type:      "emergency",
		ActionURL: "/dashboard/emergencies",
	}
	if !hub.shouldSend(adminClient, emergencyNotif) {
		t.Errorf("admin should receive emergency notification")
	}
}
