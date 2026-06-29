package routes
import (
	"backend/controllers"
	"backend/middleware"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)
func SetupPromoRoutes(r *gin.Engine, db *gorm.DB) {
	ctrl := controllers.NewPromoController(db)
	r.GET("/api/promos", ctrl.GetPromos)
	admin := r.Group("/api/admin/promos")
	admin.Use(middleware.AuthMiddleware())
	{
		admin.GET("", ctrl.GetAllPromos)
		admin.POST("", ctrl.CreatePromo)
		admin.PUT("/:id", ctrl.UpdatePromo)
		admin.DELETE("/:id", ctrl.DeletePromo)
	}
}
