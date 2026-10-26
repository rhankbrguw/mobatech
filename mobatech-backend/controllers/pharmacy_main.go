package controllers

import (
	"backend/constants"
	"backend/services"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type PharmacyController struct {
	service services.PharmacyService
}

func NewPharmacyController(service services.PharmacyService) *PharmacyController {
	return &PharmacyController{service}
}

func (c *PharmacyController) GetCategories(ctx *gin.Context) {
	cats, err := c.service.GetAllCategories(ctx.Request.Context())
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgSuccess, cats))
}

func parseGetMedicinesParams(ctx *gin.Context) (uint, string, int, int, int, error) {
	catIDStr := ctx.Query("category_id")
	search := ctx.Query(constants.QUERY_PARAM_SEARCH)

	var catID uint
	if catIDStr != "" {
		parsed, err := strconv.Atoi(catIDStr)
		if err != nil {
			return 0, "", 0, 0, 0, utils.NewValidationError("Invalid parsed parameter")
		}
		catID = uint(parsed)
	}

	page, err := strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_PAGE, constants.PAGINATION_DEFAULT_PAGE))
	if err != nil {
		return 0, "", 0, 0, 0, utils.NewValidationError(constants.MsgInvalidPageParam)
	}
	limit, err := strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_LIMIT, constants.PAGINATION_DEFAULT_LIMIT))
	if err != nil {
		return 0, "", 0, 0, 0, utils.NewValidationError(constants.MsgInvalidLimitParam)
	}
	offset := (page - 1) * limit
	return catID, search, page, limit, offset, nil
}

func (c *PharmacyController) GetMedicines(ctx *gin.Context) {
	catID, search, page, limit, offset, err := parseGetMedicinesParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	meds, totalCount, err := c.service.GetAllMedicines(ctx.Request.Context(), catID, search, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess(constants.MsgSuccess, meds, page, limit, totalCount))
}

func (c *PharmacyController) GetMedicineDetail(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}

	med, err := c.service.GetMedicineByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgMedicineNotFound, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgSuccess, med))
}
