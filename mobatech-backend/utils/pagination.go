package utils

import (
	"backend/constants"
	"strconv"

	"github.com/gin-gonic/gin"
)

func GetPaginationParams(ctx *gin.Context) (page int, limit int, offset int, err error) {
	page, err = strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_PAGE, constants.PAGINATION_DEFAULT_PAGE))
	if err != nil {
		return 0, 0, 0, NewValidationError("Invalid page parameter")
	}
	if page < 1 {
		page = 1
	}
	limit, err = strconv.Atoi(ctx.DefaultQuery(constants.QUERY_PARAM_LIMIT, constants.PAGINATION_DEFAULT_LIMIT))
	if err != nil {
		return 0, 0, 0, NewValidationError("Invalid limit parameter")
	}
	offset = (page - 1) * limit
	return page, limit, offset, nil
}
