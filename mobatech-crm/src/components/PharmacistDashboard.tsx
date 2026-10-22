"use client";
import { usePharmacistDashboard } from "@/hooks/usePharmacistDashboard";
import { PharmacistHeader } from "@/components/pharmacist/PharmacistHeader";
import { PharmacistStatsGrid } from "@/components/pharmacist/PharmacistStatsGrid";
import { PharmacistQuickActions } from "@/components/pharmacist/PharmacistQuickActions";

export function PharmacistDashboard() {
  const { greeting, displayName, stats } = usePharmacistDashboard();

  return (
    <div className="space-y-8 animate-slide-in">
      <PharmacistHeader greeting={greeting} displayName={displayName} />
      <PharmacistStatsGrid stats={stats} />
      <PharmacistQuickActions />
    </div>
  );
}
