package controllers

import (
	"backend/constants"
	"backend/models"
	"backend/utils"
	"net/http"
	"strconv"

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
	search := c.Query("search")
	filter := c.Query("filter")

	page, err := strconv.Atoi(c.DefaultQuery(constants.QueryParamPage, constants.PaginationDefaultPage))
	if err != nil {
		c.Error(utils.NewValidationError("Invalid page parameter"))
		return
	}
	limit, err := strconv.Atoi(c.DefaultQuery(constants.QueryParamLimit, constants.PaginationDefaultLimit))
	if err != nil {
		c.Error(utils.NewValidationError("Invalid limit parameter"))
		return
	}
	offset := (page - 1) * limit

	var branches []models.Branch
	var totalCount int64
	query := buildBranchQuery(ctrl.DB, search, filter)
	if err := query.Count(&totalCount).Error; err != nil {
		c.JSON(http.StatusInternalServerError, utils.BuildError(utils.ErrInternal, "Failed to count branches", nil))
		return
	}
	if limit > 0 {
		query = query.Limit(limit).Offset(offset)
	}

	if err := query.Find(&branches).Error; err != nil {
		c.JSON(http.StatusInternalServerError, utils.BuildError(utils.ErrInternal, "Failed to fetch branches", nil))
		return
	}
	c.JSON(http.StatusOK, utils.BuildPaginatedSuccess("Success", branches, page, limit, totalCount))
}

func (ctrl *BranchController) GetBranchByID(c *gin.Context) {
	id := c.Param("id")
	var branch models.Branch
	if err := ctrl.DB.First(&branch, id).Error; err != nil {
		c.JSON(http.StatusNotFound, utils.BuildError(utils.ErrNotFound, "Branch not found", nil))
		return
	}
	c.JSON(http.StatusOK, utils.BuildSuccess("OK", "Success", branch))
}

func (ctrl *BranchController) CreateBranch(c *gin.Context) {
	var req models.Branch
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, utils.BuildError(utils.ErrValidation, err.Error(), nil))
		return
	}
	if err := ctrl.DB.Create(&req).Error; err != nil {
		c.JSON(http.StatusInternalServerError, utils.BuildError(utils.ErrInternal, "Failed to create branch", nil))
		return
	}
	c.JSON(http.StatusCreated, utils.BuildSuccess("Created", "Branch created successfully", req))
}

func (ctrl *BranchController) UpdateBranch(c *gin.Context) {
	id := c.Param("id")
	var branch models.Branch
	if err := ctrl.DB.First(&branch, id).Error; err != nil {
		c.JSON(http.StatusNotFound, utils.BuildError(utils.ErrNotFound, "Branch not found", nil))
		return
	}
	var req models.Branch
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, utils.BuildError(utils.ErrValidation, err.Error(), nil))
		return
	}
	if err := ctrl.DB.Model(&branch).Updates(req).Error; err != nil {
		c.JSON(http.StatusInternalServerError, utils.BuildError(utils.ErrInternal, "Failed to update branch", nil))
		return
	}
	c.JSON(http.StatusOK, utils.BuildSuccess("OK", "Branch updated successfully", branch))
}

func (ctrl *BranchController) DeleteBranch(c *gin.Context) {
	id := c.Param("id")
	if err := ctrl.DB.Delete(&models.Branch{}, id).Error; err != nil {
		c.JSON(http.StatusInternalServerError, utils.BuildError(utils.ErrInternal, "Failed to delete branch", nil))
		return
	}
	c.JSON(http.StatusOK, utils.BuildSuccess("OK", "Branch deleted successfully", nil))
}
