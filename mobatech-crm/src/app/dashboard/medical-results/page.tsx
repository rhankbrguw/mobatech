"use client";

import { useState, useEffect } from "react";
import { api } from "@/lib/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { DeleteModal } from "@/components/DeleteModal";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Plus, Edit2, Trash2 } from "lucide-react";

interface User { id: number; full_name: string; email: string; }

interface MedicalResult { id: number; created_at: string; user_id: number; appointment_id: number; doctor_name: string; test_type: string; test_name: string; result: string; notes: string; file_url: string; result_date: string; }

const TEST_TYPES = ["Lab", "Radiologi", "EKG", "USG", "Endoskopi", "Lainnya"];

const defaultForm = { user_id: 0, appointment_id: 0, doctor_name: "", test_type: "Lab", test_name: "", result: "", notes: "", file_url: "", result_date: "" };

export default function MedicalResultsPage() {
  const [users, setUsers] = useState<User[]>([]);
  const [results, setResults] = useState<MedicalResult[]>([]);
  const [loading, setLoading] = useState(true);
  const [showForm, setShowForm] = useState(false);
  const [editId, setEditId] = useState<number | null>(null);
  const [form, setForm] = useState(defaultForm);
  const [saving, setSaving] = useState(false);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({ isOpen: false, message: "", type: "success" });

  const showToast = (message: string, type: "success" | "error") => setToast({ isOpen: true, message, type });

  const load = async () => {
    setLoading(true);
    try {
      const res = await api.get<MedicalResult[]>("/api/admin/medical-results");
      setResults(res.data || []);
    } catch { showToast("Gagal memuat hasil medis", "error"); }
    finally { setLoading(false); }
  };

  const loadUsers = async () => {
    try {
      const res = await api.get<User[]>("/api/admin/users");
      setUsers(res.data || []);
    } catch { /* non-blocking */ }
  };

  useEffect(() => { load(); loadUsers(); }, []);

  const openCreate = () => { setForm(defaultForm); setEditId(null); setShowForm(true); };
  const openEdit = (r: MedicalResult) => {
    setForm({ user_id: r.user_id, appointment_id: r.appointment_id, doctor_name: r.doctor_name, test_type: r.test_type, test_name: r.test_name, result: r.result, notes: r.notes, file_url: r.file_url, result_date: r.result_date?.slice(0, 10) ?? "" });
    setEditId(r.id);
    setShowForm(true);
  };

  const handleSave = async () => {
    if (!form.user_id || !form.test_name || !form.result_date) {
      showToast("User ID, Nama Tes, dan Tanggal wajib diisi", "error");
      return;
    }
    setSaving(true);
    try {
      if (editId) {
        await api.put(`/api/admin/medical-results/${editId}`, form);
        showToast("Hasil medis diperbarui", "success");
      } else {
        await api.post("/api/admin/medical-results", form);
        showToast("Hasil medis berhasil ditambahkan", "success");
      }
      setShowForm(false);
      setForm(defaultForm);
      setEditId(null);
      load();
    } catch { showToast("Gagal menyimpan data", "error"); }
    finally { setSaving(false); }
  };

  const [deleteId, setDeleteId] = useState<number | null>(null);
  const [isDeleting, setIsDeleting] = useState(false);

  const handleDelete = async (id: number) => {
    setIsDeleting(true);
    try {
      await api.delete(`/api/admin/medical-results/${id}`);
      showToast("Data dihapus", "success");
      load();
    } catch { 
      showToast("Gagal menghapus data", "error"); 
    } finally {
      setIsDeleting(false);
      setDeleteId(null);
    }
  };

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title="Hasil Medis Pasien"
        description="Input dan kelola hasil lab, radiologi, dan pemeriksaan medis lainnya."
        action={
          <Button onClick={openCreate} icon={<Plus size={18} />}>
            Tambah Hasil Medis
          </Button>
        }
      />

      {showForm && (
        <Card className="space-y-4">
          <h2 className="font-semibold text-base">{editId ? "Edit Hasil Medis" : "Tambah Hasil Medis Baru"}</h2>
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
                  <option key={u.id} value={u.id}>{u.full_name || u.email}</option>
                ))}
              </select>
            </div>
            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">ID Janji Temu (opsional)</label>
              <input type="number" value={form.appointment_id || ""} onChange={(e) => setForm((f) => ({ ...f, appointment_id: Number(e.target.value) }))}
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary" />
            </div>
            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Nama Dokter</label>
              <input type="text" value={form.doctor_name} onChange={(e) => setForm((f) => ({ ...f, doctor_name: e.target.value }))}
                placeholder="dr. Budi, Sp.PD" className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary" />
            </div>
            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Tipe Pemeriksaan</label>
              <select value={form.test_type} onChange={(e) => setForm((f) => ({ ...f, test_type: e.target.value }))}
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary">
                {TEST_TYPES.map((t) => <option key={t}>{t}</option>)}
              </select>
            </div>
            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Nama Tes *</label>
              <input type="text" value={form.test_name} onChange={(e) => setForm((f) => ({ ...f, test_name: e.target.value }))}
                placeholder="Darah Lengkap, Rontgen Thorax, dll." className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary" />
            </div>
            <div className="space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Tanggal Hasil *</label>
              <input type="date" value={form.result_date} onChange={(e) => setForm((f) => ({ ...f, result_date: e.target.value }))}
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary" />
            </div>
            <div className="sm:col-span-2 space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Hasil / Kesimpulan *</label>
              <textarea value={form.result} onChange={(e) => setForm((f) => ({ ...f, result: e.target.value }))}
                rows={3} placeholder="Tuliskan ringkasan hasil pemeriksaan..."
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary resize-none" />
            </div>
            <div className="sm:col-span-2 space-y-1">
              <label className="text-xs text-foreground/60 font-medium">Catatan Dokter</label>
              <textarea value={form.notes} onChange={(e) => setForm((f) => ({ ...f, notes: e.target.value }))}
                rows={2} placeholder="Anjuran atau catatan tambahan..."
                className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary resize-none" />
            </div>
            <div className="sm:col-span-2 space-y-1">
              <label className="text-xs text-foreground/60 font-medium">URL Berkas (PDF / Gambar)</label>
              <input type="text" value={form.file_url} onChange={(e) => setForm((f) => ({ ...f, file_url: e.target.value }))}
                placeholder="https://..." className="w-full glass-input rounded-xl px-3 py-2 text-sm text-foreground focus:border-primary" />
            </div>
          </div>
          <div className="flex justify-end gap-2 pt-2">
            <Button variant="ghost" onClick={() => setShowForm(false)}>Batal</Button>
            <Button onClick={handleSave} isLoading={saving}>
              {editId ? "Simpan Perubahan" : "Tambahkan"}
            </Button>
          </div>
        </Card>
      )}

      <Card noPadding className="overflow-x-auto">
        {loading ? (
          <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>
        ) : (
          <table className="w-full text-left border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-black/5 dark:bg-white/5 font-semibold">
                <th className="p-4">Tanggal</th>
                <th className="p-4">Pasien</th>
                <th className="p-4">Dokter</th>
                <th className="p-4">Pemeriksaan</th>
                <th className="p-4">Ringkasan Hasil</th>
                <th className="p-4 text-right">Aksi</th>
              </tr>
            </thead>
            <tbody>
              {results.length === 0 ? (
                <tr><td colSpan={6} className="p-8 text-center text-foreground/50">Belum ada data hasil medis.</td></tr>
              ) : results.map((r) => (
                <tr key={r.id} className="border-b border-glass-border/50 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                  <td className="p-4 text-foreground/70 text-xs whitespace-nowrap">{new Date(r.result_date).toLocaleDateString("id-ID", { day: "2-digit", month: "short", year: "numeric" })}</td>
                  <td className="p-4 font-semibold">
                    {users.find((u) => u.id === r.user_id)?.full_name || users.find((u) => u.id === r.user_id)?.email || `User #${r.user_id}`}
                  </td>
                  <td className="p-4 text-foreground/80">{r.doctor_name || "-"}</td>
                  <td className="p-4">
                    <div>{r.test_name}</div>
                    <span className="px-1.5 py-0.5 bg-primary/10 text-primary rounded text-xs mt-1 inline-block">{r.test_type}</span>
                  </td>
                  <td className="p-4 text-foreground/70 max-w-xs truncate">{r.result}</td>
                  <td className="p-4 text-right">
                    <div className="flex gap-2 justify-end">
                      <Button size="sm" variant="ghost" onClick={() => openEdit(r)} className="text-primary hover:text-primary-hover px-2" icon={<Edit2 size={14} />}>
                        Edit
                      </Button>
                      <Button size="sm" variant="ghost" onClick={() => setDeleteId(r.id)} className="text-rose-500 hover:text-rose-600 px-2" icon={<Trash2 size={14} />}>
                        Hapus
                      </Button>
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </Card>

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
