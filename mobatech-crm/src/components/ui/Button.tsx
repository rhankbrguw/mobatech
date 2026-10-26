import React from "react";

export type ButtonVariant = "primary" | "secondary" | "danger" | "ghost" | "outline";
export type ButtonSize = "sm" | "md" | "lg";

export interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: ButtonVariant;
  size?: ButtonSize;
  icon?: React.ReactNode;
  isLoading?: boolean;
}

const variantStyles: Record<ButtonVariant, string> = {
  primary: "bg-primary text-primary-foreground hover:bg-primary-hover shadow-md border border-transparent active:scale-[0.98]",
  secondary: "bg-overlay-dark/60 dark:bg-white/5 text-foreground hover:bg-overlay-dark dark:hover:bg-white/10 border border-glass-border shadow-sm active:scale-[0.98]",
  danger: "bg-error-muted text-error hover:bg-error/20 border border-error/20 shadow-sm active:scale-[0.98]",
  ghost: "bg-transparent text-foreground/80 hover:bg-overlay-dark dark:hover:bg-white/5 hover:text-foreground border border-transparent active:scale-[0.98]",
  outline: "bg-transparent text-primary dark:text-emerald-400 border border-primary/30 dark:border-emerald-500/30 hover:bg-primary/10 dark:hover:bg-primary/20 active:scale-[0.98]",
};

const sizeStyles: Record<ButtonSize, string> = {
  sm: "h-7 sm:h-8 px-2.5 sm:px-3 text-xs rounded-lg gap-1.5",
  md: "h-9 sm:h-10 md:h-11 px-3 sm:px-4 text-xs sm:text-sm rounded-lg sm:rounded-xl gap-1.5 sm:gap-2",
  lg: "h-11 sm:h-13 md:h-14 px-4 sm:px-6 text-sm sm:text-base rounded-xl sm:rounded-2xl gap-2 sm:gap-3",
};

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className = "", variant = "primary", size = "md", icon, isLoading, children, disabled, ...props }, ref) => {
    return (
      <button
        ref={ref}
        disabled={disabled || isLoading}
        className={`inline-flex items-center justify-center font-medium transition-all duration-200 active:scale-[0.98] disabled:opacity-50 disabled:pointer-events-none cursor-pointer ${variantStyles[variant]} ${sizeStyles[size]} ${className}`}
        {...props}
      >
        {isLoading ? (
          <div className="w-4 h-4 border-2 border-current border-t-transparent rounded-full animate-spin" />
        ) : icon ? (
          icon
        ) : null}
        {children && <span>{children}</span>}
      </button>
    );
  }
);
Button.displayName = "Button";
