import { useQuery } from "@tanstack/react-query";
import { useAuthStore } from "@/store/useAuthStore";
import { doctorService, adminService } from "@/services";
import { Appointment, Doctor } from "@/types/api";

interface DoctorStats {
  pending: number;
  completed: number;
  today: number;
  loading: boolean;
}

function getDoctorDisplayName(name?: string): string {
  if (!name) return "Spesialis";
  const parts = name.split(" ");
  if (parts.length > 1 && (parts[0].toLowerCase() === "dr." || parts[0].toLowerCase() === "dr")) {
    return `${parts[0]} ${parts[1]}`;
  }
  return parts[0];
}

export function useDoctorDashboard() {
  const user = useAuthStore((state) => state.user);

  const { data: docsRes, isLoading: docsLoading } = useQuery({
    queryKey: ["doctors"],
    queryFn: () => doctorService.getDoctors(),
  });

  const { data: apptsRes, isLoading: apptsLoading } = useQuery({
    queryKey: ["admin_appointments"],
    queryFn: () => adminService.getAppointments(),
  });

  const loading = docsLoading || apptsLoading;
  
  const docs: Doctor[] = docsRes?.data || [];
  const appts: Appointment[] = apptsRes?.data || [];
  const myDoc = docs.find((d) => String(d.user_id) === String(user?.id));
  const targetAppts = myDoc ? appts.filter((a) => a.doctor_id === myDoc.id) : appts;

  const stats: DoctorStats = {
    pending: targetAppts.filter((a) => a.status === "pending").length,
    completed: targetAppts.filter((a) => a.status === "completed").length,
    today: targetAppts.length,
    loading,
  };

  const hour = new Date().getHours();
  const greeting = hour < 12 ? "Selamat Pagi" : hour < 18 ? "Selamat Siang" : "Selamat Malam";
  const progress = stats.today > 0 ? Math.round((stats.completed / stats.today) * 100) : 0;

  return {
    greeting,
    displayName: getDoctorDisplayName(user?.full_name),
    stats,
    progress,
  };
}
