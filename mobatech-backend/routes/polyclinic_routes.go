package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/repositories"
	"backend/services"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupPolyclinicRoutes(router *gin.Engine, db *gorm.DB) {
	repo := repositories.NewPolyclinicRepository(db)
	service := services.NewPolyclinicService(repo)
	controller := controllers.NewPolyclinicController(service)

	api := router.Group(constants.RouteApi)

	api.GET(constants.RoutePolyclinics, controller.GetPolyclinics)
	api.GET(constants.RoutePolyclinicsParamId, controller.GetPolyclinicByID)

	// Admin endpoints
	admin := api.Group(constants.RouteAdmin)
	{
		admin.POST(constants.RoutePolyclinics, controller.CreatePolyclinic)
		admin.PUT(constants.RoutePolyclinicsParamId, controller.UpdatePolyclinic)
		admin.DELETE(constants.RoutePolyclinicsParamId, controller.DeletePolyclinic)

		admin.POST(constants.RoutePolyclinicsParamIdSchedules, controller.CreateSchedule)
		admin.PUT(constants.RoutePolyclinicsSchedulesParamSched_id, controller.UpdateSchedule)
		admin.DELETE(constants.RoutePolyclinicsSchedulesParamSched_id, controller.DeleteSchedule)
	}
}
