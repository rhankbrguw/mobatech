package constants

import "time"

const (
	DefaultPort            = ":8080"
	DefaultUploadsDir      = "uploads"
	DefaultUploadURL       = "http://127.0.0.1:8080/uploads/"
	JWTExpirationTime      = time.Hour * 72
	PaginationDefaultPage  = "1"
	PaginationDefaultLimit = "10"
	QueryParamPage         = "page"
	QueryParamLimit        = "limit"
)
