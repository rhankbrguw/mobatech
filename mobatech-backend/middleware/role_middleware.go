package middleware

import (
	"backend/utils"
	"github.com/gin-gonic/gin"
	"net/http"
)

func RequireRole(roles ...string) gin.HandlerFunc {
	return func(c *gin.Context) {
		roleVal, exists := c.Get("role")
		if !exists {
			c.AbortWithStatusJSON(http.StatusUnauthorized, utils.BuildError(utils.ErrUnauthenticated, "Unauthorized", nil))
			return
		}
		
		userRole := roleVal.(string)
		
		hasAccess := false
		for _, r := range roles {
			if userRole == r {
				hasAccess = true
				break
			}
		}
		
		if !hasAccess {
			c.AbortWithStatusJSON(http.StatusForbidden, utils.BuildError(utils.ErrUnauthorized, "Access denied for your role", nil))
			return
		}
		
		c.Next()
	}
}
