package repositories

import (
	"fmt"

	"context"

	"backend/models"

	"gorm.io/gorm"
)

func (r *pharmacyRepository) GetCartByUserID(ctx context.Context, userID uint) (*models.Cart, error) {
	var cart models.Cart
	if err := r.db.Preload("Items").Preload("Items.Medicine").Where("user_id = ?", userID).FirstOrCreate(&cart, models.Cart{UserID: userID}).Error; err != nil {
		return nil, fmt.Errorf("pharmacyRepository.GetCartByUserID: %w", err)
	}
	return &cart, nil
}

func (r *pharmacyRepository) AddToCart(ctx context.Context, userID uint, medicineID uint, quantity int) error {
	cart, err := r.GetCartByUserID(ctx, userID)
	if err != nil {
		return fmt.Errorf("pharmacyRepository.AddToCart: %w", err)
	}

	var item models.CartItem
	err = r.db.Where("cart_id = ? AND medicine_id = ?", cart.ID, medicineID).First(&item).Error
	if err == nil {
		item.Quantity += quantity
		return r.db.Omit("created_at").Save(&item).Error
	} else if err == gorm.ErrRecordNotFound {
		newItem := models.CartItem{
			CartID:     cart.ID,
			MedicineID: medicineID,
			Quantity:   quantity,
		}
		return r.db.Create(&newItem).Error
	}
	return fmt.Errorf("pharmacyRepository.AddToCart: %w", err)
}

func (r *pharmacyRepository) UpdateCartItemQuantity(ctx context.Context, userID uint, cartItemID uint, quantity int) error {
	cart, err := r.GetCartByUserID(ctx, userID)
	if err != nil {
		return fmt.Errorf("pharmacyRepository.UpdateCartItemQuantity: %w", err)
	}
	return r.db.Model(&models.CartItem{}).Where("id = ? AND cart_id = ?", cartItemID, cart.ID).Update("quantity", quantity).Error
}

func (r *pharmacyRepository) RemoveFromCart(ctx context.Context, userID uint, cartItemID uint) error {
	cart, err := r.GetCartByUserID(ctx, userID)
	if err != nil {
		return fmt.Errorf("pharmacyRepository.RemoveFromCart: %w", err)
	}
	return r.db.Where("id = ? AND cart_id = ?", cartItemID, cart.ID).Delete(&models.CartItem{}).Error
}

func (r *pharmacyRepository) ClearCart(ctx context.Context, userID uint) error {
	cart, err := r.GetCartByUserID(ctx, userID)
	if err != nil {
		return fmt.Errorf("pharmacyRepository.ClearCart: %w", err)
	}
	return r.db.Where("cart_id = ?", cart.ID).Delete(&models.CartItem{}).Error
}
