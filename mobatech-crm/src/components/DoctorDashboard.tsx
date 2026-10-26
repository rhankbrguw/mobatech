"use client";
import { useDoctorDashboard } from "@/hooks/useDoctorDashboard";
import { DoctorHeader } from "@/components/doctor/DoctorHeader";
import { DoctorStatsGrid } from "@/components/doctor/DoctorStatsGrid";
import { DoctorQuickActions } from "@/components/doctor/DoctorQuickActions";

export function DoctorDashboard() {
  const { greeting, displayName, stats, progress } = useDoctorDashboard();

  return (
    <div className="space-y-8 animate-slide-in">
      <DoctorHeader
        greeting={greeting}
        displayName={displayName}
        completed={stats.completed}
        today={stats.today}
        progress={progress}
      />
      <DoctorStatsGrid stats={stats} />
      <DoctorQuickActions />
    </div>
  );
}
