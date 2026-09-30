package services

import (
	"backend/constants"
	"backend/repositories"
	"context"
	"encoding/json"
	"fmt"

	"github.com/google/generative-ai-go/genai"
	"google.golang.org/api/option"
)

type Article struct {
	ID          string `json:"id"`
	Title       string `json:"title"`
	Category    string `json:"category"`
	ReadTime    string `json:"readTime"`
	Content     string `json:"content"`
	Tag         string `json:"tag"`
	ActionText  string `json:"actionText"`
	ActionRoute string `json:"actionRoute"`
	DoctorName  string `json:"doctorName"`
	PolyName    string `json:"polyName"`
	LikesCount  int    `json:"likesCount"`
}

type ForYouService interface {
	GenerateRecommendations(ctx context.Context, userID string) ([]Article, error)
}

type forYouService struct {
	chatRepo repositories.ChatRepository
}

func NewForYouService(chatRepo repositories.ChatRepository) ForYouService {
	return &forYouService{chatRepo}
}

func (s *forYouService) GenerateRecommendations(ctx context.Context, userID string) ([]Article, error) {
	chatContext := s.extractUserContext(ctx, userID)
	prompt := fmt.Sprintf(constants.GeminiForYouPrompt, chatContext)

	jsonStr, err := s.fetchGeminiResponse(ctx, prompt)
	if err == nil && jsonStr != "" {
		var articles []Article
		if err := json.Unmarshal([]byte(jsonStr), &articles); err == nil && len(articles) > 0 {
			return s.normalizeArticles(articles), nil
		}
	}

	return s.getPersonalizedFallback(chatContext), nil
}

func (s *forYouService) extractUserContext(ctx context.Context, userID string) string {
	sessions, err := s.chatRepo.GetUserSessions(ctx, userID)
	if err != nil || len(sessions) == 0 {
		return constants.DefaultChatContext
	}

	chatContext := ""
	for i, session := range sessions {
		if i >= constants.MaxChatSessionsForContext {
			break
		}
		msgs, err := s.chatRepo.GetSessionMessages(ctx, session.ID)
		if err != nil {
			continue
		}

		for _, msg := range msgs {
			if msg.Role == "user" {
				chatContext += "- " + msg.Content + "\n"
			}
		}
	}

	if chatContext == "" {
		return constants.DefaultChatContext
	}
	return chatContext
}

func (s *forYouService) fetchGeminiResponse(ctx context.Context, prompt string) (string, error) {
	apiKey := constants.GeminiAPIKey
	if apiKey == "" {
		return "", fmt.Errorf("forYouService.fetchGeminiResponse: gemini api key is not configured")
	}
	client, err := genai.NewClient(ctx, option.WithAPIKey(apiKey))
	if err != nil {
		return "", fmt.Errorf("forYouService.fetchGeminiResponse: %w", err)
	}
	defer client.Close()

	model := client.GenerativeModel(constants.GeminiModel)
	model.ResponseMIMEType = constants.MIMETypeJSON

	resp, err := model.GenerateContent(ctx, genai.Text(prompt))
	if err != nil {
		return "", fmt.Errorf("forYouService.fetchGeminiResponse: %w", err)
	}

	var jsonStr string
	if len(resp.Candidates) > 0 && len(resp.Candidates[0].Content.Parts) > 0 {
		for _, part := range resp.Candidates[0].Content.Parts {
			if text, ok := part.(genai.Text); ok {
				jsonStr += string(text)
			}
		}
	}
	return jsonStr, nil
}

func (s *forYouService) normalizeArticles(articles []Article) []Article {
	for i := range articles {
		if articles[i].ID == "" {
			articles[i].ID = fmt.Sprintf("gemini-%d", i+1)
		}
		if articles[i].Tag == "" {
			articles[i].Tag = "Berdasarkan Chat Terakhir Anda"
		}
		if articles[i].ActionText == "" {
			articles[i].ActionText = "Konsultasi Dokter Terkait"
		}
		if articles[i].ActionRoute == "" {
			articles[i].ActionRoute = "/doctors"
		}
		if articles[i].LikesCount == 0 {
			articles[i].LikesCount = 45 + (i * 18)
		}
	}
	return articles
}
