package services

import (
	"backend/models"
	"sync"

	"github.com/gorilla/websocket"
)

type NotificationClient struct {
	UserID uint
	Role   string
	Conn   *websocket.Conn
	Send   chan *models.Notification
}

type NotificationHub interface {
	Register(client *NotificationClient)
	Unregister(client *NotificationClient)
	Broadcast(notification *models.Notification)
}

type notificationHub struct {
	clients map[*NotificationClient]bool
	mu      sync.RWMutex
}

var (
	globalHub     NotificationHub
	globalHubOnce sync.Once
)

func GetNotificationHub() NotificationHub {
	globalHubOnce.Do(func() {
		globalHub = &notificationHub{
			clients: make(map[*NotificationClient]bool),
		}
	})
	return globalHub
}

func (h *notificationHub) Register(client *NotificationClient) {
	h.mu.Lock()
	defer h.mu.Unlock()
	h.clients[client] = true
}

func (h *notificationHub) Unregister(client *NotificationClient) {
	h.mu.Lock()
	defer h.mu.Unlock()
	if _, ok := h.clients[client]; ok {
		delete(h.clients, client)
		close(client.Send)
	}
}

func (h *notificationHub) shouldSend(client *NotificationClient, n *models.Notification) bool {
	if n.UserID != nil && *n.UserID > 0 {
		return client.UserID == *n.UserID
	}
	if n.Type == "appointment" {
		return client.Role == "admin" && (n.Role == "admin" || n.Role == "all")
	}
	if n.Type == "prescription" {
		if n.Role == "pharmacist" {
			return client.Role == "pharmacist" || client.Role == "admin"
		}
		return client.Role == "admin" && (n.Role == "admin" || n.Role == "all")
	}
	if client.Role == "admin" {
		return n.Role == "" || n.Role == "all" || n.Role == "admin"
	}
	if n.Role == "" || n.Role == "all" {
		return true
	}
	return client.Role == n.Role
}

func (h *notificationHub) Broadcast(n *models.Notification) {
	h.mu.RLock()
	defer h.mu.RUnlock()

	for client := range h.clients {
		if h.shouldSend(client, n) {
			select {
			case client.Send <- n:
			default:
				// Buffer full, skip to avoid blocking
			}
		}
	}
}
