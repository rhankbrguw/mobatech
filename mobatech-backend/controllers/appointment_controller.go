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

type AppointmentController struct {
	appointmentService services.AppointmentService
}

func NewAppointmentController(appointmentService services.AppointmentService) *AppointmentController {
	return &AppointmentController{appointmentService}
}

func (c *AppointmentController) GetAllAppointments(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")

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

	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	appointments, totalCount, err := c.appointmentService.GetAllAppointments(ctx.Request.Context(), search, filter, userID, role, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", appointments, page, limit, totalCount))
}

func (c *AppointmentController) GetUserAppointments(ctx *gin.Context) {
	userIDFloat, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	userID := uint(userIDFloat.(float64))

	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	appointments, totalCount, err := c.appointmentService.GetUserAppointments(ctx.Request.Context(), userID, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", appointments, page, limit, totalCount))
}

func (c *AppointmentController) BookAppointment(ctx *gin.Context) {
	userIDFloat, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	userID := uint(userIDFloat.(float64))

	var req models.Appointment
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	appointment, err := c.appointmentService.BookAppointment(ctx.Request.Context(), userID, &req)
	if err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", appointment))
}

func (c *AppointmentController) CancelAppointment(ctx *gin.Context) {
	userIDFloat, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	userID := uint(userIDFloat.(float64))

	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	if err := c.appointmentService.CancelAppointment(ctx.Request.Context(), uint(id), userID, false); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
