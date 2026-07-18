package controllers

import (
	"backend/models"
	"backend/services"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

type PolyclinicController struct {
	service services.PolyclinicService
}

func NewPolyclinicController(service services.PolyclinicService) *PolyclinicController {
	return &PolyclinicController{service}
}

func (c *PolyclinicController) GetPolyclinics(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")

	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	polys, totalCount, err := c.service.GetAllPolyclinics(ctx.Request.Context(), search, filter, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", polys, page, limit, totalCount))
}

func (c *PolyclinicController) GetPolyclinicByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	poly, err := c.service.GetPolyclinicByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, "Polyclinic not found", nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", poly))
}

func (c *PolyclinicController) CreatePolyclinic(ctx *gin.Context) {
	var req models.Polyclinic
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	if err := c.service.CreatePolyclinic(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", req))
}

func (c *PolyclinicController) UpdatePolyclinic(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	var req models.Polyclinic
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	req.ID = uint(id)
	if err := c.service.UpdatePolyclinic(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", req))
}

func (c *PolyclinicController) DeletePolyclinic(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	if err := c.service.DeletePolyclinic(ctx.Request.Context(), uint(id)); err != nil {
		if err.Error() == "Tidak bisa menghapus poliklinik karena masih ada dokter yang terdaftar di dalamnya. Pindahkan dokternya terlebih dahulu." {
			ctx.Error(utils.NewAppError(utils.ErrConflict, http.StatusConflict, err.Error(), nil))
			return
		}
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
