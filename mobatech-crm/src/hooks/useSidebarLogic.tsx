import React from "react";
import { usePathname, useRouter } from "next/navigation";
import { useAuthStore } from "@/store/useAuthStore";
import { useUIStore } from "@/store/useUIStore";
import { APP_STRINGS } from "@/constants";
import {
  LayoutDashboard, Users, Building2, Stethoscope, CalendarDays,
  Siren, Pill, FileText, Bell, Bot
} from "lucide-react";

export interface NavItem {
  name: string;
  path: string;
  icon: React.ReactNode;
  roles: string[];
}

function getNavItems(): NavItem[] {
  return [
    { name: APP_STRINGS.sidebar.dashboard, path: "/dashboard", icon: <LayoutDashboard size={20} />, roles: ["admin", "pharmacist", "doctor"] },
    { name: "Manajemen Pengguna", path: "/dashboard/users", icon: <Users size={20} />, roles: ["admin"] },
    { name: APP_STRINGS.sidebar.polyclinics, path: "/dashboard/polyclinics", icon: <Building2 size={20} />, roles: ["admin"] },
    { name: "Cabang RS", path: "/dashboard/branches", icon: <Building2 size={20} />, roles: ["admin"] },
    { name: "Manajemen Dokter", path: "/dashboard/doctors", icon: <Stethoscope size={20} />, roles: ["admin"] },
    { name: "Jadwal Praktik", path: "/dashboard/doctors", icon: <CalendarDays size={20} />, roles: ["doctor"] },
    { name: "Database Pasien", path: "/dashboard/patients", icon: <Users size={20} />, roles: ["admin"] },
    { name: "Pasien Saya", path: "/dashboard/patients", icon: <Users size={20} />, roles: ["doctor"] },
    { name: "Seluruh Antrean", path: "/dashboard/appointments", icon: <CalendarDays size={20} />, roles: ["admin"] },
    { name: "Antrean Klinik", path: "/dashboard/appointments", icon: <CalendarDays size={20} />, roles: ["doctor"] },
    { name: "Darurat", path: "/dashboard/emergencies", icon: <Siren size={20} />, roles: ["admin"] },
    { name: "Inventaris Apotek", path: "/dashboard/pharmacy", icon: <Pill size={20} />, roles: ["admin"] },
    { name: "Katalog Obat", path: "/dashboard/pharmacy", icon: <Pill size={20} />, roles: ["pharmacist"] },
    { name: "Log E-Resep", path: "/dashboard/prescriptions", icon: <FileText size={20} />, roles: ["admin"] },
    { name: "Proses E-Resep", path: "/dashboard/prescriptions", icon: <FileText size={20} />, roles: ["pharmacist"] },
    { name: "Arsip Medis", path: "/dashboard/medical-results", icon: <FileText size={20} />, roles: ["admin"] },
    { name: "Input Hasil Medis", path: "/dashboard/medical-results", icon: <FileText size={20} />, roles: ["doctor"] },
    { name: "Pengingat", path: "/dashboard/reminders", icon: <Bell size={20} />, roles: ["admin"] },
    { name: "Manajemen Promo", path: "/dashboard/promos", icon: <FileText size={20} />, roles: ["admin"] },
    { name: APP_STRINGS.sidebar.aiAudit, path: "/dashboard/ai-audit", icon: <Bot size={20} />, roles: ["admin"] },
  ];
}

export function useSidebarLogic() {
  const pathname = usePathname();
  const router = useRouter();
  const clearAuth = useAuthStore((state) => state.clearAuth);
  const user = useAuthStore((state) => state.user);
  const userRole = user?.role || "admin";
  const { isSidebarOpen, closeSidebar } = useUIStore();

  const handleLogout = async () => {
    await fetch("/api/auth/logout", { method: "POST" });
    clearAuth();
    router.replace("/login");
  };

  const filteredNavItems = getNavItems().filter((item) => item.roles.includes(userRole));

  return {
    pathname,
    isSidebarOpen,
    closeSidebar,
    handleLogout,
    filteredNavItems,
  };
}
