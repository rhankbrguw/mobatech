import { APP_STRINGS } from "./constants";

const EMAIL_REGEX = /^[^\s@]+@[^\s@]+\.(com|id|co\.id|net|org|ac\.id|go\.id|sch\.id)$/i;
const NAME_REGEX = /^[a-zA-Z\s'.,-]+$/;
const PASSWORD_REGEX = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d\w\W]{8,}$/;
const PHONE_DIGITS_MIN = 7;
const PHONE_DIGITS_MAX = 12;

export const FormValidators = {
  name: (value: string): string | null => {
    if (!value.trim()) return APP_STRINGS.validation.nameEmpty;
    if (!NAME_REGEX.test(value)) return APP_STRINGS.validation.nameInvalid;
    return null;
  },

  email: (value: string): string | null => {
    if (!value.trim()) return APP_STRINGS.validation.emailEmpty;
    if (!EMAIL_REGEX.test(value)) return APP_STRINGS.validation.emailInvalid;
    return null;
  },

  phone: (e62: string): string | null => {
    let cleanPhone = e62.replace(/[^\d+]/g, "");
    if (cleanPhone.startsWith("+62")) cleanPhone = cleanPhone.substring(3);
    else if (cleanPhone.startsWith("62")) cleanPhone = cleanPhone.substring(2);
    else if (cleanPhone.startsWith("0")) cleanPhone = cleanPhone.substring(1);
    
    const digits = cleanPhone.replace(/\D/g, "");
    if (!digits) return APP_STRINGS.validation.phoneEmpty;
    if (digits.length < PHONE_DIGITS_MIN) return APP_STRINGS.validation.phoneShort;
    if (digits.length > PHONE_DIGITS_MAX) return APP_STRINGS.validation.phoneLong;
    return null;
  },

  password: (value: string): string | null => {
    if (!value.trim()) return APP_STRINGS.validation.passwordEmpty;
    if (!PASSWORD_REGEX.test(value)) return APP_STRINGS.validation.passwordWeak;
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
