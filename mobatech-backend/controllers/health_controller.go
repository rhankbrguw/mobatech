package controllers

import (
	"backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

type HealthController struct{}

func NewHealthController() *HealthController {
	return &HealthController{}
}

func (ctrl *HealthController) Ping(c *gin.Context) {
	c.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", gin.H{"message": "pong"}))
}
