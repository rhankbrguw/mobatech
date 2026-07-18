package controllers

import (
	"backend/controllers/dto"
	"backend/models"
	"backend/utils"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (c *PharmacyController) AdminCreatePrescription(ctx *gin.Context) {
	var p models.Prescription
	if err := ctx.ShouldBindJSON(&p); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}
	if err := c.service.CreatePrescription(ctx.Request.Context(), &p); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusCreated, utils.BuildSuccess("CREATED", "Resource created successfully", p))
}

func (c *PharmacyController) AdminGetAllPrescriptions(ctx *gin.Context) {
	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	prescriptions, totalCount, err := c.service.GetAllPrescriptions(ctx.Request.Context(), limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", prescriptions, page, limit, totalCount))
}

func (c *PharmacyController) AdminDeletePrescription(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	if err := c.service.DeletePrescription(ctx.Request.Context(), uint(id), nil); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Prescription deleted", nil))
}

func (c *PharmacyController) AdminUpdatePrescriptionStatus(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	role, exists := ctx.Get("role")
	if !exists || (role != "pharmacist" && role != "doctor") {
		ctx.Error(utils.NewAppError(utils.ErrUnauthorized, http.StatusForbidden, "Akses ditolak: Hanya Apoteker atau Dokter yang dapat memproses E-Resep", nil))
		return
	}

	var req dto.AdminUpdatePrescriptionStatusReq
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := c.service.UpdatePrescriptionStatus(ctx.Request.Context(), uint(id), req.Status, &req.Notes); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *PharmacyController) AdminGetAllOrders(ctx *gin.Context) {
	search := ctx.Query("search")
	filter := ctx.Query("filter")

	page, limit, offset, err := utils.GetPaginationParams(ctx)
	if err != nil {
		ctx.Error(err)
		return
	}

	orders, totalCount, err := c.service.GetAllOrders(ctx.Request.Context(), search, filter, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", orders, page, limit, totalCount))
}

func (c *PharmacyController) AdminUpdateOrderStatus(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	var req dto.AdminUpdateOrderStatusReq
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := c.service.UpdateOrderStatus(ctx.Request.Context(), uint(id), req.Status); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *PharmacyController) AdminUpdateOrderPayment(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		ctx.Error(utils.NewValidationError("Invalid id parameter"))
		return
	}

	var req dto.AdminUpdateOrderPaymentReq
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	if err := c.service.UpdateOrderPayment(ctx.Request.Context(), uint(id), req.PaymentStatus); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}
