package services

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

func (s *chatService) buildRAGPrompt(ctx context.Context, userMessage string) string {
	ragContext, anonymizedQuery := s.fetchRAGContext(ctx, userMessage)
	if anonymizedQuery == "" {
		anonymizedQuery = userMessage
	}
	if ragContext != "" {
		return fmt.Sprintf("Konteks Internal RS Hermina:\n%s\n\nPertanyaan Pasien: %s", ragContext, anonymizedQuery)
	}
	return anonymizedQuery
}

func (s *chatService) fetchRAGContext(ctx context.Context, query string) (string, string) {
	payload, err := json.Marshal(map[string]string{"query": query})
	if err != nil {
		return "", ""
	}
	resp, err := http.Post("http://127.0.0.1:8000/api/rag/context", "application/json", bytes.NewBuffer(payload))
	if err != nil {
		return "", ""
	}
	defer resp.Body.Close()

	if resp.StatusCode != 200 {
		return "", ""
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", ""
	}

	var env struct {
		Success bool `json:"success"`
		Data    struct {
			AnonymizedQuery string   `json:"anonymized_query"`
			Context         []string `json:"context"`
		} `json:"data"`
	}

	if err := json.Unmarshal(body, &env); err == nil && env.Success {
		anonymized := env.Data.AnonymizedQuery
		result := ""
		if len(env.Data.Context) > 0 {
			for _, ctxStr := range env.Data.Context {
				result += fmt.Sprintf("- %v\n", ctxStr)
			}
			return result, anonymized
		}
		return "", anonymized
	}
	return "", ""
}
