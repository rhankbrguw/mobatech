package controllers

import (
	"backend/utils"
	"bytes"
	"encoding/json"
	"io"
	"net/http"

	"github.com/gin-gonic/gin"
)

type RAGController struct{}

func NewRAGController() *RAGController {
	return &RAGController{}
}

func (c *RAGController) TriggerManualSync(ctx *gin.Context) {
	url := "http://localhost:8000/api/rag/sync"
	resp, err := http.Post(url, "application/json", bytes.NewBuffer([]byte("{}")))
	if err != nil {
		ctx.Error(utils.NewInternalError("Gagal terhubung ke layanan sinkronisasi RAG Python."))
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		ctx.Error(utils.NewInternalError("Gagal membaca respon layanan sinkronisasi."))
		return
	}

	var result map[string]interface{}
	if err := json.Unmarshal(body, &result); err != nil {
		ctx.Error(utils.NewInternalError("Respon layanan sinkronisasi tidak valid."))
		return
	}

	successVal, ok := result["success"].(bool)
	if resp.StatusCode != http.StatusOK || (ok && !successVal) || result["status"] == "error" {
		ctx.JSON(http.StatusInternalServerError, utils.BuildError("INTERNAL_ERROR", "Gagal menyelaraskan database vektor.", result))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Sinkronisasi Vector DB selesai!", result))
}

func (c *RAGController) GetRAGStatus(ctx *gin.Context) {
	url := "http://localhost:8000/api/rag/status"
	resp, err := http.Get(url)
	if err != nil {
		ctx.Error(utils.NewInternalError("Gagal terhubung ke layanan sinkronisasi RAG Python."))
		return
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		ctx.Error(utils.NewInternalError("Gagal membaca respon status RAG."))
		return
	}

	var result map[string]interface{}
	if err := json.Unmarshal(body, &result); err != nil {
		ctx.Error(utils.NewInternalError("Respon status RAG tidak valid."))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", result["data"]))
}
