package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/middleware"
	"backend/repositories"
	"backend/services"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupPharmacyRoutes(r *gin.Engine, db *gorm.DB) {
	repo := repositories.NewPharmacyRepository(db)
	service := services.NewPharmacyService(repo)
	ctrl := controllers.NewPharmacyController(service)

	setupPharmacyPublicRoutes(r, ctrl)
	setupPharmacyUserRoutes(r, ctrl)
	setupPharmacyAdminRoutes(r, ctrl)
}

func setupPharmacyPublicRoutes(r *gin.Engine, ctrl *controllers.PharmacyController) {
	public := r.Group(constants.RouteApiPharmacy)
	public.GET(constants.RouteCategories, ctrl.GetCategories)
	public.GET(constants.RouteMedicines, ctrl.GetMedicines)
	public.GET(constants.RouteMedicinesParamId, ctrl.GetMedicineDetail)
}

func setupPharmacyUserRoutes(r *gin.Engine, ctrl *controllers.PharmacyController) {
	user := r.Group(constants.RouteApiPharmacy)
	user.Use(middleware.AuthMiddleware())
	user.GET(constants.RoutePrescriptions, ctrl.GetMyPrescriptions)
	user.GET(constants.RoutePrescriptionsParamId, ctrl.GetPrescriptionDetail)
	user.POST(constants.RoutePrescriptionsParamIdRedeem, ctrl.RedeemPrescription)
	user.POST(constants.RoutePrescriptions, ctrl.CreatePrescription)
	user.DELETE(constants.RoutePrescriptionsParamId, ctrl.DeletePrescription)
	user.POST(constants.RouteOrders, ctrl.CreateOrder)
	user.GET(constants.RouteOrders, ctrl.GetMyOrders)
	user.GET(constants.RouteOrdersParamId, ctrl.GetOrderDetail)
	user.PUT(constants.RouteOrdersParamIdCancel, ctrl.CancelOrder)
	user.GET(constants.RouteCart, ctrl.GetCart)
	user.POST(constants.RouteCart, ctrl.AddToCart)
	user.PUT(constants.RouteCartParamId, ctrl.UpdateCartItem)
	user.DELETE(constants.RouteCartParamId, ctrl.RemoveFromCart)
}

func setupPharmacyAdminRoutes(r *gin.Engine, ctrl *controllers.PharmacyController) {
	admin := r.Group(constants.RouteApiAdminPharmacy)
	admin.Use(middleware.AdminMiddleware())
	admin.POST(constants.RouteCategories, ctrl.AdminCreateCategory)
	admin.PUT(constants.RouteCategoriesParamId, ctrl.AdminUpdateCategory)
	admin.DELETE(constants.RouteCategoriesParamId, ctrl.AdminDeleteCategory)
	admin.POST(constants.RouteMedicines, ctrl.AdminCreateMedicine)
	admin.PUT(constants.RouteMedicinesParamId, ctrl.AdminUpdateMedicine)
	admin.DELETE(constants.RouteMedicinesParamId, ctrl.AdminDeleteMedicine)
	admin.POST(constants.RoutePrescriptions, ctrl.AdminCreatePrescription)
	admin.GET(constants.RoutePrescriptions, ctrl.AdminGetAllPrescriptions)
	admin.DELETE(constants.RoutePrescriptionsParamId, ctrl.AdminDeletePrescription)
	admin.PUT(constants.RoutePrescriptionsParamIdStatus, ctrl.AdminUpdatePrescriptionStatus)
	admin.GET(constants.RouteOrders, ctrl.AdminGetAllOrders)
	admin.PUT(constants.RouteOrdersParamIdStatus, ctrl.AdminUpdateOrderStatus)
	admin.PUT(constants.RouteOrdersParamIdPayment, ctrl.AdminUpdateOrderPayment)
}
