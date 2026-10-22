package services

import (
	"fmt"

	"backend/constants"

	"context"

	"backend/models"
)

func (s *pharmacyService) GetCartByUserID(ctx context.Context, userID uint) (*models.Cart, error) {
	return s.repo.GetCartByUserID(ctx, userID)
}

func (s *pharmacyService) AddToCart(ctx context.Context, userID uint, medicineID uint, quantity int) error {
	if quantity <= 0 {
		return fmt.Errorf("pharmacyService.AddToCart: %w", constants.ErrQuantityMustBeGreaterThan0)
	}
	return s.repo.AddToCart(ctx, userID, medicineID, quantity)
}

func (s *pharmacyService) UpdateCartItemQuantity(ctx context.Context, userID uint, cartItemID uint, quantity int) error {
	if quantity <= 0 {
		return fmt.Errorf("pharmacyService.UpdateCartItemQuantity: %w", constants.ErrQuantityMustBeGreaterThan0)
	}
	return s.repo.UpdateCartItemQuantity(ctx, userID, cartItemID, quantity)
}

func (s *pharmacyService) RemoveFromCart(ctx context.Context, userID uint, cartItemID uint) error {
	return s.repo.RemoveFromCart(ctx, userID, cartItemID)
}

func (s *pharmacyService) ClearCart(ctx context.Context, userID uint) error {
	return s.repo.ClearCart(ctx, userID)
}
