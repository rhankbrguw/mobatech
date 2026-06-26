"use client";

import { useEffect, useState } from "react";
import { api, ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { Doctor, DoctorSchedule } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { DoctorFormModal } from "@/components/DoctorFormModal";
import { ScheduleModal } from "@/components/ScheduleModal";
import { ScheduleCalendar } from "@/components/ScheduleCalendar";
import { DeleteModal } from "@/components/DeleteModal";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Plus, Edit2, Trash2, Calendar, Users, Clock } from "lucide-react";

export default function DoctorsPage() {
  const [items, setItems] = useState<Doctor[]>([]);
  const [schedules, setSchedules] = useState<DoctorSchedule[]>([]);
  const [activeTab, setActiveTab] = useState<"doctors" | "schedules">("doctors");
  const [loading, setLoading] = useState(true);
  const [showFormModal, setShowFormModal] = useState(false);
  const [showSchedModal, setShowSchedModal] = useState(false);
  const [selectedItem, setSelectedItem] = useState<Doctor | null>(null);

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning";
  }>({ isOpen: false, message: "", type: "success" });

  const loadItems = async () => {
    try {
      const [docRes, schedRes] = await Promise.allSettled([
        api.get<Doctor[]>("/api/doctors"),
        api.get<DoctorSchedule[]>("/api/admin/schedules?limit=200")
      ]);
      setItems(docRes.status === "fulfilled" ? (docRes.value.data || []) : []);
      setSchedules(schedRes.status === "fulfilled" ? (schedRes.value.data || []) : []);
    } catch {
      setToast({ isOpen: true, message: APP_STRINGS.login.networkError, type: "error" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadItems();
    
    // Auto-refresh for realtime updates
    const interval = setInterval(() => {
      loadItems();
    }, 5000);
    
    return () => clearInterval(interval);
  }, []);

  const openForm = (item: Doctor | null = null) => {
    setSelectedItem(item);
    setShowFormModal(true);
  };

  const openSchedules = (item: Doctor) => {
    setSelectedItem(item);
    setShowSchedModal(true);
  };

  const handleSave = async (payload: any) => {
    try {
      if (selectedItem) {
        await api.put(`/api/admin/doctors/${selectedItem.id}`, payload);
        setToast({ isOpen: true, message: APP_STRINGS.doctors.successUpdate, type: "success" });
      } else {
        await api.post("/api/admin/doctors", payload);
        setToast({ isOpen: true, message: APP_STRINGS.doctors.successCreate, type: "success" });
      }
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
      throw err;
    }
  };

  const [deleteId, setDeleteId] = useState<number | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  const handleDelete = async (id: number) => {
    setIsDeleting(true);
    try {
      await api.delete(`/api/admin/doctors/${id}`);
      setToast({ isOpen: true, message: APP_STRINGS.doctors.successDelete, type: "success" });
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    } finally {
      setIsDeleting(false);
      setDeleteId(null);
    }
  };

  const groupedSchedules = schedules.reduce((acc, sched) => {
    const d = new Date(sched.date);
    const dateKey = `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`;
    if (!acc[dateKey]) acc[dateKey] = [];
    acc[dateKey].push(sched);
    return acc;
  }, {} as Record<string, DoctorSchedule[]>);
  const sortedDates = Object.keys(groupedSchedules).sort();

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title={APP_STRINGS.doctors.title}
        description={APP_STRINGS.doctors.subtitle}
        action={
          <Button onClick={() => openForm(null)} icon={<Plus size={18} />}>
            {APP_STRINGS.doctors.addBtn}
          </Button>
        }
      />

      <div className="flex gap-2 p-1 bg-black/5 dark:bg-white/5 rounded-xl w-max">
        <button
          onClick={() => setActiveTab("doctors")}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
            activeTab === "doctors" ? "bg-white dark:bg-black/50 shadow text-primary" : "text-foreground/60 hover:text-foreground"
          }`}
        >
          <Users size={16} /> Daftar Dokter
        </button>
        <button
          onClick={() => setActiveTab("schedules")}
          className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-colors ${
            activeTab === "schedules" ? "bg-white dark:bg-black/50 shadow text-primary" : "text-foreground/60 hover:text-foreground"
          }`}
        >
          <Clock size={16} /> Jadwal by Day
        </button>
      </div>

      <Card noPadding className="overflow-x-auto">
        {loading ? (
          <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>
        ) : activeTab === "doctors" ? (
          <table className="w-full text-left border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-black/5 dark:bg-white/5 font-semibold">
                <th className="p-4">{APP_STRINGS.doctors.tableHeaderName}</th>
                <th className="p-4">Poliklinik</th>
                <th className="p-4">{APP_STRINGS.doctors.tableHeaderSpec}</th>
                <th className="p-4">{APP_STRINGS.doctors.tableHeaderContact}</th>
                <th className="p-4">{APP_STRINGS.doctors.tableHeaderStatus}</th>
                <th className="p-4 text-right">{APP_STRINGS.doctors.tableHeaderActions}</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id} className="border-b border-glass-border/50 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                  <td className="p-4 font-semibold">{item.name}</td>
                  <td className="p-4 text-foreground/75">{item.polyclinic?.name || "-"}</td>
                  <td className="p-4 text-foreground/75">{item.specialization}</td>
                  <td className="p-4 text-foreground/60">{item.contact_info}</td>
                  <td className="p-4">
                    <Badge variant={item.is_active ? "success" : "error"}>
                      {item.is_active ? APP_STRINGS.doctors.statusActive : APP_STRINGS.doctors.statusInactive}
                    </Badge>
                  </td>
                  <td className="p-4 text-right">
                    <div className="flex gap-2 justify-end">
                      <Button size="sm" variant="outline" onClick={() => openSchedules(item)} icon={<Calendar size={14} />}>
                        Jadwal
                      </Button>
                      <Button size="sm" variant="ghost" onClick={() => openForm(item)} className="text-primary hover:text-primary-hover px-2" icon={<Edit2 size={14} />}>
                        Ubah
                      </Button>
                      <Button size="sm" variant="ghost" onClick={() => setDeleteId(item.id)} className="text-rose-500 hover:text-rose-600 px-2" icon={<Trash2 size={14} />}>
                        Hapus
                      </Button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        ) : (
          <div className="p-6 space-y-8">
            {sortedDates.length === 0 ? (
              <div className="text-center text-foreground/50 py-10">Belum ada jadwal dokter.</div>
            ) : (
              <ScheduleCalendar groupedSchedules={groupedSchedules} />
            )}
          </div>
        )}
      </Card>

      <DoctorFormModal isOpen={showFormModal} onClose={() => setShowFormModal(false)} doctor={selectedItem} onSave={handleSave} />
      <ScheduleModal isOpen={showSchedModal} onClose={() => setShowSchedModal(false)} doctor={selectedItem} onChange={loadItems} />
      
      <DeleteModal
        isOpen={deleteId !== null}
        onClose={() => setDeleteId(null)}
        onConfirm={() => deleteId !== null && handleDelete(deleteId)}
        isLoading={isDeleting}
      />

      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
