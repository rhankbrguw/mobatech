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

func SetupPatientSupportRoutes(r *gin.Engine, db *gorm.DB) {
	setupMedicalResultRoutes(r, db)
	setupReminderRoutes(r, db)
}

func setupMedicalResultRoutes(r *gin.Engine, db *gorm.DB) {
	mrRepo := repositories.NewMedicalResultRepository(db)
	mrController := controllers.NewMedicalResultController(services.NewMedicalResultService(mrRepo))

	mrUserGroup := r.Group(constants.RouteApiMedicalResults)
	mrUserGroup.Use(middleware.AuthMiddleware())
	mrUserGroup.GET("", mrController.GetUserResults)
	mrUserGroup.GET(constants.RouteParamId, mrController.GetByID)

	mrAdminGroup := r.Group(constants.RouteApiAdminMedicalResults)
	mrAdminGroup.Use(middleware.AdminMiddleware())
	mrAdminGroup.GET("", mrController.GetAll)
	mrAdminGroup.POST("", mrController.Create)
	mrAdminGroup.PUT(constants.RouteParamId, mrController.Update)
	mrAdminGroup.DELETE(constants.RouteParamId, mrController.Delete)
}

func setupReminderRoutes(r *gin.Engine, db *gorm.DB) {
	remRepo := repositories.NewReminderRepository(db)
	remController := controllers.NewReminderController(services.NewReminderService(remRepo))

	remUserGroup := r.Group(constants.RouteApiReminders)
	remUserGroup.Use(middleware.AuthMiddleware())
	remUserGroup.GET("", remController.GetUserReminders)
	remUserGroup.GET(constants.RouteUnreadCount, remController.GetUnreadCount)
	remUserGroup.PUT(constants.RouteParamIdRead, remController.MarkAsRead)

	remAdminGroup := r.Group(constants.RouteApiAdminReminders)
	remAdminGroup.Use(middleware.AdminMiddleware())
	remAdminGroup.GET("", remController.GetAll)
	remAdminGroup.POST("", remController.Create)
	remAdminGroup.DELETE(constants.RouteParamId, remController.Delete)
}
