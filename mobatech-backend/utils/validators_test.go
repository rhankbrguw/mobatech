package utils

import (
	"testing"
)

func TestValidateEmail(t *testing.T) {
	validEmails := []string{
		"pasien@gmail.com",
		"dokter@herminahospitals.com",
		"user@yahoo.co.id",
		"admin@outlook.com",
		"staff@kemkes.go.id",
		"user@icloud.com",
		"user@proton.me",
		"alumni@ui.ac.id",
	}

	for _, email := range validEmails {
		if err := ValidateEmail(email); err != nil {
			t.Errorf("expected email '%s' to be valid, got error: %v", email, err)
		}
	}

	invalidEmails := []string{
		"",
		"user@gmail.co",      // Typo .co
		"user@gmial.com",     // Typo gmial
		"user@yahoo.co",      // Typo .co
		"user@hotmial.com",   // Typo domain
		"user@gmail.con",     // Typo .con
		"plainaddress",       // No @
		"@missingusername.com",
		"user@.com",
		"user@invalidtld.xyz999",
	}

	for _, email := range invalidEmails {
		if err := ValidateEmail(email); err == nil {
			t.Errorf("expected email '%s' to be INVALID, but got nil error", email)
		}
	}
}

func TestValidateName(t *testing.T) {
	validNames := []string{
		"Budi Santoso",
		"dr. Siti Aminah, Sp.A",
		"John O'Connor",
		"Jean-Luc Picard",
		"Ahmad",
	}

	for _, name := range validNames {
		if err := ValidateName(name, "Nama"); err != nil {
			t.Errorf("expected name '%s' to be valid, got error: %v", name, err)
		}
	}

	invalidNames := []string{
		"",
		"   ",
		"Budi123",            // Contains numbers
		"User @Name",         // Contains symbols
		"A",                  // Too short
	}

	for _, name := range invalidNames {
		if err := ValidateName(name, "Nama"); err == nil {
			t.Errorf("expected name '%s' to be INVALID, but got nil error", name)
		}
	}
}

func TestValidatePhone(t *testing.T) {
	validPhones := []string{
		"081234567890",
		"+6281234567890",
		"6281234567890",
		"085712345678",
	}

	for _, phone := range validPhones {
		if err := ValidatePhone(phone); err != nil {
			t.Errorf("expected phone '%s' to be valid, got error: %v", phone, err)
		}
	}

	invalidPhones := []string{
		"",
		"12345",              // Too short
		"0812",               // Too short
		"081234567890123456", // Too long
		"0812345abc",         // Contains letters
		"021123456",          // Landline without mobile prefix
	}

	for _, phone := range invalidPhones {
		if err := ValidatePhone(phone); err == nil {
			t.Errorf("expected phone '%s' to be INVALID, but got nil error", phone)
		}
	}
}

func TestValidatePassword(t *testing.T) {
	validPasswords := []string{
		"Password123",
		"HerminaAdmin2026!",
		"SecurePass99",
	}

	for _, pass := range validPasswords {
		if err := ValidatePassword(pass); err != nil {
			t.Errorf("expected password '%s' to be valid, got error: %v", pass, err)
		}
	}

	invalidPasswords := []string{
		"",
		"short1A",            // < 8 chars
		"alllowercase123",    // No uppercase
		"ALLUPPERCASE123",    // No lowercase
		"NoDigitsHerePassword", // No digits
	}

	for _, pass := range invalidPasswords {
		if err := ValidatePassword(pass); err == nil {
			t.Errorf("expected password '%s' to be INVALID, but got nil error", pass)
		}
	}
}
