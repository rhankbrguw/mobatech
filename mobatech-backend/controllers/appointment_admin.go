package controllers

import (
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (c *AppointmentController) AdminCancelAppointment(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	if err := c.appointmentService.CancelAppointment(ctx.Request.Context(), uint(id), 0, true); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *AppointmentController) ApproveAppointment(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	if err := c.appointmentService.ApproveAppointment(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *AppointmentController) CompleteAppointment(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	if err := c.appointmentService.CompleteAppointment(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
