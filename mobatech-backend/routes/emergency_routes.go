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

func SetupEmergencyRoutes(r *gin.Engine, db *gorm.DB) {
	repo := repositories.NewEmergencyRepository(db)
	service := services.NewEmergencyService(repo)
	controller := controllers.NewEmergencyController(service)
	trackingController := controllers.NewTrackingController(service)

	// WebSocket tracking route (no auth - WebSocket clients have trouble with auth headers)
	r.GET(constants.RouteApiEmergenciesParamIdTrack, trackingController.TrackAmbulance)

	// User Routes (Protected)
	userGroup := r.Group(constants.RouteApiEmergencies)
	userGroup.Use(middleware.AuthMiddleware())
	{
		userGroup.POST("", controller.SubmitRequest)
		userGroup.GET(constants.RouteHistory, controller.GetUserHistory)
	}

	// Admin Routes (Protected)
	adminGroup := r.Group(constants.RouteApiAdminEmergencies)
	adminGroup.Use(middleware.AdminMiddleware())
	{
		adminGroup.GET("", controller.GetAllAdmin)
		adminGroup.PUT(constants.RouteParamIdStatus, controller.UpdateStatusAdmin)
	}
}
