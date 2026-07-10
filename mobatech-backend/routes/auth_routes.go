package routes

import (
	"backend/constants"
	"backend/controllers"
	"backend/repositories"
	"backend/services"

	"backend/middleware"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

func SetupAuthRoutes(r *gin.Engine, db *gorm.DB) {
	repo := repositories.NewAuthRepository(db)
	service := services.NewAuthService(repo)
	authController := controllers.NewAuthController(service)
	profileController := controllers.NewProfileController(service)

	authGroup := r.Group(constants.RouteApiAuth)
	{
		authGroup.POST(constants.RouteRegister, authController.Register)
		authGroup.POST(constants.RouteLogin, authController.Login)
		authGroup.GET(constants.RouteMe, middleware.AuthMiddleware(), authController.Me)
	}

	userGroup := r.Group(constants.RouteApiUsers)
	userGroup.Use(middleware.AuthMiddleware())
	{
		userGroup.PUT(constants.RouteProfile, profileController.UpdateProfile)
		userGroup.POST(constants.RouteFamilyMembers, profileController.AddFamilyMember)
		userGroup.DELETE(constants.RouteFamilyMembersParamId, profileController.DeleteFamilyMember)
	}

	adminGroup := r.Group(constants.RouteApiAdmin)
	adminGroup.Use(middleware.AdminMiddleware())
	{
		adminGroup.GET(constants.RouteUsers, authController.GetAllUsers)
		adminGroup.POST(constants.RouteUsers, authController.AdminCreateUser)
		adminGroup.PUT(constants.RouteUsersParamId, authController.AdminUpdateUser)
		adminGroup.DELETE(constants.RouteUsersParamId, authController.AdminDeleteUser)
	}
}
