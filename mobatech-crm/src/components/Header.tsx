"use client";

import { useState, useEffect, useRef } from "react";
import { useAuthStore } from "@/store/useAuthStore";
import { useUIStore } from "@/store/useUIStore";
import { Sun, Moon, Menu, Bell, ChevronDown, User, Settings, LogOut, Shield } from "lucide-react";
import { useRouter } from "next/navigation";

export function Header() {
  const user = useAuthStore((state) => state.user);
  const clearAuth = useAuthStore((state) => state.clearAuth);
  const router = useRouter();
  const [dark, setDark] = useState(false);
  const toggleSidebar = useUIStore((state) => state.toggleSidebar);

  useEffect(() => {
    setDark(document.documentElement.classList.contains("dark"));
  }, []);

  const toggleTheme = () => {
    const isDark = !dark;
    setDark(isDark);
    document.documentElement.classList.toggle("dark", isDark);
    localStorage.setItem("theme", isDark ? "dark" : "light");
  };

  const handleLogout = async () => {
    await fetch("/api/auth/logout", { method: "POST" });
    clearAuth();
    router.replace("/login");
  };

  const getFirstName = (name?: string) => {
    if (!name) return "User";
    const parts = name.split(" ");
    if (parts.length > 1 && (parts[0].toLowerCase() === "dr." || parts[0].toLowerCase() === "dr")) {
      return `${parts[0]} ${parts[1]}`;
    }
    return parts[0];
  };

  return (
    <header className="h-16 border-b border-glass-border bg-surface-primary/40 dark:bg-foreground/40 backdrop-blur-xl flex items-center justify-between px-4 md:px-8 fixed top-0 right-0 left-0 lg:left-64 z-20 transition-all duration-300 shadow-sm">
      <div className="flex items-center gap-4">
        <button onClick={toggleSidebar} className="lg:hidden p-2 rounded-xl hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors cursor-pointer text-foreground/70" aria-label="Toggle Menu">
          <Menu size={20} />
        </button>
        <div className="hidden sm:block text-sm font-medium text-foreground/60">
          Selamat datang kembali, <span className="text-primary font-bold">{getFirstName(user?.full_name)}</span>
        </div>
      </div>

      <div className="flex items-center gap-3 sm:gap-5">
        <button className="relative p-2 rounded-xl border border-glass-border bg-background/50 hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors cursor-pointer text-foreground/70">
          <Bell size={18} />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 rounded-full bg-error animate-pulse"></span>
        </button>

        <button onClick={toggleTheme} className="p-2 rounded-xl border border-glass-border bg-background/50 hover:bg-overlay-dark dark:hover:bg-overlay-light transition-colors cursor-pointer text-foreground/70">
          {dark ? <Sun size={18} /> : <Moon size={18} />}
        </button>
      </div>
    </header>
  );
}
