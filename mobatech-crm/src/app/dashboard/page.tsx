"use client";

import { useEffect, useState } from "react";
import { api } from "@/lib/api";
import { useAuthStore } from "@/store/useAuthStore";
import Link from "next/link";

interface Appointment { id: number; status: string; created_at: string; notes: string; }
interface Emergency { id: number; status: string; created_at: string; latitude: number; longitude: number; }
interface User { id: number; full_name: string; email: string; created_at: string; }
interface Doctor { id: number; name: string; }
interface Polyclinic { id: number; name: string; }
interface DoctorSchedule { id: number; doctor: { name: string; specialization: string }; date: string; start_time: string; end_time: string; quota: number; booked: number; is_available: boolean; }

interface DashboardStats {
  doctors: number;
  polyclinics: number;
  patients: number;
  totalAppointments: number;
  pendingAppointments: number;
  completedAppointments: number;
  activeEmergencies: number;
  recentAppointments: Appointment[];
  recentEmergencies: Emergency[];
  recentPatients: User[];
  recentSchedules: DoctorSchedule[];
  loading: boolean;
}

const STATUS_COLOR: Record<string, { bg: string; text: string; dot: string }> = {
  pending:    { bg: "bg-yellow-500/10", text: "text-yellow-600", dot: "bg-yellow-500" },
  approved:   { bg: "bg-blue-500/10",   text: "text-blue-600",   dot: "bg-blue-500"   },
  completed:  { bg: "bg-green-500/10",  text: "text-green-600",  dot: "bg-green-500"  },
  cancelled:  { bg: "bg-red-500/10",    text: "text-red-600",    dot: "bg-red-500"    },
  dispatched: { bg: "bg-indigo-500/10", text: "text-indigo-600", dot: "bg-indigo-500" },
  arrived:    { bg: "bg-teal-500/10",   text: "text-teal-600",   dot: "bg-teal-500"   },
  resolved:   { bg: "bg-gray-500/10",   text: "text-gray-500",   dot: "bg-gray-400"   },
};

function StatusPill({ status }: { status: string }) {
  const s = STATUS_COLOR[status?.toLowerCase()] ?? STATUS_COLOR["pending"];
  return (
    <span className={`inline-flex items-center gap-1.5 px-2 py-0.5 rounded-full text-xs font-medium ${s.bg} ${s.text}`}>
      <span className={`w-1.5 h-1.5 rounded-full ${s.dot}`} />
      {status}
    </span>
  );
}

function StatCard({ icon, label, value, sub, href, color }: { icon: string; label: string; value: number | string; sub?: string; href: string; color: string; }) {
  return (
    <Link href={href} className={`group relative p-5 rounded-2xl border glass-panel overflow-hidden hover:scale-[1.02] transition-all duration-300 shadow-sm cursor-pointer`}>
      <div className={`absolute -top-3 -right-3 w-20 h-20 rounded-full ${color} opacity-10 group-hover:opacity-20 transition-opacity duration-300`} />
      <div className={`w-10 h-10 rounded-xl ${color} bg-opacity-15 flex items-center justify-center text-xl mb-3`}>{icon}</div>
      <p className="text-xs font-semibold text-foreground/50 uppercase tracking-wider">{label}</p>
      <p className="text-3xl font-extrabold text-foreground mt-1">{value}</p>
      {sub && <p className="text-xs text-foreground/50 mt-1">{sub}</p>}
    </Link>
  );
}

