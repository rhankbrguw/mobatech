package controllers

import (
	"backend/constants"
	"backend/utils"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

type UploadController struct{}

func NewUploadController() *UploadController {
	return &UploadController{}
}

func (ctrl *UploadController) UploadFile(c *gin.Context) {
	file, err := c.FormFile("file")
	if err != nil {
		_ = c.Error(utils.NewAppError(utils.ErrValidation, http.StatusBadRequest, constants.MsgNoFileUploaded, nil))
		return
	}
	filename := fmt.Sprintf("%d_%s", time.Now().Unix(), file.Filename)
	dst := "uploads/" + filename
	if err := c.SaveUploadedFile(file, dst); err != nil {
		_ = c.Error(utils.NewInternalError(constants.MsgFileSaveFailed))
		return
	}
	urlStr := fmt.Sprintf("%s/uploads/%s", strings.TrimSuffix(constants.UploadURL, "/"), filename)
	c.JSON(http.StatusOK, utils.BuildSuccess("OK", constants.MsgFileUploadSuccess, gin.H{
		"url": urlStr,
	}))
}
