package routes

import (
	"backend/controllers"
	"backend/middleware"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupBranchRoutes(r *gin.Engine, db *gorm.DB) {
	branchCtrl := controllers.NewBranchController(db)
	r.GET("/api/branches", branchCtrl.GetBranches)
	r.GET("/api/branches/:id", branchCtrl.GetBranchByID)
	
	admin := r.Group("/api/admin")
	admin.Use(middleware.AuthMiddleware())
	admin.POST("/branches", branchCtrl.CreateBranch)
	admin.PUT("/branches/:id", branchCtrl.UpdateBranch)
	admin.DELETE("/branches/:id", branchCtrl.DeleteBranch)
}
