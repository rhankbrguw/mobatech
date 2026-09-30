package controllers

import (
	"backend/config"
	"backend/constants"
	"backend/models"
	"backend/services"
	"backend/utils"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (c *PharmacyController) GetMyPrescriptions(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	parsedUserID := uint(userID.(float64))

	page, _ := strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_PAGE, constants.PAGINATION_DEFAULT_PAGE))
	limit, _ := strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_LIMIT, constants.PAGINATION_DEFAULT_LIMIT))
	if page < 1 { page = 1 }
	if limit < 1 { limit = 10 }
	offset := (page - 1) * limit

	prescriptions, totalCount, err := c.service.GetPrescriptionsByUserID(ctx.Request.Context(), parsedUserID, limit, offset)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildPaginatedSuccess(constants.MsgSuccess, prescriptions, page, limit, totalCount))
}

func (c *PharmacyController) CreatePrescription(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	parsedUserID := uint(userID.(float64))

	var req models.Prescription
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.NewAppError(utils.ErrValidation, http.StatusUnprocessableEntity, err.Error(), nil))
		return
	}
	req.UserID = parsedUserID; req.Status = "Pending"

	if err := c.service.CreatePrescription(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusCreated, utils.BuildSuccess("OK", constants.MsgResourceCreated, req))
}

func (c *PharmacyController) DeletePrescription(ctx *gin.Context) {
	userID, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}
	uid := uint(userID.(float64))
	if err := c.service.DeletePrescription(ctx.Request.Context(), uint(id), &uid); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgResourceDeleted, nil))
}

func notifyPharmacistRedeem() {
	services.BroadcastEvent(config.DB, &models.Notification{
		Role:      "pharmacist",
		Title:     "Permintaan Tebus Resep",
		Message:   "Pasien meminta penebusan resep obat.",
		Type:      "prescription",
		ActionURL: "/dashboard/prescriptions",
	})
}

func (c *PharmacyController) RedeemPrescription(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}
	prescription, err := c.authorizePrescriptionAccess(ctx, id)
	if err != nil {
		return
	}
	if prescription.Status != "Pending" {
		ctx.Error(utils.NewAppError(utils.ErrValidation, http.StatusBadRequest, constants.ErrOnlyPendingCanBeRedeemed.Error(), nil))
		return
	}
	if err := c.service.UpdatePrescriptionStatus(ctx.Request.Context(), uint(id), "Requested", nil); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	notifyPharmacistRedeem()
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgPrescriptionRedeemed, nil))
}

func (c *PharmacyController) authorizePrescriptionAccess(ctx *gin.Context, id int) (*models.Prescription, error) {
	prescription, err := c.service.GetPrescriptionByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgPrescriptionNotFound, nil))
		return nil, err
	}
	userID, exists := ctx.Get("user_id")
	if !exists {
		err = utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil)
		ctx.Error(err)
		return nil, err
	}
	if prescription.UserID != uint(userID.(float64)) {
		err = fmt.Errorf("access denied: %w", constants.ErrForbidden)
		ctx.Error(utils.NewAppError(utils.ErrUnauthorized, http.StatusForbidden, err.Error(), nil))
		return nil, err
	}
	return prescription, nil
}

func (c *PharmacyController) GetPrescriptionDetail(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.Error(utils.NewValidationError(constants.MsgInvalidIDParam))
		return
	}
	prescription, err := c.authorizePrescriptionAccess(ctx, id)
	if err == nil {
		ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgSuccess, prescription))
	}
}
