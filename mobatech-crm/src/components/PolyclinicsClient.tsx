"use client";
import { ForbiddenView } from "@/components/ui/ForbiddenView";
import { Pagination } from "@/components/ui/Pagination";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { SideDrawer } from "@/components/ui/SideDrawer";
import { PolyclinicsTable } from "./PolyclinicsTable";
import { PolyclinicsHeader } from "./PolyclinicsHeader";
import { PolyclinicsModals } from "./PolyclinicsModals";
import { usePolyclinicsLogic } from "@/hooks/usePolyclinicsLogic";

export function PolyclinicsClient({ initialData, searchParams }: { initialData?: unknown, searchParams?: Record<string, string | string[] | undefined> }) {
  const {
    role, items, loading, showModal, setShowModal, selectedItem,
    searchQuery, setSearchQuery, filterValue, setFilterValue,
    name, setName, description, setDescription, imageUrl, setImageUrl,
    isActive, setIsActive, saving, drawerItem, setDrawerItem,
    isDrawerOpen, setIsDrawerOpen, currentPage, setCurrentPage,
    totalPages, toast, setToast, deleteId, setDeleteId,
    openForm, handleSave, handleDelete
  } = usePolyclinicsLogic();

  if (!["admin"].includes(role)) {
    return <ForbiddenView />;
  }

  return (
    <div className="space-y-6 animate-slide-in">
      <PolyclinicsHeader
        openForm={() => openForm(null)}
        filterValue={filterValue}
        setFilterValue={setFilterValue}
        searchQuery={searchQuery}
        setSearchQuery={setSearchQuery}
      />
      <PolyclinicsTable
        items={items}
        loading={loading}
        onEdit={openForm}
        onDelete={setDeleteId}
        onViewDetails={(item) => { setDrawerItem(item); setIsDrawerOpen(true); }}
      />
      <Pagination currentPage={currentPage} totalPages={totalPages} onPageChange={setCurrentPage} />
      <PolyclinicsModals
        showModal={showModal} setShowModal={setShowModal}
        selectedItem={selectedItem} name={name} setName={setName}
        description={description} setDescription={setDescription}
        imageUrl={imageUrl} setImageUrl={setImageUrl}
        isActive={isActive} setIsActive={setIsActive}
        handleSave={handleSave} saving={saving}
        deleteId={deleteId} setDeleteId={setDeleteId}
        handleDelete={handleDelete}
      />
      <SideDrawer isOpen={isDrawerOpen} onClose={() => setIsDrawerOpen(false)} title="Detail Poliklinik">
        {drawerItem && (
          <div className="space-y-3">
            <div className="flex justify-center mb-4">
              {drawerItem.image_url ? (
                <img src={drawerItem.image_url} alt={drawerItem.name} className="w-24 h-24 rounded-xl object-cover shadow-lg border-2 border-primary-foreground/20" />
              ) : (
                <div className="w-24 h-24 rounded-xl bg-primary-foreground/10 flex items-center justify-center border-2 border-primary-foreground/20 shadow-lg text-3xl">🏥</div>
              )}
            </div>
            <div><strong>Nama:</strong> {drawerItem.name}</div>
            <div><strong>Deskripsi:</strong> {drawerItem.description}</div>
            <div><strong>Status:</strong> {drawerItem.is_active ? "Aktif" : "Non-Aktif"}</div>
          </div>
        )}
      </SideDrawer>
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </div>
  );
}
