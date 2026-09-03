import { PromosFormModal } from "../PromosFormModal";
import { DeleteModal } from "@/components/DeleteModal";
import { PromoDetailView } from "../PromoDetailView";
import { CustomSnackbar } from "@/components/CustomSnackbar";
import { Promo } from "@/types/api";

interface PromosModalsProps {
  showModal: boolean;
  onCloseModal: () => void;
  editingPromo: Promo | null;
  loadPromos: () => void;
  deleteConfirm: { id: number; title: string } | null;
  onCloseDeleteConfirm: () => void;
  handleDelete: () => void;
  isDrawerOpen: boolean;
  onCloseDrawer: () => void;
  viewingPromo: Promo | null;
  toast: { isOpen: boolean; message: string; type: "success" | "error" };
  setToast: React.Dispatch<React.SetStateAction<{ isOpen: boolean; message: string; type: "success" | "error" }>>;
}

export function PromosModals({
  showModal, onCloseModal, editingPromo, loadPromos,
  deleteConfirm, onCloseDeleteConfirm, handleDelete,
  isDrawerOpen, onCloseDrawer, viewingPromo,
  toast, setToast,
}: PromosModalsProps) {
  return (
    <>
      <PromosFormModal isOpen={showModal} onClose={onCloseModal} promo={editingPromo} onSuccess={loadPromos} setToast={setToast} />
      <DeleteModal isOpen={!!deleteConfirm} onClose={onCloseDeleteConfirm} onConfirm={handleDelete} description={deleteConfirm?.title} />
      <PromoDetailView isOpen={isDrawerOpen} onClose={onCloseDrawer} promo={viewingPromo} />
      <CustomSnackbar isOpen={toast.isOpen} message={toast.message} type={toast.type} onClose={() => setToast((t) => ({ ...t, isOpen: false }))} />
    </>
  );
}
