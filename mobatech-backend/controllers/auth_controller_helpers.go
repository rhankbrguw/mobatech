package controllers

import (
	"backend/controllers/dto"
	"backend/utils"
)

func validateRegisterInput(req *dto.RegisterReq) error {
	if err := utils.ValidateName(req.FullName, "Nama lengkap"); err != nil {
		return err
	}
	if err := utils.ValidateEmail(req.Email); err != nil {
		return err
	}
	if err := utils.ValidatePhone(req.PhoneNumber); err != nil {
		return err
	}
	return utils.ValidatePassword(req.Password)
}

func validateAdminCreateUserInput(req *dto.AdminCreateUserReq) error {
	if err := utils.ValidateName(req.FullName, "Nama lengkap"); err != nil {
		return err
	}
	if err := utils.ValidateEmail(req.Email); err != nil {
		return err
	}
	if err := utils.ValidatePhone(req.PhoneNumber); err != nil {
		return err
	}
	return utils.ValidatePassword(req.Password)
}

func validateAdminUpdateUserInput(req *dto.AdminUpdateUserReq) error {
	if req.FullName != "" {
		if err := utils.ValidateName(req.FullName, "Nama lengkap"); err != nil {
			return err
		}
	}
	if req.Email != "" {
		if err := utils.ValidateEmail(req.Email); err != nil {
			return err
		}
	}
	if req.PhoneNumber != "" {
		if err := utils.ValidatePhone(req.PhoneNumber); err != nil {
			return err
		}
	}
	return nil
}
