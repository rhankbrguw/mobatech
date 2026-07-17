package routes

import (
	"backend/constants"
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

	api := router.Group(constants.RouteApi)
	setupPublicDoctorRoutes(api, h)
	setupProtectedDoctorRoutes(api, h)
	setupAdminDoctorRoutes(api, h)
}

func setupPublicDoctorRoutes(api *gin.RouterGroup, h *doctorRouteHandlers) {
	api.GET(constants.RouteDoctors, h.docCtrl.GetDoctors)
	api.GET(constants.RouteDoctorsParamId, h.docCtrl.GetDoctorByID)
	api.GET(constants.RouteDoctorsParamIdSchedules, h.schCtrl.GetDoctorSchedules)
}

func setupProtectedDoctorRoutes(api *gin.RouterGroup, h *doctorRouteHandlers) {
	protected := api.Group(constants.RouteRoot)
	protected.Use(middleware.AuthMiddleware())
	protected.GET(constants.RouteAppointments, h.apptCtrl.GetUserAppointments)
	protected.POST(constants.RouteAppointments, h.apptCtrl.BookAppointment)
	protected.POST(constants.RouteAppointmentsParamIdCancel, h.apptCtrl.CancelAppointment)
}

func setupAdminDoctorRoutes(api *gin.RouterGroup, h *doctorRouteHandlers) {
	admin := api.Group(constants.RouteAdmin)
	admin.Use(middleware.AdminMiddleware())

	admin.POST(constants.RouteDoctors, middleware.RequireRole("admin"), h.docCtrl.CreateDoctor)
	admin.PUT(constants.RouteDoctorsParamId, middleware.RequireRole("admin"), h.docCtrl.UpdateDoctor)
	admin.DELETE(constants.RouteDoctorsParamId, middleware.RequireRole("admin"), h.docCtrl.DeleteDoctor)

	admin.GET(constants.RouteSchedules, middleware.RequireRole("admin", "doctor"), h.schCtrl.GetAllSchedules)
	admin.POST(constants.RouteSchedules, middleware.RequireRole("admin", "doctor"), h.schCtrl.CreateSchedule)
	admin.PUT(constants.RouteSchedulesParamId, middleware.RequireRole("admin", "doctor"), h.schCtrl.UpdateSchedule)
	admin.DELETE(constants.RouteSchedulesParamId, middleware.RequireRole("admin", "doctor"), h.schCtrl.DeleteSchedule)

	admin.GET(constants.RouteAppointments, middleware.RequireRole("admin", "doctor"), h.apptCtrl.GetAllAppointments)
	admin.POST(constants.RouteAppointmentsParamIdApprove, middleware.RequireRole("doctor"), h.apptCtrl.ApproveAppointment)
	admin.POST(constants.RouteAppointmentsParamIdComplete, middleware.RequireRole("doctor"), h.apptCtrl.CompleteAppointment)
	admin.POST(constants.RouteAppointmentsParamIdCancel, middleware.RequireRole("admin", "doctor"), h.apptCtrl.AdminCancelAppointment)
}
