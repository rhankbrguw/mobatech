package controllers

import (
	"backend/constants"
	"backend/services"
	"backend/utils"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type ChatController struct {
	service services.ChatService
}

func NewChatController(service services.ChatService) *ChatController {
	return &ChatController{service}
}
func (c *ChatController) CreateSession(ctx *gin.Context) {
	var req struct {
		Title string `json:"title"`
	}
	if err := ctx.BindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	userIDStr, _ := ctx.Get("user_id")
	userID := fmt.Sprintf("%v", userIDStr)
	session, err := c.service.CreateSession(ctx.Request.Context(), userID, req.Title)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", session))
}
func (c *ChatController) GetUserSessions(ctx *gin.Context) {
	userIDStr, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	userID := fmt.Sprintf("%v", userIDStr)
	sessions, err := c.service.GetUserSessions(ctx.Request.Context(), userID)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", sessions))
}
func (c *ChatController) GetSessionMessages(ctx *gin.Context) {
	sessionID, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("invalid session id"))
		return
	}
	messages, err := c.service.GetSessionMessages(ctx.Request.Context(), uint(sessionID))
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", messages))
}
func (c *ChatController) DeleteSession(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	sessionID, _ := strconv.Atoi(ctx.Param("id"))
	err := c.service.DeleteSession(ctx.Request.Context(), uint(userID.(float64)), uint(sessionID))
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
func (c *ChatController) RenameSession(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	sessionID, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.Error(utils.NewValidationError("invalid session id"))
		return
	}
	var req struct {
		Title string `json:"title"`
	}
	if err := ctx.BindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	err = c.service.RenameSession(ctx.Request.Context(), uint(userID.(float64)), uint(sessionID), req.Title)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
func (c *ChatController) GetAllSessions(ctx *gin.Context) {
	search := ctx.Query("search")
	pageStr := ctx.DefaultQuery(constants.QueryParamPage, constants.PaginationDefaultPage)
	limitStr := ctx.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit)
	page, _ := strconv.Atoi(pageStr)
	limit, _ := strconv.Atoi(limitStr)
	offset := (page - 1) * limit
	sessions, totalCount, err := c.service.GetAllSessions(ctx.Request.Context(), search, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", sessions, page, limit, totalCount))
}
