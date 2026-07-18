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

type DoctorController struct {
	doctorService services.DoctorService
}

func NewDoctorController(doctorService services.DoctorService) *DoctorController {
	return &DoctorController{doctorService}
}

func (c *DoctorController) GetDoctors(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")
	specialization := ctx.Query("specialization")
	polyclinicID, err := strconv.ParseUint(ctx.DefaultQuery("polyclinic_id", "0"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid polyclinicID parameter"))
		return
	}
	page, err := strconv.Atoi(ctx.DefaultQuery(constants.QueryParamPage, constants.PaginationDefaultPage))
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid page parameter"))
		return
	}
	if page < 1 {
		page = 1
	}
	limit, err := strconv.Atoi(ctx.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit))
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid limit parameter"))
		return
	}
	offset := (page - 1) * limit

	doctors, totalCount, err := c.doctorService.GetAllDoctors(ctx.Request.Context(), search, filter, specialization, uint(polyclinicID), limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", doctors, page, limit, totalCount))
}

func (c *DoctorController) GetDoctorByID(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	doctor, err := c.doctorService.GetDoctorByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgDoctorNotFound, nil))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", doctor))
}

func (c *DoctorController) CreateDoctor(ctx *gin.Context) {
	var doctor models.Doctor
	if err := ctx.ShouldBindJSON(&doctor); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := c.doctorService.CreateDoctor(ctx.Request.Context(), &doctor); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", doctor))
}

func (c *DoctorController) UpdateDoctor(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	var input models.Doctor
	if err := ctx.ShouldBindJSON(&input); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	doctor, err := c.doctorService.UpdateDoctor(ctx.Request.Context(), uint(id), &input)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", doctor))
}

func (c *DoctorController) DeleteDoctor(ctx *gin.Context) {
	id, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}
	if err := c.doctorService.DeleteDoctor(ctx.Request.Context(), uint(id)); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
