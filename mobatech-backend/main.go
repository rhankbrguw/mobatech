package main

import (
	"backend/config"
	"backend/constants"
	"backend/cron"
	"backend/middleware"
	"backend/routes"
	"backend/services"
	"backend/utils"
	"log"
	"os"

	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func main() {
	config.ConnectDatabase()
	constants.InitConfig()

	ragClient := services.NewRAGClient("", nil)
	utils.SetRAGSyncTriggerer(ragClient)

	cron.StartScheduleExpirationCron(config.DB, ragClient)
	if err := os.MkdirAll(constants.DEFAULT_UPLOADS_DIR, 0750); err != nil {
		log.Printf("Warning: failed to create uploads dir: %v", err)
	}

	r := setupServer(ragClient)

	port := os.Getenv("PORT")
	if port == "" {
		port = constants.DEFAULT_PORT
	} else {
		port = ":" + port
	}
	if err := r.Run(port); err != nil {
		log.Fatalf("Server failed to run: %v", err)
	}
}

func setupServer(ragClient services.RAGClient) *gin.Engine {
	r := gin.Default()
	r.Use(middleware.ErrorHandler())
	corsConfig := cors.DefaultConfig()
	corsConfig.AllowOrigins = []string{"http://localhost:3000", "http://localhost:8080"} // Restricted origins
	corsConfig.AllowHeaders = []string{"Origin", "Content-Length", "Content-Type", "Authorization"}
	r.Use(cors.New(corsConfig))

	routes.SetupMiscRoutes(r)
	routes.SetupBranchRoutes(r, config.DB)
	routes.SetupAuthRoutes(r, config.DB)
	routes.SetupChatRoutes(r, config.DB, ragClient)
	routes.SetupHospitalServiceRoutes(r, config.DB)
	routes.SetupEmergencyRoutes(r, config.DB)
	routes.SetupPharmacyRoutes(r, config.DB)
	routes.SetupDoctorRoutes(r, config.DB, ragClient)
	routes.SetupPolyclinicRoutes(r, config.DB)
	routes.SetupPatientSupportRoutes(r, config.DB)
	routes.SetupForYouRoutes(r, config.DB)
	routes.SetupPromoRoutes(r, config.DB)
	routes.SetupRAGRoutes(r, ragClient)

	return r
}
