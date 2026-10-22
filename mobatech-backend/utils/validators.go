package utils

import (
	"backend/constants"
	"regexp"
	"strings"
	"unicode"
)

var (
	emailSyntaxRegex = regexp.MustCompile(constants.RegexEmailSyntax)
	nameRegex        = regexp.MustCompile(constants.RegexName)
	phoneRegex       = regexp.MustCompile(constants.RegexPhone)
)

func ValidateEmail(email string) error {
	trimmed := strings.TrimSpace(email)
	if trimmed == "" {
		return NewValidationError(constants.MsgEmailRequired)
	}
	if !emailSyntaxRegex.MatchString(trimmed) {
		return NewValidationError(constants.MsgEmailInvalid)
	}

	parts := strings.Split(trimmed, "@")
	if len(parts) != 2 {
		return NewValidationError(constants.MsgEmailInvalid)
	}
	domain := strings.ToLower(parts[1])

	if BlockedTypoDomains[domain] {
		return NewValidationError(constants.MsgEmailTypoDetected)
	}
	if !IsTrustedOrValidDomain(domain) {
		return NewValidationError(constants.MsgEmailDomainInvalid)
	}
	return nil
}

func ValidateName(name string, fieldName string) error {
	trimmed := strings.TrimSpace(name)
	if trimmed == "" {
		if fieldName == "" {
			return NewValidationError(constants.MsgNameRequired)
		}
		return NewValidationError(fieldName + " " + strings.ToLower(constants.MsgNameRequired))
	}
	if len(trimmed) < constants.MinNameLength || len(trimmed) > constants.MaxNameLength {
		return NewValidationError(constants.MsgNameLengthInvalid)
	}
	if !nameRegex.MatchString(trimmed) {
		return NewValidationError(constants.MsgNameInvalidChars)
	}
	return nil
}

func ValidatePhone(phone string) error {
	trimmed := strings.TrimSpace(phone)
	if trimmed == "" {
		return NewValidationError(constants.MsgPhoneRequired)
	}
	cleanPhone := strings.ReplaceAll(trimmed, " ", "")
	cleanPhone = strings.ReplaceAll(cleanPhone, "-", "")
	if len(cleanPhone) < constants.MinPhoneLength || len(cleanPhone) > constants.MaxPhoneLength {
		return NewValidationError(constants.MsgPhoneInvalidFormat)
	}
	if !phoneRegex.MatchString(cleanPhone) {
		return NewValidationError(constants.MsgPhoneInvalidFormat)
	}
	return nil
}

func ValidatePassword(password string) error {
	if password == "" {
		return NewValidationError(constants.MsgPasswordRequired)
	}
	if len(password) < constants.MinPasswordLength || len(password) > constants.MaxPasswordLength {
		return NewValidationError(constants.MsgPasswordWeak)
	}
	var hasLower, hasUpper, hasDigit bool
	for _, ch := range password {
		switch {
		case unicode.IsLower(ch):
			hasLower = true
		case unicode.IsUpper(ch):
			hasUpper = true
		case unicode.IsDigit(ch):
			hasDigit = true
		}
	}
	if !hasLower || !hasUpper || !hasDigit {
		return NewValidationError(constants.MsgPasswordWeak)
	}
	return nil
}
