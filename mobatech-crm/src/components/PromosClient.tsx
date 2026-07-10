"use client";
import { useState, useEffect } from "react";
import { api, ApiError } from "@/lib/api";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { Plus, Edit, Trash2, Eye } from "lucide-react";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { DeleteModal } from "@/components/DeleteModal";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { Pagination } from "@/components/ui/Pagination";
import { PromosFormModal } from "./PromosFormModal";
import { APP_STRINGS } from "@/lib/constants";
import { Promo } from "@/types/api";
import { ActionMenu } from "@/components/ui/ActionMenu";
import { PromoDetailView } from "./PromoDetailView";

import { PromosTable } from "./PromosTable";

export function PromosClient() {
  const [promos, setPromos] = useState<Promo[]>([]);
  const [loading, setLoading] = useState(true);
  const [deleteConfirm, setDeleteConfirm] = useState<{ id: number; title: string } | null>(null);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({ isOpen: false, message: "", type: "success" });
  
  const [searchQuery, setSearchQuery] = useState("");
  const [showModal, setShowModal] = useState(false);
  const [editingPromo, setEditingPromo] = useState<Promo | null>(null);
  const [viewingPromo, setViewingPromo] = useState<Promo | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);

  const loadPromos = async () => {
    try {
      setLoading(true);
      const queryParams = new URLSearchParams();
      queryParams.append("page", currentPage.toString());
      queryParams.append("limit", "10");
      if (searchQuery) queryParams.append("search", searchQuery);
      const qs = queryParams.toString() ? `?${queryParams.toString()}` : "";
      const res = await api.get<Promo[]>(`/api/admin/promos${qs}`);
      setPromos(res.data || []);
      if (res.meta) {
        setTotalPages(res.meta.total_pages);
      }
    } catch {
      setToast({ isOpen: true, message: APP_STRINGS.common.loadError, type: "error" });
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { setCurrentPage(1); }, [searchQuery]);
  useEffect(() => { loadPromos(); }, [searchQuery, currentPage]);

  const handleDelete = async () => {
    if (!deleteConfirm) return;
    try {
      await api.delete(`/api/admin/promos/${deleteConfirm.id}`);
      setToast({ isOpen: true, message: APP_STRINGS.common.deleteSuccess, type: "success" });
      loadPromos();
    } catch (err) {
      setToast({ isOpen: true, message: err instanceof ApiError ? err.message : APP_STRINGS.common.deleteError, type: "error" });
    } finally {
      setDeleteConfirm(null);
    }
  };

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader 
        title="Manajemen Promo" 
        description="Atur promo dan penawaran spesial untuk aplikasi pasien" 
        action={<Button onClick={() => { setEditingPromo(null); setShowModal(true); }} icon={<Plus size={18} />}>Tambah Promo</Button>} 
      />
      
      <div className="flex flex-col sm:flex-row sm:justify-end mb-4 gap-2">
        <SearchFilterBar value={searchQuery} onChange={setSearchQuery} placeholder={APP_STRINGS.promos.searchPlaceholder} className="w-full sm:max-w-sm" />
      </div>

      <Card noPadding>
        <div className="w-full overflow-x-auto">
          <PromosTable 
            promos={promos} 
            loading={loading} 
            onView={(p) => { setViewingPromo(p); setIsDrawerOpen(true); }} 
            onEdit={(p) => { setEditingPromo(p); setShowModal(true); }} 
            onDelete={(id, title) => setDeleteConfirm({ id, title })} 
          />
        </div>
      </Card>
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      <PromosFormModal isOpen={showModal} onClose={() => setShowModal(false)} promo={editingPromo} onSuccess={loadPromos} setToast={setToast} />
      <DeleteModal isOpen={!!deleteConfirm} onClose={() => setDeleteConfirm(null)} onConfirm={handleDelete} description={deleteConfirm?.title} />
      <PromoDetailView isOpen={isDrawerOpen} onClose={() => setIsDrawerOpen(false)} promo={viewingPromo} />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
