package controllers

import (
	"backend/config"
	"backend/services"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (c *AppointmentController) AdminCancelAppointment(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		_ = ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	var req struct {
		Reason string `json:"reason"`
	}
	_ = ctx.ShouldBindJSON(&req)

	roleFloat, _ := ctx.Get("role")
	role := "admin"
	if roleFloat != nil {
		role = roleFloat.(string)
	}

	appointment, err := c.appointmentService.CancelAppointment(ctx.Request.Context(), uint(id), 0, role, req.Reason)
	if err != nil {
		_ = ctx.Error(utils.FormatValidationError(err))
		return
	}

	services.NotifyAppointmentCancelled(config.DB, appointment, role, req.Reason)
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *AppointmentController) ApproveAppointment(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		_ = ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	appointment, err := c.appointmentService.ApproveAppointment(ctx.Request.Context(), uint(id))
	if err != nil {
		_ = ctx.Error(utils.FormatValidationError(err))
		return
	}

	services.NotifyAppointmentApproved(config.DB, appointment)
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *AppointmentController) CompleteAppointment(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		_ = ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	appointment, err := c.appointmentService.CompleteAppointment(ctx.Request.Context(), uint(id))
	if err != nil {
		_ = ctx.Error(utils.FormatValidationError(err))
		return
	}

	services.NotifyAppointmentCompleted(config.DB, appointment)
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
