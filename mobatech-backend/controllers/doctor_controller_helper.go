package controllers

import (
	"backend/constants"
	"backend/models"
	"backend/utils"
	"strconv"

	"github.com/gin-gonic/gin"
)

func parseDoctorQueryParams(ctx *gin.Context) (string, string, string, uint, int, int, int, error) {
	search := ctx.Query(constants.QUERY_PARAM_SEARCH)
	filter := ctx.Query(constants.QUERY_PARAM_FILTER)
	specialization := ctx.Query("specialization")
	polyID, err := strconv.ParseUint(ctx.DefaultQuery("polyclinic_id", "0"), 10, 32)
	if err != nil {
		return "", "", "", 0, 0, 0, 0, utils.NewValidationError("Invalid polyclinicID parameter")
	}
	polyclinicID := uint(polyID)
	page, err := strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_PAGE, constants.PAGINATION_DEFAULT_PAGE))
	if err != nil {
		return "", "", "", 0, 0, 0, 0, utils.NewValidationError("Invalid page parameter")
	}
	if page < 1 {
		page = 1
	}
	limit, err := strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_LIMIT, constants.PAGINATION_DEFAULT_LIMIT))
	if err != nil {
		return "", "", "", 0, 0, 0, 0, utils.NewValidationError("Invalid limit parameter")
	}
	offset := (page - 1) * limit
	return search, filter, specialization, polyclinicID, page, limit, offset, nil
}

func parseContextUserID(val interface{}) uint {
	switch v := val.(type) {
	case float64:
		return uint(v)
	case uint:
		return v
	case int:
		return uint(v)
	default:
		return 0
	}
}

func checkDoctorOwnership(ctx *gin.Context, doc *models.Doctor) bool {
	roleVal, _ := ctx.Get("role")
	role, _ := roleVal.(string)
	if role != constants.RoleDoctor {
		return true
	}
	userIDVal, exists := ctx.Get("user_id")
	if !exists || doc == nil || doc.UserID == nil {
		return false
	}
	return *doc.UserID == parseContextUserID(userIDVal)
}
