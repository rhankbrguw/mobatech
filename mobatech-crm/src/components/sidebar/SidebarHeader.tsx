import { APP_STRINGS } from "@/constants";

export function SidebarHeader() {
  return (
    <div className="h-16 flex items-center px-6 border-b border-glass-border">
      <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center text-primary-foreground font-bold text-lg mr-3 shadow-md">
        H
      </div>
      <span className="font-bold text-lg tracking-tight text-foreground">
        {APP_STRINGS.sidebar.title}
      </span>
    </div>
  );
}
