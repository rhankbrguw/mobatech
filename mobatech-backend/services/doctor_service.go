package services

import (
	"fmt"

	"context"

	"backend/models"
	"backend/repositories"
	"backend/utils"
)

type DoctorService interface {
	GetAllDoctors(ctx context.Context, search string, filter string, specialization string, polyclinicID uint, limit, offset int) ([]models.Doctor, int64, error)
	GetDoctorByID(ctx context.Context, id uint) (*models.Doctor, error)
	CreateDoctor(ctx context.Context, doctor *models.Doctor) error
	UpdateDoctor(ctx context.Context, id uint, input *models.Doctor) (*models.Doctor, error)
	DeleteDoctor(ctx context.Context, id uint) error
}

type doctorService struct {
	doctorRepo repositories.DoctorRepository
}

func NewDoctorService(doctorRepo repositories.DoctorRepository) DoctorService {
	return &doctorService{doctorRepo}
}

func (s *doctorService) GetAllDoctors(ctx context.Context, search string, filter string, specialization string, polyclinicID uint, limit, offset int) ([]models.Doctor, int64, error) {
	return s.doctorRepo.FindAll(ctx, search, filter, specialization, polyclinicID, limit, offset)
}

func (s *doctorService) GetDoctorByID(ctx context.Context, id uint) (*models.Doctor, error) {
	return s.doctorRepo.FindByID(ctx, id)
}

func (s *doctorService) CreateDoctor(ctx context.Context, doctor *models.Doctor) error {
	doctor.IsActive = true
	err := s.doctorRepo.Create(ctx, doctor)
	if err == nil {
		utils.TriggerAsyncRAGSync()
	}
	return fmt.Errorf("doctorService.CreateDoctor: %w", err)
}

func (s *doctorService) UpdateDoctor(ctx context.Context, id uint, input *models.Doctor) (*models.Doctor, error) {
	doctor, err := s.doctorRepo.FindByID(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("doctorService.UpdateDoctor: %w", err)
	}

	s.applyDoctorUpdates(ctx, doctor, input)

	err = s.doctorRepo.Update(ctx, doctor)
	if err != nil {
		return nil, fmt.Errorf("doctorService.UpdateDoctor: %w", err)
	}

	utils.TriggerAsyncRAGSync()
	return doctor, nil
}

func (s *doctorService) applyDoctorUpdates(ctx context.Context, doctor, input *models.Doctor) {
	if input.Name != "" {
		doctor.Name = input.Name
	}
	if input.Specialization != "" {
		doctor.Specialization = input.Specialization
	}
	if input.ContactInfo != "" {
		doctor.ContactInfo = input.ContactInfo
	}
	if input.Description != "" {
		doctor.Description = input.Description
	}
	if input.ImageURL != "" {
		doctor.ImageURL = input.ImageURL
	}
	doctor.PolyclinicID = input.PolyclinicID
}

func (s *doctorService) DeleteDoctor(ctx context.Context, id uint) error {
	err := s.doctorRepo.Delete(ctx, id)
	if err == nil {
		utils.TriggerAsyncRAGSync()
	}
	return fmt.Errorf("doctorService.DeleteDoctor: %w", err)
}
