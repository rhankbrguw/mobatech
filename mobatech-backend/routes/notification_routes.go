package routes

import (
	"backend/controllers"
	"backend/middleware"
	"backend/repositories"
	"backend/services"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupNotificationRoutes(router *gin.Engine, db *gorm.DB) {
	repo := repositories.NewNotificationRepository(db)
	hub := services.GetNotificationHub()
	service := services.NewNotificationService(repo, hub)
	controller := controllers.NewNotificationController(service, hub)

	router.GET("/api/ws/notifications", controller.HandleWebSocket)
	router.GET("/ws/notifications", controller.HandleWebSocket)

	notifGroup := router.Group("/api/notifications")
	notifGroup.Use(middleware.AuthMiddleware())
	{
		notifGroup.GET("", controller.GetNotifications)
		notifGroup.GET("/unread-count", controller.GetUnreadCount)
		notifGroup.PUT("/:id/read", controller.MarkAsRead)
		notifGroup.PUT("/read-all", controller.MarkAllAsRead)
	}
}
