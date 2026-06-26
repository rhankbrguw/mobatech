package routes

import (
	"backend/controllers"

	"github.com/gin-gonic/gin"
)

func SetupRAGRoutes(r *gin.Engine) {
	ragController := controllers.NewRAGController()
	r.POST("/api/admin/rag/sync", ragController.TriggerManualSync)
	r.GET("/api/admin/rag/status", ragController.GetRAGStatus)
}
