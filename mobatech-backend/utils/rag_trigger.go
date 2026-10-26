package utils

import (
	"context"
	"log"
)

type RAGSyncTriggerer interface {
	TriggerSync(ctx context.Context) error
}

var defaultRAGTriggerer RAGSyncTriggerer

func SetRAGSyncTriggerer(t RAGSyncTriggerer) {
	defaultRAGTriggerer = t
}

// TriggerAsyncRAGSync triggers the Python RAG engine to sync its vector database with MySQL.
// This should be called asynchronously as a goroutine to not block the main request flow.
func TriggerAsyncRAGSync() {
	go func() {
		defer func() {
			if r := recover(); r != nil {
				log.Printf("Recovered from panic in TriggerAsyncRAGSync: %v", r)
			}
		}()
		if defaultRAGTriggerer != nil {
			if err := defaultRAGTriggerer.TriggerSync(context.Background()); err != nil {
				log.Printf("Warning: failed to TriggerAsyncRAGSync: %v", err)
			}
		}
	}()
}
