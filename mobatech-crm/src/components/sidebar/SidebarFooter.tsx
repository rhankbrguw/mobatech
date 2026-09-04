import { LogOut } from "lucide-react";
import { APP_STRINGS } from "@/constants";

interface SidebarFooterProps {
  onLogout: () => void;
}

export function SidebarFooter({ onLogout }: SidebarFooterProps) {
  return (
    <div className="p-4 border-t border-glass-border">
      <button
        onClick={onLogout}
        className="w-full flex items-center gap-3 px-4 h-11 rounded-xl text-sm font-medium text-error dark:text-error hover:bg-error-muted transition-all duration-200 cursor-pointer"
      >
        <LogOut size={20} />
        <span>{APP_STRINGS.sidebar.logout}</span>
      </button>
    </div>
  );
}
