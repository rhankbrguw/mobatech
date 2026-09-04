package routes

import (
	"backend/constants"
	"backend/controllers"

	"github.com/gin-gonic/gin"
)

func SetupMiscRoutes(r *gin.Engine) {
	r.Static("/uploads", "./uploads")

	uploadCtrl := controllers.NewUploadController()
	healthCtrl := controllers.NewHealthController()

	r.POST(constants.RouteApiUpload, uploadCtrl.UploadFile)
	r.GET(constants.RoutePing, healthCtrl.Ping)
}
