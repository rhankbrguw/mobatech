"use client";

import { useAuthStore } from "@/store/useAuthStore";
import { Medicine, MedicineCategory } from "@/types/api";
import { useState } from "react";
import { Plus } from "lucide-react";
import { usePharmacyMedicines } from "@/hooks/usePharmacyMedicines";
import { DeleteModal } from "@/components/DeleteModal";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { FilterDropdown } from "@/components/ui/FilterDropdown";
import { Pagination } from "@/components/ui/Pagination";
import { APP_STRINGS } from "@/constants";
import { Button } from "@/components/ui/Button";
import { MedicineFormModal } from "./MedicineFormModal";
import { CategoryFormModal } from "./CategoryFormModal";
import { MedicineDetailView } from "./MedicineDetailView";
import { PharmacyMedicinesTable } from "./PharmacyMedicinesTable";

export function PharmacyMedicines({ initialMedicines, categories }: { initialMedicines: Medicine[], categories: MedicineCategory[] }) {
  const role = useAuthStore((state) => state.user)?.role || "admin";
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isCategoryModalOpen, setIsCategoryModalOpen] = useState(false);
  const [editingMedicine, setEditingMedicine] = useState<Partial<Medicine> | null>(null);
  const [viewingMedicine, setViewingMedicine] = useState<Medicine | null>(null);
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [deleteConfirm, setDeleteConfirm] = useState<{ isOpen: boolean; id: number; title: string } | null>(null);
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedCategory, setSelectedCategory] = useState("");
  const [currentPage, setCurrentPage] = useState(1);
  const [toast, setToast] = useState<{isOpen: boolean; message: string; type: "success"|"error"}>({ isOpen: false, message: "", type: "success" });
  const { medicines, totalPages, localCategories, saveMedicineMutation, saveCategoryMutation, deleteMedicineMutation } = usePharmacyMedicines(
    currentPage,
    searchQuery,
    selectedCategory,
    initialMedicines,
    categories,
    setToast,
    setIsModalOpen,
    setIsCategoryModalOpen,
    setDeleteConfirm
  );

  const handleSaveMedicine = async (payload: Partial<Medicine>) => {
    saveMedicineMutation.mutate(payload);
  };



  const handleSaveCategory = async (payload: { name: string; description: string }) => {
    saveCategoryMutation.mutate(payload);
  };

  const confirmDelete = (id: number, name: string) => {
    setDeleteConfirm({ isOpen: true, id, title: `Hapus obat "${name}"?` });
  };



  const executeDelete = async () => {
    if (!deleteConfirm) return;
    deleteMedicineMutation.mutate(deleteConfirm.id);
  };

  const categoryOptions = [
    { label: "Semua Kategori", value: "" },
    ...localCategories.map((c) => ({ label: c.name, value: String(c.id) }))
  ];

  return (
    <>
      <div className="w-full flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-3 mb-4">
        <div className="flex flex-col sm:flex-row flex-1 gap-2">
          <FilterDropdown value={selectedCategory} onChange={setSelectedCategory} options={categoryOptions} placeholder={APP_STRINGS.common.searchFilter} className="w-full sm:w-64 h-11" />
          <SearchFilterBar value={searchQuery} onChange={setSearchQuery} className="w-full sm:max-w-sm h-11" />
        </div>
        <div className="flex gap-2" title={role === "admin" ? APP_STRINGS.common.clinicalOnly : undefined}>
          <Button variant="outline" onClick={() => setIsCategoryModalOpen(true)} disabled={role === "admin"} icon={<Plus size={16} />}>
            Kategori
          </Button>
          <Button onClick={() => { setEditingMedicine({ requires_prescription: false }); setIsModalOpen(true); }} disabled={role === "admin"} icon={<Plus size={16} />}>
            {APP_STRINGS.pharmacy.addMedicine}
          </Button>
        </div>
      </div>

      <PharmacyMedicinesTable
        medicines={medicines}
        role={role}
        onView={(m) => { setViewingMedicine(m); setIsDrawerOpen(true); }}
        onEdit={(m) => { setEditingMedicine(m); setIsModalOpen(true); }}
        onDelete={(id, name) => confirmDelete(id, name)}
      />
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />

      <MedicineFormModal
        isOpen={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        medicine={editingMedicine}
        categories={localCategories}
        onSave={handleSaveMedicine}
      />
      <CategoryFormModal
        isOpen={isCategoryModalOpen}
        onClose={() => setIsCategoryModalOpen(false)}
        onSave={handleSaveCategory}
      />
      <DeleteModal isOpen={deleteConfirm?.isOpen || false} onClose={() => setDeleteConfirm(null)} onConfirm={executeDelete} description={deleteConfirm?.title} />
      <MedicineDetailView isOpen={isDrawerOpen} onClose={() => setIsDrawerOpen(false)} medicine={viewingMedicine} />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </>
  );
}
