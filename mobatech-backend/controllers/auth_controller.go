package controllers

import (
	"backend/constants"
	"backend/controllers/dto"
	"backend/services"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type AuthController struct {
	service services.AuthService
}

func NewAuthController(service services.AuthService) *AuthController {
	return &AuthController{service}
}
func (c *AuthController) Register(ctx *gin.Context) {
	var req dto.RegisterReq
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	user, err := c.service.Register(ctx.Request.Context(), req.FullName, req.Email, req.PhoneNumber, req.Password)
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrConflict, http.StatusConflict, constants.MsgEmailConflict, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", user))
}
func (c *AuthController) Login(ctx *gin.Context) {
	var req dto.LoginReq
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	token, user, err := c.service.Login(ctx.Request.Context(), req.Email, req.Password)
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgLoginFailed, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", gin.H{"token": token, "user": user}))
}
func (c *AuthController) Me(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	user, err := c.service.GetUser(ctx.Request.Context(), uint(userID.(float64)))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgUserNotFound, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", user))
}
func (c *AuthController) GetAllUsers(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")
	roleFilter := ctx.Query("role")
	roleFloat, _ := ctx.Get("role")
	viewerRole := ""
	if roleFloat != nil {
		viewerRole = roleFloat.(string)
	}

	userIDFloat, _ := ctx.Get("user_id")
	viewerID := uint(0)
	if userIDFloat != nil {
		viewerID = uint(userIDFloat.(float64))
	}

	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	users, totalCount, err := c.service.GetAllUsers(ctx.Request.Context(), search, filter, roleFilter, viewerID, viewerRole, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", users, page, limit, totalCount))
}
func (c *AuthController) AdminCreateUser(ctx *gin.Context) {
	var req dto.AdminCreateUserReq
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	user, err := c.service.AdminCreateUser(ctx.Request.Context(), req.FullName, req.Email, req.PhoneNumber, req.Password, req.Role, req.ImageURL)
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrConflict, http.StatusConflict, constants.MsgCreateUserFailed, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", user))
}
func (c *AuthController) AdminUpdateUser(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	var req dto.AdminUpdateUserReq
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	user, err := c.service.AdminUpdateUser(ctx.Request.Context(), uint(id), req.FullName, req.Email, req.PhoneNumber, req.Role, req.ImageURL)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", user))
}
func (c *AuthController) AdminDeleteUser(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.ParseUint(idStr, 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	if err := c.service.DeleteUser(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
