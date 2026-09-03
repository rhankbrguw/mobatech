package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/middleware"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupPromoRoutes(r *gin.Engine, db *gorm.DB) {
	ctrl := controllers.NewPromoController(db)
	r.GET(constants.RouteApiPromos, ctrl.GetPromos)
	admin := r.Group(constants.RouteApiAdminPromos)
	admin.Use(middleware.AuthMiddleware())
	{
		admin.GET("", ctrl.GetAllPromos)
		admin.POST("", ctrl.CreatePromo)
		admin.PUT(constants.RouteParamId, ctrl.UpdatePromo)
		admin.DELETE(constants.RouteParamId, ctrl.DeletePromo)
	}
}
