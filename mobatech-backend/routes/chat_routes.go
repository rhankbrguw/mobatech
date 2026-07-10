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

func SetupChatRoutes(r *gin.Engine, db *gorm.DB) {
	repo := repositories.NewChatRepository(db)
	service := services.NewChatService(repo)
	controller := controllers.NewChatController(service)

	chatGroup := r.Group(constants.RouteApiChat)
	chatGroup.Use(middleware.AuthMiddleware())
	{
		chatGroup.GET(constants.RouteSessions, controller.GetUserSessions)
		chatGroup.POST(constants.RouteSessions, controller.CreateSession)
		chatGroup.GET(constants.RouteSessionsParamIdMessages, controller.GetSessionMessages)
		chatGroup.POST(constants.RouteSessionsParamIdStream, controller.StreamChat)
		chatGroup.PUT(constants.RouteSessionsParamId, controller.RenameSession)
		chatGroup.DELETE(constants.RouteSessionsParamId, controller.DeleteSession)
	}

	adminGroup := r.Group(constants.RouteApiAdmin)
	adminGroup.Use(middleware.AdminMiddleware())
	{
		adminGroup.GET(constants.RouteChats, controller.GetAllSessions)
	}
}
