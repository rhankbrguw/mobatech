package utils

import "strings"

var TrustedEmailDomains = map[string]bool{
	"gmail.com":             true,
	"googlemail.com":        true,
	"yahoo.com":             true,
	"yahoo.co.id":           true,
	"ymail.com":             true,
	"outlook.com":           true,
	"hotmail.com":           true,
	"live.com":              true,
	"msn.com":               true,
	"icloud.com":            true,
	"me.com":                true,
	"mac.com":               true,
	"proton.me":             true,
	"protonmail.com":        true,
	"zoho.com":              true,
	"aol.com":               true,
	"herminahospitals.com":  true,
	"mobatech.com":          true,
	"kemkes.go.id":          true,
}

var BlockedTypoDomains = map[string]bool{
	"gmail.co":    true,
	"yahoo.co":    true,
	"hotmail.co":  true,
	"outlook.co":  true,
	"icloud.co":   true,
	"gmial.com":   true,
	"gmaill.com":  true,
	"gamil.com":   true,
	"yaho.com":    true,
	"outlok.com":  true,
	"hotmial.com": true,
	"iclod.com":   true,
	"gmail.con":   true,
}

var AllowedTLDs = []string{
	".com", ".id", ".co.id", ".net", ".org",
	".ac.id", ".go.id", ".sch.id", ".edu", ".io",
}

func IsTrustedOrValidDomain(domain string) bool {
	domain = strings.ToLower(strings.TrimSpace(domain))
	if BlockedTypoDomains[domain] {
		return false
	}
	if TrustedEmailDomains[domain] {
		return true
	}
	for _, tld := range AllowedTLDs {
		if strings.HasSuffix(domain, tld) {
			prefix := strings.TrimSuffix(domain, tld)
			if len(prefix) >= 2 && !strings.Contains(prefix, "..") {
				return true
			}
		}
	}
	return false
}
