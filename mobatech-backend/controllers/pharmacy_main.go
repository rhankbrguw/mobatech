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
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", cats))
}

func (c *PharmacyController) GetMedicines(ctx *gin.Context) {
	catIDStr := ctx.Query("category_id")
	search := ctx.Query("search")

	var catID uint
	if catIDStr != "" {
		parsed, err := strconv.Atoi(catIDStr)
		if err != nil {
			ctx.Error(utils.NewValidationError("Invalid parsed parameter"))
			return
		}
		catID = uint(parsed)
	}

	page, err := strconv.Atoi(ctx.DefaultQuery(constants.QueryParamPage, constants.PaginationDefaultPage))
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid page parameter"))
		return
	}
	limit, err := strconv.Atoi(ctx.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit))
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid limit parameter"))
		return
	}
	offset := (page - 1) * limit

	meds, totalCount, err := c.service.GetAllMedicines(ctx.Request.Context(), catID, search, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", meds, page, limit, totalCount))
}

func (c *PharmacyController) GetMedicineDetail(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	med, err := c.service.GetMedicineByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgMedicineNotFound, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", med))
}
