package repositories

import (
	"fmt"

	"context"

	"backend/models"
	"backend/utils"

	"gorm.io/gorm"
)

type AuthRepository interface {
	CreateUser(ctx context.Context, user *models.User) error
	FindByEmail(ctx context.Context, email string) (*models.User, error)
	FindByID(ctx context.Context, id uint) (*models.User, error)
	UpdateUser(ctx context.Context, user *models.User) error
	AddFamilyMember(ctx context.Context, member *models.FamilyMember) error
	DeleteFamilyMember(ctx context.Context, id uint) error
	GetAllUsers(ctx context.Context, search string, filter string, roleFilter string, viewerID uint, viewerRole string, limit int, offset int) ([]models.User, int64, error)
	DeleteUser(ctx context.Context, id uint) error
}

type authRepository struct {
	db *gorm.DB
}

func NewAuthRepository(db *gorm.DB) AuthRepository {
	return &authRepository{db}
}

func (r *authRepository) CreateUser(ctx context.Context, user *models.User) error {
	return r.db.Create(user).Error
}

func (r *authRepository) FindByEmail(ctx context.Context, email string) (*models.User, error) {
	var user models.User
	if err := r.db.Preload("FamilyMembers").
		Select("users.*, CASE WHEN users.image_url IS NULL OR users.image_url = '' THEN COALESCE(doctors.image_url, '') ELSE users.image_url END AS image_url").
		Joins("LEFT JOIN doctors ON doctors.user_id = users.id AND doctors.deleted_at IS NULL").
		Where("users.email = ?", email).First(&user).Error; err != nil {
		return nil, fmt.Errorf("authRepository.FindByEmail: %w", err)
	}
	return &user, nil
}

func (r *authRepository) FindByID(ctx context.Context, id uint) (*models.User, error) {
	var user models.User
	if err := r.db.Preload("FamilyMembers").
		Select("users.*, CASE WHEN users.image_url IS NULL OR users.image_url = '' THEN COALESCE(doctors.image_url, '') ELSE users.image_url END AS image_url").
		Joins("LEFT JOIN doctors ON doctors.user_id = users.id AND doctors.deleted_at IS NULL").
		Where("users.id = ?", id).First(&user).Error; err != nil {
		return nil, fmt.Errorf("authRepository.FindByID: %w", err)
	}
	return &user, nil
}

func (r *authRepository) UpdateUser(ctx context.Context, user *models.User) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		if err := tx.Omit("created_at").Save(user).Error; err != nil {
			return err
		}
		if user.Role == "doctor" {
			d := map[string]interface{}{}
			if user.FullName != "" { d["name"] = user.FullName }
			if user.ImageURL != "" { d["image_url"] = user.ImageURL }
			if user.PhoneNumber != "" { d["contact_info"] = user.PhoneNumber }
			if len(d) > 0 {
				return tx.Model(&models.Doctor{}).Where("user_id = ?", user.ID).Updates(d).Error
			}
		}
		return nil
	})
}

func (r *authRepository) DeleteUser(ctx context.Context, id uint) error {
	return r.db.Delete(&models.User{}, id).Error
}

func (r *authRepository) AddFamilyMember(ctx context.Context, member *models.FamilyMember) error {
	return r.db.Create(member).Error
}

func (r *authRepository) DeleteFamilyMember(ctx context.Context, id uint) error {
	return r.db.Delete(&models.FamilyMember{}, id).Error
}

func (r *authRepository) GetAllUsers(ctx context.Context, search string, filter string, roleFilter string, viewerID uint, viewerRole string, limit int, offset int) ([]models.User, int64, error) {
	var users []models.User
	var totalCount int64
	query := r.buildUserQuery(ctx, search, filter, roleFilter, viewerID, viewerRole)

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("authRepository.GetAllUsers: %w", err)
	}

	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}

	if err := query.Preload("FamilyMembers").Find(&users).Error; err != nil {
		return nil, 0, fmt.Errorf("authRepository.GetAllUsers: %w", err)
	}
	return users, totalCount, nil
}

func (r *authRepository) buildUserQuery(ctx context.Context, search, filter, roleFilter string, viewerID uint, viewerRole string) *gorm.DB {
	query := r.db.Model(&models.User{}).
		Select("users.*, CASE WHEN users.image_url IS NULL OR users.image_url = '' THEN COALESCE(doctors.image_url, '') ELSE users.image_url END AS image_url").
		Joins("LEFT JOIN doctors ON doctors.user_id = users.id AND doctors.deleted_at IS NULL")

	if viewerRole == "doctor" && roleFilter == "patient" {
		query = query.Where("users.id IN (SELECT user_id FROM appointments WHERE doctor_id = (SELECT id FROM doctors WHERE user_id = ? LIMIT 1))", viewerID)
	}
	if roleFilter != "" {
		query = query.Where("users.role = ?", roleFilter)
	}
	if search != "" {
		s := "%" + utils.EscapeLike(search) + "%"
		query = query.Where("users.full_name LIKE ? OR users.email LIKE ? OR users.phone_number LIKE ?", s, s, s)
	}
	if filter == "newest" {
		query = query.Order("users.created_at desc")
	} else if filter == "oldest" {
		query = query.Order("users.created_at asc")
	}
	return query
}
