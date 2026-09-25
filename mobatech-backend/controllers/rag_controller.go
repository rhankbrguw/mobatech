package controllers

import (
	"backend/services"
	"backend/utils"
	"net/http"

	"github.com/gin-gonic/gin"
)

type RAGController struct {
	ragClient services.RAGClient
}

func NewRAGController(ragClient services.RAGClient) *RAGController {
	if ragClient == nil {
		ragClient = services.NewRAGClient("", nil)
	}
	return &RAGController{ragClient: ragClient}
}

func (c *RAGController) TriggerManualSync(ctx *gin.Context) {
	if err := c.ragClient.TriggerSync(ctx.Request.Context()); err != nil {
		ctx.Error(utils.NewInternalError("Gagal terhubung ke layanan sinkronisasi RAG Python."))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Sinkronisasi Vector DB selesai!", map[string]interface{}{"status": "success"}))
}

func (c *RAGController) GetRAGStatus(ctx *gin.Context) {
	status, err := c.ragClient.GetStatus(ctx.Request.Context())
	if err != nil {
		ctx.Error(utils.NewInternalError("Gagal terhubung ke layanan sinkronisasi RAG Python."))
		return
	}

	var payload interface{}
	if val, ok := status["data"]; ok {
		payload = val
	} else {
		payload = status
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", payload))
}
