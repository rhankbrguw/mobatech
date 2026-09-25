package services

import (
	"backend/constants"
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHTTPRAGClient_FetchContext(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/api/rag/context" {
			t.Errorf("Expected path /api/rag/context, got %s", r.URL.Path)
		}
		resp := map[string]interface{}{
			"success": true,
			"data": map[string]interface{}{
				"anonymized_query": "demam tinggi",
				"context":          []string{"Paracetamol 500mg untuk demam"},
			},
		}
		_ = json.NewEncoder(w).Encode(resp)
	}))
	defer ts.Close()

	client := NewRAGClient(ts.URL, ts.Client())
	res, err := client.FetchContext(context.Background(), "saya demam tinggi")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if res.AnonymizedQuery != "demam tinggi" {
		t.Errorf("Expected anonymized_query 'demam tinggi', got %s", res.AnonymizedQuery)
	}

	if len(res.Context) != 1 || res.Context[0] != "Paracetamol 500mg untuk demam" {
		t.Errorf("Unexpected context content: %v", res.Context)
	}
}

func TestHTTPRAGClient_FetchContext_ServerError(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusInternalServerError)
	}))
	defer ts.Close()

	client := NewRAGClient(ts.URL, ts.Client())
	_, err := client.FetchContext(context.Background(), "test")
	if err == nil {
		t.Fatal("Expected error on HTTP 500 status code, got nil")
	}
	if !errors.Is(err, constants.ErrRAGServiceError) {
		t.Errorf("Expected error wrapping ErrRAGServiceError, got %v", err)
	}
}

func TestHTTPRAGClient_FetchContext_SuccessFalse(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		resp := map[string]interface{}{
			"success": false,
		}
		_ = json.NewEncoder(w).Encode(resp)
	}))
	defer ts.Close()

	client := NewRAGClient(ts.URL, ts.Client())
	_, err := client.FetchContext(context.Background(), "test")
	if err == nil {
		t.Fatal("Expected error on success=false, got nil")
	}
	if !errors.Is(err, constants.ErrRAGServiceError) {
		t.Errorf("Expected error wrapping ErrRAGServiceError, got %v", err)
	}
}

func TestHTTPRAGClient_TriggerSync(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/api/rag/sync" {
			t.Errorf("Expected path /api/rag/sync, got %s", r.URL.Path)
		}
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"status":"success"}`))
	}))
	defer ts.Close()

	client := NewRAGClient(ts.URL, ts.Client())
	err := client.TriggerSync(context.Background())
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
}

func TestHTTPRAGClient_TriggerSync_ServerError(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusServiceUnavailable)
	}))
	defer ts.Close()

	client := NewRAGClient(ts.URL, ts.Client())
	err := client.TriggerSync(context.Background())
	if err == nil {
		t.Fatal("Expected error on HTTP 503 status code, got nil")
	}
	if !errors.Is(err, constants.ErrRAGServiceError) {
		t.Errorf("Expected error wrapping ErrRAGServiceError, got %v", err)
	}
}

func TestHTTPRAGClient_GetStatus(t *testing.T) {
	ts := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path != "/api/rag/status" {
			t.Errorf("Expected path /api/rag/status, got %s", r.URL.Path)
		}
		w.WriteHeader(http.StatusOK)
		_, _ = w.Write([]byte(`{"status":"ok","documents_indexed":42}`))
	}))
	defer ts.Close()

	client := NewRAGClient(ts.URL, ts.Client())
	status, err := client.GetStatus(context.Background())
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if status["status"] != "ok" {
		t.Errorf("Expected status 'ok', got %v", status["status"])
	}
}
