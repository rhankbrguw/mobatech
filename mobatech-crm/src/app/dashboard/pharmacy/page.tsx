"use client";

import { useState, useEffect, useCallback } from "react";
import { api } from "@/lib/api";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { PageHeader } from "@/components/ui/PageHeader";
import { Card } from "@/components/ui/Card";
import { DeleteModal } from "@/components/DeleteModal";
import { Badge, BadgeVariant } from "@/components/ui/Badge";
import { Package, Pill, Tags, Baby, Activity, HeartPulse, Syringe, Cross, Plus, Edit, Trash2, X } from "lucide-react";

const getCategoryIcon = (iconName: string) => {
  switch (iconName?.toLowerCase()) {
    case "pill": return <Pill className="w-6 h-6" />;
    case "vitamin": return <Activity className="w-6 h-6" />;
    case "baby": return <Baby className="w-6 h-6" />;
    case "first_aid": return <HeartPulse className="w-6 h-6" />;
    case "injection": return <Syringe className="w-6 h-6" />;
    case "medical_cross": return <Cross className="w-6 h-6" />;
    default: return <Tags className="w-6 h-6" />;
  }
};
interface MedicineCategory { id: number; name: string; description: string; icon: string; }
interface Medicine { id: number; name: string; generic_name: string; price: number; stock: number; requires_prescription: boolean; dosage: string; unit: string; manufacturer: string; category_id?: number; category?: MedicineCategory; image_url?: string; }
interface OrderItem { id: number; medicine_id: number; medicine: Medicine; quantity: number; price: number; subtotal: number; }
interface PharmacyOrder { id: number; created_at: string; order_number: string; user_id: number; status: string; total_price: number; payment_method: string; payment_status: string; pickup_method: string; delivery_address: string; notes: string; items: OrderItem[]; }
interface Prescription { id: number; created_at: string; user_id: number; image_url: string; notes: string; status: string; }

const ORDER_STATUSES = ["Pending", "Verifying", "Processing", "Ready", "Completed", "Cancelled"];
const PAYMENT_STATUSES = ["Unpaid", "Paid", "Refunded"];
const ICON_OPTIONS = ["pill", "vitamin", "baby", "first_aid", "injection", "medical_cross", "tags"];

type Tab = "orders" | "medicines" | "categories" | "prescriptions";

function StatusBadge({ value, type }: { value: string; type: "order" | "payment" }) {
  let variant: BadgeVariant = "neutral";
  if (value === "Completed" || value === "Paid") variant = "success";
  else if (value === "Pending" || value === "Unpaid") variant = "warning";
  else if (value === "Cancelled" || value === "Refunded") variant = "error";
  else if (value === "Processing" || value === "Verifying" || value === "Ready") variant = "info";

  return <Badge variant={variant}>{value}</Badge>;
}