export default function DashboardPage() {
  const user = useAuthStore((state) => state.user);
  const [stats, setStats] = useState<DashboardStats>({
    doctors: 0, polyclinics: 0, patients: 0,
    totalAppointments: 0, pendingAppointments: 0, completedAppointments: 0,
    activeEmergencies: 0,
    recentAppointments: [], recentEmergencies: [], recentPatients: [], recentSchedules: [],
    loading: true,
  });

  useEffect(() => {
    async function load() {
      try {
        const [doctorsRes, polyRes, patientsRes, appRes, emergRes, scheduleRes] = await Promise.allSettled([
          api.get<Doctor[]>("/api/doctors"),
          api.get<Polyclinic[]>("/api/polyclinics"),
          api.get<User[]>("/api/admin/users"),
          api.get<Appointment[]>("/api/admin/appointments"),
          api.get<Emergency[]>("/api/admin/emergencies"),
          api.get<DoctorSchedule[]>("/api/admin/schedules?limit=4"),
        ]);

        const doctors    = doctorsRes.status   === "fulfilled" ? (doctorsRes.value.data   || []) : [];
        const polys      = polyRes.status       === "fulfilled" ? (polyRes.value.data       || []) : [];
        const patients   = patientsRes.status   === "fulfilled" ? (patientsRes.value.data   || []) : [];
        const appts      = appRes.status        === "fulfilled" ? (appRes.value.data        || []) : [];
        const emergencies= emergRes.status      === "fulfilled" ? (emergRes.value.data      || []) : [];
        const schedules  = scheduleRes.status   === "fulfilled" ? (scheduleRes.value.data   || []) : [];

        setStats({
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
        });
      } catch {
        setStats((prev) => ({ ...prev, loading: false }));
      }
    }
    load();
  }, []);

  const hour = new Date().getHours();
  const greeting = hour < 12 ? "Selamat Pagi" : hour < 18 ? "Selamat Siang" : "Selamat Malam";

  return (
    <div className="space-y-8 animate-slide-in">
      {/* Header */}
      <div className="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-3">
        <div>
          <p className="text-sm text-foreground/50">{greeting} 👋</p>
          <h1 className="text-2xl font-extrabold tracking-tight text-foreground mt-0.5">
            {user?.full_name ?? "Admin"}
          </h1>
          <p className="text-xs text-foreground/50 mt-1">
            {new Date().toLocaleDateString("id-ID", { weekday: "long", year: "numeric", month: "long", day: "numeric" })}
          </p>
        </div>
        {stats.activeEmergencies > 0 && (
          <Link href="/dashboard/emergencies"
            className="flex items-center gap-2 px-4 py-2 bg-red-500 text-white rounded-xl text-sm font-semibold animate-pulse shadow-lg hover:bg-red-600 transition-colors">
            🚨 {stats.activeEmergencies} Darurat Aktif
          </Link>
        )}
      </div>

      {/* Stat Cards */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        {stats.loading ? (
          [...Array(4)].map((_, i) => (
            <div key={i} className="glass-panel rounded-2xl border p-5 h-32 animate-pulse">
              <div className="w-10 h-10 bg-foreground/10 rounded-xl mb-3" />
              <div className="h-3 bg-foreground/10 rounded w-2/3 mb-2" />
              <div className="h-7 bg-foreground/10 rounded w-1/2" />
            </div>
          ))
        ) : (
          <>
            <StatCard icon="👥" label="Total Pasien"    value={stats.patients}            sub="Terdaftar di Mobile"  href="/dashboard/patients"     color="bg-blue-500"   />
            <StatCard icon="📅" label="Antrean Hari Ini" value={stats.totalAppointments}  sub={`${stats.pendingAppointments} Menunggu`} href="/dashboard/appointments" color="bg-primary" />
            <StatCard icon="🩺" label="Dokter"           value={stats.doctors}             sub={`${stats.polyclinics} Poliklinik`}       href="/dashboard/doctors"      color="bg-teal-500"   />
            <StatCard icon="🚨" label="Gawat Darurat"    value={stats.activeEmergencies}   sub="Kasus Aktif"         href="/dashboard/emergencies"  color="bg-red-500"    />
          </>
        )}
      </div>

      {/* Main Content Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Antrean Terbaru */}
        <div className="lg:col-span-2 glass-panel rounded-2xl border shadow-sm overflow-hidden">
          <div className="flex items-center justify-between px-5 py-4 border-b border-glass-border">
            <div>
              <h2 className="font-semibold text-sm">Antrean Terbaru</h2>
              <p className="text-xs text-foreground/50 mt-0.5">{stats.totalAppointments} total janji temu</p>
            </div>
            <Link href="/dashboard/appointments" className="text-xs text-primary hover:underline font-medium">Lihat Semua →</Link>
          </div>
          <div className="divide-y divide-glass-border">
            {stats.loading ? (
              [...Array(4)].map((_, i) => (
                <div key={i} className="px-5 py-3 flex items-center gap-3 animate-pulse">
                  <div className="w-8 h-8 rounded-full bg-foreground/10 flex-shrink-0" />
                  <div className="flex-1 space-y-1.5">
                    <div className="h-3 bg-foreground/10 rounded w-1/3" />
                    <div className="h-2.5 bg-foreground/10 rounded w-1/2" />
                  </div>
                </div>
              ))
            ) : stats.recentAppointments.length === 0 ? (
              <div className="px-5 py-8 text-center text-foreground/40 text-sm">Belum ada antrean.</div>
            ) : (
              stats.recentAppointments.map((a) => (
                <div key={a.id} className="px-5 py-3 flex items-center gap-3 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                  <div className="w-8 h-8 rounded-full bg-primary/10 flex items-center justify-center text-sm font-bold text-primary flex-shrink-0">
                    #{a.id}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="text-sm font-medium truncate">{a.notes || "Tidak ada catatan"}</div>
                    <div className="text-xs text-foreground/50 mt-0.5">
                      {new Date(a.created_at).toLocaleDateString("id-ID", { day: "2-digit", month: "short", year: "numeric" })}
                    </div>
                  </div>
                  <StatusPill status={a.status} />
                </div>
              ))
            )}
          </div>
        </div>

        {/* Panel Kanan */}
        <div className="space-y-5">
          {/* Progress Antrean */}
          <div className="glass-panel rounded-2xl border p-5 shadow-sm space-y-4">
            <h2 className="font-semibold text-sm">Status Antrean</h2>
            {[
              { label: "Menunggu",  value: stats.pendingAppointments,   total: stats.totalAppointments || 1, color: "bg-yellow-500" },
              { label: "Selesai",   value: stats.completedAppointments, total: stats.totalAppointments || 1, color: "bg-green-500"  },
              { label: "Lainnya",   value: stats.totalAppointments - stats.pendingAppointments - stats.completedAppointments, total: stats.totalAppointments || 1, color: "bg-gray-400" },
            ].map((item) => (
              <div key={item.label}>
                <div className="flex justify-between text-xs mb-1.5">
                  <span className="text-foreground/70">{item.label}</span>
                  <span className="font-semibold">{item.value}</span>
                </div>
                <div className="h-2 bg-foreground/10 rounded-full overflow-hidden">
                  <div
                    className={`h-full rounded-full ${item.color} transition-all duration-700`}
                    style={{ width: `${Math.round((item.value / item.total) * 100)}%` }}
                  />
                </div>
              </div>
            ))}
          </div>

          {/* Pasien Baru */}
          <div className="glass-panel rounded-2xl border p-5 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <h2 className="font-semibold text-sm">Pasien Baru</h2>
              <Link href="/dashboard/patients" className="text-xs text-primary hover:underline">Lihat →</Link>
            </div>
            <div className="space-y-2.5">
              {stats.loading ? (
                [...Array(3)].map((_, i) => (
                  <div key={i} className="flex items-center gap-2 animate-pulse">
                    <div className="w-7 h-7 rounded-full bg-foreground/10" />
                    <div className="h-3 bg-foreground/10 rounded flex-1" />
                  </div>
                ))
              ) : stats.recentPatients.length === 0 ? (
                <div className="text-xs text-foreground/40 text-center py-2">Belum ada pasien.</div>
              ) : (
                stats.recentPatients.map((p) => (
                  <div key={p.id} className="flex items-center gap-2.5">
                    <div className="w-7 h-7 rounded-full bg-primary/15 flex items-center justify-center text-xs font-bold text-primary flex-shrink-0">
                      {(p.full_name || p.email || "?")[0].toUpperCase()}
                    </div>
                    <div className="min-w-0">
                      <div className="text-xs font-medium truncate">{p.full_name || p.email}</div>
                      <div className="text-[10px] text-foreground/40">
                        {new Date(p.created_at).toLocaleDateString("id-ID", { day: "2-digit", month: "short" })}
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>

          {/* Jadwal Dokter Terbaru */}
          <div className="glass-panel rounded-2xl border p-5 shadow-sm">
            <div className="flex items-center justify-between mb-3">
              <h2 className="font-semibold text-sm">Jadwal Dokter</h2>
              <Link href="/dashboard/doctors" className="text-xs text-primary hover:underline">Master Dokter →</Link>
            </div>
            <div className="space-y-2.5">
              {stats.loading ? (
                [...Array(3)].map((_, i) => (
                  <div key={i} className="flex items-center gap-2 animate-pulse">
                    <div className="w-7 h-7 rounded-full bg-foreground/10" />
                    <div className="h-3 bg-foreground/10 rounded flex-1" />
                  </div>
                ))
              ) : stats.recentSchedules?.length === 0 ? (
                <div className="text-xs text-foreground/40 text-center py-2">Belum ada jadwal.</div>
              ) : (
                stats.recentSchedules?.map((s) => (
                  <div key={s.id} className="flex items-center gap-2.5">
                    <div className="w-7 h-7 rounded-full bg-teal-500/15 flex items-center justify-center text-xs font-bold text-teal-600 flex-shrink-0">
                      🩺
                    </div>
                    <div className="min-w-0">
                      <div className="text-xs font-medium truncate">{s.doctor?.name || "Dokter"}</div>
                      <div className="text-[10px] text-foreground/50">
                        {new Date(s.date).toLocaleDateString("id-ID", { day: "2-digit", month: "short" })} • {s.start_time} - {s.end_time}
                      </div>
                    </div>
                  </div>
                ))
              )}
            </div>
          </div>
        </div>
      </div>

      {/* Gawat Darurat Aktif */}
      {(stats.activeEmergencies > 0 || stats.recentEmergencies.length > 0) && (
        <div className="glass-panel rounded-2xl border shadow-sm overflow-hidden">
          <div className="flex items-center justify-between px-5 py-4 border-b border-glass-border bg-red-500/5">
            <div className="flex items-center gap-2">
              <span className="w-2 h-2 rounded-full bg-red-500 animate-ping inline-block" />
              <h2 className="font-semibold text-sm text-red-600">Gawat Darurat Terbaru</h2>
            </div>
            <Link href="/dashboard/emergencies" className="text-xs text-primary hover:underline font-medium">Lihat Semua →</Link>
          </div>
          <div className="divide-y divide-glass-border">
            {stats.recentEmergencies.map((e) => (
              <div key={e.id} className="px-5 py-3 flex items-center gap-3 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                <div className="w-8 h-8 rounded-full bg-red-500/10 flex items-center justify-center text-base flex-shrink-0">🚨</div>
                <div className="flex-1">
                  <div className="text-sm font-medium">Kasus #{e.id}</div>
                  <div className="text-xs text-foreground/50">
                    {new Date(e.created_at).toLocaleDateString("id-ID", { day: "2-digit", month: "short", hour: "2-digit", minute: "2-digit" })}
                  </div>
                </div>
                <StatusPill status={e.status} />
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Quick Actions */}
      <div>
        <h2 className="font-semibold text-sm text-foreground/60 uppercase tracking-wider mb-3">Aksi Cepat</h2>
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
          {[
            { href: "/dashboard/doctors",        icon: "🩺", label: "Tambah Dokter"     },
            { href: "/dashboard/reminders",      icon: "🔔", label: "Kirim Reminder"    },
            { href: "/dashboard/medical-results", icon: "🧾", label: "Input Hasil Medis" },
            { href: "/dashboard/ai-audit",        icon: "🤖", label: "Sinkronisasi AI"   },
          ].map((action) => (
            <Link key={action.href} href={action.href}
              className="glass-panel rounded-2xl border p-4 flex flex-col items-center gap-2 text-center hover:bg-primary/5 hover:border-primary/30 transition-all duration-200 group shadow-sm">
              <span className="text-2xl group-hover:scale-110 transition-transform duration-200">{action.icon}</span>
              <span className="text-xs font-medium text-foreground/70">{action.label}</span>
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}
