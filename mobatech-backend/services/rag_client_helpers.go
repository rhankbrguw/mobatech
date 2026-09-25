package services

import (
	"backend/constants"
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

func (c *HTTPRAGClient) buildRAGContextRequest(ctx context.Context, query string) (*http.Request, error) {
	payload, err := json.Marshal(map[string]string{"query": query})
	if err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.FetchContext marshal error: %w", err)
	}

	url := c.baseURL + "/api/rag/context"
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewBuffer(payload))
	if err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.FetchContext create request error: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	return req, nil
}

func (c *HTTPRAGClient) parseRAGContextResponse(ctx context.Context, resp *http.Response) (*RAGContextResponse, error) {
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("HTTPRAGClient.FetchContext status code %d: %w", resp.StatusCode, constants.ErrRAGServiceError)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.FetchContext read body error: %w", err)
	}

	var env ragContextResponse

	if err := json.Unmarshal(body, &env); err != nil {
		return nil, fmt.Errorf("HTTPRAGClient.FetchContext unmarshal error: %w", err)
	}

	if !env.Success {
		return nil, fmt.Errorf("HTTPRAGClient.FetchContext RAG service returned success=false: %w", constants.ErrRAGServiceError)
	}

	return &RAGContextResponse{
		AnonymizedQuery: env.Data.AnonymizedQuery,
		Context:         env.Data.Context,
	}, nil
}
