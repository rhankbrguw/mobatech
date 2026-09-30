package controllers

import (
	"net/http"
	"strconv"

	"backend/constants"
	"backend/services"
	"backend/utils"

	"github.com/gin-gonic/gin"
)

type NotificationController struct {
	service services.NotificationService
	hub     services.NotificationHub
}

func NewNotificationController(service services.NotificationService, hub services.NotificationHub) *NotificationController {
	return &NotificationController{service: service, hub: hub}
}

func (c *NotificationController) getUserContext(ctx *gin.Context) (uint, string) {
	val, _ := ctx.Get("user_id")
	roleVal, _ := ctx.Get("role")
	role, _ := roleVal.(string)

	var userID uint
	if idFloat, ok := val.(float64); ok {
		userID = uint(idFloat)
	} else if idUint, ok := val.(uint); ok {
		userID = idUint
	}
	return userID, role
}

func (c *NotificationController) GetNotifications(ctx *gin.Context) {
	userID, role := c.getUserContext(ctx)
	unread := ctx.Query("unread") == "true"
	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		_ = ctx.Error(err)
		return
	}
	if customOffset := ctx.Query("offset"); customOffset != "" {
		if o, err := strconv.Atoi(customOffset); err == nil && o >= 0 {
			offset = o
		}
	}

	list, total, err := c.service.GetNotifications(ctx.Request.Context(), userID, role, unread, limit, offset)
	if err != nil {
		_ = ctx.Error(utils.NewAppError(utils.ErrInternal, http.StatusInternalServerError, err.Error(), nil))
		return
	}

	unreadCount, _ := c.service.GetUnreadCount(ctx.Request.Context(), userID, role)
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Notifications retrieved successfully", gin.H{
		"notifications": list,
		"total":         total,
		"page":          page,
		"limit":         limit,
		"unread_count":  unreadCount,
	}))
}

func (c *NotificationController) MarkAsRead(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		_ = ctx.Error(utils.NewValidationError(constants.ErrInvalidID.Error()))
		return
	}
	userID, role := c.getUserContext(ctx)
	if err := c.service.MarkAsRead(ctx.Request.Context(), uint(id), userID, role); err != nil {
		_ = ctx.Error(utils.NewAppError(utils.ErrInternal, http.StatusInternalServerError, err.Error(), nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Notification marked as read", nil))
}

func (c *NotificationController) MarkAllAsRead(ctx *gin.Context) {
	userID, role := c.getUserContext(ctx)
	if err := c.service.MarkAllAsRead(ctx.Request.Context(), userID, role); err != nil {
		_ = ctx.Error(utils.NewAppError(utils.ErrInternal, http.StatusInternalServerError, err.Error(), nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "All notifications marked as read", nil))
}

func (c *NotificationController) GetUnreadCount(ctx *gin.Context) {
	userID, role := c.getUserContext(ctx)
	count, err := c.service.GetUnreadCount(ctx.Request.Context(), userID, role)
	if err != nil {
		_ = ctx.Error(utils.NewAppError(utils.ErrInternal, http.StatusInternalServerError, err.Error(), nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Unread count retrieved", gin.H{"count": count}))
}
