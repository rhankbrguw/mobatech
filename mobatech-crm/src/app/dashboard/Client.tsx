"use client";

import { useAuthStore } from "@/store/useAuthStore";
import { AdminDashboard } from "@/components/AdminDashboard";
import { DoctorDashboard } from "@/components/DoctorDashboard";
import { PharmacistDashboard } from "@/components/PharmacistDashboard";

export function DashboardClient() {
  const user = useAuthStore((state) => state.user);

  if (user?.role === "doctor")
    return (
      <>
        <h1 className="sr-only">Dashboard Dokter</h1>
        <DoctorDashboard />
      </>
    );
  if (user?.role === "pharmacist")
    return (
      <>
        <h1 className="sr-only">Dashboard Apoteker</h1>
        <PharmacistDashboard />
      </>
    );

  return (
    <>
      <h1 className="sr-only">Dashboard Admin</h1>
      <AdminDashboard />
    </>
  );
}
