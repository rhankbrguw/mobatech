package utils

import "strings"

// EscapeLike escapes special characters for SQL LIKE queries to prevent wildcard injection.
func EscapeLike(input string) string {
	escaped := strings.ReplaceAll(input, "\\", "\\\\")
	escaped = strings.ReplaceAll(escaped, "%", "\\%")
	escaped = strings.ReplaceAll(escaped, "_", "\\_")
	return escaped
}
