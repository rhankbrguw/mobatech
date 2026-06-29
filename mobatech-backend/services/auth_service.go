package services
import (
	"backend/models"
	"backend/repositories"
	"errors"
	"os"
	"time"
	"github.com/golang-jwt/jwt/v5"
	"golang.org/x/crypto/bcrypt"
)
type AuthService interface {
	Register(fullName, email, phone, password string) (*models.User, error)
	Login(email, password string) (string, *models.User, error)
	GetUser(userID uint) (*models.User, error)
	UpdateProfile(userID uint, fullName, phone, imagePath, bloodType string, height int, weight int, allergies, dob, gender string) (*models.User, error)
	AddFamilyMember(member *models.FamilyMember) error
	DeleteFamilyMember(id uint) error
	GetAllUsers(search string, filter string, roleFilter string) ([]models.User, error)
	AdminCreateUser(fullName, email, phone, password, role, imageURL string) (*models.User, error)
	AdminUpdateUser(id uint, fullName, email, phone, role, imageURL string) (*models.User, error)
	DeleteUser(id uint) error
}
type authService struct {
	repo repositories.AuthRepository
}
func NewAuthService(repo repositories.AuthRepository) AuthService {
	return &authService{repo}
}
func (s *authService) AdminCreateUser(fullName, email, phone, password, role, imageURL string) (*models.User, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	if role == "" {
		role = "patient"
	}
	user := &models.User{
		FullName:    fullName,
		Email:       email,
		PhoneNumber: phone,
		Password:    string(hashedPassword),
		Role:        role,
		ImageURL:    imageURL,
	}
	if err := s.repo.CreateUser(user); err != nil {
		return nil, err
	}
	return user, nil
}
func (s *authService) AdminUpdateUser(id uint, fullName, email, phone, role, imageURL string) (*models.User, error) {
	user, err := s.repo.FindByID(id)
	if err != nil {
		return nil, errors.New("user not found")
	}
	if fullName != "" {
		user.FullName = fullName
	}
	if email != "" {
		user.Email = email
	}
	if phone != "" {
		user.PhoneNumber = phone
	}
	if role != "" {
		user.Role = role
	}
	if imageURL != "" {
		user.ImageURL = imageURL
	}
	if err := s.repo.UpdateUser(user); err != nil {
		return nil, err
	}
	return user, nil
}
func (s *authService) DeleteUser(id uint) error {
	return s.repo.DeleteUser(id)
}
func (s *authService) Register(fullName, email, phone, password string) (*models.User, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, err
	}
	user := &models.User{
		FullName:    fullName,
		Email:       email,
		PhoneNumber: phone,
		Password:    string(hashedPassword),
		Role:        "patient",
	}
	if err := s.repo.CreateUser(user); err != nil {
		return nil, err
	}
	return user, nil
}
func (s *authService) Login(email, password string) (string, *models.User, error) {
	user, err := s.repo.FindByEmail(email)
	if err != nil {
		return "", nil, errors.New("invalid email or password")
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(password)); err != nil {
		return "", nil, errors.New("invalid email or password")
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": user.ID,
		"role":    user.Role,
		"exp":     time.Now().Add(time.Hour * 72).Unix(),
	})
	secret := os.Getenv("JWT_SECRET")
	if secret == "" {
		secret = "default_secret" // fallback
	}
	tokenString, err := token.SignedString([]byte(secret))
	if err != nil {
		return "", nil, err
	}
	return tokenString, user, nil
}
func (s *authService) GetUser(userID uint) (*models.User, error) {
	return s.repo.FindByID(userID)
}
func (s *authService) UpdateProfile(userID uint, fullName, phone, imagePath, bloodType string, height int, weight int, allergies, dob, gender string) (*models.User, error) {
	user, err := s.repo.FindByID(userID)
	if err != nil {
		return nil, errors.New("user not found")
	}
	s.applyProfileUpdates(user, fullName, phone, imagePath, bloodType, height, weight, allergies, dob, gender)
	if err := s.repo.UpdateUser(user); err != nil {
		return nil, err
	}
	return user, nil
}
func (s *authService) AddFamilyMember(member *models.FamilyMember) error {
	return s.repo.AddFamilyMember(member)
}
func (s *authService) DeleteFamilyMember(id uint) error {
	return s.repo.DeleteFamilyMember(id)
}
func (s *authService) GetAllUsers(search string, filter string, roleFilter string) ([]models.User, error) {
	return s.repo.GetAllUsers(search, filter, roleFilter)
}
func (s *authService) applyProfileUpdates(user *models.User, fullName, phone, imagePath, bloodType string, height int, weight int, allergies, dob, gender string) {
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
