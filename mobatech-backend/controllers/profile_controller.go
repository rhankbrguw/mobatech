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

type ProfileController struct {
	service services.AuthService
}

func NewProfileController(service services.AuthService) *ProfileController {
	return &ProfileController{service}
}

func (c *ProfileController) UpdateProfile(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}

	req, err := parseProfileUpdateRequest(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	imagePath := handleImageUpload(ctx, userID.(float64))

	user, err := c.service.UpdateProfile(ctx.Request.Context(), uint(userID.(float64)), req.fullName, req.phone, imagePath, req.bloodType, req.height, req.weight, req.allergies, req.dob, req.gender)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", user))
}

func (c *ProfileController) AddFamilyMember(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}

	var req models.FamilyMember
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := utils.ValidateName(req.FullName, "Nama anggota keluarga"); err != nil {
		ctx.Error(err)
		return
	}

	req.UserID = uint(userID.(float64))
	if err := c.service.AddFamilyMember(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", gin.H{
		"message":       "Family member added successfully",
		"family_member": req,
	}))
}

func (c *ProfileController) DeleteFamilyMember(ctx *gin.Context) {
	_, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}

	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.ErrInvalidID.Error()))
		return
	}

	if err := c.service.DeleteFamilyMember(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", gin.H{
		"message": "Family member deleted successfully",
	}))
}
