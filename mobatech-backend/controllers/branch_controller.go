package controllers

import (
	"net/http"
	"backend/models"

	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type BranchController struct {
	DB *gorm.DB
}

func NewBranchController(db *gorm.DB) *BranchController {
	return &BranchController{DB: db}
}

func (ctrl *BranchController) GetBranches(c *gin.Context) {
	var branches []models.Branch
	if err := ctrl.DB.Find(&branches).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch branches"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": branches})
}

func (ctrl *BranchController) GetBranchByID(c *gin.Context) {
	id := c.Param("id")
	var branch models.Branch
	if err := ctrl.DB.First(&branch, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Branch not found"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": branch})
}

func (ctrl *BranchController) CreateBranch(c *gin.Context) {
	var req models.Branch
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctrl.DB.Create(&req).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create branch"})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"data": req})
}

func (ctrl *BranchController) UpdateBranch(c *gin.Context) {
	id := c.Param("id")
	var branch models.Branch
	if err := ctrl.DB.First(&branch, id).Error; err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "Branch not found"})
		return
	}
	var req models.Branch
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	if err := ctrl.DB.Model(&branch).Updates(req).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update branch"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"data": branch})
}

func (ctrl *BranchController) DeleteBranch(c *gin.Context) {
	id := c.Param("id")
	if err := ctrl.DB.Delete(&models.Branch{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete branch"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Branch deleted successfully"})
}
