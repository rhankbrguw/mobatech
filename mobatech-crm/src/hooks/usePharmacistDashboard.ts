import { useQuery } from "@tanstack/react-query";
import { useAuthStore } from "@/store/useAuthStore";
import { pharmacyService } from "@/services";

interface PharmacistStats {
  totalMeds: number;
  lowStock: number;
  pendingPrescriptions: number;
  completedPrescriptions: number;
  totalPrescriptions: number;
  loading: boolean;
}

function getPharmacistDisplayName(name?: string): string {
  if (!name) return "Utama";
  const parts = name.split(" ");
  if (parts.length > 1 && (parts[0].toLowerCase() === "apt." || parts[0].toLowerCase() === "apt")) {
    return `${parts[0]} ${parts[1]}`;
  }
  return parts[0];
}

export function usePharmacistDashboard() {
  const user = useAuthStore((state) => state.user);

  const { data: medsRes, isLoading: medsLoading } = useQuery({
    queryKey: ["medicines"],
    queryFn: () => pharmacyService.getMedicines()
  });

  const { data: pRes, isLoading: pLoading } = useQuery({
    queryKey: ["prescriptions"],
    queryFn: () => pharmacyService.getPrescriptions()
  });

  const loading = medsLoading || pLoading;

  const meds = medsRes?.data || [];
  const pres = pRes?.data || [];

  const totalMeds = meds.length;
  const lowStock = meds.filter((m) => m.stock < 10).length;
  const pendingPrescriptions = pres.filter((p) => p.status === "Pending" || p.status === "pending").length;
  const completedPrescriptions = pres.filter((p) => p.status === "Redeemed" || p.status === "completed").length;
  const totalPrescriptions = pendingPrescriptions + completedPrescriptions;

  const stats: PharmacistStats = { totalMeds, lowStock, pendingPrescriptions, completedPrescriptions, totalPrescriptions, loading };

  const hour = new Date().getHours();
  const greeting = hour < 12 ? "Selamat Pagi" : hour < 18 ? "Selamat Siang" : "Selamat Malam";

  return {
    greeting,
    displayName: getPharmacistDisplayName(user?.full_name),
    stats,
  };
}
