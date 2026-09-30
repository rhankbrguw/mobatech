package services

import (
	"backend/models"
	"testing"
)

func TestNotificationHub_ShouldSend_TargetDoctorIsolation(t *testing.T) {
	hub := &notificationHub{}
	docA := &NotificationClient{UserID: 2, Role: "doctor"}
	docB := &NotificationClient{UserID: 5, Role: "doctor"}
	targetDocID := uint(2)

	notif := &models.Notification{
		UserID: &targetDocID,
		Role:   "doctor",
		Type:   "appointment",
		Title:  "Janji Temu Pasien Baru",
	}

	if !hub.shouldSend(docA, notif) {
		t.Errorf("expected docA (UserID 2) to receive notification, but got false")
	}
	if hub.shouldSend(docB, notif) {
		t.Errorf("expected docB (UserID 5) NOT to receive docA's notification, but got true")
	}
}

func TestNotificationHub_ShouldSend_AppointmentWithoutTargetBlocked(t *testing.T) {
	hub := &notificationHub{}
	doc := &NotificationClient{UserID: 2, Role: "doctor"}
	patient := &NotificationClient{UserID: 4, Role: "patient"}
	admin := &NotificationClient{UserID: 1, Role: "admin"}

	adminNotif := &models.Notification{
		Role:  "admin",
		Type:  "appointment",
		Title: "Janji Temu Baru Terdaftar",
	}

	if hub.shouldSend(doc, adminNotif) {
		t.Errorf("expected doctor NOT to receive admin appointment notification without target, but got true")
	}
	if hub.shouldSend(patient, adminNotif) {
		t.Errorf("expected patient NOT to receive admin appointment notification, but got true")
	}
	if !hub.shouldSend(admin, adminNotif) {
		t.Errorf("expected admin to receive admin appointment notification, but got false")
	}
}

func TestNotificationHub_ShouldSend_PatientTargetIsolation(t *testing.T) {
	hub := &notificationHub{}
	patientA := &NotificationClient{UserID: 4, Role: "patient"}
	patientB := &NotificationClient{UserID: 6, Role: "patient"}
	targetID := uint(4)

	notif := &models.Notification{
		UserID: &targetID,
		Role:   "patient",
		Type:   "appointment",
		Title:  "Konfirmasi Janji Temu",
	}

	if !hub.shouldSend(patientA, notif) {
		t.Errorf("expected patientA (UserID 4) to receive notification, but got false")
	}
	if hub.shouldSend(patientB, notif) {
		t.Errorf("expected patientB (UserID 6) NOT to receive patientA's notification, but got true")
	}
}
