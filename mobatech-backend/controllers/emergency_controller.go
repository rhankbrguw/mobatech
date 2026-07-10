package controllers

import (
	"backend/constants"
	"backend/models"
	"backend/services"
	"backend/utils"
	"net/http"
	"strconv"
	"time"

	"github.com/gin-gonic/gin"
)

type EmergencyController struct {
	service services.EmergencyService
}

func NewEmergencyController(service services.EmergencyService) *EmergencyController {
	return &EmergencyController{service}
}

func (c *EmergencyController) SubmitRequest(ctx *gin.Context) {
	var req models.EmergencyRequest
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	req.UserID = uint(userID.(float64))

	if err := c.service.CreateRequest(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	// Auto-dispatch after 3 seconds in a background goroutine
	go func(emergencyID uint) {
		time.Sleep(3 * time.Second)
		_ = c.service.UpdateStatus(ctx.Request.Context(), emergencyID, "Dispatched")
	}(req.ID)

	ctx.JSON(http.StatusCreated, utils.BuildSuccess("CREATED", "Resource created successfully", req))
}

func (c *EmergencyController) GetUserHistory(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}

	history, err := c.service.GetHistoryByUser(ctx.Request.Context(), uint(userID.(float64)))
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", history))
}

func (c *EmergencyController) GetAllAdmin(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")
	pageStr := ctx.DefaultQuery(constants.QueryParamPage, constants.PaginationDefaultPage)
	limitStr := ctx.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit)
	page, _ := strconv.Atoi(pageStr)
	limit, _ := strconv.Atoi(limitStr)
	offset := (page - 1) * limit
	reqs, totalCount, err := c.service.GetAllRequests(ctx.Request.Context(), search, filter, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", reqs, page, limit, totalCount))
}

func (c *EmergencyController) UpdateStatusAdmin(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, _ := strconv.Atoi(idStr)

	var req struct {
		Status string `json:"status"`
	}
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := c.service.UpdateStatus(ctx.Request.Context(), uint(id), req.Status); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
