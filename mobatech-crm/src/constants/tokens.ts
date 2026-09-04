import { THEME_RAW_COLORS, CSS_VARS, ThemeMode } from './theme_colors';
export { THEME_RAW_COLORS, CSS_VARS };
export type { ThemeMode };

export const TYPOGRAPHY = {
  fontFamily: {
    sans: "var(--font-geist-sans), sans-serif",
    mono: "var(--font-geist-mono), monospace",
  },
  fontSize: {
    xs: "0.75rem",
    sm: "0.875rem",
    base: "1rem",
    lg: "1.125rem",
    xl: "1.25rem",
    "2xl": "1.5rem",
    "3xl": "1.875rem",
    "4xl": "2.25rem",
  },
  fontWeight: {
    normal: "400",
    medium: "500",
    semibold: "600",
    bold: "700",
    extrabold: "800",
  },
} as const;

export const SPACING = {
  0: "0px",
  1: "0.25rem",
  2: "0.5rem",
  3: "0.75rem",
  4: "1rem",
  5: "1.25rem",
  6: "1.5rem",
  8: "2rem",
  10: "2.5rem",
  12: "3rem",
  16: "4rem",
} as const;

export const BORDER_RADIUS = {
  none: "0px",
  sm: "0.125rem",
  md: "0.375rem",
  lg: "0.5rem",
  xl: "0.75rem",
  "2xl": "1rem",
  "3xl": "1.5rem",
  full: "9999px",
} as const;

export const UI_CLASSES = {
  glassPanel: "glass-panel",
  glassCard: "glass-card",
  glassInput: "glass-input",
  animateSlideIn: "animate-slide-in",
  hoverLift: "hover-lift",
  activeScale: "active-scale",
  animatePulseGlow: "animate-pulse-glow",
} as const;

export const theme = {
  modeColors: THEME_RAW_COLORS,
  cssVars: CSS_VARS,
  typography: TYPOGRAPHY,
  spacing: SPACING,
  borderRadius: BORDER_RADIUS,
  uiClasses: UI_CLASSES,
} as const;

export type Theme = typeof theme;

export function getThemeColors(mode: ThemeMode) {
  return {
    ...THEME_RAW_COLORS[mode],
    ...THEME_RAW_COLORS.semantic,
  };
}
