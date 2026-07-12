package services

import (
	"backend/constants"

	"context"

	"backend/models"
	"fmt"
	"time"
)

func (s *pharmacyService) GetPrescriptionsByUserID(ctx context.Context, userID uint, limit int, offset int) ([]models.Prescription, int64, error) {
	return s.repo.GetPrescriptionsByUserID(ctx, userID, limit, offset)
}

func (s *pharmacyService) GetPrescriptionByID(ctx context.Context, id uint) (*models.Prescription, error) {
	return s.repo.GetPrescriptionByID(ctx, id)
}

func (s *pharmacyService) GetAllPrescriptions(ctx context.Context, limit int, offset int) ([]models.Prescription, int64, error) {
	return s.repo.GetAllPrescriptions(ctx, limit, offset)
}

func (s *pharmacyService) CreatePrescription(ctx context.Context, p *models.Prescription) error {
	if p.AppointmentID != nil && *p.AppointmentID != 0 {
		exists, err := s.repo.CheckPrescriptionExistsByAppointment(ctx, *p.AppointmentID)
		if err == nil && exists {
			return fmt.Errorf("e-resep sudah diterbitkan untuk janji temu ini")
		}
	}
	p.Status = "Pending"
	return s.repo.CreatePrescription(ctx, p)
}

func (s *pharmacyService) DeletePrescription(ctx context.Context, id uint, userID *uint) error {
	if userID != nil {
		p, err := s.repo.GetPrescriptionByID(ctx, id)
		if err != nil {
			return fmt.Errorf("pharmacyService.DeletePrescription: %w", err)
		}
		if p.UserID != *userID {
			return fmt.Errorf("pharmacyService.DeletePrescription: %w", constants.ErrUnauthorizedToDeletePresc)
		}
	}
	return s.repo.DeletePrescription(ctx, id)
}

func (s *pharmacyService) UpdatePrescriptionStatus(ctx context.Context, id uint, status string) error {
	return s.repo.UpdatePrescriptionStatus(ctx, id, status)
}

func (s *pharmacyService) GetOrdersByUserID(ctx context.Context, userID uint) ([]models.PharmacyOrder, error) {
	return s.repo.GetOrdersByUserID(ctx, userID)
}

func (s *pharmacyService) GetOrderByID(ctx context.Context, id uint) (*models.PharmacyOrder, error) {
	return s.repo.GetOrderByID(ctx, id)
}

func (s *pharmacyService) GetAllOrders(ctx context.Context, search string, filter string, limit int, offset int) ([]models.PharmacyOrder, int64, error) {
	return s.repo.GetAllOrders(ctx, search, filter, limit, offset)
}

func (s *pharmacyService) CreateOrder(ctx context.Context, order *models.PharmacyOrder) error {
	if len(order.Items) == 0 {
		return fmt.Errorf("pharmacyService.CreateOrder: %w", constants.ErrOrderMustHaveItems)
	}

	order.OrderNumber = fmt.Sprintf("ORD-%d", time.Now().Unix())
	order.Status = "Pending"
	order.PaymentStatus = "Unpaid"

	// All stock check, lock, price calculation, and order creation
	// is now safely inside repo's atomic transaction to prevent race conditions.
	return s.repo.CreateOrder(ctx, order)
}

func (s *pharmacyService) UpdateOrderStatus(ctx context.Context, id uint, status string) error {
	order, err := s.repo.GetOrderByID(ctx, id)
	if err != nil {
		return fmt.Errorf("pharmacyService.UpdateOrderStatus: %w", err)
	}

	if status == "Cancelled" && order.Status != "Cancelled" {
		for _, item := range order.Items {
			// Increase stock back by item.Quantity
			s.repo.UpdateMedicineStock(ctx, item.MedicineID, item.Quantity)
		}
	} else if order.Status == "Cancelled" && status != "Cancelled" {
		// If order status is changed from Cancelled back to something else, deduct the stock again
		for _, item := range order.Items {
			s.repo.UpdateMedicineStock(ctx, item.MedicineID, -item.Quantity)
		}
	}

	return s.repo.UpdateOrderStatus(ctx, id, status)
}

func (s *pharmacyService) UpdateOrderPayment(ctx context.Context, id uint, paymentStatus string) error {
	return s.repo.UpdateOrderPayment(ctx, id, paymentStatus)
}
