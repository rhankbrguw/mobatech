import { DOMAIN_STRINGS } from "./domain_strings";
import { COMMON_STRINGS } from "./common_strings";

export const APP_STRINGS = {
  ...DOMAIN_STRINGS,
  ...COMMON_STRINGS,
} as const;

export type AppStrings = typeof APP_STRINGS;
