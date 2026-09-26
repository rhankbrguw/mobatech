package services

import (
	"backend/constants"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

type RAGContextResponse struct {
	AnonymizedQuery string   `json:"anonymized_query"`
	Context         []string `json:"context"`
}

type ragContextResponse struct {
	Success bool `json:"success"`
	Data    struct {
		AnonymizedQuery string   `json:"anonymized_query"`
		Context         []string `json:"context"`
	} `json:"data"`
}

type RAGClient interface {
	FetchContext(ctx context.Context, query string) (*RAGContextResponse, error)
	TriggerSync(ctx context.Context) error
	GetStatus(ctx context.Context) (map[string]interface{}, error)
}

type HTTPRAGClient struct {
	baseURL    string
	httpClient *http.Client
}

func NewRAGClient(baseURL string, httpClient *http.Client) RAGClient {
	if baseURL == "" {
		baseURL = constants.RAGBaseURL
	}
	if httpClient == nil {
		httpClient = &http.Client{Timeout: 10 * time.Second}
	}
	return &HTTPRAGClient{
		baseURL:    baseURL,
		httpClient: httpClient,
	}
}

func (c *HTTPRAGClient) FetchContext(ctx context.Context, query string) (*RAGContextResponse, error) {
	req, err := c.buildRAGContextRequest(ctx, query)
	if err != nil {
		return nil, err
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.FetchContext HTTP post error: %w", err)
	}
	defer resp.Body.Close()

	return c.parseRAGContextResponse(ctx, resp)
}

func (c *HTTPRAGClient) TriggerSync(ctx context.Context) error {
	url := c.baseURL + "/api/rag/sync"
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewBuffer([]byte("{}")))
	if err != nil {
		return fmt.Errorf("HTTPRAGClient.TriggerSync create request error: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("HTTPRAGClient.TriggerSync HTTP post error: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf("HTTPRAGClient.TriggerSync status code %d: %w", resp.StatusCode, constants.ErrRAGServiceError)
	}

	return nil
}

func (c *HTTPRAGClient) GetStatus(ctx context.Context) (map[string]interface{}, error) {
	url := c.baseURL + "/api/rag/status"
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.GetStatus create request error: %w", err)
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.GetStatus HTTP get error: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("HTTPRAGClient.GetStatus status code %d: %w", resp.StatusCode, constants.ErrRAGServiceError)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.GetStatus read body error: %w", err)
	}

	var result map[string]interface{}
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.GetStatus unmarshal error: %w", err)
	}

	return result, nil
}
