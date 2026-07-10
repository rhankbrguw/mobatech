package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/middleware"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupBranchRoutes(r *gin.Engine, db *gorm.DB) {
	branchCtrl := controllers.NewBranchController(db)
	r.GET(constants.RouteApiBranches, branchCtrl.GetBranches)
	r.GET(constants.RouteApiBranchesParamId, branchCtrl.GetBranchByID)

	admin := r.Group(constants.RouteApiAdmin)
	admin.Use(middleware.AuthMiddleware())
	admin.POST(constants.RouteBranches, branchCtrl.CreateBranch)
	admin.PUT(constants.RouteBranchesParamId, branchCtrl.UpdateBranch)
	admin.DELETE(constants.RouteBranchesParamId, branchCtrl.DeleteBranch)
}
