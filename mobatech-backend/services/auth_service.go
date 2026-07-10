package services

import (
	"fmt"

	"backend/constants"

	"context"

	"backend/models"
	"backend/repositories"
	"os"
	"time"

	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)

type AuthService interface {
	Register(ctx context.Context, fullName, email, phone, password string) (*models.User, error)
	Login(ctx context.Context, email, password string) (string, *models.User, error)
	GetUser(ctx context.Context, userID uint) (*models.User, error)
	UpdateProfile(ctx context.Context, userID uint, fullName, phone, imagePath, bloodType string, height int, weight int, allergies, dob, gender string) (*models.User, error)
	AddFamilyMember(ctx context.Context, member *models.FamilyMember) error
	DeleteFamilyMember(ctx context.Context, id uint) error
	GetAllUsers(ctx context.Context, search string, filter string, roleFilter string, viewerID uint, viewerRole string, limit int, offset int) ([]models.User, int64, error)
	AdminCreateUser(ctx context.Context, fullName, email, phone, password, role, imageURL string) (*models.User, error)
	AdminUpdateUser(ctx context.Context, id uint, fullName, email, phone, role, imageURL string) (*models.User, error)
	DeleteUser(ctx context.Context, id uint) error
}
type authService struct {
	repo repositories.AuthRepository
}

func NewAuthService(repo repositories.AuthRepository) AuthService {
	return &authService{repo}
}
func (s *authService) Register(ctx context.Context, fullName, email, phone, password string) (*models.User, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("authService.Register: %w", err)
	}
	user := &models.User{FullName: fullName, Email: email, PhoneNumber: phone, Password: string(hashedPassword), Role: constants.RolePatient}
	if err := s.repo.CreateUser(ctx, user); err != nil {
		return nil, fmt.Errorf("authService.Register: %w", err)
	}
	return user, nil
}
func (s *authService) Login(ctx context.Context, email, password string) (string, *models.User, error) {
	user, err := s.repo.FindByEmail(ctx, email)
	if err != nil {
		return "", nil, fmt.Errorf("authService.Login: %w", constants.ErrInvalidEmailOrPassword)
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", nil, fmt.Errorf("authService.Login: %w", constants.ErrInvalidEmailOrPassword)
	}
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		return "", nil, fmt.Errorf("authService.Login: %w", constants.ErrJWTSecretNotConfigured)
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": user.ID, "role": user.Role,
		"exp": time.Now().Add(constants.JWTExpirationTime).Unix(),
	})
	tokenString, err := token.SignedString([]byte(secret))
	if err != nil {
		return "", nil, fmt.Errorf("authService.Login: %w", err)
	}
	return tokenString, user, nil
}
func (s *authService) GetUser(ctx context.Context, userID uint) (*models.User, error) {
	return s.repo.FindByID(ctx, userID)
}
func (s *authService) GetAllUsers(ctx context.Context, search string, filter string, roleFilter string, viewerID uint, viewerRole string, limit int, offset int) ([]models.User, int64, error) {
	return s.repo.GetAllUsers(ctx, search, filter, roleFilter, viewerID, viewerRole, limit, offset)
}
func (s *authService) AddFamilyMember(ctx context.Context, member *models.FamilyMember) error {
	return s.repo.AddFamilyMember(ctx, member)
}
func (s *authService) DeleteFamilyMember(ctx context.Context, id uint) error {
	return s.repo.DeleteFamilyMember(ctx, id)
}
func (s *authService) DeleteUser(ctx context.Context, id uint) error {
	return s.repo.DeleteUser(ctx, id)
}
func (s *authService) UpdateProfile(ctx context.Context, userID uint, fullName, phone, imagePath, bloodType string, height int, weight int, allergies, dob, gender string) (*models.User, error) {
	user, err := s.repo.FindByID(ctx, userID)
	if err != nil {
		return nil, fmt.Errorf("authService.UpdateProfile: %w", constants.ErrUserNotFound)
	}
	s.applyProfileUpdates(ctx, user, fullName, phone, imagePath, bloodType, height, weight, allergies, dob, gender)
	if err := s.repo.UpdateUser(ctx, user); err != nil {
		return nil, fmt.Errorf("authService.UpdateProfile: %w", err)
	}
	return user, nil
}
func (s *authService) applyProfileUpdates(ctx context.Context, user *models.User, fullName, phone, imagePath, bloodType string, height int, weight int, allergies, dob, gender string) {
	if fullName != "" {
		user.FullName = fullName
	}
	if phone != "" {
		user.PhoneNumber = phone
	}
	if imagePath != "" {
		user.ImageURL = imagePath
	}
	if bloodType != "" {
		user.BloodType = bloodType
	}
	if height > 0 {
		user.Height = height
	}
	if weight > 0 {
		user.Weight = weight
	}
	if allergies != "" {
		user.Allergies = allergies
	}
	if dob != "" {
		user.DateOfBirth = dob
	}
	if gender != "" {
		user.Gender = gender
	}
}
