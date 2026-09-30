"use client";

import { useSidebarLogic } from "@/hooks/useSidebarLogic";
import { SidebarHeader } from "./sidebar/SidebarHeader";
import { SidebarNavItem } from "./sidebar/SidebarNavItem";
import { SidebarFooter } from "./sidebar/SidebarFooter";

export function Sidebar() {
  const { pathname, isSidebarOpen, closeSidebar, handleLogout, filteredNavItems } = useSidebarLogic();

  return (
    <>
      {isSidebarOpen && (
        <div 
          className="fixed inset-0 bg-foreground/60 z-40 lg:hidden backdrop-blur-md transition-opacity duration-300"
          onClick={closeSidebar}
        />
      )}

      <aside 
        className={`w-64 border-r glass-panel bg-surface-primary/95 dark:bg-[#113C2B]/95 backdrop-blur-2xl flex flex-col h-screen fixed left-0 top-0 z-50 transition-transform duration-300 ease-in-out shadow-2xl lg:shadow-none ${
          isSidebarOpen ? "translate-x-0" : "-translate-x-full"
        } lg:translate-x-0`}
      >
        <SidebarHeader onClose={closeSidebar} />

        <nav className="flex-1 px-4 py-6 space-y-2 overflow-y-auto overflow-x-hidden">
          {filteredNavItems.map((item) => (
            <SidebarNavItem
              key={item.path}
              item={item}
              isActive={pathname === item.path}
              onClose={closeSidebar}
            />
          ))}
        </nav>

        <SidebarFooter onLogout={handleLogout} />
      </aside>
    </>
  );
}
