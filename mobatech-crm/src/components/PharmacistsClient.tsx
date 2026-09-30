"use client";

import { useState, useEffect } from "react";
import { useQuery, useMutation, useQueryClient } from "@tanstack/react-query";
import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { Card } from "@/components/ui/Card";
import { Plus } from "lucide-react";
import { Pagination } from "@/components/ui/Pagination";
import { APP_STRINGS } from "@/constants";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/Button";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { DeleteModal } from "@/components/DeleteModal";
import { User } from "@/types/api";
import { pharmacistService } from "@/services";
import { PharmacistsTable } from "./PharmacistsTable";
import { PharmacistsHeaderControls } from "./pharmacists/PharmacistsHeaderControls";
import { PharmacistFormModal } from "./PharmacistFormModal";
import { PharmacistDetailDrawer } from "./PharmacistDetailDrawer";
import { PharmacistFormValues } from "@/schemas/pharmacist";

export function PharmacistsClient() {
  const role = useAuthStore((state) => state.user?.role) || "admin";
  const queryClient = useQueryClient();
  const [searchQuery, setSearchQuery] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [showModal, setShowModal] = useState(false);
  const [editingItem, setEditingItem] = useState<User | null>(null);
  const [viewingItem, setViewingItem] = useState<User | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState<{ id: number; title: string } | null>(null);
  const [toast, setToast] = useState<{ isOpen: boolean; message: string; type: "success" | "error" }>({
    isOpen: false, message: "", type: "success"
  });

  useEffect(() => { setCurrentPage(1); }, [searchQuery]);

  const qs = `?page=${currentPage}&limit=10${searchQuery ? `&search=${encodeURIComponent(searchQuery)}` : ""}`;
  const { data: resData, isLoading: loading } = useQuery({
    queryKey: ["pharmacists", currentPage, searchQuery],
    queryFn: () => pharmacistService.getPharmacists(qs),
    refetchInterval: 5000,
  });

  const pharmacists = resData?.data || [];
  const totalPages = resData?.meta?.total_pages || 1;

  const saveMutation = useMutation({
    mutationFn: async (payload: PharmacistFormValues & { role: string }) => {
      const pId = editingItem?.id || (editingItem as { ID?: number })?.ID;
      if (editingItem && pId) {
        await pharmacistService.updatePharmacist(pId, payload);
      } else {
        await pharmacistService.createPharmacist(payload);
      }
    },
    onSuccess: () => {
      setToast({ isOpen: true, message: editingItem ? APP_STRINGS.pharmacists.successUpdate : APP_STRINGS.pharmacists.successCreate, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["pharmacists"] });
      setShowModal(false);
    },
    onError: (err: Error) => setToast({ isOpen: true, message: err.message || APP_STRINGS.common.saveError, type: "error" })
  });

  const deleteMutation = useMutation({
    mutationFn: (id: number) => pharmacistService.deletePharmacist(id),
    onSuccess: () => {
      setToast({ isOpen: true, message: APP_STRINGS.pharmacists.successDelete, type: "success" });
      queryClient.invalidateQueries({ queryKey: ["pharmacists"] });
      setDeleteConfirm(null);
    },
    onError: (err: Error) => setToast({ isOpen: true, message: err.message || APP_STRINGS.common.deleteError, type: "error" })
  });

  if (role !== "admin") return <ForbiddenView />;

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader
        title={APP_STRINGS.pharmacists.title}
        description={APP_STRINGS.pharmacists.subtitle}
        action={
          <Button onClick={() => { setEditingItem(null); setShowModal(true); }} icon={<Plus size={16} className="sm:w-[18px] sm:h-[18px]" />}>
            <span className="sm:hidden">{APP_STRINGS.common.add}</span>
            <span className="hidden sm:inline">{APP_STRINGS.pharmacists.addBtn}</span>
          </Button>
        }
      />
      <PharmacistsHeaderControls searchQuery={searchQuery} onSearchQueryChange={setSearchQuery} />
      <Card noPadding>
        <PharmacistsTable
          pharmacists={pharmacists}
          loading={loading}
          onView={(p) => { setViewingItem(p); setIsDrawerOpen(true); }}
          onEdit={(p) => { setEditingItem(p); setShowModal(true); }}
          onDelete={(id, name) => setDeleteConfirm({ id, title: `Hapus apoteker "${name}"?` })}
        />
      </Card>
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      <PharmacistFormModal
        isOpen={showModal}
        onClose={() => setShowModal(false)}
        pharmacist={editingItem}
        onSave={async (data) => { await saveMutation.mutateAsync(data); }}
        showToast={(msg, type) => setToast({ isOpen: true, message: msg, type })}
      />
      <PharmacistDetailDrawer isOpen={isDrawerOpen} onClose={() => setIsDrawerOpen(false)} pharmacist={viewingItem} />
      <DeleteModal
        isOpen={!!deleteConfirm}
        onClose={() => setDeleteConfirm(null)}
        onConfirm={() => { if (deleteConfirm) deleteMutation.mutate(deleteConfirm.id); }}
        title={deleteConfirm?.title || APP_STRINGS.pharmacists.deleteConfirm}
        description={APP_STRINGS.pharmacists.deleteMessage}
      />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
