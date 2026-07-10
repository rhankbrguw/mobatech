package services

import (
	"backend/models"
	"backend/repositories"
	"context"
	"fmt"

	"github.com/google/generative-ai-go/genai"
)

type ChatService interface {
	CreateSession(ctx context.Context, userID string, title string) (*models.ChatSession, error)
	GetUserSessions(ctx context.Context, userID string) ([]models.ChatSession, error)
	GetSessionMessages(ctx context.Context, sessionID uint) ([]models.ChatMessage, error)
	DeleteSession(ctx context.Context, userID uint, sessionID uint) error
	RenameSession(ctx context.Context, userID uint, sessionID uint, newTitle string) error
	StreamChat(ctx context.Context, sessionID uint, userMessage string, outChan chan<- string, errChan chan<- error)
	GetAllSessions(ctx context.Context, search string, limit int, offset int) ([]models.ChatSession, int64, error)
}

type chatService struct {
	repo repositories.ChatRepository
}

func NewChatService(repo repositories.ChatRepository) ChatService {
	return &chatService{repo}
}

func (s *chatService) CreateSession(ctx context.Context, userID string, title string) (*models.ChatSession, error) {
	session := &models.ChatSession{UserID: userID, Title: title}
	return session, s.repo.CreateSession(ctx, session)
}

func (s *chatService) GetUserSessions(ctx context.Context, userID string) ([]models.ChatSession, error) {
	return s.repo.GetUserSessions(ctx, userID)
}

func (s *chatService) GetSessionMessages(ctx context.Context, sessionID uint) ([]models.ChatMessage, error) {
	return s.repo.GetSessionMessages(ctx, sessionID)
}

func (s *chatService) DeleteSession(ctx context.Context, userID uint, sessionID uint) error {
	return s.repo.DeleteSession(ctx, userID, sessionID)
}

func (s *chatService) RenameSession(ctx context.Context, userID uint, sessionID uint, newTitle string) error {
	return s.repo.RenameSession(ctx, userID, sessionID, newTitle)
}

func (s *chatService) GetAllSessions(ctx context.Context, search string, limit int, offset int) ([]models.ChatSession, int64, error) {
	return s.repo.GetAllSessions(ctx, search, limit, offset)
}

func (s *chatService) StreamChat(ctx context.Context, sessionID uint, userMessage string, outChan chan<- string, errChan chan<- error) {
	defer close(outChan)
	defer close(errChan)

	if err := s.saveUserMessage(ctx, sessionID, userMessage); err != nil {
		errChan <- err
		return
	}

	historyMsg, err := s.repo.GetSessionMessages(ctx, sessionID)
	if err != nil {
		errChan <- fmt.Errorf("failed to get history: %v", err)
		return
	}

	if len(historyMsg) == 1 {
		go s.asyncGenerateTitle(ctx, sessionID, userMessage)
	}

	s.handleGeminiStream(ctx, sessionID, userMessage, historyMsg, outChan, errChan)
}

func (s *chatService) handleGeminiStream(ctx context.Context, sessionID uint, userMessage string, history []models.ChatMessage, outChan chan<- string, errChan chan<- error) {
	model, client, err := s.setupGemini(ctx)
	if err != nil {
		errChan <- err
		return
	}
	defer client.Close()

	cs := model.StartChat()
	s.populateHistory(ctx, cs, history, userMessage)

	ragQuery := s.buildRAGPrompt(ctx, userMessage)
	iter := cs.SendMessageStream(ctx, genai.Text(ragQuery))
	s.processStream(ctx, iter, outChan, errChan, sessionID)
}

func (s *chatService) saveUserMessage(ctx context.Context, sessionID uint, userMessage string) error {
	err := s.repo.AddMessage(ctx, &models.ChatMessage{
		SessionID: sessionID,
		Role:      "user",
		Content:   userMessage,
	})
	if err != nil {
		return fmt.Errorf("failed to save user message: %v", err)
	}
	return nil
}

func (s *chatService) asyncGenerateTitle(ctx context.Context, sessionID uint, firstMessage string) {

	model, client, err := s.setupGemini(ctx)
	if err != nil {
		return
	}
	defer client.Close()

	prompt := fmt.Sprintf("Create a short (max 4 words) and natural title for a medical chat session starting with this prompt. No quotes, no punctuation. Prompt: %s", firstMessage)

	resp, err := model.GenerateContent(ctx, genai.Text(prompt))
	if err == nil && len(resp.Candidates) > 0 && len(resp.Candidates[0].Content.Parts) > 0 {
		title := fmt.Sprintf("%v", resp.Candidates[0].Content.Parts[0])
		s.repo.UpdateSessionTitle(ctx, sessionID, title)
	}
}
