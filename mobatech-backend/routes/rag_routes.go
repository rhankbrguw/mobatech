package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/services"

	"github.com/gin-gonic/gin"
)

func SetupRAGRoutes(r *gin.Engine, ragClient services.RAGClient) {
	ragController := controllers.NewRAGController(ragClient)
	r.POST(constants.RouteApiAdminRagSync, ragController.TriggerManualSync)
	r.GET(constants.RouteApiAdminRagStatus, ragController.GetRAGStatus)
}
