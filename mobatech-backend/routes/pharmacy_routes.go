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

	// Only admin and pharmacist can manage catalog
	catalog := admin.Group("")
	catalog.Use(middleware.RequireRole("admin", "pharmacist"))
	catalog.POST(constants.RouteCategories, ctrl.AdminCreateCategory)
	catalog.PUT(constants.RouteCategoriesParamId, ctrl.AdminUpdateCategory)
	catalog.DELETE(constants.RouteCategoriesParamId, ctrl.AdminDeleteCategory)
	catalog.POST(constants.RouteMedicines, ctrl.AdminCreateMedicine)
	catalog.PUT(constants.RouteMedicinesParamId, ctrl.AdminUpdateMedicine)
	catalog.DELETE(constants.RouteMedicinesParamId, ctrl.AdminDeleteMedicine)

	// Admin and Pharmacist can view orders and prescriptions, but only Pharmacist can process them (handled in controller or here)
	// We will restrict creation of prescriptions to doctors in the backend controller, or here:
	admin.POST(constants.RoutePrescriptions, middleware.RequireRole("doctor"), ctrl.AdminCreatePrescription)

	// Anyone with admin middleware (staff) can view for now, or we restrict:
	admin.GET(constants.RoutePrescriptions, middleware.RequireRole("admin", "pharmacist", "doctor"), ctrl.AdminGetAllPrescriptions)
	admin.DELETE(constants.RoutePrescriptionsParamId, middleware.RequireRole("doctor"), ctrl.AdminDeletePrescription)
	admin.PUT(constants.RoutePrescriptionsParamIdStatus, middleware.RequireRole("pharmacist"), ctrl.AdminUpdatePrescriptionStatus)

	admin.GET(constants.RouteOrders, middleware.RequireRole("admin", "pharmacist"), ctrl.AdminGetAllOrders)
	admin.PUT(constants.RouteOrdersParamIdStatus, middleware.RequireRole("pharmacist"), ctrl.AdminUpdateOrderStatus)
	admin.PUT(constants.RouteOrdersParamIdPayment, middleware.RequireRole("admin", "pharmacist"), ctrl.AdminUpdateOrderPayment)
}
