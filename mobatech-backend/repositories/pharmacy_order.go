package repositories

import (
	"backend/models"
	"context"
	"fmt"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

func (r *pharmacyRepository) GetPrescriptionsByUserID(ctx context.Context, userID uint, limit int, offset int) ([]models.Prescription, int64, error) {
	var prescriptions []models.Prescription
	var totalCount int64
	query := r.db.Model(&models.Prescription{}).Where("user_id = ?", userID)
	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetPrescriptionsByUserID: %w", err)
	}
	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}
	if err := query.Preload("Items").Preload("Items.Medicine").Order("created_at desc").Find(&prescriptions).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetPrescriptionsByUserID: %w", err)
	}
	return prescriptions, totalCount, nil
}
func (r *pharmacyRepository) GetPrescriptionByID(ctx context.Context, id uint) (*models.Prescription, error) {
	var prescription models.Prescription
	if err := r.db.Preload("Items").Preload("Items.Medicine").First(&prescription, id).Error; err != nil {
		return nil, fmt.Errorf("pharmacyRepository.GetPrescriptionByID: %w", err)
	}
	return &prescription, nil
}
func (r *pharmacyRepository) GetAllPrescriptions(ctx context.Context, limit int, offset int) ([]models.Prescription, int64, error) {
	var prescriptions []models.Prescription
	var totalCount int64
	query := r.db.Model(&models.Prescription{})
	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetAllPrescriptions: %w", err)
	}
	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}
	if err := query.Preload("Items").Preload("Items.Medicine").Order("created_at desc").Find(&prescriptions).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetAllPrescriptions: %w", err)
	}
	return prescriptions, totalCount, nil
}
func (r *pharmacyRepository) CreatePrescription(ctx context.Context, p *models.Prescription) error {
	return r.db.Create(p).Error
}
func (r *pharmacyRepository) CheckPrescriptionExistsByAppointment(ctx context.Context, appointmentID uint) (bool, error) {
	var count int64
	err := r.db.Model(&models.Prescription{}).Where("appointment_id = ?", appointmentID).Count(&count).Error
	return count > 0, err
}
func (r *pharmacyRepository) DeletePrescription(ctx context.Context, id uint) error {
	return r.db.Delete(&models.Prescription{}, id).Error
}
func (r *pharmacyRepository) UpdatePrescriptionStatus(ctx context.Context, id uint, status string) error {
	return r.db.Model(&models.Prescription{}).Where("id = ?", id).Update("status", status).Error
}
func (r *pharmacyRepository) GetOrdersByUserID(ctx context.Context, userID uint) ([]models.PharmacyOrder, error) {
	var orders []models.PharmacyOrder
	err := r.db.Preload("Items").Preload("Items.Medicine").
		Where("user_id = ?", userID).Order("created_at desc").Find(&orders).Error
	if err != nil {
		return nil, fmt.Errorf("pharmacyRepository.GetOrdersByUserID: %w", err)
	}
	return orders, nil
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
		searchTerm := "%" + search + "%"
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
			return 0, fmt.Errorf("medicine %d not found", item.MedicineID)
		}
		if med.Stock < item.Quantity {
			return 0, fmt.Errorf("insufficient stock for %s", med.Name)
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
	return r.db.Model(&models.PharmacyOrder{}).Where("id = ?", id).Update("status", status).Error
}
func (r *pharmacyRepository) UpdateOrderPayment(ctx context.Context, id uint, paymentStatus string) error {
	return r.db.Model(&models.PharmacyOrder{}).Where("id = ?", id).Update("payment_status", paymentStatus).Error
}
