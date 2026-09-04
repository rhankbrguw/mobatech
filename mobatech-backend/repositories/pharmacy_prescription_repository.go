package repositories

import (
	"backend/models"
	"backend/utils"
	"context"
	"fmt"
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
func (r *pharmacyRepository) GetAllPrescriptions(ctx context.Context, search string, filter string, limit int, offset int) ([]models.Prescription, int64, error) {
	var prescriptions []models.Prescription
	var totalCount int64
	query := r.db.Model(&models.Prescription{}).Joins("LEFT JOIN users ON prescriptions.user_id = users.id")

	if search != "" {
		searchTerm := "%" + utils.EscapeLike(search) + "%"
		query = query.Where("users.full_name LIKE ? OR prescriptions.doctor_name LIKE ?", searchTerm, searchTerm)
	}
	if filter != "" {
		query = query.Where("prescriptions.status = ?", filter)
	}

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetAllPrescriptions: %w", err)
	}
	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}
	if err := query.Preload("Items").Preload("Items.Medicine").Order("prescriptions.created_at desc").Find(&prescriptions).Error; err != nil {
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
func (r *pharmacyRepository) UpdatePrescriptionStatus(ctx context.Context, id uint, status string, notes *string) error {
	updates := map[string]interface{}{"status": status}
	if notes != nil {
		updates["notes"] = *notes
	}
	return r.db.Model(&models.Prescription{}).Where("id = ?", id).Updates(updates).Error
}
