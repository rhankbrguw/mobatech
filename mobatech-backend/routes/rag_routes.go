package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/middleware"
	"backend/services"

	"github.com/gin-gonic/gin"
)

func SetupRAGRoutes(r *gin.Engine, ragClient services.RAGClient) {
	ragController := controllers.NewRAGController(ragClient)
	r.POST(constants.RouteApiAdminRagSync, middleware.AdminMiddleware(), ragController.TriggerManualSync)
	r.GET(constants.RouteApiAdminRagStatus, middleware.AdminMiddleware(), ragController.GetRAGStatus)
}
