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

func SetupForYouRoutes(r *gin.Engine, db *gorm.DB) {
	chatRepo := repositories.NewChatRepository(db)
	service := services.NewForYouService(chatRepo)
	controller := controllers.NewForYouController(service)

	group := r.Group(constants.RouteApiForYou)
	group.Use(middleware.AuthMiddleware())
	{
		group.GET(constants.RouteRecommendations, controller.GetRecommendations)
	}
}
