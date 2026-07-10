package routes

import (
	"backend/constants"
	"backend/controllers"

	"github.com/gin-gonic/gin"
)

func SetupRAGRoutes(r *gin.Engine) {
	ragController := controllers.NewRAGController()
	r.POST(constants.RouteApiAdminRagSync, ragController.TriggerManualSync)
	r.GET(constants.RouteApiAdminRagStatus, ragController.GetRAGStatus)
}
