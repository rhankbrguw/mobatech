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
import { useAuthStore } from "@/store/useAuthStore";
import { ForbiddenView } from "@/components/ui/ForbiddenView";

export function PromosClient() {
  const p = usePromosClient();
  const user = useAuthStore((state) => state.user);
  const userRole = user?.role || "admin";

  if (userRole !== "admin") {
    return <ForbiddenView />;
  }

  return (
    <div className="space-y-6 animate-slide-in">
      <PageHeader 
        title={APP_STRINGS.promos.pageTitle} 
        description={APP_STRINGS.promos.pageSubtitle} 
        action={
          <Button onClick={() => { p.setEditingPromo(null); p.setShowModal(true); }} icon={<Plus size={16} className="sm:w-[18px] sm:h-[18px]" />}>
            <span className="sm:hidden">{APP_STRINGS.common.add}</span>
            <span className="hidden sm:inline">{APP_STRINGS.promos.addPromo}</span>
          </Button>
        } 
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
