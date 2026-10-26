package repositories

import (
	"backend/constants"
	"backend/models"
	"backend/utils"
	"context"
	"fmt"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

func (r *pharmacyRepository) GetOrdersByUserID(ctx context.Context, userID uint, limit int, offset int) ([]models.PharmacyOrder, int64, error) {
	var orders []models.PharmacyOrder
	var totalCount int64

	query := r.db.Model(&models.PharmacyOrder{}).Where("user_id = ?", userID)
	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetOrdersByUserID: %w", err)
	}

	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}

	err := query.Preload("Items").Preload("Items.Medicine").
		Where("user_id = ?", userID).Order("created_at desc").Find(&orders).Error
	if err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetOrdersByUserID: %w", err)
	}
	return orders, totalCount, nil
}
func (r *pharmacyRepository) GetOrderByID(ctx context.Context, id uint) (*models.PharmacyOrder, error) {
	var order models.PharmacyOrder
	if err := r.db.Preload("Items").Preload("Items.Medicine").First(&order, id).Error; err != nil {
		return nil, fmt.Errorf("pharmacyRepository.GetOrderByID: %w", err)
	}
	return &order, nil
}
func (r *pharmacyRepository) GetAllOrders(ctx context.Context, search string, filter string, limit int, offset int) ([]models.PharmacyOrder, int64, error) {
	var orders []models.PharmacyOrder
	var totalCount int64
	query := r.db.Model(&models.PharmacyOrder{}).Joins("LEFT JOIN users ON pharmacy_orders.user_id = users.id")
	if search != "" {
		searchTerm := "%" + utils.EscapeLike(search) + "%"
		query = query.Where("users.full_name LIKE ? OR pharmacy_orders.delivery_address LIKE ?", searchTerm, searchTerm)
	}
	if filter != "" {
		query = query.Where("pharmacy_orders.status = ?", filter)
	}
	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetAllOrders: %w", err)
	}
	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}
	if err := query.Preload("Items").Preload("Items.Medicine").Order("pharmacy_orders.created_at desc").Find(&orders).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetAllOrders: %w", err)
	}
	return orders, totalCount, nil
}
func (r *pharmacyRepository) processOrderItems(ctx context.Context, tx *gorm.DB, order *models.PharmacyOrder) (float64, error) {
	var total float64
	for i, item := range order.Items {
		var med models.Medicine
		if err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).First(&med, item.MedicineID).Error; err != nil {
			return 0, fmt.Errorf("medicine %d not found: %w", item.MedicineID, constants.ErrMedicineNotFound)
		}
		if med.Stock < item.Quantity {
			return 0, fmt.Errorf("insufficient stock for %s: %w", med.Name, constants.ErrInsufficientStock)
		}
		med.Stock -= item.Quantity
		if err := tx.Save(&med).Error; err != nil {
			return 0, fmt.Errorf("pharmacyRepository.processOrderItems: %w", err)
		}
		order.Items[i].Price = med.Price
		order.Items[i].Subtotal = med.Price * float64(item.Quantity)
		total += order.Items[i].Subtotal
	}
	return total, nil
}
func (r *pharmacyRepository) CreateOrder(ctx context.Context, order *models.PharmacyOrder) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		total, err := r.processOrderItems(ctx, tx, order)
		if err != nil {
			return fmt.Errorf("pharmacyRepository.CreateOrder: %w", err)
		}
		order.TotalPrice = total
		if err := tx.Create(order).Error; err != nil {
			return fmt.Errorf("pharmacyRepository.CreateOrder: %w", err)
		}
		if order.PrescriptionID != nil {
			if err := tx.Model(&models.Prescription{}).Where("id = ?", *order.PrescriptionID).Update("status", "Redeemed").Error; err != nil {
				return fmt.Errorf("pharmacyRepository.CreateOrder: %w", err)
			}
		}
		return nil
	})
}
func (r *pharmacyRepository) UpdateOrderStatus(ctx context.Context, id uint, status string) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		var order models.PharmacyOrder
		if err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).Preload("Items").First(&order, id).Error; err != nil {
			return err
		}

		if status == "Cancelled" && order.Status != "Cancelled" {
			for _, item := range order.Items {
				if err := tx.Model(&models.Medicine{}).Where("id = ?", item.MedicineID).UpdateColumn("stock", gorm.Expr("stock + ?", item.Quantity)).Error; err != nil {
					return err
				}
			}
		} else if order.Status == "Cancelled" && status != "Cancelled" {
			for _, item := range order.Items {
				if err := tx.Model(&models.Medicine{}).Where("id = ?", item.MedicineID).UpdateColumn("stock", gorm.Expr("stock - ?", item.Quantity)).Error; err != nil {
					return err
				}
			}
		}

		return tx.Model(&order).Update("status", status).Error
	})
}
func (r *pharmacyRepository) UpdateOrderPayment(ctx context.Context, id uint, paymentStatus string) error {
	return r.db.Model(&models.PharmacyOrder{}).Where("id = ?", id).Update("payment_status", paymentStatus).Error
}
