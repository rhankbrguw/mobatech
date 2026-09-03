import React from "react";

export type BadgeVariant = "success" | "warning" | "error" | "info" | "neutral";

export interface BadgeProps extends React.HTMLAttributes<HTMLSpanElement> {
  variant?: BadgeVariant;
}

const badgeStyles: Record<BadgeVariant, string> = {
  success: "bg-success-muted border-success-muted text-success dark:text-success",
  warning: "bg-warning-muted border-warning-muted text-warning dark:text-warning",
  error: "bg-error-muted border-error-muted text-error dark:text-error",
  info: "bg-info-muted border-info-muted text-info dark:text-info",
  neutral: "bg-neutral-muted border-neutral-muted text-neutral dark:text-neutral",
};

export const Badge: React.FC<BadgeProps> = ({ children, variant = "neutral", className = "", ...props }) => {
  return (
    <span
      className={`inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border ${badgeStyles[variant]} ${className}`}
      {...props}
    >
      {children}
    </span>
  );
};
