package controllers

import (
	"net/http"

	"backend/middleware"
	"backend/models"
	"backend/services"

	"github.com/gin-gonic/gin"
	"github.com/gorilla/websocket"
)

var notifUpgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
}

func (c *NotificationController) authenticateWS(ctx *gin.Context) (uint, string, error) {
	token := ctx.Query("token")
	if token == "" {
		token = ctx.GetHeader("Sec-WebSocket-Protocol")
	}
	claims, err := middleware.ValidateToken(token)
	if err != nil {
		return 0, "", err
	}

	var userID uint
	switch v := claims["user_id"].(type) {
	case float64:
		userID = uint(v)
	case int:
		userID = uint(v)
	case int64:
		userID = uint(v)
	case uint:
		userID = v
	}
	role, _ := claims["role"].(string)
	return userID, role, nil
}

func (c *NotificationController) HandleWebSocket(ctx *gin.Context) {
	userID, role, err := c.authenticateWS(ctx)
	if err != nil {
		ctx.AbortWithStatus(http.StatusUnauthorized)
		return
	}

	conn, err := notifUpgrader.Upgrade(ctx.Writer, ctx.Request, nil)
	if err != nil {
		return
	}

	client := &services.NotificationClient{
		UserID: userID,
		Role:   role,
		Conn:   conn,
		Send:   make(chan *models.Notification, 32),
	}
	c.hub.Register(client)

	go c.writePump(client)
	c.readPump(client)
}

func (c *NotificationController) writePump(client *services.NotificationClient) {
	defer client.Conn.Close()
	for n := range client.Send {
		if err := client.Conn.WriteJSON(n); err != nil {
			break
		}
	}
}

func (c *NotificationController) readPump(client *services.NotificationClient) {
	defer func() {
		c.hub.Unregister(client)
		client.Conn.Close()
	}()
	for {
		if _, _, err := client.Conn.ReadMessage(); err != nil {
			break
		}
	}
}
