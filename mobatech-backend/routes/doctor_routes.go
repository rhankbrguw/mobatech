package routes

import (
	"backend/controllers"
	"backend/middleware"
	"backend/repositories"
	"backend/services"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type doctorRouteHandlers struct {
	docCtrl  *controllers.DoctorController
	schCtrl  *controllers.ScheduleController
	apptCtrl *controllers.AppointmentController
}

func SetupDoctorRoutes(router *gin.Engine, db *gorm.DB) {
	doctorRepo := repositories.NewDoctorRepository(db)
	scheduleRepo := repositories.NewScheduleRepository(db)
	appointmentRepo := repositories.NewAppointmentRepository(db)

	h := &doctorRouteHandlers{
		docCtrl:  controllers.NewDoctorController(services.NewDoctorService(doctorRepo)),
		schCtrl:  controllers.NewScheduleController(services.NewScheduleService(scheduleRepo)),
		apptCtrl: controllers.NewAppointmentController(services.NewAppointmentService(appointmentRepo, scheduleRepo)),
	}

	api := router.Group("/api")
	setupPublicDoctorRoutes(api, h)
	setupProtectedDoctorRoutes(api, h)
	setupAdminDoctorRoutes(api, h)
}

func setupPublicDoctorRoutes(api *gin.RouterGroup, h *doctorRouteHandlers) {
	api.GET("/doctors", h.docCtrl.GetDoctors)
	api.GET("/doctors/:id", h.docCtrl.GetDoctorByID)
	api.GET("/doctors/:id/schedules", h.schCtrl.GetDoctorSchedules)
}

func setupProtectedDoctorRoutes(api *gin.RouterGroup, h *doctorRouteHandlers) {
	protected := api.Group("/")
	protected.Use(middleware.AuthMiddleware())
	protected.GET("/appointments", h.apptCtrl.GetUserAppointments)
	protected.POST("/appointments", h.apptCtrl.BookAppointment)
	protected.POST("/appointments/:id/cancel", h.apptCtrl.CancelAppointment)
}

func setupAdminDoctorRoutes(api *gin.RouterGroup, h *doctorRouteHandlers) {
	admin := api.Group("/admin")
	admin.Use(middleware.AdminMiddleware())
	
	admin.POST("/doctors", h.docCtrl.CreateDoctor)
	admin.PUT("/doctors/:id", h.docCtrl.UpdateDoctor)
	admin.DELETE("/doctors/:id", h.docCtrl.DeleteDoctor)

	admin.GET("/schedules", h.schCtrl.GetAllSchedules)
	admin.POST("/schedules", h.schCtrl.CreateSchedule)
	admin.PUT("/schedules/:id", h.schCtrl.UpdateSchedule)
	admin.DELETE("/schedules/:id", h.schCtrl.DeleteSchedule)

	admin.GET("/appointments", h.apptCtrl.GetAllAppointments)
	admin.POST("/appointments/:id/approve", h.apptCtrl.ApproveAppointment)
	admin.POST("/appointments/:id/complete", h.apptCtrl.CompleteAppointment)
	admin.POST("/appointments/:id/cancel", h.apptCtrl.AdminCancelAppointment)
}
