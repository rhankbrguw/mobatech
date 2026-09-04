package controllers

import (
	"bytes"
	"encoding/json"
	"mime/multipart"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"testing"

	"github.com/gin-gonic/gin"
	"backend/middleware"
)

func TestUploadController_UploadFile_MissingFile(t *testing.T) {
	gin.SetMode(gin.TestMode)
	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/api/upload", nil)
	r := gin.New()
	r.Use(middleware.ErrorHandler())
	ctrl := NewUploadController()
	r.POST("/api/upload", ctrl.UploadFile)
	r.ServeHTTP(w, req)

	if w.Code != http.StatusBadRequest {
		t.Fatalf("Expected status 400, got %d", w.Code)
	}

	var resp struct {
		Success bool   `json:"success"`
		Code    string `json:"code"`
		Message string `json:"message"`
		Errors  any    `json:"errors"`
		Meta    struct {
			Timestamp string `json:"timestamp"`
		} `json:"meta"`
	}

	if err := json.Unmarshal(w.Body.Bytes(), &resp); err != nil {
		t.Fatalf("Failed to unmarshal error response: %v", err)
	}

	if resp.Success != false || resp.Code != "VALIDATION_ERROR" || resp.Message != "No file uploaded" {
		t.Errorf("Unexpected error response envelope: %+v", resp)
	}
	if resp.Meta.Timestamp == "" {
		t.Errorf("Expected meta.timestamp to be populated")
	}
}

func TestUploadController_UploadFile_Success(t *testing.T) {
	gin.SetMode(gin.TestMode)
	_ = os.MkdirAll("uploads", 0755)
	defer os.RemoveAll("uploads")

	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	part, err := writer.CreateFormFile("file", "test.txt")
	if err != nil {
		t.Fatalf("Failed to create form file: %v", err)
	}
	_, _ = part.Write([]byte("hello test file"))
	writer.Close()

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodPost, "/api/upload", body)
	req.Header.Set("Content-Type", writer.FormDataContentType())
	r := gin.New()
	r.Use(middleware.ErrorHandler())
	ctrl := NewUploadController()
	r.POST("/api/upload", ctrl.UploadFile)
	r.ServeHTTP(w, req)

	if w.Code != http.StatusOK {
		t.Fatalf("Expected status 200, got %d, body: %s", w.Code, w.Body.String())
	}

	var resp struct {
		Success bool   `json:"success"`
		Code    string `json:"code"`
		Message string `json:"message"`
		Data    struct {
			URL string `json:"url"`
		} `json:"data"`
		Meta struct {
			Timestamp string `json:"timestamp"`
		} `json:"meta"`
	}

	if err := json.Unmarshal(w.Body.Bytes(), &resp); err != nil {
		t.Fatalf("Failed to unmarshal success response: %v", err)
	}

	if !resp.Success || resp.Code != "OK" || resp.Message != "File uploaded successfully" {
		t.Errorf("Unexpected success response envelope: %+v", resp)
	}
	if resp.Meta.Timestamp == "" {
		t.Errorf("Expected meta.timestamp to be populated")
	}

	// Clean up created upload file if any
	files, _ := filepath.Glob("uploads/*_test.txt")
	for _, f := range files {
		os.Remove(f)
	}
}
