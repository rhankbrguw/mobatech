package routes

import (
	"backend/constants"
	"fmt"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func SetupMiscRoutes(r *gin.Engine) {
	r.Static("/uploads", "./uploads")

	r.POST(constants.RouteApiUpload, func(c *gin.Context) {
		file, err := c.FormFile("file")
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "No file uploaded"})
			return
		}
		filename := fmt.Sprintf("%d_%s", time.Now().Unix(), file.Filename)
		dst := "uploads/" + filename
		if err := c.SaveUploadedFile(file, dst); err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to save file"})
			return
		}
		c.JSON(http.StatusOK, gin.H{
			"url": "http://127.0.0.1:8080/uploads/" + filename,
		})
	})

	r.GET(constants.RoutePing, func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"message": "pong"})
	})
}
