package controllers

import (
	"backend/constants"
	"backend/models"
	"backend/services"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type MedicalResultController struct {
	service services.MedicalResultService
}

func NewMedicalResultController(service services.MedicalResultService) *MedicalResultController {
	return &MedicalResultController{service}
}

func (c *MedicalResultController) GetAll(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")
	pageStr := ctx.DefaultQuery(constants.QueryParamPage, constants.PaginationDefaultPage)
	limitStr := ctx.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit)
	page, err := strconv.Atoi(pageStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid page parameter"))
		return
	}
	limit, err := strconv.Atoi(limitStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid limit parameter"))
		return
	}
	offset := (page - 1) * limit

	roleFloat, _ := ctx.Get("role")
	role := ""
	if roleFloat != nil {
		role = roleFloat.(string)
	}

	userIDFloat, _ := ctx.Get("user_id")
	userID := uint(0)
	if userIDFloat != nil {
		userID = uint(userIDFloat.(float64))
	}

	results, totalCount, err := c.service.GetAllMedicalResults(ctx.Request.Context(), search, filter, userID, role, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", results, page, limit, totalCount))
}

func (c *MedicalResultController) GetUserResults(ctx *gin.Context) {
	userIDFloat, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Unauthorized", nil))
		return
	}
	userID := uint(userIDFloat.(float64))

	results, err := c.service.GetUserMedicalResults(ctx.Request.Context(), userID)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", results))
}

func (c *MedicalResultController) GetByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	result, err := c.service.GetMedicalResultByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, err.Error(), nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", result))
}

func (c *MedicalResultController) Create(ctx *gin.Context) {
	role, exists := ctx.Get("role")
	if !exists || role != "doctor" {
		ctx.JSON(http.StatusForbidden, utils.BuildError(utils.ErrUnauthorized, "Aksi klinis ditolak. Hanya Dokter yang berhak menambah hasil medis.", nil))
		return
	}

	var req models.MedicalResult
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	result, err := c.service.CreateMedicalResult(ctx.Request.Context(), &req)
	if err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", result))
}

func (c *MedicalResultController) Update(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	var req models.MedicalResult
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	req.ID = uint(id)

	result, err := c.service.UpdateMedicalResult(ctx.Request.Context(), &req)
	if err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", result))
}

func (c *MedicalResultController) Delete(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	if err := c.service.DeleteMedicalResult(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
