import { THEME_RAW_COLORS } from "./theme_colors";

export const CONFIG = {
  theme: {
    defaultColor: THEME_RAW_COLORS.dark.primary,
    defaultColorLight: `${THEME_RAW_COLORS.dark.primary}99`,
  },
  formatters: {
    phonePrefix: "+62 ",
    phonePrefixIntl: "62",
    phonePrefixLocal: "0",
    currencyPrefix: "Rp ",
    currencyZero: "Rp 0",
    locale: "id-ID",
    timezone: "Asia/Jakarta",
  },
} as const;
