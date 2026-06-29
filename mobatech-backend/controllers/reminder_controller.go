package controllers

import (
	"backend/models"
	"backend/services"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type ReminderController struct {
	service services.ReminderService
}

func NewReminderController(service services.ReminderService) *ReminderController {
	return &ReminderController{service}
}

func (c *ReminderController) GetAll(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")
	reminders, err := c.service.GetAllReminders(search, filter)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", reminders))
}

func (c *ReminderController) GetUserReminders(ctx *gin.Context) {
	userIDFloat, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Unauthorized"))
		return
	}
	userID := uint(userIDFloat.(float64))

	reminders, err := c.service.GetUserReminders(userID)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", reminders))
}

func (c *ReminderController) GetUnreadCount(ctx *gin.Context) {
	userIDFloat, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Unauthorized"))
		return
	}
	userID := uint(userIDFloat.(float64))

	count, err := c.service.GetUnreadCount(userID)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", gin.H{"data": gin.H{"count": count}}))
}

func (c *ReminderController) Create(ctx *gin.Context) {
	var req models.Reminder
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.NewValidationError(err.Error()))
		return
	}

	reminder, err := c.service.CreateReminder(&req)
	if err != nil {
		ctx.Error(utils.NewValidationError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", reminder))
}

func (c *ReminderController) MarkAsRead(ctx *gin.Context) {
	userIDFloat, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Unauthorized"))
		return
	}
	userID := uint(userIDFloat.(float64))

	id, _ := strconv.ParseUint(ctx.Param("id"), 10, 32)

	if err := c.service.MarkAsRead(uint(id), userID); err != nil {
		ctx.Error(utils.NewValidationError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *ReminderController) Delete(ctx *gin.Context) {
	id, _ := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err := c.service.DeleteReminder(uint(id)); err != nil {
		ctx.Error(utils.NewValidationError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
