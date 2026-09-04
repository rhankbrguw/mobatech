package cron

import (
	"context"
	"log"
	"sync"
	"time"

	"backend/models"
	"backend/services"

	"gorm.io/gorm"
)

var cronMapMutex sync.Mutex

// StartScheduleExpirationCron runs a background job to mark expired schedules as unavailable.
func StartScheduleExpirationCron(db *gorm.DB, ragClient services.RAGClient) {
	if ragClient == nil {
		ragClient = services.NewRAGClient("", nil)
	}
	ticker := time.NewTicker(30 * time.Minute)
	go func() {
		defer func() {
			if r := recover(); r != nil {
				log.Printf("Recovered from panic in schedule ticker: %v", r)
			}
		}()
		for {
			<-ticker.C
			runScheduleSweep(db, ragClient)
		}
	}()
	go func() {
		defer func() {
			if r := recover(); r != nil {
				log.Printf("Recovered from panic in nightly cron: %v", r)
			}
		}()
		runNightlyCron(db, ragClient)
	}()
}

func runNightlyCron(db *gorm.DB, ragClient services.RAGClient) {
	for {
		now := time.Now()
		next := time.Date(now.Year(), now.Month(), now.Day()+1, 0, 0, 0, 0, now.Location())
		time.Sleep(time.Until(next))
		if ragClient != nil {
			if err := ragClient.TriggerSync(context.Background()); err != nil {
				log.Printf("Warning: nightly RAG sync error: %v", err)
			}
		}
		db.Where("status = ? AND created_at < ?", "cancelled", now.AddDate(0, -1, 0)).Delete(&models.Appointment{})
	}
}

func runScheduleSweep(db *gorm.DB, ragClient services.RAGClient) {
	now := time.Now()
	expiredCount := sweepExpiredSchedules(db, now)
	releasedCount := releaseUnpaidBookings(db, now)
	if releasedCount > 0 {
		log.Printf("Schedule sweep released %d unpaid bookings", releasedCount)
	}

	if expiredCount > 0 {
		go func() {
			defer func() {
				if r := recover(); r != nil {
					log.Printf("Recovered from panic in RAG sync sweep: %v", r)
				}
			}()
			syncRAG(ragClient)
		}()
	}
}

func sweepExpiredSchedules(db *gorm.DB, now time.Time) int {
	var schedules []models.DoctorSchedule
	if err := db.Where("is_available = ?", true).Find(&schedules).Error; err != nil {
		return 0
	}

	expiredCount := 0
	for _, s := range schedules {
		scheduleEnd, errParse := parseScheduleEnd(s.Date, s.EndTime)

		if errParse == nil && now.After(scheduleEnd) {
			s.IsAvailable = false
			db.Save(&s)
			cronMapMutex.Lock()
			updates := map[string]interface{}{
				"status": "cancelled",
				"notes":  "Batal otomatis: Pasien tidak hadir hingga sesi praktik berakhir (No-Show)",
			}
			db.Model(&models.Appointment{}).
				Where("doctor_schedule_id = ? AND status IN ?", s.ID, []string{"pending", "approved"}).
				Updates(updates)
			cronMapMutex.Unlock()
			expiredCount++
		}
	}
	return expiredCount
}

func releaseUnpaidBookings(db *gorm.DB, now time.Time) int {
	thirtyMinsAgo := now.Add(-30 * time.Minute)
	var pendingAppointments []models.Appointment
	db.Where("status = ? AND created_at <= ?", "pending", thirtyMinsAgo).Find(&pendingAppointments)

	releasedCount := 0
	for _, appt := range pendingAppointments {
		cronMapMutex.Lock()
		updates := map[string]interface{}{
			"status": "cancelled",
			"notes":  "Batal otomatis: Waktu pembayaran/verifikasi habis (30 Menit)",
		}
		db.Model(&appt).Updates(updates)
		cronMapMutex.Unlock()

		db.Model(&models.DoctorSchedule{}).Where("id = ? AND booked > 0", appt.DoctorScheduleID).
			UpdateColumn("booked", gorm.Expr("booked - 1"))
		releasedCount++
	}
	return releasedCount
}

func syncRAG(ragClient services.RAGClient) {
	if ragClient != nil {
		if err := ragClient.TriggerSync(context.Background()); err != nil {
			log.Printf("Warning: failed to trigger RAG sync: %v", err)
		}
	}
}
