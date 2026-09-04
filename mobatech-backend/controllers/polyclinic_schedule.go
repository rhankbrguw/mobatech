package controllers

import (
	"backend/models"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (c *PolyclinicController) CreateSchedule(ctx *gin.Context) {
	polyID, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid polyID parameter"))
		return
	}
	var req models.PolyclinicSchedule
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	req.PolyclinicID = uint(polyID)
	if err := c.service.CreateSchedule(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", req))
}

func (c *PolyclinicController) UpdateSchedule(ctx *gin.Context) {
	schedID, err := strconv.ParseUint(ctx.Param("sched_id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid schedID parameter"))
		return
	}
	var req models.PolyclinicSchedule
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	req.ID = uint(schedID)
	if err := c.service.UpdateSchedule(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", req))
}

func (c *PolyclinicController) DeleteSchedule(ctx *gin.Context) {
	schedID, err := strconv.ParseUint(ctx.Param("sched_id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid schedID parameter"))
		return
	}
	if err := c.service.DeleteSchedule(ctx.Request.Context(), uint(schedID)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
