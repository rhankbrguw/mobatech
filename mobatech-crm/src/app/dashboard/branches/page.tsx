"use client";

import { useEffect, useState } from "react";
import { api, ApiError } from "@/lib/api";
import { APP_STRINGS } from "@/lib/constants";
import { Branch } from "@/types/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { Modal } from "@/components/Modal";
import { DeleteModal } from "@/components/DeleteModal";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { Button } from "@/components/ui/Button";
import { Plus, Edit2, Trash2, MapPin } from "lucide-react";

export default function BranchesPage() {
  const [items, setItems] = useState<Branch[]>([]);
  const [loading, setLoading] = useState(true);
  const [showModal, setShowModal] = useState(false);
  const [selectedItem, setSelectedItem] = useState<Branch | null>(null);

  const [name, setName] = useState("");
  const [address, setAddress] = useState("");
  const [latitude, setLatitude] = useState<number>(0);
  const [longitude, setLongitude] = useState<number>(0);
  const [imageUrl, setImageUrl] = useState("");
  const [gmapsLink, setGmapsLink] = useState("");
  const [saving, setSaving] = useState(false);

  const [toast, setToast] = useState<{
    isOpen: boolean;
    message: string;
    type: "success" | "error" | "warning";
  }>({ isOpen: false, message: "", type: "success" });

  const loadItems = async () => {
    try {
      const res = await api.get<Branch[]>("/api/branches");
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

  const openForm = (item: Branch | null = null) => {
    setSelectedItem(item);
    setName(item ? item.name : "");
    setAddress(item ? item.address : "");
    setLatitude(item ? item.latitude : 0);
    setLongitude(item ? item.longitude : 0);
    setImageUrl(item ? item.image_url : "");
    setGmapsLink(item ? item.gmaps_link : "");
    setShowModal(true);
  };

  const handleSave = async (e: React.FormEvent) => {
    e.preventDefault();
    setSaving(true);
    const payload = {
      name,
      address,
      latitude,
      longitude,
      image_url: imageUrl || `https://placehold.co/400x400/1E5E44/FFFFFF/png?text=${encodeURIComponent(name)}`,
      gmaps_link: gmapsLink,
    };

    try {
      if (selectedItem) {
        await api.put(`/api/admin/branches/${selectedItem.id}`, payload);
        setToast({ isOpen: true, message: APP_STRINGS.branches.successUpdate, type: "success" });
      } else {
        await api.post("/api/admin/branches", payload);
        setToast({ isOpen: true, message: APP_STRINGS.branches.successCreate, type: "success" });
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
      await api.delete(`/api/admin/branches/${id}`);
      setToast({ isOpen: true, message: APP_STRINGS.branches.successDelete, type: "success" });
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
        title={APP_STRINGS.branches.title}
        description={APP_STRINGS.branches.subtitle}
        action={
          <Button onClick={() => openForm(null)} icon={<Plus size={18} />}>
            {APP_STRINGS.branches.addBtn}
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
                <th className="p-4">{APP_STRINGS.branches.tableHeaderName}</th>
                <th className="p-4">{APP_STRINGS.branches.tableHeaderAddress}</th>
                <th className="p-4">{APP_STRINGS.branches.tableHeaderGmaps}</th>
                <th className="p-4 text-right">{APP_STRINGS.branches.tableHeaderActions}</th>
              </tr>
            </thead>
            <tbody>
              {items.map((item) => (
                <tr key={item.id} className="border-b border-glass-border/50 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                  <td className="p-4 font-semibold flex items-center gap-3">
                    <img src={item.image_url} alt={item.name} className="w-8 h-8 rounded-full object-cover bg-glass-panel" />
                    {item.name}
                  </td>
                  <td className="p-4 text-foreground/75 truncate max-w-xs">{item.address}</td>
                  <td className="p-4">
                    {item.gmaps_link ? (
                      <a href={item.gmaps_link} target="_blank" rel="noreferrer" className="text-primary hover:underline flex items-center gap-1">
                        <MapPin size={14} /> Buka Maps
                      </a>
                    ) : (
                      <span className="text-foreground/40 text-xs">Belum ada</span>
                    )}
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

      <Modal isOpen={showModal} onClose={() => setShowModal(false)} title={selectedItem ? APP_STRINGS.branches.editTitle : APP_STRINGS.branches.addTitle}>
        <form onSubmit={handleSave} className="space-y-4">
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.nameLabel}</label>
            <input type="text" required value={name} onChange={(e) => setName(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" />
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.addressLabel}</label>
            <textarea required value={address} onChange={(e) => setAddress(e.target.value)} className="w-full p-3 rounded-xl border glass-input text-sm text-foreground h-20 resize-none focus:border-primary outline-none" />
          </div>
          <div className="flex gap-4">
            <div className="flex-1">
              <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.latLabel}</label>
              <input type="number" step="any" required value={latitude} onChange={(e) => setLatitude(parseFloat(e.target.value) || 0)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" />
            </div>
            <div className="flex-1">
              <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.lngLabel}</label>
              <input type="number" step="any" required value={longitude} onChange={(e) => setLongitude(parseFloat(e.target.value) || 0)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" />
            </div>
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.gmapsLabel}</label>
            <input type="url" value={gmapsLink} onChange={(e) => setGmapsLink(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder="https://maps.app.goo.gl/..." />
          </div>
          <div>
            <label className="block text-xs font-semibold mb-2">{APP_STRINGS.branches.imgLabel}</label>
            <input type="text" value={imageUrl} onChange={(e) => setImageUrl(e.target.value)} className="w-full h-10 px-3 rounded-xl border glass-input text-sm text-foreground focus:border-primary outline-none" placeholder="https://placehold.co/..." />
          </div>
          <div className="flex justify-end gap-2 pt-2">
            <Button type="button" variant="ghost" onClick={() => setShowModal(false)}>{APP_STRINGS.branches.cancelBtn}</Button>
            <Button type="submit" isLoading={saving}>{APP_STRINGS.branches.saveBtn}</Button>
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
