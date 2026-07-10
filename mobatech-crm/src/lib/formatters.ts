import { APP_STRINGS } from "./constants";

export const Formatters = {
  phone: (raw: string | undefined | null): string => {
    if (!raw) return "-";
    let val = raw.replace(/\D/g, "");
    if (val.startsWith(APP_STRINGS.formatters.phonePrefixIntl)) {
      val = val.slice(2);
    }
    
    if (val.startsWith(APP_STRINGS.formatters.phonePrefixLocal)) {
      val = val.slice(1);
    }
    
    if (!val) return "-";
    const prefix = APP_STRINGS.formatters.phonePrefix;
    if (val.length <= 3) return `${prefix}${val}`;
    if (val.length <= 7) return `${prefix}${val.slice(0, 3)}-${val.slice(3)}`;
    if (val.length <= 11) return `${prefix}${val.slice(0, 3)}-${val.slice(3, 7)}-${val.slice(7)}`;
    return `${prefix}${val.slice(0, 3)}-${val.slice(3, 7)}-${val.slice(7, 12)}`;
  },

  currency: (amount: number | undefined | null): string => {
    if (amount === undefined || amount === null) return APP_STRINGS.formatters.currencyZero;
    return `${APP_STRINGS.formatters.currencyPrefix}${amount.toLocaleString(APP_STRINGS.formatters.locale)}`;
  },

  date: (dateVal: string | Date | undefined | null, format: "short" | "long" | "datetime" | "datetimesec" | "weekday" = "short"): string => {
    if (!dateVal) return "-";
    const d = new Date(dateVal);
    const loc = APP_STRINGS.formatters.locale;
    
    switch (format) {
      case "short":
        return d.toLocaleDateString(loc, { day: "2-digit", month: "short", year: "numeric" });
      case "long":
        return d.toLocaleDateString(loc, { month: "long", year: "numeric" });
      case "weekday":
        return d.toLocaleDateString(loc, { weekday: "long", day: "numeric", month: "long", year: "numeric" });
      case "datetime": {
        const dt = d.toLocaleString(loc, { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit", hour12: false });
        return dt.replace(',', '').replace(/\./g, ':');
      }
      case "datetimesec": {
        const dts = d.toLocaleString(loc, { day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit", second: "2-digit", hour12: false });
        return dts.replace(',', '').replace(/\./g, ':');
      }
      default:
        return d.toLocaleDateString(loc);
    }
  },

  currentLocalDatetimeInput: (): string => {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    return `${year}-${month}-${day}T${hours}:${minutes}`;
  }
};
