"use client";

import { useEffect, useState } from "react";
import { api, ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { Appointment } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { format } from "date-fns";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { Badge, BadgeVariant } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Check, X, CheckCircle2 } from "lucide-react";

export default function AppointmentsPage() {
  const [items, setItems] = useState<Appointment[]>([]);
  const [loading, setLoading] = useState(true);
  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning";
  }>({ isOpen: false, message: "", type: "success" });

  const loadItems = async () => {
    try {
      const res = await api.get<Appointment[]>("/api/admin/appointments");
      setItems(res.data || []);
    } catch {
      setToast({ isOpen: true, message: APP_STRINGS.login.networkError, type: "error" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadItems();
  }, []);

  const handleApprove = async (id: number) => {
    try {
      await api.post(`/api/admin/appointments/${id}/approve`, {});
      setToast({ isOpen: true, message: "Antrean berhasil disetujui", type: "success" });
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    }
  };

  const handleCancel = async (id: number) => {
    if (!confirm("Yakin ingin membatalkan antrean ini?")) return;
    try {
      await api.post(`/api/admin/appointments/${id}/cancel`, {});
      setToast({ isOpen: true, message: "Antrean dibatalkan", type: "success" });
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    }
  };

  const handleComplete = async (id: number) => {
    try {
      await api.post(`/api/admin/appointments/${id}/complete`, {});
      setToast({ isOpen: true, message: "Antrean diselesaikan", type: "success" });
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    }
  };

  const getStatusBadge = (status: string) => {
    let variant: BadgeVariant = "warning";
    let label = "Menunggu";

    switch (status) {
      case "approved":
        variant = "success";
        label = "Disetujui";
        break;
      case "cancelled":
        variant = "error";
        label = "Dibatalkan";
        break;
      case "completed":
        variant = "info";
        label = "Selesai";
        break;
    }

    return <Badge variant={variant}>{label}</Badge>;
  };

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title="Antrean Pasien"
        description="Pantau jadwal dan janji temu pasien (Live Booking Queue)."
      />

      <Card noPadding>
        {loading ? (
          <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full text-left border-collapse text-sm">
              <thead>
                <tr className="border-b border-glass-border bg-black/5 dark:bg-white/5 font-semibold">
                  <th className="p-4">Tanggal Daftar</th>
                  <th className="p-4">Pasien</th>
                  <th className="p-4">Dokter & Jadwal</th>
                  <th className="p-4">Catatan</th>
                  <th className="p-4">Status</th>
                  <th className="p-4 text-right">Aksi</th>
                </tr>
              </thead>
              <tbody>
                {items.map((item) => (
                  <tr key={item.id} className="border-b border-glass-border/50 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                    <td className="p-4 text-foreground/80">{format(new Date(item.created_at), "dd MMM yyyy HH:mm")}</td>
                    <td className="p-4 font-semibold">
                      {item.user?.full_name || `Pasien #${item.user_id}`}
                      <div className="text-xs text-foreground/60 font-normal">{item.user?.email}</div>
                    </td>
                    <td className="p-4">
                      <div className="font-semibold">{item.doctor?.name}</div>
                      <div className="text-xs text-foreground/60">
                        {item.schedule ? `${item.schedule.date} (${item.schedule.start_time} - ${item.schedule.end_time})` : "Jadwal tidak ditemukan"}
                      </div>
                    </td>
                    <td className="p-4 text-foreground/75 max-w-[150px] truncate">{item.notes || "-"}</td>
                    <td className="p-4">{getStatusBadge(item.status)}</td>
                    <td className="p-4 text-right space-x-2 whitespace-nowrap">
                      {item.status === "pending" && (
                        <>
                          <Button size="sm" variant="outline" className="text-emerald-600 border-emerald-500/30 hover:bg-emerald-500/10" onClick={() => handleApprove(item.id)} icon={<Check size={14} />}>
                            Setujui
                          </Button>
                          <Button size="sm" variant="danger" onClick={() => handleCancel(item.id)} icon={<X size={14} />}>
                            Tolak
                          </Button>
                        </>
                      )}
                      {item.status === "approved" && (
                        <Button size="sm" variant="outline" className="text-blue-600 border-blue-500/30 hover:bg-blue-500/10" onClick={() => handleComplete(item.id)} icon={<CheckCircle2 size={14} />}>
                          Selesai
                        </Button>
                      )}
                    </td>
                  </tr>
                ))}
                {items.length === 0 && (
                  <tr>
                    <td colSpan={6} className="p-8 text-center text-foreground/50 text-sm">Tidak ada antrean saat ini</td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>
        )}
      </Card>

      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
