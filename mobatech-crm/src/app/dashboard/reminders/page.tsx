"use client";

import { useState, useEffect } from "react";
import { api } from "@/lib/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { Badge, BadgeVariant } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Plus, X, Trash2 } from "lucide-react";

interface User { id: number; full_name: string; email: string; phone_number: string; }
interface Reminder { id: number; created_at: string; user_id: number; appointment_id: number; title: string; message: string; reminder_date: string; is_read: boolean; type: string; }

const REMINDER_TYPES = ["Appointment", "Medication", "Checkup", "General"];

const defaultForm = { user_id: 0, appointment_id: 0, title: "", message: "", reminder_date: "", type: "General" };

export default function RemindersPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [reminders, setReminders] = useState<Reminder[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [form, setForm] = useState(defaultForm);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({ isOpen: false, message: "", type: "success" });

  const showToast = (message: string, type: "success" | "error") =>
    setToast({ isOpen: true, message, type });

  const loadUsers = async () => {
    try {
      const res = await api.get<User[]>("/api/admin/users");
      setUsers(res.data || []);
    } catch { /* non-blocking */ }
  };

  const loadReminders = async () => {
    setLoading(true);
    try {
      const res = await api.get<Reminder[]>("/api/admin/reminders");
      setReminders(res.data || []);
    } catch { showToast("Gagal memuat data reminder", "error"); }
    finally { setLoading(false); }
  };

  useEffect(() => {
    loadUsers();
    loadReminders();
  }, []);

  const handleCreate = async () => {
    if (!form.user_id || !form.title || !form.reminder_date) {
      showToast("Pilih pasien, isi Judul, dan Tanggal", "error");
      return;
    }
    // Go time.Time requires RFC3339 format — append seconds and timezone if missing
    const isoDate = form.reminder_date.includes(":") && form.reminder_date.length === 16
      ? form.reminder_date + ":00+07:00"
      : form.reminder_date;
    setSaving(true);
    try {
      await api.post("/api/admin/reminders", { ...form, reminder_date: isoDate });
      showToast("Reminder berhasil dikirim ke pasien", "success");
      setShowForm(false);
      setForm(defaultForm);
      loadReminders();
    } catch { showToast("Gagal membuat reminder", "error"); }
    finally { setSaving(false); }
  };

  const handleDelete = async (id: number) => {
    if (!confirm("Hapus reminder ini?")) return;
    try {
      await api.delete(`/api/admin/reminders/${id}`);
      showToast("Reminder dihapus", "success");
      loadReminders();
    } catch { showToast("Gagal menghapus reminder", "error"); }
  };

  const getUserName = (userId: number) => {
    const u = users.find((u) => u.id === userId);
    return u ? u.full_name || u.email : `User #${userId}`;
  };

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title="Pengingat Pasien"
        description="Kirim notifikasi / pengingat ke pasien terdaftar."
        action={
          <Button onClick={() => setShowForm(!showForm)} variant={showForm ? "outline" : "primary"} icon={showForm ? <X size={18} /> : <Plus size={18} />}>
            {showForm ? "Batal" : "Kirim Reminder Baru"}
          </Button>
        }
      />

      {showForm && (
        <Card className="space-y-4">
          <h2 className="font-semibold text-base">Form Kirim Reminder</h2>
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Pasien *</label>
              <select
                value={form.user_id || ""}
                onChange={(e) => setForm((f) => ({ ...f, user_id: Number(e.target.value) }))}
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary"
              >
                <option value="">— Pilih Pasien —</option>
                {users.map((u) => (
                  <option key={u.id} value={u.id}>
                    {u.full_name || u.email} {u.phone_number ? `(${u.phone_number})` : ""}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Tipe Reminder</label>
              <select
                value={form.type}
                onChange={(e) => setForm((f) => ({ ...f, type: e.target.value }))}
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary"
              >
                {REMINDER_TYPES.map((t) => <option key={t}>{t}</option>)}
              </select>
            </div>

            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Judul *</label>
              <input
                type="text"
                value={form.title}
                onChange={(e) => setForm((f) => ({ ...f, title: e.target.value }))}
                placeholder="Judul singkat reminder"
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary"
              />
            </div>

            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Tanggal &amp; Waktu *</label>
              <input
                type="datetime-local"
                value={form.reminder_date}
                onChange={(e) => setForm((f) => ({ ...f, reminder_date: e.target.value }))}
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary"
              />
            </div>

            <div className="sm:col-span-2 space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Pesan</label>
              <textarea
                value={form.message}
                onChange={(e) => setForm((f) => ({ ...f, message: e.target.value }))}
                rows={3}
                placeholder="Isi pesan pengingat untuk pasien..."
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary resize-none"
              />
            </div>
          </div>

          <div className="flex justify-end pt-2">
            <Button onClick={handleCreate} isLoading={saving}>
              Kirim Reminder
            </Button>
          </div>
        </Card>
      )}

      <Card noPadding>
        {loading ? (
          <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>
        ) : reminders.length === 0 ? (
          <div className="p-10 text-center text-foreground/50 text-sm">Belum ada reminder yang dikirim.</div>
        ) : (
          <div className="divide-y divide-glass-border">
            {reminders.map((r) => (
              <div
                key={r.id}
                className="p-4 flex items-start justify-between gap-3 hover:bg-black/5 dark:hover:bg-white/5 transition-colors"
              >
                <div className="flex items-start gap-3">
                  <div className={`mt-1.5 w-2 h-2 rounded-full flex-shrink-0 ${r.is_read ? "bg-gray-300" : "bg-primary"}`} />
                  <div>
                    <div className="flex items-center gap-2 flex-wrap">
                      <span className="font-semibold text-sm">{r.title}</span>
                      <Badge variant={r.type === 'Appointment' ? 'info' : r.type === 'Medication' ? 'success' : r.type === 'Checkup' ? 'warning' : 'neutral'}>
                        {r.type}
                      </Badge>
                      {r.is_read && <span className="text-xs text-foreground/40">Sudah dibaca</span>}
                    </div>
                    {r.message && <div className="text-xs text-foreground/60 mt-1">{r.message}</div>}
                    <div className="text-xs text-foreground/40 mt-1">
                      Kepada: <span className="font-medium text-foreground/60">{getUserName(r.user_id)}</span>
                      {" • "}
                      {new Date(r.reminder_date).toLocaleDateString("id-ID", {
                        day: "2-digit", month: "short", year: "numeric", hour: "2-digit", minute: "2-digit",
                      })}
                    </div>
                  </div>
                </div>

                <Button size="sm" variant="ghost" onClick={() => handleDelete(r.id)} className="text-rose-500 hover:text-rose-600 px-2 flex-shrink-0" icon={<Trash2 size={14} />}>
                  Hapus
                </Button>
              </div>
            ))}
          </div>
        )}
      </Card>

      <CustomSnackbar
        isOpen={toast.isOpen}
        message={toast.message}
        type={toast.type}
        onClose={() => setToast((t) => ({ ...t, isOpen: false }))}
      />
    </div>
  );
}
