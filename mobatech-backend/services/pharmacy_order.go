package services

import (
	"backend/config"
	"backend/constants"
	"context"
	"fmt"
	"time"

	"backend/models"
)

func (s *pharmacyService) GetPrescriptionsByUserID(ctx context.Context, userID uint, limit int, offset int) ([]models.Prescription, int64, error) {
	return s.repo.GetPrescriptionsByUserID(ctx, userID, limit, offset)
}

func (s *pharmacyService) GetPrescriptionByID(ctx context.Context, id uint) (*models.Prescription, error) {
	return s.repo.GetPrescriptionByID(ctx, id)
}

func (s *pharmacyService) GetAllPrescriptions(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Prescription, int64, error) {
	return s.repo.GetAllPrescriptions(ctx, search, filter, limit, offset)
}

func (s *pharmacyService) CreatePrescription(ctx context.Context, p *models.Prescription) error {
	if p.AppointmentID != nil && *p.AppointmentID != 0 {
		exists, err := s.repo.CheckPrescriptionExistsByAppointment(ctx, *p.AppointmentID)
		if err == nil && exists {
			return fmt.Errorf("pharmacyOrderService.CreateOrder: %w", constants.ErrPrescriptionAlreadyExists)
		}
	}
	p.Status = "Pending"
	if err := s.repo.CreatePrescription(ctx, p); err != nil {
		return err
	}
	BroadcastEvent(config.DB, &models.Notification{
		Role:      "pharmacist",
		Title:     constants.MsgNotifNewEResepTitle,
		Message:   constants.MsgNotifNewEResepPharmacist,
		Type:      "prescription",
		ActionURL: "/dashboard/prescriptions",
	})
	if p.UserID > 0 {
		BroadcastEvent(config.DB, &models.Notification{
			UserID:    &p.UserID,
			Role:      "patient",
			Title:     constants.MsgNotifNewEResepTitle,
			Message:   constants.MsgNotifNewEResepPatient,
			Type:      "prescription",
			ActionURL: "/prescriptions",
		})
	}
	return nil
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

func (s *pharmacyService) UpdatePrescriptionStatus(ctx context.Context, id uint, status string, notes *string) error {
	if err := s.repo.UpdatePrescriptionStatus(ctx, id, status, notes); err != nil {
		return err
	}
	p, err := s.repo.GetPrescriptionByID(ctx, id)
	if err == nil && p != nil {
		msg := fmt.Sprintf("Status e-resep Anda diperbarui menjadi %s.", status)
		if (status == "Rejected" || status == "Cancelled") && notes != nil && *notes != "" {
			msg = fmt.Sprintf("E-resep ditolak. Alasan: %s", *notes)
		} else if status == "Ready" || status == "Completed" {
			msg = "Resep obat Anda telah disiapkan oleh apoteker dan siap diambil."
		}
		BroadcastEvent(config.DB, &models.Notification{
			UserID:    &p.UserID,
			Role:      "patient",
			Title:     fmt.Sprintf("Status Resep: %s", status),
			Message:   msg,
			Type:      "prescription",
			ActionURL: "/prescriptions",
		})
	}
	return nil
}

func (s *pharmacyService) GetOrdersByUserID(ctx context.Context, userID uint, limit int, offset int) ([]models.PharmacyOrder, int64, error) {
	return s.repo.GetOrdersByUserID(ctx, userID, limit, offset)
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

	return s.repo.CreateOrder(ctx, order)
}

func (s *pharmacyService) UpdateOrderStatus(ctx context.Context, id uint, status string) error {
	if err := s.repo.UpdateOrderStatus(ctx, id, status); err != nil {
		return err
	}
	order, err := s.repo.GetOrderByID(ctx, id)
	if err == nil && order != nil {
		msg := fmt.Sprintf("Status pesanan obat Anda diperbarui menjadi %s.", status)
		if status == "Ready" || status == "Completed" {
			msg = constants.MsgNotifOrderStatusReady
		}
		BroadcastEvent(config.DB, &models.Notification{
			UserID:    &order.UserID,
			Role:      "patient",
			Title:     fmt.Sprintf("Pesanan Obat: %s", status),
			Message:   msg,
			Type:      "order",
			ActionURL: "/orders",
		})
	}
	return nil
}

func (s *pharmacyService) UpdateOrderPayment(ctx context.Context, id uint, paymentStatus string) error {
	return s.repo.UpdateOrderPayment(ctx, id, paymentStatus)
}
