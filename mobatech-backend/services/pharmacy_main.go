package services

import (
	"context"

	"backend/models"
	"backend/repositories"
)

type PharmacyService interface {
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

	GetPrescriptionsByUserID(ctx context.Context, userID uint, limit int, offset int) ([]models.Prescription, int64, error)
	GetPrescriptionByID(ctx context.Context, id uint) (*models.Prescription, error)
	GetAllPrescriptions(ctx context.Context, limit int, offset int) ([]models.Prescription, int64, error)
	CreatePrescription(ctx context.Context, p *models.Prescription) error
	DeletePrescription(ctx context.Context, id uint, userID *uint) error
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
type pharmacyService struct {
	repo repositories.PharmacyRepository
}

func NewPharmacyService(repo repositories.PharmacyRepository) PharmacyService {
	return &pharmacyService{repo}
}

func (s *pharmacyService) GetAllCategories(ctx context.Context) ([]models.MedicineCategory, error) {
	return s.repo.GetAllCategories(ctx)
}

func (s *pharmacyService) GetCategoryByID(ctx context.Context, id uint) (*models.MedicineCategory, error) {
	return s.repo.GetCategoryByID(ctx, id)
}

func (s *pharmacyService) CreateCategory(ctx context.Context, cat *models.MedicineCategory) error {
	return s.repo.CreateCategory(ctx, cat)
}

func (s *pharmacyService) UpdateCategory(ctx context.Context, cat *models.MedicineCategory) error {
	return s.repo.UpdateCategory(ctx, cat)
}

func (s *pharmacyService) DeleteCategory(ctx context.Context, id uint) error {
	return s.repo.DeleteCategory(ctx, id)
}

func (s *pharmacyService) GetAllMedicines(ctx context.Context, categoryID uint, search string, limit int, offset int) ([]models.Medicine, int64, error) {
	return s.repo.GetAllMedicines(ctx, categoryID, search, limit, offset)
}

func (s *pharmacyService) GetMedicineByID(ctx context.Context, id uint) (*models.Medicine, error) {
	return s.repo.GetMedicineByID(ctx, id)
}

func (s *pharmacyService) CreateMedicine(ctx context.Context, med *models.Medicine) error {
	return s.repo.CreateMedicine(ctx, med)
}

func (s *pharmacyService) UpdateMedicine(ctx context.Context, med *models.Medicine) error {
	return s.repo.UpdateMedicine(ctx, med)
}

func (s *pharmacyService) DeleteMedicine(ctx context.Context, id uint) error {
	return s.repo.DeleteMedicine(ctx, id)
}
