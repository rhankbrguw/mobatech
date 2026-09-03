"use client";
import { usePromosClient } from "@/hooks/usePromosClient";
import { PageHeader } from "@/components/ui/PageHeader";
import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { Plus } from "lucide-react";
import { SearchFilterBar } from "@/components/ui/SearchFilterBar";
import { Pagination } from "@/components/ui/Pagination";
import { APP_STRINGS } from "@/constants";
import { PromosTable } from "./PromosTable";
import { PromosModals } from "./promos/PromosModals";

export function PromosClient() {
  const p = usePromosClient();

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader 
        title="Manajemen Promo" 
        description="Atur promo dan penawaran spesial untuk aplikasi pasien" 
        action={<Button onClick={() => { p.setEditingPromo(null); p.setShowModal(true); }} icon={<Plus size={18} />}>Tambah Promo</Button>} 
      />
      
      <div className="flex flex-col sm:flex-row sm:justify-end mb-4 gap-2">
        <SearchFilterBar value={p.searchQuery} onChange={p.setSearchQuery} placeholder={APP_STRINGS.promos.searchPlaceholder} className="w-full sm:max-w-sm" />
      </div>

      <Card noPadding>
        <div className="w-full overflow-x-auto">
          <PromosTable 
            promos={p.promos} 
            loading={p.loading} 
            onView={(promo) => { p.setViewingPromo(promo); p.setIsDrawerOpen(true); }} 
            onEdit={(promo) => { p.setEditingPromo(promo); p.setShowModal(true); }} 
            onDelete={(id, title) => p.setDeleteConfirm({ id, title })} 
          />
        </div>
      </Card>

      <Pagination currentPage={p.currentPage} totalPages={p.totalPages} onPageChange={p.setCurrentPage} />

      <PromosModals
        showModal={p.showModal}
        onCloseModal={() => p.setShowModal(false)}
        editingPromo={p.editingPromo}
        loadPromos={p.loadPromos}
        deleteConfirm={p.deleteConfirm}
        onCloseDeleteConfirm={() => p.setDeleteConfirm(null)}
        handleDelete={p.handleDelete}
        isDrawerOpen={p.isDrawerOpen}
        onCloseDrawer={() => p.setIsDrawerOpen(false)}
        viewingPromo={p.viewingPromo}
        toast={p.toast}
        setToast={p.setToast}
      />
    </div>
  );
}
