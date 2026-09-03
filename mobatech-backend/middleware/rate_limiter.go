package middleware

import (
	"backend/utils"
	"net/http"
	"sync"
	"time"

	"github.com/gin-gonic/gin"
)

type clientInfo struct {
	tokens int
	last   time.Time
}

var (
	clients = make(map[string]*clientInfo)
	mu      sync.Mutex
	rate    = 5
	burst   = 5
)

func RateLimitMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		ip := c.ClientIP()
		mu.Lock()
		info, exists := clients[ip]
		if !exists {
			clients[ip] = &clientInfo{tokens: burst - 1, last: time.Now()}
			mu.Unlock()
			c.Next()
			return
		}

		now := time.Now()
		elapsed := now.Sub(info.last).Seconds()
		info.tokens += int(elapsed * float64(rate))
		if info.tokens > burst {
			info.tokens = burst
		}
		info.last = now

		if info.tokens <= 0 {
			mu.Unlock()
			c.AbortWithStatusJSON(http.StatusTooManyRequests, utils.BuildError("TOO_MANY_REQUESTS", "Rate limit exceeded", nil))
			return
		}

		info.tokens--
		mu.Unlock()
		c.Next()
	}
}
