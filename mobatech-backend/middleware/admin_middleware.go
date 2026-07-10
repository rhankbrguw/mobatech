package middleware

import (
	"backend/utils"
	"github.com/gin-gonic/gin"
	"net/http"
)

func AdminMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString, err := extractToken(c)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, utils.BuildError(utils.ErrUnauthenticated, err.Error(), nil))
			return
		}
		claims, err := validateToken(tokenString)
		if err != nil {
			c.AbortWithStatusJSON(http.StatusUnauthorized, utils.BuildError(utils.ErrUnauthenticated, err.Error(), nil))
			return
		}
		role, ok := claims["role"].(string)
		if !ok || role == "patient" {
			c.AbortWithStatusJSON(http.StatusForbidden, utils.BuildError(utils.ErrUnauthorized, "Access denied: Staff only", nil))
			return
		}
		c.Set("user_id", claims["user_id"])
		c.Set("role", role)
		c.Set("is_admin", role == "admin")
		c.Next()
	}
}
