package controllers

import (
	"backend/constants"
	"backend/utils"
	"fmt"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

type profileUpdateRequest struct {
	fullName  string
	phone     string
	bloodType string
	height    int
	weight    int
	allergies string
	dob       string
	gender    string
}

func parseProfileUpdateRequest(ctx *gin.Context) (*profileUpdateRequest, error) {
	height, err := strconv.Atoi(ctx.PostForm("height"))
	if err != nil {
		return nil, utils.NewValidationError("Invalid height parameter")
	}
	weight, err := strconv.Atoi(ctx.PostForm("weight"))
	if err != nil {
		return nil, utils.NewValidationError("Invalid weight parameter")
	}
	fullName := ctx.PostForm("full_name")
	if fullName != "" {
		if err := utils.ValidateName(fullName, "Nama lengkap"); err != nil {
			return nil, err
		}
	}
	phone := ctx.PostForm("phone_number")
	if phone != "" {
		if err := utils.ValidatePhone(phone); err != nil {
			return nil, err
		}
	}
	return &profileUpdateRequest{
		fullName:  fullName,
		phone:     phone,
		bloodType: ctx.PostForm("blood_type"),
		height:    height,
		weight:    weight,
		allergies: ctx.PostForm("allergies"),
		dob:       ctx.PostForm("date_of_birth"),
		gender:    ctx.PostForm("gender"),
	}, nil
}

func handleImageUpload(ctx *gin.Context, userID float64) string {
	file, err := ctx.FormFile("image")
	if err != nil {
		return ""
	}
	filename := fmt.Sprintf("%d_%d_%s", int(userID), time.Now().Unix(), file.Filename)
	dst := "uploads/" + filename
	if err := ctx.SaveUploadedFile(file, dst); err == nil {
		return fmt.Sprintf("%s/uploads/%s", strings.TrimSuffix(constants.UploadURL, "/"), filename)
	}
	return ""
}
