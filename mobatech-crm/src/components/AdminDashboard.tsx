"use client";
import { useAdminDashboard } from "@/hooks/useAdminDashboard";
import { AdminHeader } from "@/components/admin/AdminHeader";
import { AdminQuickActions } from "@/components/admin/AdminQuickActions";
import { AdminRecentEmergencies } from "@/components/admin/AdminRecentEmergencies";
import { DashboardStatCards } from "@/components/DashboardStatCards";
import { DashboardRecentAppointments } from "@/components/DashboardRecentAppointments";
import { DashboardRightPanel } from "@/components/DashboardRightPanel";

export function AdminDashboard() {
  const { user, stats, greeting } = useAdminDashboard();

  return (
    <div className="space-y-8 animate-slide-in">
      <AdminHeader
        greeting={greeting}
        userName={user?.full_name}
        activeEmergencies={stats.activeEmergencies}
      />
      <DashboardStatCards stats={stats} />
      <AdminQuickActions />
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <DashboardRecentAppointments stats={stats} />
        <DashboardRightPanel stats={stats} />
      </div>
      <AdminRecentEmergencies
        recentEmergencies={stats.recentEmergencies}
        activeEmergencies={stats.activeEmergencies}
      />
    </div>
  );
}
