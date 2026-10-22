import { useQuery } from "@tanstack/react-query";
import { doctorService, polyclinicService, adminService } from "@/services";
import { useAuthStore } from "@/store/useAuthStore";
import { DashboardStats, Doctor, Polyclinic, User, Appointment, Emergency, DoctorSchedule } from "@/app/dashboard/types";

function parseAdminResults(results: [
  PromiseSettledResult<{ data: Doctor[] }>,
  PromiseSettledResult<{ data: Polyclinic[] }>,
  PromiseSettledResult<{ data: User[] }>,
  PromiseSettledResult<{ data: Appointment[] }>,
  PromiseSettledResult<{ data: Emergency[] }>,
  PromiseSettledResult<{ data: DoctorSchedule[] }>
]): DashboardStats {
  const doctors = results[0].status === "fulfilled" ? (results[0].value.data || []) : [];
  const polys = results[1].status === "fulfilled" ? (results[1].value.data || []) : [];
  const patients = results[2].status === "fulfilled" ? (results[2].value.data || []) : [];
  const appts = results[3].status === "fulfilled" ? (results[3].value.data || []) : [];
  const emergencies = results[4].status === "fulfilled" ? (results[4].value.data || []) : [];
  const schedules = results[5].status === "fulfilled" ? (results[5].value.data || []) : [];

  return {
    doctors: doctors.length,
    polyclinics: polys.length,
    patients: patients.length,
    totalAppointments: appts.length,
    pendingAppointments: appts.filter((a) => a.status?.toLowerCase() === "pending").length,
    completedAppointments: appts.filter((a) => a.status?.toLowerCase() === "completed").length,
    activeEmergencies: emergencies.filter((e) => !["resolved", "cancelled"].includes(e.status?.toLowerCase())).length,
    recentAppointments: [...appts].reverse().slice(0, 5),
    recentEmergencies: [...emergencies].reverse().slice(0, 3),
    recentPatients: [...patients].reverse().slice(0, 4),
    recentSchedules: schedules,
    loading: false,
  };
}

async function fetchAdminDashboardStats(): Promise<DashboardStats> {
  const results = await Promise.allSettled([
    doctorService.getDoctors(),
    polyclinicService.getPolyclinics(),
    adminService.getPatients(),
    adminService.getAppointments(),
    adminService.getEmergenciesList(),
    doctorService.getAllSchedules("?limit=4"),
  ]);
  return parseAdminResults(results as unknown as Parameters<typeof parseAdminResults>[0]);
}

function getGreeting(hour: number): string {
  if (hour < 12) return "Selamat Pagi";
  if (hour < 18) return "Selamat Siang";
  return "Selamat Malam";
}

export function useAdminDashboard() {
  const user = useAuthStore((state) => state.user);
  
  const { data: stats = {
    doctors: 0, polyclinics: 0, patients: 0,
    totalAppointments: 0, pendingAppointments: 0, completedAppointments: 0,
    activeEmergencies: 0,
    recentAppointments: [], recentEmergencies: [], recentPatients: [], recentSchedules: [],
    loading: true,
  } } = useQuery({
    queryKey: ["adminDashboardStats"],
    queryFn: fetchAdminDashboardStats,
  });

  const greeting = getGreeting(new Date().getHours());

  return { user, stats: { ...stats, loading: false }, greeting };
}
