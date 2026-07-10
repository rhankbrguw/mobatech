package cron

import (
	"backend/models"
	"log"
	"net/http"
	"sync"
	"time"

	"gorm.io/gorm"
)

var cronMapMutex sync.Mutex

// StartScheduleExpirationCron runs a background job to mark expired schedules as unavailable.
func StartScheduleExpirationCron(db *gorm.DB) {
	ticker := time.NewTicker(30 * time.Minute)
	go func() {
		for {
			<-ticker.C
			runScheduleSweep(db)
		}
	}()
	go runNightlyCron(db)
}

func runNightlyCron(db *gorm.DB) {
	for {
		now := time.Now()
		next := time.Date(now.Year(), now.Month(), now.Day()+1, 0, 0, 0, 0, now.Location())
		time.Sleep(time.Until(next))

		log.Println("[CRON] Executing Nightly 00:00 Tasks (RAG Sync & Garbage Collection)...")
		http.Post("http://localhost:8000/api/rag/sync", "application/json", nil)
		db.Where("status = ? AND created_at < ?", "cancelled", now.AddDate(0, -1, 0)).Delete(&models.Appointment{})
	}
}

func runScheduleSweep(db *gorm.DB) {
	now := time.Now()
	expiredCount := sweepExpiredSchedules(db, now)
	releasedCount := releaseUnpaidBookings(db, now)

	if releasedCount > 0 {
		log.Printf("ScheduleCron: Successfully released %d unpaid bookings.\n", releasedCount)
	}

	if expiredCount > 0 {
		log.Printf("ScheduleCron: Successfully marked %d expired schedules as unavailable.\n", expiredCount)
		go syncRAG()
	}
}

func sweepExpiredSchedules(db *gorm.DB, now time.Time) int {
	var schedules []models.DoctorSchedule
	if err := db.Where("is_available = ?", true).Find(&schedules).Error; err != nil {
		log.Println("ScheduleCron Error fetching schedules:", err)
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

func syncRAG() {
	resp, err := http.Post("http://localhost:8000/api/rag/sync", "application/json", nil)
	if err == nil {
		resp.Body.Close()
	}
}
