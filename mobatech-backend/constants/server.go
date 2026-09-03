package constants

import (
	"os"
	"time"
)

const (
	DEFAULT_PORT             = ":8080"
	DEFAULT_UPLOADS_DIR      = "uploads"
	JWT_EXPIRATION_TIME      = time.Hour * 72
	PAGINATION_DEFAULT_PAGE  = "1"
	PAGINATION_DEFAULT_LIMIT = "10"
	QUERY_PARAM_PAGE         = "page"
	QUERY_PARAM_LIMIT        = "limit"
	QUERY_PARAM_SEARCH       = "search"
	QUERY_PARAM_FILTER       = "filter"
	QUERY_PARAM_ROLE         = "role"
	QUERY_PARAM_USER_ID      = "user_id"

	RESPONSE_SUCCESS = "success"
	RESPONSE_CODE    = "code"
	RESPONSE_MESSAGE = "message"
	RESPONSE_DATA    = "data"
	RESPONSE_META    = "meta"
)

var (
	RAGBaseURL   = ""
	UploadURL    = ""
	GeminiAPIKey = ""
	GeminiModel  = ""
	JWTSecret    = ""
)

func InitConfig() {
	RAGBaseURL = os.Getenv("RAG_BASE_URL")
	UploadURL = os.Getenv("UPLOAD_BASE_URL")
	GeminiAPIKey = os.Getenv("GEMINI_API_KEY")

	GeminiModel = os.Getenv("GEMINI_MODEL")
	if GeminiModel == "" {
		GeminiModel = "gemini-2.5-flash"
	}

	JWTSecret = os.Getenv("JWT_SECRET")
}
