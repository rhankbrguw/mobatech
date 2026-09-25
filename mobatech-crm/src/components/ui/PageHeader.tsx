import React from "react";

export interface PageHeaderProps {
  title: string;
  description?: string;
  action?: React.ReactNode;
  children?: React.ReactNode;
}

export const PageHeader: React.FC<PageHeaderProps> = ({ title, description, action, children }) => {
  return (
    <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-2.5 sm:gap-4 mb-4 sm:mb-6">
      <div className="flex items-center justify-between gap-3 w-full sm:w-auto">
        <div>
          <h1 className="text-lg sm:text-2xl font-bold tracking-tight text-foreground">{title}</h1>
          {description && <p className="text-foreground/60 text-xs sm:text-sm mt-0.5 sm:mt-1 leading-relaxed">{description}</p>}
        </div>
        {(action || children) && (
          <div className="sm:hidden flex items-center shrink-0">
            {action || children}
          </div>
        )}
      </div>
      {(action || children) && (
        <div className="hidden sm:flex flex-wrap items-center gap-2 sm:gap-3 shrink-0">
          {action || children}
        </div>
      )}
    </div>
  );
};
