package controllers

import (
	"backend/utils"
	"github.com/gin-gonic/gin"
	"io"
	"strconv"
)

func (c *ChatController) StreamChat(ctx *gin.Context) {
	sessionID, err := strconv.ParseUint(ctx.Param("id"), 10, 32)
	if err != nil {
		ctx.Error(utils.NewValidationError("invalid session id"))
		return
	}
	var req struct {
		Message string `json:"message"`
	}
	if err := ctx.BindJSON(&req); err != nil {
		ctx.Error(utils.NewValidationError(err.Error()))
		return
	}
	outChan := make(chan string)
	errChan := make(chan error)
	go c.service.StreamChat(ctx.Request.Context(), uint(sessionID), req.Message, outChan, errChan)
	c.handleStream(ctx, outChan, errChan)
}

func (c *ChatController) handleStream(ctx *gin.Context, outChan <-chan string, errChan <-chan error) {
	ctx.Stream(func(w io.Writer) bool {
		select {
		case msg, ok := <-outChan:
			if !ok {
				return false
			}
			ctx.SSEvent("message", gin.H{"text": msg})
			return true
		case err, ok := <-errChan:
			if !ok {
				return false
			}
			ctx.SSEvent("error", err.Error())
			return false
		case <-ctx.Request.Context().Done():
			return false
		}
	})
}
