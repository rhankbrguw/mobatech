package dto

type AdminUpdatePrescriptionStatusReq struct {
	Status string `json:"status"`
	Notes  string `json:"notes"`
}

type AdminUpdateOrderStatusReq struct {
	Status string `json:"status"`
}

type AdminUpdateOrderPaymentReq struct {
	PaymentStatus string `json:"payment_status"`
}
