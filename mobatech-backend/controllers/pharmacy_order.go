package controllers

import (
	"backend/constants"
	"backend/models"
	"backend/utils"
	"fmt"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func (c *PharmacyController) CreateOrder(ctx *gin.Context) {
	var req models.PharmacyOrder
	if err := ctx.ShouldBindJSON(&req); err != nil {
		ctx.Error(utils.FormatValidationError(err))
		return
	}

	userIDVal, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	req.UserID = uint(userIDVal.(float64))

	if err := c.service.CreateOrder(ctx.Request.Context(), &req); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusCreated, utils.BuildSuccess("CREATED", "Resource created successfully", req))
}
func (c *PharmacyController) GetMyOrders(ctx *gin.Context) {
	userIDVal, exists := ctx.Get("user_id")
	if !exists {
		ctx.Error(utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil))
		return
	}
	userID := uint(userIDVal.(float64))

	orders, err := c.service.GetOrdersByUserID(ctx.Request.Context(), userID)
	if err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}
	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", orders))
}
func (c *PharmacyController) GetOrderDetail(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, _ := strconv.Atoi(idStr)

	order, err := c.authorizeOrderAccess(ctx, id)
	if err != nil {
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", order))
}
func (c *PharmacyController) CancelOrder(ctx *gin.Context) {
	idStr := ctx.Param("id")
	id, _ := strconv.Atoi(idStr)

	order, err := c.authorizeOrderAccess(ctx, id)
	if err != nil {
		return
	}

	if order.Status != "Pending" {
		ctx.Error(utils.NewValidationError("Only pending orders can be cancelled"))
		return
	}

	if err := c.service.UpdateOrderStatus(ctx.Request.Context(), uint(id), "Cancelled"); err != nil {
		ctx.Error(utils.NewInternalError(err.Error()))
		return
	}

	ctx.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", nil))
}

func (c *PharmacyController) authorizeOrderAccess(ctx *gin.Context, id int) (*models.PharmacyOrder, error) {
	order, err := c.service.GetOrderByID(ctx.Request.Context(), uint(id))
	if err != nil {
		ctx.Error(utils.NewAppError(utils.ErrNotFound, http.StatusNotFound, constants.MsgOrderNotFound, nil))
		return nil, fmt.Errorf("PharmacyController.authorizeOrderAccess: %w", err)
	}

	userIDVal, exists := ctx.Get("user_id")
	if !exists {
		err = utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, constants.MsgUnauthorized, nil)
		ctx.Error(err)
		return nil, fmt.Errorf("PharmacyController.authorizeOrderAccess: %w", err)
	}
	userID := uint(userIDVal.(float64))
	if order.UserID != userID {
		err = fmt.Errorf("access denied")
		ctx.JSON(http.StatusForbidden, gin.H{"error": err.Error()})
		return nil, fmt.Errorf("PharmacyController.authorizeOrderAccess: %w", err)
	}
	return order, nil
}
