package middleware

import (
	"backend/constants"
	"fmt"
	"net/http"
	"strings"

	"backend/utils"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt/v5"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		tokenString, err := extractToken(c)
		if err != nil {
			_ = c.Error(err)
			c.Abort()
			return
		}

		claims, err := validateToken(tokenString)
		if err != nil {
			_ = c.Error(err)
			c.Abort()
			return
		}

		c.Set("user_id", claims["user_id"])
		c.Set("role", claims["role"])
		c.Next()
	}
}

func extractToken(c *gin.Context) (string, error) {
	authHeader := c.GetHeader("Authorization")
	if authHeader == "" {
		return "", utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Authorization header is required", nil)
	}

	parts := strings.SplitN(authHeader, " ", 2)
	if !(len(parts) == 2 && parts[0] == "Bearer") {
		return "", utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Authorization header format must be Bearer {token}", nil)
	}
	return parts[1], nil
}

func validateToken(tokenString string) (jwt.MapClaims, error) {
	secret := []byte(constants.JWTSecret)
	if len(secret) == 0 {
		return nil, utils.NewAppError(utils.ErrInternal, http.StatusInternalServerError, "JWT_SECRET is not configured on the server", nil)
	}

	token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method %v: %w", token.Header["alg"], constants.ErrInvalidSigningMethod)
		}
		return []byte(secret), nil
	})

	if err != nil || !token.Valid {
		return nil, utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Invalid or expired token", nil)
	}

	if claims, ok := token.Claims.(jwt.MapClaims); ok {
		return claims, nil
	}
	return nil, utils.NewAppError(utils.ErrUnauthenticated, http.StatusUnauthorized, "Invalid token claims", nil)
}
