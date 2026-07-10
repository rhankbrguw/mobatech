package repositories

import (
	"fmt"

	"context"

	"backend/models"

	"gorm.io/gorm"
)

type ChatRepository interface {
	CreateSession(ctx context.Context, session *models.ChatSession) error
	GetUserSessions(ctx context.Context, userID string) ([]models.ChatSession, error)
	GetSession(ctx context.Context, sessionID uint) (*models.ChatSession, error)
	AddMessage(ctx context.Context, message *models.ChatMessage) error
	GetSessionMessages(ctx context.Context, sessionID uint) ([]models.ChatMessage, error)
	DeleteSession(ctx context.Context, userID uint, sessionID uint) error
	RenameSession(ctx context.Context, userID uint, sessionID uint, newTitle string) error
	UpdateSessionTitle(ctx context.Context, sessionID uint, newTitle string) error
	GetAllSessions(ctx context.Context, search string, limit int, offset int) ([]models.ChatSession, int64, error)
}

type chatRepository struct {
	db *gorm.DB
}

func NewChatRepository(db *gorm.DB) ChatRepository {
	return &chatRepository{db}
}

func (r *chatRepository) CreateSession(ctx context.Context, session *models.ChatSession) error {
	return r.db.Create(session).Error
}

func (r *chatRepository) GetUserSessions(ctx context.Context, userID string) ([]models.ChatSession, error) {
	var sessions []models.ChatSession
	if err := r.db.Where("user_id = ?", userID).Order("updated_at desc").Find(&sessions).Error; err != nil {
		return nil, fmt.Errorf("chatRepository.GetUserSessions: %w", err)
	}
	return sessions, nil
}

func (r *chatRepository) GetSession(ctx context.Context, sessionID uint) (*models.ChatSession, error) {
	var session models.ChatSession
	if err := r.db.Preload("Messages").First(&session, sessionID).Error; err != nil {
		return nil, fmt.Errorf("chatRepository.GetSession: %w", err)
	}
	return &session, nil
}

func (r *chatRepository) AddMessage(ctx context.Context, message *models.ChatMessage) error {
	return r.db.Create(message).Error
}

func (r *chatRepository) GetSessionMessages(ctx context.Context, sessionID uint) ([]models.ChatMessage, error) {
	var messages []models.ChatMessage
	if err := r.db.Where("session_id = ?", sessionID).Order("created_at asc").Find(&messages).Error; err != nil {
		return nil, fmt.Errorf("chatRepository.GetSessionMessages: %w", err)
	}
	return messages, nil
}

func (r *chatRepository) DeleteSession(ctx context.Context, userID uint, sessionID uint) error {
	r.db.Where("chat_session_id = ?", sessionID).Delete(&models.ChatMessage{})
	return r.db.Where("id = ? AND user_id = ?", sessionID, userID).Delete(&models.ChatSession{}).Error
}

func (r *chatRepository) RenameSession(ctx context.Context, userID uint, sessionID uint, newTitle string) error {
	return r.db.Model(&models.ChatSession{}).Where("id = ? AND user_id = ?", sessionID, userID).Update("title", newTitle).Error
}

func (r *chatRepository) UpdateSessionTitle(ctx context.Context, sessionID uint, newTitle string) error {
	return r.db.Model(&models.ChatSession{}).Where("id = ?", sessionID).Update("title", newTitle).Error
}

func (r *chatRepository) GetAllSessions(ctx context.Context, search string, limit int, offset int) ([]models.ChatSession, int64, error) {
	var sessions []models.ChatSession
	var totalCount int64
	query := r.db.Model(&models.ChatSession{})
	if search != "" {
		query = query.Where("title LIKE ?", "%"+search+"%")
	}
	err := query.Count(&totalCount).Error
	if err != nil {
		return nil, 0, fmt.Errorf("chatRepository.GetAllSessions: %w", err)
	}
	if err = query.Preload("Messages").Order("updated_at desc").Limit(limit).Offset(offset).Find(&sessions).Error; err != nil {
		return nil, 0, fmt.Errorf("chatRepository.GetAllSessions: %w", err)
	}
	return sessions, totalCount, nil
}
