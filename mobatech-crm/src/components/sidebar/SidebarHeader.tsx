import { APP_STRINGS } from "@/constants";
import { X } from "lucide-react";

export function SidebarHeader({ onClose }: { onClose?: () => void }) {
  return (
    <div className="h-14 sm:h-16 flex items-center justify-between px-4 sm:px-6 border-b border-glass-border">
      <div className="flex items-center">
        <div className="w-8 h-8 bg-primary rounded-lg flex items-center justify-center text-primary-foreground font-bold text-lg mr-3 shadow-md">
          H
        </div>
        <span className="font-bold text-base sm:text-lg tracking-tight text-foreground">
          {APP_STRINGS.sidebar.title}
        </span>
      </div>
      {onClose && (
        <button
          onClick={onClose}
          className="lg:hidden p-1.5 rounded-lg hover:bg-overlay-dark dark:hover:bg-overlay-light text-foreground/60 hover:text-foreground transition-colors cursor-pointer"
          aria-label="Tutup Menu"
        >
          <X size={18} />
        </button>
      )}
    </div>
  );
}
