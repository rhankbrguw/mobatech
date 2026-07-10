package controllers

import (
	"backend/constants"
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
	var req struct {
		FullName    string `json:"full_name" binding:"required"`
		Email       string `json:"email" binding:"required,email"`
		PhoneNumber string `json:"phone_number" binding:"required"`
		Password    string `json:"password" binding:"required,min=6"`
	}
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
	var req struct {
		Email    string `json:"email" binding:"required,email"`
		Password string `json:"password" binding:"required"`
	}
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

	page, _ := strconv.Atoi(ctx.DefaultQuery(constants.QueryParamPage, constants.PaginationDefaultPage))
	limit, _ := strconv.Atoi(ctx.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit))
	offset := (page - 1) * limit

	users, totalCount, err := c.service.GetAllUsers(ctx.Request.Context(), search, filter, roleFilter, viewerID, viewerRole, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", users, page, limit, totalCount))
}
func (c *AuthController) AdminCreateUser(ctx *gin.Context) {
	var req struct {
		FullName    string `json:"full_name" binding:"required"`
		Email       string `json:"email" binding:"required,email"`
		PhoneNumber string `json:"phone_number" binding:"required"`
		Password    string `json:"password" binding:"required,min=6"`
		Role        string `json:"role" binding:"required"`
		ImageURL    string `json:"image_url"`
	}
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
	id, _ := strconv.ParseUint(idStr, 10, 32)
	var req struct {
		FullName    string `json:"full_name"`
		Email       string `json:"email"`
		PhoneNumber string `json:"phone_number"`
		Role        string `json:"role"`
		ImageURL    string `json:"image_url"`
	}
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
	id, _ := strconv.ParseUint(idStr, 10, 32)
	if err := c.service.DeleteUser(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
