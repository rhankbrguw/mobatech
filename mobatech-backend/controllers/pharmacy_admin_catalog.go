package controllers

import (
	"backend/constants"
	"backend/models"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (c *PharmacyController) AdminCreateCategory(ctx *gin.Context) {
	var cat models.MedicineCategory
	if err := ctx.ShouldBindJSON(&cat); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	if err := c.service.CreateCategory(ctx.Request.Context(), &cat); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusCreated, utils.BuildSuccess("CREATED", constants.MsgResourceCreated, cat))
}

func (c *PharmacyController) AdminUpdateCategory(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}

	var cat models.MedicineCategory
	if err := ctx.ShouldBindJSON(&cat); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	cat.ID = uint(id)

	if err := c.service.UpdateCategory(ctx.Request.Context(), &cat); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgSuccess, cat))
}

func (c *PharmacyController) AdminDeleteCategory(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}

	if err := c.service.DeleteCategory(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgSuccess, nil))
}

func (c *PharmacyController) AdminCreateMedicine(ctx *gin.Context) {
	var med models.Medicine
	if err := ctx.ShouldBindJSON(&med); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	if err := c.service.CreateMedicine(ctx.Request.Context(), &med); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusCreated, utils.BuildSuccess("CREATED", constants.MsgResourceCreated, med))
}

func (c *PharmacyController) AdminUpdateMedicine(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}

	var med models.Medicine
	if err := ctx.ShouldBindJSON(&med); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	med.ID = uint(id)

	if err := c.service.UpdateMedicine(ctx.Request.Context(), &med); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgSuccess, med))
}

func (c *PharmacyController) AdminDeleteMedicine(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}

	if err := c.service.DeleteMedicine(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgSuccess, nil))
}
