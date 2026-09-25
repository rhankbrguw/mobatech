package services

import (
	"backend/constants"
	"backend/models"
	"context"
	"fmt"
	"time"

	"github.com/google/generative-ai-go/genai"
	"google.golang.org/api/iterator"
	"google.golang.org/api/option"
)

func (s *chatService) setupGemini(ctx context.Context) (*genai.GenerativeModel, *genai.Client, error) {
	apiKey := constants.GeminiAPIKey
	if apiKey == "" {
		return nil, nil, fmt.Errorf("gemini api key is not configured")
	}
	client, err := genai.NewClient(ctx, option.WithAPIKey(apiKey))
	if err != nil {
		return nil, nil, fmt.Errorf("failed to create gemini client: %w", err)
	}

	model := client.GenerativeModel(constants.GeminiModel)

	loc, err := time.LoadLocation("Asia/Jakarta")
	if err != nil {
		return nil, nil, fmt.Errorf("failed to load location: %w", err)
	}
	currentTime := time.Now().In(loc).Format("15:04 WIB, Monday, 02 January 2006")
	formattedPrompt := fmt.Sprintf(constants.GeminiSystemPrompt, currentTime)

	model.SystemInstruction = &genai.Content{
		Parts: []genai.Part{genai.Text(formattedPrompt)},
	}
	return model, client, nil
}

func (s *chatService) populateHistory(ctx context.Context, cs *genai.ChatSession, historyMsg []models.ChatMessage, lastUserMsg string) {
	for _, msg := range historyMsg {
		if msg.Role == "user" && msg.Content == lastUserMsg {
			continue
		}
		role := msg.Role
		if role != "model" && role != "user" {
			role = "user"
		}
		cs.History = append(cs.History, &genai.Content{
			Parts: []genai.Part{genai.Text(msg.Content)},
			Role:  role,
		})
	}
}

func (s *chatService) processStream(ctx context.Context, iter *genai.GenerateContentResponseIterator, outChan chan<- string, errChan chan<- error, sessionID uint) {
	var fullResponse string
	for {
		resp, err := iter.Next()
		if err == iterator.Done {
			break
		}
		if err != nil {
			errChan <- fmt.Errorf("stream error: %w", err)
			return
		}
		fullResponse += s.extractAndSendParts(ctx, resp.Candidates, outChan)
	}

	if err := s.repo.AddMessage(ctx, &models.ChatMessage{
		SessionID: sessionID,
		Role:      "model",
		Content:   fullResponse,
	}); err != nil {
		errChan <- fmt.Errorf("failed to save assistant message: %w", err)
	}
}

func (s *chatService) extractAndSendParts(ctx context.Context, candidates []*genai.Candidate, outChan chan<- string) string {
	var added string
	for _, cand := range candidates {
		if cand.Content == nil {
			continue
		}
		for _, part := range cand.Content.Parts {
			if text, ok := part.(genai.Text); ok {
				added += string(text)
				outChan <- string(text)
			}
		}
	}
	return added
}
