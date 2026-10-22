package services

import (
	"fmt"

	"backend/constants"

	"context"

	"backend/models"

	"golang.org/x/crypto/bcrypt"
)

func (s *authService) AdminCreateUser(ctx context.Context, fullName, email, phone, password, role, imageURL string) (*models.User, error) {
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(password), bcrypt.DefaultCost)
	if err != nil {
		return nil, fmt.Errorf("authService.AdminCreateUser: %w", err)
	}
	if role == "" {
		role = "patient"
	}
	user := &models.User{FullName: fullName, Email: email, PhoneNumber: phone, Password: string(hashedPassword), Role: role, ImageURL: imageURL}
	if err := s.repo.CreateUser(ctx, user); err != nil {
		return nil, fmt.Errorf("authService.AdminCreateUser: %w", err)
	}
	return user, nil
}
func (s *authService) AdminUpdateUser(ctx context.Context, id uint, fullName, email, phone, role, imageURL string) (*models.User, error) {
	user, err := s.repo.FindByID(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("authService.AdminUpdateUser: %w", constants.ErrUserNotFound)
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
	if err := s.repo.UpdateUser(ctx, user); err != nil {
		return nil, fmt.Errorf("authService.AdminUpdateUser: %w", err)
	}
	return user, nil
}
