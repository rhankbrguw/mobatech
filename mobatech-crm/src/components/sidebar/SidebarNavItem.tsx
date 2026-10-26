import Link from "next/link";
import { NavItem } from "@/hooks/useSidebarLogic";

interface SidebarNavItemProps {
  item: NavItem;
  isActive: boolean;
  onClose: () => void;
}

export function SidebarNavItem({ item, isActive, onClose }: SidebarNavItemProps) {
  return (
    <Link
      href={item.path}
      onClick={onClose}
      className={`flex items-center gap-3 px-4 h-11 rounded-xl text-sm font-medium transition-all duration-200 active:scale-[0.98] cursor-pointer ${
        isActive
          ? "bg-primary text-primary-foreground shadow-md"
          : "text-foreground/75 hover:bg-overlay-dark dark:hover:bg-overlay-light hover:text-foreground"
      }`}
    >
      <span className={isActive ? "text-primary-foreground" : "text-foreground/60"}>{item.icon}</span>
      <span>{item.name}</span>
    </Link>
  );
}
