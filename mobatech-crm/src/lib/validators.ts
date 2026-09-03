import { APP_STRINGS } from "@/constants";

const EMAIL_SYNTAX_REGEX = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
const NAME_REGEX = /^[a-zA-ZÀ-ÿ\s.',-]+$/;
const PHONE_REGEX = /^(\+62|62|0)8[1-9][0-9]{7,11}$/;
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,64}$/;

const BLOCKED_TYPO_DOMAINS = new Set([
  "gmail.co", "yahoo.co", "hotmail.co", "outlook.co", "icloud.co",
  "gmial.com", "gmaill.com", "gamil.com", "yaho.com", "outlok.com",
  "hotmial.com", "iclod.com", "gmail.con",
]);

const TRUSTED_DOMAINS = new Set([
  "gmail.com", "googlemail.com", "yahoo.com", "yahoo.co.id", "ymail.com",
  "outlook.com", "hotmail.com", "live.com", "msn.com", "icloud.com",
  "me.com", "mac.com", "proton.me", "protonmail.com", "zoho.com", "aol.com",
  "herminahospitals.com", "mobatech.com", "kemkes.go.id",
]);

const ALLOWED_TLDS = [
  ".com", ".id", ".co.id", ".net", ".org",
  ".ac.id", ".go.id", ".sch.id", ".edu", ".io",
];

function isTrustedOrValidDomain(domain: string): boolean {
  const lower = domain.toLowerCase().trim();
  if (BLOCKED_TYPO_DOMAINS.has(lower)) return false;
  if (TRUSTED_DOMAINS.has(lower)) return true;
  return ALLOWED_TLDS.some((tld) => lower.endsWith(tld) && lower.length > tld.length + 1);
}

export const FormValidators = {
  name: (value: string): string | null => {
    const trimmed = value.trim();
    if (!trimmed) return APP_STRINGS.validation.nameEmpty;
    if (trimmed.length < 2 || trimmed.length > 100) return APP_STRINGS.validation.nameInvalid;
    if (!NAME_REGEX.test(trimmed)) return APP_STRINGS.validation.nameInvalid;
    return null;
  },

  email: (value: string): string | null => {
    const trimmed = value.trim();
    if (!trimmed) return APP_STRINGS.validation.emailEmpty;
    if (!EMAIL_SYNTAX_REGEX.test(trimmed)) return APP_STRINGS.validation.emailInvalid;

    const parts = trimmed.split("@");
    if (parts.length !== 2) return APP_STRINGS.validation.emailInvalid;
    const domain = parts[1].toLowerCase();

    if (BLOCKED_TYPO_DOMAINS.has(domain)) return APP_STRINGS.validation.emailTypoDetected;
    if (!isTrustedOrValidDomain(domain)) return APP_STRINGS.validation.emailDomainInvalid;

    return null;
  },

  phone: (e62: string): string | null => {
    const trimmed = e62.trim();
    if (!trimmed) return APP_STRINGS.validation.phoneEmpty;
    const cleanPhone = trimmed.replace(/[\s-]/g, "");
    if (!PHONE_REGEX.test(cleanPhone)) return APP_STRINGS.validation.phoneInvalid;
    return null;
  },

  password: (value: string): string | null => {
    if (!value) return APP_STRINGS.validation.passwordEmpty;
    if (value.length < 8 || value.length > 64 || !PASSWORD_REGEX.test(value)) {
      return APP_STRINGS.validation.passwordWeak;
    }
    return null;
  },

  required: (value: string, label: string): string | null => {
    if (!value.trim()) return `${label}${APP_STRINGS.validation.requiredSuffix}`;
    return null;
  },

  quota: (value: number | undefined | null | string): string | null => {
    if (value === undefined || value === null || value === "") return APP_STRINGS.validation.quotaEmpty;
    const numValue = Number(value);
    if (isNaN(numValue) || numValue < 10) return APP_STRINGS.validation.quotaMin;
    return null;
  },
} as const;
