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

type ScheduleController struct {
	scheduleService services.ScheduleService
}

func NewScheduleController(scheduleService services.ScheduleService) *ScheduleController {
	return &ScheduleController{scheduleService}
}

func (c *ScheduleController) GetDoctorSchedules(ctx *gin.Context) {
	doctorID, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid doctorID parameter"))
		return
	}
	schedules, err := c.scheduleService.GetDoctorSchedules(ctx.Request.Context(), uint(doctorID))
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", schedules))
}

func (c *ScheduleController) GetAllSchedules(ctx *gin.Context) {
	limit, err := strconv.Atoi(ctx.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit))
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid limit parameter"))
		return
	}
	schedules, err := c.scheduleService.GetUpcomingSchedules(ctx.Request.Context(), limit)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", schedules))
}

func (c *ScheduleController) CreateSchedule(ctx *gin.Context) {
	var input models.DoctorSchedule
	if err := ctx.ShouldBindJSON(&input); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if input.Quota < 10 {
		ctx.Error(utils.NewValidationError("Minimum quota/pasien adalah 10"))
		return
	}

	if err := c.scheduleService.CreateSchedule(ctx.Request.Context(), &input); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", input))
}

func (c *ScheduleController) UpdateSchedule(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	var input models.DoctorSchedule
	if err := ctx.ShouldBindJSON(&input); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if input.Quota > 0 && input.Quota < 10 {
		ctx.Error(utils.NewValidationError("Minimum quota/pasien adalah 10"))
		return
	}

	schedule, err := c.scheduleService.UpdateSchedule(ctx.Request.Context(), uint(id), &input)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", schedule))
}

func (c *ScheduleController) DeleteSchedule(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	if err := c.scheduleService.DeleteSchedule(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