export default function PharmacyPage() {
  const [tab, setTab] = useState<Tab>("orders");
  const [orders, setOrders] = useState<PharmacyOrder[]>([]);
  const [medicines, setMedicines] = useState<Medicine[]>([]);
  const [categories, setCategories] = useState<MedicineCategory[]>([]);
  const [prescriptions, setPrescriptions] = useState<Prescription[]>([]);
  const [loading, setLoading] = useState(false);
  const [expandedOrder, setExpandedOrder] = useState<number | null>(null);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({ isOpen: false, message: "", type: "success" });

  const [isCategoryModalOpen, setIsCategoryModalOpen] = useState(false);
  const [editingCategory, setEditingCategory] = useState<Partial<MedicineCategory> | null>(null);

  const [isMedicineModalOpen, setIsMedicineModalOpen] = useState(false);
  const [editingMedicine, setEditingMedicine] = useState<Partial<Medicine> | null>(null);

  const [deleteConfirm, setDeleteConfirm] = useState<{ isOpen: boolean; type: "medicine" | "category" | "prescription"; id: number; title: string } | null>(null);
  const [selectedImage, setSelectedImage] = useState<string | null>(null);

  const showToast = (message: string, type: "success" | "error") => setToast({ isOpen: true, message, type });

  const loadOrders = useCallback(async (silent = false) => {
    if (!silent) setLoading(true);
    try {
      const res = await api.get<PharmacyOrder[]>("/api/admin/pharmacy/orders");
      setOrders(res.data || []);
    } catch { if (!silent) showToast("Gagal memuat data order", "error"); }
    finally { if (!silent) setLoading(false); }
  }, []);

  const loadMedicines = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get<Medicine[]>("/api/pharmacy/medicines");
      setMedicines(res.data || []);
    } catch { showToast("Gagal memuat data obat", "error"); }
    finally { setLoading(false); }
  }, []);

  const loadCategories = useCallback(async () => {
    setLoading(true);
    try {
      const res = await api.get<MedicineCategory[]>("/api/pharmacy/categories");
      setCategories(res.data || []);
    } catch { showToast("Gagal memuat kategori", "error"); }
    finally { setLoading(false); }
  }, []);

  const loadPrescriptions = useCallback(async (silent = false) => {
    if (!silent) setLoading(true);
    try {
      const res = await api.get<Prescription[]>("/api/admin/pharmacy/prescriptions");
      setPrescriptions(res.data || []);
    } catch { if (!silent) showToast("Gagal memuat resep", "error"); }
    finally { if (!silent) setLoading(false); }
  }, []);

  useEffect(() => {
    if (tab === "orders") {
      loadOrders();
      const interval = setInterval(() => loadOrders(true), 5000);
      return () => clearInterval(interval);
    } else if (tab === "medicines") {
      loadMedicines();
      if (categories.length === 0) loadCategories();
    } else if (tab === "prescriptions") {
      loadPrescriptions();
      const interval = setInterval(() => loadPrescriptions(true), 5000);
      return () => clearInterval(interval);
    } else {
      loadCategories();
    }
  }, [tab, loadOrders, loadMedicines, loadCategories, loadPrescriptions]);

  const handleUpdateStatus = async (id: number, status: string) => {
    try {
      await api.put(`/api/admin/pharmacy/orders/${id}/status`, { status });
      showToast("Status order diperbarui", "success");
      loadOrders(true);
    } catch { showToast("Gagal memperbarui status", "error"); }
  };

  const handleUpdatePayment = async (id: number, payment_status: string) => {
    try {
      await api.put(`/api/admin/pharmacy/orders/${id}/payment`, { payment_status });
      showToast("Status pembayaran diperbarui", "success");
      loadOrders(true);
    } catch { showToast("Gagal memperbarui pembayaran", "error"); }
  };

  const handleUpdatePrescriptionStatus = async (id: number, status: string) => {
    try {
      await api.put(`/api/admin/pharmacy/prescriptions/${id}/status`, { status });
      showToast("Status resep diperbarui", "success");
      loadPrescriptions();
    } catch { showToast("Gagal memperbarui resep", "error"); }
  };

  const handleImageUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    if (!e.target.files || e.target.files.length === 0) return;
    const file = e.target.files[0];
    const formData = new FormData();
    formData.append("file", file);
    try {
      setLoading(true);
      const res = await fetch("http://127.0.0.1:8080/api/upload", {
        method: "POST",
        body: formData,
      });
      const data = await res.json();
      if (res.ok) {
        setEditingMedicine((prev) => ({ ...prev, image_url: data.url }));
        showToast("Gambar berhasil diunggah", "success");
      } else {
        showToast(data.error || "Gagal mengunggah", "error");
      }
    } catch {
      showToast("Gagal mengunggah gambar", "error");
    } finally {
      setLoading(false);
    }
  };

  const handleSaveCategory = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingCategory?.id) {
        await api.put(`/api/admin/pharmacy/categories/${editingCategory.id}`, editingCategory);
        showToast("Kategori diperbarui", "success");
      } else {
        await api.post(`/api/admin/pharmacy/categories`, editingCategory);
        showToast("Kategori ditambahkan", "success");
      }
      setIsCategoryModalOpen(false);
      loadCategories();
    } catch { showToast("Gagal menyimpan kategori", "error"); }
  };

  const handleSaveMedicine = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (editingMedicine?.id) {
        await api.put(`/api/admin/pharmacy/medicines/${editingMedicine.id}`, editingMedicine);
        showToast("Obat diperbarui", "success");
      } else {
        await api.post(`/api/admin/pharmacy/medicines`, editingMedicine);
        showToast("Obat ditambahkan", "success");
      }
      setIsMedicineModalOpen(false);
      loadMedicines();
    } catch { showToast("Gagal menyimpan obat", "error"); }
  };

  const confirmDeleteCategory = (id: number, name: string) => {
    setDeleteConfirm({ isOpen: true, type: "category", id, title: `Apakah Anda yakin ingin menghapus kategori "${name}"?` });
  };

  const confirmDeleteMedicine = (id: number, name: string) => {
    setDeleteConfirm({ isOpen: true, type: "medicine", id, title: `Apakah Anda yakin ingin menghapus obat "${name}"?` });
  };

  const confirmDeletePrescription = (id: number) => {
    setDeleteConfirm({ isOpen: true, type: "prescription", id, title: `Apakah Anda yakin ingin menghapus E-Resep #${id}?` });
  };

  const executeDelete = async () => {
    if (!deleteConfirm) return;
    try {
      if (deleteConfirm.type === "category") {
        await api.delete(`/api/admin/pharmacy/categories/${deleteConfirm.id}`);
        showToast("Kategori dihapus", "success");
        loadCategories();
      } else if (deleteConfirm.type === "prescription") {
        await api.delete(`/api/admin/pharmacy/prescriptions/${deleteConfirm.id}`);
        showToast("E-Resep dihapus", "success");
        loadPrescriptions();
      } else {
        await api.delete(`/api/admin/pharmacy/medicines/${deleteConfirm.id}`);
        showToast("Obat dihapus", "success");
        loadMedicines();
      }
    } catch { showToast("Gagal menghapus data", "error"); }
    finally { setDeleteConfirm(null); }
  };

  const tabs: { key: Tab; label: string; icon: React.ReactNode }[] = [
    { key: "orders", label: "Order Masuk", icon: <Package size={16} /> },
    { key: "prescriptions", label: "E-Resep Masuk", icon: <HeartPulse size={16} /> },
    { key: "medicines", label: "Daftar Obat", icon: <Pill size={16} /> },
    { key: "categories", label: "Kategori", icon: <Tags size={16} /> },
  ];

  return (
    <>
      <div className="space-y-6 animate-slide-in relative">
        <PageHeader
          title="Manajemen Apotek"
          description="Kelola order obat, stok, dan kategori produk apotek."
        />

        <div className="flex justify-between items-center border-b border-glass-border flex-wrap gap-2">
        <div className="flex gap-2">
          {tabs.map((t) => (
            <button key={t.key} onClick={() => setTab(t.key)}
              className={`flex items-center gap-2 px-4 py-2.5 text-sm font-medium border-b-2 transition-colors -mb-px cursor-pointer ${tab === t.key ? "border-primary text-primary" : "border-transparent text-foreground/60 hover:text-foreground"}`}>
              <span>{t.icon}</span>{t.label}
            </button>
          ))}
        </div>
        {tab === "medicines" && (
          <button onClick={() => { setEditingMedicine({ requires_prescription: false }); setIsMedicineModalOpen(true); }} className="flex items-center gap-2 px-3 py-1.5 text-sm font-semibold bg-primary text-white rounded-lg hover:bg-primary/90 mb-2">
            <Plus size={16} /> Tambah Obat
          </button>
        )}
        {tab === "categories" && (
          <button onClick={() => { setEditingCategory({}); setIsCategoryModalOpen(true); }} className="flex items-center gap-2 px-3 py-1.5 text-sm font-semibold bg-primary text-white rounded-lg hover:bg-primary/90 mb-2">
            <Plus size={16} /> Tambah Kategori
          </button>
        )}
      </div>

      {loading ? (
        <div className="p-8 text-center text-foreground/50 animate-pulse text-sm">Memuat data...</div>
      ) : tab === "orders" ? (
        <Card noPadding>
          {orders.length === 0 ? (
            <div className="p-10 text-center text-foreground/50 text-sm">Belum ada order masuk.</div>
          ) : (
            <div className="divide-y divide-glass-border">
              {orders.map((order) => (
                <div key={order.id}>
                  <div className="p-4 flex flex-col sm:flex-row sm:items-center gap-3 cursor-pointer hover:bg-black/5 dark:hover:bg-white/5 transition-colors"
                    onClick={() => setExpandedOrder(expandedOrder === order.id ? null : order.id)}>
                    <div className="flex-1">
                      <div className="font-semibold text-sm">{order.order_number}</div>
                      <div className="text-xs text-foreground/50 mt-0.5">
                        User #{order.user_id} • {new Date(order.created_at).toLocaleDateString("id-ID")} • {order.pickup_method}
                      </div>
                    </div>
                    <div className="flex items-center gap-2 flex-wrap">
                      <StatusBadge value={order.status} type="order" />
                      <StatusBadge value={order.payment_status} type="payment" />
                      <span className="text-sm font-semibold">Rp {order.total_price.toLocaleString("id-ID")}</span>
                    </div>
                  </div>
                  {expandedOrder === order.id && (
                    <div className="px-4 pb-4 bg-black/5 dark:bg-white/5 space-y-3 pt-2">
                      <div className="text-xs text-foreground/50 font-semibold uppercase tracking-wider">Item Pesanan</div>
                      {order.items?.map((item) => (
                        <div key={item.id} className="flex justify-between text-sm">
                          <span>{item.medicine?.name ?? `Obat #${item.medicine_id}`} × {item.quantity}</span>
                          <span className="font-medium">Rp {item.subtotal?.toLocaleString("id-ID")}</span>
                        </div>
                      ))}
                      {order.delivery_address && <div className="text-xs text-foreground/60"><span className="font-medium">Alamat:</span> {order.delivery_address}</div>}
                      {order.notes && <div className="text-xs text-foreground/60"><span className="font-medium">Catatan:</span> {order.notes}</div>}
                      
                      <div className="flex gap-4 pt-3 mt-2 border-t border-glass-border flex-wrap">
                        <div className="flex flex-col gap-1.5">
                          <span className="text-xs font-semibold text-foreground/70">Status Order</span>
                          <select value={order.status} onChange={(e) => handleUpdateStatus(order.id, e.target.value)}
                            className="text-sm border border-glass-border rounded-lg px-3 py-1.5 bg-background glass-input cursor-pointer outline-none focus:border-primary">
                            {ORDER_STATUSES.map((s) => <option key={s}>{s}</option>)}
                          </select>
                        </div>
                        <div className="flex flex-col gap-1.5">
                          <span className="text-xs font-semibold text-foreground/70">Status Pembayaran</span>
                          <select value={order.payment_status} onChange={(e) => handleUpdatePayment(order.id, e.target.value)}
                            className="text-sm border border-glass-border rounded-lg px-3 py-1.5 bg-background glass-input cursor-pointer outline-none focus:border-primary">
                            {PAYMENT_STATUSES.map((s) => <option key={s}>{s}</option>)}
                          </select>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              ))}
            </div>
          )}
        </Card>
      ) : tab === "medicines" ? (
        <Card noPadding className="overflow-x-auto">
          <table className="w-full text-left border-collapse text-sm">
            <thead>
              <tr className="border-b border-glass-border bg-black/5 dark:bg-white/5 font-semibold">
                <th className="p-4">Nama Obat</th>
                <th className="p-4">Kategori</th>
                <th className="p-4">Harga</th>
                <th className="p-4">Stok</th>
                <th className="p-4">Resep</th>
                <th className="p-4">Aksi</th>
              </tr>
            </thead>
            <tbody>
              {medicines.length === 0 ? (
                <tr><td colSpan={6} className="p-8 text-center text-foreground/50">Belum ada obat terdaftar.</td></tr>
              ) : medicines.map((m) => (
                <tr key={m.id} className="border-b border-glass-border/50 hover:bg-black/5 dark:hover:bg-white/5 transition-colors">
                  <td className="p-4">
                    <div className="font-semibold">{m.name}</div>
                    <div className="text-xs text-foreground/50">{m.generic_name} • {m.dosage} {m.unit}</div>
                  </td>
                  <td className="p-4 text-foreground/70">{m.category?.name ?? "-"}</td>
                  <td className="p-4 font-medium">Rp {m.price?.toLocaleString("id-ID")}</td>
                  <td className="p-4">
                    <Badge variant={m.stock <= 10 ? "error" : "success"}>
                      {m.stock}
                    </Badge>
                  </td>
                  <td className="p-4">
                    <Badge variant={m.requires_prescription ? "warning" : "neutral"}>
                      {m.requires_prescription ? "Wajib Resep" : "Bebas"}
                    </Badge>
                  </td>
                  <td className="p-4 flex gap-2">
                    <button onClick={() => { setEditingMedicine({ ...m, category_id: m.category?.id }); setIsMedicineModalOpen(true); }} className="text-info hover:text-info/80"><Edit size={16} /></button>
                    <button onClick={() => confirmDeleteMedicine(m.id, m.name)} className="text-error hover:text-error/80"><Trash2 size={16} /></button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </Card>
      ) : tab === "prescriptions" ? (
        <Card noPadding>
          {prescriptions.length === 0 ? (
            <div className="p-10 text-center text-foreground/50 text-sm">Belum ada resep masuk.</div>
          ) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4 p-4 bg-background/50">
              {prescriptions.map((p) => (
                <Card key={p.id} className="flex flex-col gap-3 hover:shadow-md transition-shadow">
                  <div className="flex justify-between items-center">
                    <span className="text-xs font-semibold text-foreground/50">
                      Resep #{p.id} • {new Date(p.created_at).toLocaleDateString("id-ID")}
                    </span>
                    <Badge variant={p.status === "Pending" ? "warning" : p.status === "Processed" ? "info" : "error"}>{p.status}</Badge>
                  </div>
                  <div className="w-full h-40 bg-black/5 dark:bg-white/5 rounded-lg overflow-hidden border border-glass-border">
                    {p.image_url ? (
                      <div onClick={() => setSelectedImage(p.image_url)} className="cursor-pointer w-full h-full">
                        <img src={p.image_url} alt="Resep" className="w-full h-full object-cover hover:scale-105 transition-transform" />
                      </div>
                    ) : (
                      <div className="flex h-full items-center justify-center text-foreground/40"><HeartPulse size={32} /></div>
                    )}
                  </div>
                  <p className="text-sm line-clamp-2">{p.notes || "Tidak ada catatan."}</p>
                  <div className="pt-3 border-t border-glass-border mt-auto flex gap-2">
                    <select
                      value={p.status}
                      onChange={(e) => handleUpdatePrescriptionStatus(p.id, e.target.value)}
                      className="w-full text-sm border border-glass-border rounded-lg px-2 py-1.5 bg-background glass-input outline-none focus:border-primary cursor-pointer font-medium"
                    >
                      <option value="Pending">Pending</option>
                      <option value="Processed">Processed</option>
                      <option value="Rejected">Rejected</option>
                    </select>
                    <button onClick={() => confirmDeletePrescription(p.id)} className="p-2 text-error hover:bg-error/10 rounded-lg transition-colors border border-glass-border glass-input">
                      <Trash2 size={18} />
                    </button>
                  </div>
                </Card>
              ))}
            </div>
          )}
        </Card>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
          {categories.length === 0 ? (
            <Card className="col-span-3 p-8 text-center text-foreground/50">Belum ada kategori.</Card>
          ) : categories.map((cat) => (
            <Card key={cat.id} className="flex items-center justify-between gap-4 hover:shadow-md transition-shadow">
              <div className="flex items-center gap-4">
                <div className="w-12 h-12 rounded-xl bg-primary/10 flex items-center justify-center text-primary border border-primary/20">
                  {getCategoryIcon(cat.icon)}
                </div>
                <div>
                  <div className="font-semibold">{cat.name}</div>
                  <div className="text-xs text-foreground/60 mt-1">{cat.description || "-"}</div>
                </div>
              </div>
              <div className="flex gap-2">
                <button onClick={() => { setEditingCategory(cat); setIsCategoryModalOpen(true); }} className="text-info hover:text-info/80"><Edit size={16} /></button>
                <button onClick={() => confirmDeleteCategory(cat.id, cat.name)} className="text-error hover:text-error/80"><Trash2 size={16} /></button>
              </div>
            </Card>
          ))}
        </div>
      )}
      </div>

      {/* CATEGORY MODAL */}
      {isCategoryModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
          <Card className="w-full max-w-md shadow-2xl">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-bold">{editingCategory?.id ? "Edit Kategori" : "Tambah Kategori"}</h2>
              <button onClick={() => setIsCategoryModalOpen(false)} className="text-foreground/50 hover:text-foreground"><X size={20} /></button>
            </div>
            <form onSubmit={handleSaveCategory} className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Nama Kategori</label>
                <input required type="text" value={editingCategory?.name || ""} onChange={(e) => setEditingCategory({ ...editingCategory, name: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Deskripsi</label>
                <textarea rows={3} value={editingCategory?.description || ""} onChange={(e) => setEditingCategory({ ...editingCategory, description: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm"></textarea>
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Ikon</label>
                <select value={editingCategory?.icon || "tags"} onChange={(e) => setEditingCategory({ ...editingCategory, icon: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm cursor-pointer">
                  {ICON_OPTIONS.map((i) => <option key={i} value={i}>{i}</option>)}
                </select>
              </div>
              <div className="pt-4 flex justify-end gap-2 border-t border-glass-border">
                <button type="button" onClick={() => setIsCategoryModalOpen(false)} className="px-4 py-2 text-sm font-semibold hover:bg-black/5 dark:hover:bg-white/5 rounded-lg">Batal</button>
                <button type="submit" className="px-4 py-2 text-sm font-semibold bg-primary text-white rounded-lg hover:bg-primary/90">Simpan</button>
              </div>
            </form>
          </Card>
        </div>
      )}

      {/* MEDICINE MODAL */}
      {isMedicineModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
          <Card className="w-full max-w-2xl shadow-2xl max-h-[90vh] overflow-y-auto">
            <div className="flex justify-between items-center mb-4">
              <h2 className="text-lg font-bold">{editingMedicine?.id ? "Edit Obat" : "Tambah Obat"}</h2>
              <button onClick={() => setIsMedicineModalOpen(false)} className="text-foreground/50 hover:text-foreground"><X size={20} /></button>
            </div>
            <form onSubmit={handleSaveMedicine} className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div className="sm:col-span-2 border border-glass-border rounded-xl p-4 bg-background/50">
                <label className="block text-xs font-semibold text-foreground/70 mb-3">Foto Obat</label>
                <div className="flex items-center gap-4">
                  {editingMedicine?.image_url ? (
                    <img src={editingMedicine.image_url} alt="Obat" className="w-16 h-16 object-cover rounded-lg shadow-sm border border-glass-border" />
                  ) : (
                    <div className="w-16 h-16 bg-primary/10 rounded-lg flex items-center justify-center text-primary shadow-sm">
                      <Package size={24} />
                    </div>
                  )}
                  <input type="file" accept="image/*" onChange={handleImageUpload} className="text-sm text-foreground/70 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-semibold file:bg-primary/10 file:text-primary hover:file:bg-primary/20 cursor-pointer" />
                </div>
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Nama Obat</label>
                <input required type="text" value={editingMedicine?.name || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, name: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Nama Generik</label>
                <input required type="text" value={editingMedicine?.generic_name || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, generic_name: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Kategori</label>
                <select required value={editingMedicine?.category_id || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, category_id: parseInt(e.target.value) })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm cursor-pointer">
                  <option value="">Pilih Kategori</option>
                  {categories.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Pabrikan</label>
                <input required type="text" value={editingMedicine?.manufacturer || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, manufacturer: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Harga (Rp)</label>
                <input required type="number" value={editingMedicine?.price || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, price: parseFloat(e.target.value) })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Stok</label>
                <input required type="number" value={editingMedicine?.stock || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, stock: parseInt(e.target.value) })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Dosis (cth: 500mg)</label>
                <input required type="text" value={editingMedicine?.dosage || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, dosage: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div>
                <label className="block text-xs font-semibold text-foreground/70 mb-1">Unit (cth: Strip, Botol)</label>
                <input required type="text" value={editingMedicine?.unit || ""} onChange={(e) => setEditingMedicine({ ...editingMedicine, unit: e.target.value })} className="w-full border border-glass-border rounded-lg px-3 py-2 bg-background glass-input outline-none focus:border-primary text-sm" />
              </div>
              <div className="sm:col-span-2 flex items-center gap-2 mt-2">
                <input type="checkbox" id="req_prescription" checked={editingMedicine?.requires_prescription || false} onChange={(e) => setEditingMedicine({ ...editingMedicine, requires_prescription: e.target.checked })} className="w-4 h-4 cursor-pointer" />
                <label htmlFor="req_prescription" className="text-sm font-semibold cursor-pointer">Wajib dengan Resep Dokter</label>
              </div>
              <div className="sm:col-span-2 pt-4 flex justify-end gap-2 border-t border-glass-border mt-2">
                <button type="button" onClick={() => setIsMedicineModalOpen(false)} className="px-4 py-2 text-sm font-semibold hover:bg-black/5 dark:hover:bg-white/5 rounded-lg">Batal</button>
                <button type="submit" className="px-4 py-2 text-sm font-semibold bg-primary text-white rounded-lg hover:bg-primary/90">Simpan</button>
              </div>
            </form>
          </Card>
        </div>
      )}

      {/* DELETE CONFIRMATION MODAL */}
      <DeleteModal
        isOpen={deleteConfirm?.isOpen || false}
        onClose={() => setDeleteConfirm(null)}
        onConfirm={executeDelete}
        description={deleteConfirm?.title}
      />

      {/* IMAGE PREVIEW MODAL */}
      {selectedImage && (
        <div className="fixed inset-0 z-[100] flex items-center justify-center bg-black/80 backdrop-blur-sm p-4" onClick={() => setSelectedImage(null)}>
          <div className="relative max-w-4xl max-h-screen w-full flex items-center justify-center" onClick={(e) => e.stopPropagation()}>
            <button 
              onClick={() => setSelectedImage(null)} 
              className="absolute -top-12 right-0 text-white hover:text-white/80 transition-colors"
            >
              <X size={32} />
            </button>
            <img src={selectedImage} alt="Detail Resep" className="max-w-full max-h-[90vh] object-contain rounded-lg shadow-2xl" />
          </div>
        </div>
      )}

      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </>
  );
}
