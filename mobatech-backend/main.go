package main

import (
	"backend/config"
	"backend/constants"
	"backend/cron"
	"backend/middleware"
	"backend/routes"
	"log"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	config.ConnectDatabase()
	cron.StartScheduleExpirationCron(config.DB)
	if err := os.MkdirAll(constants.DefaultUploadsDir, 0750); err != nil {
		log.Printf("Warning: Failed to create uploads directory: %v", err)
	}

	r := setupServer()

	port := os.Getenv("PORT")
	if port == "" {
		port = constants.DefaultPort
	} else {
		port = ":" + port
	}
	_ = r.Run(port)
}

func setupServer() *gin.Engine {
	r := gin.Default()
	r.Use(middleware.ErrorHandler())
	corsConfig := cors.DefaultConfig()
	corsConfig.AllowAllOrigins = true
	corsConfig.AllowHeaders = []string{"Origin", "Content-Length", "Content-Type", "Authorization"}
	r.Use(cors.New(corsConfig))

	routes.SetupMiscRoutes(r)
	routes.SetupBranchRoutes(r, config.DB)
	routes.SetupAuthRoutes(r, config.DB)
	routes.SetupChatRoutes(r, config.DB)
	routes.SetupHospitalServiceRoutes(r, config.DB)
	routes.SetupEmergencyRoutes(r, config.DB)
	routes.SetupPharmacyRoutes(r, config.DB)
	routes.SetupDoctorRoutes(r, config.DB)
	routes.SetupPolyclinicRoutes(r, config.DB)
	routes.SetupPatientSupportRoutes(r, config.DB)
	routes.SetupForYouRoutes(r, config.DB)
	routes.SetupPromoRoutes(r, config.DB)
	routes.SetupRAGRoutes(r)

	return r
}
