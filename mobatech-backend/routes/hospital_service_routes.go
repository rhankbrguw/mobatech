package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/repositories"
	"backend/services"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupHospitalServiceRoutes(r *gin.Engine, db *gorm.DB) {
	repo := repositories.NewHospitalServiceRepository(db)
	service := services.NewHospitalServiceService(repo)
	controller := controllers.NewHospitalServiceController(service)

	// Public API for mobile
	publicGroup := r.Group(constants.RouteApiServices)
	{
		publicGroup.GET("", controller.GetAll)
		publicGroup.GET(constants.RouteParamId, controller.GetByID)
	}

	adminGroup := r.Group(constants.RouteApiAdminServices)
	{
		adminGroup.POST("", controller.Create)
		adminGroup.PUT(constants.RouteParamId, controller.Update)
		adminGroup.DELETE(constants.RouteParamId, controller.Delete)
	}
}
