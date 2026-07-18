package repositories

import (
	"fmt"

	"context"

	"backend/models"

	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type PharmacyRepository interface {
	GetAllCategories(ctx context.Context) ([]models.MedicineCategory, error)
	GetCategoryByID(ctx context.Context, id uint) (*models.MedicineCategory, error)
	CreateCategory(ctx context.Context, cat *models.MedicineCategory) error
	UpdateCategory(ctx context.Context, cat *models.MedicineCategory) error
	DeleteCategory(ctx context.Context, id uint) error

	GetAllMedicines(ctx context.Context, categoryID uint, search string, limit int, offset int) ([]models.Medicine, int64, error)
	GetMedicineByID(ctx context.Context, id uint) (*models.Medicine, error)
	CreateMedicine(ctx context.Context, med *models.Medicine) error
	UpdateMedicine(ctx context.Context, med *models.Medicine) error
	DeleteMedicine(ctx context.Context, id uint) error
	UpdateMedicineStock(ctx context.Context, id uint, quantityChange int) error

	GetPrescriptionsByUserID(ctx context.Context, userID uint, limit int, offset int) ([]models.Prescription, int64, error)
	GetPrescriptionByID(ctx context.Context, id uint) (*models.Prescription, error)
	GetAllPrescriptions(ctx context.Context, limit int, offset int) ([]models.Prescription, int64, error)
	CreatePrescription(ctx context.Context, p *models.Prescription) error
	CheckPrescriptionExistsByAppointment(ctx context.Context, appointmentID uint) (bool, error)
	DeletePrescription(ctx context.Context, id uint) error
	UpdatePrescriptionStatus(ctx context.Context, id uint, status string, notes *string) error

	GetOrdersByUserID(ctx context.Context, userID uint) ([]models.PharmacyOrder, error)
	GetOrderByID(ctx context.Context, id uint) (*models.PharmacyOrder, error)
	GetAllOrders(ctx context.Context, search string, filter string, limit int, offset int) ([]models.PharmacyOrder, int64, error)
	CreateOrder(ctx context.Context, order *models.PharmacyOrder) error
	UpdateOrderStatus(ctx context.Context, id uint, status string) error
	UpdateOrderPayment(ctx context.Context, id uint, paymentStatus string) error

	GetCartByUserID(ctx context.Context, userID uint) (*models.Cart, error)
	AddToCart(ctx context.Context, userID uint, medicineID uint, quantity int) error
	UpdateCartItemQuantity(ctx context.Context, userID uint, cartItemID uint, quantity int) error
	RemoveFromCart(ctx context.Context, userID uint, cartItemID uint) error
	ClearCart(ctx context.Context, userID uint) error
}
type pharmacyRepository struct {
	db *gorm.DB
}

func NewPharmacyRepository(db *gorm.DB) PharmacyRepository {
	return &pharmacyRepository{db}
}

func (r *pharmacyRepository) GetAllCategories(ctx context.Context) ([]models.MedicineCategory, error) {
	var cats []models.MedicineCategory
	if err := r.db.Find(&cats).Error; err != nil {
		return nil, fmt.Errorf("pharmacyRepository.GetAllCategories: %w", err)
	}
	return cats, nil
}

func (r *pharmacyRepository) GetCategoryByID(ctx context.Context, id uint) (*models.MedicineCategory, error) {
	var cat models.MedicineCategory
	if err := r.db.First(&cat, id).Error; err != nil {
		return nil, fmt.Errorf("pharmacyRepository.GetCategoryByID: %w", err)
	}
	return &cat, nil
}

func (r *pharmacyRepository) CreateCategory(ctx context.Context, cat *models.MedicineCategory) error {
	return r.db.Create(cat).Error
}

func (r *pharmacyRepository) UpdateCategory(ctx context.Context, cat *models.MedicineCategory) error {
	return r.db.Omit("created_at").Save(cat).Error
}

func (r *pharmacyRepository) DeleteCategory(ctx context.Context, id uint) error {
	return r.db.Delete(&models.MedicineCategory{}, id).Error
}

func (r *pharmacyRepository) GetAllMedicines(ctx context.Context, categoryID uint, search string, limit int, offset int) ([]models.Medicine, int64, error) {
	var meds []models.Medicine
	var totalCount int64
	query := r.db.Model(&models.Medicine{})

	if categoryID > 0 {
		query = query.Where("category_id = ?", categoryID)
	}

	if search != "" {
		searchPattern := "%" + search + "%"
		query = query.Where("name LIKE ? OR generic_name LIKE ?", searchPattern, searchPattern)
	}

	if err := query.Count(&totalCount).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetAllMedicines: %w", err)
	}

	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}

	if err := query.Preload("Category").Find(&meds).Error; err != nil {
		return nil, 0, fmt.Errorf("pharmacyRepository.GetAllMedicines: %w", err)
	}
	return meds, totalCount, nil
}

func (r *pharmacyRepository) GetMedicineByID(ctx context.Context, id uint) (*models.Medicine, error) {
	var med models.Medicine
	if err := r.db.Preload("Category").First(&med, id).Error; err != nil {
		return nil, fmt.Errorf("pharmacyRepository.GetMedicineByID: %w", err)
	}
	return &med, nil
}

func (r *pharmacyRepository) CreateMedicine(ctx context.Context, med *models.Medicine) error {
	return r.db.Create(med).Error
}

func (r *pharmacyRepository) UpdateMedicine(ctx context.Context, med *models.Medicine) error {
	return r.db.Omit("created_at").Save(med).Error
}

func (r *pharmacyRepository) DeleteMedicine(ctx context.Context, id uint) error {
	return r.db.Delete(&models.Medicine{}, id).Error
}

func (r *pharmacyRepository) UpdateMedicineStock(ctx context.Context, id uint, quantityChange int) error {
	return r.db.Transaction(func(tx *gorm.DB) error {
		var med models.Medicine
		if err := tx.Clauses(clause.Locking{Strength: "UPDATE"}).First(&med, id).Error; err != nil {
			return fmt.Errorf("pharmacyRepository.UpdateMedicineStock: %w", err)
		}
		if med.Stock+quantityChange < 0 {
			return fmt.Errorf("pharmacyRepository.UpdateMedicineStock: insufficient stock")
		}
		return tx.Model(&med).UpdateColumn("stock", med.Stock+quantityChange).Error
	})
}
