package services

import (
	"context"
	"fmt"
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
	if s.ragClient == nil {
		return "", ""
	}
	resp, err := s.ragClient.FetchContext(ctx, query)
	if err != nil || resp == nil {
		return "", ""
	}

	anonymized := resp.AnonymizedQuery
	result := ""
	if len(resp.Context) > 0 {
		for _, ctxStr := range resp.Context {
			result += fmt.Sprintf("- %v\n", ctxStr)
		}
		return result, anonymized
	}
	return "", anonymized
}
