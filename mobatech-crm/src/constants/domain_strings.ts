import { ADMIN_STRINGS } from "./admin_strings";
import { FEATURE_STRINGS } from "./feature_strings";

export const DOMAIN_STRINGS = {
  ...ADMIN_STRINGS,
  ...FEATURE_STRINGS,
} as const;
