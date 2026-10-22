package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
)

func setupTestRouterWithRole(role string, hasRole bool, allowedRoles ...string) *httptest.ResponseRecorder {
	gin.SetMode(gin.TestMode)
	w := httptest.NewRecorder()
	_, r := gin.CreateTestContext(w)

	r.Use(func(c *gin.Context) {
		if hasRole {
			c.Set("role", role)
		}
		c.Next()
	})

	r.GET("/protected", RequireRole(allowedRoles...), func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{"status": "ok"})
	})

	req, _ := http.NewRequest(http.MethodGet, "/protected", nil)
	r.ServeHTTP(w, req)
	return w
}

func TestRequireRole_Allowed(t *testing.T) {
	roles := []string{"admin", "doctor", "pharmacist"}
	for _, role := range roles {
		w := setupTestRouterWithRole(role, true, "admin", "doctor", "pharmacist")
		if w.Code != http.StatusOK {
			t.Errorf("Expected status 200 for role %s, got %d", role, w.Code)
		}
	}
}

func TestRequireRole_Forbidden(t *testing.T) {
	testCases := []struct {
		userRole     string
		allowedRoles []string
	}{
		{"patient", []string{"admin", "doctor"}},
		{"patient", []string{"pharmacist"}},
		{"doctor", []string{"admin"}},
		{"doctor", []string{"pharmacist"}},
		{"pharmacist", []string{"doctor"}},
		{"pharmacist", []string{"admin"}},
	}

	for _, tc := range testCases {
		w := setupTestRouterWithRole(tc.userRole, true, tc.allowedRoles...)
		if w.Code != http.StatusForbidden {
			t.Errorf("Expected 403 Forbidden for %s on %v, got %d", tc.userRole, tc.allowedRoles, w.Code)
		}
	}
}

func TestRequireRole_MissingRole(t *testing.T) {
	w := setupTestRouterWithRole("", false, "admin", "doctor")
	if w.Code != http.StatusUnauthorized {
		t.Errorf("Expected 401 Unauthorized for missing role, got %d", w.Code)
	}
}
