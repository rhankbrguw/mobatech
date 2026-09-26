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

type HospitalServiceController struct {
	service services.HospitalServiceService
}

func NewHospitalServiceController(service services.HospitalServiceService) *HospitalServiceController {
	return &HospitalServiceController{service}
}

func (c *HospitalServiceController) GetAll(ctx *gin.Context) {
	search := ctx.Query(constants.QUERY_PARAM_SEARCH)
	filter := ctx.Query(constants.QUERY_PARAM_FILTER)
	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}
	services, totalCount, err := c.service.GetAll(ctx.Request.Context(), search, filter, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", services, page, limit, totalCount))
}

func (c *HospitalServiceController) GetByID(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	service, err := c.service.GetByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgServiceNotFound, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", service))
}

func (c *HospitalServiceController) Create(ctx *gin.Context) {
	var req models.HospitalService
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := c.service.Create(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusCreated, utils.BuildSuccess("CREATED", "Resource created successfully", req))
}

func (c *HospitalServiceController) Update(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	service, err := c.service.GetByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgServiceNotFound, nil))
		return
	}

	if err := ctx.ShouldBindJSON(&service); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := c.service.Update(ctx.Request.Context(), service); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", service))
}

func (c *HospitalServiceController) Delete(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	if err := c.service.Delete(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
