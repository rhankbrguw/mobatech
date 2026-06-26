"use client";

import { useEffect, useState } from "react";
import { api, ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { Polyclinic } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { Modal } from "@/components/Modal";
import { DeleteModal } from "@/components/DeleteModal";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { Badge } from "@/components/ui/Badge";
import { Button } from "@/components/ui/Button";
import { Plus, Edit2, Trash2 } from "lucide-react";

export default function PolyclinicsPage() {
  const [items, setItems] = useState<Polyclinic[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [selectedItem, setSelectedItem] = useState<Polyclinic | null>(null);

  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [imageUrl, setImageUrl] = useState("");
  const [isActive, setIsActive] = useState(true);
  const [saving, setSaving] = useState(false);

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning";
  }>({ isOpen: false, message: "", type: "success" });

  const loadItems = async () => {
    try {
      const res = await api.get<Polyclinic[]>("/api/polyclinics");
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

  const openForm = (item: Polyclinic | null = null) => {
    setSelectedItem(item);
    setName(item ? item.name : "");
    setDescription(item ? item.description : "");
    setImageUrl(item ? item.image_url : "");
    setIsActive(item ? item.is_active : true);
    setShowModal(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    const payload = {
      name,
      description,
      image_url: imageUrl || "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?w=150",
      is_active: isActive,
    };

    try {
      if (selectedItem) {
        await api.put(`/api/admin/polyclinics/${selectedItem.id}`, payload);
        setToast({ isOpen: true, message: APP_STRINGS.polyclinics.successUpdate, type: "success" });
      } else {
        await api.post("/api/admin/polyclinics", payload);
        setToast({ isOpen: true, message: APP_STRINGS.polyclinics.successCreate, type: "success" });
      }
      setShowModal(false);
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    } finally {
      setSaving(false);
    }
  };
  const [deleteId, setDeleteId] = useState<number | null>(null);

  const handleDelete = async (id: number) => {
    setSaving(true);
    try {
      await api.delete(`/api/admin/polyclinics/${id}`);
      setToast({ isOpen: true, message: APP_STRINGS.polyclinics.successDelete, type: "success" });
      loadItems();
    } catch (err) {
      const msg = err instanceof ApiError ? err.message : APP_STRINGS.login.networkError;
      setToast({ isOpen: true, message: msg, type: "error" });
    } finally {
      setSaving(false);
      setDeleteId(null);
    }
  };

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title={APP_STRINGS.polyclinics.title}
        description={APP_STRINGS.polyclinics.subtitle}
        action={
          <Button onClick={() => openForm(null)} icon={<Plus size={18} />}>
            {APP_STRINGS.polyclinics.addBtn}
          </Button>
        }
      />

      <Card noPadding className="overflow-x-auto">
        {loading ? (
          <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>
        ) : (
          <table className="w-full text-left border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-black/5 dark:bg-white/5 font-semibold">
                <th className="p-4">{APP_STRINGS.polyclinics.tableHeaderName}</th>
                <th className="p-4">{APP_STRINGS.polyclinics.tableHeaderDesc}</th>
                <th className="p-4">Daftar Dokter</th>
                <th className="p-4">{APP_STRINGS.polyclinics.tableHeaderStatus}</th>
                <th className="p-4 text-right">{APP_STRINGS.polyclinics.tableHeaderActions}</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id} className="border-b border-glass-border/50 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                  <td className="p-4 font-semibold">{item.name}</td>
                  <td className="p-4 text-foreground/75 truncate max-w-xs">{item.description}</td>
                  <td className="p-4">
                    {item.doctors && item.doctors.length > 0 ? (
                      <div className="flex flex-wrap gap-1">
                        {item.doctors.map((doc) => (
                          <span key={doc.id} className="px-2 py-0.5 rounded-full bg-primary/10 text-primary text-[10px] font-medium">
                            {doc.name}
                          </span>
                        ))}
                      </div>
                    ) : (
                      <span className="text-xs text-foreground/40">Belum ada dokter</span>
                    )}
                  </td>
                  <td className="p-4">
                    <Badge variant={item.is_active ? "success" : "error"}>
                      {item.is_active ? APP_STRINGS.polyclinics.statusActive : APP_STRINGS.polyclinics.statusInactive}
                    </Badge>
                  </td>
                  <td className="p-4 text-right">
                    <div className="flex gap-2 justify-end">
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
        )}
      </Card>

      <Modal isOpen={showModal} onClose={() => setShowModal(false)} title={selectedItem ? APP_STRINGS.polyclinics.editTitle : APP_STRINGS.polyclinics.addTitle}>
        <form onSubmit={handleSave} className="space-y-4">
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.polyclinics.nameLabel}</label>
            <input type="text" required value={name} onChange={(e) => setName(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" />
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.polyclinics.descLabel}</label>
            <textarea required value={description} onChange={(e) => setDescription(e.target.value)} className="w-full p-3 rounded-xl border glass-input text-sm text-foreground h-20 resize-none focus:border-primary outline-none" />
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.polyclinics.imgLabel}</label>
            <input type="text" value={imageUrl} onChange={(e) => setImageUrl(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" />
          </div>
          <div className="flex items-center gap-2">
            <input type="checkbox" id="isActive" checked={isActive} onChange={(e) => setIsActive(e.target.checked)} className="rounded border-glass-border text-primary focus:ring-primary w-4 h-4 cursor-pointer" />
            <label htmlFor="isActive" className="text-xs font-semibold cursor-pointer">{APP_STRINGS.polyclinics.activeLabel}</label>
          </div>
          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="ghost" onClick={() => setShowModal(false)}>{APP_STRINGS.polyclinics.cancelBtn}</Button>
            <Button type="submit" isLoading={saving}>{APP_STRINGS.polyclinics.saveBtn}</Button>
          </div>
        </form>
      </Modal>

      <DeleteModal
        isOpen={deleteId !== null}
        onClose={() => setDeleteId(null)}
        onConfirm={() => deleteId !== null && handleDelete(deleteId)}
        isLoading={saving}
      />

      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
