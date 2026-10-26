package utils

import (
	"github.com/go-playground/validator/v10"
	"net/http"
)

type AppError struct {
	Code    string
	Status  int
	Message string
	Errors  interface{}
}

func (e *AppError) Error() string {
	return e.Message
}

const (
	ErrValidation      = "VALIDATION_ERROR"
	ErrUnauthenticated = "UNAUTHENTICATED"
	ErrUnauthorized    = "UNAUTHORIZED"
	ErrNotFound        = "NOT_FOUND"
	ErrConflict        = "CONFLICT"
	ErrInternal        = "INTERNAL_ERROR"
)

func NewAppError(code string, status int, message string, errors interface{}) *AppError {
	return &AppError{
		Code:    code,
		Status:  status,
		Message: message,
		Errors:  errors,
	}
}

func NewValidationError(message string) *AppError {
	return NewAppError(ErrValidation, http.StatusUnprocessableEntity, message, map[string][]string{"general": {message}})
}

func NewInternalError(message string) *AppError {
	return NewAppError(ErrInternal, http.StatusInternalServerError, message, nil)
}

func FormatValidationError(err error) *AppError {
	if validationErrs, ok := err.(validator.ValidationErrors); ok {
		errorMap := make(map[string][]string)
		for _, e := range validationErrs {
			field := e.Field()
			msg := "Field validation for '" + field + "' failed on the '" + e.Tag() + "' tag"
			errorMap[field] = append(errorMap[field], msg)
		}
		return NewAppError(ErrValidation, http.StatusUnprocessableEntity, "The given data was invalid.", errorMap)
	}
	return NewValidationError(err.Error())
}
