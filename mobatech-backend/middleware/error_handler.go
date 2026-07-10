package middleware

import (
	"log"
	"net/http"

	"backend/constants"
	"backend/utils"

	"github.com/gin-gonic/gin"
)

func ErrorHandler() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Next()

		if len(c.Errors) > 0 {
			err := c.Errors.Last().Err
			if appErr, ok := err.(*utils.AppError); ok {
				c.JSON(appErr.Status, utils.BuildError(appErr.Code, appErr.Message, appErr.Errors))
				return
			}

			// Log actual error, return generic internal error
			log.Printf("[Internal Server Error]: %v", err)
			c.JSON(http.StatusInternalServerError, utils.BuildError(utils.ErrInternal, constants.MsgInternalServer, nil))
		}
	}
}
